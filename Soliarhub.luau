pcall(function()
    -- executor check
    local exec = (identifyexecutor and identifyexecutor()) or "Unknown"
    print("Executor:", exec)

    -- services
    local s = setmetatable({}, { __index = function(_,v)
        local ok,sv = pcall(game.GetService, game, v)
        return ok and sv or nil
    end})
    local p = s.Players.LocalPlayer
    local uis, rs, sg = s.UserInputService, s.RunService, s.StarterGui

    local function safe(f, ...)
        local ok, err = pcall(f, ...)
        if not ok then warn("[Soliar Error]", err) end
    end

    local function notify(t,m,d)
        safe(function()
            sg:SetCore("SendNotification", {Title=t,Text=m,Duration=d or 3})
        end)
    end

    -- load Rayfield safely
    local Rayfield
    safe(function()
        local src = game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source", true)
        Rayfield = loadstring(src)()
    end)

    if not Rayfield then
        warn("Rayfield failed, using fallback UI.")
        Rayfield = { CreateWindow=function() return {
            CreateTab=function() return {
                CreateButton=function()end,
                CreateToggle=function()end,
                CreateSlider=function()end,
                CreateTextbox=function()end
            } end
        } end }
    end

    local w = Rayfield:CreateWindow({
        Name = "Soliar Hub",
        LoadingTitle = "Soliar Hub",
        LoadingSubtitle = exec,
        KeySystem = false
    })

    ------------------ MAIN TAB ------------------
    local main = w:CreateTab("Main", 4483362458)

    local infjump = false
    main:CreateToggle({
        Name = "Infinite Jump",
        CurrentValue = false,
        Callback = function(v) infjump = v end
    })
    uis.JumpRequest:Connect(function()
        if infjump then
            local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    local noclip = false
    main:CreateToggle({
        Name = "Noclip",
        CurrentValue = false,
        Callback = function(v) noclip = v end
    })
    rs.Stepped:Connect(function()
        if noclip and p.Character then
            for _,v in pairs(p.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)

    local fly, flySpeed = false, 100
    local bv, bg, loop
    main:CreateToggle({
        Name = "Fly",
        CurrentValue = false,
        Callback = function(v) fly = v end
    })
    main:CreateSlider({
        Name = "Fly Speed",
        Range = {10, 500},
        Increment = 10,
        CurrentValue = 100,
        Callback = function(v) flySpeed = v end
    })

    local function startFly()
        safe(function()
            local c = p.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            bv = Instance.new("BodyVelocity", hrp)
            bg = Instance.new("BodyGyro", hrp)
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
            local cam = workspace.CurrentCamera
            loop = rs.Heartbeat:Connect(function()
                if not fly then return end
                local mv = Vector3.new()
                local f, r = cam.CFrame.LookVector, cam.CFrame.RightVector
                if uis:IsKeyDown(Enum.KeyCode.W) then mv += f end
                if uis:IsKeyDown(Enum.KeyCode.S) then mv -= f end
                if uis:IsKeyDown(Enum.KeyCode.A) then mv -= r end
                if uis:IsKeyDown(Enum.KeyCode.D) then mv += r end
                if uis:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0,1,0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftControl) then mv -= Vector3.new(0,1,0) end
                if mv.Magnitude > 0 then mv = mv.Unit * flySpeed end
                bv.Velocity = mv
                bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
            end)
        end)
    end

    local function stopFly()
        safe(function()
            if loop then loop:Disconnect() end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    end

    task.spawn(function()
        while task.wait(0.1) do
            if fly then
                if not loop or not loop.Connected then startFly() end
            else
                stopFly()
            end
        end
    end)

    main:CreateToggle({
        Name = "Anti AFK",
        CurrentValue = false,
        Callback = function(v)
            task.spawn(function()
                while v do
                    safe(function()
                        s.VirtualUser:Button2Down(Vector2.new())
                        task.wait(0.1)
                        s.VirtualUser:Button2Up(Vector2.new())
                    end)
                    task.wait(25)
                end
            end)
        end
    })

    main:CreateButton({
        Name = "Fix Lag (FPS/Ping)",
        Callback = function()
            safe(function()
                local pg = p:FindFirstChildOfClass("PlayerGui")
                if not pg or pg:FindFirstChild("PerfGui") then return end
                local g = Instance.new("ScreenGui", pg)
                g.Name = "PerfGui"
                local f = Instance.new("Frame", g)
                f.Size = UDim2.new(0,200,0,70)
                f.Position = UDim2.new(0,10,0,10)
                f.BackgroundColor3 = Color3.new(0,0,0)
                f.BackgroundTransparency = 0.3
                local fpsL = Instance.new("TextLabel", f)
                fpsL.Size = UDim2.new(1,0,0,35)
                fpsL.BackgroundTransparency = 1
                local pingL = fpsL:Clone()
                pingL.Position = UDim2.new(0,0,0,35)
                pingL.Parent = f
                task.spawn(function()
                    local last = tick()
                    while f and f.Parent do
                        local now = tick()
                        local fps = math.floor(1/math.max(0.001, now-last))
                        last = now
                        local ping = math.floor(p:GetNetworkPing()*1000)
                        fpsL.Text = "FPS: "..fps
                        pingL.Text = "Ping: "..ping.."ms"
                        task.wait(0.5)
                    end
                end)
            end)
        end
    })

    ------------------ PLAYER TAB ------------------
    local pl = w:CreateTab("Player", 4483362458)

    pl:CreateTextbox({
        Name = "JumpPower",
        Text = "50",
        Callback = function(v)
            safe(function()
                local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                if h then h.JumpPower = tonumber(v) or 50 end
            end)
        end
    })

    pl:CreateButton({
        Name = "Speed Script",
        Callback = function()
            safe(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/MrScripterrFr/Speed-Changer/main/Speed%20Changer"))()
            end)
        end
    })

    pl:CreateButton({
        Name = "Click TP",
        Callback = function()
            safe(function()
                loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Click%20Teleport.txt"))()
            end)
        end
    })

    ------------------ SERVER TAB ------------------
    local sv = w:CreateTab("Server", 4483362458)

    sv:CreateButton({
        Name = "R6",
        Callback = function()
            safe(function()
                loadstring(game:HttpGet("https://pastebin.com/raw/jHGVauVX"))()
            end)
        end
    })

    sv:CreateButton({
        Name = "R15",
        Callback = function()
            safe(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/kuragalol/r15/main/reanimation"))()
            end)
        end
    })

    sv:CreateButton({
        Name = "Fling",
        Callback = function()
            safe(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/K1LAS1K/Ultimate-Fling-GUI/main/flingscript.lua"))()
            end)
        end
    })
end)
