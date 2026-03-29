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
            click_read_item_box_btn_tips = "セーブデータをロードしてからアイテムボックスを読み込んでください！",
            search_item_label = "アイテムを検索",
            select_item_label = "アイテムを選択",
            set_to_zero_btn = "0に設定",
            set_to_max_btn = "最大に設定 %s",
            custom_num_label = "カスタム数量",
            confirm_custom_num_btn = "適用",
            custom_num_empty = "数量を入力してください。",
            custom_num_not_positive_integer = "正の整数を入力してください。",
            custom_num_out_of_range = "有効範囲は1〜%sです。",
            pts_editor_title = "ポイントエディター",
            pts_list = {"ブロンズポイント", "シルバーポイント", "ゴールドポイント"},
            advanced_options_title = "詳細オプション",
            advanced_options_tips = "内容を理解している場合を除き、\n以下のオプションを変更しないでください！\n変更前に必ずセーブデータをバックアップしてください！",
            set_all_item_to_zero_btn = "すべてのアイテムを0に設定",
            set_all_item_to_max_btn = "すべてのアイテムを最大に設定"
        },
        [1] = {
            save_data_warning = "Please BACK UP your save data before use!!!",
            read_item_box_btn = "Read Item Box",
            click_read_item_box_btn_tips = "Please read the item box after loading the save data!",
            search_item_label = "Search Item",
            select_item_label = "Select Item",
            set_to_zero_btn = "Set to 0",
            set_to_max_btn = "Set to %s",
            custom_num_label = "Custom Amount",
            confirm_custom_num_btn = "Apply",
            custom_num_empty = "Please enter an amount.",
            custom_num_not_positive_integer = "Please enter a positive integer.",
            custom_num_out_of_range = "Allowed range is 1 to %s.",
            pts_editor_title = "Trade Points Editor",
            pts_list = {"Bronze Points", "Silver Points", "Gold Points"},
            advanced_options_title = "Advanced Options",
            advanced_options_tips = "Unless you know what you are doing,\ndo not modify the options below!\nPlease back up your save data before making any changes!",
            set_all_item_to_zero_btn = "Set All Items to 0",
            set_all_item_to_max_btn = "Set All Items to Max"
        },
        [11] = {
            save_data_warning = "사용 전 반드시 세이브 데이터를 백업해 주세요!!!",
            read_item_box_btn = "아이템 박스 읽기",
            click_read_item_box_btn_tips = "세이브 데이터를 로드한 후 아이템 박스를 읽어주세요!",
            search_item_label = "아이템 검색",
            select_item_label = "아이템 선택",
            set_to_zero_btn = "0으로 설정",
            set_to_max_btn = "%s로 설정",
            custom_num_label = "사용자 수량",
            confirm_custom_num_btn = "적용",
            custom_num_empty = "수량을 입력해 주세요.",
            custom_num_not_positive_integer = "양의 정수를 입력해 주세요.",
            custom_num_out_of_range = "허용 범위는 1~%s입니다.",
            pts_editor_title = "거래 포인트 편집기",
            pts_list = {"브론즈 포인트", "실버 포인트", "골드 포인트"},
            advanced_options_title = "고급 옵션",
            advanced_options_tips = "무엇을 하는지 정확히 알지 못한다면,\n아래 옵션을 임의로 변경하지 마세요!\n변경 전에 반드시 세이브 데이터를 백업해 주세요!",
            set_all_item_to_zero_btn = "모든 아이템을 0으로 설정",
            set_all_item_to_max_btn = "모든 아이템을 최대로 설정"
        },
        [12] = {
            save_data_warning = "使用前請務必備份存檔！！！",
            read_item_box_btn = "讀取物品箱",
            click_read_item_box_btn_tips = "請進入存檔後再讀取物品箱！",
            search_item_label = "搜尋物品",
            select_item_label = "選擇物品",
            set_to_zero_btn = "設為0",
            set_to_max_btn = "設為%s",
            custom_num_label = "自訂數量",
            confirm_custom_num_btn = "套用",
            custom_num_empty = "請輸入數量。",
            custom_num_not_positive_integer = "請輸入正整數。",
            custom_num_out_of_range = "允許範圍為 1 到 %s。",
            pts_editor_title = "交易点数编辑器",
            pts_list = {"青銅點數", "白銀點數", "黃金點數"},
            advanced_options_title = "進階選項",
            advanced_options_tips = "除非你知道自己在做什麼，\n否則不要隨意修改以下選項！\n修改前請務必備份存檔！",
            set_all_item_to_zero_btn = "所有物品設為0",
            set_all_item_to_max_btn = "所有物品設為最大"
        },
        [13] = {
            save_data_warning = "使用前请务必备份存档！！！",
            read_item_box_btn = "读取物品箱",
            click_read_item_box_btn_tips = "请进入存档后再读取物品箱！",
            search_item_label = "搜索物品",
            select_item_label = "选择物品",
            set_to_zero_btn = "设为0",
            set_to_max_btn = "设为%s",
            custom_num_label = "自定义数量",
            confirm_custom_num_btn = "应用",
            custom_num_empty = "请输入数量。",
            custom_num_not_positive_integer = "请输入正整数。",
            custom_num_out_of_range = "允许范围是 1 到 %s。",
            pts_editor_title = "交易点数编辑器",
            pts_list = {"青铜点数", "白银点数", "黄金点数"},
            advanced_options_title = "高级选项",
            advanced_options_tips = "除非你知道自己在做什么，\n否则不要随意修改以下选项！\n修改前请务必备份存档！",
            set_all_item_to_zero_btn = "所有物品设为0",
            set_all_item_to_max_btn = "所有物品设为最大"
        }
    }
})

return M
