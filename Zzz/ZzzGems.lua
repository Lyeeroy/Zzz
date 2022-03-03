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

function Zzz_TotalGemsInAllItems()
    local GemsInAll = 0

    for slot = 1, 18 do
    local itemUpgraded = GetInventoryItemLink(unit, slot) --get the itemlink
    if itemUpgraded ~= nil then -- check if item is in slot
        for i = 1, 3 do
            local gemName, gemLink = GetItemGem(itemUpgraded, i)
            if (gemLink) then
                GemsInAll = GemsInAll + 1
            end
        end
    end
end

    return GemsInAll
end

function Zzz_HighLevelGemsInItem()
    local HighLevelGemsInSlot = 0

    for slot = 1, 18 do
        local itemUpgraded = GetInventoryItemLink(unit, slot) --get the itemlink
        if itemUpgraded ~= nil then -- check if item is in slot
            for i = 1, 3 do
                local gemName, gemLink = GetItemGem(itemUpgraded, i)
                if (gemLink ~= nil) then
                    for i = 1, 137 do -- > 105+ = meta
                        if (ZzzGemName[i] == gemName) then
                            HighLevelGemsInSlot = HighLevelGemsInSlot + 1
                            --break
                        end
                    end
                end
            end
        end
    end

    return HighLevelGemsInSlot
end

function Zzz_GemsInItem(slot)
    local GemsInItem = 0

    local itemUpgraded = GetInventoryItemLink(unit, slot) --get the itemlink
    if itemUpgraded ~= nil then -- check if item is in slot
        for i = 1, 3 do
            local gemName, gemLink = GetItemGem(itemUpgraded, i)
            if (gemLink) then
                GemsInItem = GemsInItem + 1
            end
        end
    end

    return GemsInItem
end

function Zzz_SocketsInItem()
    local SocketsInItem = 0
    local temp_SocketsInItem = 0

    for slot = 1, 18 do
        local itemUpgraded = GetInventoryItemLink(unit, slot) --get the itemlink
        if itemUpgraded ~= nil then -- check if item is in slot
            local _, _, Color, Ltype, iId, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name =
                string.find(
                itemUpgraded,
                "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?"
            )
            if (ZzzItems[tonumber(iId)] == 1) then
                SocketsInItem = SocketsInItem + 1
                temp_SocketsInItem = 1
            elseif (ZzzItems[tonumber(iId)] == 2) then
                SocketsInItem = SocketsInItem + 2
                temp_SocketsInItem = 2
            elseif (ZzzItems[tonumber(iId)] == 3) then
                SocketsInItem = SocketsInItem + 3
                temp_SocketsInItem = 3
            end
        end

        if SlotId["waist"] == slot then -- belt + 1
            SocketsInItem = SocketsInItem + 1
            --print('+1 Belt')
        end
        if (SlotId["hands"] == slot) or (SlotId["wrist"] == slot) then -- player has blacksmitting
            if (Zzz_GemsInItem(slot) > temp_SocketsInItem) then
                SocketsInItem = SocketsInItem + 1
                --print('+1 BS')
            end
        end
    end

    return SocketsInItem
end

