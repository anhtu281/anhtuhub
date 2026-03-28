--[[
    COOPS SPEEDJOINER - INSTANT LOG EDITION
    Maximum speed with instant console log forwarding
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- ========================
-- INSTANT LOG FORWARDING SYSTEM
-- ========================
local logBuffer = {}
local maxBufferSize = 100
local flushInterval = 0.01  -- Flush every 0.01 seconds (100 times per second)

-- Override print to capture and forward instantly
local oldPrint = print
local oldWarn = warn
local oldError = error

-- Instant console forwarding
local function instantLog(message, logType)
    logType = logType or "INFO"
    
    -- Send to executor console immediately
    if rconsoleprint then
        local timestamp = os.date("%H:%M:%S")
        local prefix = ""
        
        if logType == "WARN" then
            prefix = "⚠️ "
        elseif logType == "ERROR" then
            prefix = "❌ "
        else
            prefix = "✓ "
        end
        
        -- INSTANT OUTPUT - no buffering
        rconsoleprint(string.format("[%s] %s%s\n", timestamp, prefix, tostring(message)))
    end
    
    -- Also buffer for batch operations if needed
    table.insert(logBuffer, {
        time = tick(),
        message = message,
        type = logType
    })
    
    -- Keep buffer size limited
    if #logBuffer > maxBufferSize then
        table.remove(logBuffer, 1)
    end
end

-- Override print functions for instant forwarding
print = function(...)
    local args = {...}
    local message = table.concat({...}, " ")
    oldPrint(...)
    instantLog(message, "INFO")
end

warn = function(...)
    local message = table.concat({...}, " ")
    oldWarn(...)
    instantLog(message, "WARN")
end

-- High-frequency log flusher (even faster)
task.spawn(function()
    while task.wait(flushInterval) do
        if rconsoleclear and #logBuffer > 50 then
            -- Clear console if too many logs
            -- (optional - comment out if you want to keep all logs)
        end
    end
end)

-- ========================
-- ENHANCED EXECUTOR OPTIMIZATION
-- ========================
local function optimizeLogs()
    -- Disable ALL unnecessary Roblox logging
    if setfflag then
        pcall(function()
            setfflag("AbuseReportScreenshotPercentage", "0")
            setfflag("DFFlagDebugAnalytics", "false")
            setfflag("DFFlagDebugVisualizationsEnabled", "false")
            setfflag("FFlagDebugForceFutureIsBrightPhase2", "false")
            setfflag("FFlagDebugForceFutureIsBrightPhase3", "false")
            setfflag("DFFlagDebugEnableLogToCloudForAllPlayers", "false")
        end)
    end
    
    if rconsoleclear then
        rconsoleclear()
    end
    
    if rconsoleinfo then
        rconsoleinfo("⚡ COOPSSPEED - INSTANT LOG EDITION")
        rconsoleinfo("✓ Console forwarding: INSTANT MODE")
    end
    
    -- Set console to highest priority if available
    if setconsoletitle then
        setconsoletitle("COOPSSPEED - INSTANT LOGS")
    end
    
    instantLog("Executor optimization complete", "INFO")
end

optimizeLogs()

-- ========================
-- FPS BOOST STATE
-- ========================
local fpsBoostEnabled = false
local hiddenObjects = {}

-- ========================
-- MAXIMUM NETWORK OPTIMIZATION
-- ========================
local function optimizeNetwork()
    instantLog("Applying network optimizations...", "INFO")
    
    pcall(function()
        -- MAXIMUM network settings
        settings().Network.IncomingReplicationLag = 0
        settings().Network.PhysicsSend = 255
        settings().Network.DataSendRate = 255
        settings().Network.ExperimentalPhysicsEnabled = true
        settings().Network.PhysicsReceive = 255
        
        -- Advanced network tweaks
        if sethiddenproperty then
            pcall(function()
                sethiddenproperty(game:GetService("NetworkClient"), "OutgoingReplicationLag", 0)
            end)
        end
        
        -- Disable network throttling
        if setfflag then
            pcall(function()
                setfflag("DFIntTaskSchedulerTargetFps", "9999")
                setfflag("DFIntTimestepArbiterThresholdCFLThou", "0")
            end)
        end
    end)
    
    -- Physics optimization
    pcall(function()
        settings().Physics.AllowSleep = true
        settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Skip
        settings().Physics.ThrottleAdjustTime = 0
    end)
    
    instantLog("Network optimizations applied", "INFO")
end

optimizeNetwork()

-- ========================
-- MAXIMUM RENDERING OPTIMIZATION
-- ========================
local function optimizeRendering()
    instantLog("Applying rendering optimizations...", "INFO")
    
    pcall(function()
        -- Absolute minimum graphics
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        settings().Rendering.EnableFRM = false
        settings().Rendering.EnableVRMode = false
        
        -- Disable all visual effects
        if sethiddenproperty then
            pcall(function()
                sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
            end)
        end
        
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        
        -- Remove ALL lighting effects
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") 
                or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") 
                or effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = false
            end
        end
        
        -- Set FPS cap to maximum if available
        if setfpscap then
            setfpscap(999)
            instantLog("FPS cap set to 999", "INFO")
        end
    end)
    
    instantLog("Rendering optimizations applied", "INFO")
end

optimizeRendering()

-- ========================
-- FPS BOOST TOGGLE FUNCTION
-- ========================
local function toggleFPSBoost()
    fpsBoostEnabled = not fpsBoostEnabled
    
    if fpsBoostEnabled then
        instantLog("FPS BOOST ENABLED - Hiding environment", "INFO")
        
        local objectsHidden = 0
        
        for _, obj in pairs(workspace:GetDescendants()) do
            pcall(function()
                -- Skip players
                if obj:IsDescendantOf(player.Character) then
                    return
                end
                
                local isPlayerChar = false
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr.Character and obj:IsDescendantOf(plr.Character) then
                        isPlayerChar = true
                        break
                    end
                end
                
                if not isPlayerChar then
                    -- Hide BaseParts
                    if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("Part") 
                        or obj:IsA("UnionOperation") or obj:IsA("TrussPart") then
                        if obj.Transparency < 1 then
                            table.insert(hiddenObjects, {obj = obj, originalTransparency = obj.Transparency})
                            obj.Transparency = 1
                            obj.CanCollide = false
                            objectsHidden = objectsHidden + 1
                        end
                    end
                    
                    -- Hide Decals, Textures
                    if obj:IsA("Decal") or obj:IsA("Texture") then
                        if obj.Transparency < 1 then
                            table.insert(hiddenObjects, {obj = obj, originalTransparency = obj.Transparency})
                            obj.Transparency = 1
                        end
                    end
                    
                    -- Disable ParticleEmitters, Beams, Trails
                    if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                        if obj.Enabled then
                            table.insert(hiddenObjects, {obj = obj, originalEnabled = true})
                            obj.Enabled = false
                        end
                    end
                    
                    -- Disable Lights
                    if obj:IsA("Light") or obj:IsA("SpotLight") or obj:IsA("PointLight") 
                        or obj:IsA("SurfaceLight") then
                        if obj.Enabled then
                            table.insert(hiddenObjects, {obj = obj, originalEnabled = true})
                            obj.Enabled = false
                        end
                    end
                    
                    -- Hide Smoke, Fire, Sparkles
                    if obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                        if obj.Enabled then
                            table.insert(hiddenObjects, {obj = obj, originalEnabled = true})
                            obj.Enabled = false
                        end
                    end
                end
            end)
        end
        
        -- Disable terrain rendering
        pcall(function()
            workspace.Terrain.WaterTransparency = 1
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterWaveSpeed = 0
        end)
        
        instantLog(string.format("FPS BOOST ACTIVE - %d objects hidden", objectsHidden), "INFO")
        
    else
        instantLog("FPS BOOST DISABLED - Restoring environment", "INFO")
        
        local objectsRestored = 0
        
        for _, data in pairs(hiddenObjects) do
            pcall(function()
                if data.originalTransparency then
                    data.obj.Transparency = data.originalTransparency
                    if data.obj:IsA("BasePart") then
                        data.obj.CanCollide = true
                    end
                    objectsRestored = objectsRestored + 1
                elseif data.originalEnabled then
                    data.obj.Enabled = true
                    objectsRestored = objectsRestored + 1
                end
            end)
        end
        
        hiddenObjects = {}
        
        instantLog(string.format("Environment restored - %d objects", objectsRestored), "INFO")
    end
end

-- ========================
-- KEYBIND SETUP (Press 0)
-- ========================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Zero then
        toggleFPSBoost()
    end
end)

-- ========================
-- ULTRA-FAST LOADING SCREEN
-- ========================
local function createCleanLoadingScreen()
    local playerGui = player:WaitForChild("PlayerGui")
    
    if playerGui:FindFirstChild("CoopsSpeed") then
        playerGui.CoopsSpeed:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CoopsSpeed"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999999
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui
    
    -- Clean black overlay
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.2
    overlay.BorderSizePixel = 0
    overlay.Parent = screenGui
    
    -- Main container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = screenGui
    
    -- Sleek scan lines
    for i = 1, 6 do
        local scanline = Instance.new("Frame")
        scanline.Size = UDim2.new(1, 0, 0, 2)
        scanline.Position = UDim2.new(0, 0, 0, -100 - (i * 80))
        scanline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        scanline.BackgroundTransparency = 0.3
        scanline.BorderSizePixel = 0
        scanline.Parent = container
        
        task.spawn(function()
            while container.Visible do
                scanline.Position = UDim2.new(0, 0, 0, -100 - (i * 80))
                TweenService:Create(scanline,
                    TweenInfo.new(1.5, Enum.EasingStyle.Linear),
                    {Position = UDim2.new(0, 0, 1.2, 0)}
                ):Play()
                task.wait(1.5)
            end
        end)
    end
    
    -- "COOPS" text
    local coopsText = Instance.new("TextLabel")
    coopsText.Size = UDim2.new(0, 500, 0, 180)
    coopsText.Position = UDim2.new(0, -550, 0.5, -90)
    coopsText.BackgroundTransparency = 1
    coopsText.Text = "COOPS"
    coopsText.Font = Enum.Font.GothamBlack
    coopsText.TextSize = 110
    coopsText.TextColor3 = Color3.fromRGB(255, 255, 255)
    coopsText.TextStrokeTransparency = 0.7
    coopsText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    coopsText.TextTransparency = 0
    coopsText.Parent = container
    
    -- "SPEED" text
    local speedText = Instance.new("TextLabel")
    speedText.Size = UDim2.new(0, 500, 0, 180)
    speedText.Position = UDim2.new(1, 50, 0.5, -90)
    speedText.BackgroundTransparency = 1
    speedText.Text = "SPEED"
    speedText.Font = Enum.Font.GothamBlack
    speedText.TextSize = 110
    speedText.TextColor3 = Color3.fromRGB(0, 0, 0)
    speedText.TextStrokeTransparency = 0
    speedText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    speedText.TextTransparency = 0
    speedText.Parent = container
    
    -- Bottom bar
    local bottomBar = Instance.new("Frame")
    bottomBar.Size = UDim2.new(0, 0, 0, 4)
    bottomBar.Position = UDim2.new(0.5, 0, 0.72, 0)
    bottomBar.AnchorPoint = Vector2.new(0.5, 0)
    bottomBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bottomBar.BorderSizePixel = 0
    bottomBar.Parent = container
    
    -- Version text
    local versionText = Instance.new("TextLabel")
    versionText.Size = UDim2.new(0, 400, 0, 30)
    versionText.Position = UDim2.new(0.5, -200, 0.74, 0)
    versionText.BackgroundTransparency = 1
    versionText.Text = "INSTANT LOG v3.0"
    versionText.Font = Enum.Font.GothamBold
    versionText.TextSize = 16
    versionText.TextColor3 = Color3.fromRGB(200, 200, 200)
    versionText.TextTransparency = 1
    versionText.Parent = container
    
    -- Corner brackets (simplified for brevity)
    local function createBracket(xPos, yPos, isHorizontal, isFlipped)
        local bracket = Instance.new("Frame")
        if isHorizontal then
            bracket.Size = UDim2.new(0, 40, 0, 3)
        else
            bracket.Size = UDim2.new(0, 3, 0, 40)
        end
        bracket.Position = UDim2.new(xPos, isFlipped and (isHorizontal and -40 or -3) or 0, yPos, isFlipped and (isHorizontal and -3 or -40) or 0)
        bracket.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        bracket.BorderSizePixel = 0
        bracket.Parent = container
        return bracket
    end
    
    local brackets = {
        createBracket(0.2, 0.3, true, false),
        createBracket(0.2, 0.3, false, false),
        createBracket(0.8, 0.3, true, true),
        createBracket(0.8, 0.3, false, true),
        createBracket(0.2, 0.7, true, true),
        createBracket(0.2, 0.7, false, true),
        createBracket(0.8, 0.7, true, true),
        createBracket(0.8, 0.7, false, true),
    }
    
    -- PLAY SOUND
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://"
    sound.Volume = 0.5
    sound.Parent = workspace
    sound.Loaded:Connect(function()
        sound:Play()
    end)
    
    task.spawn(function()
        task.wait(0.1)
        pcall(function() sound:Play() end)
    end)
    
    task.spawn(function()
        task.wait(5)
        sound:Destroy()
    end)
    
    -- FAST ANIMATION
    task.spawn(function()
        task.wait(2)
        task.wait(0.05)
        
        TweenService:Create(coopsText, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -480, 0.5, -90)}):Play()
        
        task.wait(0.05)
        
        TweenService:Create(speedText, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 20, 0.5, -90)}):Play()
        
        task.wait(0.35)
        
        TweenService:Create(bottomBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 800, 0, 4)}):Play()
        
        TweenService:Create(versionText, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        
        task.wait(0.35)
        
        TweenService:Create(coopsText, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(0, -600, 0.5, -90), TextTransparency = 1}):Play()
        
        TweenService:Create(speedText, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(1, 100, 0.5, -90), TextTransparency = 1}):Play()
        
        TweenService:Create(overlay, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(bottomBar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(versionText, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        
        for _, bracket in pairs(brackets) do
            TweenService:Create(bracket, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
        
        task.wait(0.35)
        container:Destroy()
        overlay:Destroy()
    end)
    
    return screenGui
end

-- ========================
-- ENHANCED HUD
-- ========================
local function createCleanHUD(screenGui)
    local hudBar = Instance.new("Frame")
    hudBar.Size = UDim2.new(0, 220, 0, 3)
    hudBar.Position = UDim2.new(0.5, -110, 0, 20)
    hudBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hudBar.BorderSizePixel = 0
    hudBar.Parent = screenGui
    
    local hudText = Instance.new("TextLabel")
    hudText.Size = UDim2.new(0, 220, 0, 30)
    hudText.Position = UDim2.new(0.5, -110, 0, 25)
    hudText.BackgroundTransparency = 1
    hudText.Text = "COOPSSPEED"
    hudText.Font = Enum.Font.GothamBold
    hudText.TextSize = 18
    hudText.TextColor3 = Color3.fromRGB(255, 255, 255)
    hudText.TextStrokeTransparency = 0.5
    hudText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hudText.Parent = screenGui
    
    task.spawn(function()
        while task.wait(1.5) do
            TweenService:Create(hudBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {Size = UDim2.new(0, 240, 0, 3)}):Play()
            task.wait(0.3)
            TweenService:Create(hudBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {Size = UDim2.new(0, 220, 0, 3)}):Play()
        end
    end)
    
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(0, 150, 0, 60)
    statsFrame.Position = UDim2.new(0, 15, 1, -75)
    statsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    statsFrame.BackgroundTransparency = 0.4
    statsFrame.BorderSizePixel = 0
    statsFrame.Parent = screenGui
    
    local statsAccent = Instance.new("Frame")
    statsAccent.Size = UDim2.new(1, 0, 0, 2)
    statsAccent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    statsAccent.BorderSizePixel = 0
    statsAccent.Parent = statsFrame
    
    local statsText = Instance.new("TextLabel")
    statsText.Size = UDim2.new(1, -10, 1, -5)
    statsText.Position = UDim2.new(0, 5, 0, 3)
    statsText.BackgroundTransparency = 1
    statsText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statsText.Font = Enum.Font.Code
    statsText.TextSize = 12
    statsText.TextXAlignment = Enum.TextXAlignment.Left
    statsText.TextYAlignment = Enum.TextYAlignment.Top
    statsText.Text = "FPS: --\nPING: --\nBOOST: OFF"
    statsText.Parent = statsFrame
    
    -- Real-time stats update
    task.spawn(function()
        local lastTime = tick()
        while task.wait(0.1) do  -- Update 10 times per second
            local fps = math.floor(1 / (tick() - lastTime))
            lastTime = tick()
            
            local ping = 0
            pcall(function()
                ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            
            local boostStatus = fpsBoostEnabled and "ON" or "OFF"
            local boostColor = fpsBoostEnabled and "🟢" or "🔴"
            
            statsText.Text = string.format("FPS: %d\nPING: %.0f\nBOOST: %s %s", fps, ping, boostColor, boostStatus)
        end
    end)
    
    local hintFrame = Instance.new("Frame")
    hintFrame.Size = UDim2.new(0, 200, 0, 30)
    hintFrame.Position = UDim2.new(0, 15, 1, -110)
    hintFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    hintFrame.BackgroundTransparency = 0.5
    hintFrame.BorderSizePixel = 0
    hintFrame.Parent = screenGui
    
    local hintText = Instance.new("TextLabel")
    hintText.Size = UDim2.new(1, 0, 1, 0)
    hintText.BackgroundTransparency = 1
    hintText.Text = "Press [0] for FPS Boost"
    hintText.Font = Enum.Font.GothamBold
    hintText.TextSize = 13
    hintText.TextColor3 = Color3.fromRGB(255, 255, 255)
    hintText.Parent = hintFrame
    
    task.spawn(function()
        task.wait(10)
        TweenService:Create(hintFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
        TweenService:Create(hintText, TweenInfo.new(1), {TextTransparency = 1}):Play()
    end)
end

-- ========================
-- ADDITIONAL OPTIMIZATIONS
-- ========================
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()

-- Ultra-fast GUI removal
task.spawn(function()
    while task.wait(0.05) do  -- Check 20 times per second
        for _, gui in pairs(player.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "CoopsSpeed" then
                local name = gui.Name:lower()
                if name:match("loading") or name:match("intro") or name:match("welcome") then
                    pcall(function() gui:Destroy() end)
                end
            end
        end
    end
end)

-- Ultra-fast auto-click
task.spawn(function()
    while task.wait(0.03) do  -- Check 33 times per second
        for _, button in pairs(player.PlayerGui:GetDescendants()) do
            if (button:IsA("TextButton") or button:IsA("ImageButton")) and button.Visible then
                local text = button.Text:lower()
                if text:match("play") or text:match("continue") or text:match("start") or text:match("skip") then
                    pcall(function()
                        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
                            connection:Fire()
                        end
                    end)
                end
            end
        end
    end
end)

-- Aggressive garbage collection
task.spawn(function()
    while task.wait(2) do
        collectgarbage("collect")
    end
end)

-- Disable sounds
task.spawn(function()
    task.wait(1)
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Sound") and not obj:IsDescendantOf(player.Character) then
                obj:Stop()
                obj.Volume = 0
            end
        end
    end)
end)

-- Monitor and log performance
task.spawn(function()
    task.wait(5)
    while task.wait(30) do
        local ping = 0
        local fps = 0
        
        pcall(function()
            ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
        end)
        
        instantLog(string.format("Performance: FPS=%d, PING=%.0f, BOOST=%s", fps, ping, fpsBoostEnabled and "ON" or "OFF"), "INFO")
    end
end)

-- ========================
-- MAIN EXECUTION
-- ========================
instantLog("Starting COOPSSPEED initialization...", "INFO")

local screenGui = createCleanLoadingScreen()

task.wait(3)
createCleanHUD(screenGui)

instantLog("COOPSSPEED fully loaded", "INFO")
instantLog("Press [0] to toggle FPS Boost", "INFO")
instantLog("Instant log forwarding: ACTIVE", "INFO")

print("⚡ COOPSSPEED - INSTANT LOG EDITION")
print("⚡ Console logs are forwarded INSTANTLY")
print("⚡ Press [0] to toggle FPS Boost mode")
