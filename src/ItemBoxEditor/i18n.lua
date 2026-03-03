--- Language Index:
--- 0: Japanese
--- 1: English
--- 11: Korean
--- 12: Chinese (Traditional)
--- 13: Chinese (Simplified)
local coreApi = require("ItemBoxEditor.utils")

local M = coreApi.createI18n({
    defaultLanguageIdx = 1,
    text = {
        [0] = {
            save_data_warning = "使用前に必ずセーブデータをバックアップしてください！！！",
            read_item_box_btn = "アイテムボックスを読み込む",
            select_item_label = "アイテムを選択",
            set_to_zero_btn = "0に設定",
            set_to_max_btn = "最大に設定 %s",
            custom_num_label = "カスタム数量",
            confirm_custom_num_btn = "適用",
            custom_num_empty = "数量を入力してください。",
            custom_num_not_positive_integer = "正の整数を入力してください。",
            custom_num_out_of_range = "有効範囲は1〜%sです。",
        },
        [1] = {
            save_data_warning = "Please BACK UP your save data before use!!!",
            read_item_box_btn = "Read Item Box",
            select_item_label = "Select Item",
            set_to_zero_btn = "Set to 0",
            set_to_max_btn = "Set to %s",
            custom_num_label = "Custom Amount",
            confirm_custom_num_btn = "Apply",
            custom_num_empty = "Please enter an amount.",
            custom_num_not_positive_integer = "Please enter a positive integer.",
            custom_num_out_of_range = "Allowed range is 1 to %s.",
        },
        [11] = {
            save_data_warning = "사용 전 반드시 세이브 데이터를 백업해 주세요!!!",
            read_item_box_btn = "아이템 박스 읽기",
            select_item_label = "아이템 선택",
            set_to_zero_btn = "0으로 설정",
            set_to_max_btn = "%s로 설정",
            custom_num_label = "사용자 수량",
            confirm_custom_num_btn = "적용",
            custom_num_empty = "수량을 입력해 주세요.",
            custom_num_not_positive_integer = "양의 정수를 입력해 주세요.",
            custom_num_out_of_range = "허용 범위는 1~%s입니다.",
        },
        [12] = {
            save_data_warning = "使用前請務必備份存檔！！！",
            read_item_box_btn = "讀取物品箱",
            select_item_label = "選擇物品",
            set_to_zero_btn = "設為0",
            set_to_max_btn = "設為%s",
            custom_num_label = "自訂數量",
            confirm_custom_num_btn = "套用",
            custom_num_empty = "請輸入數量。",
            custom_num_not_positive_integer = "請輸入正整數。",
            custom_num_out_of_range = "允許範圍為 1 到 %s。",
        },
        [13] = {
            save_data_warning = "使用前请务必备份存档！！！",
            read_item_box_btn = "读取物品箱",
            select_item_label = "选择物品",
            set_to_zero_btn = "设为0",
            set_to_max_btn = "设为%s",
            custom_num_label = "自定义数量",
            confirm_custom_num_btn = "应用",
            custom_num_empty = "请输入数量。",
            custom_num_not_positive_integer = "请输入正整数。",
            custom_num_out_of_range = "允许范围是 1 到 %s。",
        }
    }
})

return M
