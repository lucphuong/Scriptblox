-- PinkHub_Full.lua
-- LocalScript: Menu giữa màn, màu hồng, draggable, nút draggable, nhiều chức năng
-- Paste vào StarterPlayer > StarterPlayerScripts (hoặc chạy bằng executor client)

pcall(function()
    -- Services
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local VirtualUser = game:GetService("VirtualUser")
    local Workspace = game:GetService("Workspace")

    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "PinkHubGUI"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    -- Helper: safe get character/humanoid/root
    local function getChar()
        local c = player.Character
        if not c then return nil end
        local h = c:FindFirstChildOfClass("Humanoid")
        local root = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
        return c, h, root
    end

    -- ========== Main frame ==========
    local main = Instance.new("Frame", gui)
    main.Name = "Main"
    main.Size = UDim2.new(0, 420, 0, 480)
    main.Position = UDim2.new(0.5, -210, 0.12, 0)
    main.AnchorPoint = Vector2.new(0.5, 0)
    main.BackgroundColor3 = Color3.fromRGB(255, 145, 175) -- pink pastel
    main.BorderSizePixel = 0
    main.Active = true
    main.Visible = true
    local mainUICorner = Instance.new("UICorner", main)
    mainUICorner.CornerRadius = UDim.new(0, 14)
    local mainShadow = Instance.new("Frame", main) -- subtle shadow feel
    mainShadow.Size = UDim2.new(1,0,1,0)
    mainShadow.Position = UDim2.new(0,0,0,0)
    mainShadow.BackgroundTransparency = 1

    -- TitleBar
    local titleBar = Instance.new("Frame", main)
    titleBar.Size = UDim2.new(1,0,0,40)
    titleBar.Position = UDim2.new(0,0,0,0)
    titleBar.BackgroundColor3 = Color3.fromRGB(255,120,160)
    titleBar.BorderSizePixel = 0
    local titleCorner = Instance.new("UICorner", titleBar)
    titleCorner.CornerRadius = UDim.new(0, 12)

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Text = "PinkHub • Utility"
    titleLabel.Size = UDim2.new(0.7, -12, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(30,30,30)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Control buttons (top-right): minimize, maximize, close (X highlighted)
    local ctrlFrame = Instance.new("Frame", titleBar)
    ctrlFrame.Size = UDim2.new(0, 120, 1, 0)
    ctrlFrame.Position = UDim2.new(1, -126, 0, 0)
    ctrlFrame.BackgroundTransparency = 1

    local function makeCtrl(sym, x)
        local b = Instance.new("TextButton", ctrlFrame)
        b.Size = UDim2.new(0, 32, 0, 28)
        b.Position = UDim2.new(0, x, 0, 6)
        b.Text = sym
        b.Font = Enum.Font.SourceSansBold
        b.TextSize = 18
        b.BackgroundColor3 = Color3.fromRGB(255, 250, 250)
        b.TextColor3 = Color3.fromRGB(60,10,40)
        b.BorderSizePixel = 0
        local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,6)
        return b
    end

    local btnMin = makeCtrl("–", 4)
    local btnMax = makeCtrl("▢", 38)
    local btnClose = makeCtrl("X", 72)
    btnClose.BackgroundColor3 = Color3.fromRGB(255,80,90) -- red highlight
    btnClose.TextColor3 = Color3.fromRGB(255,255,255)

    -- Content (scrollable)
    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, -16, 1, -56)
    content.Position = UDim2.new(0,8,0,48)
    content.BackgroundTransparency = 1

    local scroll = Instance.new("ScrollingFrame", content)
    scroll.Size = UDim2.new(1,0,1,0)
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ScrollBarThickness = 8
    scroll.BackgroundTransparency = 1
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local listLayout = Instance.new("UIGridLayout", scroll)
    listLayout.CellSize = UDim2.new(0, 194, 0, 44)
    listLayout.CellPadding = UDim2.new(0, 10, 0, 10)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Helper create compact button (draggable)
    local function createFuncButton(text, layoutOrder)
        local fr = Instance.new("Frame", scroll)
        fr.Size = UDim2.new(0, 194, 0, 44)
        fr.BackgroundColor3 = Color3.fromRGB(255,200,215)
        fr.BorderSizePixel = 0
        fr.LayoutOrder = layoutOrder
        local corner = Instance.new("UICorner", fr); corner.CornerRadius = UDim.new(0,8)

        local lbl = Instance.new("TextLabel", fr)
        lbl.Size = UDim2.new(0.68, -8, 1, 0)
        lbl.Position = UDim2.new(0,8,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(30,20,30)
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton", fr)
        btn.Size = UDim2.new(0.3, -8, 0.86, 0)
        btn.Position = UDim2.new(0.68, 6, 0.07, 0)
        btn.Text = "OFF"
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 14
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.BackgroundColor3 = Color3.fromRGB(255,120,160)
        btn.BorderSizePixel = 0
        local cb = Instance.new("UICorner", btn); cb.CornerRadius = UDim.new(0,6)

        -- Make each button draggable individually
        local dragging = false; local dragInput, mousePos, startPos
        fr.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                mousePos = Vector2.new(inp.Position.X, inp.Position.Y)
                startPos = fr.Position
                inp.Changed:Connect(function()
                    if inp.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        fr.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = inp
            end
        end)
        UIS.InputChanged:Connect(function(inp)
            if dragging and inp == dragInput then
                local delta = inp.Position - mousePos
                -- convert delta to offset within scroll frame area (approx)
                local newX = startPos.X.Offset + delta.X
                local newY = startPos.Y.Offset + delta.Y
                -- clamp inside scroll (basic)
                fr.Position = UDim2.new(0, math.clamp(newX, 6, scroll.AbsoluteSize.X - fr.AbsoluteSize.X - 6), 0, math.clamp(newY, 6, 4000))
            end
        end)

        return fr, btn, lbl
    end

    -- Create buttons (2-column grid layout)
    local order = 1
    local btns = {}

    local function addToggle(name)
        local fr, btn, lbl = createFuncButton(name, order); order = order + 1
        btns[name] = {frame = fr, toggle = btn, label = lbl}
        return btn, fr, lbl
    end

    -- Movement
    local flyBtn = addToggle("Fly")
    local infBtn = addToggle("Infinite Jump")
    local speedFr, speedBtn, speedLabel = (function()
        local fr, btn, lbl = createFuncButton("Set Speed", order); order = order + 1
        -- replace btn to show current speed
        btn.Text = "Set"
        btns["Speed"] = {frame = fr, btn = btn, label = lbl}
        return fr, btn, lbl
    end)()
    local jumpFr, jumpBtn, jumpLabel = (function()
        local fr, btn, lbl = createFuncButton("Set JumpPower", order); order = order + 1
        btn.Text = "Set"
        btns["JumpPower"] = {frame = fr, btn = btn, label = lbl}
        return fr, btn, lbl
    end)()
    local swimBtn = addToggle("Swimming")
    -- Survivability
    local godBtn = addToggle("Bất tử")
    local invisBtn = addToggle("Tàng hình")
    local ragBtn = addToggle("Ragdoll")
    local flingBtn = addToggle("Fling")
    -- Visual / Misc
    local dimBtn = addToggle("Dim Screen")
    local nvBtn = addToggle("FullBright")
    local fixBtn = addToggle("Fix Lag")
    local afkBtn = addToggle("Anti-AFK")
    -- Teleports
    local tpFr, tpBtn, tpLbl = (function()
        local fr, btn, lbl = createFuncButton("Teleport → Player", order); order = order + 1
        btn.Text = "Open"
        btns["TeleportUI"] = {frame = fr, btn = btn, label = lbl}
        return fr, btn, lbl
    end)()
    local touchTPBtn = addToggle("Click-to-Teleport")

    -- Add a compact input panel for Speed & JumpPower when clicked
    local function openNumberPopup(titleText, default, applyFunc)
        -- simple popup in center of main
        local popup = Instance.new("Frame", gui)
        popup.Size = UDim2.new(0, 300, 0, 120)
        popup.Position = UDim2.new(0.5, -150, 0.5, -60)
        popup.BackgroundColor3 = Color3.fromRGB(255,240,245)
        popup.BorderSizePixel = 0
        popup.ZIndex = 10
        local c = Instance.new("UICorner", popup); c.CornerRadius = UDim.new(0,10)

        local t = Instance.new("TextLabel", popup)
        t.Size = UDim2.new(1, -20, 0, 28)
        t.Position = UDim2.new(0,10,0,8)
        t.BackgroundTransparency = 1
        t.Text = titleText
        t.Font = Enum.Font.GothamBold
        t.TextSize = 16
        t.TextColor3 = Color3.fromRGB(30,20,30)
        t.TextXAlignment = Enum.TextXAlignment.Left

        local box = Instance.new("TextBox", popup)
        box.Size = UDim2.new(1, -20, 0, 34)
        box.Position = UDim2.new(0,10,0,40)
        box.Text = tostring(default)
        box.ClearTextOnFocus = false
        box.Font = Enum.Font.Gotham
        box.TextSize = 16
        box.TextColor3 = Color3.fromRGB(30,30,30)

        local apply = Instance.new("TextButton", popup)
        apply.Size = UDim2.new(0.4, -8, 0, 26)
        apply.Position = UDim2.new(0.58, 0, 1, -36)
        apply.Text = "Apply"
        apply.Font = Enum.Font.SourceSansBold
        apply.TextSize = 14
        apply.BackgroundColor3 = Color3.fromRGB(255,120,160)
        apply.TextColor3 = Color3.fromRGB(255,255,255)
        local ac = Instance.new("UICorner", apply); ac.CornerRadius = UDim.new(0,6)

        local cancel = Instance.new("TextButton", popup)
        cancel.Size = UDim2.new(0.4, -8, 0, 26)
        cancel.Position = UDim2.new(0.06, 0, 1, -36)
        cancel.Text = "Cancel"
        cancel.Font = Enum.Font.SourceSans
        cancel.TextSize = 14
        cancel.BackgroundColor3 = Color3.fromRGB(240,240,240)
        cancel.TextColor3 = Color3.fromRGB(40,40,40)
        local cc = Instance.new("UICorner", cancel); cc.CornerRadius = UDim.new(0,6)

        apply.MouseButton1Click:Connect(function()
            local n = tonumber(box.Text)
            if n then
                pcall(function() applyFunc(n) end)
            end
            popup:Destroy()
        end)
        cancel.MouseButton1Click:Connect(function() popup:Destroy() end)
    end

    -- Teleport UI (list players)
    local function openTeleportPanel()
        local panel = Instance.new("Frame", gui)
        panel.Size = UDim2.new(0, 300, 0, 320)
        panel.Position = UDim2.new(0.5, -150, 0.5, -160)
        panel.BackgroundColor3 = Color3.fromRGB(255,240,245)
        panel.BorderSizePixel = 0
        panel.ZIndex = 11
        local c = Instance.new("UICorner", panel); c.CornerRadius = UDim.new(0,10)

        local title = Instance.new("TextLabel", panel)
        title.Size = UDim2.new(1, -20, 0, 26)
        title.Position = UDim2.new(0, 10, 0, 8)
        title.BackgroundTransparency = 1
        title.Text = "Teleport to Player"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 16
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextColor3 = Color3.fromRGB(30,30,30)

        local list = Instance.new("ScrollingFrame", panel)
        list.Size = UDim2.new(1, -20, 1, -68)
        list.Position = UDim2.new(0,10,0,40)
        list.BackgroundTransparency = 1
        list.ScrollBarThickness = 8

        local layout = Instance.new("UIListLayout", list)
        layout.Padding = UDim.new(0,6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        for i, pl in pairs(Players:GetPlayers()) do
            if pl ~= player then
                local item = Instance.new("TextButton", list)
                item.Size = UDim2.new(1, -6, 0, 34)
                item.Text = pl.Name
                item.Font = Enum.Font.Gotham
                item.TextSize = 14
                item.BackgroundColor3 = Color3.fromRGB(255,200,215)
                item.TextColor3 = Color3.fromRGB(30,20,30)
                item.BorderSizePixel = 0
                local u = Instance.new("UICorner", item); u.CornerRadius = UDim.new(0,6)
                item.MouseButton1Click:Connect(function()
                    pcall(function()
                        local targetChar = pl.Character
                        local root = targetChar and (targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso"))
                        local myChar, myHum, myRoot = getChar()
                        if root and myRoot then
                            myRoot.CFrame = root.CFrame + Vector3.new(0,3,0)
                        end
                    end)
                end)
            end
        end

        local close = Instance.new("TextButton", panel)
        close.Size = UDim2.new(0.3, -8, 0, 28)
        close.Position = UDim2.new(0.35, 0, 1, -36)
        close.Text = "Close"
        close.Font = Enum.Font.SourceSansBold
        close.TextSize = 14
        close.BackgroundColor3 = Color3.fromRGB(255,120,160)
        close.TextColor3 = Color3.fromRGB(255,255,255)
        local uc = Instance.new("UICorner", close); uc.CornerRadius = UDim.new(0,6)
        close.MouseButton1Click:Connect(function() panel:Destroy() end)
    end

    -- Hook actions for special buttons
    btns["Speed"].btn.MouseButton1Click:Connect(function()
        local c,h = getChar()
        local current = (h and h.WalkSpeed) or 16
        openNumberPopup("Set WalkSpeed", current, function(n)
            local c2,h2 = getChar()
            if h2 then pcall(function() h2.WalkSpeed = n end) end
        end)
    end)

    btns["JumpPower"].btn.MouseButton1Click:Connect(function()
        local c,h = getChar()
        local current = (h and h.JumpPower) or 50
        openNumberPopup("Set JumpPower", current, function(n)
            local c2,h2 = getChar()
            if h2 then pcall(function() h2.JumpPower = n end) end
        end)
    end)

    btns["TeleportUI"].btn.MouseButton1Click:Connect(function()
        openTeleportPanel()
    end)

    -- Click-to-teleport implementation:
    local clickTPEnabled = false
    local function onClickTeleport(input)
        if not clickTPEnabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = player:GetMouse()
            local target = mouse.Target
            if target then
                local part = target
                -- if part belongs to a player, teleport to that player's root
                local pl = Players:GetPlayerFromCharacter(part:FindFirstAncestorOfClass("Model"))
                if not pl then
                    pl = Players:GetPlayerFromCharacter(part.Parent)
                end
                if pl and pl.Character then
                    local root = pl.Character:FindFirstChild("HumanoidRootPart") or pl.Character:FindFirstChild("Torso")
                    local myc, myh, myroot = getChar()
                    if root and myroot then
                        pcall(function() myroot.CFrame = root.CFrame + Vector3.new(0,3,0) end)
                    end
                end
            end
        end
    end

    -- Toggle states and implementations
    local states = {
        Fly = false, InfiniteJump = false, Swimming = false,
        God = false, Invisible = false, Ragdoll = false, Fling = false,
        Dim = false, FullBright = false, FixLag = false, AntiAFK = false,
        ClickTP = false
    }

    -- Fly variables
    local flyBV = nil; local flySpeed = 60
    local flyConn = nil

    local function startFly()
        local c,h,root = getChar()
        if not root then return end
        if flyBV and flyBV.Parent then flyBV:Destroy() end
        flyBV = Instance.new("BodyVelocity")
        flyBV.Name = "PinkFlyBV"
        flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
        flyBV.P = 2500
        flyBV.Velocity = Vector3.new(0,0,0)
        flyBV.Parent = root
        states.Fly = true
        -- bind to render
        flyConn = RunService:BindToRenderStep("PinkFlyStep", Enum.RenderPriority.Character.Value, function()
            if not states.Fly then return end
            local cam = Workspace.CurrentCamera
            local move = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.E) then move = move + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.Q) then move = move - Vector3.new(0,1,0) end
            if move.Magnitude > 0 then
                flyBV.Velocity = move.Unit * flySpeed
            else
                flyBV.Velocity = Vector3.new(0,0,0)
            end
        end)
    end

    local function stopFly()
        states.Fly = false
        pcall(function()
            if flyConn then RunService:UnbindFromRenderStep("PinkFlyStep") end
            if flyBV and flyBV.Parent then flyBV:Destroy() end
            flyBV = nil
        end)
    end

    -- Infinite jump implementation
    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.Space and states.InfiniteJump then
            local c,h = getChar()
            if h and h.Health > 0 then
                pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end)
            end
        end
    end)

    -- Click teleport binding
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        onClickTeleport(input)
    end)
    -- Also use Mouse Button1 down via player mouse (safety)
    -- will rely on onClickTeleport above

    -- Anti-AFK
    local afkConn = nil
    local function startAFK()
        afkConn = RunService.Stepped:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
            end)
        end)
    end
    local function stopAFK()
        if afkConn then afkConn:Disconnect(); afkConn = nil end
    end

    -- FullBright (client-only overlay)
    local fbFrame = nil
    local function enableFullBright()
        if fbFrame and fbFrame.Parent then return end
        fbFrame = Instance.new("ColorCorrectionEffect", game:GetService("Lighting"))
        fbFrame.Brightness = 0.3
        fbFrame.Contrast = 0.05
        fbFrame.Saturation = 0.2
    end
    local function disableFullBright()
        pcall(function()
            for _,v in pairs(game:GetService("Lighting"):GetChildren()) do
                if v:IsA("ColorCorrectionEffect") then
                    -- remove only those we created? best-effort remove all corrections
                    v:Destroy()
                end
            end
        end)
    end

    -- Dim overlay
    local dimOverlay = nil
    local function enableDim()
        if dimOverlay then return end
        dimOverlay = Instance.new("Frame", gui)
        dimOverlay.Size = UDim2.new(1,0,1,0)
        dimOverlay.Position = UDim2.new(0,0,0,0)
        dimOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
        dimOverlay.BackgroundTransparency = 0.6
        dimOverlay.ZIndex = 2
    end
    local function disableDim()
        if dimOverlay then dimOverlay:Destroy(); dimOverlay = nil end
    end

    -- Fix Lag: simple client-side disabling of expensive effects (best-effort)
    local lagDisabled = false
    local disabledObjects = {}
    local function enableFixLag()
        if lagDisabled then return end
        lagDisabled = true
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Sparkles") then
                pcall(function()
                    disabledObjects[#disabledObjects+1] = {obj, obj.Enabled}
                    obj.Enabled = false
                end)
            end
        end
    end
    local function disableFixLag()
        if not lagDisabled then return end
        for _, entry in pairs(disabledObjects) do
            local obj, prev = entry[1], entry[2]
            pcall(function() if obj and obj.Parent then obj.Enabled = prev end end)
        end
        disabledObjects = {}
        lagDisabled = false
    end

    -- Godmode (client-only)
    local godConn = nil
    local function enableGod()
        godConn = RunService.Heartbeat:Connect(function()
            local c,h = getChar()
            if h then
                pcall(function() h.MaxHealth = 9e9; if h.Health < 9e9 then h.Health = 9e9 end end)
            end
        end)
    end
    local function disableGod()
        if godConn then godConn:Disconnect(); godConn = nil end
        local c,h = getChar()
        if h then pcall(function() h.MaxHealth = 100; h.Health = 100 end) end
    end

    -- Invisible (client-only): hide character parts visuals (local only)
    local invisParts = {}
    local function enableInvisible()
        local c = player.Character
        if not c then return end
        for _, part in pairs(c:GetDescendants()) do
            if part:IsA("BasePart") then
                invisParts[#invisParts+1] = {part, part.Transparency}
                part.Transparency = 1
            elseif part:IsA("Decal") then
                invisParts[#invisParts+1] = {part, part.Transparency}
                part.Transparency = 1
            end
        end
    end
    local function disableInvisible()
        for _, entry in pairs(invisParts) do
            local o, prev = entry[1], entry[2]
            pcall(function() if o and o.Parent then o.Transparency = prev end end)
        end
        invisParts = {}
    end

    -- Ragdoll (soft approach: PlatformStand)
    local function enableRagdoll()
        local c,h = getChar()
        if h then pcall(function() h.PlatformStand = true end) end
    end
    local function disableRagdoll()
        local c,h = getChar()
        if h then pcall(function() h.PlatformStand = false end) end
    end

    -- Fling: add BodyAngularVelocity on root
    local function enableFling()
        local c,h,root = getChar()
        if not root then return end
        if root:FindFirstChild("Pink_FlingAV") then return end
        local av = Instance.new("BodyAngularVelocity")
        av.Name = "Pink_FlingAV"
        av.MaxTorque = Vector3.new(1e8,1e8,1e8)
        av.AngularVelocity = Vector3.new(0,90,0)
        av.Parent = root
    end
    local function disableFling()
        local c = player.Character
        if c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso")) then
            local root = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso")
            local av = root and root:FindFirstChild("Pink_FlingAV")
            if av then av:Destroy() end
        end
    end

    -- Swimming toggle: best-effort: enable swimming state
    local function setSwimming(on)
        local c,h = getChar()
        if h then pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Swimming, on) end) end
    end

    -- Wire up UI button behavior (toggling with visual text change)
    local function bindToggle(name, toggleBtn)
        toggleBtn.MouseButton1Click:Connect(function()
            states[name] = not states[name]
            toggleBtn.Text = states[name] and "ON" or "OFF"

            -- perform action per name
            if name == "Fly" then
                if states.Fly then startFly() else stopFly() end
            elseif name == "InfiniteJump" then
                -- nothing else needed (handled in InputBegan)
            elseif name == "Swimming" then
                setSwimming(states.Swimming)
            elseif name == "Bất tử" or name == "God" then
                if states.God then enableGod() else disableGod() end
            elseif name == "Tàng hình" then
                if states.Tàng hình or states.Invisible then -- handle both keys
                    -- toggle invis using states.Invisible
                    states.Invisible = states.Invisible or states["Tàng hình"]
                end
                if states.Invisible then enableInvisible() else disableInvisible() end
            elseif name == "Ragdoll" then
                if states.Ragdoll then enableRagdoll() else disableRagdoll() end
            elseif name == "Fling" then
                if states.Fling then enableFling() else disableFling() end
            elseif name == "Dim Screen" then
                if states.Dim then enableDim() else disableDim() end
            elseif name == "FullBright" then
                if states.FullBright then enableFullBright() else disableFullBright() end
            elseif name == "Fix Lag" then
                if states["Fix Lag"] then enableFixLag() else disableFixLag() end
            elseif name == "Anti-AFK" then
                if states["Anti-AFK"] then startAFK() else stopAFK() end
            elseif name == "Click-to-Teleport" then
                clickTPEnabled = states["Click-to-Teleport"] or states["Click-to-Teleport"] == nil and states["Click-to-Teleport"]
                -- map the key since label has slight variant
                states.ClickTP = states["Click-to-Teleport"] or states["Click-to-Teleport"]
            end
        end)
    end

    -- Because some labels used VN text, match by frame key mapping to states
    -- We'll map created UI to internal states manually:
    -- Mapping frames/buttons to state keys
    local mapping = {
        ["Fly"] = {button = btns["Fly"].toggle or btns["Fly"]},
        ["Infinite Jump"] = {button = btns["Infinite Jump"].toggle or btns["Infinite Jump"]},
        ["Swimming"] = {button = btns["Swimming"].toggle or btns["Swimming"]},
        ["Bất tử"] = {button = btns["Bất tử"].toggle or btns["Bất tử"]},
        ["Tàng hình"] = {button = btns["Tàng hình"].toggle or btns["Tàng hình"]},
        ["Ragdoll"] = {button = btns["Ragdoll"].toggle or btns["Ragdoll"]},
        ["Fling"] = {button = btns["Fling"].toggle or btns["Fling"]},
        ["Dim Screen"] = {button = btns["Dim Screen"].toggle or btns["Dim Screen"]},
        ["FullBright"] = {button = btns["FullBright"].toggle or btns["FullBright"]},
        ["Fix Lag"] = {button = btns["Fix Lag"].toggle or btns["Fix Lag"]},
        ["Anti-AFK"] = {button = btns["Anti-AFK"].toggle or btns["Anti-AFK"]},
        ["Click-to-Teleport"] = {button = btns["Click-to-Teleport"].toggle or btns["Click-to-Teleport"]},
    }

    -- Because we created using VN names earlier, find buttons by label text
    for _, child in pairs(scroll:GetChildren()) do
        if child:IsA("Frame") then
            local txt = nil
            for _, v in pairs(child:GetChildren()) do
                if v:IsA("TextLabel") then txt = v.Text end
            end
            local btnObj = nil
            for _, v in pairs(child:GetChildren()) do
                if v:IsA("TextButton") then btnObj = v end
            end
            if txt and btnObj then
                if txt == "Fly" then bindToggle("Fly", btnObj) end
                if txt == "Infinite Jump" then bindToggle("InfiniteJump", btnObj) end
                if txt == "Swimming" then bindToggle("Swimming", btnObj) end
                if txt == "Bất tử" then bindToggle("Bất tử", btnObj) end
                if txt == "Tàng hình" then bindToggle("Tàng hình", btnObj) end
                if txt == "Ragdoll" then bindToggle("Ragdoll", btnObj) end
                if txt == "Fling" then bindToggle("Fling", btnObj) end
                if txt == "Dim Screen" then bindToggle("Dim Screen", btnObj) end
                if txt == "FullBright" then bindToggle("FullBright", btnObj) end
                if txt == "Fix Lag" then bindToggle("Fix Lag", btnObj) end
                if txt == "Anti-AFK" then bindToggle("Anti-AFK", btnObj) end
                if txt == "Click-to-Teleport" then
                    bindToggle("Click-to-Teleport", btnObj)
                    -- also sync a simple state name for clicktp
                    btnObj.MouseButton1Click:Connect(function()
                        states["Click-to-Teleport"] = not states["Click-to-Teleport"]
                        btnObj.Text = states["Click-to-Teleport"] and "ON" or "OFF"
                        clickTPEnabled = states["Click-to-Teleport"]
                    end)
                end
            end
        end
    end

    -- Bind Speed & Jump set (we created buttons earlier with text "Set")
    for _, child in pairs(scroll:GetChildren()) do
        if child:IsA("Frame") then
            local lbl, btn = nil, nil
            for _, v in pairs(child:GetChildren()) do
                if v:IsA("TextLabel") then lbl = v end
                if v:IsA("TextButton") then btn = v end
            end
            if lbl and btn then
                if lbl.Text == "Set Speed" or lbl.Text == "Set WalkSpeed" then
                    btn.MouseButton1Click:Connect(function()
                        local c,h = getChar()
                        local cur = h and h.WalkSpeed or 16
                        openNumberPopup("Set WalkSpeed", cur, function(n) pcall(function() local _, hh = getChar(); if hh then hh.WalkSpeed = n end end) end)
                    end)
                elseif lbl.Text == "Set JumpPower" then
                    btn.MouseButton1Click:Connect(function()
                        local c,h = getChar()
                        local cur = h and h.JumpPower or 50
                        openNumberPopup("Set JumpPower", cur, function(n) pcall(function() local _, hh = getChar(); if hh then hh.JumpPower = n end end) end)
                    end)
                elseif lbl.Text == "Teleport → Player" then
                    btn.MouseButton1Click:Connect(function()
                        openTeleportPanel()
                    end)
                end
            end
        end
    end

    -- Min/Max/Close behavior
    local prevSize = main.Size; local prevPos = main.Position; local minimized = false
    btnMin.MouseButton1Click:Connect(function()
        if not minimized then
            prevSize = main.Size; prevPos = main.Position
            main.Size = UDim2.new(0, 320, 0, 40)
            minimized = true
        else
            main.Size = prevSize; main.Position = prevPos
            minimized = false
        end
    end)
    btnMax.MouseButton1Click:Connect(function()
        if main.Size.X.Offset < 700 then
            main.Size = UDim2.new(0, 740, 0, 560)
            main.Position = UDim2.new(0.5, -370, 0.05, 0)
        else
            main.Size = UDim2.new(0, 420, 0, 480)
            main.Position = UDim2.new(0.5, -210, 0.12, 0)
        end
    end)
    btnClose.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Drag main
    do
        local dragging = false
        local dragInput, mousePos, framePos
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                mousePos = Vector2.new(input.Position.X, input.Position.Y)
                framePos = Vector2.new(main.Position.X.Offset, main.Position.Y.Offset)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        titleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - mousePos
                main.Position = UDim2.new(0, framePos.X + delta.X, 0, framePos.Y + delta.Y)
            end
        end)
    end

    -- Update canvas size of scroll
    scroll.ChildAdded:Connect(function()
        task.wait(0.02)
        scroll.CanvasSize = UDim2.new(0,0,0, math.max(0, (listLayout.AbsoluteContentSize.Y + 20)))
    end)
    -- initial update
    task.spawn(function() task.wait(0.05); scroll.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 20) end)

    -- Keybind to hide/show menu
    local visible = true
    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.M then
            visible = not visible
            main.Visible = visible
        end
    end)

    -- Safety on character added: cleanup client-only effects
    player.CharacterAdded:Connect(function()
        -- stop fly on respawn to avoid stuck BV
        stopFly()
        disableFling()
        disableInvisible()
        disableGod()
        disableFullBright()
    end)

    -- Final notes & initial labels
    -- Set initial labels for toggles (find all toggles and set OFF)
    for _, child in pairs(scroll:GetChildren()) do
        if child:IsA("Frame") then
            for _, v in pairs(child:GetChildren()) do
                if v:IsA("TextButton") then
                    if v.Text ~= "Set" and v.Text ~= "Open" then
                        v.Text = "OFF"
                    end
                end
            end
        end
    end

    -- Note: add mouse cleanup for clickTP state binding
    -- (click teleport already handled by states["Click-to-Teleport"] and UIS.InputBegan)
    -- Map VN label keys to internal state keys for easier management:
    -- We'll bind that label texts toggle working above.

    -- End script
    print("[PinkHub] Loaded - use M to toggle menu. Buttons are draggable individually.")
end)
