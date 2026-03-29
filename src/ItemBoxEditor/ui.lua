local state = require("ItemBoxEditor.state")
local i18n = require("ItemBoxEditor.i18n")
local coreApi = require("ItemBoxEditor.utils")
local config = require("ItemBoxEditor.config")
local dataHelper = require("ItemBoxEditor.data_helper")

local M = {}
local customTargetItemNumInput = ""
local customTradePtsNumInput = ""

local function getCustomTargetNumValidationResult(customInput, maxNum)
    if customInput == nil or customInput == "" then
        return false, "custom_num_empty"
    end

    if not string.match(customInput, "^%d+$") then
        return false, "custom_num_not_positive_integer"
    end

    local customNum = tonumber(customInput)
    if customNum == nil or customNum <= 0 then
        return false, "custom_num_not_positive_integer"
    end

    if customNum > maxNum then
        return false, "custom_num_out_of_range"
    end

    return true, nil
end

function M.drawUI()
    if state.cUserSaveDataParam ~= nil then
        if state.searchInput == nil then
            state.searchInput = ""
        end

        local filteredOptions = state.filteredComboItemOptions
        if not filteredOptions or #filteredOptions.fixedId == 0 then
            filteredOptions = {
                displayText = {"(No matching items)"},
                fixedId = {0},
                currentNum = {0},
                maxNum = {0},
                originalIdx = {1}
            }
        end

        if type(state.currentSelectedItemIdx) ~= "number" or state.currentSelectedItemIdx < 1 then
            state.currentSelectedItemIdx = 1
        elseif state.currentSelectedItemIdx > #filteredOptions.fixedId then
            state.currentSelectedItemIdx = #filteredOptions.fixedId
        end

        local currentSelectedItemInfo = {
            fixedId = filteredOptions.fixedId[state.currentSelectedItemIdx],
            currentNum = tonumber(filteredOptions.currentNum[state.currentSelectedItemIdx]),
            maxNum = tonumber(filteredOptions.maxNum[state.currentSelectedItemIdx])
        }

        if imgui.begin_table("##item_box_editor_main_table", 1) then
            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.text(i18n.getUIText("search_item_label"))
            imgui.same_line()
            imgui.set_next_item_width(-1)
            local isSearchChanged, newSearchInput = imgui.input_text("##search_item_input", state.searchInput)
            if isSearchChanged then
                state.searchInput = newSearchInput
                dataHelper.applySearchFilter(newSearchInput)
                state.currentSelectedItemIdx = 1
                filteredOptions = state.filteredComboItemOptions
                if not filteredOptions or #filteredOptions.fixedId == 0 then
                    filteredOptions = {
                        displayText = {"(No matching items)"},
                        fixedId = {0},
                        currentNum = {0},
                        maxNum = {0},
                        originalIdx = {1}
                    }
                end
                currentSelectedItemInfo.fixedId = filteredOptions.fixedId[state.currentSelectedItemIdx]
                currentSelectedItemInfo.currentNum = tonumber(filteredOptions.currentNum[state.currentSelectedItemIdx])
                currentSelectedItemInfo.maxNum = tonumber(filteredOptions.maxNum[state.currentSelectedItemIdx])
            end

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.set_next_item_width(-1)
            state.selectedItemChanged, state.currentSelectedItemIdx =
                imgui.combo(i18n.getUIText("select_item_label"), state.currentSelectedItemIdx,
                    filteredOptions.displayText)
            if state.selectedItemChanged then
                coreApi.log("Selected item changed: " .. tostring(filteredOptions.fixedId[state.currentSelectedItemIdx]))
                currentSelectedItemInfo.fixedId = filteredOptions.fixedId[state.currentSelectedItemIdx]
                currentSelectedItemInfo.currentNum = tonumber(filteredOptions.currentNum[state.currentSelectedItemIdx])
                currentSelectedItemInfo.maxNum = tonumber(filteredOptions.maxNum[state.currentSelectedItemIdx])
            end

            if state.selectedItemChanged or customTargetItemNumInput == "" then
                customTargetItemNumInput = tostring(currentSelectedItemInfo.currentNum)
            end

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            if imgui.begin_table("##item_set_buttons_row", 2) then
                imgui.table_next_column()
                imgui.begin_disabled(not dataHelper.isEnableRemove(currentSelectedItemInfo.currentNum) or
                                         currentSelectedItemInfo.fixedId == 0)
                if imgui.button(i18n.getUIText("set_to_zero_btn"), {-0.001, 0}) then
                    dataHelper.removeItem(currentSelectedItemInfo.fixedId, currentSelectedItemInfo.currentNum,
                        state.currentSelectedItemIdx)
                    customTargetItemNumInput = "0"
                end
                imgui.end_disabled()

                imgui.table_next_column()
                imgui.begin_disabled(not dataHelper.isEnableAdd(currentSelectedItemInfo.currentNum,
                    currentSelectedItemInfo.maxNum) or currentSelectedItemInfo.fixedId == 0)
                if imgui.button(i18n.getUIText("set_to_max_btn", currentSelectedItemInfo.maxNum), {-0.001, 0}) then
                    dataHelper.addItem(currentSelectedItemInfo.fixedId,
                        currentSelectedItemInfo.maxNum - currentSelectedItemInfo.currentNum,
                        state.currentSelectedItemIdx)
                    customTargetItemNumInput = tostring(currentSelectedItemInfo.maxNum)
                end
                imgui.end_disabled()
                imgui.end_table()
            end

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.set_next_item_width(-1)
            _, customTargetItemNumInput = imgui.input_text(i18n.getUIText("custom_num_label"), customTargetItemNumInput)
            local isValidCustomNum, customNumErrorKey = getCustomTargetNumValidationResult(customTargetItemNumInput,
                currentSelectedItemInfo.maxNum)

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.begin_disabled(not isValidCustomNum or currentSelectedItemInfo.fixedId == 0)
            if imgui.button(i18n.getUIText("confirm_custom_num_btn"), {-0.001, 0}) then
                local customTargetNum = tonumber(customTargetItemNumInput)
                local diff = customTargetNum - currentSelectedItemInfo.currentNum
                if diff > 0 then
                    dataHelper.addItem(currentSelectedItemInfo.fixedId, diff, state.currentSelectedItemIdx)
                elseif diff < 0 then
                    dataHelper.removeItem(currentSelectedItemInfo.fixedId, -diff, state.currentSelectedItemIdx)
                end
            end
            imgui.end_disabled()
            if not isValidCustomNum and currentSelectedItemInfo.fixedId ~= 0 then
                imgui.table_next_row()
                imgui.table_set_column_index(0)
                imgui.text_colored(i18n.getUIText(customNumErrorKey, currentSelectedItemInfo.maxNum), config.ERROR_COLOR)
            end

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.spacing()

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.text(i18n.getUIText("pts_editor_title"))

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.set_next_item_width(-1)
            state.selectedTradePtsChanged, state.currentSelectedTradePtsIdx = imgui.combo("##tradePtsType",
                state.currentSelectedTradePtsIdx, state.comboTradePtsOptions.displayText)

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            if imgui.begin_table("##pts_set_buttons_row", 2) then
                imgui.table_next_column()
                if imgui.button(i18n.getUIText("set_to_zero_btn") .. "##pts_to_zero_btn", {-0.001, 0}) then
                    local selectedPtsFixedId = state.comboTradePtsOptions.fixedId[state.currentSelectedTradePtsIdx]
                    local diff = 0 - state.comboTradePtsOptions.currentNum[state.currentSelectedTradePtsIdx]
                    dataHelper.updateTradePtsNum(selectedPtsFixedId, diff)
                end

                imgui.table_next_column()
                if imgui.button(i18n.getUIText("set_to_max_btn", config.MAX_PTS) .. "##pts_to_max_btn", {-0.001, 0}) then
                    local selectedPtsFixedId = state.comboTradePtsOptions.fixedId[state.currentSelectedTradePtsIdx]
                    local diff = config.MAX_PTS -
                                     state.comboTradePtsOptions.currentNum[state.currentSelectedTradePtsIdx]
                    dataHelper.updateTradePtsNum(selectedPtsFixedId, diff)
                end
                imgui.end_table()
            end

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.set_next_item_width(-1)
            _, customTradePtsNumInput = imgui.input_text(i18n.getUIText("custom_num_label") .. "##pts_custom_num",
                customTradePtsNumInput)
            local isValidCustomPtsNum, customPtsNumErrorKey =
                getCustomTargetNumValidationResult(customTradePtsNumInput, config.MAX_PTS)

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.begin_disabled(not isValidCustomPtsNum)
            if imgui.button(i18n.getUIText("confirm_custom_num_btn") .. "##pts_confirm_custom_num_btn", {-0.001, 0}) then
                local customPtsNum = tonumber(customTradePtsNumInput)
                local selectedPtsFixedId = state.comboTradePtsOptions.fixedId[state.currentSelectedTradePtsIdx]
                local diff = customPtsNum - state.comboTradePtsOptions.currentNum[state.currentSelectedTradePtsIdx]
                dataHelper.updateTradePtsNum(selectedPtsFixedId, diff)
            end
            imgui.end_disabled()
            if not isValidCustomPtsNum then
                imgui.table_next_row()
                imgui.table_set_column_index(0)
                imgui.text_colored(i18n.getUIText(customPtsNumErrorKey, config.MAX_PTS), config.ERROR_COLOR)
            end

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.spacing()

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            if imgui.tree_node(i18n.getUIText("advanced_options_title")) then
                imgui.text_colored(i18n.getUIText("advanced_options_tips"), config.ERROR_COLOR)

                if imgui.begin_table("##advanced_options_buttons_row", 2) then
                    imgui.table_next_column()
                    if imgui.button(i18n.getUIText("set_all_item_to_zero_btn"), {-0.001, 0}) then
                        dataHelper.setAllItemsToZero()
                        customTargetItemNumInput = "0"
                    end

                    imgui.table_next_column()
                    if imgui.button(i18n.getUIText("set_all_item_to_max_btn"), {-0.001, 0}) then
                        dataHelper.setAllItemsToMax()
                    end

                    imgui.end_table()
                end

                imgui.tree_pop()
            end

            imgui.end_table()
        end
    end
end

return M
