Config = {}

-- 基本設定
Config.MinPlayers = 4 -- 最小プレイヤー数
Config.MaxPlayers = 6 -- 最大プレイヤー数
Config.MinCops = 4 -- 必要な警察官数
Config.Cooldown = 3600000 -- クールダウン時間（60分 = 3600000ミリ秒）

-- 島のメイン位置
Config.IslandLocation = vector3(4840.0, -5210.0, 2.0)

-- 準備エリア（ロスサントス）
Config.PreparationZone = {
    coords = vector3(1273.0, -1720.77, 54.77), -- マイルハイクラブ付近
    radius = 3.0,
    label = "カヨ・ペリコ強盗を開始"
}

-- 侵入ルート
Config.EntryRoutes = {
    maingate = {
        name = "メインゲート",
        description = "正面突破 - 高難易度",
        coords = vector3(4974.0, -5166.0, 2.5),
        difficulty = "hard",
        spawnPoint = vector3(4974.0, -5166.0, 2.5),
        icon = "fa-solid fa-door-open"
    },
    drainage = {
        name = "排水トンネル",
        description = "ステルスルート - 推奨",
        coords = vector3(5044.0, -5815.0, -10.0),
        difficulty = "medium",
        spawnPoint = vector3(5044.0, -5815.0, -10.0),
        icon = "fa-solid fa-water"
    },
    airfield = {
        name = "エアフィールド",
        description = "ヘリコプター降下",
        coords = vector3(4503.0, -4526.0, 4.0),
        difficulty = "medium",
        spawnPoint = vector3(4503.0, -4526.0, 4.0),
        icon = "fa-solid fa-helicopter"
    },
    beach = {
        name = "ビーチ",
        description = "ボート上陸 - 容易",
        coords = vector3(5010.0, -5750.0, 15.0),
        difficulty = "easy",
        spawnPoint = vector3(5010.0, -5750.0, 15.0),
        icon = "fa-solid fa-ship"
    }
}

-- セキュリティポイント
Config.SecurityPoints = {
    camera_room = {
        coords = vector3(5006.0, -5756.0, 15.0),
        hackType = "security",
        label = "セキュリティルーム",
        requiredItem = "hacking_device"
    },
    main_door = {
        coords = vector3(4999.0, -5745.0, 14.0),
        hackType = "door",
        label = "セキュリティドア",
        requiredItem = "keycard"
    },
    vault_door = {
        coords = vector3(5006.5, -5756.0, 15.0),
        hackType = "vault",
        label = "金庫室",
        requiredItem = "hacking_device"
    }
}

-- 金庫位置
Config.VaultLocations = {
    main_vault = {
        coords = vector3(5006.5, -5755.5, 15.0),
        requiredItem = "drill",
        label = "メイン金庫"
    }
}

-- 脱出ポイント
Config.EscapePoints = {
    {
        coords = vector3(4771.0, -6165.0, 0.0),
        label = "ボート脱出",
        type = "boat"
    },
    {
        coords = vector3(4503.0, -4526.0, 4.0),
        label = "ヘリコプター脱出",
        type = "helicopter"
    }
}

-- 必要アイテム
Config.RequiredItems = {
    'hacking_device',
    'thermite',
    'drill',
    'keycard'
}

-- オプションアイテム
Config.OptionalItems = {
    'bolt_cutters',
    'suppressor',
    'armor'
}

-- メインターゲット（ランダム生成）
Config.MainTargets = {
    {
        name = "pink_diamond",
        label = "ピンクダイヤモンド",
        minReward = 2000000,
        maxReward = 2500000,
        chance = 10, -- 10%の確率
        model = "h4_prop_h4_diamond_01a"
    },
    {
        name = "panther_statue",
        label = "黒豹の像",
        minReward = 1800000,
        maxReward = 2200000,
        chance = 15, -- 15%の確率
        model = "h4_prop_h4_panther_statue_01a"
    },
    {
        name = "bonds",
        label = "債券",
        minReward = 1500000,
        maxReward = 1800000,
        chance = 35, -- 35%の確率
        model = "h4_prop_h4_bonds_01a"
    },
    {
        name = "drugs",
        label = "麻薬",
        minReward = 1200000,
        maxReward = 1500000,
        chance = 40, -- 40%の確率
        model = "prop_meth_bag_01"
    }
}

-- 副次ターゲット
Config.SecondaryTargets = {
    gold = {
        name = "gold_bar",
        label = "金の延べ棒",
        minReward = 200000,
        maxReward = 300000,
        stackSize = 1,
        locations = {
            vector3(5003.0, -5755.0, 15.0),
            vector3(5009.0, -5755.0, 15.0)
        }
    },
    painting = {
        name = "painting",
        label = "絵画",
        minReward = 150000,
        maxReward = 250000,
        stackSize = 1,
        locations = {
            vector3(5005.0, -5753.0, 15.0),
            vector3(5007.0, -5753.0, 15.0),
            vector3(5010.0, -5754.0, 15.0)
        }
    },
    cocaine = {
        name = "cocaine_brick",
        label = "コカイン",
        minReward = 100000,
        maxReward = 150000,
        stackSize = 2,
        locations = {
            vector3(5002.0, -5752.0, 15.0),
            vector3(5008.0, -5752.0, 15.0)
        }
    },
    cash = {
        name = "cash_stack",
        label = "現金",
        minReward = 50000,
        maxReward = 100000,
        stackSize = 3,
        locations = {
            vector3(5004.0, -5758.0, 15.0),
            vector3(5006.0, -5758.0, 15.0),
            vector3(5008.0, -5758.0, 15.0)
        }
    }
}

-- ガード配置
Config.GuardSpawns = {
    -- メインゲート周辺
    { coords = vector3(4972.0, -5165.0, 2.5), heading = 180.0, weapon = "WEAPON_ASSAULTRIFLE" },
    { coords = vector3(4976.0, -5165.0, 2.5), heading = 180.0, weapon = "WEAPON_ASSAULTRIFLE" },
    
    -- コンパウンド内
    { coords = vector3(5001.0, -5750.0, 19.0), heading = 90.0, weapon = "WEAPON_CARBINERIFLE" },
    { coords = vector3(5010.0, -5750.0, 19.0), heading = 270.0, weapon = "WEAPON_CARBINERIFLE" },
    { coords = vector3(5006.0, -5760.0, 15.0), heading = 0.0, weapon = "WEAPON_CARBINERIFLE" },
    { coords = vector3(5000.0, -5755.0, 15.0), heading = 90.0, weapon = "WEAPON_SMG" },
    { coords = vector3(5012.0, -5755.0, 15.0), heading = 270.0, weapon = "WEAPON_SMG" },
    
    -- エアフィールド
    { coords = vector3(4500.0, -4525.0, 4.0), heading = 180.0, weapon = "WEAPON_CARBINERIFLE" },
    { coords = vector3(4505.0, -4525.0, 4.0), heading = 180.0, weapon = "WEAPON_CARBINERIFLE" },
    
    -- ビーチ
    { coords = vector3(5008.0, -5752.0, 15.0), heading = 0.0, weapon = "WEAPON_SMG" },
    { coords = vector3(5012.0, -5748.0, 15.0), heading = 180.0, weapon = "WEAPON_SMG" },
    
    -- パトロール
    { coords = vector3(5005.0, -5758.0, 15.0), heading = 90.0, weapon = "WEAPON_PISTOL", patrol = true },
    { coords = vector3(5007.0, -5752.0, 15.0), heading = 270.0, weapon = "WEAPON_PISTOL", patrol = true },
    { coords = vector3(4995.0, -5755.0, 15.0), heading = 0.0, weapon = "WEAPON_PISTOL", patrol = true },
    { coords = vector3(5015.0, -5755.0, 15.0), heading = 180.0, weapon = "WEAPON_PISTOL", patrol = true }
}

-- パトロールルート
Config.PatrolRoutes = {
    {
        name = "compound_patrol_1",
        points = {
            vector3(5000.0, -5750.0, 15.0),
            vector3(5005.0, -5750.0, 15.0),
            vector3(5005.0, -5760.0, 15.0),
            vector3(5000.0, -5760.0, 15.0)
        },
        waitTime = 5000 -- 各ポイントで5秒待機
    },
    {
        name = "compound_patrol_2",
        points = {
            vector3(5010.0, -5750.0, 15.0),
            vector3(5010.0, -5755.0, 15.0),
            vector3(5015.0, -5755.0, 15.0),
            vector3(5015.0, -5750.0, 15.0)
        },
        waitTime = 5000
    }
}

-- ハッキング設定
Config.HackSettings = {
    security = {
        difficulty = "easy",
        time = 30, -- 30秒
        lockoutTime = 60000, -- 失敗時1分ロックアウト
        attempts = 3
    },
    door = {
        difficulty = "medium",
        time = 45, -- 45秒
        lockoutTime = 30000, -- 失敗時30秒ロックアウト
        attempts = 2
    },
    vault = {
        difficulty = "hard",
        time = 90, -- 90秒
        lockoutTime = 120000, -- 失敗時2分ロックアウト
        attempts = 1,
        penalty = 30 -- 失敗時の追加ペナルティ時間（秒）
    }
}

-- 警察設定
Config.PoliceJobs = {
    'police',
    'sheriff',
    'state'
}

Config.DispatchCode = "10-90" -- 強盗進行中コード
Config.DispatchMessage = "カヨ・ペリコ島で武装強盗が進行中"

-- 報酬分配設定
Config.DefaultSplit = {
    leader = 40, -- リーダー 40%
    member = 20  -- メンバー各20%（3人なら60%、計100%）
}

-- デバッグモード
Config.Debug = false
