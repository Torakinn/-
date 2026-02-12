local QBCore = exports['qb-core']:GetCoreObject()
local Locale = Locale.ja

-- 金庫室ゾーン
CreateThread(function()
    Wait(1000)
    
    for vaultId, vault in pairs(Config.VaultLocations) do
        exports.ox_target:addBoxZone({
            coords = vault.coords,
            size = vec3(1.5, 1.5, 1.5),
            rotation = 0,
            debug = Config.Debug,
            options = {
                {
                    name = 'cayoperico_vault_' .. vaultId,
                    icon = 'fas fa-vault',
                    label = vault.label,
                    item = vault.requiredItem,
                    onSelect = function()
                        DrillVault(vaultId)
                    end
                }
            }
        })
    end
end)

-- 金庫ドリル
function DrillVault(vaultId)
    QBCore.Functions.Notify(Locale["drilling_vault"], 'info')
    
    if lib.progressBar({
        duration = 30000,
        label = Locale["progress_drilling"],
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'anim@heists@fleeca_bank@drilling',
            clip = 'drill_straight_idle'
        },
        prop = {
            model = 'hei_prop_heist_drill',
            bone = 57005,
            coords = vec3(0.14, 0, -0.01),
            rotation = vec3(90.0, -90.0, 180.0)
        }
    }) then
        TriggerServerEvent('qb-cayoperico:server:drillVault')
        
        -- 副次ターゲットゾーンを作成
        CreateSecondaryTargetZones()
    end
end

-- 副次ターゲットゾーン作成
function CreateSecondaryTargetZones()
    for lootType, lootConfig in pairs(Config.SecondaryTargets) do
        for idx, location in ipairs(lootConfig.locations) do
            exports.ox_target:addBoxZone({
                coords = location,
                size = vec3(1, 1, 1),
                rotation = 0,
                debug = Config.Debug,
                options = {
                    {
                        name = 'cayoperico_loot_' .. lootType .. '_' .. idx,
                        icon = 'fas fa-hand-holding-dollar',
                        label = lootConfig.label,
                        onSelect = function()
                            CollectLoot(lootType, idx)
                        end
                    }
                }
            })
        end
    end
end

-- 戦利品回収
function CollectLoot(lootType, idx)
    if lib.progressBar({
        duration = 5000,
        label = Locale["collecting_loot"],
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'anim@gangops@facility@servers@',
            clip = 'hotwire'
        }
    }) then
        TriggerServerEvent('qb-cayoperico:server:collectLoot', lootType)
        
        -- このゾーンを削除
        exports.ox_target:removeZone('cayoperico_loot_' .. lootType .. '_' .. idx)
    end
end

-- 脱出ポイントゾーン
CreateThread(function()
    Wait(1000)
    
    for idx, escapePoint in ipairs(Config.EscapePoints) do
        exports.ox_target:addBoxZone({
            coords = escapePoint.coords,
            size = vec3(3, 3, 3),
            rotation = 0,
            debug = Config.Debug,
            options = {
                {
                    name = 'cayoperico_escape_' .. idx,
                    icon = 'fas fa-plane-departure',
                    label = escapePoint.label,
                    onSelect = function()
                        EscapeHeist()
                    end
                }
            }
        })
        
        -- ブリップを追加
        local blip = AddBlipForCoord(escapePoint.coords.x, escapePoint.coords.y, escapePoint.coords.z)
        SetBlipSprite(blip, 467)
        SetBlipColour(blip, 2)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(escapePoint.label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- 強盗から脱出
function EscapeHeist()
    QBCore.Functions.Notify(Locale["escaped"], 'success')
    
    if lib.progressBar({
        duration = 10000,
        label = Locale["progress_escaping"],
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true
        }
    }) then
        TriggerServerEvent('qb-cayoperico:server:escapeComplete')
    end
end

if Config.Debug then
    print("[CayoPerico] Zones script loaded")
end
