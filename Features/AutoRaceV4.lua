-- ==================================================
-- AUTO RACE V4 (Awakening)
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

_G.YOKUDO_AwakeEnabled = false
_G.YOKUDO_AwakeLoopConnection = nil
_G.YOKUDO_AwakeCharConnection = nil
_G.YOKUDO_AwakeBackpackConnection = nil

local function doAwaken()
    local backpack = Player.GetBackpack()
    if backpack then
        local awakening = backpack:FindFirstChild("Awakening")
        if awakening then
            local remote = awakening:FindFirstChildWhichIsA("RemoteFunction")
            if remote then
                pcall(function() remote:InvokeServer(true) end)
            end
        end
    end
end

local function startAutoAwaken()
    if _G.YOKUDO_AwakeLoopConnection then return end
    doAwaken()
    _G.YOKUDO_AwakeLoopConnection = Y.RS.Stepped:Connect(function()
        if not _G.YOKUDO_AwakeEnabled then return end
        doAwaken()
    end)
    _G.YOKUDO_AwakeCharConnection = Player.OnCharacterAdded(function()
        task.wait(1.5)
        if _G.YOKUDO_AwakeEnabled then
            doAwaken()
        end
    end)
    local backpack = Player.GetBackpack()
    if backpack then
        _G.YOKUDO_AwakeBackpackConnection = backpack.ChildAdded:Connect(function(child)
            if child.Name == "Awakening" and _G.YOKUDO_AwakeEnabled then
                task.wait(0.3)
                doAwaken()
            end
        end)
    end
end

local function stopAutoAwaken()
    if _G.YOKUDO_AwakeLoopConnection then
        _G.YOKUDO_AwakeLoopConnection:Disconnect()
        _G.YOKUDO_AwakeLoopConnection = nil
    end
    if _G.YOKUDO_AwakeCharConnection then
        _G.YOKUDO_AwakeCharConnection:Disconnect()
        _G.YOKUDO_AwakeCharConnection = nil
    end
    if _G.YOKUDO_AwakeBackpackConnection then
        _G.YOKUDO_AwakeBackpackConnection:Disconnect()
        _G.YOKUDO_AwakeBackpackConnection = nil
    end
end

function _G.YOKUDO_ToggleAutoRaceV4()
    _G.YOKUDO_AwakeEnabled = not _G.YOKUDO_AwakeEnabled
    if _G.YOKUDO_AwakeEnabled then
        startAutoAwaken()
    else
        stopAutoAwaken()
    end
end

print("✅ AutoRaceV4 Loaded")
