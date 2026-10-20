-- Live performance/cleanup regression. Uses only its own temporary files.
local d=assert(getgenv().WindUIForkDemo);local p=d.Presets;local w=d.Window;local c=d.Library.Creator;local f=w.FeatureUI
local n=0;local function check(v,m)n+=1;assert(v,'ConfigPerformance: '..m)end
local prior=p.Current;local names=w.ConfigManager:AllConfigs();local prefix='__perf_'..os.time();local temp=prefix..'_state';local stress=prefix..'_stress'
local loaded={};local heartbeat=0;local maxFrame=0;local run=game:GetService('RunService');local conn=run.Heartbeat:Connect(function(dt)heartbeat+=1;maxFrame=math.max(maxFrame,dt)end)
local function size(t)local a=0;for _ in pairs(t)do a+=1 end;return a end
local function dead()local a=0;for obj in pairs(c.Objects)do if not obj.Parent then a+=1 end end;return a end
local stats
local function test()
 check(p:Create(temp),'snapshot temporary preset')
 f:CloseAll();task.wait(.25)
 local render=f.AllRenderCount or 0
 for i=1,24 do
  local name=names[(i-1)%#names+1];local start=os.clock();check(p:Load(name),'existing preset loads')
  loaded[#loaded+1]=(os.clock()-start)*1000;task.wait(.02)
 end
 check((f.AllRenderCount or 0)==render,'closed All Hotkeys never rebuilt on config loads')
 check(not w.ConfigLoading and not f.Model.Suspended and not p.Loading,'all load guards released')
 task.wait(.3);check(dead()==0,'no destroyed objects retained by theme registry')
 local fonts,objects=size(c.FontObjects),size(c.Objects)
 local label=c.New('TextLabel',{Parent=w.UIElements.Main.Main,Text='cleanup probe',FontFace=Font.new(c.Font),ThemeTag={TextColor3='Text'}})
 check(size(c.FontObjects)==fonts+1,'new text registers only itself');label:Destroy();task.wait(.05)
 check(size(c.FontObjects)==fonts,'font registry cleaned on destroy');check(size(c.Objects)==objects,'theme registry cleaned on destroy')
 local config=w.ConfigManager:CreateConfig(stress)
 local mocks={}
 for i=1,100 do
  local obj={__type='Toggle',Value=false}
  function obj:Set(value)
   local t=os.clock();while os.clock()-t<.00015 do end
   self.Value=value
  end
  mocks[i]=obj;config:Register('stress_'..i,obj)
 end
 config:Save();for _,obj in ipairs(mocks)do obj.Value=true end
 local ticks=heartbeat;check(config:Load()~=false,'cooperative large config load');stats=config.LastLoadStats
 check(stats.Applied>=100,'stress callbacks applied');check(stats.Yields>0,'long load yields to frames');check(heartbeat>ticks,'game heartbeat continues during load')
 for _,obj in ipairs(mocks)do check(obj.Value==false,'stress value applied')end
 check(not w.ConfigLoading and not f.Model.Suspended,'batch state released after stress load')
 -- A failing parser must roll back values and release the batch.
 mocks[1].Value=true;local old=mocks[1].Set
 mocks[1].Set=function()error('intentional parser failure')end
 local ok=config:Load();mocks[1].Set=old
 check(ok==false,'parser error reported');check(not w.ConfigLoading and not f.Model.Suspended,'batch released on parser error')
 local records=config.Elements;for key in pairs(records)do if key:match('^stress_')then records[key]=nil end end
end
local ok,err=pcall(test);conn:Disconnect()
f:CloseAll();if isfile(w.ConfigManager.Path..temp..'.json')then p:Load(temp)end
for _,name in ipairs({temp,stress})do if isfile(w.ConfigManager.Path..name..'.json')then p:Delete(name)end end
if prior then p.Current=prior;p.UIElements.Trigger.Label.Text=prior;w.ConfigManager:GetConfig(prior):SetAsCurrent()end;p:Refresh()
task.wait(.3);table.sort(loaded)
assert(ok,err)
return{passed=n,loads=#loaded,loadMedianMs=math.floor(loaded[math.ceil(#loaded/2)]*100)/100,loadMaxMs=math.floor(loaded[#loaded]*100)/100,stress=stats,themeObjects=size(c.Objects),deadThemeObjects=dead(),fontObjects=size(c.FontObjects),heartbeatTicks=heartbeat,maxObservedFrameMs=math.floor(maxFrame*100000)/100}
