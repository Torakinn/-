local QBCore = exports['qb-core']:GetCoreObject()
local activeHeists = {}
local heistCooldowns = {}
local Locale = Locale.ja

-- ヘルパー関数: 警察官数を確認
local function GetOnlineCops()
    local cops = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, player in pairs(players) do
        for _, job in pairs(Config.PoliceJobs) do
            if player.PlayerData.job.name == job and player.PlayerData.job.onduty then
                cops = cops + 1
                break
            end
        end
    end
    return cops
end

-- ヘルパー関数: プレイヤーがアイテムを持っているか確認
local function HasRequiredItems(source)
    for _, item in pairs(Config.RequiredItems) do
        local hasItem = exports.ox_inventory:GetItem(source, item, nil, true)
        if not hasItem or hasItem < 1 then
            return false, item
        end
    end
    return true
end

-- ヘルパー関数: ランダムなメインターゲットを生成
local function GenerateMainTarget()
    local rand = math.random(1, 100)
    local cumulativeChance = 0
    
    for _, target in pairs(Config.MainTargets) do
        cumulativeChance = cumulativeChance + target.chance
        if rand <= cumulativeChance then
            local reward = math.random(target.minReward, target.maxReward)
            return {
                name = target.name,
                label = target.label,
                reward = reward,
                model = target.model
            }
        end
    end
    
    -- フォールバック
    local fallback = Config.MainTargets[#Config.MainTargets]
    return {
        name = fallback.name,
        label = fallback.label,
        reward = math.random(fallback.minReward, fallback.maxReward),
        model = fallback.model
    }
end

-- ヘルパー関数: クールダウンをチェック
local function IsOnCooldown(identifier)
    if heistCooldowns[identifier] then
        local timeLeft = heistCooldowns[identifier] - os.time()
        if timeLeft > 0 then
            return true, math.ceil(timeLeft / 60)
        else
            heistCooldowns[identifier] = nil
        end
    end
    return false, 0
end

-- ヘルパー関数: クールダウンを設定
local function SetCooldown(identifier)
    heistCooldowns[identifier] = os.time() + (Config.Cooldown / 1000)
end

-- 強盗開始
RegisterNetEvent('qb-cayoperico:server:startHeist', function(teamMembers)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local identifier = Player.PlayerData.citizenid
    
    -- クールダウンチェック
    local onCooldown, minutesLeft = IsOnCooldown(identifier)
    if onCooldown then
        TriggerClientEvent('QBCore:Notify', src, string.format(Locale["heist_cooldown"], minutesLeft), 'error')
        return
    end
    
    -- プレイヤー数チェック
    if #teamMembers < Config.MinPlayers then
        TriggerClientEvent('QBCore:Notify', src, string.format(Locale["not_enough_players"], Config.MinPlayers), 'error')
        return
    end
    
    if #teamMembers > Config.MaxPlayers then
        TriggerClientEvent('QBCore:Notify', src, string.format(Locale["too_many_players"], Config.MaxPlayers), 'error')
        return
    end
    
    -- 警察官数チェック
    local copCount = GetOnlineCops()
    if copCount < Config.MinCops then
        TriggerClientEvent('QBCore:Notify', src, string.format(Locale["not_enough_cops"], Config.MinCops), 'error')
        return
    end
    
    -- 必要アイテムチェック
    local hasItems, missingItem = HasRequiredItems(src)
    if not hasItems then
        TriggerClientEvent('QBCore:Notify', src, string.format(Locale["missing_item"], missingItem), 'error')
        return
    end
    
    -- メインターゲット生成
    local mainTarget = GenerateMainTarget()
    
    -- 強盗データを作成
    local heistData = {
        leader = src,
        members = teamMembers,
        mainTarget = mainTarget,
        phase = 1,
        startTime = os.time(),
        stealthBonus = true,
        collectedLoot = {},
        route = nil
    }
    
    activeHeists[src] = heistData
    
    -- クールダウン設定
    SetCooldown(identifier)
    
    -- チームメンバーに通知
    for _, memberId in pairs(teamMembers) do
        TriggerClientEvent('qb-cayoperico:client:heistStarted', memberId, heistData)
        TriggerClientEvent('QBCore:Notify', memberId, Locale["heist_started"], 'success')
    end
    
    if Config.Debug then
        print(string.format("[CayoPerico] Heist started by %s with %d members", GetPlayerName(src), #teamMembers))
    end
end)

-- ルート選択
RegisterNetEvent('qb-cayoperico:server:selectRoute', function(routeName)
    local src = source
    local heist = activeHeists[src]
    
    if not heist then return end
    if heist.leader ~= src then
        TriggerClientEvent('QBCore:Notify', src, Locale["error_not_leader"], 'error')
        return
    end
    
    heist.route = routeName
    heist.phase = 2
    
    for _, memberId in pairs(heist.members) do
        TriggerClientEvent('qb-cayoperico:client:routeSelected', memberId, routeName)
    end
end)

-- ハッキング成功
RegisterNetEvent('qb-cayoperico:server:hackSuccess', function(hackType)
    local src = source
    local heist = activeHeists[src]
    
    if not heist then return end
    
    -- アイテム消費
    if hackType == "security" then
        exports.ox_inventory:RemoveItem(src, 'hacking_device', 1)
    elseif hackType == "door" then
        exports.ox_inventory:RemoveItem(src, 'keycard', 1)
    elseif hackType == "vault" then
        heist.phase = 4
    end
    
    for _, memberId in pairs(heist.members) do
        TriggerClientEvent('qb-cayoperico:client:hackSuccess', memberId, hackType)
    end
end)

-- ハッキング失敗
RegisterNetEvent('qb-cayoperico:server:hackFailed', function(hackType)
    local src = source
    local heist = activeHeists[src]
    
    if not heist then return end
    
    -- 一定確率で警報発動
    if hackType == "door" or hackType == "vault" then
        if math.random(1, 100) <= 50 then
            heist.stealthBonus = false
            for _, memberId in pairs(heist.members) do
                TriggerClientEvent('qb-cayoperico:client:alarmTriggered', memberId)
            end
        end
    end
end)

-- 金庫ドリル
RegisterNetEvent('qb-cayoperico:server:drillVault', function()
    local src = source
    local heist = activeHeists[src]
    
    if not heist then return end
    
    -- ドリル消費
    exports.ox_inventory:RemoveItem(src, 'drill', 1)
    
    -- 警察に通報
    TriggerEvent('qb-cayoperico:server:notifyPolice', heist)
    
    -- メインターゲット報酬
    table.insert(heist.collectedLoot, heist.mainTarget)
    
    for _, memberId in pairs(heist.members) do
        TriggerClientEvent('qb-cayoperico:client:vaultOpened', memberId)
    end
end)

-- 副次ターゲット回収
RegisterNetEvent('qb-cayoperico:server:collectLoot', function(lootType)
    local src = source
    local heist = activeHeists[src]
    
    if not heist then return end
    
    local lootConfig = Config.SecondaryTargets[lootType]
    if not lootConfig then return end
    
    local reward = math.random(lootConfig.minReward, lootConfig.maxReward)
    
    table.insert(heist.collectedLoot, {
        name = lootConfig.name,
        label = lootConfig.label,
        reward = reward
    })
    
    TriggerClientEvent('QBCore:Notify', src, string.format(Locale["loot_collected"], lootConfig.label), 'success')
end)

-- 脱出完了
RegisterNetEvent('qb-cayoperico:server:escapeComplete', function()
    local src = source
    local heist = activeHeists[src]
    
    if not heist then return end
    if heist.leader ~= src then return end
    
    heist.phase = 5
    
    -- 報酬計算
    local totalReward = 0
    for _, loot in pairs(heist.collectedLoot) do
        totalReward = totalReward + loot.reward
    end
    
    -- ステルスボーナス
    if heist.stealthBonus then
        local bonus = math.floor(totalReward * 0.1)
        totalReward = totalReward + bonus
        for _, memberId in pairs(heist.members) do
            TriggerClientEvent('QBCore:Notify', memberId, string.format(Locale["stealth_bonus"], bonus), 'success')
        end
    end
    
    -- 報酬分配
    local memberCount = #heist.members
    local leaderShare = math.floor(totalReward * (Config.DefaultSplit.leader / 100))
    local memberShare = math.floor((totalReward - leaderShare) / (memberCount - 1))
    
    -- リーダーに報酬
    local Leader = QBCore.Functions.GetPlayer(src)
    if Leader then
        Leader.Functions.AddMoney('bank', leaderShare)
        TriggerClientEvent('QBCore:Notify', src, string.format(Locale["money_received"], leaderShare), 'success')
    end
    
    -- メンバーに報酬
    for _, memberId in pairs(heist.members) do
        if memberId ~= src then
            local Member = QBCore.Functions.GetPlayer(memberId)
            if Member then
                Member.Functions.AddMoney('bank', memberShare)
                TriggerClientEvent('QBCore:Notify', memberId, string.format(Locale["money_received"], memberShare), 'success')
            end
        end
    end
    
    -- 完了通知
    for _, memberId in pairs(heist.members) do
        TriggerClientEvent('qb-cayoperico:client:heistCompleted', memberId, totalReward)
    end
    
    -- クリーンアップ
    activeHeists[src] = nil
    
    if Config.Debug then
        print(string.format("[CayoPerico] Heist completed. Total reward: $%d", totalReward))
    end
end)

-- 強盗失敗
RegisterNetEvent('qb-cayoperico:server:heistFailed', function()
    local src = source
    local heist = activeHeists[src]
    
    if not heist then return end
    
    for _, memberId in pairs(heist.members) do
        TriggerClientEvent('qb-cayoperico:client:heistFailed', memberId)
        TriggerClientEvent('QBCore:Notify', memberId, Locale["heist_failed"], 'error')
    end
    
    activeHeists[src] = nil
end)

-- 警察通報
RegisterNetEvent('qb-cayoperico:server:notifyPolice', function(heist)
    local players = QBCore.Functions.GetQBPlayers()
    for _, player in pairs(players) do
        for _, job in pairs(Config.PoliceJobs) do
            if player.PlayerData.job.name == job and player.PlayerData.job.onduty then
                TriggerClientEvent('qb-cayoperico:client:policeAlert', player.PlayerData.source, Config.IslandLocation)
            end
        end
    end
end)

-- アクティブな強盗を取得
QBCore.Functions.CreateCallback('qb-cayoperico:server:getActiveHeist', function(source, cb)
    cb(activeHeists[source])
end)

-- 警察官数を取得
QBCore.Functions.CreateCallback('qb-cayoperico:server:getCopCount', function(source, cb)
    cb(GetOnlineCops())
end)

-- クールダウンをチェック
QBCore.Functions.CreateCallback('qb-cayoperico:server:checkCooldown', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then cb(true, 0) return end
    
    local identifier = Player.PlayerData.citizenid
    local onCooldown, minutesLeft = IsOnCooldown(identifier)
    cb(onCooldown, minutesLeft)
end)

if Config.Debug then
    print("[CayoPerico] Server script loaded")
end
