-- ==================================================
-- AUTO RACE V3 (Press T)
-- ==================================================
_G.YOKUDO_EnablePrint = false  -- false = បិទ, true = បើក

local oldPrint = print
print = function(...)
    if _G.YOKUDO_EnablePrint then
        oldPrint(...)
    end
end
local Y = _G.Y
local Player = _G.YOKUDO.Player
local Settings = _G.YOKUDO

_G.YOKUDO_TRaceEnabled = false
_G.YOKUDO_TTimerConnection = nil
_G.YOKUDO_TCharConnection = nil

local cooldown = Settings.Defaults.RaceV3Cooldown
local delayAfterRespawn = 3
local lastPressTime = 0

local function pressT()
    Y.VI:SendKeyEvent(true, "T", false, game)
    task.wait(0.05)
    Y.VI:SendKeyEvent(false, "T", false, game)
    lastPressTime = tick()
end

local function startPressT()
    if _G.YOKUDO_TTimerConnection then return end
    pressT()
    _G.YOKUDO_TTimerConnection = Y.RS.Stepped:Connect(function()
        if not _G.YOKUDO_TRaceEnabled then return end
        if tick() - lastPressTime >= cooldown then
            pressT()
        end
    end)
    _G.YOKUDO_TCharConnection = Player.OnCharacterAdded(function()
        task.wait(delayAfterRespawn)
        if _G.YOKUDO_TRaceEnabled then
            pressT()
        end
    end)
end

local function stopPressT()
    if _G.YOKUDO_TTimerConnection then
        _G.YOKUDO_TTimerConnection:Disconnect()
        _G.YOKUDO_TTimerConnection = nil
    end
    if _G.YOKUDO_TCharConnection then
        _G.YOKUDO_TCharConnection:Disconnect()
        _G.YOKUDO_TCharConnection = nil
    end
    lastPressTime = 0
end

function _G.YOKUDO_ToggleAutoRaceV3()
    _G.YOKUDO_TRaceEnabled = not _G.YOKUDO_TRaceEnabled
    if _G.YOKUDO_TRaceEnabled then
        startPressT()
    else
        stopPressT()
    end
end

print("✅ AutoRaceV3 Loaded")
