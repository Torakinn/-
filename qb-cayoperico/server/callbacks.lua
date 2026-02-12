local QBCore = exports['qb-core']:GetCoreObject()

-- プレイヤーが必要アイテムを持っているかチェック
QBCore.Functions.CreateCallback('qb-cayoperico:callback:hasRequiredItems', function(source, cb)
    local hasAll = true
    local missingItems = {}
    
    for _, item in pairs(Config.RequiredItems) do
        local hasItem = exports.ox_inventory:GetItem(source, item, nil, true)
        if not hasItem or hasItem < 1 then
            hasAll = false
            table.insert(missingItems, item)
        end
    end
    
    cb(hasAll, missingItems)
end)

-- プレイヤーの近くにいるプレイヤーを取得
QBCore.Functions.CreateCallback('qb-cayoperico:callback:getNearbyPlayers', function(source, cb, maxDistance)
    local src = source
    local players = {}
    local srcCoords = GetEntityCoords(GetPlayerPed(src))
    local allPlayers = QBCore.Functions.GetQBPlayers()
    
    for _, player in pairs(allPlayers) do
        if player.PlayerData.source ~= src then
            local targetCoords = GetEntityCoords(GetPlayerPed(player.PlayerData.source))
            local distance = #(srcCoords - targetCoords)
            
            if distance <= (maxDistance or 10.0) then
                table.insert(players, {
                    source = player.PlayerData.source,
                    name = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname,
                    citizenid = player.PlayerData.citizenid
                })
            end
        end
    end
    
    cb(players)
end)

-- 特定のアイテムを持っているかチェック
QBCore.Functions.CreateCallback('qb-cayoperico:callback:hasItem', function(source, cb, item)
    local hasItem = exports.ox_inventory:GetItem(source, item, nil, true)
    cb(hasItem and hasItem >= 1)
end)

if Config.Debug then
    print("[CayoPerico] Callbacks loaded")
end
