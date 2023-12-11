---@type l10n
local l10n = QuestieLoader:ImportModule("l10n")

local autoOptionsLocales = {
    ["Auto Complete Quests"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Вкл/выкл",
        ["deDE"] = "Quests automatisch abschließen",
        ["koKR"] = false,
        ["esMX"] = "Entregar misiones",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Entregar misiones automáticamente",
        ["frFR"] = false,
    },
    ["When enabled, Questie will automatically hand in finished quests when talking to NPCs."] = {
        ["ptBR"] = false,
        ["ruRU"] = "Когда включено, задания будут завершаться автоматически при разговоре с NPC",
        ["deDE"] = "Wenn aktiviert, wird Questie automatisch Quests abgeben.",
        ["koKR"] = false,
        ["esMX"] = "Si está activado, Questie entregará automáticamente las misiones terminadas cuando hable con los PNJs.",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Si está activado, Questie entregará automáticamente las misiones terminadas cuando hable con los PNJs.",
        ["frFR"] = false,
    },
    ["Auto Accept"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Автопринятие",
        ["deDE"] = "Quests automatisch annehmen",
        ["koKR"] = false,
        ["esMX"] = "Aceptar automáticamente",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Aceptar automáticamente",
        ["frFR"] = false,
    },
    ["When enabled, Questie will automatically accept quest dialogs when they appear, depending on the rules below."] = {
        ["ptBR"] = false,
        ["ruRU"] = "Когда включено, задания будут приниматься автоматически в зависимости от правил ниже",
        ["deDE"] = "Wenn aktiviert, wird Questie automatisch Quests annehmen, abhängig von den unten stehenden Regeln.",
        ["koKR"] = false,
        ["esMX"] = "Si está activado, Questie aceptará automáticamente los cuadros de diálogo de misiones cuando aparezcan, dependiendo de las reglas a continuación.",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Si está activado, Questie aceptará automáticamente los cuadros de diálogo de misiones cuando aparezcan, dependiendo de las reglas a continuación.",
        ["frFR"] = false,
    },
    ["Rules for NPCs"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Правила для NPC",
        ["deDE"] = "Regeln für NPCs",
        ["koKR"] = false,
        ["esMX"] = "Reglas para PNJs",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Reglas para PNJs",
        ["frFR"] = false,
    },
    ["Rules for players"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Правила для игроков",
        ["deDE"] = "Regeln für Spieler",
        ["koKR"] = false,
        ["esMX"] = "Reglas para jugadores",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Reglas para jugadores",
        ["frFR"] = false,
    },
    ["Automatically accept normal quests from players."] = {
        ["ptBR"] = false,
        ["ruRU"] = "Автопринятие обычных заданий от игроков",
        ["deDE"] = "Normale Quests automatisch annehmen.",
        ["koKR"] = false,
        ["esMX"] = "Acepta automáticamente las misiones normales de los jugadores.",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Acepta automáticamente las misiones normales de los jugadores.",
        ["frFR"] = false,
    },
    ["Automatically accept repeatable quests (including dailies) from players."] = {
        ["ptBR"] = false,
        ["ruRU"] = "Автопринятие повторяемых заданий (включая ежедневные) от игроков",
        ["deDE"] = "Wiederholbare Quests (inkl. Dailies) automatisch annehmen.",
        ["koKR"] = false,
        ["esMX"] = "Acepta automáticamente misiones repetibles (incluidas las diarias) de los jugadores.",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Acepta automáticamente misiones repetibles (incluidas las diarias) de los jugadores.",
        ["frFR"] = false,
    },
    ["Automatically accept PvP quests from players."] = {
        ["ptBR"] = false,
        ["ruRU"] = "Автопринятие PVP-заданий от игроков",
        ["deDE"] = "PvP-Quests automatisch annehmen.",
        ["koKR"] = false,
        ["esMX"] = "Acepta automáticamente las misiones JcJ de los jugadores.",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Acepta automáticamente las misiones JcJ de los jugadores.",
        ["frFR"] = false,
    },
    ["Automatically accept event quests (including event dailies) from players."] = {
        ["ptBR"] = false,
        ["ruRU"] = "Автопринятие заданий игровых событий (включая ежедневные) от игроков",
        ["deDE"] = "Event-Quests (inkl. Event-Dailies) automatisch annehmen.",
        ["koKR"] = false,
        ["esMX"] = "Acepta automáticamente misiones de eventos (incluidos los diarios de eventos) de los jugadores.",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Acepta automáticamente misiones de eventos (incluidos los diarios de eventos) de los jugadores.",
        ["frFR"] = false,
    },
    ["Dungeon/Raid Quests"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Подземелья/рейды",
        ["deDE"] = "Dungeon-/Schlachtzug-Quests",
        ["koKR"] = false,
        ["esMX"] = "Misiones de calabozo y banda",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Misiones de calabozo y banda",
        ["frFR"] = false,
    },
    ["Automatically accept dungeon and raid quests from players."] = {
        ["ptBR"] = false,
        ["ruRU"] = "Автопринятие заданий подземелий и рейдов от игроков",
        ["deDE"] = "Dungeon- und Schlachtzug-Quests automatisch annehmen.",
        ["koKR"] = false,
        ["esMX"] = "Acepta automáticamente misiones de mazmorras y bandas de los jugadores.",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Acepta automáticamente misiones de calabozos y bandas de los jugadores.",
        ["frFR"] = false,
    },
    ["Trivial Quests"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Простые задания",
        ["deDE"] = "Triviale Quests",
        ["koKR"] = false,
        ["esMX"] = "Misiones triviales",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Misiones triviales",
        ["frFR"] = false,
    },
    ["Automatically accept trivial (low-level) quests from players."] = {
        ["ptBR"] = false,
        ["ruRU"] = "Автопринятие простых (низкоуровневых) заданий от игроков",
        ["deDE"] = "Triviale (niedrigstufige) Quests automatisch annehmen.",
        ["koKR"] = false,
        ["esMX"] = "Acepta automáticamente misiones triviales (de bajo nivel) de los jugadores.",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Acepta automáticamente misiones triviales (de bajo nivel) de los jugadores.",
        ["frFR"] = false,
    },
    ["Auto Reject"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Автоотклонение",
        ["deDE"] = "Quests automatisch ablehnen",
        ["koKR"] = false,
        ["esMX"] = "Rechazar automáticamente",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Rechazar automáticamente",
        ["frFR"] = false,
    },
    ["Reject quests shared in battlegrounds"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Отклонять на полях боя",
        ["deDE"] = "Quests in Schlachtfeldern automatisch ablehnen",
        ["koKR"] = false,
        ["esMX"] = "Rechaza misiones compartidas en campos de batalla",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Rechaza misiones compartidas en campos de batalla",
        ["frFR"] = false,
    },
    ["Automatically reject quests shared by players while in a battleground instance. This feature overrides autoaccept behavior."] = {
        ["ptBR"] = false,
        ["ruRU"] = "Автоматически отклонять задания, предлагаемые другими игроками, находясь на поле боя. Эта настройка отменяет поведение автопринятия",
        ["deDE"] = "Quests, die in Schlachtfeldern geteilt werden, automatisch ablehnen.",
        ["koKR"] = false,
        ["esMX"] = "Rechaza automáticamente las misiones compartidas por los jugadores mientras estás en un campo de batalla. Esta característica anula la aceptación automática.",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Rechaza automáticamente las misiones compartidas por los jugadores mientras estás en un campo de batalla. Esta característica anula la aceptación automática.",
        ["frFR"] = false,
    },
    ["Reject quests shared by non-friends"] = {
        ["ptBR"] = false,
        ["ruRU"] = "Отклонять от не-друзей",
        ["deDE"] = "Quests von Nicht-Freunden automatisch ablehnen",
        ["koKR"] = false,
        ["esMX"] = "Rechazar misiones compartidas por no amigos",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Rechazar misiones compartidas por no amigos",
        ["frFR"] = false,
    },
    ["Automatically reject quests shared by players that aren\'t on your friends list. This feature overrides autoaccept behavior."] = {
        ["ptBR"] = false,
        ["ruRU"] = "Автоматически отклонять задания, предлагаемые другими игроками, которые не в списке ваших друзей. Эта настройка отменяет поведение автопринятия",
        ["deDE"] = "Quests, die von Nicht-Freunden geteilt werden, automatisch ablehnen.",
        ["koKR"] = false,
        ["esMX"] = "Rechaza automáticamente misiones compartidas por jugadores que no están en tu lista de amigos. Esta característica anula la aceptación automática.",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Rechaza automáticamente misiones compartidas por jugadores que no están en tu lista de amigos. Esta característica anula la aceptación automática.",
        ["frFR"] = false,
    },
    ["Further Auto customization is coming in a future Questie update."] = {
        ["ptBR"] = false,
        ["ruRU"] = "Другие настройки автоматизации будут добавлены в будущих версиях Questie",
        ["deDE"] = "Weitere Anpassungsmöglichkeiten werden in einem zukünftigen Questie-Update kommen.",
        ["koKR"] = false,
        ["esMX"] = "Una mayor personalización automática llegará en una futura actualización de Questie.",
        ["enUS"] = true,
        ["zhCN"] = false,
        ["zhTW"] = false,
        ["esES"] = "Una mayor personalización automática llegará en una futura actualización de Questie.",
        ["frFR"] = false,
    },
}

for k, v in pairs(autoOptionsLocales) do
    l10n.translations[k] = v
end
