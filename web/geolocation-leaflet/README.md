# Geolocation API + Leaflet 現在位置デモ

ブラウザ標準の **Geolocation API** で現在位置を取得し、
**Leaflet** を使って地図上へ表示する最小デモです。

## ライブデモ

GitHub Pages で公開する実行用HTMLは、公開専用ディレクトリへ移しました。

- 公開ソース: `docs/demos/geolocation-leaflet/index.html`
- 公開URL: `https://papanda925.github.io/Daily-Code-Samples/demos/geolocation-leaflet/`

## このデモで分かること

- 位置情報を取得するのは Leaflet ではなく `navigator.geolocation`
- ブラウザがユーザーへ位置情報の許可を求める流れ
- latitude / longitude / accuracy の意味
- 取得した座標を Leaflet の marker へ渡す流れ
- 許可拒否やタイムアウト時のエラー処理

## プライバシー

このサンプル自身は、取得した緯度・経度をサーバーへ送信・保存しません。
座標はこのページを開いているブラウザ内で、画面表示と地図マーカー表示にだけ使用します。

ただし地図表示には外部の地図タイルを取得するためネットワーク通信が発生します。
位置情報そのものをアプリ側から地図タイルURLへ埋め込む処理はしていません。

## 使い方

1. GitHub Pages のライブデモを HTTPS で開く
2. 「現在位置を取得」ボタンを押す
3. ブラウザ/OSの位置情報アクセスを許可または拒否する
4. 成功時は座標と精度、地図上のマーカーを確認する
5. 拒否時は画面にエラー内容が表示される

## 使用技術

- Browser Geolocation API
- Leaflet 1.9.4
- OpenStreetMap tile
- HTML / CSS / JavaScript

## 注意

位置情報取得は secure context (HTTPS) とユーザー許可が必要です。
端末やブラウザ、OS設定によって取得精度や挙動は異なります。

Leafletのバージョンやブラウザ仕様は記事公開時に公式情報を再確認してください。
