# ダウンロード＆インストールガイド / Download & Installation Guide

## 🇯🇵 日本語版

### ダウンロード方法

このFiveM Cayo Perico強盗スクリプトをダウンロードするには、以下の3つの方法があります。

---

#### 📦 方法1: Git でクローン（推奨）

Gitがインストールされている場合、この方法が最も簡単です。

```bash
# ステップ 1: サーバーのリソースフォルダに移動
cd /path/to/your/fivem/server/resources/[qb]

# ステップ 2: リポジトリをクローン
git clone https://github.com/Torakinn/- cayoperico-temp

# ステップ 3: 必要なフォルダをコピー
cd cayoperico-temp
cp -r qb-cayoperico ../
cd ..

# ステップ 4: 一時フォルダを削除
rm -rf cayoperico-temp

# 完了！qb-cayoperico フォルダが作成されました
```

**Windowsの場合**:
```cmd
cd C:\YourFiveMServer\resources\[qb]
git clone https://github.com/Torakinn/- cayoperico-temp
xcopy cayoperico-temp\qb-cayoperico qb-cayoperico /E /I /H
rmdir /S /Q cayoperico-temp
```

---

#### 💾 方法2: ZIPファイルでダウンロード

Gitを使わない場合は、この方法を使用してください。

1. **GitHubページにアクセス**
   - URL: https://github.com/Torakinn/-

2. **ZIPファイルをダウンロード**
   - 緑色の **[Code]** ボタンをクリック
   - **[Download ZIP]** を選択
   - ファイルが `-.zip` としてダウンロードされます

3. **ZIPファイルを解凍**
   - ダウンロードした `-.zip` を右クリック
   - **[すべて展開]** または **[Extract All]** を選択
   - 任意の場所に解凍

4. **qb-cayoperico フォルダをコピー**
   - 解凍したフォルダ内の `qb-cayoperico` フォルダを見つける
   - このフォルダをコピー
   - FiveMサーバーの `resources/[qb]/` フォルダに貼り付け

5. **確認**
   - 最終的なパス: `resources/[qb]/qb-cayoperico/fxmanifest.lua`

---

#### 🖥️ 方法3: GitHub Desktop を使用

デスクトップアプリを使いたい場合の方法です。

1. **GitHub Desktop をインストール**
   - https://desktop.github.com/ からダウンロード
   - インストール後、起動

2. **リポジトリをクローン**
   - **File** メニュー → **Clone Repository**
   - **URL** タブを選択
   - URL欄に入力: `https://github.com/Torakinn/-`
   - ローカルパスを選択して **Clone**

3. **フォルダをコピー**
   - クローンしたフォルダ内の `qb-cayoperico` を探す
   - FiveMサーバーの `resources/[qb]/` にコピー

---

### インストール手順

ダウンロード後、以下の手順でインストールします。

#### ステップ 1: ファイルの配置確認

```
あなたのFiveMサーバー/
└── resources/
    └── [qb]/
        └── qb-cayoperico/
            ├── fxmanifest.lua
            ├── config.lua
            ├── server/
            ├── client/
            ├── html/
            └── locales/
```

#### ステップ 2: アイテムの追加

`ox_inventory/data/items.lua` に以下を追加:

```lua
['hacking_device'] = {
    label = 'ハッキングデバイス',
    weight = 500,
    stack = true,
    close = true,
    description = 'セキュリティシステムをハックするためのデバイス'
},
['thermite'] = {
    label = 'サーマイト',
    weight = 1000,
    stack = true,
    close = true,
    description = 'ドアを破壊するための爆薬'
},
['drill'] = {
    label = 'ドリル',
    weight = 3000,
    stack = false,
    close = true,
    description = '金庫を開けるための電動ドリル'
},
['keycard'] = {
    label = 'セキュリティキーカード',
    weight = 50,
    stack = true,
    close = true,
    description = 'セキュリティドアを開けるためのキーカード'
},
['bolt_cutters'] = {
    label = 'ボルトカッター',
    weight = 2000,
    stack = false,
    close = true,
    description = 'フェンスや鎖を切断するための工具'
},
```

#### ステップ 3: server.cfg の編集

`server.cfg` に以下を追加:

```cfg
# 依存関係
ensure qb-core
ensure ox_lib
ensure ox_inventory
ensure ox_target
ensure PolyZone
ensure oxmysql

# Cayo Perico スクリプト
ensure qb-cayoperico
```

#### ステップ 4: サーバーの再起動

サーバーを完全に再起動します。

```bash
# Linuxの場合
./run.sh

# Windowsの場合
run.cmd
```

#### ステップ 5: 動作確認

1. サーバーに接続
2. 座標 `1273.0, -1720.77, 54.77` に移動
3. ox_target のインタラクションポイントが表示されるか確認

---

### トラブルシューティング

#### リソースが起動しない

**確認項目**:
- すべての依存関係がインストールされているか
- `fxmanifest.lua` が存在するか
- サーバーログでエラーを確認

**解決方法**:
```bash
# サーバーコンソールで
ensure qb-cayoperico
```

#### ox_target が動作しない

**確認項目**:
- ox_target が正しくインストールされているか
- ox_lib が最新版か

**解決方法**:
```bash
# 依存関係を再起動
restart ox_lib
restart ox_target
restart qb-cayoperico
```

#### アイテムが表示されない

**確認項目**:
- `ox_inventory/data/items.lua` にアイテムを追加したか
- サーバーを完全に再起動したか

**解決方法**:
- サーバーを完全に停止して再起動
- `items.lua` の構文エラーを確認

---

### さらに詳しい情報

- **完全なREADME**: [qb-cayoperico/README.md](qb-cayoperico/README.md)
- **インストールチェックリスト**: [INSTALLATION_CHECKLIST.md](qb-cayoperico/INSTALLATION_CHECKLIST.md)
- **設定のカスタマイズ**: [CONFIG_EXAMPLES.md](qb-cayoperico/CONFIG_EXAMPLES.md)
- **技術仕様**: [IMPLEMENTATION.md](qb-cayoperico/IMPLEMENTATION.md)

---

## 🇬🇧 English Version

### Download Methods

There are 3 ways to download this FiveM Cayo Perico heist script.

---

#### 📦 Method 1: Clone with Git (Recommended)

If you have Git installed, this is the easiest method.

```bash
# Step 1: Navigate to your FiveM server resources folder
cd /path/to/your/fivem/server/resources/[qb]

# Step 2: Clone the repository
git clone https://github.com/Torakinn/- cayoperico-temp

# Step 3: Copy the required folder
cd cayoperico-temp
cp -r qb-cayoperico ../
cd ..

# Step 4: Remove temporary folder
rm -rf cayoperico-temp

# Done! qb-cayoperico folder has been created
```

**For Windows**:
```cmd
cd C:\YourFiveMServer\resources\[qb]
git clone https://github.com/Torakinn/- cayoperico-temp
xcopy cayoperico-temp\qb-cayoperico qb-cayoperico /E /I /H
rmdir /S /Q cayoperico-temp
```

---

#### 💾 Method 2: Download ZIP File

If you don't want to use Git, use this method.

1. **Visit GitHub Page**
   - URL: https://github.com/Torakinn/-

2. **Download ZIP File**
   - Click the green **[Code]** button
   - Select **[Download ZIP]**
   - File will download as `-.zip`

3. **Extract ZIP File**
   - Right-click on downloaded `-.zip`
   - Select **[Extract All]**
   - Extract to any location

4. **Copy qb-cayoperico Folder**
   - Find `qb-cayoperico` folder in extracted files
   - Copy this folder
   - Paste into your FiveM server's `resources/[qb]/` folder

5. **Verify**
   - Final path should be: `resources/[qb]/qb-cayoperico/fxmanifest.lua`

---

#### 🖥️ Method 3: Use GitHub Desktop

For those who prefer a desktop application.

1. **Install GitHub Desktop**
   - Download from https://desktop.github.com/
   - Install and launch

2. **Clone Repository**
   - **File** menu → **Clone Repository**
   - Select **URL** tab
   - Enter URL: `https://github.com/Torakinn/-`
   - Choose local path and click **Clone**

3. **Copy Folder**
   - Find `qb-cayoperico` in cloned folder
   - Copy to your FiveM server's `resources/[qb]/`

---

### Installation Steps

After downloading, follow these steps to install.

#### Step 1: Verify File Placement

```
YourFiveMServer/
└── resources/
    └── [qb]/
        └── qb-cayoperico/
            ├── fxmanifest.lua
            ├── config.lua
            ├── server/
            ├── client/
            ├── html/
            └── locales/
```

#### Step 2: Add Items

Add to `ox_inventory/data/items.lua`:

```lua
['hacking_device'] = {
    label = 'Hacking Device',
    weight = 500,
    stack = true,
    close = true,
    description = 'Device for hacking security systems'
},
['thermite'] = {
    label = 'Thermite',
    weight = 1000,
    stack = true,
    close = true,
    description = 'Explosive for destroying doors'
},
['drill'] = {
    label = 'Drill',
    weight = 3000,
    stack = false,
    close = true,
    description = 'Electric drill for opening vaults'
},
['keycard'] = {
    label = 'Security Keycard',
    weight = 50,
    stack = true,
    close = true,
    description = 'Keycard for opening security doors'
},
['bolt_cutters'] = {
    label = 'Bolt Cutters',
    weight = 2000,
    stack = false,
    close = true,
    description = 'Tool for cutting fences and chains'
},
```

#### Step 3: Edit server.cfg

Add to `server.cfg`:

```cfg
# Dependencies
ensure qb-core
ensure ox_lib
ensure ox_inventory
ensure ox_target
ensure PolyZone
ensure oxmysql

# Cayo Perico Script
ensure qb-cayoperico
```

#### Step 4: Restart Server

Completely restart your server.

```bash
# Linux
./run.sh

# Windows
run.cmd
```

#### Step 5: Verify Operation

1. Connect to server
2. Go to coordinates `1273.0, -1720.77, 54.77`
3. Check if ox_target interaction point appears

---

### Support

For issues, please report at: https://github.com/Torakinn/-/issues

---

**Version**: 1.0.0  
**License**: MIT
