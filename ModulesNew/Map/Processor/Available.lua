---@class AvailableMapProcessor
local AvailableMapProcessor = QuestieLoader:CreateModule("AvailableMapProcessor")
local QuestEventBus = QuestieLoader:ImportModule("QuestEventBus")

local MapEventBus = QuestieLoader:ImportModule("MapEventBus")
---@type QuestieDB
local QuestieDB = QuestieLoader:ImportModule("QuestieDB")
---@type ZoneDB
local ZoneDB = QuestieLoader:ImportModule("ZoneDB")
---@type MapProvider
local MapProvider = QuestieLoader:ImportModule("MapProvider")

local QuestieLib = QuestieLoader:ImportModule("QuestieLib")

local MapCoodinates = QuestieLoader:ImportModule("MapCoordinates")

local MapTooltip = QuestieLoader:ImportModule("MapTooltip")

local QuestieQuest = QuestieLoader:CreateModule("QQuest")

-- Pin Mixin
local RelationPinMixin = QuestieLoader:ImportModule("RelationPinMixin")


-- Math
local abs = math.abs
local tInsert = table.insert
local lRound = Round

local pinTemplate
local map
---@type TexturePool
local texPool

local AVAILABLE_ICON_PATH = QuestieLib.AddonPath .. "Icons\\available.blp"
local LOOT_ICON_PATH = QuestieLib.AddonPath .. "Icons\\loot.blp"
local OBJECT_ICON_PATH = QuestieLib.AddonPath .. "Icons\\object.blp"
local AVAILABLE_LOOT_ICON_PATH = QuestieLib.AddonPath .. "Icons\\lootAvailable.blp"
local COMPLETE_ICON_PATH =  QuestieLib.AddonPath.."Icons\\complete.tga"

local function Initialize()
    QuestEventBus:RegisterRepeating(QuestEventBus.events.CALCULATED_AVAILABLE_QUESTS, AvailableMapProcessor.ProcessAvailableQuests)
    QuestEventBus:RegisterRepeating(QuestEventBus.events.CALCULATED_COMPLETED_QUESTS, AvailableMapProcessor.ProcessCompletedQuests)
    pinTemplate = worldPinTemplate
    map = MapProvider:GetMap()
    texPool = TexturePool
end

C_Timer.After(0, Initialize)

---Get the dungeon locations in the correct format or false(because we can't save nil)
---@param AreaId AreaId
---@return false|Coordinates[]
local function getDungeonLocations(AreaId)
    local dungeonLocation = ZoneDB:GetDungeonLocation(AreaId)

    ---@type table<AreaId, Coordinates>
    local locations = {}
    if dungeonLocation ~= nil then
        for _, dungeonCoords in ipairs(dungeonLocation) do
            ---@type AreaId, MapX, MapY
            local areaId, x, y = dungeonCoords[1], dungeonCoords[2], dungeonCoords[3]

            if (not locations[areaId]) then
                locations[areaId] = { x = {}, y = {} } --, areaId = areaId
            end
            -- Add the coordinates to the table
            locations[areaId].x[#locations[areaId].x + 1] = x
            locations[areaId].y[#locations[areaId].y + 1] = y
        end
        return locations
    else
        return false
    end
end

--- A memoized version of the getDungeonLocations function
--- Just use it as a regular table
---@type table<AreaId, Coordinates[]>>
local DungeonLocations = setmetatable({}, {
    __index = function(self, k)
        local v = getDungeonLocations(k);
        self[k] = v
        return v;
    end,
})

---comment
---@param starterIcons table<UiMapId, AvailablePoints>
---@param id NpcId|ObjectId|ItemId
---@param data table
---@param idType RelationPointType
---@param QuerySingleFunction fun(id: NpcId|ObjectId|ItemId, query: "spawns"): table<AreaId, {[1]: MapX, [2]: MapY}[]>>
---@param itemId ItemId? -- This is used to override the ID which is added into starterIcons
function AvailableMapProcessor.GetSpawns(starterIcons, id, data, idType, QuerySingleFunction, itemId)
    if starterIcons == nil or type(starterIcons) ~= "table" then
        error("GetSpawns called with invalid starterIcons")
        return
    elseif id == nil or type(id) ~= "number" then
        error("GetSpawns called with invalid id")
        return
    elseif data == nil or type(data) ~= "table" then
        error("GetSpawns called with invalid data")
        return
    elseif idType ~= "npc" and idType ~= "object" and idType ~= "item" and idType ~= "npcFinisher" and idType ~= "objectFinisher" then
        error("GetSpawns called with invalid type")
        return
    elseif QuerySingleFunction == nil or type(QuerySingleFunction) ~= "function" then
        error("GetSpawns called with invalid QuerySingleFunction")
        return
    elseif itemId ~= nil and type(itemId) ~= "number" and idType == "item" then
        error("GetSpawns called with invalid itemId")
        return
    end
    local spawns = QuerySingleFunction(id, "spawns")
    if spawns ~= nil then
        ---@type table<AreaId, {x: MapX[], y: MapY[]}>>
        local starter = {}
        for SpawnAreaId, coords in pairs(spawns) do

            local dungeonLocation = DungeonLocations[SpawnAreaId]

            if starter[SpawnAreaId] == nil and not dungeonLocation then
                starter[SpawnAreaId] = { x = {}, y = {}, questId = {} }
            end

            if not dungeonLocation then
                for coordIndex = 1, #coords do
                    local coord = coords[coordIndex]
                    -- Add the coordinates to the table
                    starter[SpawnAreaId].x[#starter[SpawnAreaId].x + 1] = coord[1]
                    starter[SpawnAreaId].y[#starter[SpawnAreaId].y + 1] = coord[2]
                end
            else
                for areaId, dungeonCoords in pairs(dungeonLocation) do
                    if starter[areaId] == nil then
                        starter[areaId] = { x = {}, y = {}, questId = {} } --, areaId = areaId
                    end
                    for coordIndex = 1, #dungeonCoords.x do
                        local x = dungeonCoords.x[coordIndex]
                        local y = dungeonCoords.y[coordIndex]
                        -- Add the coordinates to the table
                        starter[areaId].x[#starter[areaId].x + 1] = x
                        starter[areaId].y[#starter[areaId].y + 1] = y
                    end
                end
            end
        end
        for areaId, coords in pairs(starter) do
            if coords.x and coords.y then
                for i = 1, #coords.x do


                    local UiMapId = ZoneDB:GetUiMapIdByAreaId(areaId)
                    local x = coords.x[i]
                    local y = coords.y[i]

                    -- We only want to handle Maps that are on the worldmap
                    if MapCoodinates.Maps[UiMapId] then
                        if starterIcons[UiMapId] == nil then
                            starterIcons[UiMapId] = { x = {}, y = {}, iconData = {}, id = {}, type = {} }
                        end
                        -- print(UiMapId)
                        local worldX, worldY = MapCoodinates.Maps[UiMapId]:ToWorldCoordinate(x, y)
                        local index = #starterIcons[UiMapId].x + 1
                        starterIcons[UiMapId].x[index] = x
                        starterIcons[UiMapId].y[index] = y
                        starterIcons[UiMapId].iconData[index] = data
                        starterIcons[UiMapId].id[index] = itemId or id
                        starterIcons[UiMapId].type[index] = idType

                        -- All nearby zones but also continents.
                        for NearByUiMapId, _ in pairs(MapCoodinates.Maps[UiMapId].nearbyZones) do
                            if MapCoodinates.Maps[NearByUiMapId] then
                                local mapX, mapY = MapCoodinates.Maps[NearByUiMapId]:ToMapCoordinate(worldX, worldY)
                                if mapX > 0 and mapX < 100 and mapY > 0 and mapY < 100 then
                                    if starterIcons[NearByUiMapId] == nil then
                                        starterIcons[NearByUiMapId] = { x = {}, y = {}, iconData = {}, id = {}, type = {} }
                                    end
                                    index = #starterIcons[NearByUiMapId].x + 1
                                    starterIcons[NearByUiMapId].x[index] = mapX
                                    starterIcons[NearByUiMapId].y[index] = mapY
                                    starterIcons[NearByUiMapId].iconData[index] = data
                                    starterIcons[NearByUiMapId].id[index] = itemId or id
                                    starterIcons[NearByUiMapId].type[index] = idType
                                end
                            end
                        end

                        -- Add to world map
                        local worldMapId = MapCoodinates.Maps[UiMapId].worldMapId
                        if not MapCoodinates.Maps[worldMapId] then
                            if starterIcons[worldMapId] == nil then
                                starterIcons[worldMapId] = { x = {}, y = {}, iconData = {}, id = {}, type = {} }
                            end
                            index = #starterIcons[worldMapId].x + 1
                            -- This is a bit of a special case WorldX/Y is basicall MapX/Y for the worldMapId
                            starterIcons[worldMapId].x[index] = worldX --[[@as MapX]]
                            starterIcons[worldMapId].y[index] = worldY --[[@as MapY]]
                            starterIcons[worldMapId].iconData[index] = data
                            starterIcons[worldMapId].id[index] = itemId or id
                            starterIcons[worldMapId].type[index] = idType
                        end
                    end
                end
            end
        end
    end
    return starterIcons
end

local function Draw(self)
    local Pin = map:AcquirePin(pinTemplate, self, RelationPinMixin)

    local highlightTexture = texPool:Acquire()
    local highlightAlpha = 0.4
    highlightTexture:SetParent(Pin)
    highlightTexture:SetPoint("CENTER");

    local baseTexture = texPool:Acquire();
    baseTexture:SetParent(Pin)
    baseTexture:SetPoint("CENTER");

    local frameLevelType = "PIN_FRAME_LEVEL_AREA_POI_AVAILABLE"

    if Pin.data.majorityType == "npcFinisher" then
        baseTexture:SetTexture(COMPLETE_ICON_PATH)

        highlightTexture:SetTexture(COMPLETE_ICON_PATH)
        frameLevelType = "PIN_FRAME_LEVEL_AREA_POI_COMPLETE"
        Pin:SetSize(10, 15)
    elseif Pin.data.majorityType == "objectFinisher" then
        baseTexture:SetTexture(COMPLETE_ICON_PATH)

        --? Is this even good...?
        -- The object icon for the complete icon
        local objectTexture = texPool:Acquire();
        objectTexture:SetParent(Pin)
        objectTexture:SetPoint("CENTER", 5, -5);
        objectTexture:SetTexture(OBJECT_ICON_PATH)
        objectTexture:SetSize(12,12)
        objectTexture:Show();
        Pin.textures[#Pin.textures + 1] = objectTexture

        highlightTexture:SetTexture(COMPLETE_ICON_PATH)
        frameLevelType = "PIN_FRAME_LEVEL_AREA_POI_COMPLETE"
        Pin:SetSize(10, 15)
    -- elseif Pin.data.majorityType == "item" then
    --     -- The loot bag
    --     baseTexture:SetTexture(LOOT_ICON_PATH)

    --     -- The available icon for loot bag
    --     local availableTexture = texPool:Acquire();
    --     availableTexture:SetParent(Pin)
    --     availableTexture:SetPoint("CENTER");
    --     availableTexture:SetTexture(AVAILABLE_LOOT_ICON_PATH)
    --     availableTexture:Show();
    --     Pin.textures[#Pin.textures + 1] = availableTexture

    --     highlightTexture:SetTexture(LOOT_ICON_PATH) ---TODO: This has not been tested to see if it looks good.
    else
        baseTexture:SetTexture(AVAILABLE_ICON_PATH)
        Pin.textures[#Pin.textures + 1] = baseTexture

        highlightTexture:SetTexture(AVAILABLE_ICON_PATH)
        Pin:SetSize(8, 15)
    end
    baseTexture:Show();
    Pin.textures[#Pin.textures + 1] = baseTexture


    highlightTexture:SetAlpha(highlightAlpha)
    highlightTexture:SetDrawLayer("HIGHLIGHT")
    highlightTexture:SetBlendMode("ADD")
    highlightTexture:Show()
    Pin.textures[#Pin.textures + 1] = highlightTexture


    Pin:UseFrameLevelType(frameLevelType, self.frameLevel)
    Pin:SetPosition(self.x * 0.01, self.y * 0.01) -- Also runs ApplyFrameLevel
    -- Pin:ApplyFrameLevel()
    -- Pin:Show();
end


---comment
---@param ShowData Show
function AvailableMapProcessor.ProcessCompletedQuests(ShowData)
    print("ProcessCompletedQuests")
    ---@type table<UiMapId, AvailablePoints>
    local finisherIcons = {}
    for npcId, npcData in pairs(ShowData.NPC) do
        if npcData.finisher then
            AvailableMapProcessor.GetSpawns(finisherIcons, npcId, npcData.finisher, "npcFinisher", QuestieDB.QueryNPCSingle)
        end
    end
    for objectId, objectData in pairs(ShowData.GameObject) do
        if objectData.finisher then
            AvailableMapProcessor.GetSpawns(finisherIcons, objectId, objectData.finisher, "objectFinisher", QuestieDB.QueryObjectSingle)
        end
    end

    -- We return the majority type to control the icon
    -- Hardcode the types because we already know them
    local majorityType = {
        ["npcFinisher"] = 0,
        ["objectFinisher"] = 0,
    }

    for UiMapId, data in pairs(finisherIcons) do
        local combinedGivers = AvailableMapProcessor.CombineGivers(UiMapId, data)
        print("Finisher", UiMapId, #combinedGivers)
        for combinedGiverIndex = 1, #combinedGivers do
            local combinedGiver = combinedGivers[combinedGiverIndex]
            for _, idType in pairs(combinedGiver.type) do
                majorityType[idType] = majorityType[idType] + 1
            end
            local majority = "npcFinisher"
            if majorityType["objectFinisher"] > majorityType[majority] then
                majority = "objectFinisher"
            end
            local iconData = { uiMapId = UiMapId,
                x = combinedGiver.x,
                y = combinedGiver.y,
                frameLevel = lRound(combinedGiver.y),
                iconData = combinedGiver.iconData,
                id = combinedGiver.id,
                type = combinedGiver.type,
                majorityType = majority
            }
            --* Register draw
            MapEventBus:ObjectRegisterRepeating(iconData, MapEventBus.events.MAP.DRAW_UIMAPID(UiMapId), Draw)
            MapEventBus:RegisterOnce(MapEventBus.events.MAP.REMOVE_ALL_COMPLETED, function()
                MapEventBus:ObjectUnregisterRepeating(iconData, MapEventBus.events.MAP.DRAW_UIMAPID(UiMapId))
            end)
            --* Register tooltips
            -- for i = 1, #combinedGiver.id do
            --     local id = combinedGiver.id[i]
            --     local idType = combinedGiver.type[i]
            --     if not registered[idType] then
            --         registered[idType] = {}
            --     end
            --     if not registered[idType][id] then
            --         registered[idType][id] = true
            --         local object
            --         if idType == "npcFinisher" then
            --             object = QuestieQuest.Show.NPC[id]
            --         elseif idType == "objectFinisher" then
            --             object = QuestieQuest.Show.GameObject[id]
            --         -- elseif idType == "item" then
            --         --     object = QuestieQuest.Show.Item[id]
            --         end
            --         local tooltipFunction = function() MapTooltip.SimpleAvailableTooltip(id, idType, object) end
            --         local event = MapEventBus.events.TOOLTIP.ADD_AVAILABLE_TOOLTIP(id, idType)
            --         MapEventBus:ObjectRegisterRepeating(object.finisher, event, tooltipFunction)
            --         MapEventBus:RegisterOnce(MapEventBus.events.MAP.REMOVE_ALL_AVAILABLE, function()
            --             MapEventBus:ObjectUnregisterRepeating(object.finisher, event)
            --         end)
            --     end
            -- end
            -- Reset the type counters
            majorityType["npcFinisher"] = 0
            majorityType["objectFinisher"] = 0
        end
    end
end

---comment
---@param ShowData Show
function AvailableMapProcessor.ProcessAvailableQuests(ShowData)
    print("ProcessAvailableQuests")
    ---@type table<UiMapId, AvailablePoints>
    local starterIcons = {}
    for npcId, npcData in pairs(ShowData.NPC) do
        if npcData.available and npcData.finisher == nil then
            AvailableMapProcessor.GetSpawns(starterIcons, npcId, npcData.available, "npc", QuestieDB.QueryNPCSingle)
        end
    end
    for objectId, objectData in pairs(ShowData.GameObject) do
        if objectData.available and objectData.finisher == nil then
            AvailableMapProcessor.GetSpawns(starterIcons, objectId, objectData.available, "object", QuestieDB.QueryObjectSingle)
        end
    end

    --! Disabled because the insane amount of icons plus the multiple entries
    --! Also look at the combine givers the "alreadySpawned" stuff.
    --? These should probably be Polygons
    -- for itemId, itemData in pairs(ShowData.Item) do
    --     if itemData.available then
    --         local npcDrops = QuestieDB.QueryItemSingle(itemId, "npcDrops")
    --         if npcDrops then
    --             for _, npcId in pairs(npcDrops) do
    --                 AvailableMapProcessor.GetSpawns(starterIcons, npcId, itemData.available, "item", QuestieDB.QueryNPCSingle, itemId)
    --             end
    --         end
    --     end
    -- end

    --? Trying to create a data object usable in polygons
    -- local availableItems = {}
    -- for itemId, itemData in pairs(ShowData.Item) do
    --     if itemData.available then
    --         local npcDrops = QuestieDB.QueryItemSingle(itemId, "npcDrops")
    --         if npcDrops then
    --             local starterIconsItem = {dropsItem = itemId, starterIcons = nil}
    --             for _, npcId in pairs(npcDrops) do
    --                 if not availableItems[npcId] then
    --                     local npcData = {}
    --                     AvailableMapProcessor.GetSpawns(npcData, npcId, itemData.available, "npc", QuestieDB.QueryNPCSingle, itemId)
    --                     starterIconsItem.starterIcons = npcData
    --                     availableItems[npcId] = starterIconsItem
    --                 end
    --             end
    --         end
    --     end
    -- end
    -- DevTools_Dump(availableItems)


    -- We return the majority type to control the icon
    -- Hardcode the types because we already know them
    local majorityType = {
        ["item"] = 0,
        ["object"] = 0,
        ["npc"] = 0
    }
    for UiMapId, data in pairs(starterIcons) do
        local combinedGivers = AvailableMapProcessor.CombineGivers(UiMapId, data)
        for combinedGiverIndex = 1, #combinedGivers do
            local combinedGiver = combinedGivers[combinedGiverIndex]
            for _, idType in pairs(combinedGiver.type) do
                majorityType[idType] = majorityType[idType] + 1
            end
            local majority = "npc"
            if majorityType["item"] > majorityType[majority] then
                majority = "item"
            end
            if majorityType["object"] > majorityType[majority] then
                majority = "object"
            end
            local iconData = { uiMapId = UiMapId,
                x = combinedGiver.x,
                y = combinedGiver.y,
                frameLevel = lRound(combinedGiver.y),
                iconData = combinedGiver.iconData,
                id = combinedGiver.id,
                type = combinedGiver.type,
                majorityType = majority
            }
            --* Register draw
            MapEventBus:ObjectRegisterRepeating(iconData, MapEventBus.events.MAP.DRAW_UIMAPID(UiMapId), Draw)
            MapEventBus:RegisterOnce(MapEventBus.events.MAP.REMOVE_ALL_AVAILABLE, function()
                MapEventBus:ObjectUnregisterRepeating(iconData, MapEventBus.events.MAP.DRAW_UIMAPID(UiMapId))
            end)
            --* Register tooltips
            -- for i = 1, #combinedGiver.id do
            --     local id = combinedGiver.id[i]
            --     local idType = combinedGiver.type[i]
            --     if not registered[idType] then
            --         registered[idType] = {}
            --     end
            --     if not registered[idType][id] then
            --         registered[idType][id] = true
            --         local object
            --         if idType == "npc" then
            --             object = QuestieQuest.Show.NPC[id]
            --         elseif idType == "object" then
            --             object = QuestieQuest.Show.GameObject[id]
            --         elseif idType == "item" then
            --             object = QuestieQuest.Show.Item[id]
            --         end
            --         local tooltipFunction = function() MapTooltip.SimpleAvailableTooltip(id, idType, object) end
            --         local event = MapEventBus.events.TOOLTIP.ADD_AVAILABLE_TOOLTIP(id, idType)
            --         MapEventBus:ObjectRegisterRepeating(object.available, event, tooltipFunction)
            --         MapEventBus:RegisterOnce(MapEventBus.events.MAP.REMOVE_ALL_AVAILABLE, function()
            --             MapEventBus:ObjectUnregisterRepeating(object.available, event)
            --         end)
            --     end
            -- end
            -- Reset the type counters
            majorityType["item"] = 0
            majorityType["object"] = 0
            majorityType["npc"] = 0
        end
    end
end

---Absolute center, not average
-- -@param points table<number, Point> @Point list {x=0, y=0}
---@return MapX x, MapY y
local function AbsCenterPoint(points)
    --Localize the functions
    --local min, max = math.min, math.max
    local minX = 99999999999
    local minY = 99999999999
    local maxX = 0
    local maxY = 0
    local x, y
    local length = #points.x == #points.y and #points.x or 0
    if length == 0 then
        error("AbsCenterPoint: points.x and points.y must be the same length")
    end
    for pointIndex = 1, length do
        x = points.x[pointIndex]
        y = points.y[pointIndex]
        --? Inline is always faster than function call
        if (x and minX > x) then
            minX = x
        end
        if (y and minY > y) then
            minY = y
        end
        if (x and maxX < x) then
            maxX = x
        end
        if (y and maxY < y) then
            maxY = y
        end
        --minX = min(minX, point.x or point.orgX);
        --minY = min(minY, point.y or point.orgY);
        --maxX = max(maxX, point.x or point.orgX);
        --maxY = max(maxY, point.y or point.orgY);
    end
    --local fCenterX = minX + ((maxX - minX)/2)--local fCenterY = minY + ((maxY - minY)/2)
    ---@diagnostic disable-next-line: return-type-mismatch
    return minX + ((maxX - minX) / 2), minY + ((maxY - minY) / 2)
end

---Combines different gives with each other
---@param uiMapId UiMapId
---@param points AvailablePoints
---@return AvailablePoints[]
function AvailableMapProcessor.CombineGivers(uiMapId, points)
    --print("calc1")
    if (points == nil) then return {} end

    points.touched = {}

    local worldMapFrameWidth = WorldMapFrame:GetWidth() * WorldMapFrame:GetEffectiveScale()
    local worldMapFrameHeight = WorldMapFrame:GetHeight() * WorldMapFrame:GetEffectiveScale()
    local distWidth = ConvertPixelsToUI(7 * RelationPinMixin:GetIconScale(uiMapId), WorldMapFrame:GetEffectiveScale()) --actual = 12
    local distHeight = ConvertPixelsToUI(12 * RelationPinMixin:GetIconScale(uiMapId), WorldMapFrame:GetEffectiveScale()) --actual = 29

    local length = #points.x == #points.y and #points.x or nil
    if length == nil then
        error("CombineGivers: points.x and points.y must be the same length")
    end

    ---@type AvailablePoints[]
    local returnPoints = {}

    local FoundUntouched = nil
    ---@type AvailablePoints
    local notes = { x = {}, y = {}, iconData = {}, id = {} }
    while (true) do
        FoundUntouched = nil;
        for sourcePointIndex = 1, length do
            if (points.touched[sourcePointIndex] == nil) then
                --! This stuff works, but i have to figure out a way to not also throw a way the coords.
                -- Prevent the same data from being added twice
                -- local alreadyAdded = {}

                --We touch this
                FoundUntouched = true;
                points.touched[sourcePointIndex] = true;

                local aX, aY = points.x[sourcePointIndex], points.y[sourcePointIndex] -- MapCoodinates.Maps[UiMapId]:ToMapCoordinate(points.x[sourcePointIndex], points.y[sourcePointIndex])
                if (aX and aY) then
                    notes = {
                        x = { aX },
                        y = { aY },
                        iconData = { points.iconData[sourcePointIndex] },
                        id = { points.id[sourcePointIndex] },
                        type = { points.type[sourcePointIndex] }
                    }
                    -- Add the first data to alreadyAdded
                    -- alreadyAdded[points.iconData[sourcePointIndex]] = true

                    --* tinsert(notes.? points.?) is the same as below
                    -- notes.x[#notes.x + 1] = points.x[sourcePointIndex]
                    -- notes.y[#notes.y + 1] = points.y[sourcePointIndex]
                    -- notes.iconData[#notes.iconData + 1] = points.iconData[sourcePointIndex]
                    -- notes.id[#notes.id + 1] = points.id[sourcePointIndex]

                    for targetPointIndex = 1, length do
                        if (points.touched[targetPointIndex] == nil) then
                            local bX, bY = points.x[targetPointIndex], points.y[targetPointIndex] --MapCoodinates.Maps[UiMapId]:ToMapCoordinate(points.x[targetPointIndex], points.y[targetPointIndex])
                            if (bX and bY) then
                                local dX = (aX / 100 - bX / 100)
                                local dY = (aY / 100 - bY / 100)
                                --? This is a fast math.abs function
                                if dX < 0 then
                                    dX = -dX
                                end
                                if dY < 0 then
                                    dY = -dY
                                end
                                dX = worldMapFrameWidth * dX
                                dY = worldMapFrameHeight * dY

                                if (dX < distWidth and dY < distHeight) then
                                    points.touched[targetPointIndex] = true
                                    -- If the data has previously been added already, don't add it again
                                    -- if not alreadyAdded[points.iconData[targetPointIndex]] then

                                    --* tinsert(notes.? points.?) is the same as below
                                    local index = #notes.x + 1
                                    notes.x[index] = points.x[targetPointIndex]
                                    notes.y[index] = points.y[targetPointIndex]
                                    notes.iconData[index] = points.iconData[targetPointIndex]
                                    notes.id[index] = points.id[targetPointIndex]
                                    notes.type[index] = points.type[targetPointIndex]

                                    -- alreadyAdded[points.iconData[targetPointIndex]] = true
                                    -- end
                                end
                            end
                        end
                    end
                    local x, y = AbsCenterPoint(notes)
                    returnPoints[#returnPoints + 1] = {
                        x = x,
                        y = y,
                        iconData = notes.iconData,
                        id = notes.id,
                        type = notes.type
                    }
                end
            end
        end
        if (FoundUntouched == nil) then
            points.touched = nil
            break
        end
    end
    return returnPoints
end
