-- Restore the captured fork.18 view after loading ForkExample.lua.
local d=assert(getgenv().WindUIForkDemo,'Load the WindUI demo first')
local snapshot=game:GetService('HttpService'):JSONDecode([=====[{"SourceRepository":"https://github.com/123ads213/WindUI","SourceCommit":"1044ddb14d8d4f32a6b252318c7931c3930c5185","Version":"1.6.66-fork.18","Theme":"Light","Scale":1,"Transparency":0,"WindowPosition":[0.5,-98,0.5,47],"WindowSize":[0,696,0,560],"SelectedTab":3,"Values":{"ShowPlayers":false,"Distance":500000,"Budget":1250000000,"Precision":0.12345},"Hotkeys":[],"SolidColor":{"Rotation":0,"Stops":[{"Color":"2a94ff","Transparency":0.15,"Position":0}]},"GradientColor":{"Rotation":0,"Stops":[{"Color":"00aaff","Transparency":0,"Position":0},{"Color":"c45cff","Transparency":0.2,"Position":1}]},"HUD":{"Version":2,"Fields":{"Ping":true,"Platform":true,"Avatar":true,"FPS":true,"Username":true,"Day":true,"Time":true,"Build":true,"Place":false,"VAR":false,"Executor":false,"Memory":false,"Uptime":false},"KeylistMode":"Classic","Watermark":true,"Keylist":true,"Positions":{"Keylist":{"Y":0.4375,"X":0.001953125,"Anchor":0},"Watermark":{"Y":0.96597222222222,"X":0.5,"Anchor":0.5}}}}]=====])
d.Library:SetTheme(snapshot.Theme);d.Window:SetUIScale(snapshot.Scale)
d.Profile:SetTransparency(snapshot.Transparency)
d.SolidColor:Import(snapshot.SolidColor);d.GradientColor:Import(snapshot.GradientColor)
d.Big:Set(snapshot.Values.Distance);d.Billion:Set(snapshot.Values.Budget);d.Fine:Set(snapshot.Values.Precision)
d.ShowPlayers:SetHotkeys(snapshot.Hotkeys);d.ShowPlayers:Set(snapshot.Values.ShowPlayers)
d.HUD:Import(snapshot.HUD)
d.Window:SetSize(UDim2.new(table.unpack(snapshot.WindowSize)))
task.wait(.15)
d.Window:SetPosition(UDim2.new(table.unpack(snapshot.WindowPosition)))
d.Window:SelectTab(snapshot.SelectedTab);d.Window:Open()
return true
