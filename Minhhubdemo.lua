loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua"))()

       local Window = MakeWindow({
         Hub = {
         Tittle = "Minh hub beta",
         Animation = "Đang lên"
         },
        Key = {
        KeySystem = true,
        Title = "Key đâu cu",
        Description = "",
        KeyLink = " https://link4sub.com/uLyo",
        Keys = {"nanatvcute.cc"},
        Notifi = {
        Notifications = true,
        CorrectKey = "lên",
       Incorrectkey = "hoạt động",
       CopyKeyLink = "Copied to Clipboard"
      }
    }
  })

       MinimizeButton({
       Image = "http://www.roblox.com/asset/?id=92120582532478",
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
     local Tab0o = MakeTab({Name = "Chính"})
     local Tab1o = MakeTab({Name = "người chơi"})
     local Tab2o = MakeTab({Name = "sever"})
     local Tab3o = MakeTab({Name = "Đồ họa"})
     
------- BUTTON
    
    AddButton(Tab3o, {
     Name = "Shader",
    Callback = function()
	  loadstring(game:HttpGet("https://pastebin.com/raw/pVJU9wze"))()
  end
  })
  
  AddButton(Tab3o, {
     Name = "Fix lag",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletgojo/Haidepzai/refs/heads/main/Fixlag-delete100%25trash-Teddy"))()
  end
  })
  
  AddButton(Tab2o, {
     Name = "Chống afk",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/Anti-afk/main/antiafkbyhassanxzyn"))();
  end
  })
  
  AddButton(Tab1o, {
     Name = "bay v3",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "inf jump",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Uranium-235-scripzz/infinityjump.lua/main/infinityjump.lua"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "tốc độ",
    Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/MrScripterrFr/Speed-Changer/main/Speed%20Changer"))();
  end
  })
  
  AddButton(Tab0o, {
     Name = "IY",
    Callback = function()
	  loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
  end
  })
  
  AddButton(Tab0o, {
     Name = "bất tự",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()
  end
  })
  
