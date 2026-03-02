local state = require("ItemBoxEditor.state")
local i18n = require("ItemBoxEditor.i18n")
local coreApi = require("ItemBoxEditor.utils")
local config = require("ItemBoxEditor.config")
local dataHelper = require("ItemBoxEditor.data_helper")

local M = {}
local customTargetNumInput = ""

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
        local currentSelectedItemInfo = {
            fixedId = state.comboItemOptions.fixedId[state.currentSelectedItemIdx],
            currentNum = tonumber(state.comboItemOptions.currentNum[state.currentSelectedItemIdx]),
            maxNum = tonumber(state.comboItemOptions.maxNum[state.currentSelectedItemIdx]),
        }

        state.selectedItemChanged, state.currentSelectedItemIdx = imgui.combo(
            i18n.getUIText("select_item_label"),
            state.currentSelectedItemIdx,
            state.comboItemOptions.displayText
        )
        if state.selectedItemChanged then
            coreApi.log("Selected item changed: " ..
                tostring(state.comboItemOptions.fixedId[state.currentSelectedItemIdx]))
            currentSelectedItemInfo.fixedId = state.comboItemOptions.fixedId[state.currentSelectedItemIdx]
            currentSelectedItemInfo.currentNum = tonumber(state.comboItemOptions.currentNum
                [state.currentSelectedItemIdx])
            currentSelectedItemInfo.maxNum = tonumber(state.comboItemOptions.maxNum[state.currentSelectedItemIdx])
        end

        if state.selectedItemChanged or customTargetNumInput == "" then
            customTargetNumInput = tostring(currentSelectedItemInfo.currentNum)
        end

        imgui.begin_disabled(not dataHelper.isEnableRemove(currentSelectedItemInfo.currentNum))
        if imgui.button(i18n.getUIText("set_to_zero_btn"), config.SMALL_BTN) then
            dataHelper.removeItem(
                currentSelectedItemInfo.fixedId,
                currentSelectedItemInfo.currentNum,
                state.currentSelectedItemIdx
            )
            customTargetNumInput = "0"
        end
        imgui.end_disabled()
        imgui.same_line()
        imgui.begin_disabled(not dataHelper.isEnableAdd(currentSelectedItemInfo.currentNum,
            currentSelectedItemInfo.maxNum))
        if imgui.button(i18n.getUIText("set_to_max_btn", currentSelectedItemInfo.maxNum), config.SMALL_BTN) then
            dataHelper.addItem(
                currentSelectedItemInfo.fixedId,
                currentSelectedItemInfo.maxNum - currentSelectedItemInfo.currentNum,
                state.currentSelectedItemIdx
            )
            customTargetNumInput = tostring(currentSelectedItemInfo.maxNum)
        end
        imgui.end_disabled()

        _, customTargetNumInput = imgui.input_text(
            i18n.getUIText("custom_num_label"),
            customTargetNumInput
        )
        local isValidCustomNum, customNumErrorKey = getCustomTargetNumValidationResult(
            customTargetNumInput,
            currentSelectedItemInfo.maxNum
        )
        imgui.begin_disabled(not isValidCustomNum)
        if imgui.button(i18n.getUIText("confirm_custom_num_btn"), config.SMALL_BTN) then
            local customTargetNum = tonumber(customTargetNumInput)
            local diff = customTargetNum - currentSelectedItemInfo.currentNum
            if diff > 0 then
                dataHelper.addItem(
                    currentSelectedItemInfo.fixedId,
                    diff,
                    state.currentSelectedItemIdx
                )
            elseif diff < 0 then
                dataHelper.removeItem(
                    currentSelectedItemInfo.fixedId,
                    -diff,
                    state.currentSelectedItemIdx
                )
            end
        end
        imgui.end_disabled()
        if not isValidCustomNum then
            imgui.text_colored(
                i18n.getUIText(customNumErrorKey, currentSelectedItemInfo.maxNum),
                config.ERROR_COLOR
            )
        else
            imgui.text(" ")
        end
    end
end

return M
