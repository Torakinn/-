local QBCore = exports['qb-core']:GetCoreObject()
local spawnedGuards = {}
local guardsAlerted = false
local Locale = Locale.ja

-- ガードのスポーン
CreateThread(function()
    Wait(5000) -- 他のスクリプトの読み込みを待つ
    
    -- ガードモデルをロード
    local guardModels = {
        's_m_m_highsec_01',
        's_m_m_highsec_02',
        's_m_y_blackops_01',
        's_m_y_blackops_02',
        's_m_y_blackops_03',
        's_m_y_marine_01'
    }
    
    for _, model in pairs(guardModels) do
        RequestModel(GetHashKey(model))
        while not HasModelLoaded(GetHashKey(model)) do
            Wait(10)
        end
    end
    
    -- ガードをスポーン
    for idx, spawnData in ipairs(Config.GuardSpawns) do
        local modelName = guardModels[math.random(1, #guardModels)]
        local ped = CreatePed(4, GetHashKey(modelName), spawnData.coords.x, spawnData.coords.y, spawnData.coords.z, spawnData.heading, true, false)
        
        if ped and DoesEntityExist(ped) then
            -- ガードの設定
            SetPedArmour(ped, 100)
            SetPedMaxHealth(ped, 500)
            SetEntityHealth(ped, 500)
            SetPedFleeAttributes(ped, 0, false)
            SetPedCombatAttributes(ped, 46, true)
            SetPedCombatAbility(ped, 100)
            SetPedCombatMovement(ped, 2)
            SetPedCombatRange(ped, 2)
            SetPedAlertness(ped, 3)
            SetPedAccuracy(ped, 75)
            
            -- 武器を与える
            GiveWeaponToPed(ped, GetHashKey(spawnData.weapon), 250, false, true)
            SetCurrentPedWeapon(ped, GetHashKey(spawnData.weapon), true)
            
            -- 関係を設定
            SetPedRelationshipGroupHash(ped, GetHashKey("HATES_PLAYER"))
            
            -- パトロールの場合
            if spawnData.patrol then
                TaskPatrol(ped, idx)
            else
                -- 定位置で警戒
                TaskGuardCurrentPosition(ped, 15.0, 15.0, 1)
            end
            
            table.insert(spawnedGuards, {
                ped = ped,
                coords = spawnData.coords,
                patrol = spawnData.patrol or false,
                alerted = false
            })
        end
    end
    
    if Config.Debug then
        print(string.format("[CayoPerico] Spawned %d guards", #spawnedGuards))
    end
end)

-- パトロールタスク
function TaskPatrol(ped, routeIdx)
    CreateThread(function()
        local route = Config.PatrolRoutes[routeIdx]
        if not route then
            -- デフォルトパトロール
            TaskWanderStandard(ped, 10.0, 10)
            return
        end
        
        local pointIndex = 1
        
        while DoesEntityExist(ped) and not IsPedDeadOrDying(ped) do
            if not guardsAlerted then
                local point = route.points[pointIndex]
                
                TaskGoToCoordAnyMeans(ped, point.x, point.y, point.z, 1.0, 0, 0, 786603, 0xbf800000)
                
                -- 目的地に到達するまで待機
                while DoesEntityExist(ped) and not IsPedDeadOrDying(ped) do
                    local pedCoords = GetEntityCoords(ped)
                    local dist = #(pedCoords - point)
                    
                    if dist < 2.0 then
                        break
                    end
                    
                    Wait(500)
                end
                
                -- ポイントで待機
                TaskStandStill(ped, route.waitTime)
                Wait(route.waitTime)
                
                -- 次のポイントへ
                pointIndex = pointIndex + 1
                if pointIndex > #route.points then
                    pointIndex = 1
                end
            else
                -- 警戒状態の場合は通常の戦闘AI
                break
            end
            
            Wait(100)
        end
    end)
end

-- プレイヤー検知システム
CreateThread(function()
    while true do
        Wait(1000)
        
        if not guardsAlerted then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            
            for _, guard in pairs(spawnedGuards) do
                if DoesEntityExist(guard.ped) and not IsPedDeadOrDying(guard.ped) then
                    local guardCoords = GetEntityCoords(guard.ped)
                    local distance = #(playerCoords - guardCoords)
                    
                    -- 検知範囲: 30m
                    if distance < 30.0 then
                        -- 視線チェック
                        local hasLineOfSight = HasEntityClearLosToEntity(guard.ped, playerPed, 17)
                        
                        if hasLineOfSight and distance < 15.0 then
                            -- ガードがプレイヤーを発見
                            AlertGuards(playerPed)
                            break
                        end
                    end
                end
            end
        else
            -- すでに警戒中の場合
            Wait(5000)
        end
    end
end)

-- ガードを警戒状態にする
function AlertGuards(targetPed)
    if guardsAlerted then return end
    
    guardsAlerted = true
    QBCore.Functions.Notify(Locale["guard_alerted"], 'error')
    PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", false)
    
    for _, guard in pairs(spawnedGuards) do
        if DoesEntityExist(guard.ped) and not IsPedDeadOrDying(guard.ped) then
            guard.alerted = true
            
            -- 戦闘モードに切り替え
            TaskCombatPed(guard.ped, targetPed, 0, 16)
            SetPedKeepTask(guard.ped, true)
            SetPedCombatAttributes(guard.ped, 5, true)
            SetPedCombatAttributes(guard.ped, 46, true)
        end
    end
    
    -- 増援呼び出し（50%の確率）
    if math.random(1, 100) <= 50 then
        Wait(30000) -- 30秒後
        SpawnReinforcements()
    end
end

-- 増援スポーン
function SpawnReinforcements()
    QBCore.Functions.Notify(Locale["reinforcements_called"], 'error')
    
    local reinforcementCount = math.random(3, 5)
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    for i = 1, reinforcementCount do
        local spawnOffset = vector3(
            math.random(-50, 50),
            math.random(-50, 50),
            0
        )
        local spawnCoords = playerCoords + spawnOffset
        
        local ped = CreatePed(4, GetHashKey('s_m_y_blackops_03'), spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, false)
        
        if ped and DoesEntityExist(ped) then
            SetPedArmour(ped, 150)
            SetPedMaxHealth(ped, 600)
            SetEntityHealth(ped, 600)
            SetPedFleeAttributes(ped, 0, false)
            SetPedCombatAttributes(ped, 46, true)
            SetPedCombatAbility(ped, 100)
            SetPedCombatMovement(ped, 2)
            SetPedCombatRange(ped, 2)
            SetPedAlertness(ped, 3)
            SetPedAccuracy(ped, 80)
            
            GiveWeaponToPed(ped, GetHashKey('WEAPON_ASSAULTRIFLE'), 250, false, true)
            SetCurrentPedWeapon(ped, GetHashKey('WEAPON_ASSAULTRIFLE'), true)
            
            SetPedRelationshipGroupHash(ped, GetHashKey("HATES_PLAYER"))
            TaskCombatPed(ped, PlayerPedId(), 0, 16)
            
            table.insert(spawnedGuards, {
                ped = ped,
                coords = spawnCoords,
                patrol = false,
                alerted = true,
                reinforcement = true
            })
        end
        
        Wait(500)
    end
end

-- クリーンアップ
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    for _, guard in pairs(spawnedGuards) do
        if DoesEntityExist(guard.ped) then
            DeleteEntity(guard.ped)
        end
    end
    
    spawnedGuards = {}
end)

-- 強盗完了/失敗時にガードをクリーンアップ
RegisterNetEvent('qb-cayoperico:client:heistCompleted', function()
    Wait(2000)
    for _, guard in pairs(spawnedGuards) do
        if DoesEntityExist(guard.ped) then
            DeleteEntity(guard.ped)
        end
    end
    spawnedGuards = {}
    guardsAlerted = false
end)

RegisterNetEvent('qb-cayoperico:client:heistFailed', function()
    Wait(2000)
    for _, guard in pairs(spawnedGuards) do
        if DoesEntityExist(guard.ped) then
            DeleteEntity(guard.ped)
        end
    end
    spawnedGuards = {}
    guardsAlerted = false
end)

if Config.Debug then
    print("[CayoPerico] Guards script loaded")
end
