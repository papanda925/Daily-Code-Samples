# Blog-Ideas -> Daily-Code-Samples

## 正本

- ネタ: `papanda925/Blog-Ideas/ideas`
- コード/Tips: `papanda925/Daily-Code-Samples/samples-v2`
- 公開原稿: `papanda925/Blog-Ideas/publish`

## 14:00処理

1. Blog-Ideasを取得
2. `daily_code_required: true` を探す
3. `daily_code_status` が `none` または `planned` の候補から1件選ぶ
4. 既存サンプルとの重複を確認
5. `samples-v2/` に実装
6. テスト可能なら実行
7. 実行結果を記録
8. Blog-Ideas側へ sample path / status を戻す

トピックは14:00スロットへ固定しません。

## 禁止

- ROADMAPを埋めるためだけにサンプルを作る
- 似たサンプルを番号違いで量産する
- 未実行なのにtested/verifiedへする
- ブログ本文へ完全版コードを重複掲載する
