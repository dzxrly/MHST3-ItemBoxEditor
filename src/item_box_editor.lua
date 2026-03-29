local coreApi = require("ItemBoxEditor.utils")
local state = require("ItemBoxEditor.state")
local init = require("ItemBoxEditor.init")
local i18n = require("ItemBoxEditor.i18n")
local config = require("ItemBoxEditor.config")
local ui = require("ItemBoxEditor.ui")

coreApi.init("ItemBoxEditor")

local isBtnClicked = false

local function fullWidthButton(label)
    return imgui.button(label, {-0.001, 0})
end

-- DO NOT CHANGE THE NEXT LINE, ONLY UPDATE THE VERSION NUMBER
local modVersion = "v1.2.0"
-- DO NOT CHANGE THE PREVIOUS LINE

sdk.hook(sdk.find_type_definition("app.SaveDataManager"):get_method("getTitleText()"), function(args)
end, function(retval)
    state.resetState()
    init.onStart()
    coreApi.setUserCmdPostHook(init.modInit)
    return retval
end)

re.on_draw_ui(function()
    if imgui.tree_node("Item Box Editor") then
        if imgui.begin_table("##entry_main_table", 1) then
            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.text("VERSION: " .. modVersion .. " | by Egg Targaryen")

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.text_colored(i18n.getUIText("save_data_warning"), config.ERROR_COLOR)

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.text_colored(i18n.getUIText("save_data_warning"), config.ERROR_COLOR)

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.text_colored(i18n.getUIText("save_data_warning"), config.ERROR_COLOR)

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.spacing()

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            if fullWidthButton(i18n.getUIText("read_item_box_btn")) then
                coreApi.executeUserCmd(function()
                    coreApi.log("Read item box btn clicked")
                    state.resetState()
                    init.onStart()
                    isBtnClicked = true
                end)
            end

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.text_colored(i18n.getUIText("click_read_item_box_btn_tips"), config.TIPS_COLOR)

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            imgui.spacing()

            imgui.table_next_row()
            imgui.table_set_column_index(0)
            if state.cUserSaveDataParam ~= nil and isBtnClicked and #state.comboItemOptions.displayText > 0 then
                ui.drawUI()
            end

            imgui.end_table()
        end

        imgui.tree_pop()
    end
end)
