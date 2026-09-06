# Daily Code Samples — Snippet & Copy/Paste Roadmap #301〜#421

この文書は、**「そのままコピペして使える」「短時間で意味まで分かる」**ことを重視した Daily Code の追加候補です。

## 共通方針

- 1サンプル = 1目的
- 最初に「まずコピペ」を置く
- その後に1行ずつ・パラメータごとに分解して説明する
- 最小版と、可能なら実務向けの安全版を併記する
- 実行例・想定結果・よくあるエラーを付ける
- APIキー、パスワード、個人情報、実環境固有値は掲載しない
- 初心者向けに、日本語コメントを十分に入れる
- Mermaidはコードだけでなく「何を表す図か」「どこを書き換えるか」まで説明する
- コマンドは「何をするか」だけでなく各オプションの意味を分解する
- 将来のブログ記事化を前提に、末尾へ「コピペ用まとめ」を置く

---

## 🟣 VBA Copy & Paste Lab

- **#301** VBAで最終行を取得する
- **#302** VBAで最終列を取得する
- **#303** VBAでシートが存在するか確認する
- **#304** VBAでファイルが存在するか確認する
- **#305** VBAでフォルダーが存在するか確認する
- **#306** VBAでCSVを1行ずつ読み込む
- **#307** VBAでCSVへ安全に書き出す
- **#308** VBAでDictionaryを作って重複を数える
- **#309** VBAでエラー処理の共通テンプレートを作る
- **#310** VBAで処理時間を計測する
- **#311** VBAでログファイルへ追記する
- **#312** VBAでXMLHTTPによるGETを最小コードで実行する
- **#313** VBAでXMLHTTPによるPOSTを実行する
- **#314** VBAでHTTPステータスコードを確認してエラー処理する
- **#315** VBAで64bit対応のPtrSafe / LongPtrテンプレートを作る

---

## 🔵 PowerShell Copy & Paste Lab

- **#316** PowerShellでファイルの存在を確認する
- **#317** PowerShellでフォルダーを再帰検索する
- **#318** PowerShellで文字列をgrep風に検索する
- **#319** PowerShellでCSVを読み込み条件抽出する
- **#320** PowerShellでJSONを読み書きする
- **#321** PowerShellでREST APIへGETする
- **#322** PowerShellでREST APIへPOSTする
- **#323** PowerShellでログへ日時付きで追記する
- **#324** PowerShellでtry/catchの実務向けテンプレートを作る
- **#325** PowerShellでTCPポート疎通を確認する

---

## 🐧 Bash / Linux Command Breakdown Lab

- **#326** findコマンドで名前からファイルを探す
- **#327** findの -iname / -type / -print を分解する
- **#328** 2>/dev/null は何をしている？標準エラーを理解する
- **#329** grep -RniE をパラメータごとに分解する
- **#330** curl -I でHTTPレスポンスヘッダーを見る
- **#331** curl -sS -o /dev/null -w を分解する
- **#332** systemctl status / restart / enable の違いを知る
- **#333** journalctl -u --since --no-pager を分解する
- **#334** tail -f でログをリアルタイム確認する
- **#335** ps / pgrep / kill でプロセスを確認・終了する

---

## 🧭 Mermaid Copy & Paste Diagram Lab

- **#336** MermaidでPC→ルーター→Internetの基本ネットワーク図を描く
- **#337** MermaidでWebサーバー / Nginx / PHP-FPM / WordPress / DBを描く
- **#338** MermaidでDNS名前解決の流れを描く
- **#339** MermaidでDHCPによるIPアドレス取得の流れを描く
- **#340** MermaidでHTTPリクエストとレスポンスをSequence Diagramにする
- **#341** MermaidでREST APIのクライアント・サーバー通信を描く
- **#342** MermaidでGitのbranch→PR→mergeの流れを描く
- **#343** MermaidでGitHub ActionsのCI処理を描く
- **#344** MermaidでAIブログ自動生成パイプラインを描く
- **#345** MermaidでWordPress公開までの処理フローを描く

---

## 🤖 Git / Codex Parameter Lab

- **#346** git status の見方を初心者向けに分解する
- **#347** git log --oneline --graph --decorate を分解する
- **#348** git diff --stat / --name-only / --check の違いを比べる
- **#349** git fetch / pull / clone の違いを実例で比べる
- **#350** codex --version と codex -m の意味を知る
- **#351** Codexの /model /status /usage の使い分けを知る
- **#352** AGENTS.mdとは何か？最小テンプレートを作る

---

## 🟢 Excel / Office Copy & Paste Lab

- **#353** Excelで最終行までの動的範囲を作る
- **#354** FILTERで条件に合う行だけ抽出する
- **#355** LETで長い数式を読みやすくする
- **#356** CHOOSECOLSで必要な列だけ取り出す
- **#357** HSTACK / VSTACKで表を結合する
- **#358** NETWORKDAYSで営業日を判定する
- **#359** TEXTJOINで複数セルの文字列を安全に結合する
- **#360** 条件付き書式で特定文字を含む行全体へ色を付ける

---

## 🟣 VBA Practical Utility Lab

- **#361** VBAでRange.Findを安全に使って文字列を検索する
- **#362** VBAでExcelテーブル（ListObject）を名前で取得して扱う
- **#363** VBAでRangeを2次元配列へ一括取得して高速化する
- **#364** VBAでScreenUpdating・EnableEvents・Calculationを一時停止して必ず元へ戻す
- **#365** VBAのFileDialogでファイル選択画面を表示する
- **#366** VBAのFileDialogでフォルダー選択画面を表示する
- **#367** VBA + ADODB.StreamでUTF-8テキストを読み込む
- **#368** VBA + ADODB.StreamでUTF-8テキストを書き出す

---

## 🧭 Mermaid Network Architecture Lab

- **#369** MermaidでVLAN分割された社内ネットワーク図を描く
- **#370** MermaidでNAT / ルーター / Internetの関係を描く
- **#371** MermaidでReverse Proxy→Webサーバーの構成を描く
- **#372** MermaidでLoad Balancer配下の複数Webサーバーを描く
- **#373** MermaidでFirewall / DMZ / 社内LANの基本構成を描く
- **#374** MermaidでIPv4とIPv6の通信経路を比較する
- **#375** MermaidでリモートアクセスVPNの接続経路を描く
- **#376** Mermaidでオンプレミス→Internet→SaaSの通信経路を描く

---

## 🐧 Ubuntu Operations Copy & Paste Lab

- **#377** df -h と du -sh でディスク使用量を確認する
- **#378** ss -lntup で待受ポートとプロセスを確認する
- **#379** ip addr / ip route でIPアドレスと経路を確認する
- **#380** digでDNS名前解決の結果を確認する
- **#381** nginx -t で設定変更前後の構文チェックをする
- **#382** systemctl list-units --failed で失敗サービスを確認する
- **#383** logrotateの設定とdry-runでログローテーションを確認する
- **#384** certbot certificates / renew --dry-run でTLS証明書更新を確認する

---

## 🤖 Codex / AI Development Workflow Lab

- **#385** ~/.codex/config.toml の場所を確認してバックアップする
- **#386** CodexのModelとEffortを作業内容に応じて使い分ける
- **#387** AGENTS.mdの親ディレクトリ・子ディレクトリの適用範囲を理解する
- **#388** Codexへ「変更せずに調査だけ」を依頼するプロンプトテンプレート
- **#389** Codexへ障害原因調査を依頼するプロンプトテンプレート
- **#390** Codexへコードレビューを依頼するプロンプトテンプレート
- **#391** CodexへPRのmerge-readiness確認を依頼するプロンプトテンプレート
- **#392** Codex CLIの更新前後でversion・設定・動作を確認する

---

## 🌐 WordPress Operations Copy & Paste Lab

- **#393** WP-CLIでWordPress本体・PHP・WP-CLIのバージョンを確認する
- **#394** WP-CLIで有効テーマとプラグイン一覧を確認する
- **#395** WP-CLIでCronイベント一覧と次回実行時刻を確認する
- **#396** WP-CLIでデータベースを変更前にバックアップする
- **#397** wp core verify-checksums でWordPressコア改変の有無を確認する
- **#398** wp-content配下のファイル権限をfindで点検する
- **#399** curlでWordPress REST APIとHTTPステータスを確認する
- **#400** WordPress障害時に使う読み取り中心の一次切り分けコマンド集

---

## 🪟 VBA Windows API Constants & Types Lab

Windows API をVBAから呼び出すときに頻出する **Declare / 型 / Const / Enum / ビットフラグ** を、
「そのまま貼れる定義」と「なぜこの型・値なのか」の両方から学ぶ。

- **#401** VBAの `Const` と `Enum` はどう使い分ける？ Windows API定数で比較する
- **#402** `&H` から始まる16進数定数をVBAで読む（`&H10`, `&H80000000` など）
- **#403** `Declare PtrSafe` / `LongPtr` / `LongLong` の役割を32bit・64bitで整理する
- **#404** Windows APIの引数を全部 `LongPtr` にしてはいけない理由を型対応表で学ぶ
- **#405** `HWND` とは何か？ VBAではウィンドウハンドルをどう宣言する？
- **#406** `WM_*` 定数入門：`WM_CLOSE` / `WM_COMMAND` / `WM_USER` をEnumで整理する
- **#407** `SW_*` 定数入門：`SW_HIDE` / `SW_SHOW` / `SW_RESTORE` をShowWindowで試す
- **#408** `SWP_*` 定数入門：SetWindowPosのフラグをConstで整理する
- **#409** `MB_*` 定数入門：MessageBoxのボタン・アイコンを `Or` で組み合わせる
- **#410** `GW_*` 定数入門：GetWindowで前後・親子ウィンドウをたどる
- **#411** `SM_*` 定数入門：GetSystemMetricsで画面サイズやシステム値を読む
- **#412** `VK_*` 仮想キーコード入門：Enter / Esc / Shift / F1などをEnumで整理する
- **#413** `WS_*` Window Style定数を読み解く：ビットフラグとしてのウィンドウ属性
- **#414** `WS_EX_*` Extended Window Style定数を読み解く
- **#415** `GWL_*` / `GWLP_*` の違いと32bit・64bit対応を理解する
- **#416** `FILE_ATTRIBUTE_*` 定数でWindowsのファイル属性を読み解く
- **#417** `WAIT_OBJECT_0` / `WAIT_TIMEOUT` / `INFINITE` でWait系APIの戻り値と待機時間を読む
- **#418** `PROCESS_*` アクセス権定数を「必要最小限」で指定する考え方を学ぶ
- **#419** APIのフラグを `Or` で組み合わせ、`And` で判定するVBAのビット演算入門
- **#420** コピペ用「VBA Windows API定義モジュール」最小テンプレートを作る

---

## 🔐 AI Sharing Sanitization Lab

- **#421** 設定ファイルをAIへ渡す前に秘密情報を `****` へ自動マスクするBashスクリプト

  - 元ファイルは変更しない
  - `password` / `passwd` / `secret` / `token` / `api_key` / `client_secret` / `access_token` / `refresh_token` / `authorization` などをマスク対象にする
  - 実ドメイン・実ユーザー名・メールアドレス・SSID・MACアドレス・内部IP・ホスト名・秘密鍵・証明書関連情報なども、共有前に一般化・除去する
  - 自動マスク後に**必ず人間が最終確認**してからAIへ共有する
  - 正規表現だけでは複数行の秘密情報やJSON/YAML構造を取りこぼす可能性があることも説明する
  - 「自動サニタイズ = 100%安全」ではないことを明記する

---

## 推奨記事テンプレート

```markdown
# ○○する方法

## まずコピペ

```
ここにコードまたはコマンド
```

## 何をしている？

## 1行ずつ / パラメータごとに分解

## 実行例

## 実行結果の見方

## よくあるエラー

## 実務向けの安全版

## コピペ用まとめ
```

## ステータス

#301〜#421 は **planned**。既存 #001〜#300 の実体化済みサンプルとは区別し、今後 Daily Code の生成対象として順次実装する。
