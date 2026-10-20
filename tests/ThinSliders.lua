-- Live full-menu regression; restores values and leaves the Player tab open.
local d=assert(getgenv().WindUIForkDemo)
local n=0
local function check(v,m)n+=1;assert(v,'ThinSliders: '..m)end
local old={big=d.Big:Get(),advanced=d.Advanced.Value,dependent=d.Dependent:Get()}
local function run()
 d.Player:Select();task.wait(.3)
 for _,slider in ipairs({d.Big,d.Billion,d.Fine,d.Gravity,d.Dependent})do
  check(slider.UIElements.HoverValue~=nil,'shared value popup')
  check(not slider.UIElements.SliderIcon.Frame.Thumb.Visible,'no bulky thumb')
  check(slider.UIElements.SliderIcon.Size.Y.Offset==4,'thin 4px track')
  check(slider.UIElements.ValueInput.Parent==slider.UIElements.SliderContainer,'value editor remains inline')
 end
 d.World:Select();task.wait(.2)
 check(d.Gravity.ElementFrame.Size.Y.Offset==d.Balance.ElementFrame.Size.Y.Offset,'matching slider/progress row heights')
 check(d.Collection.ElementFrame.Size.Y.Offset==44,'Collection is one compact row')
 check(d.Gravity.ElementFrame.RowDivider.Visible,'separator between visible rows')
 check(d.Balance.ElementFrame.RowDivider.Visible,'separator between progress rows')
 check(not d.Collection.ElementFrame.RowDivider.Visible,'no separator after final row')
 local previousSlot=d.Balance.ElementFrame.Parent
 d.Collection:SetVisible(false);task.wait(.7)
 check(not d.Balance.ElementFrame.RowDivider.Visible,'last visible row loses separator')
 d.Collection:SetVisible(true);task.wait(.7)
 check(d.Balance.ElementFrame.RowDivider.Visible,'separator restored when next row appears')
 for _,v in ipairs({d.Balance,d.Collection})do
  check(v.ElementFrame.ImageTransparency==1,'no nested round row plate')
  check(v.UIElements.Bar.Size.Y.Offset==4,'progress uses thin track')
  check(v.ProgressBarFrame.UIElements.Title.TextWrapped==false,'progress title never wraps')
 end
 d.Player:Select();task.wait(.2)
 local s=d.Big;local box=s.UIElements.ValueInput
 firesignal(s.UIElements.SliderContainer.MouseEnter);task.wait(.05)
 check(box.Visible,'inline value stays visible');check(not s.UIElements.HoverValue.Visible,'no popup on hover')
 firesignal(box.Focused);box.Text='1.25m';firesignal(box.FocusLost,true)
 check(s:Get()==1250000,'exact abbreviated input')
 firesignal(box.Focused);box.Text='invalid';firesignal(box.FocusLost,true)
 check(s:Get()==1250000,'invalid input preserves value')
 firesignal(box.Focused);box.Text='999999999999999';firesignal(box.FocusLost,true)
 check(s:Get()==s.Value.Max,'manual value clamps at maximum')
 firesignal(box.Focused);box.Text='-999999999999999';firesignal(box.FocusLost,true)
 check(s:Get()==s.Value.Min,'manual value clamps at minimum')
 check(box.AbsolutePosition.X>=s.UIElements.SliderIcon.AbsolutePosition.X+s.UIElements.SliderIcon.AbsoluteSize.X,'editor to the right of track')
 check(box.AbsolutePosition.X+box.AbsoluteSize.X<=s.ElementFrame.AbsolutePosition.X+s.ElementFrame.AbsoluteSize.X,'editor inside row bounds')
 firesignal(s.UIElements.SliderContainer.MouseLeave);firesignal(box.MouseLeave);task.wait(.15)
 check(box.Visible and not s.UIElements.HoverValue.Visible,'inline value remains but no hover popup')
 firesignal(s.UIElements.SliderContainer.MouseEnter);s:Lock()
 check(not s.UIElements.HoverValue.Visible and not box.TextEditable,'locked editor and no popup');s:Unlock()
 local track=s.UIElements.SliderIcon;local x,w,y=track.AbsolutePosition.X,track.AbsoluteSize.X,track.AbsolutePosition.Y
 local touch={UserInputType=Enum.UserInputType.Touch,Position=Vector3.new(x+w*.25,y,0)}
 firesignal(s.UIElements.SliderContainer.InputBegan,touch);task.wait(.08)
 local expected=s.Value.Min+.25*(s.Value.Max-s.Value.Min)
 check(math.abs(s:Get()-expected)<=s.Step,'touch ratio maps to value');check(s.UIElements.HoverValue.Visible,'popup during drag')
 check(math.abs(track.AbsoluteSize.X-w)<.1,'track geometry stays fixed')
 s:Lock();s:Unlock();check(not s.UIElements.HoverValue.Visible,'popup closes at end of drag')
 d.Pages:Select('enemies');task.wait(.2)
 local pages=d.Pages.Pages
 check(pages[1].Button.Parent==pages[2].Button.Parent,'subtabs share one background group')
 check(d.Pages.UIElements.Group.BackgroundTransparency<1,'shared group has visible background')
 check(pages[1].Button.BackgroundTransparency<pages[2].Button.BackgroundTransparency,'active subtab has separate highlight')
 d.Pages:Select('teammates');task.wait(.2)
 check(pages[2].Button.BackgroundTransparency<pages[1].Button.BackgroundTransparency,'highlight follows active subtab')
 d.Pages:Select('enemies')
 d.General:Select();d.Advanced:Set(false);task.wait(.7)
 check(d.DependencyGroup.Hidden and not d.DependencyGroup.VisibilityFrame.Visible,'toggle hides settings')
 check(not d.DependencyGroup.VisibilityFrame.Interactable,'hidden settings cannot interact')
 d.Dependent:Set(63);d.Advanced:Set(true);task.wait(.05)
 local mid=d.DependencyGroup.VisibilityFrame.GroupTransparency
 check(mid>0 and mid<1,'settings reveal is animated')
 task.wait(.65)
 check(not d.DependencyGroup.Hidden and d.DependencyGroup.VisibilityFrame.Visible,'toggle reveals settings')
 check(d.Dependent:Get()==63,'toggle preserves dependent values')
 d.Advanced:Set(false);task.wait(.05)
 check(d.DependencyGroup.VisibilityFrame.GroupTransparency>0,'settings hide is animated')
 task.wait(.65)
 check(d.DependencyGroup.VisibilityFrame.Size.Y.Offset<1,'hidden layout collapses')
end
local ok,err=pcall(run)
d.Big:Set(old.big);d.Advanced:Set(old.advanced);d.Dependent:Set(old.dependent);d.Player:Select()
assert(ok,err);return {passed=n}
