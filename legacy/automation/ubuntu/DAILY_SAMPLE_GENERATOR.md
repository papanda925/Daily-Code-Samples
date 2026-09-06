# 14:00 Daily Code generator v2

旧ROADMAPを順番に消化する方式は停止します。

新方式では `Blog-Ideas/ideas` を入力にします。

## 選定

- `daily_code_required: true`
- `daily_code_status: none` または `planned`
- 既存 `samples-v2/` と重複しない
- 実用性がある
- 安全に検証できる

カテゴリは固定しません。

## 出力

`Daily-Code-Samples/samples-v2/<stable-slug>/`

最低限:

- `README.md`
- 実コード/Tips
- 元idea ID/パス
- verification status

## 品質

実行していないものを `tested` / `verified` / `copy_paste_ready` と扱いません。
失敗した場合は公開用状態へ進めません。

## 14:00

Ubuntu側の14:00スケジュールは残し、処理内容だけこのv2方式へ差し替えます。
