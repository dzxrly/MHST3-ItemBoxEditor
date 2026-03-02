local state = require("ItemBoxEditor.state")
local i18n = require("ItemBoxEditor.i18n")
local coreApi = require("ItemBoxEditor.utils")
local config = require("ItemBoxEditor.config")

local M = {}

function M.findCItemDataCDataByFixedId(itemFixedId)
    if state.userDataCItemData ~= nil then
        local len = state.userDataCItemData:call("getDataNum()")
        for i = 0, len - 1 do
            local cData = state.userDataCItemData:call("getDataByIndex(System.Int32)", i)
            if cData ~= nil and cData:call("get_ItemID()") == itemFixedId then
                return {
                    obj = cData,
                    idx = i
                }
            end
        end
    end
    return {
        obj = nil,
        idx = -1
    }
end

function M.getItemName(cItemDataCData, itemFixedId)
    if cItemDataCData.obj ~= nil then
        local itemName = cItemDataCData.obj:call("get_ItemName()")
        if itemName ~= nil then
            return tostring(i18n.getTextLanguage(itemName))
        end
    end
    return "[Unknown] " .. itemFixedId
end

function M.getCurrentItemNum(itemFixedId)
    if state.cSaveDataHelperItem ~= nil then
        return state.cSaveDataHelperItem:call("getSaveItemStock(app.ItemID.ID_Fixed)", itemFixedId)
    end
    return 0
end

function M.isInAllowedCategory(cItemDataCData)
    if cItemDataCData ~= nil and state.itemMainCategoryEnum ~= nil then
        local mainCatagory = cItemDataCData.obj:call("get_MainCategory()")
        for _, allowedCategoryContent in pairs(config.ALLOWED_CATEGORIES_CONTENT) do
            if mainCatagory == state.itemMainCategoryEnum.contentToFixedId[allowedCategoryContent] then
                return true
            end
        end
    end
    return false
end

function M.setComboItemOptions()
    if state.itemFixedIdEnum == nil or state.cSaveDataHelperItem == nil or state.userDataCItemData == nil then
        return
    end

    local staticOptions = state.comboItemStaticOptions
    if staticOptions == nil then
        staticOptions = {
            displayPrefix = {},
            fixedId = {},
            maxNum = {}
        }
        state.comboItemStaticOptions = staticOptions
    end

    if #staticOptions.fixedId == 0 then
        for _, itemFixedId in pairs(state.itemFixedIdEnum.fixedId) do
            local cData = M.findCItemDataCDataByFixedId(itemFixedId)
            if cData.obj ~= nil then
                local itemName = M.getItemName(cData, itemFixedId)
                local maxNum = cData.obj:call("get_MaxCapacity()")
                if itemName ~= nil and itemName ~= "" and maxNum == config.MAX_NUM and M.isInAllowedCategory(cData) then
                    local displayPrefix = "[" .. tostring(itemFixedId) .. "] " .. itemName .. " "
                    table.insert(staticOptions.displayPrefix, displayPrefix)
                    table.insert(staticOptions.fixedId, itemFixedId)
                    table.insert(staticOptions.maxNum, maxNum)
                end
            end
        end
    end

    local options = {
        displayText = {},
        fixedId = {},
        currentNum = {},
        maxNum = {}
    }

    for i = 1, #staticOptions.fixedId do
        local itemFixedId = staticOptions.fixedId[i]
        local currentNum = M.getCurrentItemNum(itemFixedId)

        table.insert(options.displayText, staticOptions.displayPrefix[i] .. tostring(currentNum))
        table.insert(options.fixedId, itemFixedId)
        table.insert(options.currentNum, currentNum)
        table.insert(options.maxNum, staticOptions.maxNum[i])
    end

    state.comboItemOptions = options
end

function M.isEnableAdd(currentNum, maxNum)
    return currentNum < maxNum
end

function M.isEnableRemove(currentNum)
    return currentNum > 0
end

function M.addItem(itemFixedId, numToAdd, selectedItemIdx)
    if state.cSaveDataHelperItem ~= nil and state.cUserSaveDataParam ~= nil then
        coreApi.executeUserCmd(function()
            state.cSaveDataHelperItem:call(
                "addSaveItem(app.ItemID.ID_Fixed, System.UInt32, app.savedata.cUserSaveDataParam, System.Boolean)",
                itemFixedId,
                numToAdd,
                state.cUserSaveDataParam,
                true
            )
            M.setComboItemOptions()
            if selectedItemIdx ~= nil then
                state.currentSelectedItemIdx = selectedItemIdx
            end
        end)
    end
end

function M.removeItem(itemFixedId, numToRemove, selectedItemIdx)
    local flag = false
    if state.cSaveDataHelperItem ~= nil and state.cUserSaveDataParam ~= nil then
        coreApi.executeUserCmd(function()
            flag = state.cSaveDataHelperItem:call(
                "subSaveItem(app.ItemID.ID_Fixed, System.UInt32)",
                itemFixedId,
                numToRemove
            )
            M.setComboItemOptions()
            if selectedItemIdx ~= nil then
                state.currentSelectedItemIdx = selectedItemIdx
            end
        end)
    end
    return flag
end

return M
