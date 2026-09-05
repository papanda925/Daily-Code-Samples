# Daily Code Samples — Snippet & Copy/Paste Roadmap #301〜#360

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

#301〜#360 は **planned**。既存 #001〜#300 の実体化済みサンプルとは区別し、今後 Daily Code の生成対象として順次実装する。
