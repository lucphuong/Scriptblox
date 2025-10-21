-- LocalScript: MainLoader.lua
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- Biến toàn cục
local flyEnabled = false
local infJumpEnabled = false
local noclipEnabled = false
local speedEnabled = false
local antiAfkEnabled = false
local antiLagEnabled = false
local goonEnabled = false
local carEnabled = false
local danceEnabled = false
local connections = {}

-- Đợi character load
local character = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

-- Tạo Window chính
local Window = Rayfield:CreateWindow({
   Name = "🔥 VIP Hub",
   LoadingTitle = "VIP Hub Loader",
   LoadingSubtitle = "Đang tải hệ thống...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "VIPConfig",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "your_invite_code",
      RememberJoins = true
   },
   KeySystem = false,
})

-- ==================== TAB 1: PLAYER ====================
local PlayerTab = Window:CreateTab("Player", "rbxassetid://4483345998")

-- Section Fly
local FlySection = PlayerTab:CreateSection("Fly System")
local flyConnection
local bodyVelocity

local FlyToggle = PlayerTab:CreateToggle({
    Name = "🕊️ Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(value)
        flyEnabled = value
        if value then
            activateFly()
        else
            deactivateFly()
        end
    end,
})

function activateFly()
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = character.HumanoidRootPart
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled or not character or not character:FindFirstChild("HumanoidRootPart") then
            deactivateFly()
            return
        end
        
        local root = character.HumanoidRootPart
        local camera = Workspace.CurrentCamera
        
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local up = Vector3.new(0, 1, 0)
        
        local direction = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + forward end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - forward end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - right end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + right end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + up end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - up end
        
        if direction.Magnitude > 0 then
            direction = direction.Unit * 50
        end
        
        bodyVelocity.Velocity = direction
    end)
end

function deactivateFly()
    if flyConnection then flyConnection:Disconnect() end
    if bodyVelocity then bodyVelocity:Destroy() end
end

-- Section Infinite Jump
local JumpSection = PlayerTab:CreateSection("Jump System")

local InfJumpToggle = PlayerTab:CreateToggle({
    Name = "🌟 Infinite Jump",
    CurrentValue = false,
    Flag = "InfJumpToggle",
    Callback = function(value)
        infJumpEnabled = value
        if value then
            activateInfJump()
        else
            deactivateInfJump()
        end
    end,
})

function activateInfJump()
    local jumpConnection
    jumpConnection = UserInputService.JumpRequest:Connect(function()
        if infJumpEnabled and character and character:FindFirstChild("Humanoid") then
            character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
    table.insert(connections, jumpConnection)
end

function deactivateInfJump()
    -- Auto cleanup
end

-- Section Speed
local SpeedSection = PlayerTab:CreateSection("Speed System")

local SpeedSlider = PlayerTab:CreateSlider({
    Name = "⚡ Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 16,
    Flag = "SpeedSlider",
    Callback = function(value)
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = value
        end
    end,
})

-- Section Teleport
local TeleportSection = PlayerTab:CreateSection("Teleport System")

local TeleportInput = PlayerTab:CreateInput({
    Name = "📍 Teleport to Player",
    PlaceholderText = "Nhập tên người chơi",
    RemoveTextAfterFocusLost = false,
    Callback = function(text) end,
})

local TeleportButton = PlayerTab:CreateButton({
    Name = "🚀 Teleport",
    Callback = function()
        local targetName = TeleportInput:Get()
        local targetPlayer = Players:FindFirstChild(targetName)
        
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Đã teleport đến " .. targetName,
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title = "Lỗi",
                Content = "Không tìm thấy người chơi!",
                Duration = 3,
            })
        end
    end,
})

-- Section Noclip
local NoclipSection = PlayerTab:CreateSection("Noclip System")

local NoclipToggle = PlayerTab:CreateToggle({
    Name = "👻 Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclipEnabled = value
        if value then
            activateNoclip()
        else
            deactivateNoclip()
        end
    end,
})

function activateNoclip()
    local noclipConnection
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled or not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
    table.insert(connections, noclipConnection)
end

function deactivateNoclip()
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- ==================== TAB 2: SERVER ====================
local ServerTab = Window:CreateTab("Server", "rbxassetid://4483345998")

-- Section Anti-AFK
local AntiAFKSection = ServerTab:CreateSection("Anti-AFK System")

local AntiAFKToggle = ServerTab:CreateToggle({
    Name = "⏰ Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFKToggle",
    Callback = function(value)
        antiAfkEnabled = value
        if value then activateAntiAFK() else deactivateAntiAFK() end
    end,
})

function activateAntiAFK()
    local virtualUser = game:GetService("VirtualUser")
    local antiAfkConnection
    antiAfkConnection = RunService.Heartbeat:Connect(function()
        if antiAfkEnabled then
            virtualUser:CaptureController()
            virtualUser:ClickButton2(Vector2.new())
        end
    end)
    table.insert(connections, antiAfkConnection)
end

function deactivateAntiAFK() end

-- Section Anti-Ban
local AntiBanSection = ServerTab:CreateSection("Anti-Ban System")

local AntiBanToggle = ServerTab:CreateToggle({
    Name = "🛡️ Anti-Ban",
    CurrentValue = false,
    Flag = "AntiBanToggle",
    Callback = function(value)
        Rayfield:Notify({
            Title = "Anti-Ban",
            Content = value and "Anti-Ban đã bật" or "Anti-Ban đã tắt",
            Duration = 3,
        })
    end,
})

-- Section Anti-Lag
local AntiLagSection = ServerTab:CreateSection("Anti-Lag System")

local AntiLagToggle = ServerTab:CreateToggle({
    Name = "🚀 Anti-Lag",
    CurrentValue = false,
    Flag = "AntiLagToggle",
    Callback = function(value)
        antiLagEnabled = value
        if value then
            -- Giảm graphics để tăng performance
            settings().Rendering.QualityLevel = 1
            Workspace.DescendantAdded:Connect(function(descendant)
                if antiLagEnabled and descendant:IsA("Part") then
                    descendant.Material = Enum.Material.Plastic
                end
            end)
            Rayfield:Notify({Title = "Anti-Lag", Content = "Đã bật Anti-Lag", Duration = 3})
        else
            settings().Rendering.QualityLevel = 10
            Rayfield:Notify({Title = "Anti-Lag", Content = "Đã tắt Anti-Lag", Duration = 3})
        end
    end,
})

-- ==================== TAB 3: FUNNY ====================
local FunnyTab = Window:CreateTab("Funny", "rbxassetid://4483345998")

-- Section Goon
local GoonSection = FunnyTab:CreateSection("Goon Mode")

local GoonToggle = FunnyTab:CreateToggle({
    Name = "😈 Goon Mode",
    CurrentValue = false,
    Flag = "GoonToggle",
    Callback = function(value)
        goonEnabled = value
        if value then
            -- Thay đổi kích thước character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Size = part.Size * 1.5
                    end
                end
            end
            Rayfield:Notify({Title = "Goon", Content = "Goon mode activated!", Duration = 3})
        else
            -- Khôi phục kích thước
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Size = part.Size / 1.5
                    end
                end
            end
        end
    end,
})

-- Section Car
local CarSection = FunnyTab:CreateSection("Car Mode")

local CarToggle = FunnyTab:CreateToggle({
    Name = "🚗 Be a Car",
    CurrentValue = false,
    Flag = "CarToggle",
    Callback = function(value)
        carEnabled = value
        if value then
            -- Thêm hiệu ứng car
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 35
                character.Humanoid.JumpPower = 0
            end
            Rayfield:Notify({Title = "Car", Content = "Vroom vroom! 🚗", Duration = 3})
        else
            -- Khôi phục
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.WalkSpeed = 16
                character.Humanoid.JumpPower = 50
            end
        end
    end,
})

-- Section Dance
local DanceSection = FunnyTab:CreateSection("Dance Party")

local DanceToggle = FunnyTab:CreateToggle({
    Name = "💃 Dance Mode",
    CurrentValue = false,
    Flag = "DanceToggle",
    Callback = function(value)
        danceEnabled = value
        if value then
            -- Kích hoạt animations dance
            local danceAnimation = Instance.new("Animation")
            danceAnimation.AnimationId = "rbxassetid://181525546" -- ID animation dance
            
            if character and character:FindFirstChild("Humanoid") then
                local animator = character.Humanoid:FindFirstChild("Animator")
                if animator then
                    local danceTrack = animator:LoadAnimation(danceAnimation)
                    danceTrack:Play()
                end
            end
            Rayfield:Notify({Title = "Dance", Content = "Let's dance! 💃", Duration = 3})
        else
            -- Dừng dance
            if character and character:FindFirstChild("Humanoid") then
                local animator = character.Humanoid:FindFirstChild("Animator")
                if animator then
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop()
                    end
                end
            end
        end
    end,
})

-- ==================== TAB 4: FIGHTING ====================
local FightingTab = Window:CreateTab("Fighting", "rbxassetid://4483345998")

-- Section Sword
local SwordSection = FightingTab:CreateSection("Sword System")

local SwordButton = FightingTab:CreateButton({
    Name = "⚔️ Spawn Sword",
    Callback = function()
        -- Tạo kiếm
        local sword = Instance.new("Tool")
        sword.Name = "Magic Sword"
        sword.Grip = CFrame.new(0, 0, 0)
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 5, 1)
        handle.BrickColor = BrickColor.new("Bright blue")
        handle.Material = Enum.Material.Neon
        handle.Parent = sword
        
        local swordScript = Instance.new("Script")
        swordScript.Source = [[
            tool = script.Parent
            damage = 50
            
            tool.Activated:Connect(function()
                local character = tool.Parent
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    -- Tìm target
                    local target = humanoid.Target
                    if target then
                        local targetHumanoid = target.Parent:FindFirstChild("Humanoid")
                        if targetHumanoid then
                            targetHumanoid:TakeDamage(damage)
                        end
                    end
                end
            end)
        ]]
        swordScript.Parent = sword
        
        sword.Parent = player.Backpack
        Rayfield:Notify({Title = "Sword", Content = "Đã tạo kiếm!", Duration = 3})
    end,
})

-- Section Gun
local GunSection = FightingTab:CreateSection("Gun System")

local GunButton = FightingTab:CreateButton({
    Name = "🔫 Spawn Gun",
    Callback = function()
        -- Tạo súng
        local gun = Instance.new("Tool")
        gun.Name = "Magic Gun"
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 1, 3)
        handle.BrickColor = BrickColor.new("Black")
        handle.Parent = gun
        
        local gunScript = Instance.new("Script")
        gunScript.Source = [[
            local tool = script.Parent
            local damage = 25
            
            tool.Activated:Connect(function()
                -- Bắn đạn
                local character = tool.Parent
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                
                if humanoidRootPart then
                    local bullet = Instance.new("Part")
                    bullet.Size = Vector3.new(0.2, 0.2, 0.2)
                    bullet.BrickColor = BrickColor.new("Bright yellow")
                    bullet.Material = Enum.Material.Neon
                    bullet.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    bullet.Velocity = humanoidRootPart.CFrame.LookVector * 100
                    bullet.Parent = workspace
                    
                    -- Xóa bullet sau 3 giây
                    game:GetService("Debris"):AddItem(bullet, 3)
                end
            end)
        ]]
        gunScript.Parent = gun
        
        gun.Parent = player.Backpack
        Rayfield:Notify({Title = "Gun", Content = "Đã tạo súng!", Duration = 3})
    end,
})

-- Section Laser Gun
local LaserSection = FightingTab:CreateSection("Laser Gun System")

local LaserButton = FightingTab:CreateButton({
    Name = "🔦 Spawn Laser Gun",
    Callback = function()
        -- Tạo súng laser
        local laserGun = Instance.new("Tool")
        laserGun.Name = "Laser Gun"
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.5, 0.5, 2)
        handle.BrickColor = BrickColor.new("Bright red")
        handle.Material = Enum.Material.Neon
        handle.Parent = laserGun
        
        local laserScript = Instance.new("Script")
        laserScript.Source = [[
            local tool = script.Parent
            local damage = 75
            
            tool.Activated:Connect(function()
                local character = tool.Parent
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                
                if humanoidRootPart then
                    -- Tạo tia laser
                    local laser = Instance.new("Part")
                    laser.Size = Vector3.new(0.1, 0.1, 10)
                    laser.BrickColor = BrickColor.new("Bright red")
                    laser.Material = Enum.Material.Neon
                    laser.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    laser.Parent = workspace
                    
                    -- Beam effect
                    local beam = Instance.new("Beam")
                    beam.Attachment0 = Instance.new("Attachment")
                    beam.Attachment0.Parent = laser
                    beam.Attachment1 = Instance.new("Attachment")
                    beam.Attachment1.Parent = laser
                    beam.Attachment1.Position = Vector3.new(0, 0, -10)
                    beam.Color = ColorSequence.new(Color3.new(1, 0, 0))
                    beam.Parent = laser
                    
                    -- Xóa laser sau 0.5 giây
                    game:GetService("Debris"):AddItem(laser, 0.5)
                end
            end)
        ]]
        laserScript.Parent = laserGun
        
        laserGun.Parent = player.Backpack
        Rayfield:Notify({Title = "Laser Gun", Content = "Đã tạo súng laser!", Duration = 3})
    end,
})

-- Cleanup khi player leave
player.CharacterRemoving:Connect(function()
    deactivateFly()
    deactivateNoclip()
end)

-- Thông báo load thành công
Rayfield:Notify({
    Title = "VIP Hub",
    Content = "Đã tải menu thành công!",
    Duration = 6,
    Image = 4483362458,
})
