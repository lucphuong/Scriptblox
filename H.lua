local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Bum hub",
   Icon = 0,
   LoadingTitle = "Bum hub |  test",
   LoadingSubtitle = "by Minh",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "FunscriptsGuiFF1"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Key System",
      Subtitle = "To Verify your not a bot, Please type: Key1109888",
      Note = "Key is required to continue!",
      FileName = "Keyforent1r11",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"Key1109888"}
   }
})

local MainTab = Window:CreateTab("Main")

Rayfield:Notify({
   Title = "Welcome!",
   Content = "Enjoy!",
   Duration = 6.5,
   Image = nil,
})

-- Inf Jump
MainTab:CreateToggle({
   Name = "Inf jump",
   Callback = function()
       local InfiniteJumpEnabled = true
       game:GetService("UserInputService").JumpRequest:Connect(function()
           if InfiniteJumpEnabled then
               local char = game.Players.LocalPlayer.Character
               if char then
                   char:FindFirstChildOfClass('Humanoid'):ChangeState(Enum.HumanoidStateType.Jumping)
               end
           end
       end)
   end,
})

-- Walkspeed
MainTab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Fly GUI
MainTab:CreateButton({
   Name = "Fly gui",
   Callback = function()
       local main = Instance.new("ScreenGui")
       local Frame = Instance.new("Frame")
       local up = Instance.new("TextButton")
       local down = Instance.new("TextButton")
       local onof = Instance.new("TextButton")
       local TextLabel = Instance.new("TextLabel")
       local plus = Instance.new("TextButton")
       local speed = Instance.new("TextLabel")
       local mine = Instance.new("TextButton")
       local closebutton = Instance.new("TextButton")
       local mini = Instance.new("TextButton")
       local mini2 = Instance.new("TextButton")

       main.Name = "main"
       main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
       main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
       main.ResetOnSpawn = false

       Frame.Parent = main
       Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
       Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
       Frame.Position = UDim2.new(0.100,0,0.38,0)
       Frame.Size = UDim2.new(0, 190, 0, 57)
       Frame.Active = true
       Frame.Draggable = true

       -- Buttons setup
       up.Name = "up"; up.Parent = Frame; up.BackgroundColor3 = Color3.fromRGB(79,255,152)
       up.Size = UDim2.new(0,44,0,28); up.Font = Enum.Font.SourceSans; up.Text = "UP"; up.TextColor3 = Color3.fromRGB(0,0,0); up.TextSize = 14
       
       down.Name = "down"; down.Parent = Frame; down.BackgroundColor3 = Color3.fromRGB(215,255,121)
       down.Position = UDim2.new(0,0,0.49,0); down.Size = UDim2.new(0,44,0,28); down.Font = Enum.Font.SourceSans; down.Text = "DOWN"; down.TextColor3 = Color3.fromRGB(0,0,0); down.TextSize = 14
       
       onof.Name = "onof"; onof.Parent = Frame; onof.BackgroundColor3 = Color3.fromRGB(255,249,74)
       onof.Position = UDim2.new(0.7,0,0.49,0); onof.Size = UDim2.new(0,56,0,28); onof.Font = Enum.Font.SourceSans; onof.Text = "fly"; onof.TextColor3 = Color3.fromRGB(0,0,0); onof.TextSize = 14
       
       TextLabel.Parent = Frame; TextLabel.BackgroundColor3 = Color3.fromRGB(242,60,255)
       TextLabel.Position = UDim2.new(0.46,0,0,0); TextLabel.Size = UDim2.new(0,100,0,28)
       TextLabel.Font = Enum.Font.SourceSans; TextLabel.Text = "FLY GUI V3"; TextLabel.TextColor3 = Color3.fromRGB(0,0,0); TextLabel.TextScaled = true; TextLabel.TextWrapped = true

       plus.Name = "plus"; plus.Parent = Frame; plus.BackgroundColor3 = Color3.fromRGB(133,145,255)
       plus.Position = UDim2.new(0.23,0,0,0); plus.Size = UDim2.new(0,45,0,28); plus.Font = Enum.Font.SourceSans; plus.Text = "+"; plus.TextColor3 = Color3.fromRGB(0,0,0); plus.TextScaled = true; plus.TextWrapped = true

       speed.Name = "speed"; speed.Parent = Frame; speed.BackgroundColor3 = Color3.fromRGB(255,85,0)
       speed.Position = UDim2.new(0.46,0,0.49,0); speed.Size = UDim2.new(0,44,0,28); speed.Font = Enum.Font.SourceSans; speed.Text = "1"; speed.TextColor3 = Color3.fromRGB(0,0,0); speed.TextScaled = true; speed.TextWrapped = true

       mine.Name = "mine"; mine.Parent = Frame; mine.BackgroundColor3 = Color3.fromRGB(123,255,247)
       mine.Position = UDim2.new(0.23,0,0.49,0); mine.Size = UDim2.new(0,45,0,29); mine.Font = Enum.Font.SourceSans; mine.Text = "-"; mine.TextColor3 = Color3.fromRGB(0,0,0); mine.TextScaled = true; mine.TextWrapped = true

       closebutton.Name = "Close"; closebutton.Parent = Frame
       closebutton.BackgroundColor3 = Color3.fromRGB(225,25,0); closebutton.Size = UDim2.new(0,45,0,28); closebutton.Font = Enum.Font.SourceSans; closebutton.Text = "X"; closebutton.TextSize = 30; closebutton.Position = UDim2.new(0,0,-1,27)

       mini.Name = "minimize"; mini.Parent = Frame
       mini.BackgroundColor3 = Color3.fromRGB(192,150,230); mini.Size = UDim2.new(0,45,0,28); mini.Font = Enum.Font.SourceSans; mini.Text = "-"; mini.TextSize = 40; mini.Position = UDim2.new(0,44,-1,27)

       mini2.Name = "minimize2"; mini2.Parent = Frame
       mini2.BackgroundColor3 = Color3.fromRGB(192,150,230); mini2.Size = UDim2.new(0,45,0,28); mini2.Font = Enum.Font.SourceSans; mini2.Text = "+"; mini2.TextSize = 40; mini2.Position = UDim2.new(0,44,-1,57); mini2.Visible = false

       local speeds = 1
       local nowe = false
       local tpwalking = false
       local speaker = game.Players.LocalPlayer

       -- Fly toggle
       onof.MouseButton1Down:Connect(function()
           nowe = not nowe
           if nowe then
               tpwalking = true
           else
               tpwalking = false
           end
       end)

       -- Close button
       closebutton.MouseButton1Click:Connect(function() main:Destroy() end)

       -- Minimize button
       mini.MouseButton1Click:Connect(function()
           up.Visible = false; down.Visible = false; onof.Visible = false
           plus.Visible = false; speed.Visible = false; mine.Visible = false
           mini.Visible = false; mini2.Visible = true
           Frame.BackgroundTransparency = 1
           closebutton.Position = UDim2.new(0,0,-1,57)
       end)
       mini2.MouseButton1Click:Connect(function()
           up.Visible = true; down.Visible = true; onof.Visible = true
           plus.Visible = true; speed.Visible = true; mine.Visible = true
           mini.Visible = true; mini2.Visible = false
           Frame.BackgroundTransparency = 0
           closebutton.Position = UDim2.new(0,0,-1,27)
       end)
   end,
})

-- God mode
MainTab:CreateToggle({
   Name = "God mode",
   Callback = function()
       local Players = game:GetService("Players")
       local LocalPlayer = Players.LocalPlayer
       local function protectCharacter(char)
           if not char then return end
           local hum = char:FindFirstChildOfClass("Humanoid")
           if not hum then return end
           pcall(function()
               hum.BreakJointsOnDeath = false
               hum.MaxHealth = 1e9
               hum.Health = hum.MaxHealth
               hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
           end)
           hum:GetPropertyChangedSignal("Health"):Connect(function()
               if hum.Health < hum.MaxHealth then
                   hum.Health = hum.MaxHealth
               end
           end)
           hum.Died:Connect(function()
               task.delay(0.05, function()
                   if hum.Parent then
                       hum.Health = hum.MaxHealth
                       hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                   end
               end)
           end)
       end
       LocalPlayer.CharacterAdded:Connect(protectCharacter)
       if LocalPlayer.Character then
           protectCharacter(LocalPlayer.Character)
       end
   end,
})

-- Invisible
MainTab:CreateToggle({
   Name = "invisible",
   Callback = function()
       local Players = game:GetService("Players")
       local LocalPlayer = Players.LocalPlayer
       local function invisCharacter(char)
           if not char then return end
           for _, part in pairs(char:GetDescendants()) do
               if part:IsA("BasePart") then
                   part.LocalTransparencyModifier = 1
               elseif part:IsA("Decal") then
                   part.Transparency = 1
               elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                   part.Handle.LocalTransparencyModifier = 1
               end
           end
       end
       LocalPlayer.CharacterAdded:Connect(invisCharacter)
       if LocalPlayer.Character then
           invisCharacter(LocalPlayer.Character)
       end
   end,
})

-- Click to TP
MainTab:CreateButton({
   Name = "Click to tp",
   Callback = function()
       local UIS = game:GetService("UserInputService")
       local Player = game.Players.LocalPlayer
       local Mouse = Player:GetMouse()
       function GetCharacter() return Player.Character end
       function Teleport(pos)
           local Char = GetCharacter()
           if Char then Char:MoveTo(pos) end
       end
       UIS.InputBegan:Connect(function(input)
           if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
               Teleport(Mouse.Hit.p)
           end
       end)
   end,
})

-- Jerk off R6
MainTab:CreateToggle({
   Name = "jerk off r6",
   Callback = function()
       loadstring(game:HttpGet("https://pastefy.app/lawnvcTT/raw", true))()
   end,
})
