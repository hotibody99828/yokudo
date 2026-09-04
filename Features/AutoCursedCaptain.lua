-- ==================================================
-- AUTO CURSED CAPTAIN (មាន No Clip ពេល Tween)
-- ==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- ==================================================
-- CURSED CAPTAIN POSITION
-- ==================================================
local CURSED_CAPTAIN_POSITION = Vector3.new(-6499, 90, -124)

-- ==================================================
-- TOGGLE DEBOUNCE
-- ==================================================
local isToggling = false

-- ==================================================
-- BYPASS TELEPORT STATE
-- ==================================================
local hasBypassTeleported = false

-- ==================================================
-- TOGGLE PROTECTION
-- ==================================================
local isFeatureRunning = false
local toggleLock = false

-- ==================================================
-- TWEEN TELEPORT VARIABLES
-- ==================================================
local currentTween = nil
local bodyVelocity = nil
local bodyGyro = nil
local isTweening = false
local lockConnection = nil
local isLocked = false
local currentBossPos = nil
local followConnection = nil
local bossTarget = nil
local isBossDead = false
local isTweeningToPosition = false
local bossFound = false
local isAtPosition = false
local isFollowingBoss = false

-- ==================================================
-- NO CLIP FUNCTIONS
-- ==================================================
local function enableNoClip()
    local character = Player.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

local function disableNoClip()
    local character = Player.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ==================================================
-- BYPASS TELEPORT FUNCTION
-- ==================================================
local function bypassTeleport(targetPos)
    local character = Player.Character
    if not character then return false end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health <= 0 then return false end
    
    -- Enable No Clip before teleport
    enableNoClip()
    
    root.CFrame = CFrame.new(targetPos)
    hasBypassTeleported = true
    
    -- Disable No Clip after teleport
    task.wait(0.1)
    disableNoClip()
    
    return true
end

-- ==================================================
-- RESET BYPASS STATE (ពេល Character Respawn)
-- ==================================================
local function resetBypassState()
    hasBypassTeleported = false
end

-- ==================================================
-- TWEEN TELEPORT FUNCTIONS
-- ==================================================

local function cleanupBody()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    isTweening = false
    isLocked = false
    isTweeningToPosition = false
end

local function stopTweenTeleport()
    cleanupBody()
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    isLocked = false
    currentBossPos = nil
    bossTarget = nil
    isTweeningToPosition = false
end

local function stopTweenToPosition()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    isTweening = false
    isTweeningToPosition = false
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end

local function tweenToBoss(bossPos, speed)
    local character = Player.Character
    if not character then return false end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health <= 0 then return false end
    
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    isTweening = false
    isTweeningToPosition = false
    
    if lockConnection then
        lockConnection:Disconnect()
        lockConnection = nil
    end
    isLocked = false
    
    local targetPos = Vector3.new(bossPos.X, bossPos.Y + 30, bossPos.Z)
    local distance = (targetPos - root.Position).Magnitude
    if distance < 3 then 
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        return true 
    end
    
    local duration = math.max(0.10, distance / speed)
    
    local direction = (targetPos - root.Position).Unit
    if not bodyVelocity then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 10000
        bodyVelocity.Parent = root
    end
    bodyVelocity.Velocity = direction * speed
    
    if not bodyGyro then
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1, 1, 1) * 10000
        bodyGyro.Parent = root
    end
    bodyGyro.CFrame = CFrame.lookAt(root.Position, targetPos)
    
    -- Enable No Clip before tween
    enableNoClip()
    
    local tweenInfo = TweenInfo.new(
        duration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    currentTween = TweenService:Create(root, tweenInfo, {
        CFrame = CFrame.new(targetPos)
    })
    
    isTweening = true
    
    currentTween:Play()
    currentTween.Completed:Wait()
    
    if bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
    
    -- Disable No Clip after tween complete
    task.wait(0.1)
    disableNoClip()
    
    if not isTweening then
        return false
    end
    
    return true
end

-- ==================================================
-- FIND CURSED CAPTAIN BOSS
-- ==================================================
local function findCursedCaptain()
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        local boss = enemies:FindFirstChild("Cursed Captain")
        if boss and boss:FindFirstChild("Humanoid") then
            local humanoid = boss.Humanoid
            if humanoid.Health > 0 then
                return boss, "workspace"
            else
                return nil, "dead"
            end
        end
    end
    
    local stored = ReplicatedStorage:FindFirstChild("Cursed Captain")
    if stored then
        return stored, "replicatedstorage"
    end
    
    return nil, nil
end

-- ==================================================
-- AUTO CURSED CAPTAIN LOOP
-- ==================================================
local function cursedCaptainLoop()
    isFeatureRunning = true
    
    while _G.YOKUDO_AutoCursedCaptainEnabled do
        local character = Player.Character
        if not character then
            task.wait(0.01)
            continue
        end
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then
            task.wait(0.01)
            continue
        end
        
        local boss, location = findCursedCaptain()
        
        if not boss then
            if location == "dead" then
                if not isBossDead then
                    isBossDead = true
                    cleanupBody()
                    if followConnection then
                        followConnection:Disconnect()
                        followConnection = nil
                    end
                    isFollowingBoss = false
                    isTweeningToPosition = false
                end
                task.wait(5)
                isBossDead = false
                continue
            end
            
            bossFound = false
            isAtPosition = false
            isFollowingBoss = false
            task.wait(0.01)
            continue
        end
        
        isBossDead = false
        
        if _G.YOKUDO_EquipWeaponFromBackpack then
            local weaponType = "Melee"
            if _G.YOKUDO_AutoEquip then
                weaponType = _G.YOKUDO_AutoEquip.SelectedType
            end
            _G.YOKUDO_EquipWeaponFromBackpack(weaponType)
        end
        
        if location == "workspace" then
            if isTweeningToPosition then
                stopTweenToPosition()
                isTweeningToPosition = false
            end
            
            local bossRoot = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChild("Torso")
            if not bossRoot then
                task.wait(0.01)
                continue
            end
            
            local bossPos = bossRoot.Position
            bossTarget = boss
            currentBossPos = bossPos
            bossFound = true
            isFollowingBoss = true
            
            local dist = (bossPos - root.Position).Magnitude
            
            if dist > 60 then
                tweenToBoss(bossPos, 250)
                
                if followConnection then
                    followConnection:Disconnect()
                    followConnection = nil
                end
                
                followConnection = RunService.Heartbeat:Connect(function()
                    if not _G.YOKUDO_AutoCursedCaptainEnabled then
                        if followConnection then
                            followConnection:Disconnect()
                            followConnection = nil
                        end
                        return
                    end
                    
                    if not bossTarget or not bossTarget.Parent then
                        return
                    end
                    
                    local bossRoot = bossTarget:FindFirstChild("HumanoidRootPart") or bossTarget:FindFirstChild("Torso")
                    if not bossRoot then return end
                    
                    local currentBossPos = bossRoot.Position
                    local char = Player.Character
                    if not char then return end
                    
                    local rootPart = char:FindFirstChild("HumanoidRootPart")
                    if not rootPart then return end
                    
                    local lockPos = Vector3.new(currentBossPos.X, currentBossPos.Y + 30, currentBossPos.Z)
                    
                    local distToLock = (lockPos - rootPart.Position).Magnitude
                    if distToLock > 5 then
                        rootPart.CFrame = CFrame.new(lockPos)
                    end
                    
                    local distToBoss = (currentBossPos - rootPart.Position).Magnitude
                    if distToBoss <= 60 then
                        if _G.YOKUDO_AttackTarget then
                            _G.YOKUDO_AttackTarget(bossTarget)
                        end
                    end
                end)
                
                isLocked = true
            else
                if _G.YOKUDO_AttackTarget then
                    _G.YOKUDO_AttackTarget(boss)
                end
            end
            
            task.wait(0.01)
            continue
        end
        
        if location == "replicatedstorage" then
            bossFound = false
            isAtPosition = false
            isFollowingBoss = false
            
            if not hasBypassTeleported then
                bypassTeleport(CURSED_CAPTAIN_POSITION)
            end
            
            task.wait(0.01)
            continue
        end
    end
    
    isFeatureRunning = false
end

-- ==================================================
-- STATE
-- ==================================================
_G.YOKUDO_AutoCursedCaptainEnabled = false
_G.YOKUDO_AutoCursedCaptainLoop = nil

-- ==================================================
-- TOGGLE AUTO CURSED CAPTAIN (មានការពារ)
-- ==================================================
function _G.YOKUDO_ToggleAutoCursedCaptain()
    if toggleLock then
        return
    end
    
    if isToggling then
        return
    end
    
    isToggling = true
    toggleLock = true
    
    _G.YOKUDO_AutoCursedCaptainEnabled = not _G.YOKUDO_AutoCursedCaptainEnabled
    
    if _G.YOKUDO_AutoCursedCaptainEnabled then
        if isFeatureRunning then
            isToggling = false
            toggleLock = false
            return
        end
        
        hasBypassTeleported = false
        isBossDead = false
        bossFound = false
        isAtPosition = false
        isFollowingBoss = false
        isTweeningToPosition = false
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        if _G.YOKUDO_AutoCursedCaptainLoop then
            _G.YOKUDO_AutoCursedCaptainLoop:Disconnect()
            _G.YOKUDO_AutoCursedCaptainLoop = nil
        end
        
        _G.YOKUDO_AutoCursedCaptainLoop = task.spawn(cursedCaptainLoop)
        print("⚓ Auto Cursed Captain Started")
    else
        if _G.YOKUDO_AutoCursedCaptainLoop then
            task.cancel(_G.YOKUDO_AutoCursedCaptainLoop)
            _G.YOKUDO_AutoCursedCaptainLoop = nil
        end
        
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        
        stopTweenTeleport()
        
        isBossDead = false
        bossFound = false
        isAtPosition = false
        isFollowingBoss = false
        isTweeningToPosition = false
        bossTarget = nil
        currentBossPos = nil
        isLocked = false
        isFeatureRunning = false
        
        print("⚓ Auto Cursed Captain Stopped")
    end
    
    task.wait(0.3)
    isToggling = false
    toggleLock = false
end

-- ==================================================
-- CHARACTER RESPAWN HANDLER
-- ==================================================
Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    resetBypassState()
    
    if _G.YOKUDO_AutoCursedCaptainEnabled then
        stopTweenTeleport()
    end
end)

print("✅ AutoCursedCaptain Loaded (No Clip on Tween)")
