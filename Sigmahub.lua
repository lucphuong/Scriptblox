-- Sigma Hub (Rayfield style) - Universal Full Menu
-- Paste into executor. Tested logic for universal client-side features.
-- NOTE: Some game servers prevent client-side cheats (server-side checks) — not all features will work in every game.

pcall(function()
    -- ===== Services & helpers =====
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Lighting = game:GetService("Lighting")
    local CoreGui = game:GetService("CoreGui")
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local Workspace = game:GetService("Workspace")
    local StarterGui = game:GetService("StarterGui")

    local localPlayer = Players.LocalPlayer
    if not localPlayer then return end

    -- Resource tracking for cleanup
    local created = {}
    local connections = {}
    local function regObj(o) if o then table.insert(created, o) end; return o end
    local function regConn(c) if c then table.insert(connections, c) end; return c end
    local function cleanupAll()
        for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        for _,o in ipairs(created) do pcall(function() if o and o.Parent then o:Destroy() end end) end
        connections = {}; created = {}
    end

    -- Try to protect gui with syn if available
    local function protectGui(g)
        if syn and syn.protect_gui then
            pcall(function() syn.protect_gui(g) end)
        end
    end

    -- ===== Rayfield loader (try multiple known URLs) =====
    local rayfieldSources = {
        "https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua",
        "https://raw.githubusercontent.com/dawid-scripts/Rayfield/main/source.lua",
        "https://raw.githubusercontent.com/RegularVynixu/Rayfield/main/source.lua"
    }

    local Rayfield = nil
    local function tryLoadRayfield()
        for _,url in ipairs(rayfieldSources) do
            local ok, code = pcall(function() return game:HttpGet(url) end)
            if ok and code and code:len() > 50 then
                local sOk, lib = pcall(function() return loadstring(code)() end)
                if sOk and lib then
                    return lib
                end
            end
        end
        return nil
    end

    Rayfield = tryLoadRayfield()

    -- ===== Fallback minimal UI (if Rayfield unavailable) =====
    local UIroot = nil
    local function makeFallbackUI()
        -- Simple ScreenGui with basic elements (very minimal)
        local screen = regObj(Instance.new("ScreenGui"))
        screen.Name = "SigmaHubFallback"
        screen.ResetOnSpawn = false
        screen.Parent = CoreGui
        protectGui(screen)
        local frame = regObj(Instance.new("Frame"))
        frame.Size = UDim2.new(0,420,0,360)
        frame.Position = UDim2.new(0.5,-210,0.5,-180)
        frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
        frame.BorderSizePixel = 0
        frame.Parent = screen
        regObj(Instance.new("UICorner", frame)).CornerRadius = UDim.new(0,8)

        local title = regObj(Instance.new("TextLabel")); title.Parent=frame; title.Size=UDim2.new(1,0,0,26); title.BackgroundTransparency=1; title.Font=Enum.Font.GothamBold; title.TextSize=16; title.TextColor3=Color3.fromRGB(240,240,240); title.Text="Sigma Hub (Fallback)"; title.Position=UDim2.new(0,0,0,0)
        UIroot = {Screen=screen, Frame=frame}
        return UIroot
    end

    -- ===== Create main UI via Rayfield or fallback =====
    local Window, Tabs = nil, {}
    if Rayfield then
        pcall(function()
            Window = Rayfield:CreateWindow({
                Name = "Sigma Hub",
                LoadingTitle = "Sigma Hub",
                LoadingSubtitle = "Universal | Rayfield Style",
                ConfigurationSaving = {
                    Enabled = true,
                    FolderName = "SigmaHub",
                    FileName = "config"
                },
                Discord = {
                    Enabled = false
                },
            })
        end)
    else
        makeFallbackUI()
    end

    -- ===== Core variables & utilities =====
    local function notify(title, text, dur)
        pcall(function() StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = dur or 3}) end)
    end

    -- Simple safe loader function
    local function safeLoad(url)
        return pcall(function()
            local code = game:HttpGet(url)
            if not code or code == "" then error("Empty code") end
            local f = loadstring(code)
            if f then f() end
        end)
    end

    -- Ensure single instance removal
    for _,g in ipairs(CoreGui:GetChildren()) do
        if g.Name == "SigmaHub" or g.Name == "SigmaHubFallback" then pcall(function() g:Destroy() end) end
    end

    -- ===== Player feature implementations =====
    local state = {
        Fly = false,
        FlySpeed = 50,
        Noclip = false,
        InfJump = false,
        WalkSpeed = 16,
        JumpPower = 50,
        AntiAFK = false,
        AntiLag = false,
        ESP = false,
        ESP_Objects = {}
    }

    -- Helpers: get humanoid + hrp
    local function getCharacter()
        return localPlayer.Character
    end
    local function getHumanoid()
        local c = getCharacter()
        if not c then return nil end
        return c:FindFirstChildOfClass("Humanoid")
    end
    local function getHRP()
        local c = getCharacter()
        if not c then return nil end
        return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
    end

    -- Infinite Jump
    local jumpConn = nil
    local function setInfiniteJump(on)
        if on then
            if jumpConn then jumpConn:Disconnect() end
            jumpConn = regConn(UserInputService.JumpRequest:Connect(function()
                pcall(function() local h = getHumanoid(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end)
            end))
        else
            if jumpConn then jumpConn:Disconnect() end
            jumpConn = nil
        end
    end

    -- Fly (basic implementation: set HumanoidRootPart assembly linear velocity)
    local flyConnections = {}
    local function setFly(on)
        state.Fly = on
        if on then
            local hrp = getHRP()
            if not hrp then notify("Sigma Hub","No character to fly",3); state.Fly=false; return end
            hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
            local conn = regConn(RunService.Heartbeat:Connect(function(dt)
                pcall(function()
                    if not state.Fly then return end
                    local hrp = getHRP()
                    if not hrp then return end
                    local cam = workspace.CurrentCamera
                    local dir = Vector3.new(0,0,0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + (cam.CFrame.LookVector) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - (cam.CFrame.LookVector) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - (cam.CFrame.RightVector) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + (cam.CFrame.RightVector) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
                    hrp.Velocity = dir.Unit * (state.FlySpeed) + Vector3.new(0,0,0)
                end)
            end))
            table.insert(flyConnections, conn)
        else
            for _,c in ipairs(flyConnections) do pcall(function() c:Disconnect() end) end
            flyConnections = {}
        end
    end

    -- Noclip
    local noclipConn = nil
    local function setNoclip(on)
        state.Noclip = on
        if on then
            if noclipConn then noclipConn:Disconnect() end
            noclipConn = regConn(RunService.Stepped:Connect(function()
                pcall(function()
                    local ch = getCharacter()
                    if not ch then return end
                    for _,part in ipairs(ch:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end)
            end))
        else
            if noclipConn then noclipConn:Disconnect() end
            noclipConn = nil
            pcall(function()
                local ch = getCharacter()
                if not ch then return end
                for _,part in ipairs(ch:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end)
        end
    end

    -- WalkSpeed/JumpPower set
    regConn(RunService.RenderStepped:Connect(function()
        pcall(function()
            local h = getHumanoid()
            if h then
                h.WalkSpeed = tonumber(state.WalkSpeed) or 16
                h.JumpPower = tonumber(state.JumpPower) or 50
            end
        end)
    end))

    -- Anti AFK
    local afkConn = nil
    local function setAntiAFK(on)
        state.AntiAFK = on
        if on then
            if afkConn then afkConn:Disconnect() end
            afkConn = regConn(localPlayer.Idled:Connect(function()
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
    end

    -- Anti-Lag (client-side reductions)
    local antiLagState = false
    local antiLagConn = nil
    local function setAntiLag(on)
        antiLagState = on
        if on then
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
        else
            if antiLagConn then antiLagConn:Disconnect() end
            antiLagConn = nil
        end
    end

    -- ===== ESP (players & items) =====
    local ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "SigmaESPFolder"
    ESPFolder.Parent = CoreGui
    protectGui(ESPFolder)
    regObj(ESPFolder)
    local function createBillboardFor(part, label)
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0,120,0,40)
        bb.AlwaysOnTop = true
        bb.Adornee = part
        local t = Instance.new("TextLabel", bb)
        t.BackgroundTransparency = 1
        t.Size = UDim2.new(1,0,1,0)
        t.Text = label
        t.TextColor3 = Color3.fromRGB(255,255,255)
        t.Font = Enum.Font.GothamBold
        t.TextScaled = true
        bb.Parent = ESPFolder
        return bb
    end

    local espConnections = {}
    local function clearESP()
        for _,v in ipairs(ESPFolder:GetChildren()) do pcall(function() v:Destroy() end) end
        for _,c in ipairs(espConnections) do pcall(function() c:Disconnect() end) end
        espConnections = {}
    end

    local function setESP(on)
        clearESP()
        state.ESP = on
        if not on then return end
        -- Player ESP
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl ~= localPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                local bb = createBillboardFor(pl.Character.HumanoidRootPart, pl.Name)
            end
        end
        regConn(Players.PlayerAdded:Connect(function(pl)
            regConn(pl.CharacterAdded:Connect(function(ch)
                if state.ESP then
                    if ch:FindFirstChild("HumanoidRootPart") then createBillboardFor(ch.HumanoidRootPart, pl.Name) end
                end
            end))
        end))
    end

    -- ===== Teleport / Rejoin / Server Hop =====
    local function teleportToPlayer(name)
        local target = Players:FindFirstChild(name)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and getHRP() then
            getHRP().CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
            notify("Teleport", "Teleported to "..name, 3)
        else
            notify("Teleport", "Player not found or no HRP", 3)
        end
    end

    local function rejoin()
        pcall(function() TeleportService:Teleport(game.PlaceId) end)
    end

    local function serverHop()
        -- simplistic serverhop: try to teleport to same placeId (Roblox will load new server)
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, nil) end)
    end

    -- ===== Fight features (basic client-side heuristics) =====
    local fightState = {
        KillAura = false,
        KillRange = 10,
        AutoClick = false,
        AutoClickInterval = 0.1,
        HitboxSize = 5
    }

    -- AutoClick using VirtualUser (best-effort)
    local autoClickConn = nil
    local function setAutoClick(on)
        fightState.AutoClick = on
        if on then
            if autoClickConn then autoClickConn:Disconnect() end
            autoClickConn = regConn(RunService.Heartbeat:Connect(function(dt)
                pcall(function()
                    if fightState.AutoClick and localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Tool") then
                        local vu = game:GetService("VirtualUser")
                        vu:Button1Down(Vector2.new(0,0))
                        wait(fightState.AutoClickInterval)
                        vu:Button1Up(Vector2.new(0,0))
                    end
                end)
            end))
        else
            if autoClickConn then autoClickConn:Disconnect() end
            autoClickConn = nil
        end
    end

    -- KillAura: move near nearest player and attempt to click (client-side)
    local killAuraConn = nil
    local function setKillAura(on)
        fightState.KillAura = on
        if on then
            if killAuraConn then killAuraConn:Disconnect() end
            killAuraConn = regConn(RunService.Heartbeat:Connect(function()
                pcall(function()
                    if not fightState.KillAura then return end
                    local hrp = getHRP()
                    if not hrp then return end
                    local nearest, ndist = nil, math.huge
                    for _,pl in ipairs(Players:GetPlayers()) do
                        if pl ~= localPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") and pl.Character:FindFirstChildOfClass("Humanoid") and pl.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                            local d = (pl.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                            if d < ndist and d <= fightState.KillRange then
                                nearest = pl
                                ndist = d
                            end
                        end
                    end
                    if nearest and ndist <= fightState.KillRange then
                        -- attempt to move slightly towards them (client movement)
                        hrp.CFrame = nearest.Character.HumanoidRootPart.CFrame * CFrame.new(0,0, -2)
                        -- attempt a click via VirtualUser if holding a tool
                        if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Tool") then
                            local vu = game:GetService("VirtualUser")
                            vu:Button1Down(Vector2.new(0,0))
                            wait(0.06)
                            vu:Button1Up(Vector2.new(0,0))
                        end
                    end
                end)
            end))
        else
            if killAuraConn then killAuraConn:Disconnect() end
            killAuraConn = nil
        end
    end

    -- Hitbox extender (client-side enlarge target hitboxes)
    local originalSizes = {}
    local function setHitboxSize(size)
        fightState.HitboxSize = size
        for _,pl in ipairs(Players:GetPlayers()) do
            if pl.Character then
                for _,part in ipairs(pl.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name:lower():find("head") or part.Name:lower():find("humanoidrootpart") then
                        if not originalSizes[part] then originalSizes[part] = part.Size end
                        pcall(function() part.Size = Vector3.new(size,size,size) end)
                    end
                end
            end
        end
    end

    local function resetHitboxes()
        for part, sz in pairs(originalSizes) do
            pcall(function() part.Size = sz end)
        end
        originalSizes = {}
    end

    -- ===== Boombox (Play/Stop + Volume slider + Popular list) =====
    local currentSound = nil
    local function playAudio(id, volume, loop)
        pcall(function()
            if currentSound then currentSound:Stop(); currentSound:Destroy(); currentSound = nil end
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://"..tostring(id)
            s.Volume = volume or 5
            s.Looped = loop == nil and true or loop
            s.PlayOnRemove = false
            s.Parent = Workspace
            s:Play()
            currentSound = s
            regConn(s.Ended:Connect(function()
                if currentSound == s then currentSound = nil end
            end))
        end)
    end
    local function stopAudio()
        pcall(function()
            if currentSound then currentSound:Stop(); currentSound:Destroy(); currentSound = nil end
        end)
    end

    -- ===== External script URLs (user can edit) =====
    local urls = {
        Fly = "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt",
        Goon = "https://pastefy.app/lawnvcTT/raw",
        Dance = "https://pastebin.com/raw/0MLPL32f",
        Bang = "https://raw.githubusercontent.com/4gh9/Bang-Script-Gui/main/bang%20gui.lua",
        Driver = "https://raw.githubusercontent.com/AstraOutlight/my-scripts/refs/heads/main/fe%20car%20v3",
        Gun = "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/AK-47"
    }

    -- ===== GUI (Rayfield) construction =====
    if Rayfield and Window then
        -- Player Tab
        local PlayerTab = Window:CreateTab("Player")
        local playerSection = PlayerTab:CreateSection("Movement & Player")
        playerSection:CreateToggle({
            Name = "Fly",
            CurrentValue = false,
            Flag = "FlyToggle",
            Callback = function(val) setFly(val) end
        })
        playerSection:CreateSlider({
            Name = "Fly Speed",
            Range = {10,200},
            Increment = 1,
            CurrentValue = 50,
            Flag = "FlySpeed",
            Callback = function(v) state.FlySpeed = v end
        })
        playerSection:CreateToggle({ Name = "Noclip", CurrentValue = false, Callback = function(v) setNoclip(v) end })
        playerSection:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(v) setInfiniteJump(v) end })
        playerSection:CreateSlider({ Name = "WalkSpeed", Range = {8,300}, Increment = 1, CurrentValue = 16, Callback = function(v) state.WalkSpeed = v end })
        playerSection:CreateSlider({ Name = "JumpPower", Range = {30,300}, Increment = 1, CurrentValue = 50, Callback = function(v) state.JumpPower = v end })
        playerSection:CreateToggle({ Name = "Anti AFK", CurrentValue = false, Callback = function(v) setAntiAFK(v) end })
        playerSection:CreateToggle({ Name = "ESP (Players)", CurrentValue = false, Callback = function(v) setESP(v) end })

        -- Server Tab
        local ServerTab = Window:CreateTab("Server")
        local serverSection = ServerTab:CreateSection("Server Utilities")
        serverSection:CreateToggle({ Name = "Anti-Lag (Client)", CurrentValue = false, Callback = function(v) setAntiLag(v) end })
        serverSection:CreateButton({ Name = "Rejoin", Callback = function() rejoin() end })
        serverSection:CreateButton({ Name = "Server Hop", Callback = function() serverHop() end })
        serverSection:CreateButton({ Name = "Reset Character", Callback = function() localPlayer:LoadCharacter() end })

        -- Fight Tab
        local FightTab = Window:CreateTab("Fight")
        local fightSection = FightTab:CreateSection("Combat (Client-side)")
        fightSection:CreateToggle({ Name = "Auto Click", CurrentValue = false, Callback = function(v) setAutoClick(v) end })
        fightSection:CreateSlider({ Name = "AutoClick Interval", Range = {0.03,1}, Increment = 0.01, CurrentValue = 0.1, Callback = function(v) fightState.AutoClickInterval = v end })
        fightSection:CreateToggle({ Name = "KillAura", CurrentValue = false, Callback = function(v) setKillAura(v) end })
        fightSection:CreateSlider({ Name = "Kill Range", Range = {2,60}, Increment = 1, CurrentValue = 10, Callback = function(v) fightState.KillRange = v end })
        fightSection:CreateSlider({ Name = "Hitbox Size", Range = {1,15}, Increment = 1, CurrentValue = 5, Callback = function(v) setHitboxSize(v) end })
        fightSection:CreateButton({ Name = "Reset Hitboxes", Callback = function() resetHitboxes() end })

        -- Fun Tab
        local FunTab = Window:CreateTab("Fun")
        local funSection = FunTab:CreateSection("Fun & Emotes")
        funSection:CreateButton({ Name = "Load Goon Script (external)", Callback = function() safeLoad(urls.Goon) end })
        funSection:CreateButton({ Name = "Load Dance Script (external)", Callback = function() safeLoad(urls.Dance) end })
        funSection:CreateButton({ Name = "Play Popular Boombox: Megalovania", Callback = function() playAudio(1382096109,5,true) end })
        funSection:CreateButton({ Name = "Stop Boombox", Callback = function() stopAudio() end })

        -- Teleport Tab
        local TP = Window:CreateTab("Teleport")
        local tpSection = TP:CreateSection("Teleport")
        tpSection:CreateInput({ Name = "Player Name", Placeholder = "Type player name...", Flag = "tp_name" })
        tpSection:CreateButton({ Name = "Teleport to Player", Callback = function() local name = Window.Flags["tp_name"].Value; teleportToPlayer(name) end })
        tpSection:CreateButton({ Name = "Save Position", Callback = function()
            local hrp = getHRP()
            if hrp then
                _G.SavedPos = hrp.CFrame
                notify("Sigma Hub","Position saved",2)
            else notify("Sigma Hub","No HRP",2) end
        end})
        tpSection:CreateButton({ Name = "Teleport to Saved", Callback = function()
            if _G.SavedPos and getHRP() then getHRP().CFrame = _G.SavedPos; notify("Sigma Hub","Teleported to saved",2) else notify("Sigma Hub","No saved pos",2) end
        end})

        -- Visuals / Misc
        local VisualTab = Window:CreateTab("Visuals")
        local vSec = VisualTab:CreateSection("Visuals & Misc")
        vSec:CreateToggle({ Name = "Toggle UI (RightCtrl)", CurrentValue = true, Callback = function(v) pcall(function() Window:Toggle(v) end) end })

        -- Boombox Tab
        local BoomTab = Window:CreateTab("Boombox")
        local boomSection = BoomTab:CreateSection("Boombox")
        boomSection:CreateInput({ Name = "Audio ID", Placeholder = "Enter audio id", Flag = "audio_id" })
        boomSection:CreateSlider({ Name = "Volume", Range = {1,10}, Increment = 1, CurrentValue = 5, Flag = "audio_vol" })
        boomSection:CreateToggle({ Name = "Loop", CurrentValue = true, Flag = "audio_loop" })
        boomSection:CreateButton({ Name = "Play Audio", Callback = function()
            local id = tonumber(Window.Flags["audio_id"].Value)
            local vol = tonumber(Window.Flags["audio_vol"].Value) or 5
            local loop = Window.Flags["audio_loop"].Value
            if id then playAudio(id, vol, loop) else notify("Sigma Hub","Invalid ID",2) end
        end})
        boomSection:CreateButton({ Name = "Stop Audio", Callback = function() stopAudio() end })
        boomSection:CreateLabel({ Name = "Popular: Megalovania, Gangnam, Numb, All Star" })

        -- Cleanup on close
        Window:OnClose(function()
            cleanupAll()
            notify("Sigma Hub","Closed & cleaned up",3)
        end)
    else
        -- Fallback UI creation (simple controls). Minimal to avoid massive code duplication.
        local fb = UIroot and UIroot.Frame
        if fb then
            -- Create a few basic buttons for fallback
            local y = 36
            local function addBtn(name, cb)
                local b = regObj(Instance.new("TextButton"))
                b.Parent = fb
                b.Position = UDim2.new(0,12,0,y)
                b.Size = UDim2.new(0,396,0,28)
                b.BackgroundColor3 = Color3.fromRGB(45,45,45)
                b.Text = name
                b.Font = Enum.Font.GothamBold
                b.TextColor3 = Color3.new(1,1,1)
                regObj(Instance.new("UICorner", b)).CornerRadius = UDim.new(0,6)
                regConn(b.MouseButton1Click:Connect(cb))
                y = y + 36
                return b
            end
            addBtn("Toggle Fly", function() setFly(not state.Fly) end)
            addBtn("Toggle Noclip", function() setNoclip(not state.Noclip) end)
            addBtn("Toggle InfJump", function() setInfiniteJump(not state.InfJump) end)
            addBtn("Play Megalovania", function() playAudio(1382096109,5,true) end)
            addBtn("Stop Audio", function() stopAudio() end)
            addBtn("Rejoin", function() rejoin() end)
            addBtn("Server Hop", function() serverHop() end)
            addBtn("Cleanup & Close", function() cleanupAll(); notify("Sigma Hub","Closed",2) end)
            notify("Sigma Hub","Rayfield not found -> using fallback UI",4)
        end
    end

    -- Bind RightCtrl to toggle the UI if Rayfield exists
    if Rayfield and Window then
        regConn(UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.RightControl then
                pcall(function() Window:Toggle() end)
            end
        end))
    else
        -- fallback toggle: hide fallback frame with RightCtrl
        regConn(UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.RightControl and UIroot and UIroot.Screen then
                UIroot.Screen.Enabled = not UIroot.Screen.Enabled
            end
        end))
    end

    -- Final notification
    notify("Sigma Hub", "Loaded (Universal) — Rayfield: "..tostring(Rayfield ~= nil), 4)
end)
