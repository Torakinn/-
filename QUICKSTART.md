# クイックスタートガイド / Quick Start Guide

## 🚀 3ステップで始める

### 📥 ステップ1: ダウンロード

#### 最も簡単な方法:

```bash
cd resources/[qb]
git clone https://github.com/Torakinn/- cayoperico-temp
cp -r cayoperico-temp/qb-cayoperico ./
rm -rf cayoperico-temp
```

#### または ZIPでダウンロード:

1. https://github.com/Torakinn/- にアクセス
2. 緑の **Code** ボタン → **Download ZIP**
3. 解凍して `qb-cayoperico` フォルダを `resources/[qb]/` にコピー

---

### ⚙️ ステップ2: 設定

#### A. アイテムを追加

`ox_inventory/data/items.lua` に追加:

```lua
['hacking_device'] = { label = 'ハッキングデバイス', weight = 500, stack = true, close = true },
['thermite'] = { label = 'サーマイト', weight = 1000, stack = true, close = true },
['drill'] = { label = 'ドリル', weight = 3000, stack = false, close = true },
['keycard'] = { label = 'セキュリティキーカード', weight = 50, stack = true, close = true },
['bolt_cutters'] = { label = 'ボルトカッター', weight = 2000, stack = false, close = true },
```

#### B. server.cfg に追加

```cfg
ensure qb-cayoperico
```

---

### 🎮 ステップ3: プレイ

1. **サーバー再起動**
2. **座標に移動**: `1273.0, -1720.77, 54.77`
3. **ox_target で開始**: 「カヨ・ペリコ強盗を開始」

---

## 📋 チェックリスト

- [ ] ダウンロード完了（git clone または ZIP）
- [ ] `qb-cayoperico` フォルダが `resources/[qb]/` にある
- [ ] 5つのアイテムを `ox_inventory/data/items.lua` に追加
- [ ] `server.cfg` に `ensure qb-cayoperico` を追加
- [ ] サーバーを再起動
- [ ] ゲーム内で座標に移動して確認

---

## 🆘 問題がある？

### よくある質問

**Q: リソースが起動しない**
```bash
# サーバーコンソールで
ensure qb-cayoperico
```

**Q: アイテムが表示されない**
- サーバーを完全に再起動してください

**Q: ox_target が動作しない**
- ox_lib と ox_target が最新版か確認

**Q: もっと詳しい情報が欲しい**
- [完全なダウンロードガイド](DOWNLOAD_GUIDE.md)
- [インストールチェックリスト](qb-cayoperico/INSTALLATION_CHECKLIST.md)
- [詳細README](qb-cayoperico/README.md)

---

## 💡 便利なリンク

- **完全ガイド**: [DOWNLOAD_GUIDE.md](DOWNLOAD_GUIDE.md)
- **詳細README**: [qb-cayoperico/README.md](qb-cayoperico/README.md)
- **設定例**: [CONFIG_EXAMPLES.md](qb-cayoperico/CONFIG_EXAMPLES.md)
- **トラブルシューティング**: [INSTALLATION_CHECKLIST.md](qb-cayoperico/INSTALLATION_CHECKLIST.md)
- **問題報告**: [GitHub Issues](https://github.com/Torakinn/-/issues)

---

## 🎯 次のステップ

インストール後:

1. **カスタマイズ**: `config.lua` で報酬やガード数を調整
2. **テスト**: デバッグモードで動作確認
3. **本番運用**: 設定を調整して公開

楽しんでください！🎉

---

**作成者**: Torakinn  
**バージョン**: 1.0.0  
**サポート**: https://github.com/Torakinn/-/issues
