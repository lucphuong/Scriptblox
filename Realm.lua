-- DEVIL CUSTOM TRANSPARENT MENU (Classic-top-tabs, no effects)
-- Paste into executor (client) or StarterPlayerScripts
pcall(function()
    -- Services
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Debris = game:GetService("Debris")
    local TeleportService = game:GetService("TeleportService")
    local Lighting = game:GetService("Lighting")

    local player = Players.LocalPlayer
    if not player then return end

    -- Resource tracking for cleanup
    local created = {}
    local conns = {}
    local function regObj(o) if o then table.insert(created, o) end; return o end
    local function regConn(c) if c then table.insert(conns, c) end; return c end

    local function cleanupAll()
        for _,c in pairs(conns) do pcall(function() c:Disconnect() end) end
        for _,o in pairs(created) do pcall(function() if o and o.Parent then o:Destroy() end end) end
        conns, created = {}, {}
    end

    -- State
    local state = {
        fly = false,
        infJump = false,
        noclip = false,
        speed = 16,
        antiAfk = false,
        antiLag = false,
        goon = false,
        dance = false,
        menuOpen = true,
        bodyCollapsed = false,
    }

    -- Character reference
    local character = player.Character or player.CharacterAdded:Wait()
    player.CharacterAdded:Connect(function(c) character = c end)

    -- UI sizes/colors (transparent style)
    local UI = {}
    local baseX, baseY = 420, 340
    local bgColor = Color3.fromRGB(20,20,20)
    local accent = Color3.fromRGB(0,150,255)
    local textColor = Color3.fromRGB(230,230,230)
    local trans = 0.45 -- main transparency

    -- Root ScreenGui
    local screen = regObj(Instance.new("ScreenGui"))
    screen.Name = "DevilCustomMenu"
    screen.ResetOnSpawn = false
    screen.Parent = game:GetService("CoreGui") -- use CoreGui for executor

    -- Floating toggle button (corner)
    local floatBtn = regObj(Instance.new("TextButton"))
    floatBtn.Name = "DevilToggle"
    floatBtn.Parent = screen
    floatBtn.Size = UDim2.new(0,48,0,48)
    floatBtn.Position = UDim2.new(0, 10, 0, 10)
    floatBtn.BackgroundTransparency = 0.6
    floatBtn.BackgroundColor3 = bgColor
    floatBtn.Text = "VIP"
    floatBtn.Font = Enum.Font.GothamBold
    floatBtn.TextSize = 14
    floatBtn.TextColor3 = Color3.new(1,1,1)
    floatBtn.AutoButtonColor = true
    local corner = regObj(Instance.new("UICorner", floatBtn))
    corner.CornerRadius = UDim.new(0,10)

    -- Main Frame
    local frame = regObj(Instance.new("Frame"))
    frame.Name = "MainWindow"
    frame.Parent = screen
    frame.Size = UDim2.new(0, baseX, 0, baseY)
    frame.Position = UDim2.new(0.25,0,0.2,0)
    frame.BackgroundColor3 = bgColor
    frame.BackgroundTransparency = trans
    frame.BorderSizePixel = 0
    frame.Visible = true

    regObj(Instance.new("UICorner", frame)).CornerRadius = UDim.new(0,8)

    -- Title bar (with - □ x and drag)
    local titleBar = regObj(Instance.new("Frame"))
    titleBar.Name = "TitleBar"
    titleBar.Parent = frame
    titleBar.Size = UDim2.new(1,0,0,30)
    titleBar.Position = UDim2.new(0,0,0,0)
    titleBar.BackgroundTransparency = 1

    local titleLabel = regObj(Instance.new("TextLabel"))
    titleLabel.Parent = titleBar
    titleLabel.Size = UDim2.new(0.7,0,1,0)
    titleLabel.Position = UDim2.new(0,8,0,0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = textColor
    titleLabel.Text = "🔥 VIP MENU"

    -- Control buttons on left: -, □, x (we'll put them right of title)
    local controls = regObj(Instance.new("Frame"))
    controls.Parent = titleBar
    controls.Size = UDim2.new(0.3,-8,1,0)
    controls.Position = UDim2.new(0.7,0,0,0)
    controls.BackgroundTransparency = 1

    local btnMinus = regObj(Instance.new("TextButton"))
    btnMinus.Parent = controls
    btnMinus.Size = UDim2.new(0,28,0,22)
    btnMinus.Position = UDim2.new(1,-92,0,4)
    btnMinus.BackgroundTransparency = 0.6
    btnMinus.BackgroundColor3 = bgColor
    btnMinus.Font = Enum.Font.Gotham
    btnMinus.TextSize = 16
    btnMinus.Text = "-"
    btnMinus.TextColor3 = textColor
    regObj(Instance.new("UICorner", btnMinus)).CornerRadius = UDim.new(0,6)

    local btnSquare = regObj(Instance.new("TextButton"))
    btnSquare.Parent = controls
    btnSquare.Size = UDim2.new(0,28,0,22)
    btnSquare.Position = UDim2.new(1,-58,0,4)
    btnSquare.BackgroundTransparency = 0.6
    btnSquare.BackgroundColor3 = bgColor
    btnSquare.Font = Enum.Font.Gotham
    btnSquare.TextSize = 14
    btnSquare.Text = "□"
    btnSquare.TextColor3 = textColor
    regObj(Instance.new("UICorner", btnSquare)).CornerRadius = UDim.new(0,6)

    local btnClose = regObj(Instance.new("TextButton"))
    btnClose.Parent = controls
    btnClose.Size = UDim2.new(0,28,0,22)
    btnClose.Position = UDim2.new(1,-24,0,4)
    btnClose.BackgroundTransparency = 0.6
    btnClose.BackgroundColor3 = bgColor
    btnClose.Font = Enum.Font.GothamBold
    btnClose.TextSize = 14
    btnClose.Text = "x"
    btnClose.TextColor3 = textColor
    regObj(Instance.new("UICorner", btnClose)).CornerRadius = UDim.new(0,6)

    -- Tab bar (top)
    local tabBar = regObj(Instance.new("Frame"))
    tabBar.Parent = frame
    tabBar.Size = UDim2.new(1,0,0,32)
    tabBar.Position = UDim2.new(0,0,0,30)
    tabBar.BackgroundTransparency = 1

    local function createTabButton(name, pos)
        local btn = regObj(Instance.new("TextButton"))
        btn.Parent = tabBar
        btn.Size = UDim2.new(0,100,1,0)
        btn.Position = UDim2.new(0,pos*100,0,0)
        btn.BackgroundTransparency = 1
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Text = name
        btn.TextColor3 = textColor
        btn.AutoButtonColor = true
        return btn
    end

    local tabNames = {"Player","Server","Fun","Fight"}
    local tabBtns = {}
    for i,name in ipairs(tabNames) do tabBtns[i] = createTabButton(name, i-1) end

    -- Content container
    local body = regObj(Instance.new("Frame"))
    body.Parent = frame
    body.Size = UDim2.new(1,-12,1,-78)
    body.Position = UDim2.new(0,6,0,64)
    body.BackgroundTransparency = 1

    -- Left column (controls) and right column (info)
    local leftCol = regObj(Instance.new("Frame"))
    leftCol.Parent = body
    leftCol.Size = UDim2.new(0.5,-8,1,0)
    leftCol.Position = UDim2.new(0,0,0,0)
    leftCol.BackgroundTransparency = 1

    local rightCol = regObj(Instance.new("Frame"))
    rightCol.Parent = body
    rightCol.Size = UDim2.new(0.5,-8,1,0)
    rightCol.Position = UDim2.new(0.5,8,0,0)
    rightCol.BackgroundTransparency = 1

    -- Helper to create rows
    local function createToggle(parent, y, label, start)
        local lbl = regObj(Instance.new("TextLabel"))
        lbl.Parent = parent
        lbl.Size = UDim2.new(1, -70, 0, 30)
        lbl.Position = UDim2.new(0, 8, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = textColor
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = label

        local btn = regObj(Instance.new("TextButton"))
        btn.Parent = parent
        btn.Size = UDim2.new(0,56,0,24)
        btn.Position = UDim2.new(1, -64, 0, y+3)
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.Text = start and "ON" or "OFF"
        btn.TextColor3 = Color3.new(1,1,1)
        regObj(Instance.new("UICorner", btn)).CornerRadius = UDim.new(0,6)
        return btn
    end

    local function createSlider(parent, y, label, min, max, init)
        local lbl = regObj(Instance.new("TextLabel"))
        lbl.Parent = parent
        lbl.Size = UDim2.new(1, -20, 0, 20)
        lbl.Position = UDim2.new(0, 8, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = textColor
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = label.." : "..tostring(init)

        local bar = regObj(Instance.new("Frame"))
        bar.Parent = parent
        bar.Size = UDim2.new(1, -20, 0, 10)
        bar.Position = UDim2.new(0, 10, 0, y+22)
        bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
        regObj(Instance.new("UICorner", bar)).CornerRadius = UDim.new(0,6)

        local fill = regObj(Instance.new("Frame"))
        fill.Parent = bar
        fill.Size = UDim2.new((init-min)/(max-min), 0, 1, 0)
        fill.BackgroundColor3 = accent
        regObj(Instance.new("UICorner", fill)).CornerRadius = UDim.new(0,6)

        return {
            label = lbl,
            bar = bar,
            fill = fill,
            min = min,
            max = max,
            value = init
        }
    end

    -- Build Player tab content (left column)
    -- Row positions
    local row = 0
    local flyBtn = createToggle(leftCol, row*36, "🕊️ Fly", false); row = row + 1
    local infJumpBtn = createToggle(leftCol, row*36, "🌟 Infinite Jump", false); row = row + 1
    local noclipBtn = createToggle(leftCol, row*36, "👻 Noclip", false); row = row + 1
    local speedSlider = createSlider(leftCol, row*36, "⚡ Speed (WalkSpeed)", 8, 200, 16); row = row + 3

    -- Right column: Teleport input + button + status
    local tpLabel = regObj(Instance.new("TextLabel"))
    tpLabel.Parent = rightCol
    tpLabel.Size = UDim2.new(1, -20, 0, 20)
    tpLabel.Position = UDim2.new(0, 8, 0, 0)
    tpLabel.BackgroundTransparency = 1
    tpLabel.Font = Enum.Font.Gotham
    tpLabel.TextSize = 13
    tpLabel.TextColor3 = textColor
    tpLabel.TextXAlignment = Enum.TextXAlignment.Left
    tpLabel.Text = "📍 Teleport to Player"

    local tpBox = regObj(Instance.new("TextBox"))
    tpBox.Parent = rightCol
    tpBox.Size = UDim2.new(1, -20, 0, 28)
    tpBox.Position = UDim2.new(0, 8, 0, 26)
    tpBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
    tpBox.TextColor3 = textColor
    tpBox.Text = ""
    tpBox.Font = Enum.Font.Gotham
    tpBox.TextSize = 14
    regObj(Instance.new("UICorner", tpBox)).CornerRadius = UDim.new(0,6)

    local tpBtn = regObj(Instance.new("TextButton"))
    tpBtn.Parent = rightCol
    tpBtn.Size = UDim2.new(1, -20, 0, 30)
    tpBtn.Position = UDim2.new(0,8,0,62)
    tpBtn.BackgroundColor3 = accent
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 14
    tpBtn.Text = "🚀 Teleport"
    tpBtn.TextColor3 = Color3.new(1,1,1)
    regObj(Instance.new("UICorner", tpBtn)).CornerRadius = UDim.new(0,6)

    local statusLabel = regObj(Instance.new("TextLabel"))
    statusLabel.Parent = rightCol
    statusLabel.Size = UDim2.new(1, -20, 0, 80)
    statusLabel.Position = UDim2.new(0,8,0,102)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 12
    statusLabel.TextColor3 = textColor
    statusLabel.Text = "Status: Ready"

    -- Server tab content (simple)
    local S_left = regObj(Instance.new("Frame")); S_left.Parent = body; S_left.Size = leftCol.Size; S_left.Position = leftCol.Position; S_left.BackgroundTransparency = 1; S_left.Visible = false
    local S_right = regObj(Instance.new("Frame")); S_right.Parent = body; S_right.Size = rightCol.Size; S_right.Position = rightCol.Position; S_right.BackgroundTransparency = 1; S_right.Visible = false

    local afkBtn = createToggle(S_left, 0, "⏰ Anti-AFK", false)
    local antiLagBtn = createToggle(S_left, 1*36, "🚀 Anti-Lag", false)
    local rejoinBtn = regObj(Instance.new("TextButton"))
    rejoinBtn.Parent = S_right
    rejoinBtn.Size = UDim2.new(1, -20, 0, 30)
    rejoinBtn.Position = UDim2.new(0,8,0,0)
    rejoinBtn.BackgroundColor3 = accent
    rejoinBtn.Font = Enum.Font.GothamBold
    rejoinBtn.TextSize = 14
    rejoinBtn.Text = "⤴ Rejoin Server"
    rejoinBtn.TextColor3 = Color3.new(1,1,1)
    regObj(Instance.new("UICorner", rejoinBtn)).CornerRadius = UDim.new(0,6)

    -- Fun tab (Goon, Dance)
    local F_left = regObj(Instance.new("Frame")); F_left.Parent = body; F_left.Size = leftCol.Size; F_left.Position = leftCol.Position; F_left.BackgroundTransparency = 1; F_left.Visible = false
    local F_right = regObj(Instance.new("Frame")); F_right.Parent = body; F_right.Size = rightCol.Size; F_right.Position = rightCol.Position; F_right.BackgroundTransparency = 1; F_right.Visible = false

    local goonBtn = createToggle(F_left, 0, "😈 Goon Mode", false)
    local danceBtn = createToggle(F_left, 1*36, "💃 Dance Mode", false)

    -- Fight tab (spawn visual tools)
    local U_left = regObj(Instance.new("Frame")); U_left.Parent = body; U_left.Size = leftCol.Size; U_left.Position = leftCol.Position; U_left.BackgroundTransparency = 1; U_left.Visible = false
    local U_right = regObj(Instance.new("Frame")); U_right.Parent = body; U_right.Size = rightCol.Size; U_right.Position = rightCol.Position; U_right.BackgroundTransparency = 1; U_right.Visible = false

    local spawnSwordBtn = regObj(Instance.new("TextButton")); spawnSwordBtn.Parent = U_left; spawnSwordBtn.Size = U_left.Size; spawnSwordBtn.Position = U_left.Position; spawnSwordBtn.BackgroundColor3 = accent; spawnSwordBtn.Text = "⚔️ Spawn Sword"; spawnSwordBtn.Font = Enum.Font.GothamBold; spawnSwordBtn.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", spawnSwordBtn)).CornerRadius = UDim.new(0,6)
    spawnSwordBtn.Size = UDim2.new(1,-20,0,36); spawnSwordBtn.Position = UDim2.new(0,10,0,0)

    local spawnGunBtn = regObj(Instance.new("TextButton")); spawnGunBtn.Parent = U_left; spawnGunBtn.Size = spawnSwordBtn.Size; spawnGunBtn.Position = UDim2.new(0,10,0,46); spawnGunBtn.BackgroundColor3 = accent; spawnGunBtn.Text = "🔫 Spawn Gun"; spawnGunBtn.Font = Enum.Font.GothamBold; spawnGunBtn.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", spawnGunBtn)).CornerRadius = UDim.new(0,6)

    -- Tab switching logic
    local allPanels = {
        Player = {leftCol, rightCol},
        Server = {S_left, S_right},
        Fun = {F_left, F_right},
        Fight = {U_left, U_right},
    }
    local function showTab(name)
        -- hide all
        for _,p in pairs(allPanels) do for _,v in pairs(p) do v.Visible = false end end
        -- show chosen
        local panels = allPanels[name]
        if panels then for _,v in pairs(panels) do v.Visible = true end end
        -- update tab button styles
        for i,btn in ipairs(tabBtns) do
            btn.TextColor3 = (btn.Text == name) and accent or textColor
        end
    end
    showTab("Player")

    for _,btn in ipairs(tabBtns) do
        regConn(btn.MouseButton1Click:Connect(function()
            pcall(function() showTab(btn.Text) end)
        end))
    end

    -- Dragging the frame by titleBar
    do
        local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                regConn(input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end))
            end
        end)
        titleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
        end)
        regConn(UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end))
    end

    -- Floating toggle behavior
    regConn(floatBtn.MouseButton1Click:Connect(function()
        state.menuOpen = not state.menuOpen
        frame.Visible = state.menuOpen
        floatBtn.Text = state.menuOpen and "VIP" or "OPEN"
    end))

    -- Title control buttons
    regConn(btnMinus.MouseButton1Click:Connect(function()
        -- hide menu (minimize to float)
        frame.Visible = false
        state.menuOpen = false
        floatBtn.Text = "OPEN"
    end))
    regConn(btnClose.MouseButton1Click:Connect(function()
        cleanupAll()
    end))
    regConn(btnSquare.MouseButton1Click:Connect(function()
        -- collapse/expand body
        state.bodyCollapsed = not state.bodyCollapsed
        body.Visible = not state.bodyCollapsed
        tabBar.Visible = not state.bodyCollapsed
        if state.bodyCollapsed then
            frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, 64) -- only title
        else
            frame.Size = UDim2.new(0, baseX, 0, baseY)
        end
    end))

    -- ========== Feature logic (client-side) ==========

    -- Helpers to safely get humanoid/hrp
    local function getHumanoid()
        if not character then return nil end
        return character:FindFirstChildOfClass("Humanoid")
    end
    local function getHRP()
        if not character then return nil end
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    end

    -- Fly implementation (BodyVelocity)
    local flyBV, flyHB = nil, nil
    local function setFly(on)
        state.fly = on
        pcall(function()
            if on then
                local hrp = getHRP()
                if not hrp then return end
                if flyBV then pcall(function() flyBV:Destroy() end) end
                flyBV = regObj(Instance.new("BodyVelocity"))
                flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
                flyBV.P = 1e4
                flyBV.Velocity = Vector3.new(0,0,0)
                flyBV.Parent = hrp
                if flyHB then flyHB:Disconnect() end
                flyHB = regConn(RunService.Heartbeat:Connect(function()
                    if not state.fly or not getHRP() then
                        if flyHB then flyHB:Disconnect() end
                        if flyBV then pcall(function() flyBV:Destroy() end) end
                        return
                    end
                    local cam = workspace.CurrentCamera
                    if not cam then return end
                    local forward = Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z)
                    local right = Vector3.new(cam.CFrame.RightVector.X,0,cam.CFrame.RightVector.Z)
                    local dir = Vector3.new(0,0,0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += forward end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= forward end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= right end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += right end
                    local y = 0
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then y = 1 end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then y = -1 end
                    local speed = state.speed or 50
                    if dir.Magnitude > 0 then dir = dir.Unit * speed else dir = Vector3.new(0,0,0) end
                    flyBV.Velocity = Vector3.new(dir.X, y * speed, dir.Z)
                end))
            else
                if flyHB then flyHB:Disconnect() end
                if flyBV then pcall(function() flyBV:Destroy() end) end
                flyHB, flyBV = nil, nil
            end
        end)
    end

    -- Infinite Jump toggle
    local jumpConn = nil
    local function setInfJump(on)
        state.infJump = on
        pcall(function()
            if on then
                if jumpConn then jumpConn:Disconnect() end
                jumpConn = regConn(UserInputService.JumpRequest:Connect(function()
                    if state.infJump and getHumanoid() then
                        pcall(function() local h = getHumanoid(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end)
                    end
                end))
            else
                if jumpConn then jumpConn:Disconnect() end
                jumpConn = nil
            end
        end)
    end

    -- Noclip toggle
    local noclipConn = nil
    local function setNoclip(on)
        state.noclip = on
        pcall(function()
            if on then
                if noclipConn then noclipConn:Disconnect() end
                noclipConn = regConn(RunService.Stepped:Connect(function()
                    if not state.noclip or not character then return end
                    for _,p in ipairs(character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
                end))
            else
                if noclipConn then noclipConn:Disconnect() end
                noclipConn = nil
                if character then for _,p in ipairs(character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
            end
        end)
    end

    -- Speed slider apply (RenderStepped)
    local speedConn = regConn(RunService.RenderStepped:Connect(function()
        local hum = getHumanoid()
        if hum then
            pcall(function() hum.WalkSpeed = state.speed or 16 end)
        end
    end))

    -- Anti-AFK (Player.Idled)
    local afkConn = nil
    local function setAntiAfk(on)
        state.antiAfk = on
        pcall(function()
            if on then
                if afkConn then afkConn:Disconnect() end
                afkConn = regConn(player.Idled:Connect(function()
                    pcall(function()
                        local vu = game:GetService("VirtualUser")
                        vu:CaptureController()
                        vu:ClickButton2(Vector2.new(0,0))
                    end)
                end))
            else
                if afkConn then afkConn:Disconnect() end
                afkConn = nil
            end
        end)
    end

    -- Anti-Lag (reduce effects)
    local antiLagConn = nil
    local savedLighting = {
        Brightness = Lighting.Brightness,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        QualityLevel = (pcall(function() return settings().Rendering.QualityLevel end) and settings().Rendering.QualityLevel) or nil,
    }
    local function setAntiLag(on)
        state.antiLag = on
        pcall(function()
            if on then
                -- save
                savedLighting.Brightness = Lighting.Brightness
                savedLighting.GlobalShadows = Lighting.GlobalShadows
                savedLighting.FogEnd = Lighting.FogEnd
                pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 1e9
                Lighting.Brightness = 1
                if antiLagConn then antiLagConn:Disconnect() end
                antiLagConn = regConn(Workspace.DescendantAdded:Connect(function(desc)
                    if state.antiLag and desc and desc:IsA("BasePart") then
                        pcall(function() desc.Material = Enum.Material.Plastic end)
                    end
                end))
            else
                if antiLagConn then antiLagConn:Disconnect() end
                antiLagConn = nil
                pcall(function()
                    if savedLighting.QualityLevel then pcall(function() settings().Rendering.QualityLevel = savedLighting.QualityLevel end) end
                    Lighting.Brightness = savedLighting.Brightness
                    Lighting.GlobalShadows = savedLighting.GlobalShadows
                    Lighting.FogEnd = savedLighting.FogEnd
                end)
            end
        end)
    end

    -- Rejoin
    local function rejoin()
        pcall(function() TeleportService:Teleport(game.PlaceId) end)
    end

    -- Goon mode (scale up with tween, then restore)
    local storedSizes = {}
    local function setGoon(on)
        state.goon = on
        pcall(function()
            if on then
                storedSizes = {}
                if not character then return end
                for _,p in ipairs(character:GetDescendants()) do
                    if p:IsA("BasePart") then storedSizes[p] = p.Size end
                end
                for p,size in pairs(storedSizes) do
                    if p and p.Parent then
                        pcall(function() TweenService:Create(p, TweenInfo.new(0.18), {Size = size * 1.3}):Play() end)
                    end
                end
            else
                for p,size in pairs(storedSizes) do
                    if p and p.Parent then pcall(function() TweenService:Create(p, TweenInfo.new(0.18), {Size = size}):Play() end) end
                end
                storedSizes = {}
            end
        end)
    end

    -- Dance (play animation)
    local danceTrack = nil
    local function setDance(on)
        state.dance = on
        pcall(function()
            local hum = getHumanoid()
            if on then
                if not hum then return end
                local animator = hum:FindFirstChildOfClass("Animator") or hum:FindFirstChild("Animator")
                if animator then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://181525546"
                    danceTrack = animator:LoadAnimation(anim)
                    danceTrack:Play()
                    regObj(anim)
                end
            else
                if danceTrack then pcall(function() danceTrack:Stop() end) end
                danceTrack = nil
            end
        end)
    end

    -- Spawn visual-only tool helpers
    local function createClientTool(name, source)
        local tool = regObj(Instance.new("Tool"))
        tool.Name = name
        local handle = regObj(Instance.new("Part"))
        handle.Name = "Handle"
        handle.Size = Vector3.new(1,1,1)
        handle.CanCollide = false
        handle.Parent = tool
        tool.Parent = player:FindFirstChild("Backpack") or player.Backpack
        local ls = regObj(Instance.new("LocalScript"))
        ls.Source = source
        ls.Parent = tool
        return tool
    end

    local swordSource = [[
        local tool = script.Parent
        local Tween = game:GetService("TweenService")
        tool.Activated:Connect(function()
            local h = tool:FindFirstChild("Handle"); if not h then return end
            local orig = h.CFrame
            Tween:Create(h, TweenInfo.new(0.12), {CFrame = h.CFrame * CFrame.Angles(-1.2,0,0)}):Play()
            task.wait(0.12)
            Tween:Create(h, TweenInfo.new(0.08), {CFrame = orig}):Play()
            local p = Instance.new("Part", workspace); p.Size = Vector3.new(0.2,0.2,0.2); p.Anchored = true; p.CanCollide = false
            p.CFrame = h.CFrame * CFrame.new(0,-1,-1); p.BrickColor = BrickColor.new("Bright yellow")
            game:GetService("Debris"):AddItem(p, 0.3)
        end)
    ]]
    local gunSource = [[
        local tool = script.Parent
        tool.Activated:Connect(function()
            local plr = game:GetService("Players").LocalPlayer
            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local b = Instance.new("Part", workspace); b.Size = Vector3.new(0.2,0.2,0.2); b.Anchored=false; b.CanCollide=false; b.BrickColor=BrickColor.new("Bright yellow")
            b.CFrame = hrp.CFrame * CFrame.new(0,0,-3); b.Velocity = hrp.CFrame.LookVector * 120
            game:GetService("Debris"):AddItem(b, 3)
        end)
    ]]

    -- Wire UI -> features

    -- Player tab wiring
    regConn(flyBtn.MouseButton1Click:Connect(function()
        local on = not state.fly
        flyBtn.Text = on and "ON" or "OFF"
        flyBtn.BackgroundColor3 = on and Color3.fromRGB(45,180,90) or Color3.fromRGB(100,100,100)
        setFly(on)
    end))

    regConn(infJumpBtn.MouseButton1Click:Connect(function()
        local on = not state.infJump
        infJumpBtn.Text = on and "ON" or "OFF"
        infJumpBtn.BackgroundColor3 = on and Color3.fromRGB(45,180,90) or Color3.fromRGB(100,100,100)
        setInfJump(on)
    end))

    regConn(noclipBtn.MouseButton1Click:Connect(function()
        local on = not state.noclip
        noclipBtn.Text = on and "ON" or "OFF"
        noclipBtn.BackgroundColor3 = on and Color3.fromRGB(45,180,90) or Color3.fromRGB(100,100,100)
        setNoclip(on)
    end))

    -- Speed slider handling
    do
        local dragging = false
        regConn(speedSlider.bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end))
        regConn(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end))
        regConn(UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = UserInputService:GetMouseLocation()
                local abs = speedSlider.bar.AbsolutePosition
                local size = speedSlider.bar.AbsoluteSize
                local rel = math.clamp((pos.X - abs.X) / size.X, 0, 1)
                speedSlider.fill.Size = UDim2.new(rel, 0, 1, 0)
                local val = math.floor(speedSlider.min + rel * (speedSlider.max - speedSlider.min))
                speedSlider.label.Text = "⚡ Speed (WalkSpeed) : "..tostring(val)
                state.speed = val
            end
        end))
    end

    -- Teleport button
    regConn(tpBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local name = tpBox.Text or ""
            if name == "" then
                statusLabel.Text = "Status: Chưa nhập tên!"
                return
            end
            local target = Players:FindFirstChild(name)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = character and character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = target.Character.HumanoidRootPart.CFrame; statusLabel.Text = "Status: Đã teleport đến "..name end
            else
                statusLabel.Text = "Status: Người chơi không tồn tại"
            end
        end)
    end))

    -- Server tab wiring
    regConn(afkBtn.MouseButton1Click:Connect(function()
        local on = not state.antiAfk
        afkBtn.Text = on and "ON" or "OFF"
        afkBtn.BackgroundColor3 = on and Color3.fromRGB(45,180,90) or Color3.fromRGB(100,100,100)
        setAntiAfk(on)
    end))

    regConn(antiLagBtn.MouseButton1Click:Connect(function()
        local on = not state.antiLag
        antiLagBtn.Text = on and "ON" or "OFF"
        antiLagBtn.BackgroundColor3 = on and Color3.fromRGB(45,180,90) or Color3.fromRGB(100,100,100)
        setAntiLag(on)
    end))

    regConn(rejoinBtn.MouseButton1Click:Connect(function() rejoin() end))

    -- Fun tab wiring
    regConn(goonBtn.MouseButton1Click:Connect(function()
        local on = not state.goon
        goonBtn.Text = on and "ON" or "OFF"
        goonBtn.BackgroundColor3 = on and Color3.fromRGB(45,180,90) or Color3.fromRGB(100,100,100)
        setGoon(on)
    end))

    regConn(danceBtn.MouseButton1Click:Connect(function()
        local on = not state.dance
        danceBtn.Text = on and "ON" or "OFF"
        danceBtn.BackgroundColor3 = on and Color3.fromRGB(45,180,90) or Color3.fromRGB(100,100,100)
        setDance(on)
    end))

    -- Fight tab wiring
    regConn(spawnSwordBtn.MouseButton1Click:Connect(function()
        pcall(function() createClientTool("Magic Sword", swordSource) end)
    end))
    regConn(spawnGunBtn.MouseButton1Click:Connect(function()
        pcall(function() createClientTool("Magic Gun", gunSource) end)
    end))

    -- Safety: cleanup on CharacterRemoving and BindToClose
    regConn(player.CharacterRemoving:Connect(function()
        cleanupAll()
    end))
    regConn(game:BindToClose(function() cleanupAll() end))

    -- Start initially hidden? keep visible
    frame.Visible = true
    floatBtn.Text = "VIP"

    -- Notify loaded
    pcall(function()
        local StarterGui = game:GetService("StarterGui")
        StarterGui:SetCore("SendNotification", {Title="DEVIL MENU", Text="Custom menu loaded", Duration=3})
    end)
end)
