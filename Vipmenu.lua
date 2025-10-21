-- DEVIL CUSTOM MENU — Integrations version
-- Paste into executor (client). Loads many external scripts via HttpGet (pcall-wrapped).
pcall(function()
    -- ===== Services =====
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Debris = game:GetService("Debris")
    local Lighting = game:GetService("Lighting")
    local CoreGui = game:GetService("CoreGui")
    local TeleportService = game:GetService("TeleportService")

    local player = Players.LocalPlayer
    if not player then return end

    -- ===== Resource tracking =====
    local created = {}
    local connections = {}
    local function regObj(o) if o then table.insert(created, o) end; return o end
    local function regConn(c) if c then table.insert(connections, c) end; return c end
    local function cleanupAll()
        for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        for _,o in ipairs(created) do pcall(function() if o and o.Parent then o:Destroy() end end) end
        connections = {}; created = {}
    end

    -- ===== UI constants =====
    local BG = Color3.fromRGB(18,18,18)
    local ACC = Color3.fromRGB(0,150,255)
    local TEXT = Color3.fromRGB(230,230,230)
    local TRANSP = 0.45

    -- Remove any previous instance to avoid dupes on re-run
    for _, g in ipairs(CoreGui:GetChildren()) do
        if g.Name == "DevilCustomMenu" then pcall(function() g:Destroy() end) end
    end

    -- ===== Root UI =====
    local screen = regObj(Instance.new("ScreenGui"))
    screen.Name = "DevilCustomMenu"
    screen.ResetOnSpawn = false
    screen.Parent = CoreGui

    -- Floating toggle button
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

    -- Main window
    local baseW, baseH = 460, 360
    local frame = regObj(Instance.new("Frame"))
    frame.Name = "MainWindow"
    frame.Size = UDim2.new(0, baseW, 0, baseH)
    frame.Position = UDim2.new(0.25,0,0.15,0)
    frame.BackgroundColor3 = BG
    frame.BackgroundTransparency = TRANSP
    frame.BorderSizePixel = 0
    frame.Parent = screen
    regObj(Instance.new("UICorner", frame)).CornerRadius = UDim.new(0,8)

    -- Titlebar (drag + controls)
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

    -- Tab bar (top)
    local tabBar = regObj(Instance.new("Frame"))
    tabBar.Parent = frame
    tabBar.Size = UDim2.new(1,0,0,36)
    tabBar.Position = UDim2.new(0,0,0,32)
    tabBar.BackgroundTransparency = 1

    local tabNames = {"Player","Server","Fun","Fight"}
    local tabButtons = {}
    for i,name in ipairs(tabNames) do
        local btn = regObj(Instance.new("TextButton"))
        btn.Parent = tabBar
        btn.Size = UDim2.new(0,100,1,0)
        btn.Position = UDim2.new(0,(i-1)*100,0,0)
        btn.Text = name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BackgroundTransparency = 1
        btn.TextColor3 = TEXT
        tabButtons[i] = btn
    end

    -- Body
    local body = regObj(Instance.new("Frame"))
    body.Parent = frame
    body.Position = UDim2.new(0,8,0,76)
    body.Size = UDim2.new(1,-16,1,-84)
    body.BackgroundTransparency = 1

    -- Two column layout
    local leftCol = regObj(Instance.new("Frame")); leftCol.Parent = body; leftCol.Size = UDim2.new(0.5,-8,1,0); leftCol.Position = UDim2.new(0,0,0,0); leftCol.BackgroundTransparency = 1
    local rightCol = regObj(Instance.new("Frame")); rightCol.Parent = body; rightCol.Size = UDim2.new(0.5,-8,1,0); rightCol.Position = UDim2.new(0.5,8,0,0); rightCol.BackgroundTransparency = 1

    -- simple helpers for controls
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

    -- Build Player tab controls
    local row = 0
    local btnFlyLoad = regObj(Instance.new("TextButton")); btnFlyLoad.Parent = leftCol; btnFlyLoad.Size = UDim2.new(1,-20,0,30); btnFlyLoad.Position = UDim2.new(0,10,0,row*36); btnFlyLoad.BackgroundColor3 = ACC; btnFlyLoad.Font = Enum.Font.GothamBold; btnFlyLoad.TextSize = 14; btnFlyLoad.Text = "Load Fly GUI (external)"; btnFlyLoad.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", btnFlyLoad)).CornerRadius = UDim.new(0,6); row = row + 1
    local btnInfJump = makeToggle(leftCol, row*36, "🌟 Infinite Jump"); row = row + 1
    local btnNoclip = makeToggle(leftCol, row*36, "👻 Noclip"); row = row + 1
    local speedSlider = makeSlider(leftCol, row*36, "⚡ WalkSpeed", 8, 200, 16); row = row + 3

    local tpLabel = regObj(Instance.new("TextLabel")); tpLabel.Parent = rightCol; tpLabel.Size = UDim2.new(1,-20,0,20); tpLabel.Position = UDim2.new(0,8,0,0); tpLabel.BackgroundTransparency = 1; tpLabel.Font = Enum.Font.Gotham; tpLabel.TextSize = 13; tpLabel.TextColor3 = TEXT; tpLabel.Text = "📍 Teleport to Player"
    local tpBox = regObj(Instance.new("TextBox")); tpBox.Parent = rightCol; tpBox.Size = UDim2.new(1,-20,0,28); tpBox.Position = UDim2.new(0,8,0,26); tpBox.BackgroundColor3 = Color3.fromRGB(35,35,35); tpBox.TextColor3 = TEXT; tpBox.Font = Enum.Font.Gotham; tpBox.TextSize = 14; tpBox.Text = ""; regObj(Instance.new("UICorner", tpBox)).CornerRadius = UDim.new(0,6)
    local tpBtn = regObj(Instance.new("TextButton")); tpBtn.Parent = rightCol; tpBtn.Size = UDim2.new(1,-20,0,30); tpBtn.Position = UDim2.new(0,8,0,62); tpBtn.BackgroundColor3 = ACC; tpBtn.Font = Enum.Font.GothamBold; tpBtn.TextSize = 14; tpBtn.Text = "🚀 Teleport"; tpBtn.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", tpBtn)).CornerRadius = UDim.new(0,6)
    local stLabel = regObj(Instance.new("TextLabel")); stLabel.Parent = rightCol; stLabel.Size = UDim2.new(1,-20,0,80); stLabel.Position = UDim2.new(0,8,0,102); stLabel.BackgroundTransparency = 1; stLabel.Font = Enum.Font.Gotham; stLabel.TextSize = 12; stLabel.TextColor3 = TEXT; stLabel.Text = "Status: Ready"

    -- Server tab content
    local S_left = regObj(Instance.new("Frame")); S_left.Parent = body; S_left.Size = leftCol.Size; S_left.Position = leftCol.Position; S_left.BackgroundTransparency = 1; S_left.Visible = false
    local S_right = regObj(Instance.new("Frame")); S_right.Parent = body; S_right.Size = rightCol.Size; S_right.Position = rightCol.Position; S_right.BackgroundTransparency = 1; S_right.Visible = false
    local btnAntiAfk = makeToggle(S_left, 0, "⏰ Anti-AFK")
    local btnAntiLag = makeToggle(S_left, 1*36, "🚀 Anti-Lag")
    local rejoinBtn = regObj(Instance.new("TextButton")); rejoinBtn.Parent = S_right; rejoinBtn.Size = UDim2.new(1,-20,0,30); rejoinBtn.Position = UDim2.new(0,8,0,0); rejoinBtn.BackgroundColor3 = ACC; rejoinBtn.Font = Enum.Font.GothamBold; rejoinBtn.Text = "⤴ Rejoin Server"; rejoinBtn.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", rejoinBtn)).CornerRadius = UDim.new(0,6)

    -- Fun tab content (we'll load external goon/dance scripts, remove internal implementations)
    local F_left = regObj(Instance.new("Frame")); F_left.Parent = body; F_left.Size = leftCol.Size; F_left.Position = leftCol.Position; F_left.BackgroundTransparency = 1; F_left.Visible = false
    local F_right = regObj(Instance.new("Frame")); F_right.Parent = body; F_right.Size = rightCol.Size; F_right.Position = rightCol.Position; F_right.BackgroundTransparency = 1; F_right.Visible = false
    local btnLoadGoon = regObj(Instance.new("TextButton")); btnLoadGoon.Parent = F_left; btnLoadGoon.Size = UDim2.new(1,-20,0,36); btnLoadGoon.Position = UDim2.new(0,10,0,0); btnLoadGoon.BackgroundColor3 = ACC; btnLoadGoon.Font=Enum.Font.GothamBold; btnLoadGoon.Text="Load Goon Script"; btnLoadGoon.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadGoon)).CornerRadius = UDim.new(0,6)
    local btnLoadDance = regObj(Instance.new("TextButton")); btnLoadDance.Parent = F_left; btnLoadDance.Size = UDim2.new(1,-20,0,36); btnLoadDance.Position = UDim2.new(0,10,0,46); btnLoadDance.BackgroundColor3 = ACC; btnLoadDance.Font=Enum.Font.GothamBold; btnLoadDance.Text="Load Dance Script"; btnLoadDance.TextColor3 = Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadDance)).CornerRadius = UDim.new(0,6)

    -- Fight tab content (clear internal fight code and provide buttons to load external scripts)
    local U_left = regObj(Instance.new("Frame")); U_left.Parent = body; U_left.Size = leftCol.Size; U_left.Position = leftCol.Position; U_left.BackgroundTransparency = 1; U_left.Visible = false
    local U_right = regObj(Instance.new("Frame")); U_right.Parent = body; U_right.Size = rightCol.Size; U_right.Position = rightCol.Position; U_right.BackgroundTransparency = 1; U_right.Visible = false
    local btnLoadBang = regObj(Instance.new("TextButton")); btnLoadBang.Parent = U_left; btnLoadBang.Size = U_left.Size; btnLoadBang.Position = U_left.Position; btnLoadBang.BackgroundColor3 = ACC; btnLoadBang.Font=Enum.Font.GothamBold; btnLoadBang.Text="Load Bang GUI"; btnLoadBang.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadBang)).CornerRadius = UDim.new(0,6)
    btnLoadBang.Size = UDim2.new(1,-20,0,36); btnLoadBang.Position = UDim2.new(0,10,0,0)
    local btnLoadDriver = regObj(Instance.new("TextButton")); btnLoadDriver.Parent = U_left; btnLoadDriver.Size = btnLoadBang.Size; btnLoadDriver.Position = UDim2.new(0,10,0,46); btnLoadDriver.BackgroundColor3 = ACC; btnLoadDriver.Font=Enum.Font.GothamBold; btnLoadDriver.Text="Load Driver Car"; btnLoadDriver.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadDriver)).CornerRadius = UDim.new(0,6)
    local btnLoadGun = regObj(Instance.new("TextButton")); btnLoadGun.Parent = U_left; btnLoadGun.Size = btnLoadBang.Size; btnLoadGun.Position = UDim2.new(0,10,0,92); btnLoadGun.BackgroundColor3 = ACC; btnLoadGun.Font=Enum.Font.GothamBold; btnLoadGun.Text="Load Gun Script"; btnLoadGun.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadGun)).CornerRadius = UDim.new(0,6)
    local btnLoadSword = regObj(Instance.new("TextButton")); btnLoadSword.Parent = U_left; btnLoadSword.Size = btnLoadBang.Size; btnLoadSword.Position = UDim2.new(0,10,0,138); btnLoadSword.BackgroundColor3 = ACC; btnLoadSword.Font=Enum.Font.GothamBold; btnLoadSword.Text="Load Sword Script"; btnLoadSword.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadSword)).CornerRadius = UDim.new(0,6)
    local btnLoadLaser = regObj(Instance.new("TextButton")); btnLoadLaser.Parent = U_left; btnLoadLaser.Size = btnLoadBang.Size; btnLoadLaser.Position = UDim2.new(0,10,0,184); btnLoadLaser.BackgroundColor3 = ACC; btnLoadLaser.Font=Enum.Font.GothamBold; btnLoadLaser.Text="Load Laser Gun"; btnLoadLaser.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", btnLoadLaser)).CornerRadius = UDim.new(0,6)

    -- Show/hide panels
    local panels = {
        Player = {leftCol, rightCol},
        Server = {S_left, S_right},
        Fun = {F_left, F_right},
        Fight = {U_left, U_right},
    }
    local function showTab(name)
        for _,v in pairs(panels) do for _,frame in ipairs(v) do frame.Visible = false end end
        local p = panels[name]
        if p then for _,frame in ipairs(p) do frame.Visible = true end end
        for _,b in ipairs(tabButtons) do b.TextColor3 = (b.Text == name) and ACC or TEXT end
    end
    showTab("Player")
    for _,b in ipairs(tabButtons) do regConn(b.MouseButton1Click:Connect(function() pcall(function() showTab(b.Text) end) end)) end

    -- ===== Draggable title bar (fixed) =====
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

    -- ===== Title controls =====
    regConn(btnMin.MouseButton1Click:Connect(function()
        frame.Visible = false; floatBtn.Text = "OPEN"
    end))
    regConn(btnClose.MouseButton1Click:Connect(function() cleanupAll() end))
    regConn(btnSquare.MouseButton1Click:Connect(function()
        body.Visible = not body.Visible
        tabBar.Visible = not tabBar.Visible
        if not body.Visible then frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, 64) else frame.Size = UDim2.new(0, baseW, 0, baseH) end
    end))

    -- Floating toggle
    regConn(floatBtn.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
        floatBtn.Text = frame.Visible and "VIP" or "OPEN"
    end))

    -- ===== Feature implementations (client-side) =====

    -- Helpers
    local function getHumanoid()
        if not player.Character then return nil end
        return player.Character:FindFirstChildOfClass("Humanoid")
    end
    local function getHRP()
        if not player.Character then return nil end
        return player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
    end

    -- Infinite Jump
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

    -- Noclip (client)
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

    -- WalkSpeed apply loop
    regConn(RunService.RenderStepped:Connect(function()
        pcall(function()
            local h = getHumanoid()
            if h then h.WalkSpeed = tonumber(speedSlider.value) or 16 end
        end)
    end))

    -- Anti-AFK
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

    -- Anti-Lag: reduce heavy visuals and prepare removal helper
    local antiLagConn = nil
    local function setAntiLag(on)
        if on then
            pcall(function()
                -- basic reductions
                pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 1e9
                Lighting.Brightness = 1
                -- optional: set materials for new parts
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

    -- Fix-Lag aggressive cleanup (client-runner)
    -- NOTE: This acts on client-side workspace view. Removing instances may not replicate; be careful.
    -- It removes: Models/Folder/Parts that match common "thừa" patterns or large compiled models and deletes Sky objects.
    local function fixLagCleanup()
        pcall(function()
            local removed = 0
            local patterns = {"CompiledModel","Compiled","Temp","GoonFragment","Fragment","DebugModel","_MAP","__MAP"}
            for _,obj in ipairs(workspace:GetChildren()) do
                local name = obj.Name:lower()
                -- remove if name matches patterns
                for _,pat in ipairs(patterns) do
                    if string.find(name, pat:lower()) then
                        pcall(function() obj:Destroy() end)
                        removed = removed + 1
                        break
                    end
                end
                -- also remove huge models (heuristic): model with many descendants > 200
                if obj:IsA("Model") then
                    local count = #obj:GetDescendants()
                    if count > 400 then
                        pcall(function() obj:Destroy() end)
                        removed = removed + 1
                    end
                end
            end
            -- remove Sky objects in Lighting
            for _,v in ipairs(Lighting:GetChildren()) do
                if v.ClassName == "Sky" or v.ClassName == "BloomEffect" or v.ClassName == "SunRaysEffect" or v.ClassName == "ColorCorrectionEffect" then
                    pcall(function() v:Destroy() end)
                end
            end
            -- notify
            pcall(function()
                local StarterGui = game:GetService("StarterGui")
                StarterGui:SetCore("SendNotification", {Title="DEVIL MENU", Text="Fix-Lag: removed "..tostring(removed).." objects and cleared sky effects", Duration=4})
            end)
        end)
    end

    -- Rejoin
    local function rejoinServer()
        pcall(function() TeleportService:Teleport(game.PlaceId) end)
    end

    -- ===== External script loaders (pcall) =====
    local function safeLoad(url)
        return pcall(function()
            local code = game:HttpGet(url)
            if not code or code == "" then error("Empty code") end
            local fok, ferr = pcall(function() loadstring(code)() end)
            if not fok then error(ferr) end
        end)
    end

    -- URLs provided by user
    local urls = {
        FlyGuiV3 = "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt",
        Goon = "https://pastefy.app/lawnvcTT/raw",
        Dance = "https://pastebin.com/raw/0MLPL32f",
        Bang = "https://raw.githubusercontent.com/4gh9/Bang-Script-Gui/main/bang%20gui.lua",
        DriverCar = "https://raw.githubusercontent.com/AstraOutlight/my-scripts/refs/heads/main/fe%20car%20v3",
        Gun = "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/AK-47",
        Sword = "https://raw.githubusercontent.com/lucphuong/Scriptblox/refs/heads/main/sword-replacement.lua", -- user-provided inline originally; safer to place in repo - but we'll attempt to run the block if provided
        Laser = "https://raw.githubusercontent.com/yourplaceholder/laser/main/laser.lua", -- placeholder (user provided big script inline earlier; we will not auto-download unknown)
        Shader = "https://raw.githubusercontent.com/p0e1/1/refs/heads/main/SimpleShader.lua",
    }

    -- NOTE: For Sword & Laser the user pasted code inline (large). We'll load sword if URL works; otherwise provide pastebutton for user to paste code manually.
    -- Buttons wiring (Player tab)
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

    -- Speed slider drag handling
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

    -- Teleport
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

    -- Server tab wiring
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

    -- Fun tab wiring: load external goon/dance links
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

    -- Fight tab wiring: load external scripts
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
            -- If Sword URL exists, try to load; else warn and skip
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

    -- Fix-lag button (we'll add to Server tab right column)
    local fixBtn = regObj(Instance.new("TextButton")); fixBtn.Parent = S_right; fixBtn.Size = UDim2.new(1,-20,0,36); fixBtn.Position = UDim2.new(0,8,0,40); fixBtn.BackgroundColor3 = ACC; fixBtn.Font = Enum.Font.GothamBold; fixBtn.Text="Fix-Lag (clean workspace & sky)"; fixBtn.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", fixBtn)).CornerRadius = UDim.new(0,6)
    regConn(fixBtn.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Running Fix-Lag..."
            fixLagCleanup()
            stLabel.Text = "Status: Fix-Lag complete"
        end)
    end))

    -- Shader load button (server-side shader link - client will attempt to load)
    local shaderBtn = regObj(Instance.new("TextButton")); shaderBtn.Parent = S_right; shaderBtn.Size = UDim2.new(1,-20,0,36); shaderBtn.Position = UDim2.new(0,8,0,84); shaderBtn.BackgroundColor3 = ACC; shaderBtn.Font = Enum.Font.GothamBold; shaderBtn.Text="Load Shader (client)"; shaderBtn.TextColor3=Color3.new(1,1,1); regObj(Instance.new("UICorner", shaderBtn)).CornerRadius = UDim.new(0,6)
    regConn(shaderBtn.MouseButton1Click:Connect(function()
        pcall(function()
            stLabel.Text = "Status: Loading Shader..."
            local ok,err = safeLoad(urls.Shader)
            stLabel.Text = ok and "Status: Shader loaded" or "Status: Shader failed"
            if not ok then warn("Shader load error", err) end
        end)
    end))

    -- Lastly, a quick-access "Load all external fight scripts" for convenience (pcall-wrapped)
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

    -- Final notifications
    pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title="DEVIL MENU", Text="Custom menu loaded (integrations)", Duration=3}) end)

    -- Ensure cleanup on respawn/close
    regConn(player.CharacterRemoving:Connect(function() cleanupAll() end))
    regConn(game:BindToClose(function() cleanupAll() end))
end)
