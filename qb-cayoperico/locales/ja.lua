Locale = {}

Locale.ja = {
    -- 一般メッセージ
    ["heist_start"] = "カヨ・ペリコ強盗を開始しますか？",
    ["heist_started"] = "強盗が開始されました",
    ["heist_cancelled"] = "強盗がキャンセルされました",
    ["heist_completed"] = "強盗が完了しました！",
    ["heist_failed"] = "強盗が失敗しました",
    
    -- プレイヤー要件
    ["not_enough_players"] = "プレイヤーが不足しています（最小: %s人）",
    ["too_many_players"] = "プレイヤーが多すぎます（最大: %s人）",
    ["not_enough_cops"] = "警察官が不足しています（最小: %s人）",
    ["heist_cooldown"] = "強盗はクールダウン中です。残り時間: %s分",
    
    -- フェーズ
    ["phase_preparation"] = "フェーズ1: 準備",
    ["phase_infiltration"] = "フェーズ2: 侵入",
    ["phase_security"] = "フェーズ3: セキュリティ突破",
    ["phase_vault"] = "フェーズ4: 金庫室",
    ["phase_escape"] = "フェーズ5: 脱出",
    
    -- 侵入ルート
    ["select_route"] = "侵入ルートを選択してください",
    ["route_selected"] = "ルート選択: %s",
    ["maingate_route"] = "メインゲート - 正面突破（高難易度）",
    ["drainage_route"] = "排水トンネル - ステルス（推奨）",
    ["airfield_route"] = "エアフィールド - ヘリコプター降下",
    ["beach_route"] = "ビーチ - ボート上陸（容易）",
    
    -- アイテム
    ["missing_item"] = "必要なアイテムが不足しています: %s",
    ["item_used"] = "%sを使用しました",
    ["hacking_device"] = "ハッキングデバイス",
    ["thermite"] = "サーマイト",
    ["drill"] = "ドリル",
    ["keycard"] = "キーカード",
    ["bolt_cutters"] = "ボルトカッター",
    
    -- ハッキング
    ["hacking_start"] = "ハッキングを開始します",
    ["hacking_success"] = "ハッキング成功！",
    ["hacking_failed"] = "ハッキング失敗",
    ["hacking_lockout"] = "システムがロックされました。待機時間: %s秒",
    ["hacking_timeout"] = "タイムアウト！",
    ["camera_disabled"] = "カメラが無効化されました",
    ["door_unlocked"] = "ドアのロックが解除されました",
    ["vault_opened"] = "金庫室が開きました",
    
    -- セキュリティ
    ["guard_alerted"] = "ガードに発見されました！",
    ["alarm_triggered"] = "警報が発動しました！",
    ["stealth_bonus"] = "ステルスボーナス: +%s$",
    ["reinforcements_called"] = "増援が呼ばれました",
    
    -- 金庫室
    ["drilling_vault"] = "金庫をドリルで開けています...",
    ["vault_drill_success"] = "金庫が開きました！",
    ["collecting_loot"] = "戦利品を回収中...",
    ["loot_collected"] = "%sを回収しました",
    ["inventory_full"] = "インベントリがいっぱいです",
    
    -- ターゲット
    ["main_target"] = "メインターゲット: %s",
    ["secondary_target"] = "副次ターゲット: %s",
    ["pink_diamond"] = "ピンクダイヤモンド",
    ["panther_statue"] = "黒豹の像",
    ["bonds"] = "債券",
    ["drugs"] = "麻薬",
    ["gold_bar"] = "金の延べ棒",
    ["painting"] = "絵画",
    ["cocaine_brick"] = "コカイン",
    ["cash_stack"] = "現金",
    
    -- 警察
    ["police_notified"] = "警察に通報されました！",
    ["dispatch_alert"] = "カヨ・ペリコ島で武装強盗が進行中",
    
    -- 脱出
    ["reach_escape"] = "脱出ポイントに向かってください",
    ["escape_point"] = "脱出ポイント",
    ["escaped"] = "脱出成功！",
    ["escape_failed"] = "脱出失敗",
    
    -- 報酬
    ["reward_total"] = "合計報酬: $%s",
    ["reward_split"] = "あなたの取り分: $%s",
    ["money_received"] = "$%sを受け取りました",
    ["distributing_rewards"] = "報酬を分配中...",
    
    -- チーム
    ["team_joined"] = "%sがチームに参加しました",
    ["team_left"] = "%sがチームから離脱しました",
    ["team_ready"] = "チームの準備完了",
    ["waiting_for_team"] = "チームメンバーを待機中...",
    
    -- 進行状況
    ["progress_hacking"] = "ハッキング中...",
    ["progress_drilling"] = "ドリル中...",
    ["progress_collecting"] = "回収中...",
    ["progress_escaping"] = "脱出中...",
    ["progress_preparing"] = "準備中...",
    
    -- エラー
    ["error_generic"] = "エラーが発生しました",
    ["error_already_active"] = "強盗が既に進行中です",
    ["error_not_leader"] = "チームリーダーのみがこの操作を実行できます",
    ["error_too_far"] = "対象から遠すぎます",
    
    -- UI
    ["press_to_interact"] = "[E] 相互作用",
    ["press_to_hack"] = "[E] ハッキング",
    ["press_to_drill"] = "[E] ドリル使用",
    ["press_to_collect"] = "[E] 回収",
    ["press_to_escape"] = "[E] 脱出",
    
    -- メニュー
    ["menu_start_heist"] = "強盗を開始",
    ["menu_select_route"] = "ルート選択",
    ["menu_team_management"] = "チーム管理",
    ["menu_split_settings"] = "報酬分配設定",
    ["menu_cancel"] = "キャンセル",
    
    -- 通知
    ["notify_success"] = "成功",
    ["notify_error"] = "エラー",
    ["notify_info"] = "情報",
    ["notify_warning"] = "警告"
}

return Locale.ja
