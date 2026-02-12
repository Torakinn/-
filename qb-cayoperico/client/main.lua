local QBCore = exports['qb-core']:GetCoreObject()
local currentHeist = nil
local isInHeist = false
local Locale = Locale.ja

-- 強盗開始ポイント
CreateThread(function()
    -- ox_target を使用して準備エリアを作成
    exports.ox_target:addBoxZone({
        coords = Config.PreparationZone.coords,
        size = vec3(2, 2, 2),
        rotation = 0,
        debug = Config.Debug,
        options = {
            {
                name = 'cayoperico_start',
                icon = 'fas fa-island-tropical',
                label = Config.PreparationZone.label,
                onSelect = function()
                    OpenStartMenu()
                end,
                canInteract = function()
                    return not isInHeist
                end
            }
        }
    })
end)

-- スタートメニューを開く
function OpenStartMenu()
    QBCore.Functions.TriggerCallback('qb-cayoperico:server:checkCooldown', function(onCooldown, minutesLeft)
        if onCooldown then
            QBCore.Functions.Notify(string.format(Locale["heist_cooldown"], minutesLeft), 'error')
            return
        end
        
        QBCore.Functions.TriggerCallback('qb-cayoperico:server:getCopCount', function(copCount)
            if copCount < Config.MinCops then
                QBCore.Functions.Notify(string.format(Locale["not_enough_cops"], Config.MinCops), 'error')
                return
            end
            
            -- チーム選択メニュー
            ShowTeamSelectionMenu()
        end)
    end)
end

-- チーム選択メニュー
function ShowTeamSelectionMenu()
    QBCore.Functions.TriggerCallback('qb-cayoperico:callback:getNearbyPlayers', function(nearbyPlayers)
        local teamMembers = { GetPlayerServerId(PlayerId()) }
        
        local options = {}
        
        for _, player in pairs(nearbyPlayers) do
            table.insert(options, {
                title = player.name,
                description = 'チームに招待',
                icon = 'user',
                onSelect = function()
                    table.insert(teamMembers, player.source)
                    QBCore.Functions.Notify(string.format(Locale["team_joined"], player.name), 'success')
                end
            })
        end
        
        table.insert(options, {
            title = Locale["menu_start_heist"],
            description = string.format('チームメンバー: %d人', #teamMembers),
            icon = 'play',
            onSelect = function()
                if #teamMembers >= Config.MinPlayers and #teamMembers <= Config.MaxPlayers then
                    StartHeist(teamMembers)
                else
                    QBCore.Functions.Notify(string.format(Locale["not_enough_players"], Config.MinPlayers), 'error')
                end
            end
        })
        
        lib.registerContext({
            id = 'cayoperico_team_menu',
            title = 'カヨ・ペリコ強盗',
            options = options
        })
        
        lib.showContext('cayoperico_team_menu')
    end, 10.0)
end

-- 強盗開始
function StartHeist(teamMembers)
    QBCore.Functions.TriggerCallback('qb-cayoperico:callback:hasRequiredItems', function(hasItems, missingItems)
        if not hasItems then
            QBCore.Functions.Notify(string.format(Locale["missing_item"], table.concat(missingItems, ", ")), 'error')
            return
        end
        
        TriggerServerEvent('qb-cayoperico:server:startHeist', teamMembers)
    end)
end

-- 強盗開始時のクライアント処理
RegisterNetEvent('qb-cayoperico:client:heistStarted', function(heistData)
    currentHeist = heistData
    isInHeist = true
    
    QBCore.Functions.Notify(Locale["heist_started"], 'success')
    QBCore.Functions.Notify(string.format(Locale["main_target"], heistData.mainTarget.label), 'info', 5000)
    
    -- ルート選択メニューを表示（リーダーのみ）
    if heistData.leader == GetPlayerServerId(PlayerId()) then
        Wait(2000)
        ShowRouteSelectionMenu()
    end
end)

-- ルート選択メニュー
function ShowRouteSelectionMenu()
    local options = {}
    
    for routeId, route in pairs(Config.EntryRoutes) do
        table.insert(options, {
            title = route.name,
            description = route.description,
            icon = route.icon,
            onSelect = function()
                SelectRoute(routeId)
            end
        })
    end
    
    lib.registerContext({
        id = 'cayoperico_route_menu',
        title = Locale["select_route"],
        options = options
    })
    
    lib.showContext('cayoperico_route_menu')
end

-- ルート選択
function SelectRoute(routeName)
    TriggerServerEvent('qb-cayoperico:server:selectRoute', routeName)
end

-- ルート選択後
RegisterNetEvent('qb-cayoperico:client:routeSelected', function(routeName)
    local route = Config.EntryRoutes[routeName]
    if not route then return end
    
    QBCore.Functions.Notify(string.format(Locale["route_selected"], route.name), 'success')
    
    -- プレイヤーを島にテレポート
    DoScreenFadeOut(1000)
    Wait(1000)
    
    SetEntityCoords(PlayerPedId(), route.spawnPoint.x, route.spawnPoint.y, route.spawnPoint.z)
    
    Wait(1000)
    DoScreenFadeIn(1000)
    
    -- フェーズ2開始
    QBCore.Functions.Notify(Locale["phase_infiltration"], 'info')
end)

-- ハッキング成功
RegisterNetEvent('qb-cayoperico:client:hackSuccess', function(hackType)
    QBCore.Functions.Notify(Locale["hacking_success"], 'success')
    
    if hackType == "security" then
        QBCore.Functions.Notify(Locale["camera_disabled"], 'success')
    elseif hackType == "door" then
        QBCore.Functions.Notify(Locale["door_unlocked"], 'success')
    elseif hackType == "vault" then
        QBCore.Functions.Notify(Locale["vault_opened"], 'success')
        QBCore.Functions.Notify(Locale["phase_vault"], 'info')
    end
end)

-- 警報発動
RegisterNetEvent('qb-cayoperico:client:alarmTriggered', function()
    QBCore.Functions.Notify(Locale["alarm_triggered"], 'error')
    PlaySoundFrontend(-1, "Lose_1st", "GTAO_FM_Events_Soundset", false)
end)

-- 金庫オープン
RegisterNetEvent('qb-cayoperico:client:vaultOpened', function()
    QBCore.Functions.Notify(Locale["vault_drill_success"], 'success')
    QBCore.Functions.Notify(Locale["police_notified"], 'error')
end)

-- 警察アラート
RegisterNetEvent('qb-cayoperico:client:policeAlert', function(coords)
    if not coords then coords = Config.IslandLocation end
    
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    
    QBCore.Functions.Notify(Locale["dispatch_alert"], 'error', 10000)
    
    -- ブリップを追加
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 2.0)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Locale["dispatch_alert"])
    EndTextCommandSetBlipName(blip)
    
    -- 2分後にブリップを削除
    SetTimeout(120000, function()
        RemoveBlip(blip)
    end)
end)

-- 強盗完了
RegisterNetEvent('qb-cayoperico:client:heistCompleted', function(totalReward)
    QBCore.Functions.Notify(Locale["heist_completed"], 'success')
    QBCore.Functions.Notify(string.format(Locale["reward_total"], totalReward), 'success', 10000)
    
    isInHeist = false
    currentHeist = nil
    
    -- プレイヤーをロスサントスに戻す
    DoScreenFadeOut(1000)
    Wait(1000)
    
    SetEntityCoords(PlayerPedId(), Config.PreparationZone.coords.x, Config.PreparationZone.coords.y, Config.PreparationZone.coords.z)
    
    Wait(1000)
    DoScreenFadeIn(1000)
end)

-- 強盗失敗
RegisterNetEvent('qb-cayoperico:client:heistFailed', function()
    QBCore.Functions.Notify(Locale["heist_failed"], 'error')
    
    isInHeist = false
    currentHeist = nil
    
    -- プレイヤーをロスサントスに戻す
    DoScreenFadeOut(1000)
    Wait(1000)
    
    SetEntityCoords(PlayerPedId(), Config.PreparationZone.coords.x, Config.PreparationZone.coords.y, Config.PreparationZone.coords.z)
    
    Wait(1000)
    DoScreenFadeIn(1000)
end)

-- コマンド: 強盗をキャンセル（デバッグ用）
if Config.Debug then
    RegisterCommand('cancelheist', function()
        if isInHeist then
            TriggerServerEvent('qb-cayoperico:server:heistFailed')
        end
    end)
end

if Config.Debug then
    print("[CayoPerico] Client main script loaded")
end
