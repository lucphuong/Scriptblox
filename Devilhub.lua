local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/LlSourcell/Rayfield-Library/main/Rayfield.lua"))()

local Window = Rayfield:CreateWindow({
   Name = "DEVIL HUB | Rayfield",
   LoadingTitle = "DEVIL HUB",
   LoadingSubtitle = "Rayfield Menu",
   ConfigurationSaving = { Enabled = true, FolderName = "DevilHubConfigs", FileName = "Config1" },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)
local LocalTab = Window:CreateTab("Local Player", 4483362458)
local FunnyTab = Window:CreateTab("Funny", 4483362458)
local ServerTab = Window:CreateTab("Server", 4483362458)
local FightTab = Window:CreateTab("Fight", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local workspace = workspace
local VirtualUser = game:GetService("VirtualUser")
local handles = {}

-- Helper: cleanup
local function tryCleanup(key)
    local h = handles[key]
    if not h then return end
    pcall(function()
        if type(h)=="function" then h()
        elseif typeof(h)=="RBXScriptConnection" then h:Disconnect()
        elseif typeof(h)=="Instance" and h.Destroy then h:Destroy() end
    end)
    handles[key] = nil
end

-- Fly
MainTab:CreateToggle({Name="Fly",CurrentValue=false,Flag="Fly",Callback=function(enable)
    if enable then
        tryCleanup("Fly")
        local bv = Instance.new("BodyVelocity")
        local bg = Instance.new("BodyGyro")
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bv.Velocity = Vector3.new()
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        bg.P = 2500
        local speed = 60
        local conn
        conn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local hrp = char.HumanoidRootPart
            if not bv.Parent then bv.Parent = hrp end
            if not bg.Parent then bg.Parent = hrp end
            local cam = workspace.CurrentCamera
            bg.CFrame = cam.CFrame
            local vel = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel=vel+cam.CFrame.LookVector*speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel=vel-cam.CFrame.LookVector*speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel=vel-cam.CFrame.RightVector*speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel=vel+cam.CFrame.RightVector*speed end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel=vel+Vector3.new(0,speed,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vel=vel-Vector3.new(0,speed,0) end
            bv.Velocity = vel
        end)
        handles.Fly = function()
            pcall(function() conn:Disconnect() end)
            pcall(function() bv:Destroy() end)
            pcall(function() bg:Destroy() end)
        end
    else
        tryCleanup("Fly")
    end
end})

-- Speed
MainTab:CreateToggle({Name="Speed",CurrentValue=false,Flag="Speed",Callback=function(enable)
    if enable then
        tryCleanup("Speed")
        local conn
        conn = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local cam = workspace.CurrentCamera
                local dir = Vector3.new()
                local speed = 80
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                if dir.Magnitude>0 then
                    dir = dir.Unit
                    hrp.Velocity = Vector3.new(dir.X*speed, hrp.Velocity.Y, dir.Z*speed)
                end
            end
        end)
        handles.Speed = conn
    else
        tryCleanup("Speed")
    end
end})

-- Infinite Jump
MainTab:CreateToggle({Name="Infinite Jump",CurrentValue=false,Flag="InfJump",Callback=function(enable)
    if enable then
        tryCleanup("InfJump")
        handles.InfJump = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end
            end
        end)
    else
        tryCleanup("InfJump")
    end
end})

-- AntiAFK
MainTab:CreateToggle({Name="AntiAFK",CurrentValue=false,Flag="AntiAFK",Callback=function(enable)
    if enable then
        tryCleanup("AntiAFK")
        handles.AntiAFK = LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
            end)
        end)
    else
        tryCleanup("AntiAFK")
    end
end})

-- Teleport To Mouse
MainTab:CreateButton({Name="Teleport To Mouse",Callback=function()
    local mouse = LocalPlayer:GetMouse()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and mouse and mouse.Hit then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position+Vector3.new(0,3,0))
    end
end})

-- Local Player Toggles
LocalTab:CreateToggle({Name="Noclip",CurrentValue=false,Flag="Noclip",Callback=function(enable)
    if enable then
        tryCleanup("Noclip")
        handles.Noclip = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        tryCleanup("Noclip")
    end
end})

LocalTab:CreateToggle({Name="BatTu (Fall Prevention)",CurrentValue=false,Flag="BatTu",Callback=function(enable)
    if enable then
        handles._oldFall = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 9e9
    else
        if handles._oldFall then
            workspace.FallenPartsDestroyHeight = handles._oldFall
            handles._oldFall = nil
        else
            workspace.FallenPartsDestroyHeight = -500
        end
    end
end})

LocalTab:CreateToggle({Name="TanHinh (Invisibility)",CurrentValue=false,Flag="TanHinh",Callback=function(enable)
    local char = LocalPlayer.Character
    if not char then return end
    if enable then
        handles._TanHinhStore = {}
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                handles._TanHinhStore[part] = part.Transparency
                part.Transparency = 1
            end
        end
    else
        if handles._TanHinhStore then
            for part, old in pairs(handles._TanHinhStore) do pcall(function() part.Transparency=old end) end
            handles._TanHinhStore = nil
        end
    end
end})

-- Server Tab: ESP/XRay, External scripts
ServerTab:CreateToggle({Name="ESP",CurrentValue=false,Flag="ESP",Callback=function(enable)
    if enable then
        tryCleanup("ESP")
        local folder = Instance.new("Folder", workspace)
        folder.Name = "DevilHub_ESP"
        handles.ESP = folder
        local function apply(plr)
            if plr==LocalPlayer then return end
            local function add(c)
                pcall(function()
                    if not c or c:FindFirstChild("DevilHubHighlight") then return end
                    local hl = Instance.new("Highlight", folder)
                    hl.Name="DevilHubHighlight"
                    hl.Adornee = c
                    hl.FillTransparency=0.6
                    hl.OutlineTransparency=0
                    hl.FillColor=(plr.Team==LocalPlayer.Team) and Color3.fromRGB(0,120,255) or Color3.fromRGB(255,60,60)
                end)
            end
            if plr.Character then add(plr.Character) end
            plr.CharacterAdded:Connect(add)
        end
        for _,p in pairs(Players:GetPlayers()) do apply(p) end
        Players.PlayerAdded:Connect(apply)
    else
        tryCleanup("ESP")
    end
end})

ServerTab:CreateToggle({Name="XRay",CurrentValue=false,Flag="XRay",Callback=function(enable)
    if enable then
        pcall(function() ServerTab.Flags["ESP"]:Callback(true) end)
        if handles.ESP then
            for _,v in pairs(handles.ESP:GetChildren()) do
                if v:IsA("Highlight") then
                    v.FillTransparency=1
                    v.OutlineTransparency=0
                    v.OutlineColor=Color3.new(1,0,0)
                end
            end
        end
    else
        tryCleanup("ESP")
    end
end})

-- External Scripts (WallWalk, LowLag, FeFlip)
local extScripts = {
    WallWalk = "https://pastebin.com/raw/5T7KsEWy",
    LowLag = "https://pastebin.com/raw/KiSYpej6",
    FeFlip = "https://pastebin.com/raw/abcd1234" -- replace with actual raw
}

for name,url in pairs(extScripts) do
    ServerTab:CreateToggle({Name=name,CurrentValue=false,Flag=name,Callback=function(enable)
        if enable then
            local ok, res = pcall(function() loadstring(game:HttpGet(url))() end)
            if not ok then warn("Failed to load "..name,res) end
        else
            tryCleanup(name)
        end
    end})
end

-- Fight Tab: KillAura, Gun, Sword, LaserGun
local fightScripts = {
    KillAura = "https://pastebin.com/raw/0hn40Zbc",
    Gun = "https://pastebin.com/raw/0hn40Zbc",
    Sword = "https://pastebin.com/raw/0hn40Zbc",
    LaserGun = "https://raw.githubusercontent.com/lucphuong/Coco/refs/heads/main/laser_compiled_placeholder.lua"
}

for name,url in pairs(fightScripts) do
    FightTab:CreateToggle({Name=name,CurrentValue=false,Flag=name,Callback=function(enable)
        if enable then
            local ok, res = pcall(function() loadstring(game:HttpGet(url))() end)
            if not ok then warn("Failed to load "..name,res) end
        else
            tryCleanup(name)
        end
    end})
end

-- Funny Tab: BeACar, Bang, JerkOff, Shader, FeFlip
FunnyTab:CreateToggle({Name="Be A Car",CurrentValue=false,Flag="BeACar",Callback=function(enable)
    if enable then
        local ok,res = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/BeaCar"))() end)
        if not ok then warn("BeACar failed:",res) end
    else
        tryCleanup("BeACar")
    end
end})

FunnyTab:CreateToggle({Name="Bang Script",CurrentValue=false,Flag="Bang",Callback=function(enable)
    if enable then
        local ok,res = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/4gh9/Bang-Script-Gui/main/bang%20gui.lua"))() end)
        if not ok then warn("Bang failed:",res) end
    else
        tryCleanup("Bang")
    end
end})

FunnyTab:CreateToggle({Name="Jerk Off",CurrentValue=false,Flag="JerkOff",Callback=function(enable)
    if enable then
        local ok,res = pcall(function() loadstring(game:HttpGet("https://pastefy.app/lawnvcTT/raw"))() end)
        if not ok then warn("JerkOff failed:",res) end
    else
        tryCleanup("JerkOff")
    end
end})

FunnyTab:CreateToggle({Name="Shader Effects",CurrentValue=false,Flag="Shader",Callback=function(enable)
    if enable then
        local ok,res = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/p0e1/1/refs/heads/main/SimpleShader.lua"))() end)
        if not ok then warn("Shader failed:",res) end
    else
        tryCleanup("Shader")
    end
end})

FunnyTab:CreateToggle({Name="FeFlip (Roll)",CurrentValue=false,Flag="FeFlip",Callback=function(enable)
    if enable then
        local ok,res = pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/abcd1234"))() end)
        if not ok then warn("FeFlip failed:",res) end
    else
        tryCleanup("FeFlip")
    end
end})

-- Server Tab extras: AutoClick, WallWalk, LowLag
ServerTab:CreateToggle({Name="Auto Click (KSystem)",CurrentValue=false,Flag="AutoClick",Callback=function(enable)
    if enable then
        local ok,res = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Hosvile/The-telligence/main/MC%20KSystem%202"))() end)
        if not ok then warn("AutoClick failed:",res) end
    else
        tryCleanup("AutoClick")
    end
end})

-- Fight Tab: Fighting script loader (one-shot button)
FightTab:CreateButton({Name="Load Fighting Script",Callback=function()
    local ok,res = pcall(function() loadstring(game:HttpGet("https://pastefy.app/cAQICuXo/raw"))() end)
    if not ok then warn("Fighting failed:",res) end
end})

-- Optional: Notification helper
local function notify(msg,duration)
    Rayfield:Notify({Title="DEVIL HUB",Content=msg,Duration=duration or 3,Image=4483362458})
end

notify("DEVIL HUB loaded successfully!",4)

-- Phần 3: Draggable Window, Show/Hide, Close All, Notification

-- Draggable window logic
local dragging, dragInput, dragStart, startPos = false, nil, Vector3.new(), win.Position
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = win.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Show/hide toggle button
local visible = true
toggleBtn.MouseButton1Click:Connect(function()
    visible = not visible
    win.Visible = visible
    toggleBtn.BackgroundColor3 = visible and accent or Color3.fromRGB(60,60,60)
end)

-- Close All button (clean up handles & destroy GUI)
closeAll.MouseButton1Click:Connect(function()
    for k,_ in pairs(handles) do
        tryCleanup(k)
    end
    pcall(function() SG:Destroy() end)
    notify("DEVIL HUB closed.",3)
end)

-- Optional notification helper
function notify(msg,duration)
    local lab = Instance.new("TextLabel")
    lab.Size = UDim2.new(0,220,0,28)
    lab.Position = UDim2.new(1,-280,0.9,0)
    lab.BackgroundColor3 = Color3.fromRGB(30,30,30)
    lab.TextColor3 = Color3.fromRGB(240,240,240)
    lab.Text = msg
    lab.Font = Enum.Font.GothamBold
    lab.TextSize = 14
    lab.Parent = SG
    local stroke = Instance.new("UIStroke",lab)
    stroke.Color = accent
    stroke.Thickness = 1
    delay(duration or 3,function()
        pcall(function() lab:Destroy() end)
    end)
end

-- Final load notification
notify("✅ DEVIL HUB fully loaded!",4)
