# QB-CayoPerico - カヨ・ペリコ強盗スクリプト

FiveM用のQB-Coreベースのカヨ・ペリコ大型強盗スクリプト

## 📥 ダウンロード方法

### 方法1: Gitを使用（推奨）

```bash
# FiveM サーバーのリソースフォルダに移動
cd /path/to/your/fivem/server/resources/[qb]

# リポジトリをクローン
git clone https://github.com/Torakinn/- qb-cayoperico-download
cd qb-cayoperico-download

# qb-cayoperico フォルダをコピー
cp -r qb-cayoperico ../qb-cayoperico
cd ..
rm -rf qb-cayoperico-download
```

### 方法2: ZIPファイルでダウンロード

1. GitHubページの **[Code]** ボタンをクリック
2. **[Download ZIP]** を選択
3. ZIPファイルを解凍
4. `qb-cayoperico` フォルダを `resources/[qb]/` にコピー

### 方法3: GitHub Desktop使用

1. [GitHub Desktop](https://desktop.github.com/)をインストール
2. **File** → **Clone Repository**
3. URL: `https://github.com/Torakinn/-`
4. クローン後、`qb-cayoperico` フォルダをサーバーにコピー

## 🚀 クイックスタート

1. **ダウンロード後**:
   ```bash
   cd resources/[qb]/qb-cayoperico
   ```

2. **アイテムを追加** (詳細は qb-cayoperico/README.md を参照)

3. **server.cfg に追加**:
   ```cfg
   ensure qb-cayoperico
   ```

4. **サーバーを再起動**

## 📚 完全なドキュメント

詳細なインストール手順とカスタマイズガイド:
- [完全なREADME](qb-cayoperico/README.md)
- [インストールチェックリスト](qb-cayoperico/INSTALLATION_CHECKLIST.md)
- [設定例](qb-cayoperico/CONFIG_EXAMPLES.md)
- [実装詳細](qb-cayoperico/IMPLEMENTATION.md)

## 💡 サポート

問題がある場合は [Issues](https://github.com/Torakinn/-/issues) で報告してください。

---

**バージョン**: 1.0.0  
**ライセンス**: MIT
