# powercfgで画面オフ時間を確認する

Windowsの電源設定を、まず読み取りだけで観察するサンプルです。

## まず試す

```powershell
powercfg /query SCHEME_CURRENT SUB_VIDEO VIDEOIDLE
```

AC/DCの現在値を16進秒で確認します。

## ここを見る

`Current AC Power Setting Index` と `Current DC Power Setting Index` を確認します。

## 1か所変える

この記事では変更を必須にしません。変更する場合は現在値を記録してから、Windowsの「設定 > システム > 電源とバッテリー > 画面、スリープ、休止状態のタイムアウト」でGUI側を変更し、同じコマンドで差を確認します。

## 仕事で使うなら

PCセットアップ時の設定確認、問い合わせ時の現状採取に使えます。

## 注意点

ポリシー管理端末ではGUI変更が反映されない場合があります。組織管理端末でポリシーを回避しないでください。

検証状態: implemented。Windows実機では未確認です。
