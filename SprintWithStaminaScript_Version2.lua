--[[
SprintWithStaminaScript.lua
Place this script in StarterPlayer > StarterPlayerScripts.
It creates a Sprint/Stamina system and corresponding ScreenGui.

Instructions:
- Hold Left Shift to sprint.
- Stamina drains while sprinting and replenishes when not sprinting.
- GUI at top left shows stamina bar and percentage.

Customize values under CONFIGURATION as needed.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- CONFIGURATION
local SPRINT_SPEED = 24
local WALK_SPEED = 16
local MAX_STAMINA = 100
local STAMINA_DRAIN_RATE = 30 -- per second
local STAMINA_RECOVER_RATE = 20 -- per second
local GUI_BG_COLOR = Color3.fromRGB(30, 30, 30)
local GUI_BAR_COLOR = Color3.fromRGB(44, 170, 255)

-- Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local stamina = MAX_STAMINA
local isSprinting = false
local canSprint = true

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "StaminaGUI"
gui.ResetOnSpawn = false

local bgFrame = Instance.new("Frame")
bgFrame.Name = "BG"
bgFrame.Size = UDim2.new(0, 250, 0, 60)
bgFrame.Position = UDim2.new(0, 15, 0, 15)
bgFrame.BackgroundColor3 = GUI_BG_COLOR
bgFrame.BackgroundTransparency = 0.10
bgFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "Sprint Stamina"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 0)
title.Parent = bgFrame

local barBG = Instance.new("Frame")
barBG.Name = "BarBG"
barBG.Size = UDim2.new(1, -20, 0, 18)
barBG.Position = UDim2.new(0, 10, 0, 30)
barBG.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
barBG.BorderSizePixel = 0
barBG.Parent = bgFrame

local staminaBar = Instance.new("Frame")
staminaBar.Name = "StaminaBar"
staminaBar.Size = UDim2.new(1, 0, 1, 0)
staminaBar.BackgroundColor3 = GUI_BAR_COLOR
staminaBar.BorderSizePixel = 0
staminaBar.Parent = barBG

local percentText = Instance.new("TextLabel")
percentText.Name = "PercentText"
percentText.Text = "100%"
percentText.Font = Enum.Font.Gotham
percentText.TextSize = 14
percentText.TextColor3 = Color3.new(1, 1, 1)
percentText.BackgroundTransparency = 1
percentText.Size = UDim2.new(1, 0, 1, 0)
percentText.Parent = barBG

gui.Parent = player:WaitForChild("PlayerGui")

-- Functions
local function updateGUI()
	local ratio = stamina / MAX_STAMINA
	staminaBar.Size = UDim2.new(math.clamp(ratio, 0, 1), 0, 1, 0)
	percentText.Text = string.format("%d%%", math.floor(ratio * 100))
end

local function isMoving()
	return humanoid.MoveDirection.Magnitude > 0
end

local function setSprinting(state)
	if state and canSprint and stamina > 0 and isMoving() then
		humanoid.WalkSpeed = SPRINT_SPEED
		isSprinting = true
	else
		humanoid.WalkSpeed = WALK_SPEED
		isSprinting = false
	end
end

-- Input
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		if isMoving() then
			setSprinting(true)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift then
		setSprinting(false)
	end
end)

-- Track movement to enable sprinting only while moving
humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
		if isMoving() then
			setSprinting(true)
		else
			setSprinting(false)
		end
	end
end)

-- Main loop
RunService.RenderStepped:Connect(function(dt)
	if isSprinting and stamina > 0 then
		stamina = stamina - STAMINA_DRAIN_RATE * dt
		if stamina <= 0 then
			stamina = 0
			canSprint = false
			setSprinting(false)
		end
	elseif not isSprinting then
		stamina = stamina + STAMINA_RECOVER_RATE * dt
		if stamina >= MAX_STAMINA then
			stamina = MAX_STAMINA
		end
		if stamina > 10 then
			canSprint = true
		end
	end
	updateGUI()
end)

-- Reset stamina on respawn
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
	stamina = MAX_STAMINA
	canSprint = true
	setSprinting(false)
	updateGUI()
	-- Reconnect movement tracker for new humanoid
	humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			if isMoving() then
				setSprinting(true)
			else
				setSprinting(false)
			end
		end
	end)
end)

-- Initial GUI update
updateGUI()