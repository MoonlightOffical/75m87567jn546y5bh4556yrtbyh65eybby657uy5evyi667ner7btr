local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Moonlight HUB | Rayfield",
    LoadingTitle = "Moonlight HUB",
    LoadingSubtitle = "by Nakhun",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MoonlightHub",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local autoFarm = false
local noclipEnabled = false
local autoWalkToPlant = true

local function getOwnedPlot()
    for _, plot in pairs(workspace.Farm:GetChildren()) do
        local important = plot:FindFirstChild("Important") or plot:FindFirstChild("Importanert")
        if important then
            local data = important:FindFirstChild("Data")
            if data and data:FindFirstChild("Owner") and data.Owner.Value == player.Name then
                return plot
            end
        end
    end
    return nil
end

-- Main tab
local MainTab = Window:CreateTab("Main")

MainTab:CreateToggle({
    Name = "Autofarm (Collect + Walk)",
    CurrentValue = false,
    Flag = "AutofarmToggle",
    Callback = function(value)
        autoFarm = value
        print("[Moonlight] Autofarm:", value)
    end,
})

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclipEnabled = value
        print("[Moonlight] Noclip:", value)
    end,
})

-- Gear Shop tab
local GearTab = Window:CreateTab("Gear Shop")

GearTab:CreateButton({
    Name = "Teleport to Gear Shop",
    Callback = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(Vector3.new(-285.41, 2.77, -13.98))
            Rayfield:Notify({
                Title = "Teleported",
                Content = "You have been teleported to the Gear Shop!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Could not find HumanoidRootPart.",
                Duration = 3
            })
        end
    end,
})

-- 🆕 Harvest Event button
GearTab:CreateButton({
    Name = "Harvest Event",
    Callback = function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(Vector3.new(-105.13, 1.4, -10.53))
            Rayfield:Notify({
                Title = "Teleported",
                Content = "You have been teleported to the Harvest Event!",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Could not find HumanoidRootPart.",
                Duration = 3
            })
        end
    end,
})

-- Autofarm loop
spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if autoFarm then
            local plot = getOwnedPlot()
            if plot then
                local important = plot:FindFirstChild("Important")
                if important then
                    local farm = important:FindFirstChild("Plants_Physical")
                    if farm then
                        for _, prompt in pairs(farm:GetDescendants()) do
                            if prompt:IsA("ProximityPrompt") then
                                local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                if rootPart then
                                    local dist = (rootPart.Position - prompt.Parent.Position).Magnitude
                                    if dist <= 20 then
                                        prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
                                        prompt.MaxActivationDistance = 100
                                        prompt.RequiresLineOfSight = false
                                        prompt.Enabled = true
                                        fireproximityprompt(prompt, 1, true)
                                    elseif autoWalkToPlant then
                                        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                                        if humanoid then
                                            humanoid:MoveTo(prompt.Parent.Position + Vector3.new(0, 5, 0))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            task.wait(0.5)
        end
    end
end)

-- Noclip loop
spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if noclipEnabled then
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        else
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            task.wait(0.5)
        end
    end
end)
