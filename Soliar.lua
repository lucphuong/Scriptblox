local ok, Rayfield = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
end)
if not ok or not Rayfield then return end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local function notify(t, m, d)
	pcall(function()
		StarterGui:SetCore("SendNotification", {Title=t, Text=m, Duration=d or 3})
	end)
end

local Window = Rayfield:CreateWindow({
	Name = "Soliar Hub",
	LoadingTitle = "Soliar Hub",
	LoadingSubtitle = "3 Tabs",
	KeySystem = false
})

-- MAIN TAB
local main = Window:CreateTab("Main", 4483362458)

local infJump = false
main:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Callback = function(v) infJump = v end
})
UIS.JumpRequest:Connect(function()
	if infJump then
		local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

local noclip = false
main:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Callback = function(v) noclip = v end
})
RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end
end)

local fly = false
local flySpeed = 100
main:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Callback = function(v) fly = v end
})
main:CreateSlider({
	Name = "Fly Speed",
	Range = {10, 500},
	Increment = 10,
	CurrentValue = flySpeed,
	Callback = function(v) flySpeed = v end
})
local bv, bg, loop
local function startFly()
	local c = LocalPlayer.Character
	if not c then return end
	local hrp = c:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	bv = Instance.new("BodyVelocity", hrp)
	bg = Instance.new("BodyGyro", hrp)
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	local cam = workspace.CurrentCamera
	loop = RunService.Heartbeat:Connect(function()
		if not fly then return end
		local mv = Vector3.new()
		local f = cam.CFrame.LookVector
		local r = cam.CFrame.RightVector
		if UIS:IsKeyDown(Enum.KeyCode.W) then mv += f end
		if UIS:IsKeyDown(Enum.KeyCode.S) then mv -= f end
		if UIS:IsKeyDown(Enum.KeyCode.A) then mv -= r end
		if UIS:IsKeyDown(Enum.KeyCode.D) then mv += r end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then mv -= Vector3.new(0,1,0) end
		if mv.Magnitude > 0 then mv = mv.Unit * flySpeed end
		bv.Velocity = mv
		bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
	end)
end
local function stopFly()
	if loop then loop:Disconnect() end
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
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

local anti = false
main:CreateToggle({
	Name = "Anti AFK",
	CurrentValue = false,
	Callback = function(v)
		anti = v
		if v then
			task.spawn(function()
				while anti do
					pcall(function()
						game:GetService("VirtualUser"):Button2Down(Vector2.new())
						task.wait(0.1)
						game:GetService("VirtualUser"):Button2Up(Vector2.new())
					end)
					task.wait(25)
				end
			end)
		end
	end
})

main:CreateButton({
	Name = "Fix Lag (FPS/Ping)",
	Callback = function()
		local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if not pg or pg:FindFirstChild("PerfGui") then return end
		local s = Instance.new("ScreenGui", pg)
		s.Name = "PerfGui"
		local f = Instance.new("Frame", s)
		f.Size = UDim2.new(0,200,0,70)
		f.Position = UDim2.new(0,10,0,10)
		f.BackgroundTransparency = 0.3
		f.BackgroundColor3 = Color3.new(0,0,0)
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
				local ping = math.floor(LocalPlayer:GetNetworkPing()*1000)
				fpsL.Text = "FPS: "..fps
				pingL.Text = "Ping: "..ping.."ms"
				task.wait(0.5)
			end
		end)
	end
})

-- PLAYER TAB
local player = Window:CreateTab("Player", 4483362458)

player:CreateTextbox({
	Name = "JumpPower",
	Text = "50",
	Callback = function(v)
		local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if h then h.JumpPower = tonumber(v) or 50 end
	end
})

player:CreateButton({
	Name = "Speed Script",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/MrScripterrFr/Speed-Changer/main/Speed%20Changer"))()
	end
})

player:CreateButton({
	Name = "Teleport GUI",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/lucphuong/Scriptblox/main/teleport.lua"))()
	end
})

player:CreateButton({
	Name = "Click Teleport",
	Callback = function()
		loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Click%20Teleport.txt"))()
	end
})

player:CreateButton({
	Name = "Bang Script",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/4gh9/Bang-Script-Gui/main/bang%20gui.lua"))()
	end
})

-- SERVER TAB
local server = Window:CreateTab("Server", 4483362458)

server:CreateButton({
	Name = "R6",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/jHGVauVX"))()
	end
})

server:CreateButton({
	Name = "R15",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/kuragalol/r15/main/reanimation"))()
	end
})

server:CreateButton({
	Name = "Fling",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/K1LAS1K/Ultimate-Fling-GUI/main/flingscript.lua"))()
	end
})

server:CreateButton({
	Name = "Credits GUI",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/ukFZuXbb"))()
	end
})
