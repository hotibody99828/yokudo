-- ==================================================
-- AUTO BUY LEGENDARY SWORD
-- ==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer

-- ==================================================
-- TOGGLE DEBOUNCE
-- ==================================================
local isToggling = false
local toggleLock = false
local isFeatureRunning = false

-- ==================================================
-- STATE
-- ==================================================
_G.YOKUDO_AutoBuySwordEnabled = false
_G.YOKUDO_AutoBuySwordLoop = nil

-- ==================================================
-- BUY SWORD FUNCTION
-- ==================================================
local function buySword()
    pcall(function()
        local args = {
            "LegendarySwordDealer",
            "2"
        }
        local Remote = ReplicatedStorage:FindFirstChild("Remotes")
        if Remote then
            local CommF = Remote:FindFirstChild("CommF_")
            if CommF then
                CommF:InvokeServer(unpack(args))
            end
        end
    end)
end

-- ==================================================
-- AUTO BUY SWORD LOOP
-- ==================================================
local function buySwordLoop()
    isFeatureRunning = true
    
    while _G.YOKUDO_AutoBuySwordEnabled do
        buySword()
        task.wait(0.05)
    end
    
    isFeatureRunning = false
end

-- ==================================================
-- TOGGLE AUTO BUY SWORD
-- ==================================================
function _G.YOKUDO_ToggleAutoBuySword()
    -- ការពារការចុចភ្លាមៗ
    if toggleLock then
        
        return
    end
    
    if isToggling then
        return
    end
    
    isToggling = true
    toggleLock = true
    
    _G.YOKUDO_AutoBuySwordEnabled = not _G.YOKUDO_AutoBuySwordEnabled
    
    if _G.YOKUDO_AutoBuySwordEnabled then
        -- START
        if isFeatureRunning then
            
            isToggling = false
            toggleLock = false
            return
        end
        
        if _G.YOKUDO_AutoBuySwordLoop then
            _G.YOKUDO_AutoBuySwordLoop:Disconnect()
            _G.YOKUDO_AutoBuySwordLoop = nil
        end
        
        _G.YOKUDO_AutoBuySwordLoop = task.spawn(buySwordLoop)
       
    else
        -- STOP
        if _G.YOKUDO_AutoBuySwordLoop then
            task.cancel(_G.YOKUDO_AutoBuySwordLoop)
            _G.YOKUDO_AutoBuySwordLoop = nil
        end
        
        isFeatureRunning = false
        print("❌ Auto Buy Legendary Sword Stopped")
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
    if _G.YOKUDO_AutoBuySwordEnabled then
        -- Restart loop if feature is enabled
        if _G.YOKUDO_AutoBuySwordLoop then
            task.cancel(_G.YOKUDO_AutoBuySwordLoop)
            _G.YOKUDO_AutoBuySwordLoop = nil
        end
        _G.YOKUDO_AutoBuySwordLoop = task.spawn(buySwordLoop)
    end
end)


