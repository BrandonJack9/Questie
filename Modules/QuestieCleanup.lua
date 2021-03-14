---@class Cleanup
local QuestieCleanup = QuestieLoader:CreateModule("Cleanup")
---@type QuestieDB
local QuestieDB = QuestieLoader:ImportModule("QuestieDB")
---@tyle QuestieDBCompiler
local QuestieDBCompiler = QuestieLoader:ImportModule("DBCompiler")

function QuestieCleanup:Run()
    -- clean up raw db
    QuestieDB.npcData = nil
    QuestieDB.questData = nil
    QuestieDB.objectData = nil
    QuestieDB.itemData = nil

    -- clean up lang
    l10n.itemLookup = nil
    l10n.npcNameLookup = nil
    l10n.objectLookup = nil
    l10n.questLookup = nil

    -- we call this here to make sure there isn't a lag spike later on
    collectgarbage()
end