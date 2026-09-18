local HOLD_TIME = 0.55
local DELAY_AFTER = 0.3
local SEARCH_KEYWORD = "Chest"

local Players = game:GetService("Players")
local player = Players.LocalPlayer

task.spawn(function()
    while true do
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if rootPart then
            local foundChest = false
            
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    
                    local promptName = string.lower(obj.Name)
                    local parentName = string.lower(obj.Parent.Name)
                    local grandParentName = obj.Parent.Parent and string.lower(obj.Parent.Parent.Name) or ""
                    
                    if string.find(promptName, string.lower(SEARCH_KEYWORD)) or 
                       string.find(parentName, string.lower(SEARCH_KEYWORD)) or 
                       string.find(grandParentName, string.lower(SEARCH_KEYWORD)) then
                        
                        local targetPart = obj.Parent
                        
                        if targetPart and targetPart:IsA("BasePart") then
                            rootPart.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.1)
                            
                            if fireproximityprompt then
                                pcall(function() fireproximityprompt(obj) end)
                            else
                                pcall(function() obj:InputHoldBegin() end)
                                task.wait(HOLD_TIME)
                                pcall(function() obj:InputHoldEnd() end)
                            end
                            
                            foundChest = true
                            task.wait(DELAY_AFTER)
                            break
                        end
                    end
                end
            end
            
            if not foundChest then
                task.wait(0.5)
            end
        else
            task.wait(0.5)
        end
    end
end)
