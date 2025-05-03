local Players = game:GetService("Players")

local player = Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats") -- Wait for the leaderstats folder
local cash = leaderstats:WaitForChild("cash") -- Wait for the Cash stat

-- Create the ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CashDisplay"
screenGui.Parent = player:WaitForChild("PlayerGui") -- Add to the player's PlayerGui

-- Create the Frame (with rounded edges)
local frame = Instance.new("Frame")
frame.Name = "CashFrame"
frame.Size = UDim2.new(0, 150, 0, 35) -- Adjust size as needed
frame.Position = UDim2.new(0, 15, 0, 50) -- Top-left corner
frame.BackgroundTransparency = 0.25 -- Semi-transparent
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
frame.BorderSizePixel = 0 -- Remove border
frame.Parent = screenGui

-- Add UICorner for rounded edges
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15) -- Adjust radius for rounded edges
uiCorner.Parent = frame

-- Create the TextLabel
local cashLabel = Instance.new("TextLabel")
cashLabel.Name = "CashLabel"
cashLabel.Size = UDim2.new(1, 0, 1, 0) -- Fill the frame
cashLabel.BackgroundTransparency = 1 -- Fully transparent background
cashLabel.Text = "Cash: 0" -- Default text
cashLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
cashLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- Black outline
cashLabel.TextStrokeTransparency = 0 -- Fully visible outline
cashLabel.Font = Enum.Font.SourceSansBold -- Bold font
cashLabel.TextSize = 24 -- Font size
cashLabel.Parent = frame

-- Update the text whenever the cash value changes
cash:GetPropertyChangedSignal("Value"):Connect(function()
	cashLabel.Text = "Cash: " .. tostring(cash.Value)
end)

-- Initialize the value on load
cashLabel.Text = "Cash: " .. tostring(cash.Value)