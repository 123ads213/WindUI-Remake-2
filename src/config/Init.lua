local cloneref = (cloneref or clonereference or function(instance) return instance end)


local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))

local Names=require("../modules/ConfigNames")
local Creator=require("../modules/Creator")
local Window 

local ConfigManager
ConfigManager = {
    Folder = nil,
    Path = nil,
    Configs = {},
    Parser = {
        Button = {
            Save = function(obj)return {__type=obj.__type}end,
            Load = function()end,
        },
        Colorpicker = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Default:ToHex(),
                    transparency = obj.Transparency or nil,
                    gradient = obj.Export and obj:Export() or nil,
                }
            end,
            Load = function(element, data)
                if element and element.Update then
                    if data.gradient and element.Import then
                        local ok,err=element:Import(data.gradient)
                        if not ok then error(err)end
                    else local ok,err=element:Update(Color3.fromHex(data.value), data.transparency or nil);if ok==false then error(err)end end
                    if element.Callback then Creator.SafeCallback(element.Callback,element.Default,element.Transparency,element.GetGradient and element:GetGradient())end
                end
            end
        },
        Dropdown = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element and element.Select then
                    element:Select(data.value)
                end
            end
        },
        Input = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value)
                end
            end
        },
        Slider = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value.Default,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(tonumber(data.value))
                end
            end
        },
        Toggle = {
            Save = function(obj)
                return {
                    __type = obj.__type,
                    value = obj.Value,
                }
            end,
            Load = function(element, data)
                if element and element.Set then
                    element:Set(data.value)
                end
            end
        },
    }
}

-- Extend existing records, retaining every legacy element value/parser.
for _,parser in pairs(ConfigManager.Parser)do
 local save,load=parser.Save,parser.Load
 parser.Save=function(element)
  local data=save(element)
  if element.GetHotkeys then data.hotkeys=element:GetHotkeys()end
  return data
 end
 parser.Load=function(element,data)
  local binds=element and element.SetHotkeys and data.hotkeys
  local entry=element and element.HotkeyEntry;local was=entry and entry.Suspended
  if entry then entry.Suspended=true end
  local ok,err=pcall(load,element,data)
  if ok and binds~=nil then element:SetHotkeys(binds)end
  if entry then entry.Suspended=was;if element.__HotkeyController then element.__HotkeyController.Model:Enforce(entry)end end
  if not ok then error(err)end
 end
end

function ConfigManager:Init(WindowTable)
    if not WindowTable.Folder then
        warn("[ WindUI.ConfigManager ] Window.Folder is not specified.")
        return false
    end
    if RunService:IsStudio() or type(writefile)~="function" or type(readfile)~="function" or type(isfile)~="function" or type(isfolder)~="function" or type(makefolder)~="function" then
        warn("[ WindUI.ConfigManager ] The config system doesn't work in the studio.")
        return false
    end
    
    Window = WindowTable
    ConfigManager.Folder = Window.Folder
    ConfigManager.Path = "WindUI/" .. tostring(ConfigManager.Folder) .. "/config/"
    
    if not isfolder(ConfigManager.Path) then
        makefolder(ConfigManager.Path)
    end
    
    return ConfigManager
end

function ConfigManager:SetPath(customPath)
    if not customPath then
        warn("[ WindUI.ConfigManager ] Custom path is not specified.")
        return false
    end
    
    ConfigManager.Path = customPath
    if not customPath:match("/$") then
        ConfigManager.Path = customPath .. "/"
    end
    
    if not isfolder(ConfigManager.Path) then
        makefolder(ConfigManager.Path)
    end
    
    return true
end

function ConfigManager:CreateConfig(configFilename, autoload)
    local valid,err=Names.Validate(configFilename);if not valid then return false,err end;configFilename=valid
    local ConfigModule = {
        Path = ConfigManager.Path .. configFilename .. ".json",
        Elements = {},
        CustomData = {},
        AutoLoad = autoload or false,
        Version = 1.3,
        Name = configFilename,
        Meta = {author=game:GetService("Players").LocalPlayer.Name,created=os.time(),modified=os.time()},
    }
    
    if not configFilename then
        return false, "No config file is selected"
    end
    
    function ConfigModule:SetAsCurrent()
        Window:SetCurrentConfig(ConfigModule)
    end
    
    function ConfigModule:Register(Name, Element)
        ConfigModule.Elements[Name] = Element
    end
    
    function ConfigModule:Set(key, value)
        ConfigModule.CustomData[key] = value
    end
    
    function ConfigModule:Get(key)
        return ConfigModule.CustomData[key]
    end
    
    function ConfigModule:SetAutoLoad(Value)
        ConfigModule.AutoLoad = Value
    end
    
    function ConfigModule:Save()
        if Window.PendingFlags then
            for flag, element in next, Window.PendingFlags do
                ConfigModule:Register(flag, element)
            end
        end
        
        local saveData = {
            __version = ConfigModule.Version,
            __elements = {},
            __autoload = ConfigModule.AutoLoad,
            __custom = ConfigModule.CustomData,
            __meta = ConfigModule.Meta
        }
        
        for name, element in next, ConfigModule.Elements do
            if ConfigManager.Parser[element.__type] then
                saveData.__elements[tostring(name)] = ConfigManager.Parser[element.__type].Save(element)
            end
        end
        
        if Window.HUD and not Window.HUD.Destroyed then saveData.__hud=Window.HUD:Export()end
        ConfigModule.Meta.modified=os.time()
        local jsonData = HttpService:JSONEncode(saveData)
        if writefile then 
            writefile(ConfigModule.Path, jsonData)
        end
        
        return saveData
    end
    
    function ConfigModule:Load()
        if isfile and not isfile(ConfigModule.Path) then 
            return false, "Config file does not exist" 
        end
        
        local success, loadData = pcall(function()
            local readfile = readfile or function() 
                warn("[ WindUI.ConfigManager ] The config system doesn't work in the studio.") 
                return nil 
            end
            return HttpService:JSONDecode(readfile(ConfigModule.Path))
        end)
        
        if not success or type(loadData)~="table" then
            return false, "Failed to parse config file"
        end
        
        if not loadData.__version then
            local migratedData = {
                __version = ConfigModule.Version,
                __elements = loadData,
                __custom = {}
            }
            loadData = migratedData
        end
        
        local valid,err=Names.ValidateData(loadData);if not valid then return false,err end
        if Window.PendingFlags then
            for flag, element in next, Window.PendingFlags do
                ConfigModule:Register(flag, element)
            end
        end
        
        if Window.ConfigLoading then return false,'A config is already loading'end
        local started=os.clock();local budgetStarted=started
        local stats={Applied=0,Skipped=0,Yields=0,DurationMs=0}
        local function budget()
            if os.clock()-budgetStarted>=.003 then
                RunService.Heartbeat:Wait();budgetStarted=os.clock();stats.Yields+=1
            end
        end
        local function same(a,b)
            if type(a)~=type(b)then return false end
            if type(a)~='table'then return a==b end
            for k,v in pairs(a)do if not same(v,b[k])then return false end end
            for k in pairs(b)do if a[k]==nil then return false end end
            return true
        end
        local backup,work={},{}
        for name,data in pairs(loadData.__elements)do
            local element=ConfigModule.Elements[name]
            if element then
                if element.__type~=data.__type then return false,'Element type mismatch: '..name end
                local parser=ConfigManager.Parser[element.__type]
                if parser then
                    local old=parser.Save(element)
                    if same(old,data)then stats.Skipped+=1 else backup[name]=old;work[#work+1]={Name=name,Data=data,Element=element,Parser=parser}end
                end
            end
            budget()
        end
        Window.ConfigLoading=true
        if Window.FeatureUI then Window.FeatureUI:BeginConfigBatch()end
        local applied={}
        local ok,message=pcall(function()
            for _,item in ipairs(work)do
                applied[#applied+1]=item
                local good,err=pcall(item.Parser.Load,item.Element,item.Data)
                if not good then error('Failed to load '..item.Name..': '..tostring(err),0)end
                stats.Applied+=1;budget()
            end
            if loadData.__hud and Window.HUD and not Window.HUD.Destroyed then
                local good,err=Window.HUD:Import(loadData.__hud)
                if good==false then error(err or 'Invalid HUD config',0)end
            end
        end)
        if not ok then
            for i=#applied,1,-1 do
                local item=applied[i];pcall(item.Parser.Load,item.Element,backup[item.Name]);budget()
            end
        end
        Window.ConfigLoading=false
        if Window.FeatureUI then Window.FeatureUI:EndConfigBatch()end
        stats.DurationMs=math.floor((os.clock()-started)*100000)/100;ConfigModule.LastLoadStats=stats;Window.LastConfigLoadStats=stats
        if not ok then return false,tostring(message)end

        ConfigModule.CustomData = loadData.__custom or {}
        ConfigModule.Meta = loadData.__meta or ConfigModule.Meta
        
        return ConfigModule.CustomData
    end
    
    function ConfigModule:Delete()
        if not delfile then
            return false, "delfile function is not available"
        end
        
        if not isfile(ConfigModule.Path) then
            return false, "Config file does not exist"
        end
        
        local success, err = pcall(function()
            delfile(ConfigModule.Path)
        end)
        
        if not success then
            return false, "Failed to delete config file: " .. tostring(err)
        end
        
        ConfigManager.Configs[configFilename] = nil
        
        if Window.CurrentConfig == ConfigModule then
            Window.CurrentConfig = nil
        end
        
        return true, "Config deleted successfully"
    end
    
    function ConfigModule:GetData()
        return {
            elements = ConfigModule.Elements,
            custom = ConfigModule.CustomData,
            autoload = ConfigModule.AutoLoad
        }
    end
    
    
    if isfile(ConfigModule.Path) then
        local success, configData = pcall(function()
            return HttpService:JSONDecode(readfile(ConfigModule.Path))
        end)
        
        if success and configData and configData.__autoload then
            ConfigModule.AutoLoad = true
            
            task.spawn(function()
                task.wait(0.5)
                local success, result = pcall(function()
                    return ConfigModule:Load()
                end)
                if success then
                    if Window.Debug then print("[ WindUI.ConfigManager ] AutoLoaded config: " .. configFilename) end
                else
                    warn("[ WindUI.ConfigManager ] Failed to AutoLoad config: " .. configFilename .. " - " .. tostring(result))
                end
            end)
        end
    end
    
    
    ConfigModule:SetAsCurrent()
    ConfigManager.Configs[configFilename] = ConfigModule
    return ConfigModule
end

function ConfigManager:Config(configFilename, autoload)
    return ConfigManager:CreateConfig(configFilename, autoload)
end

function ConfigManager:GetAutoLoadConfigs()
    local autoloadConfigs = {}
    
    for configName, configModule in pairs(ConfigManager.Configs) do
        if configModule.AutoLoad then
            table.insert(autoloadConfigs, configName)
        end
    end
    
    return autoloadConfigs
end

function ConfigManager:DeleteConfig(configName)
    local valid,err=Names.Validate(configName);if not valid then return false,err end;configName=valid
    if not delfile then
        return false, "delfile function is not available"
    end
    
    local configPath = ConfigManager.Path .. configName .. ".json"
    
    if not isfile(configPath) then
        return false, "Config file does not exist"
    end
    
    local success, err = pcall(function()
        delfile(configPath)
    end)
    
    if not success then
        return false, "Failed to delete config file: " .. tostring(err)
    end
    
    ConfigManager.Configs[configName] = nil
    
    if Window.CurrentConfig and Window.CurrentConfig.Path == configPath then
        Window.CurrentConfig = nil
    end
    
    return true, "Config deleted successfully"
end

function ConfigManager:AllConfigs()
    if not listfiles then return {} end
    
    local files = {}
    if not isfolder(ConfigManager.Path) then
        makefolder(ConfigManager.Path)
        return files
    end
    
    for _, file in next, listfiles(ConfigManager.Path) do
        local name = file:match("([^\\/]+)%.json$")
        if name then
            table.insert(files, name)
        end
    end
    
    return files
end

function ConfigManager:GetConfig(configName)
    return ConfigManager.Configs[configName]
end

return ConfigManager