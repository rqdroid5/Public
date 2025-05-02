-- Services
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

-- DataStore for saving player cash
local cashDataStore = DataStoreService:GetDataStore("PlayerCashData")

-- Function to handle player joining
local function onPlayerAdded(player)
	-- Create a leaderboard for displaying stats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- Create a "Cash" stat
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = leaderstats

	-- Load the player's saved cash from the DataStore
	local success, savedCash = pcall(function()
		return cashDataStore:GetAsync(player.UserId) -- Use UserId as a unique key
	end)

	if success and savedCash ~= nil then
		cash.Value = savedCash -- Set the player's cash to the saved amount
	else
		cash.Value = 0 -- Default to 0 if no data exists or there was an error
	end

	-- Debug message (optional)
	print(player.Name .. " joined with " .. cash.Value .. " cash.")
end

-- Function to handle player leaving
local function onPlayerRemoving(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local cash = leaderstats:FindFirstChild("Cash")
		if cash then
			-- Save the player's cash to the DataStore
			local success, errorMessage = pcall(function()
				cashDataStore:SetAsync(player.UserId, cash.Value)
			end)

			if not success then
				warn("Failed to save cash for " .. player.Name .. ": " .. errorMessage)
			end
		end
	end
end

-- Connect the events
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Handle errors when the server shuts down
game:BindToClose(function()
	for _, player in pairs(Players:GetPlayers()) do
		onPlayerRemoving(player)
	end
end)