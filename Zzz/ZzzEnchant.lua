local unit = "target"

local SlotId = {
    ["head"] = 1,
    ["neck"] = 2,
    ["shoulder"] = 3,
    ["shirt"] = 4,
    ["chest"] = 5,
    ["waist"] = 6,
    ["legs"] = 7,
    ["feet"] = 8,
    ["wrist"] = 9,
    ["hands"] = 10,
    ["finger1"] = 11,
    ["finger2"] = 12,
    ["trinket1"] = 13,
    ["trinket2"] = 14,
    ["back"] = 15,
    ["main_hand"] = 16,
    ["off_hand"] = 17,
    ["ranged"] = 18
}


function Zzz_Enchanted()
    local Enchanted = 0

    for slot = 1, 18 do
    local itemUpgraded = GetInventoryItemLink(unit, slot) --get the itemlink
    if itemUpgraded ~= nil then -- check if item is in slot
        local _, _, _, _, _, itemType, itemSubType, _, _, _, _ = GetItemInfo(itemUpgraded)
        local _, _, Color, Ltype, iId, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name =
            string.find(
            itemUpgraded,
            "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?"
        )
       
        if Enchant ~= '0' then
            Enchanted = Enchanted + 1
        end
    end
end
    return Enchanted
end

function Zzz_CanEnchant()
    local CanEnchant = 9
    for slot = 1, 18 do
    local itemUpgraded = GetInventoryItemLink(unit, slot) --get the itemlink
    if itemUpgraded ~= nil then -- check if item is in slot
        local _, _, _, _, _, itemType, itemSubType, _, _, _, _ = GetItemInfo(itemUpgraded)
        local _, _, Color, Ltype, iId, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name =
        string.find(
        itemUpgraded,
        "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?"
    )

        if SlotId["off_hand"] == slot then -- belt + 1
            if itemSubType == 'Shields' or 
            itemSubType == 'Two-Handed Swords' or 
            itemSubType == 'Two-Handed Axes' or 
            itemSubType == 'Two-Handed Maces' or 
            itemSubType == 'Daggers' or 
            itemSubType == 'One-Handed Axes' or
            itemSubType == 'One-Handed Swords' then
                CanEnchant = CanEnchant + 1
            end
        elseif (SlotId["finger1"] == slot) or 
        (SlotId["finger2"] == slot) or 
        (SlotId["waist"] == slot) or 
        (SlotId["ranged"] == slot) then -- Check if player has additional enchant
            if Enchant ~= '0' then 
                CanEnchant = CanEnchant + 1
            end
        end

    end
end
    return CanEnchant
end