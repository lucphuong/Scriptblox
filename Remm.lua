-- DEVIL CUSTOM MENU — Integrations version
pcall(function()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Debris = game:GetService("Debris")
    local Lighting = game:GetService("Lighting")
    local CoreGui = game:GetService("CoreGui")
    local TeleportService = game:GetService("TeleportService")
    local TweenService = game:GetService("TweenService")
    local MarketplaceService = game:GetService("MarketplaceService")

    local player = Players.LocalPlayer
    if not player then return end

    local created = {}
    local connections = {}
    local function regObj(o) if o then table.insert(created, o) end; return o end
    local function regConn(c) if c then table.insert(connections, c) end; return c end
    local function cleanupAll()
        for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        for _,o in ipairs(created) do pcall(function() if o and o.Parent then o:Destroy() end end) end
        connections = {}; created = {}
    end

    local BG = Color3.fromRGB(18,18,18)
    local ACC = Color3.fromRGB(0,150,255)
    local TEXT = Color3.fromRGB(230,230,230)
    local TRANSP = 0.45

    for _, g in ipairs(CoreGui:GetChildren()) do
        if g.Name == "DevilCustomMenu" then pcall(function() g:Destroy() end) end
    end

    local screen = regObj(Instance.new("ScreenGui"))
    screen.Name = "DevilCustomMenu"
    screen.ResetOnSpawn = false
    screen.Parent = CoreGui

    local floatBtn = regObj(Instance.new("TextButton"))
    floatBtn.Name = "DevilToggle"
    floatBtn.Parent = screen
    floatBtn.Size = UDim2.new(0,56,0,48)
    floatBtn.Position = UDim2.new(0, 10, 0, 10)
    floatBtn.BackgroundColor3 = BG
    floatBtn.BackgroundTransparency = 0.6
    floatBtn.Text = "VIP"
    floatBtn.Font = Enum.Font.GothamBold
    floatBtn.TextSize = 14
    floatBtn.TextColor3 = Color3.new(1,1,1)
    regObj(Instance.new("UICorner", floatBtn)).CornerRadius = UDim.new(0,10)

    local baseW, baseH = 460, 400
    local frame = regObj(Instance.new("Frame"))
    frame.Name = "MainWindow"
    frame.Size = UDim2.new(0, baseW, 0, baseH)
    frame.Position = UDim2.new(0.5, -baseW/2, 0.5, -baseH/2)
    frame.BackgroundColor3 = BG
    frame.BackgroundTransparency = TRANSP
    frame.BorderSizePixel = 0
    frame.Parent = screen
    regObj(Instance.new("UICorner", frame)).CornerRadius = UDim.new(0,8)

    local titleBar = regObj(Instance.new("Frame"))
    titleBar.Parent = frame
    titleBar.Size = UDim2.new(1,0,0,32)
    titleBar.Position = UDim2.new(0,0,0,0)
    titleBar.BackgroundTransparency = 1

    local titleLbl = regObj(Instance.new("TextLabel"))
    titleLbl.Parent = titleBar
    titleLbl.Size = UDim2.new(0.6,0,1,0)
    titleLbl.Position = UDim2.new(0,8,0,0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextColor3 = TEXT
    titleLbl.Text = "🔥 VIP MENU"

    local controlFrame = regObj(Instance.new("Frame"))
    controlFrame.Parent = titleBar
    controlFrame.Size = UDim2.new(0.4,-8,1,0)
    controlFrame.Position = UDim2.new(0.6,0,0,0)
    controlFrame.BackgroundTransparency = 1

    local btnMin = regObj(Instance.new("TextButton")); btnMin.Parent = controlFrame; btnMin.Text = "-"; btnMin.Size = UDim2.new(0,28,0,22); btnMin.Position = UDim2.new(1,-96,0,4)
    local btnSquare = regObj(Instance.new("TextButton")); btnSquare.Parent = controlFrame; btnSquare.Text = "□"; btnSquare.Size = UDim2.new(0,28,0,22); btnSquare.Position = UDim2.new(1,-60,0,4)
    local btnClose = regObj(Instance.new("TextButton")); btnClose.Parent = controlFrame; btnClose.Text = "x"; btnClose.Size = UDim2.new(0,28,0,22); btnClose.Position = UDim2.new(1,-24,0,4)

    for _,b in ipairs({btnMin, btnSquare, btnClose}) do
        b.BackgroundColor3 = BG; b.BackgroundTransparency = 0.6; b.Font = Enum.Font.GothamBold; b.TextSize = 14; b.TextColor3 = TEXT
        regObj(Instance.new("UICorner", b)).CornerRadius = UDim.new(0,6)
    end

    local tabBar = regObj(Instance.new("Frame"))
    tabBar.Parent = frame
    tabBar.Size = UDim2.new(1,0,0,36)
    tabBar.Position = UDim2.new(0,0,0,32)
    tabBar.BackgroundTransparency = 1

    local tabNames = {"Player","Server","Fun","Fight","Boombox"}
    local tabButtons = {}
    for i,name in ipairs(tabNames) do
        local btn = regObj(Instance.new("TextButton"))
        btn.Parent = tabBar
        btn.Size = UDim2.new(0,80,1,0)
        btn.Position = UDim2.new(0,(i-1)*80,0,0)
        btn.Text = name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.BackgroundTransparency = 1
        btn.TextColor3 = TEXT
        tabButtons[i] = btn
    end

    local body = regObj(Instance.new("Frame"))
    body.Parent = frame
    body.Position = UDim2.new(0,8,0,76)
    body.Size = UDim2.new(1,-16,1,-84)
    body.BackgroundTransparency = 1

    local leftCol = regObj(Instance.new("Frame")); leftCol.Parent = body; leftCol.Size = UDim2.new(0.5,-8,1,0); leftCol.Position = UDim2.new(0,0,0,0); leftCol.BackgroundTransparency = 1
    local rightCol = regObj(Instance.new("Frame")); rightCol.Parent = body; rightCol.Size = UDim2.new(0.5,-8,1,0); rightCol.Position = UDim2.new(0.5,8,0,0); rightCol.BackgroundTransparency = 1

    local function makeToggle(parent, y, text)
        local lbl = regObj(Instance.new("TextLabel")); lbl.Parent = parent; lbl.Size = UDim2.new(1,-70,0,26); lbl.Position = UDim2.new(0,8,0,y); lbl.BackgroundTransparency = 1; lbl.Font=Enum.Font.Gotham; lbl.TextSize=14; lbl.TextColor3=TEXT; lbl.Text=text; lbl.TextXAlignment=Enum.TextXAlignment.Left
        local btn = regObj(Instance.new("TextButton")); btn.Parent = parent; btn.Size = UDim2.new(0,56,0,24); btn.Position = UDim2.new(1,-64,0,y+1); btn.BackgroundColor3 = Color3.fromRGB(100,100,100); btn.Font=Enum.Font.GothamBold; btn.TextSize=13; btn.Text="OFF"; regObj(Instance.new("UICorner", btn)).CornerRadius = UDim.new(0,6)
        return btn
    end
    local function makeSlider(parent, y, label, min, max, init)
        local lbl = regObj(Instance.new("TextLabel")); lbl.Parent = parent; lbl.Size = UDim2.new(1,-20,0,20); lbl.Position = UDim2.new(0,8,0,y); lbl.BackgroundTransparency = 1; lbl.Font=Enum.Font.Gotham; lbl.TextSize=13; lbl.TextColor3=TEXT; lbl.Text = label.." : "..tostring(init); lbl.TextXAlignment=Enum.TextXAlignment.Left
        local bar = regObj(Instance.new("Frame")); bar.Parent = parent; bar.Size = UDim2.new(1,-20,0,10); bar.Position = UDim2.new(0,10,0,y+22); bar.BackgroundColor3 = Color3.fromRGB(50,50,50); regObj(Instance.new("UICorner", bar)).CornerRadius = UDim.new(0,6)
        local fill = regObj(Instance.new("Frame")); fill.Parent = bar; fill.Size = UDim2.new((init-min)/(max-min),0,1,0); fill.BackgroundColor3 = ACC; regObj(Instance.new("UICorner", fill)).CornerRadius = UDim.new(0,6)
        return {label=lbl, bar=bar, fill=fill, min=min, max=max, value=init}
    end

    local row = 0
    local btnFlyLoad = regObj(Instance.new("TextButton")); btnFlyLoad.Parent = leftCol; btnFlyLoad.Size = UDim2.new(1,-20,0,30); btnFlyLoad.Position = UDim2.new(0,10,0,row*36); btnFlyLoad.BackgroundColor3 = ACC; btnFlyLoad.Font = Enum.Font.GothamBold; btnFlyLoad.TextSize = 14; btnFlyLoad.Text = "Load Fly GUI (external)"; btnFlyLoad.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", btnFlyLoad)).CornerRadius = UDim.new(0,6); row = row + 1
    local btnInfJump = makeToggle(leftCol, row*36, "🌟 Infinite Jump"); row = row + 1
    local btnNoclip = makeToggle(leftCol, row*36, "👻 Noclip"); row = row + 1
    local speedSlider = makeSlider(leftCol, row*36, "⚡ WalkSpeed", 8, 200, 16); row = row + 3

    local tpLabel = regObj(Instance.new("TextLabel")); tpLabel.Parent = rightCol; tpLabel.Size = UDim2.new(1,-20,0,20); tpLabel.Position = UDim2.new(0,8,0,0); tpLabel.BackgroundTransparency = 1; tpLabel.Font = Enum.Font.Gotham; tpLabel.TextSize = 13; tpLabel.TextColor3 = TEXT; tpLabel.Text = "📍 Teleport to Player"
    local tpBox = regObj(Instance.new("TextBox")); tpBox.Parent = rightCol; tpBox.Size = UDim2.new(1,-20,0,28); tpBox.Position = UDim2.new(0,8,0,26); tpBox.BackgroundColor3 = Color3.fromRGB(35,35,35); tpBox.TextColor3 = TEXT; tpBox.Font = Enum.Font.Gotham; tpBox.TextSize = 14; tpBox.Text = ""; regObj(Instance.new("UICorner", tpBox)).CornerRadius = UDim.new(0,6)
    local tpBtn = regObj(Instance.new("TextButton")); tpBtn.Parent = rightCol; tpBtn.Size = UDim2.new(1,-20,0,30); tpBtn.Position = UDim2.new(0,8,0,62); tpBtn.BackgroundColor3 = ACC; tpBtn.Font = Enum.Font.GothamBold; tpBtn.TextSize = 14; tpBtn.Text = "🚀 Teleport"; tpBtn.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", tpBtn)).CornerRadius = UDim.new(0,6)
    local stLabel = regObj(Instance.new("TextLabel")); stLabel.Parent = rightCol; stLabel.Size = UDim2.new(1,-20,0,80); stLabel.Position = UDim2.new(0,8,0,102); stLabel.BackgroundTransparency = 1; stLabel.Font = Enum.Font.Gotham; stLabel.TextSize = 12; stLabel.TextColor3 = TEXT; stLabel.Text = "Status: Ready"

    local S_left = regObj(Instance.new("Frame")); S_left.Parent = body; S_left.Size = leftCol.Size; S_left.Position = leftCol.Position; S_left.BackgroundTransparency = 1; S_left.Visible = false
    local S_right = regObj(Instance.new("Frame")); S_right.Parent = body; S_right.Size = rightCol.Size; S_right.Position = rightCol.Position; S_right.BackgroundTransparency = 1; S_right.Visible = false
    local btnAntiAfk = makeToggle(S_left, 0, "⏰ Anti-AFK")
    local btnAntiLag = makeToggle(S_left, 1*36, "🚀 Anti-Lag")
    local rejoinBtn = regObj(Instance.new("TextButton")); rejoinBtn.Parent = S_right; rejoinBtn.Size = UDim2.new(1,-20,0,30); rejoinBtn.Position = UDim2.new(0,8,0,0); rejoinBtn.BackgroundColor3 = ACC; rejoinBtn.Font = Enum.Font.GothamBold; rejoinBtn.Text = "⤴ Rejoin Server"; rejoinBtn.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", rejoinBtn)).CornerRadius = UDim.new(0,6)

    local F_left = regObj(Instance.new("Frame")); F_left.Parent = body; F_left.Size = leftCol.Size; F_left.Position = leftCol.Position; F_left.BackgroundTransparency = 1; F_left.Visible = false
    local F_right = regObj(Instance.new("Frame")); F_right.Parent = body; F_right.Size = rightCol.Size; F_right.Position = rightCol.Position; F_right.BackgroundTransparency = 1; F_right.Visible = false
    local btnLoadGoon = regObj(Instance.new("TextButton")); btnLoadGoon.Parent = F_left; btnLoadGoon.Size = UDim2.new(1,-20,0,36); btnLoadGoon.Position = UDim2.new(0,10,0,0); btnLoadGoon.BackgroundColor3 = ACC; btnLoadGoon.Font=Enum.Font.GothamBold; btnLoadGoon.Text="Load Goon Script"; btnLoadGoon.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadGoon)).CornerRadius = UDim.new(0,6)
    local btnLoadDance = regObj(Instance.new("TextButton")); btnLoadDance.Parent = F_left; btnLoadDance.Size = UDim2.new(1,-20,0,36); btnLoadDance.Position = UDim2.new(0,10,0,46); btnLoadDance.BackgroundColor3 = ACC; btnLoadDance.Font=Enum.Font.GothamBold; btnLoadDance.Text="Load Dance Script"; btnLoadDance.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadDance)).CornerRadius = UDim.new(0,6)

    local U_left = regObj(Instance.new("Frame")); U_left.Parent = body; U_left.Size = leftCol.Size; U_left.Position = leftCol.Position; U_left.BackgroundTransparency = 1; U_left.Visible = false
    local U_right = regObj(Instance.new("Frame")); U_right.Parent = body; U_right.Size = rightCol.Size; U_right.Position = rightCol.Position; U_right.BackgroundTransparency = 1; U_right.Visible = false
    local btnLoadBang = regObj(Instance.new("TextButton")); btnLoadBang.Parent = U_left; btnLoadBang.Size = U_left.Size; btnLoadBang.Position = U_left.Position; btnLoadBang.BackgroundColor3 = ACC; btnLoadBang.Font=Enum.Font.GothamBold; btnLoadBang.Text="Load Bang GUI"; btnLoadBang.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadBang)).CornerRadius = UDim.new(0,6)
    btnLoadBang.Size = UDim2.new(1,-20,0,36); btnLoadBang.Position = UDim2.new(0,10,0,0)
    local btnLoadDriver = regObj(Instance.new("TextButton")); btnLoadDriver.Parent = U_left; btnLoadDriver.Size = btnLoadBang.Size; btnLoadDriver.Position = UDim2.new(0,10,0,46); btnLoadDriver.BackgroundColor3 = ACC; btnLoadDriver.Font=Enum.Font.GothamBold; btnLoadDriver.Text="Load Driver Car"; btnLoadDriver.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadDriver)).CornerRadius = UDim.new(0,6)
    local btnLoadGun = regObj(Instance.new("TextButton")); btnLoadGun.Parent = U_left; btnLoadGun.Size = btnLoadBang.Size; btnLoadGun.Position = UDim2.new(0,10,0,92); btnLoadGun.BackgroundColor3 = ACC; btnLoadGun.Font=Enum.Font.GothamBold; btnLoadGun.Text="Load Gun Script"; btnLoadGun.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadGun)).CornerRadius = UDim.new(0,6)
    local btnLoadSword = regObj(Instance.new("TextButton")); btnLoadSword.Parent = U_left; btnLoadSword.Size = btnLoadBang.Size; btnLoadSword.Position = UDim2.new(0,10,0,138); btnLoadSword.BackgroundColor3 = ACC; btnLoadSword.Font=Enum.Font.GothamBold; btnLoadSword.Text="Load Sword Script"; btnLoadSword.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadSword)).CornerRadius = UDim.new(0,6)
    local btnLoadLaser = regObj(Instance.new("TextButton")); btnLoadLaser.Parent = U_left; btnLoadLaser.Size = btnLoadBang.Size; btnLoadLaser.Position = UDim2.new(0,10,0,184); btnLoadLaser.BackgroundColor3 = ACC; btnLoadLaser.Font=Enum.Font.GothamBold; btnLoadLaser.Text="Load Laser Gun"; btnLoadLaser.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadLaser)).CornerRadius = UDim.new(0,6)

    local B_left = regObj(Instance.new("Frame")); B_left.Parent = body; B_left.Size = leftCol.Size; B_left.Position = leftCol.Position; B_left.BackgroundTransparency = 1; B_left.Visible = false
    local B_right = regObj(Instance.new("Frame")); B_right.Parent = body; B_right.Size = rightCol.Size; B_right.Position = rightCol.Position; B_right.BackgroundTransparency = 1; B_right.Visible = false

    local boomboxIdLabel = regObj(Instance.new("TextLabel")); boomboxIdLabel.Parent = B_left; boomboxIdLabel.Size = UDim2.new(1,-20,0,20); boomboxIdLabel.Position = UDim2.new(0,8,0,0); boomboxIdLabel.BackgroundTransparency = 1; boomboxIdLabel.Font = Enum.Font.Gotham; boomboxIdLabel.TextSize = 13; boomboxIdLabel.TextColor3 = TEXT; boomboxIdLabel.Text = "🎵 Audio ID:"
    local boomboxIdBox = regObj(Instance.new("TextBox")); boomboxIdBox.Parent = B_left; boomboxIdBox.Size = UDim2.new(1,-20,0,28); boomboxIdBox.Position = UDim2.new(0,8,0,26); boomboxIdBox.BackgroundColor3 = Color3.fromRGB(35,35,35); boomboxIdBox.TextColor3 = TEXT; boomboxIdBox.Font = Enum.Font.Gotham; boomboxIdBox.TextSize = 14; boomboxIdBox.Text = "Enter Audio ID"; boomboxIdBox.PlaceholderText = "Enter Audio ID"; regObj(Instance.new("UICorner", boomboxIdBox)).CornerRadius = UDim.new(0,6)
    
    local boomboxVolumeLabel = regObj(Instance.new("TextLabel")); boomboxVolumeLabel.Parent = B_left; boomboxVolumeLabel.Size = UDim2.new(1,-20,0,20); boomboxVolumeLabel.Position = UDim2.new(0,8,0,70); boomboxVolumeLabel.BackgroundTransparency = 1; boomboxVolumeLabel.Font = Enum.Font.Gotham; boomboxVolumeLabel.TextSize = 13; boomboxVolumeLabel.TextColor3 = TEXT; boomboxVolumeLabel.Text = "🔊 Volume: 5"
    local boomboxVolumeSlider = makeSlider(B_left, 90, "🔊 Volume", 1, 10, 5)
    
    local boomboxPlayBtn = regObj(Instance.new("TextButton")); boomboxPlayBtn.Parent = B_left; boomboxPlayBtn.Size = UDim2.new(1,-20,0,36); boomboxPlayBtn.Position = UDim2.new(0,8,0,140); boomboxPlayBtn.BackgroundColor3 = Color3.fromRGB(45,180,90); boomboxPlayBtn.Font = Enum.Font.GothamBold; boomboxPlayBtn.TextSize = 14; boomboxPlayBtn.Text = "▶️ Play Audio"; boomboxPlayBtn.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", boomboxPlayBtn)).CornerRadius = UDim.new(0,6)
    
    local boomboxStopBtn = regObj(Instance.new("TextButton")); boomboxStopBtn.Parent = B_left; boomboxStopBtn.Size = UDim2.new(1,-20,0,36); boomboxStopBtn.Position = UDim2.new(0,8,0,186); boomboxStopBtn.BackgroundColor3 = Color3.fromRGB(180,45,45); boomboxStopBtn.Font = Enum.Font.GothamBold; boomboxStopBtn.TextSize = 14; boomboxStopBtn.Text = "⏹️ Stop Audio"; boomboxStopBtn.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", boomboxStopBtn)).CornerRadius = UDim.new(0,6)

    local popularLabel = regObj(Instance.new("TextLabel")); popularLabel.Parent = B_right; popularLabel.Size = UDim2.new(1,-20,0,20); popularLabel.Position = UDim2.new(0,8,0,0); popularLabel.BackgroundTransparency = 1; popularLabel.Font = Enum.Font.GothamBold; popularLabel.TextSize = 14; popularLabel.TextColor3 = TEXT; popularLabel.Text = "🎶 Popular Songs:"
    
    local popularSongs = {
        {"Megalovania", 1382096109},
        {"Gangnam Style", 27697743},
        {"Never Gonna Give You Up", 459876374},
        {"All Star", 459876301},
        {"Numb", 459876466},
        {"In the End", 459876433},
        {"Bad Guy", 459876588},
        {"Old Town Road", 459876655},
        {"Astronaut in the Ocean", 7148738332},
        {"Stay", 7148738444}
    }
    
    local songButtons = {}
    for i, song in ipairs(popularSongs) do
        local btn = regObj(Instance.new("TextButton"))
        btn.Parent = B_right
        btn.Size = UDim2.new(1,-20,0,28)
        btn.Position = UDim2.new(0,8,0,30 + (i-1)*34)
        btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.TextColor3 = TEXT
        btn.Text = song[1]
        regObj(Instance.new("UICorner", btn)).CornerRadius = UDim.new(0,4)
        
        songButtons[i] = {button = btn, id = song[2]}
    end

    local boomboxStatus = regObj(Instance.new("TextLabel")); boomboxStatus.Parent = B_right; boomboxStatus.Size = UDim2.new(1,-20,0,40); boomboxStatus.Position = UDim2.new(0,8,1,-50); boomboxStatus.BackgroundTransparency = 1; boomboxStatus.Font = Enum.Font.Gotham; boomboxStatus.TextSize = 12; boomboxStatus.TextColor3 = TEXT; boomboxStatus.Text = "Status: Ready"; boomboxStatus.TextWrapped = true

    local panels = {
        Player = {leftCol, rightCol},
        Server = {S_left, S_right},
        Fun = {F_left, F_right},
        Fight = {U_left, U_right},
        Boombox = {B_left, B_right}
    }
    local function showTab(name)
        for _,v in pairs(panels) do for _,frame in ipairs(v) do frame.Visible = false end end
        local p = panels[name]
        if p then for _,frame in ipairs(p) do frame.Visible = true end end
        for _,b in ipairs(tabButtons) do b.TextColor3 = (b.Text == name) and ACC or TEXT end
    end
    showTab("Player")
    for _,b in ipairs(tabButtons) do regConn(b.MouseButton1Click:Connect(function() pcall(function() showTab(b.Text) end) end)) end

    do
        local dragging = false
        local dragInput, dragStart, startPos

        regConn(titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                regConn(input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end))
            end
        end))

        regConn(titleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end))

        regConn(UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end))
    end

    regConn(btnMin.MouseButton1Click:Connect(function()
        frame.Visible = false; floatBtn.Text = "OPEN"
    end))
    regConn(btnClose.MouseButton1Click:Connect(function() cleanupAll() end))
    regConn(btnSquare.MouseButton1Click:Connect(function()
        body.Visible = not body.Visible
        tabBar.Visible = not tabBar.Visible
        if not body.Visible then frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, 64) else frame.Size = UDim2.new(0, baseW, 0, baseH) end
    end))

    regConn(floatBtn.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
        floatBtn.Text = frame.Visible and "VIP" or "OPEN"
    end))

    local function getHumanoid()
        if not player.Character then return nil end
        return player.Character:FindFirstChildOfClass("Humanoid")
    end
    local function getHRP()
        if not player.Character then return nil end
        return player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
    end

    local jumpConn = nil
    local function setInfJump(on)
        if on then
            if jumpConn then jumpConn:Disconnect() end
            jumpConn = regConn(UserInputService.JumpRequest:Connect(function()
                pcall(function()
                    local h = getHumanoid()
                    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
                end)
            end))
        else
            if jumpConn then jumpConn:Disconnect() end
            jumpConn = nil
        end
    end

    local noclipConn = nil
    local function setNoclip(on)
        if on then
            if noclipConn then noclipConn:Disconnect() end
            noclipConn = regConn(RunService.Stepped:Connect(function()
                pcall(function()
                    local char = player.Character
                    if not char then return end
                    for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
                end)
            end))
        else
            if noclipConn then noclipConn:Disconnect() end; noclipConn = nil
            pcall(function()
                local char = player.Character
                if not char then return end
                for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
            end)
        end
    end

    regConn(RunService.RenderStepped:Connect(function()
        pcall(function()
            local h = getHumanoid()
            if h then h.WalkSpeed = tonumber(speedSlider.value) or 16 end
        end)
    end))

    local afkConn = nil
    local function setAntiAfk(on)
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
            if afkConn then afkConn:Disconnect() end; afkConn = nil
        end
    end

    local antiLagConn = nil
    local function setAntiLag(on)
        if on then
            pcall(function()
                pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 1e9
                Lighting.Brightness = 1
                if antiLagConn then antiLagConn:Disconnect() end
                antiLagConn = regConn(Workspace.DescendantAdded:Connect(function(desc)
                    if desc:IsA("BasePart") then
                        pcall(function() desc.Material = Enum.Material.Plastic end)
                    end
                end))
            end)
        else
            if antiLagConn then antiLagConn:Disconnect() end; antiLagConn = nil
        end
    end

    local currentSound = nil
    local function playAudio(id, volume)
        pcall(function()
            if currentSound then
                currentSound:Stop()
                currentSound:Destroy()
                currentSound = nil
            end
            
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. tostring(id)
            sound.Volume = volume or 5
            sound.Looped = false
            sound.Parent = workspace
            sound:Play()
            
            currentSound = sound
            boomboxStatus.Text = "Status: Playing ID " .. tostring(id)
        end)
    end

    local function stopAudio()
        pcall(function()
            if currentSound then
                currentSound:Stop()
                currentSound:Destroy()
                currentSound = nil
                boomboxStatus.Text = "Status: Stopped"
            end
        end)
    end

    regConn(boomboxPlayBtn.MouseButton1Click:Connect(function()
        local id = tonumber(boomboxIdBox.Text)
        if not id then
            boomboxStatus.Text = "⚠️ Invalid ID!"
            return
        end
        local vol = math.clamp(boomboxVolumeSlider.value or 5, 1, 10)
        playAudio(id, vol)
    end))

    regConn(boomboxStopBtn.MouseButton1Click:Connect(function()
        stopAudio()
    end))

    for _, song in ipairs(songButtons) do
        regConn(song.button.MouseButton1Click:Connect(function()
            boomboxIdBox.Text = tostring(song.id)
            playAudio(song.id, math.clamp(boomboxVolumeSlider.value or 5, 1, 10))
        end))
    end

    do
        local dragging = false
        regConn(boomboxVolumeSlider.bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end))
        regConn(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end))
        regConn(UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = UserInputService:GetMouseLocation()
                local abs = boomboxVolumeSlider.bar.AbsolutePosition
                local size = boomboxVolumeSlider.bar.AbsoluteSize
                local rel = math.clamp((pos.X - abs.X) / size.X, 0, 1)
                boomboxVolumeSlider.fill.Size = UDim2.new(rel,0,1,0)
                local val = math.floor(boomboxVolumeSlider.min + rel * (boomboxVolumeSlider.max - boomboxVolumeSlider.min))
                boomboxVolumeLabel.Text = "🔊 Volume: "..tostring(val)
                boomboxVolumeSlider.value = val
                
                if currentSound then
                    currentSound.Volume = val
                end
            end
        end))
    end

    local function fixLagCleanup()
        pcall(function()
            local removed = 0
            local patterns = {"CompiledModel","Compiled","Temp","GoonFragment","Fragment","DebugModel","_MAP","__MAP"}
            for _,obj in ipairs(workspace:GetChildren()) do
                local name = obj.Name:lower()
                for _,pat in ipairs(patterns) do
                    if string.find(name, pat:lower()) then
                        pcall(function() obj:Destroy() end)
                        removed = removed + 1
                        break
                    end
                end
                if obj:IsA("Model") then
                    local count = #obj:GetDescendants()
                    if count > 400 then
                        pcall(function() obj:Destroy() end)
                        removed = removed + 1
                    end
                end
            end
            for _,v in ipairs(Lighting:GetChildren()) do
                if v.ClassName == "Sky" or v.ClassName == "BloomEffect" or v.ClassName == "SunRaysEffect" or v.ClassName == "ColorCorrectionEffect" then
                    pcall(function() v:Destroy() end)
                end
            end
            pcall(function()
                local StarterGui = game:GetService("StarterGui")
                StarterGui:SetCore("SendNotification", {Title="DEVIL MENU", Text="Fix-Lag: removed "..tostring(removed).." objects and cleared sky effects", Duration=4})
            end)
        end)
    end

    local function rejoinServer()
        pcall(function() TeleportService:Teleport(game.PlaceId) end)
    end

    local function safeLoad(url)
        return pcall(function()
            local code = game:HttpGet(url)
            if not code or code == "" then error("Empty code") end
            local fok, ferr = pcall(function() loadstring(code)() end)
            if not fok then error(ferr) end
        end)
    end

    local urls = {
        FlyGuiV3 = "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt",
        Goon = "https://pastefy.app/lawnvcTT/raw",
        Dance = "https://pastebin.com/raw/0MLPL32f",
        Bang = "https://raw.githubusercontent.com/4gh9/Bang-Script-Gui/main/bang%20gui.lua",
        DriverCar = "https://raw.githubusercontent.com/AstraOutlight/my-scripts/refs/heads/main/fe%20car%20v3",
        Gun = "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/AK-47",
        Sword = "https://raw.githubusercontent.com/lucphuong/Scriptblox/refs/heads/main/sword-replacement.lua",
        Laser = "https://raw.githubusercontent.com/yourplaceholder/laser/main/laser.lua",
        Shader = "https://raw.githubusercontent.com/p0e1/1/refs/heads/main/SimpleShader.lua",
    }

    regConn(btnFlyLoad.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Loading Fly GUI..."
            local ok,err = safeLoad(urls.FlyGuiV3)
            if ok then stLabel.Text = "Status: Fly GUI loaded." else stLabel.Text = "Status: Fly load failed"; warn("Fly load error", err) end
        end)
    end))

    regConn(btnInfJump.MouseButton1Click:Connect(function()
        local on = (btnInfJump.Text == "OFF")
        btnInfJump.Text = on and "ON" or "OFF"
        btnInfJump.BackgroundColor3 = on and Color3.fromRGB(45,180,90) or Color3.fromRGB(100,100,100)
        setInfJump(on)
    end))

    regConn(btnNoclip.MouseButton1Click:Connect(function()
        local on = (btnNoclip.Text == "OFF")
        btnNoclip.Text = on and "ON" or "OFF"
        btnNoclip.BackgroundColor3 = on and Color3.fromRGB(45,180,90) or Color3.fromRGB(100,100,100)
        setNoclip(on)
    end))

    do
        local dragging = false
        regConn(speedSlider.bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
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
                speedSlider.fill.Size = UDim2.new(rel,0,1,0)
                local val = math.floor(speedSlider.min + rel * (speedSlider.max - speedSlider.min))
                speedSlider.label.Text = "⚡ WalkSpeed : "..tostring(val)
                speedSlider.value = val
            end
        end))
    end

    regConn(tpBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local name = tpBox.Text or ""
            if name == "" then stLabel.Text = "Status: Enter player name" return end
            local t = Players:FindFirstChild(name)
            if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame
                stLabel.Text = "Status: Teleported to "..name
            else stLabel.Text = "Status: Player not found" end
        end)
    end))

    regConn(btnAntiAfk.MouseButton1Click:Connect(function()
        local on = (btnAntiAfk.Text == "OFF")
        btnAntiAfk.Text = on and "ON" or "OFF"
        btnAntiAfk.BackgroundColor3 = on and Color3.fromRGB(45,180,90) or Color3.fromRGB(100,100,100)
        setAntiAfk(on)
    end))

    regConn(btnAntiLag.MouseButton1Click:Connect(function()
        local on = (btnAntiLag.Text == "OFF")
        btnAntiLag.Text = on and "ON" or "OFF"
        btnAntiLag.BackgroundColor3 = on and Color3.fromRGB(45,180,90) or Color3.fromRGB(100,100,100)
        setAntiLag(on)
    end))

    regConn(rejoinBtn.MouseButton1Click:Connect(function() pcall(function() rejoinServer() end) end))

    regConn(btnLoadGoon.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Loading Goon..."
            local ok,err = safeLoad(urls.Goon)
            stLabel.Text = ok and "Status: Goon loaded" or "Status: Goon failed"
            if not ok then warn("Goon load error", err) end
        end)
    end))
    regConn(btnLoadDance.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Loading Dance..."
            local ok,err = safeLoad(urls.Dance)
            stLabel.Text = ok and "Status: Dance loaded" or "Status: Dance failed"
            if not ok then warn("Dance load error", err) end
        end)
    end))

    regConn(btnLoadBang.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Loading Bang GUI..."
            local ok,err = safeLoad(urls.Bang)
            stLabel.Text = ok and "Status: Bang loaded" or "Status: Bang failed"
            if not ok then warn("Bang load error", err) end
        end)
    end))
    regConn(btnLoadDriver.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Loading Driver Car..."
            local ok,err = safeLoad(urls.DriverCar)
            stLabel.Text = ok and "Status: Driver loaded" or "Status: Driver failed"
            if not ok then warn("Driver load error", err) end
        end)
    end))
    regConn(btnLoadGun.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Loading Gun..."
            local ok,err = safeLoad(urls.Gun)
            stLabel.Text = ok and "Status: Gun loaded" or "Status: Gun failed"
            if not ok then warn("Gun load error", err) end
        end)
    end))
    regConn(btnLoadSword.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Loading Sword..."
            local ok,err = safeLoad(urls.Sword)
            stLabel.Text = ok and "Status: Sword loaded" or "Status: Sword failed (check URL)"
            if not ok then warn("Sword load error", err) end
        end)
    end))
    regConn(btnLoadLaser.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Loading Laser..."
            local ok,err = safeLoad(urls.Laser)
            stLabel.Text = ok and "Status: Laser loaded" or "Status: Laser failed"
            if not ok then warn("Laser load error", err) end
        end)
    end))

    local fixBtn = regObj(Instance.new("TextButton")); fixBtn.Parent = S_right; fixBtn.Size = UDim2.new(1,-20,0,36); fixBtn.Position = UDim2.new(0,8,0,40); fixBtn.BackgroundColor3 = ACC; fixBtn.Font = Enum.Font.GothamBold; fixBtn.Text="Fix-Lag (clean workspace & sky)"; fixBtn.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", fixBtn)).CornerRadius = UDim.new(0,6)
    regConn(fixBtn.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Running Fix-Lag..."
            fixLagCleanup()
            stLabel.Text = "Status: Fix-Lag complete"
        end)
    end))

    local shaderBtn = regObj(Instance.new("TextButton")); shaderBtn.Parent = S_right; shaderBtn.Size = UDim2.new(1,-20,0,36); shaderBtn.Position = UDim2.new(0,8,0,84); shaderBtn.BackgroundColor3 = ACC; shaderBtn.Font = Enum.Font.GothamBold; shaderBtn.Text="Load Shader (client)"; shaderBtn.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", shaderBtn)).CornerRadius = UDim.new(0,6)
    regConn(shaderBtn.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Loading Shader..."
            local ok,err = safeLoad(urls.Shader)
            stLabel.Text = ok and "Status: Shader loaded" or "Status: Shader failed"
            if not ok then warn("Shader load error", err) end
        end)
    end))

    local loadAllBtn = regObj(Instance.new("TextButton")); loadAllBtn.Parent = U_right; loadAllBtn.Size = U_right.Size; loadAllBtn.Position = U_right.Position; loadAllBtn.BackgroundColor3 = ACC; loadAllBtn.Font = Enum.Font.GothamBold; loadAllBtn.Text="Load All Fight Scripts"; loadAllBtn.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", loadAllBtn)).CornerRadius = UDim.new(0,6)
    loadAllBtn.Size = UDim2.new(1,-20,0,36); loadAllBtn.Position = UDim2.new(0,8,0,0)
    regConn(loadAllBtn.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Loading all fight scripts..."
            safeLoad(urls.Bang)
            safeLoad(urls.DriverCar)
            safeLoad(urls.Gun)
            safeLoad(urls.Sword)
            safeLoad(urls.Laser)
            stLabel.Text = "Status: Finished loading fight scripts (see console for errors)"
        end)
    end))

    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title="DEVIL MENU", Text="Custom menu loaded (integrations + Boombox)", Duration=3}) end)

    regConn(player.CharacterRemoving:Connect(function() cleanupAll() end))
    regConn(game:BindToClose(function() cleanupAll() end))
end)
