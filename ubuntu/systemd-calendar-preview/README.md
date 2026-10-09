# systemd-analyze calendarでタイマーの次回時刻を確認する

ファイル: `preview-calendar.sh`

```bash
bash preview-calendar.sh
bash preview-calendar.sh '*-*-* 08:30:00 Asia/Tokyo'
```

このスクリプトは`systemd-analyze calendar`に式を渡して時刻を表示するだけです。`sudo`は不要で、unitファイル、timer、サービスを変更・起動しません。

既定のカレンダーは偶数時05分の12枠（日本時間）。`--iterations=8`で次の8回を表示します。現在時刻に応じて出力日は変わります。

## 追加確認（読取りのみ）

```bash
systemctl list-timers --all --no-pager
systemctl cat <自分で選んだtimer名>
systemctl show <自分で選んだtimer名> -p NextElapseUSecRealtime -p LastTriggerUSec
```

`systemd-analyze calendar`は文法と予定時刻の計算、`systemctl list-timers`は現在登録されたタイマーの状態の観察です。前者の結果だけで稼働中だと判断しません。

## 注意

- `Persistent=true`は、OnCalendarタイマーが停止中に逃した実行を追いつかせる機能。すべての欠落実行が1件ずつ再生されることは保証しません。
- `AccuracySec`の既定値などにより、実際の起動は秒単位で完全一致しません。
- `Asia/Tokyo`を明示しない式はホストのタイムゾーンに依存します。
- 実行結果は利用環境のsystemdバージョンと時刻設定に左右されます。

## 一次資料
- https://www.man7.org/linux/man-pages/man1/systemd-analyze.1.html
- https://www.man7.org/linux/man-pages/man5/systemd.timer.5.html
- https://www.man7.org/linux/man-pages/man7/systemd.time.7.html
