-- ==================================================
-- TABS
-- ==================================================

local Y = _G.Y
local Services = _G.YOKUDO.Services
local Settings = _G.YOKUDO

-- Create Pages
local InfoPage = CreatePage("INFO")
local ShopPage = CreatePage("SHOP")
local AutoHopPage = CreatePage("AUTO_HOP")
local DarkBeardPage = CreatePage("DARK_BEARD")
local CursedCaptainPage = CreatePage("CURSED_CAPTAIN")
local CorePage = CreatePage("CORE")
local SwordPage = CreatePage("SWORD_LEGENDARY")
local HakiPage = CreatePage("HAKI_LEGENDARY")
local FruitPage = CreatePage("FRUIT")
local BerryPage = CreatePage("BERRY")
local SettingPage = CreatePage("SETTING")

-- Create Tabs
local InfoTab = CreateTab("Info", 1)
local ShopTab = CreateTab("Shop", 2)
local AutoHopTab = CreateTab("Auto Hop", 3)
local DarkBeardTab = CreateTab("Dark Beard", 4)
local CursedCaptainTab = CreateTab("Cursed Captain", 5)
local CoreTab = CreateTab("Core", 6)
local SwordTab = CreateTab("Sword Legendary", 7)
local HakiTab = CreateTab("Haki Legendary", 8)
local FruitTab = CreateTab("Fruit", 9)
local BerryTab = CreateTab("Berry", 10)
local SettingTab = CreateTab("Setting", 11)

-- Tab Map
local Tabs = {
    [InfoTab] = InfoPage,
    [ShopTab] = ShopPage,
    [AutoHopTab] = AutoHopPage,
    [DarkBeardTab] = DarkBeardPage,
    [CursedCaptainTab] = CursedCaptainPage,
    [CoreTab] = CorePage,
    [SwordTab] = SwordPage,
    [HakiTab] = HakiPage,
    [FruitTab] = FruitPage,
    [BerryTab] = BerryPage,
    [SettingTab] = SettingPage
}

local function SelectTab(SelectedTab, SelectedPage)
    for Tab, Page in pairs(Tabs) do
        Page.Visible = false
        local Indicator = Tab:FindFirstChild("Indicator")
        local TabText = Tab:FindFirstChild("TabText")
        Y.TS:Create(Tab, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        if Indicator then
            Y.TS:Create(Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end
        if TabText then
            Y.TS:Create(TabText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(155, 155, 175)}):Play()
        end
    end

    SelectedPage.Visible = true
    task.wait(0.05)
    pcall(function()
        SelectedPage.CanvasPosition = Vector2.new(0, 0)
    end)

    Y.TS:Create(SelectedTab, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    local Indicator = SelectedTab:FindFirstChild("Indicator")
    local TabText = SelectedTab:FindFirstChild("TabText")
    if Indicator then
        Y.TS:Create(Indicator, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
    end
    if TabText then
        Y.TS:Create(TabText, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end
end

for Tab, Page in pairs(Tabs) do
    Tab.MouseButton1Click:Connect(function()
        SelectTab(Tab, Page)
    end)
end

SelectTab(InfoTab, InfoPage)

-- ==================================================
-- REFRESH BUTTONS
-- ==================================================
CreateRefreshButton(DarkBeardPage, 1)
CreateRefreshButton(CursedCaptainPage, 1)
CreateRefreshButton(CorePage, 1)
CreateRefreshButton(SwordPage, 1)
CreateRefreshButton(HakiPage, 1)
CreateRefreshButton(FruitPage, 1)
CreateRefreshButton(BerryPage, 1)

-- ==================================================
-- AUTO HOP TAB
-- ==================================================
CreateSectionTitle(AutoHopPage, "Select Weapon for attack", 1)
CreateWeaponDropdown(AutoHopPage, 2)

local clickAttackFrame, clickAttackCheckbox, getClickAttackState = CreateCheckbox(AutoHopPage, "Auto Click Attack", 3)

CreateSectionTitle(AutoHopPage, "Farm Boss", 4)
local darkBeardFrame, darkBeardCheckbox, getDarkBeardState = CreateCheckbox(AutoHopPage, "Auto Darkbeard", 5)

local hopDarkBeardFrame, hopDarkBeardCheckbox, getHopDarkBeardState = CreateCheckbox(AutoHopPage, "Auto Hop Darkbeard", 6)

CreateSectionTitle(AutoHopPage, "Farm Boss", 7)

-- Auto Cursed Captain
local cursedCaptainFrame, cursedCaptainCheckbox, getCursedCaptainState = CreateCheckbox(AutoHopPage, "Auto Cursed Captain", 8)

-- Auto Hop Cursed Captain
local hopCursedCaptainFrame, hopCursedCaptainCheckbox, getHopCursedCaptainState = CreateCheckbox(AutoHopPage, "Auto Hop Cursed Captain", 9)

CreateSectionTitle(AutoHopPage, "Farm Boss", 10)

-- Auto Core
local coreFrame, coreCheckbox, getCoreState = CreateCheckbox(AutoHopPage, "Auto Core", 11)

clickAttackCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoClickAttack then
        _G.YOKUDO_ToggleAutoClickAttack()
    end
end)

darkBeardCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoDarkBeard then
        _G.YOKUDO_ToggleAutoDarkBeard()
    end
end)

hopDarkBeardCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopDarkBeard then
        _G.YOKUDO_ToggleAutoHopDarkBeard()
    end
end)

cursedCaptainCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoCursedCaptain then
        _G.YOKUDO_ToggleAutoCursedCaptain()
    end
end)

hopCursedCaptainCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoHopCursedCaptain then
        _G.YOKUDO_ToggleAutoHopCursedCaptain()
    end
end)

coreCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoCore then
        _G.YOKUDO_ToggleAutoCore()
    end
end)

-- ==================================================
-- SETTING TAB (UPDATED - គ្មាន Tween Speed & Auto Race)
-- ==================================================

-- Tween Settings (មានតែ Stop Tween Button)
CreateSectionTitle(SettingPage, "Tween Settings", 1)
CreateStopTweenButton(SettingPage, 2)

CreateSectionTitle(SettingPage, "Other", 3)
local noClipFrame, noClipCheckbox, getNoClipState = CreateCheckbox(SettingPage, "No Clip", 4)

CreateSectionTitle(SettingPage, "Auto Abilities", 5)
local busoFrame, busoCheckbox, getBusoState = CreateCheckbox(SettingPage, "Auto Buso", 6)
local obsFrame, obsCheckbox, getObsState = CreateCheckbox(SettingPage, "Auto Ken", 7)

CreateSectionTitle(SettingPage, "Movement Hacks", 8)
local jumpHolder, jumpCheckbox, getJumpState, jumpTextBox, getJumpValue = CreateTextBoxWithCheckbox(SettingPage, "Jump Hack", 9)
local speedHolder, speedCheckbox, getSpeedState, speedTextBox, getSpeedValue = CreateTextBoxWithCheckbox(SettingPage, "Speed Hack", 10)
local walkFrame, walkCheckbox, getWalkState = CreateCheckbox(SettingPage, "Walk on Water", 11)

-- ==================================================
-- SETTING CHECKBOX EVENTS
-- ==================================================
busoCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoBuso then
        _G.YOKUDO_ToggleAutoBuso()
    end
end)

obsCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoKen then
        _G.YOKUDO_ToggleAutoKen()
    end
end)

walkCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleWalkOnWater then
        _G.YOKUDO_ToggleWalkOnWater()
    end
end)

noClipCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleNoClip then
        _G.YOKUDO_ToggleNoClip()
    end
end)

-- ==================================================
-- SHOP TAB
-- ==================================================

-- ==================================================
-- TITLE: Shop
-- ==================================================
CreateSectionTitle(ShopPage, "Shop", 1)

-- Auto Buy Legendary Sword
local buySwordFrame, buySwordCheckbox, getBuySwordState = CreateCheckbox(ShopPage, "Auto Buy Legendary Sword", 2)

-- Auto Unlock Haki Legendary
local unlockHakiFrame, unlockHakiCheckbox, getUnlockHakiState = CreateCheckbox(ShopPage, "Auto Unlock Haki Legendary", 3)

-- ==================================================
-- TITLE: Join Server With Jobid
-- ==================================================
CreateSectionTitle(ShopPage, "Join Server With Jobid", 4)

-- JobId TextBox + Button
local jobIdHolder = Instance.new("Frame")
jobIdHolder.Name = "JobIdHolder"
jobIdHolder.Size = UDim2.new(1, 0, 0, 32)
jobIdHolder.BackgroundTransparency = 1
jobIdHolder.BorderSizePixel = 0
jobIdHolder.LayoutOrder = 5
jobIdHolder.ZIndex = 9
jobIdHolder.Parent = ShopPage

local jobIdLabel = Instance.new("TextLabel")
jobIdLabel.Name = "JobIdLabel"
jobIdLabel.Size = UDim2.new(0, 80, 1, 0)
jobIdLabel.Position = UDim2.new(0, 0, 0, 0)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.Text = "JobId:"
jobIdLabel.TextColor3 = Color3.fromRGB(205, 205, 220)
jobIdLabel.TextSize = 12
jobIdLabel.TextXAlignment = Enum.TextXAlignment.Left
jobIdLabel.TextYAlignment = Enum.TextYAlignment.Center
jobIdLabel.Font = Enum.Font.GothamMedium
jobIdLabel.ZIndex = 10
jobIdLabel.Parent = jobIdHolder

local jobIdTextBox = Instance.new("TextBox")
jobIdTextBox.Name = "JobIdTextBox"
jobIdTextBox.Size = UDim2.new(0, 200, 1, -6)
jobIdTextBox.Position = UDim2.new(0, 85, 0, 3)
jobIdTextBox.BackgroundColor3 = Color3.fromRGB(30, 31, 45)
jobIdTextBox.BorderSizePixel = 0
jobIdTextBox.Text = ""
jobIdTextBox.PlaceholderText = "Enter JobId here..."
jobIdTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jobIdTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
jobIdTextBox.TextSize = 12
jobIdTextBox.TextXAlignment = Enum.TextXAlignment.Left
jobIdTextBox.TextYAlignment = Enum.TextYAlignment.Center
jobIdTextBox.Font = Enum.Font.GothamMedium
jobIdTextBox.ZIndex = 11
jobIdTextBox.Parent = jobIdHolder

local TBoxCorner = Instance.new("UICorner")
TBoxCorner.CornerRadius = UDim.new(0, 4)
TBoxCorner.Parent = jobIdTextBox

local TBoxStroke = Instance.new("UIStroke")
TBoxStroke.Color = Color3.fromRGB(200, 200, 220)
TBoxStroke.Thickness = 0.5
TBoxStroke.Transparency = 0.2
TBoxStroke.Parent = jobIdTextBox

local joinButton = Instance.new("TextButton")
joinButton.Name = "JoinButton"
joinButton.Size = UDim2.new(0, 80, 1, -6)
joinButton.Position = UDim2.new(1, -85, 0, 3)
joinButton.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
joinButton.BorderSizePixel = 0
joinButton.Text = "Join"
joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
joinButton.TextSize = 12
joinButton.TextXAlignment = Enum.TextXAlignment.Center
joinButton.TextYAlignment = Enum.TextYAlignment.Center
joinButton.Font = Enum.Font.GothamBold
joinButton.ZIndex = 11
joinButton.Parent = jobIdHolder

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 4)
BtnCorner.Parent = joinButton

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(200, 200, 220)
BtnStroke.Thickness = 0.5
BtnStroke.Transparency = 0.2
BtnStroke.Parent = joinButton

joinButton.MouseEnter:Connect(function()
    joinButton.BackgroundColor3 = Color3.fromRGB(135, 120, 225)
end)

joinButton.MouseLeave:Connect(function()
    joinButton.BackgroundColor3 = Color3.fromRGB(105, 90, 190)
end)

-- ==================================================
-- SHOP CHECKBOX EVENTS
-- ==================================================
buySwordCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoBuySword then
        _G.YOKUDO_ToggleAutoBuySword()
    end
end)

unlockHakiCheckbox.MouseButton1Click:Connect(function()
    if _G.YOKUDO_ToggleAutoUnlockHaki then
        _G.YOKUDO_ToggleAutoUnlockHaki()
    end
end)

-- ==================================================
-- JOIN BUTTON EVENT
-- ==================================================
joinButton.MouseButton1Click:Connect(function()
    local jobId = jobIdTextBox.Text
    if jobId and jobId ~= "" then
        if _G.YOKUDO_JoinServerByJobId then
            _G.YOKUDO_JoinServerByJobId(jobId)
        else
            warn("⚠️ _G.YOKUDO_JoinServerByJobId not found!")
        end
    else
        print("⚠️ Please enter a JobId!")
    end
end)

-- ==================================================
-- OTHER PAGES
-- ==================================================

_G.YOKUDO_AutoHopPage = AutoHopPage

print("✅ Tabs Loaded")
