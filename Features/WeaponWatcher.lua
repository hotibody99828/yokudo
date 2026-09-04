-- ==================================================
-- WEAPON SELECTOR WATCHER
-- ==================================================

local AutoHopPage = _G.YOKUDO_AutoHopPage

local function setupWeaponSelectorWatcher()
    task.wait(0.5)
    local weaponButton = nil
    if AutoHopPage then
        for _, child in ipairs(AutoHopPage:GetDescendants()) do
            if child.Name == "WeaponButton" then
                weaponButton = child
                break
            end
        end
    end
    
    if weaponButton then
        weaponButton:GetPropertyChangedSignal("Text"):Connect(function()
            local newType = weaponButton.Text
            if newType ~= _G.YOKUDO_AutoEquip.SelectedType then
                _G.YOKUDO_AutoEquip.SelectedType = newType
                if _G.YOKUDO_AutoDarkBeardEnabled then
                    if _G.YOKUDO_EquipWeaponFromBackpack then
                        _G.YOKUDO_EquipWeaponFromBackpack(newType)
                    end
                end
            end
        end)
    end
end

task.spawn(function()
    task.wait(1)
    setupWeaponSelectorWatcher()
end)

print("✅ WeaponWatcher Loaded")
