local ScreenGui = Instance.new("ScreenGui")
local TimeFrame = Instance.new("Frame")
local TimeLabel = Instance.new("TextLabel")

-- Set up ScreenGui
ScreenGui.Name = "TimeOfDayDisplayGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Set up TimeFrame
TimeFrame.Name = "TimeFrame"
TimeFrame.Parent = ScreenGui
TimeFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
TimeFrame.BackgroundTransparency = 0.25 -- Semi-transparent
TimeFrame.BorderSizePixel = 0
TimeFrame.Position = UDim2.new(0, 90, 0, 24) -- Top-right corner
TimeFrame.Size = UDim2.new(0, 150, 0, 35) -- Width: 200px, Height: 50px
TimeFrame.AnchorPoint = Vector2.new(0.5, 0.5)
TimeFrame.Visible = true

-- Add rounded corners
local UICorner = Instance.new("UICorner", TimeFrame)
UICorner.CornerRadius = UDim.new(0, 15) -- Rounded corners with 15px radius

-- Set up TimeLabel
TimeLabel.Name = "TimeLabel"
TimeLabel.Parent = TimeFrame
TimeLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- White background (not visible due to transparency)
TimeLabel.BackgroundTransparency = 1 -- Fully transparent
TimeLabel.Size = UDim2.new(1, 0, 1, 0) -- Fill the entire frame
TimeLabel.Font = Enum.Font.SourceSansBold -- Bold font
TimeLabel.Text = "Loading..." -- Placeholder text
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
TimeLabel.TextScaled = true -- Scale text to fit
TimeLabel.TextStrokeTransparency = 0.7 -- Add a subtle stroke to make it more readable
TimeLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- Black stroke

-- Function to format TimeOfDay into "HH:MM" format
local function formatTimeOfDay()
	local timeOfDay = game.Lighting.TimeOfDay -- Get the in-game time of day (HH:MM:SS)
	local hours, minutes = string.match(timeOfDay, "(%d+):(%d+):") -- Extract hours and minutes using pattern matching
	return string.format("%02d:%02d", tonumber(hours), tonumber(minutes)) -- Format as "HH:MM"
end

-- Function to update the TimeOfDay
local function updateTimeOfDay()
	while true do
		local formattedTime = formatTimeOfDay()
		TimeLabel.Text = formattedTime -- Display only the formatted time
		wait(1) -- Update every second
	end
end

-- Start updating the TimeOfDay
spawn(updateTimeOfDay)