if GetLocale() ~= "ruRU" then
    return
end

-- - @type l10n
local l10n = QuestieLoader:ImportModule("l10n")

l10n.factionGroupLookup = {
    -- UNKNOWN
    [-1] = {
        [59] = "Братство Тория",
        [70] = "Синдикат",
        [87] = "Пираты Кровавого Паруса",
        [92] = "Кентавры из племени Гелкис",
        [93] = "Кентавры племени Маграм",
        [270] = "Племя Зандалар",
        [349] = "Черный Ворон",
        [471] = "Неистовый Молот",
        [529] = "Серебряный Рассвет",
        [576] = "Древобрюхи",
        [589] = "Укротители ледопардов",
        [609] = "Круг Кенария",
        [749] = "Гидраксианские Повелители Вод",
        [809] = "Шен'дралар",
        [909] = "Ярмарка Новолуния",
        [910] = "Род Ноздорму",
    },
    -- Орда
    [67] = {
        [68] = "Подгород",
        [76] = "Оргриммар",
        [81] = "Громовой Утес",
        [530] = "Племя Черного Копья",
    },
    -- Картель Хитрая Шестеренка
    [169] = {
        [21] = "Пиратская бухта",
        [369] = "Прибамбасск",
        [470] = "Кабестан",
        [577] = "Круговзор",
    },
    -- Альянс
    [469] = {
        [47] = "Стальгорн",
        [54] = "Изгнанники Гномрегана",
        [69] = "Дарнасс",
        [72] = "Штормград",
    },
    -- Силы Альянса
    [891] = {
        [509] = "Лига Аратора",
        [730] = "Стража Грозовой Вершины",
        [890] = "Среброкрылые Часовые",
    },
    -- Силы Орды
    [892] = {
        [510] = "Осквернители",
        [729] = "Клан Северного Волка",
        [889] = "Всадники Песни Войны",
    },
}
