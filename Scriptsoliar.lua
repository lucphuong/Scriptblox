loadstring(game:HttpGet(("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua")))()

       local Window = MakeWindow({
         Hub = {
         Title = "Soliar tổng hợp hub",
         Animation = "Đang lên chờ tí",
         },
        Key = {
        KeySystem = true,
        Title = "key đâu cu",
        Description = "",
        KeyLink = " https://link4sub.com/uLyo",
        Keys = {"nanatvcute.cc"},
        Notifi = {
        Notifications = true,
        CorrectKey = "Key chạy",
       Incorrectkey = "thành công",
       CopyKeyLink = "Copied to Clipboard"
      }
    }
  })

       MinimizeButton({
       Image = "http://www.roblox.com/asset/?id=921205825324709",
       Size = {60, 60},
       Color = Color3.fromRGB(10, 10, 10),
       Corner = true,
       Stroke = false,
       StrokeColor = Color3.fromRGB(255, 0, 0)
      })
       local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

pcall(function() setfpscap(120) end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RainbowFPS"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1000
screenGui.IgnoreGuiInset = true
screenGui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 120, 0, 30)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundTransparency = 1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.Font = Enum.Font.FredokaOne
textLabel.TextScaled = true
textLabel.BackgroundTransparency = 1
textLabel.TextStrokeTransparency = 0.2
textLabel.Text = "FPS: 0"
textLabel.Parent = frame

task.spawn(function()
    local hue = 0
    while true do
        hue = (hue + 0.005) % 1
        textLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
        RunService.RenderStepped:Wait()
    end
end)

local frameCount = 0
local lastUpdate = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastUpdate >= 1 then
        local fps = math.floor(frameCount / (now - lastUpdate))
        textLabel.Text = "FPS: " .. tostring(fps)
        frameCount = 0
        lastUpdate = now
    end
end)
------ Tab
     local Tab0o = MakeTab({Name = "mm2"})
     local Tab1o = MakeTab({Name = "gow a gader"})
     local Tab2o = MakeTab({Name = "99 đêm"})
     local Tab3o = MakeTab({Name = "steal a brainot"})
     local Tab4o = MakeTab({Name = "plant vs brainot"})
     local Tab5o = MakeTab({Name = "srcipt linh tinh"})
     local Tab6o = MakeTab({Name = "blox fruit"})
     local Tab7o = MakeTab({Name = "kaitun blox fruit"})
     local Tab8o = MakeTab({Name = "script tổng hợp"})
     local Tab9o = MakeTab({Name = "tthe strongest battlegrounds"})
     
------- BUTTON
    
    AddButton(Tab6o, {
     Name = "thinh limeted",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/thunhchk/thinhlimeted/refs/heads/main/tthinhlimeted.lua"))()
  end
  })
  
  AddButton(Tab5o, {
     Name = "bất tử tất cả game",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()
  end
  })
  
  AddButton(Tab5o, {
     Name = "bất tử 99 đêm",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/ProBaconHub/DATABASE/refs/heads/main/99%20Nights%20in%20the%20Forest/Infinite%20Health.lua"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "maru hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/thunhchk/Maruvietsub/refs/heads/main/maruhubthinh.txt"))()
  end
  })
  
  AddButton(Tab0o, {
     Name = "ko biết tên",
    Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusScripts212/Roblox/refs/heads/main/Mm2",true))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "farm chest",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/thunhchk/Farmchest/refs/heads/main/thinhtp.txt"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "cat egg đã update",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/thunhchk/Categgv6/refs/heads/main/categgv6beta.lua"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "speed hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "hop sever",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/thunhchk/Hopsever/refs/heads/main/categghop.txt"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "banana hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/thunhchk/Bananacat/refs/heads/main/testhub.lua"))()
  end
  })
  
  AddButton(Tab2o, {
     Name = "foxname- 99 đêm",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua"))()
  end
  })
  
  AddButton(Tab3o, {
     Name = "ko tên",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Tigyiscute/tigystealabrainrotscript/refs/heads/main/TigysScript"))()
  end
  })
  
  AddButton(Tab4o, {
     Name = "speed hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
  end
  })
  
  AddButton(Tab5o, {
     Name = "fly thịnh",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/thunhchk/Flythinh/refs/heads/main/Flythinhv1.lua"))()
  end
  })
  
  AddButton(Tab2o, {
     Name = "99 đêm thịnh",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/thunhchk/99nigth/refs/heads/main/99nightthinh.lua"))()
  end
  })
  
  AddButton(Tab5o, {
     Name = "bất tử",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()
  end
  })
  
  AddButton(Tab7o, {
     Name = "kaitun thịnh",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/thunhchk/Kaitunbf/refs/heads/main/thinhkaitunbf.txt"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "doremon v2",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/KiddoHiru/BloxFruits/main/MasterHub.lua"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "zen hub",
    Callback = function()
	  loadstring(game:HttpGet("https://zuwz.me/Ls-Zee-Hub"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "w azure",
    Callback = function()
	  loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/85e904ae1ff30824c1aa007fc7324f8f.lua"))()
  end
  })
  
  AddButton(Tab5o, {
     Name = "hoho hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "blue x hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/Main.lua"))()
  end
  })
  
  AddButton(Tab5o, {
     Name = "blue x hub nhặt trái",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/FindFruits.lua"))()
  end
  })
  
  AddButton(Tab5o, {
     Name = "teddy hop sever",
    Callback = function()
	  repeat task.wait() until game:IsLoaded() and game:GetService("Players") and game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Teddyseetink/Haidepzai/refs/heads/main/TEDDYHUB-FREEMIUM"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "quantum",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "thunder",
    Callback = function()
	  loadstring(game:HttpGet('https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua'))()
  end
  })
  
  AddButton(Tab2o, {
     Name = "quantum",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "tboy Roblox",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/TBoyRoblox727/TBoyRobloxYTB/refs/heads/main/TBeoMainBF.lua"))()
  end  
  })
  
  AddButton(Tab6o, {
     Name = "xeter v3",
    Callback = function()
	  getgenv().Version = "V3"
      getgenv().Team = "Marines"
      loadstring(game:HttpGet("https://raw.githubusercontent.com/TlDinhKhoi/Xeter/refs/heads/main/Main.lua"))()
  end
  })
  
  AddButton(Tab7o, {
     Name = "Yiner Hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-Yiner/Yiner-Hub/refs/heads/main/KaitunOfTheSkies.lua"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "ngọc bổng",
    Callback = function()
	  getgenv().Team = "Marines"
      loadstring(game:HttpGet("https://raw.githubusercontent.com/ngocbonggaming/script/refs/heads/main/NgocBongVn.lua"))()
  end
  })
  
  AddButton(Tab2o, {
     Name = "auto kc 99 đêm",
    Callback = function()
	  getgenv().WebhookURL = ""
      getgenv().AutoFarm = true
      loadstring(game:HttpGet("https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Farm%20Diamond%20v2.lua"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "hiru hub",
    Callback = function()
	  repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
      loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaStupid/ExecuteGames/main/QuestGames.lua"))()
  end
  })
  
  AddButton(Tab4o, {
     Name = "saki hub",
    Callback = function()
	  loadstring(game:HttpGet("https://saki-hub.vercel.app/pvb.lua"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "OMG hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "zis roblox",
    Callback = function()
	  getgenv().Team = "Marines"
      loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/Zis/refs/heads/main/ZisBVn"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "đạt thg",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaCrack/DatThg/refs/heads/main/DatThgV2"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "HNC HUB",
    Callback = function()
	  getgenv().team = "Pirates" --"Marines"
      loadstring(game:HttpGet("https://raw.githubusercontent.com/hnc-roblox/HNCHubOnTop/refs/heads/main/HNC_Roblox.lua"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "teddy hub",
    Callback = function()
	  repeat wait() until game:IsLoaded() and game.Players.LocalPlayer 
      loadstring(game:HttpGet("https://pandadevelopment.net/virtual/file/ea696e8e7439ba51"))()

  end
  })
  
  AddButton(Tab6o, {
     Name = "hiru hub ui redz",
    Callback = function()
	  getgenv().Settings = {
      JoinTeam = true,
      Team = "Marines"
      }
      getgenv().Version = "V1"-- V1 Ui Fluent or V2 Ui Redz
      loadstring(game:HttpGet("https://raw.githubusercontent.com/KiddoHiru/BloxFruits/main/MainVerison.lua"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "gravity hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua"))()
  end
  })
  
  AddButton(Tab8o, {
     Name = "tổng hợp tboy roblox",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/TBoyRoblox727/TBoyRobloxYTB/refs/heads/main/AllScriptBF.txt"))()
  end
  })
  
  AddButton(Tab8o, {
     Name = "tuấn anh ios tổng hợp",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/TuanAnhIOSNew/refs/heads/main/TuanAnhIOS-TongHop.Lua"))()
  end
  })
  
  AddButton(Tab6o, {
     Name = "astra hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Overgustx2/Main/refs/heads/main/BloxFruits_25.html"))()
  end
  })
  
  AddButton(Tab9o, {
     Name = "aimlock",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Cyborg883/TSB/refs/heads/main/CombatGui"))()
  end
  })

  AddButton(Tab6o, {
     Name = "maru hub",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/trongdeptraihucscript/MaruHubPremium/refs/heads/main/MaruHubPremium.lua"))()
  end
  })
    
  AddButton(Tab6o, {
     Name = "gravity hub",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/refs/heads/main/Main.lua"))()
  end
  })
    
  AddButton(Tab6o, {
    Name = "nazuX hub",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NguyenAnhKhoaX/Anhkhoa2279/refs/heads/main/BloxFruits.lua"))()
  end

  })
