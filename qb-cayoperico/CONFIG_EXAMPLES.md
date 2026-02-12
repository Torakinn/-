# 設定テンプレート

このファイルは `config.lua` のカスタマイズ例を示します。

## 基本設定のカスタマイズ例

### 少人数サーバー向け設定
```lua
Config.MinPlayers = 2          -- 2人から開始可能
Config.MaxPlayers = 4          -- 最大4人
Config.MinCops = 2             -- 警察官2人で開始可能
Config.Cooldown = 1800000      -- 30分のクールダウン
```

### 大規模サーバー向け設定
```lua
Config.MinPlayers = 6          -- 6人から開始
Config.MaxPlayers = 10         -- 最大10人
Config.MinCops = 6             -- 警察官6人必要
Config.Cooldown = 7200000      -- 120分のクールダウン
```

### テスト環境向け設定
```lua
Config.MinPlayers = 1          -- 1人で開始可能
Config.MaxPlayers = 1          -- ソロプレイ
Config.MinCops = 0             -- 警察官不要
Config.Cooldown = 60000        -- 1分のクールダウン
Config.Debug = true            -- デバッグモード有効
```

## 報酬設定のカスタマイズ例

### 高額報酬設定
```lua
Config.MainTargets = {
    {
        name = "pink_diamond",
        label = "ピンクダイヤモンド",
        minReward = 5000000,      -- 500万
        maxReward = 7000000,      -- 700万
        chance = 10,
        model = "h4_prop_h4_diamond_01a"
    },
    -- 他のターゲットも同様に調整
}
```

### バランス型報酬設定（推奨）
```lua
Config.MainTargets = {
    {
        name = "pink_diamond",
        label = "ピンクダイヤモンド",
        minReward = 2000000,
        maxReward = 2500000,
        chance = 10,
        model = "h4_prop_h4_diamond_01a"
    },
    -- デフォルト設定を使用
}
```

### 低額報酬設定（初心者サーバー向け）
```lua
Config.MainTargets = {
    {
        name = "pink_diamond",
        label = "ピンクダイヤモンド",
        minReward = 500000,       -- 50万
        maxReward = 800000,       -- 80万
        chance = 10,
        model = "h4_prop_h4_diamond_01a"
    },
    -- 他のターゲットも同様に調整
}
```

## ハッキング難易度のカスタマイズ例

### 簡単設定
```lua
Config.HackSettings = {
    security = {
        difficulty = "easy",
        time = 60,              -- 60秒
        lockoutTime = 30000,    -- 30秒ロックアウト
        attempts = 5            -- 5回まで試行可能
    },
    door = {
        difficulty = "easy",
        time = 60,
        lockoutTime = 20000,
        attempts = 3
    },
    vault = {
        difficulty = "medium",
        time = 120,
        lockoutTime = 60000,
        attempts = 2,
        penalty = 15
    }
}
```

### 難しい設定
```lua
Config.HackSettings = {
    security = {
        difficulty = "hard",
        time = 20,              -- 20秒
        lockoutTime = 120000,   -- 2分ロックアウト
        attempts = 1            -- 1回のみ
    },
    door = {
        difficulty = "hard",
        time = 30,
        lockoutTime = 90000,
        attempts = 1
    },
    vault = {
        difficulty = "hard",
        time = 60,
        lockoutTime = 180000,
        attempts = 1,
        penalty = 60
    }
}
```

## ガード配置のカスタマイズ例

### ガード少なめ（簡単）
```lua
Config.GuardSpawns = {
    -- メインゲート周辺のみ
    { coords = vector3(4972.0, -5165.0, 2.5), heading = 180.0, weapon = "WEAPON_PISTOL" },
    { coords = vector3(4976.0, -5165.0, 2.5), heading = 180.0, weapon = "WEAPON_PISTOL" },
    
    -- コンパウンド内
    { coords = vector3(5001.0, -5750.0, 19.0), heading = 90.0, weapon = "WEAPON_PISTOL" },
    { coords = vector3(5010.0, -5750.0, 19.0), heading = 270.0, weapon = "WEAPON_PISTOL" },
}
```

### ガード多め（難しい）
```lua
-- デフォルトの15体に加えて、さらに追加
table.insert(Config.GuardSpawns, { coords = vector3(4980.0, -5160.0, 2.5), heading = 180.0, weapon = "WEAPON_ASSAULTRIFLE" })
table.insert(Config.GuardSpawns, { coords = vector3(5015.0, -5745.0, 15.0), heading = 0.0, weapon = "WEAPON_CARBINERIFLE" })
-- さらに追加可能
```

## 警察設定のカスタマイズ例

### 複数の警察組織対応
```lua
Config.PoliceJobs = {
    'police',
    'sheriff',
    'state',
    'fbi',          -- FBI追加
    'swat',         -- SWAT追加
    'ranger'        -- レンジャー追加
}
```

### 通報メッセージのカスタマイズ
```lua
Config.DispatchCode = "10-31"  -- 強盗進行中
Config.DispatchMessage = "カヨ・ペリコ島で大規模な武装強盗が進行中。至急応援を求む！"
```

## 報酬分配のカスタマイズ例

### 均等分配
```lua
Config.DefaultSplit = {
    leader = 25,    -- リーダー 25%
    member = 25     -- メンバー各25%（3人なら75%、計100%）
}
```

### リーダー重視
```lua
Config.DefaultSplit = {
    leader = 50,    -- リーダー 50%
    member = 16.67  -- メンバー各16.67%（3人なら50%、計100%）
}
```

### 完全均等
```lua
-- カスタムロジックが必要（server/main.lua を修正）
local sharePerPerson = math.floor(totalReward / memberCount)
```

## 場所のカスタマイズ例

### カスタム準備エリア
```lua
Config.PreparationZone = {
    coords = vector3(-1088.0, -2722.0, 13.16),  -- 空港近く
    radius = 3.0,
    label = "カヨ・ペリコ強盗を開始"
}
```

### カスタム脱出ポイント
```lua
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
    },
    {
        coords = vector3(4850.0, -5200.0, 2.0),  -- 追加の脱出ポイント
        label = "潜水艦脱出",
        type = "submarine"
    }
}
```

## 実装のヒント

1. **段階的な変更**: 一度に1つの設定を変更し、テストしてから次に進む
2. **バックアップ**: 変更前に必ず `config.lua` のバックアップを取る
3. **バランス**: 報酬額とリスク（ガード数、難易度）のバランスを考慮
4. **テスト環境**: 本番環境に適用する前に、必ずテスト環境で確認
5. **プレイヤーフィードバック**: サーバーのプレイヤーから意見を聞いて調整

## トラブルシューティング

### 報酬が高すぎる場合
- `Config.MainTargets` と `Config.SecondaryTargets` の金額を下げる
- ステルスボーナスを削除または減額

### 難易度が高すぎる場合
- ガード数を減らす
- ハッキング時間を延長
- 試行回数を増やす
- 警察官数要件を下げる

### パフォーマンス問題
- ガード数を減らす（10体以下を推奨）
- デバッグモードを無効化
- スポーン範囲を調整
