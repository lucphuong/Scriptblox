loadstring(game:HttpGet("https://raw.githubusercontent.com/REDzHUB/LibraryV2/main/redzLib"))()

MakeWindow({
  Hub = {
    Title = "Devil hub",
    Animation = "Delta Edition"
  },
  Key = {
    KeySystem = false
  }
})

MinimizeButton({
  Image = "",
  Size = {40, 40},
  Color = Color3.fromRGB(15, 15, 15),
  Corner = true
})

local Main = MakeTab({Name = "Chính"})
local Player = MakeTab({Name = "Người chơi"})
local Server = MakeTab({Name = "Server"})
local Graphic = MakeTab({Name = "Đồ họa"})

-- THÔNG BÁO
MakeNotifi({
  Title = "Devil hub",
  Text = "Lên",
  Time = 4
})

-- 🌟 CHÍNH
AddButton(Main, {
  Name = "Infinite Yield",
  Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
  end
})

AddButton(Main, {
  Name = "Bất tử",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()
  end
})

AddButton(Main, {
  Name = "Tàng hình",
  Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Awesome-Invisible-man-21074"))()
  end
})

AddButton(Main, {
  Name = "Noclip (xuyên tường)",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/lucphuong/Bloxfruit/refs/heads/main/Noclip.lua"))()
  end
})

-- ⚡ NGƯỜI CHƠI
AddButton(Player, {
  Name = "Bay (Fly V3)",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
  end
})

AddButton(Player, {
  Name = "Nhảy vô hạn (Inf Jump)",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Uranium-235-scripzz/infinityjump.lua/main/infinityjump.lua"))()
  end
})

AddSlider(Player, {
  Name = "Tốc độ di chuyển",
  MinValue = 16,
  MaxValue = 200,
  Default = 16,
  Increase = 2,
  Callback = function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
  end
})

AddSlider(Player, {
  Name = "Độ cao nhảy",
  MinValue = 50,
  MaxValue = 500,
  Default = 50,
  Increase = 10,
  Callback = function(Value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
  end
})

-- 🧠 SERVER
AddButton(Server, {
  Name = "Chống AFK",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/Anti-afk/main/antiafkbyhassanxzyn"))()
  end
})

AddButton(Server, {
  Name = "Rejoin",
  Callback = function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
  end
})

AddButton(Server, {
  Name = "Server Hop",
  Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/LRBYK0hz"))()
  end
})

-- 🎨 ĐỒ HỌA
AddButton(Graphic, {
  Name = "Shader (Bóng đẹp)",
  Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/pVJU9wze"))()
  end
})

AddButton(Graphic, {
  Name = "Fix Lag 100%",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletgojo/Haidepzai/refs/heads/main/Fixlag-delete100%25trash-Teddy"))()
  end
})

AddButton(Graphic, {
  Name = "Night Vision (Nhìn trong tối)",
  Callback = function()
    game.Lighting.Brightness = 2
    game.Lighting.ClockTime = 14
    game.Lighting.FogEnd = 100000
    game.Lighting.GlobalShadows = false
  end
})

-- 📱 MOBILE TOGGLE
AddMobileToggle({
  Name = "Bật/Tắt Menu",
  Visible = true,
  Callback = function(Value)
    if Value then
      print("Menu bật")
    else
      print("Menu tắt")
    end
  end
})
