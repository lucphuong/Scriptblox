local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/RedzLibV5/main/Source.Lua"))()

local Window = redzlib:MakeWindow({
  Title = "Minhtv Hub",
  SubTitle = "Beta V2",
  SaveFolder = "MinhtvHub_Config"
})

local TabMain = Window:MakeTab({"Chính", "Main"})
local TabPlayer = Window:MakeTab({"Người chơi", "Player"})
local TabServer = Window:MakeTab({"Server", "Server"})
local TabGraphics = Window:MakeTab({"Đồ họa", "Visuals"})

TabMain:AddButton({"Infinite Yield", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end})

TabMain:AddButton({"Bất tử", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()
end})

TabMain:AddButton({"Sẽ gầy", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/4gh9/Bang-Script-Gui/main/bang%20gui.lua"))()
end})

TabMain:AddButton({"Jump Power", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/lucphuong/Bloxfruit/refs/heads/main/Jumppower.lua"))()
end})

TabPlayer:AddButton({"Bay V3", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end})

TabPlayer:AddButton({"Nhảy vô hạn", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Uranium-235-scripzz/infinityjump.lua/main/infinityjump.lua"))()
end})

TabPlayer:AddButton({"Tốc độ", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/MrScripterrFr/Speed-Changer/main/Speed%20Changer"))()
end})

TabPlayer:AddButton({"Tàng hình", function()
  loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Awesome-Invisible-man-21074"))()
end})

TabPlayer:AddButton({"No Clip", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/lucphuong/Bloxfruit/refs/heads/main/Noclip.lua"))()
end})

TabServer:AddButton({"Chống AFK", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/Anti-afk/main/antiafkbyhassanxzyn"))()
end})

TabGraphics:AddButton({"Shader", function()
  loadstring(game:HttpGet("https://pastebin.com/raw/pVJU9wze"))()
end})

TabGraphics:AddButton({"Fix lag", function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletgojo/Haidepzai/refs/heads/main/Fixlag-delete100%25trash-Teddy"))()
end})

TabPlayer:AddSlider({
  Name = "Tốc độ di chuyển",
  Min = 16,
  Max = 200,
  Increase = 1,
  Default = 16,
  Callback = function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
  end
})

TabPlayer:AddSlider({
  Name = "Độ cao nhảy",
  Min = 50,
  Max = 300,
  Increase = 5,
  Default = 50,
  Callback = function(Value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
  end
})

redzlib:Notification({
  Title = "Minhtv Hub",
  Content = "Menu đã tải xong!",
  Duration = 5
})
