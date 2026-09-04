-- ==================================================
-- YOKUDO HUB | SEA2 | [Premium] | Loader
-- ==================================================
-- URL តែមួយគត់៖
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/your-username/YOKUDO-HUB-SEA2/main/Loader.lua"))()
-- ==================================================

local BASE_URL = "https://raw.githubusercontent.com/hotibody99828/yokudo/main/"

_G.YOKUDO_EnablePrint = false  -- false = បិទ, true = បើក

local oldPrint = print
print = function(...)
    if _G.YOKUDO_EnablePrint then
        oldPrint(...)
    end
end
print("🔵 Loading YOKUDO HUB | SEA2 | [Premium]...")

-- ==================================================
-- WAIT UNTIL GAME IS LOADED
-- ==================================================
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("✅ Game loaded, Player: " .. Player.Name)

-- ==================================================
-- AUTO JOIN MARINES (តែម្ដង - ប្រើ Global Variable)
-- ==================================================
-- ប្រើ Global Variable ដើម្បីរក្សាទុក State
if _G.YOKUDO_HasJoinedMarines == nil then
    _G.YOKUDO_HasJoinedMarines = false
end

task.spawn(function()
    -- រង់ចាំ ReplicatedStorage រួចរាល់
    local success, err = pcall(function()
        ReplicatedStorage:WaitForChild("Remotes", 5)
    end)
    
    if success and not _G.YOKUDO_HasJoinedMarines then
        pcall(function()
            local args = {
                "SetTeam2",
                "Marines"
            }
            local Remote = ReplicatedStorage:FindFirstChild("Remotes")
            if Remote then
                local CommF = Remote:FindFirstChild("CommF_")
                if CommF then
                    CommF:InvokeServer(unpack(args))
                    _G.YOKUDO_HasJoinedMarines = true
                    print("⚓ Joined Team Marines!")
                end
            end
        end)
    elseif _G.YOKUDO_HasJoinedMarines then
        print("ℹ️ Already joined Marines in this server, skipping...")
    else
        print("⚠️ ReplicatedStorage.Remotes not found, skipping Auto Join Marines")
    end
end)

-- ==================================================
-- CHARACTER RESPAWN (ការពារកុំឲ្យ Join ម្តងទៀត)
-- ==================================================
Player.CharacterAdded:Connect(function()
    -- ប្រសិនបើបាន Join រួចហើយ → មិន Join ទៀត
    if _G.YOKUDO_HasJoinedMarines then
        return
    end
    
    task.wait(0.5)
    
    -- ព្យាយាម Join ម្តងទៀត (ប្រសិនបើមិនទាន់បាន Join)
    if not _G.YOKUDO_HasJoinedMarines then
        pcall(function()
            local args = {
                "SetTeam2",
                "Marines"
            }
            local Remote = ReplicatedStorage:FindFirstChild("Remotes")
            if Remote then
                local CommF = Remote:FindFirstChild("CommF_")
                if CommF then
                    CommF:InvokeServer(unpack(args))
                    _G.YOKUDO_HasJoinedMarines = true
                    print("⚓ Joined Team Marines! (After Respawn)")
                end
            end
        end)
    end
end)

-- ==================================================
-- LOAD CONFIG & CORE
-- ==================================================
loadstring(game:HttpGet(BASE_URL .. "Config/Settings.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Core/Services.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Core/Player.lua"))()
loadstring(game:HttpGet(BASE_URL .. "Core/Utils.lua"))()

-- ==================================================
-- LOAD UI & TABS
-- ==================================================
task.spawn(function()
    loadstring(game:HttpGet(BASE_URL .. "UI/Toggle.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Main.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Components.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Drag.lua"))()
    loadstring(game:HttpGet(BASE_URL .. "UI/Tabs.lua"))()
    print("✅ UI & Tabs Loaded")
end)

-- ==================================================
-- LOAD FEATURES
-- ==================================================
task.spawn(function()
    local Features = {
        "SpeedHack",
        "JumpHack",
        "AutoEquip",
        "AutoAttack",
        "AutoDarkBeard",
        "AutoHopDarkBeard",
        "AutoCursedCaptain",
        "AutoHopCursedCaptain",
        "AutoCore",
        "AutoBuySword",
        "AutoUnlockHaki",
        "JoinServer",
        "AutoClickAttack",
        "WalkOnWater",
        "AutoBuso",
        "AutoKen",
        "AutoRaceV3",
        "AutoRaceV4",
        "CharacterHandler",
        "WeaponWatcher"
    }
    
    for _, Feature in ipairs(Features) do
        pcall(function()
            loadstring(game:HttpGet(BASE_URL .. "Features/" .. Feature .. ".lua"))()
        end)
    end
    print("✅ All Features Loaded")
end)

print("🚀 YOKUDO HUB | SEA2 | [Premium] Ready!")
