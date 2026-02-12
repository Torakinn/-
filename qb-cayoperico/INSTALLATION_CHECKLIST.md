# インストール確認チェックリスト

このチェックリストを使用して、qb-cayoperico が正しくインストールされているか確認してください。

## 📋 インストール前の確認

### 必須依存関係
- [ ] QBCore Framework がインストールされている
- [ ] ox_lib がインストールされている
- [ ] ox_inventory がインストールされている
- [ ] ox_target がインストールされている
- [ ] PolyZone がインストールされている
- [ ] oxmysql がインストールされている

### サーバー要件
- [ ] FiveM Server (最新版推奨)
- [ ] MySQL データベース

## 📁 ファイル配置確認

### リソースディレクトリ
- [ ] `resources/[qb]/qb-cayoperico/` にリソースが配置されている

### ファイル構造確認
```bash
cd resources/[qb]/qb-cayoperico/
ls -la
```

以下のファイル/ディレクトリが存在するか確認：
- [ ] `fxmanifest.lua`
- [ ] `config.lua`
- [ ] `server/` ディレクトリ
- [ ] `client/` ディレクトリ
- [ ] `html/` ディレクトリ
- [ ] `locales/` ディレクトリ
- [ ] `README.md`

## ⚙️ 設定確認

### server.cfg
```cfg
ensure qb-core
ensure ox_lib
ensure ox_inventory
ensure ox_target
ensure PolyZone
ensure oxmysql
ensure qb-cayoperico
```

- [ ] `server.cfg` に上記の記述が追加されている
- [ ] `qb-cayoperico` が他の依存リソースの後に記載されている

### ox_inventory アイテム追加

`ox_inventory/data/items.lua` に以下が追加されているか確認：

- [ ] `hacking_device` アイテム
- [ ] `thermite` アイテム
- [ ] `drill` アイテム
- [ ] `keycard` アイテム
- [ ] `bolt_cutters` アイテム

コード例（README.md 参照）が正しく追加されているか確認してください。

## 🚀 起動確認

### サーバー起動
1. [ ] サーバーを起動
2. [ ] F8 コンソールを開く
3. [ ] エラーメッセージがないか確認

### リソース読み込み確認
F8 コンソールで以下を実行：
```
ensure qb-cayoperico
```

表示されるメッセージ：
- [ ] `Started qb-cayoperico` が表示される
- [ ] エラーメッセージがない

### デバッグログ確認
`config.lua` で `Config.Debug = true` に設定し、サーバーログを確認：

以下のメッセージが表示されるべき：
- [ ] `[CayoPerico] Server script loaded`
- [ ] `[CayoPerico] Callbacks loaded`
- [ ] `[CayoPerico] Client main script loaded`
- [ ] `[CayoPerico] Hacking script loaded`
- [ ] `[CayoPerico] Zones script loaded`
- [ ] `[CayoPerico] Guards script loaded`

## 🎮 ゲーム内テスト

### 準備エリアの確認
座標 `1273.0, -1720.77, 54.77` に移動：
- [ ] ox_target のインタラクションポイントが表示される
- [ ] 「カヨ・ペリコ強盗を開始」のラベルが表示される

### アイテムテスト
テスト用にアイテムを与える：
```
/giveitem [player_id] hacking_device 1
/giveitem [player_id] thermite 1
/giveitem [player_id] drill 1
/giveitem [player_id] keycard 1
/giveitem [player_id] bolt_cutters 1
```

- [ ] すべてのアイテムが正常にインベントリに追加される
- [ ] アイテムの説明が日本語で表示される

### 強盗開始テスト（デバッグモード）

デバッグ設定：
```lua
-- config.lua
Config.MinPlayers = 1
Config.MaxPlayers = 1
Config.MinCops = 0
Config.Debug = true
```

- [ ] 準備エリアでインタラクトできる
- [ ] メニューが日本語で表示される
- [ ] ルート選択メニューが表示される
- [ ] ルートを選択すると島にテレポートされる

### ハッキングテスト
セキュリティポイントに移動：
- [ ] ox_target のインタラクションが表示される
- [ ] ハッキングミニゲームが起動する
- [ ] HTML UIが正しく表示される

### ガードスポーンテスト
島に移動後：
- [ ] ガードNPCがスポーンしている
- [ ] ガードが巡回している
- [ ] プレイヤーに近づくと反応する

## 🔧 トラブルシューティング

### よくある問題

#### リソースが起動しない
- [ ] すべての依存関係が起動しているか確認
- [ ] `fxmanifest.lua` に構文エラーがないか確認
- [ ] サーバーログでエラーを確認

#### ox_target が動作しない
- [ ] ox_target が正しくインストールされているか確認
- [ ] ox_lib が最新版か確認

#### ハッキングUIが表示されない
- [ ] `html/` ディレクトリのファイルが存在するか確認
- [ ] F8 コンソールでJavaScriptエラーを確認
- [ ] `ui_page` の設定が `fxmanifest.lua` にあるか確認

#### アイテムが表示されない
- [ ] ox_inventory の `items.lua` にアイテムが追加されているか確認
- [ ] サーバーを完全に再起動したか確認

#### ガードがスポーンしない
- [ ] サーバーのAI制限設定を確認
- [ ] `Config.Debug = true` でログを確認
- [ ] 島の座標に正しく移動しているか確認

## 📊 パフォーマンステスト

### サーバーパフォーマンス
- [ ] サーバーのFPSが安定している（50+推奨）
- [ ] メモリ使用量が異常に増加していない
- [ ] プレイヤー数が多い場合でも安定している

### クライアントパフォーマンス
- [ ] クライアントのFPSが安定している
- [ ] ラグやフリーズがない
- [ ] UI操作がスムーズ

## ✅ 本番環境デプロイ前の最終チェック

### 設定の調整
- [ ] `Config.MinPlayers` を適切な値に設定（推奨: 4）
- [ ] `Config.MinCops` を適切な値に設定（推奨: 4）
- [ ] `Config.Debug` を `false` に設定
- [ ] 報酬額が適切か確認
- [ ] クールダウン時間が適切か確認

### ドキュメントの確認
- [ ] README.md を読んで理解している
- [ ] CONFIG_EXAMPLES.md で設定例を確認している
- [ ] トラブルシューティングガイドを確認している

### バックアップ
- [ ] 設定ファイルのバックアップを取っている
- [ ] サーバーデータのバックアップを取っている

### プレイヤー通知
- [ ] プレイヤーに新機能を通知している
- [ ] 使用方法を説明している
- [ ] ルールや制限を明確にしている

## 🎯 すべて完了！

すべてのチェックボックスにチェックが入れば、qb-cayoperico は正常にインストールされ、本番環境で使用可能です。

---

**問題がある場合**
1. このチェックリストを再度確認
2. README.md のトラブルシューティングを参照
3. サーバーログとクライアントコンソールでエラーを確認
4. GitHub Issues で報告

**サポート**: https://github.com/Torakinn/-/issues
