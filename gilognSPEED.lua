-- ULTRA INSTANT VERSION - ZERO DELAY
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- INSTANT LOGGING (Simplified)
local function log(msg)
    if rconsoleprint then
        rconsoleprint("[GILOGNSPEED] " .. msg .. "\n")
    end
    print(msg)
end

-- TẮT DEFAULT LOADING NGAY LẬP TỨC
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()

-- APPLY ALL OPTIMIZATIONS INSTANTLY
task.spawn(function()
    -- Network
    pcall(function()
        local n = settings().Network
        n.IncomingReplicationLag = 0
        n.PhysicsSend = 255
        n.DataSendRate = 255
        n.ExperimentalPhysicsEnabled = true
        n.PhysicsReceive = 255
    end)
    
    -- Physics
    pcall(function()
        local p = settings().Physics
        p.AllowSleep = true
        p.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Skip
        p.ThrottleAdjustTime = 0
    end)
    
    -- Rendering
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
    
    -- FFlags
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

-- FPS BOOST FUNCTION
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

-- INSTANT HUD - NO LOADING SCREEN
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("GILOGN") then
    playerGui.GILOGNSpeed:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "GILOGNSpeed"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.IgnoreGuiInset = true

-- Top Bar
local bar = Instance.new("Frame", gui)
bar.Size = UDim2.new(0, 180, 0, 2)
bar.Position = UDim2.new(0.5, -90, 0, 15)
bar.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
bar.BorderSizePixel = 0

local title = Instance.new("TextLabel", gui)
title.Size = UDim2.new(0, 180, 0, 25)
title.Position = UDim2.new(0.5, -90, 0, 18)
title.BackgroundTransparency = 1
title.Text = "GILOGNSPEED"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(100, 150, 255)
title.TextStrokeTransparency = 0.5

-- Stats
local stats = Instance.new("Frame", gui)
stats.Size = UDim2.new(0, 130, 0, 55)
stats.Position = UDim2.new(0, 10, 1, -65)
stats.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
stats.BackgroundTransparency = 0.3
stats.BorderSizePixel = 0

local accent = Instance.new("Frame", stats)
accent.Size = UDim2.new(1, 0, 0, 2)
accent.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
accent.BorderSizePixel = 0

local statsText = Instance.new("TextLabel", stats)
statsText.Size = UDim2.new(1, -6, 1, -4)
statsText.Position = UDim2.new(0, 3, 0, 2)
statsText.BackgroundTransparency = 1
statsText.TextColor3 = Color3.fromRGB(100, 150, 255)
statsText.Font = Enum.Font.Code
statsText.TextSize = 11
statsText.TextXAlignment = Enum.TextXAlignment.Left
statsText.TextYAlignment = Enum.TextYAlignment.Top
statsText.Text = "FPS: --\nPING: --\nBOOST: 🔴"

-- Hint
local hint = Instance.new("TextLabel", gui)
hint.Size = UDim2.new(0, 160, 0, 20)
hint.Position = UDim2.new(0, 10, 1, -90)
hint.BackgroundTransparency = 1
hint.Text = "[0] = FPS Boost"
hint.Font = Enum.Font.GothamBold
hint.TextSize = 11
hint.TextColor3 = Color3.fromRGB(150, 180, 255)
hint.TextXAlignment = Enum.TextXAlignment.Left

gui.Parent = playerGui

-- Stats updater
task.spawn(function()
    local lt = tick()
    while task.wait(0.25) do
        local fps = math.floor(1 / (tick() - lt))
        lt = tick()
        
        local ping = 0
        pcall(function()
            ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        
        statsText.Text = string.format("FPS: %d\nPING: %.0f\nBOOST: %s", 
            fps, ping, fpsBoostEnabled and "🟢" or "🔴")
    end
end)

-- Bar animation
task.spawn(function()
    while task.wait(2.5) do
        TweenService:Create(bar, TweenInfo.new(0.25), {Size = UDim2.new(0, 200, 0, 2)}):Play()
        task.wait(0.25)
        TweenService:Create(bar, TweenInfo.new(0.25), {Size = UDim2.new(0, 180, 0, 2)}):Play()
    end
end)

-- Fade hint
task.spawn(function()
    task.wait(7)
    TweenService:Create(hint, TweenInfo.new(1), {TextTransparency = 1}):Play()
end)

-- Background cleanup
task.spawn(function()
    while task.wait(0.15) do
        for _, g in pairs(playerGui:GetChildren()) do
            if g:IsA("ScreenGui") and g.Name ~= "GILOGNSpeed" then
                local n = g.Name:lower()
                if n:match("load") or n:match("intro") or n:match("welcome") then
                    pcall(function() g:Destroy() end)
                end
            end
        end
    end
end)

-- Auto-click
task.spawn(function()
    while task.wait(0.08) do
        for _, b in pairs(playerGui:GetDescendants()) do
            if (b:IsA("TextButton") or b:IsA("ImageButton")) and b.Visible then
                local t = b.Text:lower()
                if t:match("play") or t:match("continue") or t:match("start") or t:match("skip") then
                    pcall(function()
                        for _, c in pairs(getconnections(b.MouseButton1Click)) do
                            c:Fire()
                        end
                    end)
                end
            end
        end
    end
end)

-- GC
task.spawn(function()
    while task.wait(5) do
        collectgarbage("collect")
    end
end)

-- Mute sounds
task.spawn(function()
    for _, o in pairs(workspace:GetDescendants()) do
        if o:IsA("Sound") and not o:IsDescendantOf(player.Character) then
            o:Stop()
            o.Volume = 0
        end
    end
end)

log("⚡ GILOGNSPEED INSTANT - Ready!")
log("⚡ Load time: <0.1s")

-- AUTO EXEC SAVE
task.spawn(function()
    if writefile and isfolder and makefolder then
        pcall(function()
            if not isfolder("autoexec") then
                makefolder("autoexec")
            end
            
            -- Đọc script hiện tại và lưu
            local scriptContent = game:HttpGet("https://raw.githubusercontent.com/youruser/yourrepo/main/bluesspeed.lua", true)
            writefile("autoexec/bluesspeed.lua", scriptContent)
            
            log("✓ Saved to autoexec")
        end)
    end
end)
