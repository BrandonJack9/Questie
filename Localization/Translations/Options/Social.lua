---@type l10n
local l10n = QuestieLoader:ImportModule("l10n")

local socialOptionsLocales = {
    ["Social"] = {
        ["ptBR"] = nil,
        ["ruRU"] = nil,
        ["deDE"] = "Soziales", -- TODO: Improve translation
        ["koKR"] = nil,
        ["esMX"] = nil,
        ["enUS"] = true,
        ["zhCN"] = nil,
        ["zhTW"] = nil,
        ["esES"] = nil,
        ["frFR"] = nil,
    },
    ["Social Options"] = {
        ["ptBR"] = nil,
        ["ruRU"] = nil,
        ["deDE"] = "Soziale Einstellungen", -- TODO: Improve translation
        ["koKR"] = nil,
        ["esMX"] = nil,
        ["enUS"] = true,
        ["zhCN"] = nil,
        ["zhTW"] = nil,
        ["esES"] = nil,
        ["frFR"] = nil,
    },
    ["Announce quest updates via chat"] = {
        ["ptBR"] = "Anúncio de missão",
        ["ruRU"] = "Оповещения о заданиях",
        ["frFR"] = "Annonce de quête",
        ["koKR"] = "퀘스트 알림",
        ["enUS"] = true,
        ["zhCN"] = "任务进度通报",
        ["zhTW"] = "任務進度通報",
        ["deDE"] = "Quest Ereignisse im Chat mitteilen",
        ["esES"] = "Anuncio de misión",
        ["esMX"] = "Anuncio de misión",
    },
    ["Announce quest updates to other players in your group or raid"] = {
        ["ptBR"] = nil,
        ["ruRU"] = "Включает оповещения об обновлениях заданий в чатах группы или рейда",
        ["frFR"] = nil,
        ["koKR"] = nil,
        ["enUS"] = true,
        ["zhCN"] = "与您的队伍或团队中的其他玩家分享任务进度。",
        ["zhTW"] = nil,
        ["deDE"] = "Teilt Updates von Quests anderen Spielern in deiner Gruppe oder deinem Schlachtzug mit.",
        ["esES"] = nil,
        ["esMX"] = nil,
    },
    ["Both"] = {
        ["ptBR"] = nil,
        ["ruRU"] = "Оба",
        ["deDE"] = "Beide",
        ["koKR"] = nil,
        ["esMX"] = "Ambos",
        ["enUS"] = true,
        ["zhCN"] = "两者",
        ["zhTW"] = nil,
        ["esES"] = "Ambos",
        ["frFR"] = "les deux",
    },
    ["Announce quest updates:"] = {
        ["ptBR"] = nil,
        ["ruRU"] = "Типы оповещений:",
        ["deDE"] = "Quest Updates mitteilen:",
        ["koKR"] = nil,
        ["esMX"] = nil,
        ["enUS"] = true,
        ["zhCN"] = "通报任务进度:",
        ["zhTW"] = nil,
        ["esES"] = nil,
        ["frFR"] = nil,
    },
    ["Quest accepted"] = {
        ["ptBR"] = nil,
        ["ruRU"] = "Задание принято",
        ["deDE"] = "Quest angenommen",
        ["koKR"] = nil,
        ["esMX"] = nil,
        ["enUS"] = true,
        ["zhCN"] = "已接受任务",
        ["zhTW"] = nil,
        ["esES"] = nil,
        ["frFR"] = nil,
    },
    ["Announce quest acceptance to other players"] = {
        ["ptBR"] = nil,
        ["ruRU"] = "Оповещение о принятии задания",
        ["deDE"] = "Teilt die Annahme von Quests anderen Spielern mit.",
        ["koKR"] = nil,
        ["esMX"] = nil,
        ["enUS"] = true,
        ["zhCN"] = "向其他玩家通报接受任务",
        ["zhTW"] = nil,
        ["esES"] = nil,
        ["frFR"] = nil,
    },
    ["Quest abandoned"] = {
        ["ptBR"] = nil,
        ["ruRU"] = "Задание отменено",
        ["deDE"] = "Quest abgebrochen",
        ["koKR"] = nil,
        ["esMX"] = nil,
        ["enUS"] = true,
        ["zhCN"] = "放弃任务",
        ["zhTW"] = nil,
        ["esES"] = nil,
        ["frFR"] = nil,
    },
    ["Announce quest abortion to other players"] = {
        ["ptBR"] = nil,
        ["ruRU"] = "Оповещение об отмене задания",
        ["deDE"] = "Teilt den Abbruch von Quests anderen Spielern mit.",
        ["koKR"] = nil,
        ["esMX"] = nil,
        ["enUS"] = true,
        ["zhCN"] = "向其他玩家通报放弃任务",
        ["zhTW"] = nil,
        ["esES"] = nil,
        ["frFR"] = nil,
    },
    ["Objective completed"] = {
        ["ptBR"] = nil,
        ["ruRU"] = "Цель достигнута",
        ["deDE"] = "Questziel erfüllt",
        ["koKR"] = nil,
        ["esMX"] = nil,
        ["enUS"] = true,
        ["zhCN"] = "完成目标",
        ["zhTW"] = nil,
        ["esES"] = nil,
        ["frFR"] = nil,
    },
    ["Announce completed objectives to other players"] = {
        ["ptBR"] = nil,
        ["ruRU"] = "Оповещение о достижении целей задания",
        ["deDE"] = "Teilt die Erfüllung von Questzielen anderen Spielern mit.",
        ["koKR"] = nil,
        ["esMX"] = nil,
        ["enUS"] = true,
        ["zhCN"] = "向其他玩家通报完成目标",
        ["zhTW"] = nil,
        ["esES"] = nil,
        ["frFR"] = nil,
    },
    ["Quest completed"] = {
        ["ptBR"] = nil,
        ["ruRU"] = "Задание выполнено",
        ["deDE"] = "Quest abgeschlossen",
        ["koKR"] = nil,
        ["esMX"] = nil,
        ["enUS"] = true,
        ["zhCN"] = "任务完成",
        ["zhTW"] = nil,
        ["esES"] = nil,
        ["frFR"] = nil,
    },
    ["Announce quest completion to other players"] = {
        ["ptBR"] = nil,
        ["ruRU"] = "Оповещение о выполнении задания",
        ["deDE"] = "Teilt den Abschluß von Quests anderen Spielern mit.",
        ["koKR"] = nil,
        ["esMX"] = nil,
        ["enUS"] = true,
        ["zhCN"] = "向其他玩家通报任务完成",
        ["zhTW"] = nil,
        ["esES"] = nil,
        ["frFR"] = nil,
    },
    ["Share quest progress with nearby players"] = {
        ["ptBR"] = "Compartilhar o progresso da missão com jogadores próximos",
        ["ruRU"] = "Делиться прогрессом заданий",
        ["deDE"] = "Quest-Fortschritt mit Spielern in der Nähe teilen",
        ["koKR"] = "근처 플레이어에게 퀘스트 진행 공유",
        ["esMX"] = "Compartir el progreso de la misión con jugadores cercanos",
        ["enUS"] = true,
        ["zhCN"] = "与身边玩家分享任务进度",
        ["zhTW"] = "對鄰近玩家分享任務進度",
        ["esES"] = "Compartir el progreso de la misión con jugadores cercanos",
        ["frFR"] = "Partager la progression avec les joueurs proches",
    },
    ["Your quest progress will be periodically sent to nearby players. Disabling this doesn't affect sharing progress with party members."] = {
        ["ptBR"] = "O progresso da sua missão será enviado periodicamente a jogadores próximos",
        ["ruRU"] = "Прогресс ваших заданий будет периодически отправляться игрокам, находящимся рядом",
        ["deDE"] = "Sendet deinen Quests-Fortschritt regelmäßig zu nahegelegenen Spielern",
        ["koKR"] = "퀘스트 진행상황은 정기적으로 근처 플레이어로 전송됩니다. 이 기능을 사용하지 않도록 설정해도 파티원과의 진행률 공유에는 영향을 주지 않습니다.",
        ["esMX"] = "El progreso de tu misión se enviará periódicamente a los jugadores cercanos.",
        ["enUS"] = true,
        ["zhCN"] = "你的任务进度將定期的发送给身边玩家",
        ["zhTW"] = "你的任務進度將定期的傳送給鄰近玩家",
        ["esES"] = "El progreso de tu misión se enviará periódicamente a los jugadores cercanos.",
        ["frFR"] = "La progression de vos quêtes sera régulièrement partagée avec les joueurs proches.",
    },
}

for k, v in pairs(socialOptionsLocales) do
    l10n.translations[k] = v
end