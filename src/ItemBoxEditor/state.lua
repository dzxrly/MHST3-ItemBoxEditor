local function createEnumState()
    return {
        fixedIdToContent = {},
        contentToFixedId = {},
        fixedId = {},
        content = {}
    }
end

local function createState()
    return {
        cUserSaveDataParam = nil,
        cSaveDataHelperOption = nil,
        cSaveDataHelperItem = nil,
        itemFixedIdEnum = createEnumState(),
        itemMainCategoryEnum = createEnumState(),
        userDataCItemData = nil,
        comboItemOptions = {
            displayText = {},
            fixedId = {},
            currentNum = {},
            maxNum = {}
        },
        comboItemStaticOptions = {
            displayPrefix = {},
            fixedId = {},
            maxNum = {}
        },
        currentSelectedItemIdx = 1,
        selectedItemChanged = false,
    }
end

local M = createState()

function M.resetState()
    local nextState = createState()

    for key, value in pairs(nextState) do
        M[key] = value
    end
end

return M
