
-- ANHTU VERSION - ZERO DELAY
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- LOGGING ĐÃ ĐỔI TÊN
local function log(msg)
    if rconsoleprint then
        rconsoleprint("[ANHTU] " .. msg .. "\n")
    end
    print(msg)
end

-- TẮT DEFAULT LOADING
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()

-- TỐI ƯU HÓA HỆ THỐNG
task.spawn(function()
    pcall(function()
        local n = settings().Network
        n.IncomingReplicationLag = 0
        n.PhysicsSend = 255
        n.DataSendRate = 255
        n.ExperimentalPhysicsEnabled = true
        n.PhysicsReceive = 255
    end)
    
    pcall(function()
        local p = settings().Physics
        p.AllowSleep = true
        p.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Skip
        p.ThrottleAdjustTime = 0
    end)
  
    pcall(function()
        local r = settings().Rendering
        r.QualityLevel = Enum.QualityLevel.Level01
        r.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        r.EnableFRM = false
        r.EnableVRMode = false
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        for _, e in pairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") then e.Enabled = false end
        end
        if setfpscap then setfpscap(999) end
    end)
    
    if setfflag then
        pcall(function()
            setfflag("DFIntTaskSchedulerTargetFps", "9999")
            setfflag("AbuseReportScreenshotPercentage", "0")
        end)
    end
    log("✓ All optimizations applied")
end)

local fpsBoostEnabled = false
local hiddenObjects = {}

local function toggleFPSBoost()
    fpsBoostEnabled = not fpsBoostEnabled
    if fpsBoostEnabled then
        log("🟢 FPS BOOST ON")
        for _, obj in pairs(workspace:GetDescendants()) do
            pcall(function()
                if obj:IsDescendantOf(player.Character) then return end
                local isPlayer = false
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and obj:IsDescendantOf(p.Character) then
                        isPlayer = true
                        break
                    end
                end
                if not isPlayer then
                    if (obj:IsA("BasePart") or obj:IsA("MeshPart")) and obj.Transparency < 1 then
                        table.insert(hiddenObjects, {obj = obj, t = obj.Transparency})
                        obj.Transparency = 1
                        obj.CanCollide = false
                    elseif (obj:IsA("Decal") or obj:IsA("Texture")) and obj.Transparency < 1 then
                        table.insert(hiddenObjects, {obj = obj, t = obj.Transparency})
                        obj.Transparency = 1
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") or 
                           obj:IsA("Light") or obj:IsA("Smoke") or obj:IsA("Fire") then
                        if obj.Enabled then
                            table.insert(hiddenObjects, {obj = obj, e = true})
                            obj.Enabled = false
                        end
                    end
                end
            end)
        end
        pcall(function()
            local t = workspace.Terrain
            t.WaterTransparency = 1
            t.WaterReflectance = 0
            t.WaterWaveSize = 0
            t.WaterWaveSpeed = 0
        end)
    else
        log("🔴 FPS BOOST OFF")
        for _, d in pairs(hiddenObjects) do
            pcall(function()
                if d.t then
                    d.obj.Transparency = d.t
                    if d.obj:IsA("BasePart") then d.obj.CanCollide = true end
                elseif d.e then
                    d.obj.Enabled = true
                end
            end)
        end
        hiddenObjects = {}
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.Zero then
        toggleFPSBoost()
    end
end)

-- GIAO DIỆN (HUD) - ĐÃ ĐỔI TÊN THÀNH ANHTU
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("AnhTu") then
    playerGui.AnhTu:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "AnhTu"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true

local bar = Instance.new("Frame", gui)
bar.Size = UDim2.new(0, 180, 0, 2)
bar.Position = UDim2.new(0.5, -90, 0, 15)
bar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
bar.BorderSizePixel = 0

local title = Instance.new("TextLabel", gui)
title.Size = UDim2.new(0, 180, 0, 25)
title.Position = UDim2.new(0.5, -90, 0, 18)
title.BackgroundTransparency = 1
title.Text = "ANHTU"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(100, 150, 255)
title.TextStrokeTransparency = 0.5

local stats = Instance.new("Frame", gui)
stats.Size = UDim2.new(0, 130, 0, 55)
stats.Position = UDim2.new(0, 10, 1, -65)
stats.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
stats.BackgroundTransparency = 0.3
stats.BorderSizePixel = 0

local statsText = Instance.new("TextLabel", stats)
statsText.Size = UDim2.new(1, -6, 1, -4)
statsText.Position = UDim2.new(0, 3, 0, 2)
statsText.BackgroundTransparency = 1
statsText.TextColor3 = Color3.fromRGB(100, 150, 255)
statsText.Font = Enum.Font.Code
statsText.TextSize = 11
statsText.Text = "FPS: --\nPING: --\nBOOST: 🔴"

gui.Parent = playerGui

-- CẬP NHẬT THÔNG SỐ
task.spawn(function()
    local lt = tick()
    while task.wait(0.25) do
        local fps = math.floor(1 / (tick() - lt))
        lt = tick()
        local ping = 0
        pcall(function() ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
        statsText.Text = string.format("FPS: %d\nPING: %.0f\nBOOST: %s", fps, ping, fpsBoostEnabled and "🟢" or "🔴")
    end
end)

-- AUTO CLEANUP & AUTO CLICK
task.spawn(function()
    while task.wait(0.15) do
        for _, g in pairs(playerGui:GetChildren()) do
            if g:IsA("ScreenGui") and g.Name ~= "AnhTu" then
                local n = g.Name:lower()
                if n:match("load") or n:match("intro") or n:match("welcome") then
                    pcall(function() g:Destroy() end)
                end
            end
        end
    end
end)

log("⚡ ANHTU INSTANT - Ready!")
