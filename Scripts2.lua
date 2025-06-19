-- Roblox Murderers vs Sheriffs Script with Custom GUI for Velocity Executor
-- Features: Hitbox Expander, Skeleton ESP with Color Picker, Draggable Menu, Rainbow Skrr Title, Telegram Link
-- Success Message: "Успешно!"
-- GUI Library: Rayfield (compatible with Velocity)
-- Menu Toggle: Press English 'T' to show/hide (Enum.KeyCode.T)

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/Rayfield-Interface/Rayfield/main/source'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Success Message
print("Успешно! ✅")

-- Create GUI Window (Draggable)
local Window = Rayfield:CreateWindow({
    Name = "Skrr 🌈",
    LoadingTitle = "Loading Skrr Menu",
    LoadingSubtitle = "by @piska_softs",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SkrrConfig",
        FileName = "Settings"
    },
    Discord = {
        Enabled = true,
        Invite = "zA6bKNNaDp", -- Placeholder Discord invite
        RememberJoins = true
    },
    KeySystem = false
})

-- Make Window Draggable
Window:SetDraggable(true)

-- Customize Window Appearance (Grey Theme)
local CustomTheme = {
    Background = Color3.fromRGB(40, 40, 40),
    TitleBackground = Color3.fromRGB(30, 30, 30),
    TitleText = Color3.fromRGB(255, 255, 255),
    TabBackground = Color3.fromRGB(50, 50, 50),
    TabText = Color3.fromRGB(200, 200, 200),
    ButtonBackground = Color3.fromRGB(60, 60, 60),
    ButtonText = Color3.fromRGB(255, 255, 255),
    ToggleBackground = Color3.fromRGB(70, 70, 70),
    ToggleEnabled = Color3.fromRGB(0, 255, 0),
    ToggleDisabled = Color3.fromRGB(255, 0, 0)
}
for key, value in pairs(CustomTheme) do
    Rayfield:SetThemeProperty(key, value)
end

-- Rainbow Title Effect for "Skrr"
local function UpdateRainbowTitle()
    while true do
        for i = 0, 1, 0.01 do
            local color = Color3.fromHSV(i, 1, 1)
            Window:SetTitle("Skrr 🌈", color)
            wait(0.05)
        end
    end
end
spawn(UpdateRainbowTitle)

-- Menu Toggle with English 'T' Key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.T then
        Rayfield:ToggleWindow()
        Rayfield:Notify({
            Title = "Menu " .. (Rayfield:IsWindowVisible() and "Opened ✅" or "Closed ❌"),
            Content = "Menu visibility toggled with 'T'",
            Duration = 3,
            Image = nil
        })
    end
end)

-- Hitbox Settings
local HitboxSettings = {
    Enabled = false,
    Size = 5
}

-- ESP Settings
local ESPSettings = {
    Enabled = false,
    Color = Color3.fromRGB(255, 255, 255)
}

-- Function to Determine Enemy Players
local function IsEnemy(Player)
    if Player == LocalPlayer or not Player.Character or not Player.Character:FindFirstChild("Humanoid") or Player.Character.Humanoid.Health <= 0 then
        return false
    end
    -- In Murderers vs Sheriffs, roles are often determined by team or role-specific indicators
    -- Assuming 'Team' or role-based check (simplified for demonstration)
    local localRole = LocalPlayer:GetAttribute("Role") or LocalPlayer.Team -- Adjust based on game mechanics
    local playerRole = Player:GetAttribute("Role") or Player.Team
    return localRole ~= playerRole -- Enemies have different roles/teams
end

-- Hitbox Function
local function UpdateHitboxes()
    for _, Player in pairs(Players:GetPlayers()) do
        if IsEnemy(Player) and Player.Character then
            local HumanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")
            if HumanoidRootPart then
                if HitboxSettings.Enabled then
                    HumanoidRootPart.Size = Vector3.new(HitboxSettings.Size, HitboxSettings.Size, HitboxSettings.Size)
                    HumanoidRootPart.Transparency = 0.7
                    HumanoidRootPart.BrickColor = BrickColor.new("Really red") -- Visual feedback
                else
                    HumanoidRootPart.Size = Vector3.new(2, 2, 1) -- Default size
                    HumanoidRootPart.Transparency = 0
                    HumanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
                end
            end
        end
    end
end

-- Skeleton ESP Function
local function CreateSkeletonESP(Player)
    if not Player.Character or not IsEnemy(Player) then return end
    local Character = Player.Character
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then return end

    local Bones = {}
    local function CreateBone(Part1, Part2)
        if not Part1 or not Part2 then return end
        local Line = Drawing.new("Line")
        Line.Visible = false
        Line.Color = ESPSettings.Color
        Line.Thickness = 2
        table.insert(Bones, Line)
        return Line
    end

    -- Define skeleton connections (simplified)
    local Head = Character:FindFirstChild("Head")
    local Torso = Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("Torso")
    local LeftArm = Character:FindFirstChild("LeftUpperArm") or Character:FindFirstChild("Left Arm")
    local RightArm = Character:FindFirstChild("RightUpperArm") or Character:FindFirstChild("Right Arm")
    local LeftLeg = Character:FindFirstChild("LeftUpperLeg") or Character:FindFirstChild("Left Leg")
    local RightLeg = Character:FindFirstChild("RightUpperLeg") or Character:FindFirstChild("Right Leg")

    if Head and Torso then CreateBone(Head, Torso) end
    if Torso and LeftArm then CreateBone(Torso, LeftArm) end
    if Torso and RightArm then CreateBone(Torso, RightArm) end
    if Torso and LeftLeg then CreateBone(Torso, LeftLeg) end
    if Torso and RightLeg then CreateBone(Torso, RightLeg) end

    -- Update ESP
    local Connection
    Connection = RunService.RenderStepped:Connect(function()
        if not Player.Character or not Character:FindFirstChild("Humanoid") or Character.Humanoid.Health <= 0 or not ESPSettings.Enabled or not IsEnemy(Player) then
            for _, Line in pairs(Bones) do Line:Remove() end
            Connection:Disconnect()
            return
        end
        for _, Line in pairs(Bones) do
            Line.Color = ESPSettings.Color
            Line.Visible = ESPSettings.Enabled
            -- Update positions (simplified for head-to-torso as example)
            if Line.From and Line.To then
                local Part1, Part2 = Line.From, Line.To
                local Pos1, Pos2 = Workspace.CurrentCamera:WorldToViewportPoint(Part1.Position)
                local Pos3, Pos4 = Workspace.CurrentCamera:WorldToViewportPoint(Part2.Position)
                Line.From = Vector2.new(Pos1.X, Pos1.Y)
                Line.To = Vector2.new(Pos3.X, Pos3.Y)
            end
        end
    end)

    return Bones
end

-- Initialize ESP for All Players
local ESPLines = {}
local function InitializeESP()
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            ESPLines[Player] = CreateSkeletonESP(Player)
        end
    end
end
Players.PlayerAdded:Connect(function(Player)
    ESPLines[Player] = CreateSkeletonESP(Player)
end)
Players.PlayerRemoving:Connect(function(Player)
    if ESPLines[Player] then
        for _, Line in pairs(ESPLines[Player]) do
            Line:Remove()
        end
        ESPLines[Player] = nil
    end
end)

-- Update Hitboxes Periodically
RunService.Heartbeat:Connect(UpdateHitboxes)

-- Main Tab
local MainTab = Window:CreateTab("Main 🎮", nil)

-- Hitbox Toggle
MainTab:CreateToggle({
    Name = "Enable Hitbox 🎯",
    CurrentValue = false,
    Flag = "HitboxToggle",
    Callback = function(Value)
        HitboxSettings.Enabled = Value
        Rayfield:Notify({
            Title = "Hitbox " .. (Value and "Enabled ✅" or "Disabled ❌"),
            Content = "Hitbox expansion is now " .. (Value and "on" or "off"),
            Duration = 3,
            Image = nil
        })
    end
})

-- Hitbox Size Slider
MainTab:CreateSlider({
    Name = "Hitbox Size 📏",
    Range = {1, 10},
    Increment = 0.1,
    Suffix = "Studs",
    CurrentValue = 5,
    Flag = "HitboxSizeSlider",
    Callback = function(Value)
        HitboxSettings.Size = Value
        Rayfield:Notify({
            Title = "Hitbox Size Updated 🔄",
            Content = "Hitbox size set to " .. Value .. " studs",
            Duration = 3,
            Image = nil
        })
    end
})

-- ESP Toggle
MainTab:CreateToggle({
    Name = "Enable Skeleton ESP 👁️",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        ESPSettings.Enabled = Value
        InitializeESP()
        Rayfield:Notify({
            Title = "Skeleton ESP " .. (Value and "Enabled ✅" or "Disabled ❌"),
            Content = "Skeleton ESP is now " .. (Value and "on" or "off"),
            Duration = 3,
            Image = nil
        })
    end
})

-- ESP Color Picker
MainTab:CreateColorPicker({
    Name = "Skeleton Color 🎨",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ESPColorPicker",
    Callback = function(Value)
        ESPSettings.Color = Value
        Rayfield:Notify({
            Title = "Skeleton Color Updated 🔄",
            Content = "Skeleton color changed",
            Duration = 3,
            Image = nil
        })
    end
})

-- Telegram Label
MainTab:CreateLabel("<b>Telegram: <font color='rgb(255,255,255)'>@piska_softs</font> 📩</b>")

-- Cleanup on Script End
game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
    for _, Player in pairs(ESPLines) do
        for _, Line in pairs(Player) do
            Line:Remove()
        end
    end
    Rayfield:Destroy()
end)
