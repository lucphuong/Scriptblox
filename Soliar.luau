-- Soliar Hub - 1 Tab Rayfield Menu (VN)
-- Tên menu: Soliar Hub
-- Ghi chú: dùng có trách nhiệm. Các loadstring từ nguồn ngoài chưa được kiểm chứng.

-- Load Rayfield
local ok, Rayfield = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
end)
if not ok or not Rayfield then
	warn("Không thể load Rayfield. Kiểm tra executor / kết nối.")
	return
end

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Window
local Window = Rayfield:CreateWindow({
	Name = "Soliar Hub",
	LoadingTitle = "Soliar Hub",
	LoadingSubtitle = "Một tab duy nhất - Chính",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "SoliarHubConfig"
	},
	KeySystem = false
})

-- Single Tab "Chính"
local mainTab = Window:CreateTab("Chính", 4483362458)
local mainSection = mainTab:CreateSection("Các chức năng chính")

-- Helper: notify
local function notify(title, text, dur)
	pcall(function()
		StarterGui:SetCore("SendNotification", {Title = title; Text = text; Duration = dur or 3})
	end)
end

-- Helper: safe loadstring from url
local function safeLoadURL(url)
	local s, res = pcall(function()
		return loadstring(game:HttpGet(url, true))()
	end)
	if not s then
		notify("Soliar Hub", "Lỗi load: " .. tostring(res), 4)
		return false, res
	end
	return true, res
end

-- ========= TOGGLES (ON/OFF) =========

-- === Infinite Jump ===
local infJumpEnabled = false
mainSection:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Flag = "infJump",
	Callback = function(state)
		infJumpEnabled = state
		notify("Infinite Jump", state and "Bật" or "Tắt")
	end
})

-- hook JumpRequest
local infJumpConn = nil
infJumpConn = UserInputService.JumpRequest:Connect(function()
	if infJumpEnabled then
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- === Noclip ===
local noclipEnabled = false
mainSection:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Flag = "noclip",
	Callback = function(state)
		noclipEnabled = state
		notify("Noclip", state and "Bật" or "Tắt")
	end
})
-- Noclip implementation
local noclipConn = nil
noclipConn = RunService.Stepped:Connect(function()
	if noclipEnabled then
		local char = LocalPlayer.Character
		if char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)

-- === Fly (toggle) ===
local flyEnabled = false
local flySpeed = 100
mainSection:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Flag = "fly",
	Callback = function(state)
		flyEnabled = state
		notify("Fly", state and "Bật" or "Tắt")
	end
})
mainSection:CreateSlider({
	Name = "Fly Speed",
	Range = {10, 500},
	Increment = 1,
	Suffix = "speed",
	CurrentValue = flySpeed,
	Flag = "flySpeed",
	Callback = function(val)
		flySpeed = val
	end
})
-- Fly implementation (BodyVelocity + BodyGyro)
local flyLoop, flyBV, flyBG
local function startFly()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	hum.PlatformStand = false

	if not flyBV or not flyBV.Parent then
		flyBV = Instance.new("BodyVelocity")
		flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
		flyBV.Velocity = Vector3.new(0,0,0)
		flyBV.Parent = hrp
	end
	if not flyBG or not flyBG.Parent then
		flyBG = Instance.new("BodyGyro")
		flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
		flyBG.CFrame = hrp.CFrame
		flyBG.Parent = hrp
	end

	local camera = workspace.CurrentCamera
	flyLoop = RunService.Heartbeat:Connect(function()
		if not flyEnabled or not hrp then return end
		local moveVec = Vector3.new()
		local forward = camera.CFrame.LookVector
		local right = camera.CFrame.RightVector

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + forward end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - forward end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - right end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + right end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then moveVec = moveVec - Vector3.new(0,1,0) end

		if moveVec.Magnitude > 0 then
			moveVec = moveVec.Unit * flySpeed
		end

		if flyBV then flyBV.Velocity = moveVec end
		if flyBG then flyBG.CFrame = CFrame.new(hrp.Position, hrp.Position + camera.CFrame.LookVector) end
	end)
end

local function stopFly()
	if flyLoop and flyLoop.Connected then flyLoop:Disconnect() end
	if flyBV and flyBV.Parent then flyBV:Destroy(); flyBV = nil end
	if flyBG and flyBG.Parent then flyBG:Destroy(); flyBG = nil end
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = false end
end

-- monitor fly toggle
spawn(function()
	while true do
		wait(0.1)
		if flyEnabled then
			if not flyLoop or (flyLoop and not flyLoop.Connected) then
				startFly()
			end
		else
			stopFly()
		end
	end
end)

-- === Anti-AFK (toggle) ===
local antiAfkEnabled = false
mainSection:CreateToggle({
	Name = "Anti-AFK",
	CurrentValue = false,
	Flag = "antiafk",
	Callback = function(state)
		antiAfkEnabled = state
		notify("Anti-AFK", state and "Bật" or "Tắt")
		if state then
			-- try simple virtual user click every 25s
			spawn(function()
				while antiAfkEnabled do
					pcall(function()
						local vu = game:GetService("VirtualUser")
						vu:Button2Down(Vector2.new(0,0))
						wait(0.1)
						vu:Button2Up(Vector2.new(0,0))
					end)
					wait(25)
				end
			end)
		end
	end
})
-- also try to disable Idled connections when toggled on
mainSection:CreateButton({
	Name = "Force Disable Idled Connections Now",
	Callback = function()
		for i, con in pairs(getconnections and getconnections(LocalPlayer.Idled) or {}) do
			pcall(function() con:Disable() end)
		end
		notify("Anti-AFK", "Đã cố gắng disable các kết nối Idled.", 4)
	end
})

-- ========= BUTTONS (1 lần chạy) =========

-- Speed (external)
mainSection:CreateButton({
	Name = "Speed (run script)",
	Callback = function()
		notify("Speed", "Đang load script Speed...", 3)
		-- original link used earlier
		local ok, err = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/MrScripterrFr/Speed-Changer/main/Speed%20Changer", true))()
		end)
		if not ok then notify("Speed", "Lỗi: "..tostring(err), 4) end
	end
})

-- JumpPower (textbox -> apply once)
local jumpPowerInput = 50
mainSection:CreateTextbox({
	Name = "JumpPower (số)",
	Placeholder = "Mặc định 50",
	Text = "50",
	Flag = "jumpPowerBox",
	Callback = function(txt)
		local n = tonumber(txt)
		if n and LocalPlayer.Character then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.JumpPower = n
				notify("JumpPower", "Đã đặt JumpPower = "..tostring(n), 3)
			end
		else
			notify("JumpPower", "Giá trị không hợp lệ hoặc chưa có character", 4)
		end
	end
})
mainSection:CreateButton({
	Name = "Áp dụng JumpPower",
	Callback = function()
		local txt = Window.Flags["jumpPowerBox"] or "50"
		local n = tonumber(txt) or 50
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.JumpPower = n
			notify("JumpPower", "Đã đặt JumpPower = "..tostring(n), 3)
		else
			notify("JumpPower", "Không tìm thấy Humanoid", 3)
		end
	end
})

-- Teleport to Player GUI (from your snippet)
mainSection:CreateButton({
	Name = "Teleport to Player GUI",
	Callback = function()
		notify("Teleport GUI", "Khởi chạy GUI Teleport...", 3)
		local ok, res = pcall(function()
			-- create simple teleport GUI (safe local copy of provided snippet)
			local Players = game:GetService("Players")
			local LocalPlayer = Players.LocalPlayer
			local ScreenGui = Instance.new("ScreenGui")
			ScreenGui.Name = "SoliarTPGui"
			ScreenGui.ResetOnSpawn = false
			ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
			local Frame = Instance.new("Frame", ScreenGui)
			Frame.Size = UDim2.new(0, 260, 0, 340)
			Frame.Position = UDim2.new(0.5, -130, 0.3, 0)
			Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
			local Title = Instance.new("TextLabel", Frame)
			Title.Size = UDim2.new(1,0,0,30)
			Title.Position = UDim2.new(0,0,0,0)
			Title.Text = "Teleport to Player"
			Title.TextColor3 = Color3.new(1,1,1)
			Title.BackgroundColor3 = Color3.fromRGB(35,35,35)
			local Scrolling = Instance.new("ScrollingFrame", Frame)
			Scrolling.Position = UDim2.new(0,5,0,35)
			Scrolling.Size = UDim2.new(1,-10,1,-75)
			Scrolling.CanvasSize = UDim2.new(0,0,0,0)
			Scrolling.BackgroundColor3 = Color3.fromRGB(20,20,20)
			local UIList = Instance.new("UIListLayout", Scrolling)
			UIList.SortOrder = Enum.SortOrder.LayoutOrder
			local TPButton = Instance.new("TextButton", Frame)
			TPButton.Size = UDim2.new(1,-10,0,30)
			TPButton.Position = UDim2.new(0,5,1,-35)
			TPButton.Text = "Teleport"
			TPButton.Font = Enum.Font.GothamBold
			local teleportTarget = nil
			local function refreshList()
				for _,child in pairs(Scrolling:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				for _,plr in pairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer then
						local b = Instance.new("TextButton", Scrolling)
						b.Size = UDim2.new(1, -10, 0, 25)
						b.Text = plr.Name
						b.Font = Enum.Font.Gotham
						b.MouseButton1Click:Connect(function()
							teleportTarget = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
							TPButton.Text = "Teleport to: "..plr.Name
						end)
					end
				end
			end
			Players.PlayerAdded:Connect(refreshList)
			Players.PlayerRemoving:Connect(refreshList)
			refreshList()
			TPButton.MouseButton1Click:Connect(function()
				if teleportTarget and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					LocalPlayer.Character.HumanoidRootPart.CFrame = teleportTarget.CFrame + Vector3.new(0,3,0)
				end
			end)
		end)
		if not ok then notify("Teleport GUI", "Lỗi: "..tostring(res), 4) end
	end
})

-- Click Teleport (external)
mainSection:CreateButton({
	Name = "Click Teleport (run)",
	Callback = function()
		notify("Click TP", "Đang load Click Teleport...", 3)
		local ok, err = pcall(function()
			loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Click%20Teleport.txt", true))()
		end)
		if not ok then notify("Click TP", "Lỗi: "..tostring(err), 4) end
	end
})

-- Fix Lag (UI + optional load)
mainSection:CreateButton({
	Name = "Fix Lag (show FPS/Ping)",
	Callback = function()
		notify("Fix Lag", "Hiển thị FPS & Ping HUD...", 3)
		-- small HUD for FPS/Ping (local)
		local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
		if not playerGui then notify("Fix Lag", "Không tìm thấy PlayerGui", 3) return end
		if playerGui:FindFirstChild("SoliarPerfGui") then
			notify("Fix Lag", "HUD đã tồn tại", 3)
			return
		end
		local ScreenGui = Instance.new("ScreenGui", playerGui)
		ScreenGui.Name = "SoliarPerfGui"
		ScreenGui.ResetOnSpawn = false
		local Frame = Instance.new("Frame", ScreenGui)
		Frame.Size = UDim2.new(0, 230, 0, 90)
		Frame.Position = UDim2.new(0, 10, 0, 10)
		Frame.Active = true
		Frame.BackgroundTransparency = 0.3
		Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
		local fpsLabel = Instance.new("TextLabel", Frame)
		fpsLabel.Size = UDim2.new(1, -20, 0, 40)
		fpsLabel.Position = UDim2.new(0, 10, 0, 10)
		fpsLabel.BackgroundTransparency = 1
		fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
		fpsLabel.Font = Enum.Font.SourceSansBold
		fpsLabel.TextSize = 20
		local pingLabel = Instance.new("TextLabel", Frame)
		pingLabel.Size = UDim2.new(1, -20, 0, 40)
		pingLabel.Position = UDim2.new(0, 10, 0, 50)
		pingLabel.BackgroundTransparency = 1
		pingLabel.TextXAlignment = Enum.TextXAlignment.Left
		pingLabel.Font = Enum.Font.SourceSansBold
		pingLabel.TextSize = 18
		-- update loop
		spawn(function()
			local last = tick()
			while Frame and Frame.Parent do
				local now = tick()
				local fps = math.floor(1 / math.max(0.0001, now - last))
				last = now
				local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
				pcall(function()
					fpsLabel.Text = "FPS: "..tostring(fps)
					pingLabel.Text = "Ping: "..tostring(ping).." ms"
				end)
				wait(0.5)
			end
		end)
	end
})

-- Fling (external)
mainSection:CreateButton({
	Name = "Fling (run)",
	Callback = function()
		notify("Fling", "Đang load Fling script...", 3)
		local ok, err = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/K1LAS1K/Ultimate-Fling-GUI/main/flingscript.lua", true))()
		end)
		if not ok then notify("Fling", "Lỗi: "..tostring(err), 4) end
	end
})

-- R6 (run)
mainSection:CreateButton({
	Name = "R6 (run)",
	Callback = function()
		notify("R6", "Đang load R6 script...", 3)
		local ok, err = pcall(function()
			loadstring(game:HttpGet("https://pastebin.com/raw/jHGVauVX", true))()
		end)
		if not ok then notify("R6", "Lỗi: "..tostring(err), 4) end
	end
})

-- R15 (run)
mainSection:CreateButton({
	Name = "R15 (run)",
	Callback = function()
		notify("R15", "Đang load R15 reanimation...", 3)
		local ok, err = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/kuragalol/r15/main/reanimation", true))()
		end)
		if not ok then notify("R15", "Lỗi: "..tostring(err), 4) end
	end
})

-- Beng (Bang) (run)
mainSection:CreateButton({
	Name = "Beng (Bang) (run)",
	Callback = function()
		notify("Beng", "Đang load Bang script...", 3)
		local ok, err = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/4gh9/Bang-Script-Gui/main/bang%20gui.lua", true))()
		end)
		if not ok then notify("Beng", "Lỗi: "..tostring(err), 4) end
	end
})

-- Credits Kattt (run)
mainSection:CreateButton({
	Name = "Credits Kattt (run)",
	Callback = function()
		notify("Credits", "Chạy Credits Kattt snippet...", 3)
		-- small snippet to create two buttons as in provided code
		local pg = LocalPlayer:WaitForChild("PlayerGui")
		if pg:FindFirstChild("SoliarCreditsGui") then
			notify("Credits", "Credits GUI đã tồn tại", 3); return
		end
		local ScreenGui = Instance.new("ScreenGui", pg)
		ScreenGui.Name = "SoliarCreditsGui"; ScreenGui.ResetOnSpawn = false
		local R6 = Instance.new("TextButton", ScreenGui)
		R6.Name = "R6"; R6.Size = UDim2.new(0,29,0,29); R6.Position = UDim2.new(0,0.33,0,100)
		R6.Text = "R6"
		R6.MouseButton1Down:Connect(function()
			pcall(function()
				loadstring(game:HttpGet("https://pastebin.com/raw/jHGVauVX", true))()
			end)
		end)
		local TB = Instance.new("TextButton", ScreenGui)
		TB.Size = UDim2.new(0,72,0,27); TB.Position = UDim2.new(0,0,0,160)
		TB.Text = "Team ck"
		TB.MouseButton1Down:Connect(function()
			pcall(function()
				loadstring(game:HttpGet("https://pastebin.com/raw/ukFZuXbb", true))()
			end)
		end)
		notify("Credits", "Đã tạo Credits buttons", 3)
	end
})

-- Click-to-TP (wearedevs) included earlier as Click Teleport button

-- Optional: Quick pack/unpack: Cleanup on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.6)
	-- reapply noclip/fly/infinite jump states if needed
	if noclipEnabled then
		-- noclip will start working automatically on Stepped
	end
	if infJumpEnabled then
		-- inf jump hooked already
	end
end)

-- Load saved config
Rayfield:LoadConfiguration()

-- Ready
notify("Soliar Hub", "Sẵn sàng — Tab: Chính (togg le / button mix)", 4)
