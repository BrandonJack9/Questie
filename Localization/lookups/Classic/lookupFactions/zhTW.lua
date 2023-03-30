if GetLocale() ~= "zhTW" then
    return
end

-- - @type l10n
local l10n = QuestieLoader:ImportModule("l10n")

l10n.factionGroupLookup = {
    -- UNKNOWN
    [-1] = {
        [59] = "瑟銀兄弟會",
        [70] = "辛迪加",
        [87] = "血帆海盜",
        [92] = "吉爾吉斯半人馬",
        [93] = "瑪格拉姆半人馬",
        [270] = "贊達拉部族",
        [349] = "拉文霍德",
        [471] = "蠻錘部族",
        [529] = "銀色黎明",
        [576] = "木喉要塞",
        [589] = "冬刃豹訓練師",
        [609] = "塞納里奧議會",
        [749] = "海達希亞水元素",
        [809] = "辛德拉",
        [909] = "暗月馬戲團",
        [910] = "諾茲多姆的子嗣",
    },
    -- 部落
    [67] = {
        [68] = "幽暗城",
        [76] = "奧格瑪",
        [81] = "雷霆崖",
        [530] = "暗矛食人妖",
    },
    -- 熱砂港
    [169] = {
        [21] = "藏寶海灣",
        [369] = "加基森",
        [470] = "棘齒城",
        [577] = "永望鎮",
    },
    -- 聯盟
    [469] = {
        [47] = "鐵爐堡",
        [54] = "諾姆瑞根流亡者",
        [69] = "達納蘇斯",
        [72] = "暴風城",
    },
    -- 聯盟部隊
    [891] = {
        [509] = "阿拉索聯軍",
        [730] = "雷矛衛隊",
        [890] = "銀翼要塞的戰士",
    },
    -- 部落軍隊
    [892] = {
        [510] = "污染者",
        [729] = "霜狼氏族",
        [889] = "戰歌偵察騎兵",
    },
}
