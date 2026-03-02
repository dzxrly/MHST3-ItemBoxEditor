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

function M.modInit()
    coreApi.log("Initializing...")
    state.cUserSaveDataParam = sdk.get_managed_singleton("app.SaveDataManager"):call("get_UserSaveData()")
    state.cSaveDataHelperOption = getCSaveDataHelper():get_field("_Option")
    state.cSaveDataHelperItem = getCSaveDataHelper():get_field("_Item")
    state.userDataCItemData = sdk.get_managed_singleton(
        "app.VariousDataManager"):get_field(
        "_Setting"):get_field(
        "_ItemData"):get_field(
        "_ItemData")

    i18n.initLanguage(state.cSaveDataHelperOption)
    coreApi.log("Language Index: " .. tostring(i18n.languageIdx))

    itemFixedIdEnumParser()
    itemMainCategoryEnumParser()

    coreApi.log("Initialization complete")
end

function M.onStart()
    M.modInit()
    dataHelper.setComboItemOptions()
end

return M
