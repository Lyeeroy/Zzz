AceZzz = LibStub("AceAddon-3.0"):NewAddon("Zzz", "AceConsole-3.0", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
local Zzz = CreateFrame("Frame", "Zzz")
local AceGUI = LibStub("AceGUI-3.0")

local COLOR_GOLD = "|cffffcc00"
local COLOR_GOLD_G = ""
local COLOR_GOLD_E = "|cffffcc00"

local formats = {
COLOR_GOLD .. "Talents" .. "|r G: (*|cffffcc00X/Y|r) E: (|cffffcc00X/Y|r)",
COLOR_GOLD .. "G:|r (*|cffffcc00X/Y|r) E: (|cffffcc00X/Y|r)",
COLOR_GOLD .. "Zzz:|r (" .. COLOR_GOLD .. "*X/Y|r) -- (Sum of gems and enchants)",
COLOR_GOLD .. "G:|r H:(highLvlGems) L:(lowLvlGems) (" .. COLOR_GOLD .. "X/Y|r) E: (|cffffcc00X/Y|r)"
}

local PREFIX_TTP = COLOR_GOLD .. "Zzz:" .. "|cffffffff "

local gtt = GameTooltip
local GetTalentTabInfo = GetTalentTabInfo

local current = {}

local UnitName = UnitName

local cache = {}
local cacheSize = 25

local function slash(msg, editbox)
    local f = AceGUI:Create("Frame")
    f:SetCallback(
        "OnClose",
        function(widget)
            AceGUI:Release(widget)
        end
    )
    f:SetTitle("Zzz")
    f:SetLayout("custom_layout")
    f:SetWidth(400)
    f:SetHeight(200)
    f:SetStatusText("github.com/LyeeRoy/Zzz")

    local CheckBox = AceGUI:Create("CheckBox")
    CheckBox:SetParent(f)
    CheckBox:SetPoint("TOPRIGHT", 110, 5)
    CheckBox:SetLabel("Disable")
    CheckBox:SetValue(1)
    CheckBox:SetCallback(
        "OnValueChanged",
        function(_, _, lock)
            if ZzzSave == 1 then
                ZzzSave = 0
                print("Zzz Addon" .. COLOR_GOLD .. " [OFF]|r ")
            elseif ZzzSave == 0 then
                ZzzSave = 1
                print("Zzz Addon" .. COLOR_GOLD .. " [ON]|r")
            end
        end
    )
    if ZzzSave == 0 then
        CheckBox:SetDisabled(disabled)
    end
    f:AddChild(CheckBox)

    local dropdown = AceGUI:Create("Dropdown")
    dropdown:SetParent(f)
    dropdown:SetPoint("TOPLEFT", 20, -35)
    dropdown:SetValue(formats[1])
    dropdown:SetList(formats)
    dropdown:SetText(formats[ZzzttpFormat])
    dropdown:SetWidth(310)
    dropdown:SetCallback(
        "OnValueChanged",
        function(_, _, formats)
            ZzzttpFormat = formats
        end
    )
    f:AddChild(dropdown)

    local formatLabel = AceGUI:Create("Label")
    formatLabel:SetParent(f)
    formatLabel:SetPoint("TOPLEFT", 10, -20)
    formatLabel:SetText("Format:")
    f:AddChild(formatLabel)
end

  
function AceZzz:OnEnable()
    if (ZzzSave == nil) then ZzzSave = 1 end
    if (ZzzttpFormat == nil) then ZzzttpFormat = 2 end
    if ZzzSave == 0 then
		local cache = {}
         print('Zzz Addon' .. COLOR_GOLD .. ' [OFF]|r ')
    elseif ZzzSave == 1 then
        print('Zzz Addon' .. COLOR_GOLD .. ' [ON]|r')
    end

    SLASH_ZZZ1 = "/zzz"
    SlashCmdList["ZZZ"] = slash
end

local function Main(var)
    local TalentGroup = GetActiveTalentGroup(var)
    local mTree, _ = 1

    for i = 1, 3 do
        _, _, current[i] = GetTalentTabInfo(i, var, nil, TalentGroup)
        if (current[i] > current[mTree]) then
            mTree = i
        end
    end

    -- rewrite
    current[1] = Zzz_TotalGemsInAllItems()
    current[2] = Zzz_SocketsInItem()
    current[3] = Zzz_HighLevelGemsInItem()

    current[4] = Zzz_Enchanted()
    current[5] = Zzz_CanEnchant()

    current.tree = GetTalentTabInfo(mTree, var, nil, TalentGroup)

    --local ZzzttpFormat = (3) --Test

    if current[1] == current[2] then
        COLOR_GOLD_G = COLOR_GOLD
    else 
        COLOR_GOLD_G = ''
    end

    if current[4] == current[5] then
        COLOR_GOLD_E = COLOR_GOLD
    else 
        COLOR_GOLD_E = ''
    end

    if current[1] > current[3] then
        COLOR_GOLD_G = '*'
    end
    
    if (current[1] == 0 and current[4] == 0) then
        current.format = COLOR_GOLD .. "Zzz|r: No data" -- No sockets/gems found
    elseif (ZzzttpFormat == 1) then
        current.format = COLOR_GOLD .. current.tree .. 
        ("|r G: (" .. 
        COLOR_GOLD_G .. current[1] .. "/" .. current[2] ..
         "|r) E: (" .. 
         COLOR_GOLD_E .. current[4] .. "/" .. current[5] ..
          "|r) " )
    elseif (ZzzttpFormat == 2) then
        current.format = 
        COLOR_GOLD .. ("G: " .. "|r" ..  "(" .. 
        COLOR_GOLD_G .. current[1] .. "/" .. current[2] ..
        "|r)" .. COLOR_GOLD .. " E: " .. "|r" .. "(" ..
        COLOR_GOLD_E .. current[4] .. "/" .. current[5] .. 
        "|r) ")
    elseif (ZzzttpFormat == 3) then
        if COLOR_GOLD_E == '' then
            COLOR_GOLD_G = ''
        end
        if current[1] > current[3] then
            COLOR_GOLD_G = '*'
        end
        current.format = COLOR_GOLD .. 'Zzz:|r (' .. COLOR_GOLD_G .. current[1] + current[4] .. "/" .. current[2] + current[5] .. '|r)'
    elseif (ZzzttpFormat == 4) then
        current.format =
        COLOR_GOLD .. "G:|r H" .. current[3] .. ": L" .. (current[1] - current[3]) .. ": |r" ..
          "(" .. COLOR_GOLD_G ..
        current[1] .. "/" .. current[2] ..
        "|r)" .. COLOR_GOLD .. " E: " .. "|r" .. "(" ..
        COLOR_GOLD_E .. 
        current[4] .. "/" .. current[5] .. 
        "|r) "
    end

    for i = #cache, 1, -1 do
        if (current.name == cache[i].name) then
            tremove(cache, i)
            break
        end
    end
    if (#cache > cacheSize) then
        tremove(cache, 1)
    end

    if (cacheSize > 0) then
        cache[#cache + 1] = CopyTable(current)
    end
end

Zzz:SetScript(
    "OnEvent",
    function(self, event)
        self:UnregisterEvent("PLAYER_TARGET_CHANGED")
        if (gtt:GetUnit() == current.name) then
            Main(1)
        end
    end
)

gtt:HookScript(
    "OnTooltipSetUnit",
    function(self, ...)
        local _, unit = self:GetUnit()
        if (not unit) then
            local MouseFocus = GetMouseFocus()
            if (MouseFocus) and (MouseFocus.unit) then
                unit = MouseFocus.unit
            end
        end
        if (UnitIsPlayer(unit)) and (UnitLevel(unit) > 9 or UnitLevel(unit) == -1) and (CanInspect(unit)) and (ZzzSave == 1) then
            wipe(current)
            current.name = UnitName(unit)
            if (UnitIsUnit(unit, "player")) then
                Main()
            else
                local InspectWin =
                    (not InspectFrame or not InspectFrame:IsShown())
                --if (InspectWin) then
                    Zzz:RegisterEvent("PLAYER_TARGET_CHANGED")
                    NotifyInspect(unit)
                --end
                for _, entry in ipairs(cache) do
                    if (current.name == entry.name) then
                        self:AddLine(entry.format, 1, 1, 1)
                        current.tree = entry.tree
                        current.format = entry.format
                        return
                    end
                end
            end
        end
    end
)