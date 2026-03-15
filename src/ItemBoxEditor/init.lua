local coreApi = require("ItemBoxEditor.utils")
local i18n = require("ItemBoxEditor.i18n")
local state = require("ItemBoxEditor.state")
local dataHelper = require("ItemBoxEditor.data_helper")

local M = {}

local function getCSaveDataHelper()
    return sdk.get_managed_singleton("app.SaveDataManager"):get_field("_Helper")
end

local function itemFixedIdEnumParser()
    coreApi.parseEnumFields("app.ItemID.ID_Fixed", state.itemFixedIdEnum, true)
end

local function itemMainCategoryEnumParser()
    coreApi.parseEnumFields("app.ItemMainCategory.TYPE_Fixed", state.itemMainCategoryEnum, true)
end

local function tradePtsTypeFixedEnumParser()
    coreApi.parseEnumFields("app.ItemRank.LEVEL_Fixed", state.tradePtsTypeFixedEnum, true)
    -- remove the content == IT_RANK_NONE
    local newEnum = {
        fixedIdToContent = {},
        contentToFixedId = {},
        fixedId = {},
        content = {}
    }
    for idx, fixedId in ipairs(state.tradePtsTypeFixedEnum.fixedId) do
        local content = state.tradePtsTypeFixedEnum.fixedIdToContent[fixedId]
        if content ~= "IT_RANK_NONE" then
            table.insert(newEnum.fixedId, fixedId)
            newEnum.fixedIdToContent[fixedId] = content
            newEnum.contentToFixedId[content] = fixedId
            table.insert(newEnum.content, content)
        end
    end
    state.tradePtsTypeFixedEnum = newEnum
end

function M.modInit()
    coreApi.log("Initializing...")
    state.cUserSaveDataParam = sdk.get_managed_singleton("app.SaveDataManager"):call("get_UserSaveData()")
    state.cSaveDataHelperOption = getCSaveDataHelper():get_field("_Option")
    state.cSaveDataHelperItem = getCSaveDataHelper():get_field("_Item")
    state.userDataCItemData = sdk.get_managed_singleton("app.VariousDataManager"):get_field("_Setting"):get_field(
        "_ItemData"):get_field("_ItemData")

    i18n.initLanguage(state.cSaveDataHelperOption)
    coreApi.log("Language Index: " .. tostring(i18n.languageIdx))

    itemFixedIdEnumParser()
    itemMainCategoryEnumParser()
    tradePtsTypeFixedEnumParser()

    coreApi.log("Initialization complete")
end

function M.onStart()
    M.modInit()
    dataHelper.setComboItemOptions()
    dataHelper.setTradePtsOptions()
end

return M
