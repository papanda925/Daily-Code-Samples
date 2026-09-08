# Daily Code Samples

ブログ公開日や連番ではなく、**カテゴリから探せる実用コード・ツール集**です。

ネタの正本は `papanda925/Blog-Ideas/ideas`。ここには、記事で使う価値がある実装だけを置きます。

## カテゴリ

- `office/` — Office Scripts / Power Query M / Excel関数
- `windows/` — Win32 / WinRT / OS / GUI / デバイス
- `network/` — TCP/IP / HTTP / DNS / TLS / Socket
- `powershell/` — PowerShell実用コード
- `vba/` — VBA / Windows API / Office自動化の基礎
- `ubuntu/` — Bash / Linux / Nginx / PHP-FPM / systemd
- `security/` — マスク / Hash / 権限 / 安全確認
- `programming/` — 言語共通・アルゴリズム・データ形式
- `web/` — Browser API / JavaScript / ライブデモ / Webライブラリ

各サンプルはカテゴリ配下に、用途が分かる短い名前で置きます。

例: `security/mask-config-secrets/`

変化の速い製品・サービス固有のテーマはカテゴリ化せず、必要な場合だけ関連する基礎カテゴリへ置きます。

旧構成は `legacy-archive` ブランチに保存しています。


## Webライブデモ

`web/` 配下では、GitHub Pages等でそのまま開いて動かせるHTML/CSS/JavaScriptサンプルを扱います。
位置情報・カメラ・マイク等の権限を使うデモは、ユーザー操作後にだけ要求し、
取得した個人情報を保存・送信しない最小構成を基本とします。

最初の例: `web/geolocation-leaflet/`
