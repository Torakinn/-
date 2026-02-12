local QBCore = exports['qb-core']:GetCoreObject()
local hackingActive = false
local Locale = Locale.ja

-- セキュリティポイントのox_target設定
CreateThread(function()
    Wait(1000)
    
    for pointId, point in pairs(Config.SecurityPoints) do
        exports.ox_target:addBoxZone({
            coords = point.coords,
            size = vec3(1, 1, 1),
            rotation = 0,
            debug = Config.Debug,
            options = {
                {
                    name = 'cayoperico_hack_' .. pointId,
                    icon = 'fas fa-laptop',
                    label = point.label,
                    item = point.requiredItem,
                    onSelect = function()
                        StartHack(point.hackType, pointId)
                    end,
                    canInteract = function()
                        return not hackingActive
                    end
                }
            }
        })
    end
end)

-- ハッキング開始
function StartHack(hackType, pointId)
    if hackingActive then return end
    
    local hackSettings = Config.HackSettings[hackType]
    if not hackSettings then return end
    
    hackingActive = true
    QBCore.Functions.Notify(Locale["hacking_start"], 'info')
    
    -- プログレスバーを表示
    if lib.progressBar({
        duration = 3000,
        label = Locale["progress_hacking"],
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
        -- ハッキングミニゲーム開始
        if hackType == "security" then
            DoSecurityHack(hackSettings, pointId)
        elseif hackType == "door" then
            DoDoorHack(hackSettings, pointId)
        elseif hackType == "vault" then
            DoVaultHack(hackSettings, pointId)
        end
    else
        hackingActive = false
        QBCore.Functions.Notify(Locale["hacking_failed"], 'error')
    end
end

-- セキュリティハック（簡単 - スキルチェック）
function DoSecurityHack(settings, pointId)
    local success = lib.skillCheck({'easy', 'easy', 'easy'}, {'w', 'a', 's', 'd'})
    
    if success then
        TriggerServerEvent('qb-cayoperico:server:hackSuccess', 'security')
        hackingActive = false
    else
        TriggerServerEvent('qb-cayoperico:server:hackFailed', 'security')
        QBCore.Functions.Notify(Locale["hacking_failed"], 'error')
        QBCore.Functions.Notify(string.format(Locale["hacking_lockout"], settings.lockoutTime / 1000), 'error')
        
        Wait(settings.lockoutTime)
        hackingActive = false
    end
end

-- ドアハック（中程度 - 記憶ゲーム）
function DoDoorHack(settings, pointId)
    local success = lib.skillCheck({'easy', 'medium', 'medium'}, {'w', 'a', 's', 'd'})
    
    if success then
        TriggerServerEvent('qb-cayoperico:server:hackSuccess', 'door')
        hackingActive = false
    else
        TriggerServerEvent('qb-cayoperico:server:hackFailed', 'door')
        QBCore.Functions.Notify(Locale["hacking_failed"], 'error')
        QBCore.Functions.Notify(string.format(Locale["hacking_lockout"], settings.lockoutTime / 1000), 'error')
        
        Wait(settings.lockoutTime)
        hackingActive = false
    end
end

-- 金庫ハック（難しい - 指紋認証）
function DoVaultHack(settings, pointId)
    -- より高難易度のスキルチェック
    local success = lib.skillCheck({'medium', 'hard', 'hard', 'hard'}, {'w', 'a', 's', 'd'})
    
    if success then
        TriggerServerEvent('qb-cayoperico:server:hackSuccess', 'vault')
        hackingActive = false
    else
        TriggerServerEvent('qb-cayoperico:server:hackFailed', 'vault')
        QBCore.Functions.Notify(Locale["hacking_failed"], 'error')
        QBCore.Functions.Notify(string.format(Locale["hacking_lockout"], settings.lockoutTime / 1000 + settings.penalty), 'error')
        
        Wait(settings.lockoutTime + (settings.penalty * 1000))
        hackingActive = false
    end
end

-- HTMLベースのハッキングUI（代替実装）
function StartHTMLHack(hackType)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "startHack",
        hackType = hackType,
        time = Config.HackSettings[hackType].time
    })
end

-- NUIコールバック: ハッキング成功
RegisterNUICallback('hackSuccess', function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('qb-cayoperico:server:hackSuccess', data.hackType)
    hackingActive = false
    cb('ok')
end)

-- NUIコールバック: ハッキング失敗
RegisterNUICallback('hackFailed', function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('qb-cayoperico:server:hackFailed', data.hackType)
    
    local settings = Config.HackSettings[data.hackType]
    QBCore.Functions.Notify(Locale["hacking_failed"], 'error')
    
    Wait(settings.lockoutTime)
    hackingActive = false
    cb('ok')
end)

-- NUIコールバック: ハッキングキャンセル
RegisterNUICallback('closeHack', function(data, cb)
    SetNuiFocus(false, false)
    hackingActive = false
    cb('ok')
end)

if Config.Debug then
    print("[CayoPerico] Hacking script loaded")
end
