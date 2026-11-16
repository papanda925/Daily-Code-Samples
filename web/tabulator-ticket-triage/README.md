# Tabulatorで架空の障害チケットを整理する

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/tabulator-ticket-triage/

**公開URLの到達・ブラウザーでの操作は制作時点では未確認。** 静的ファイルはGitHub Pagesの既存 `main/docs` 設定で配信する想定。ページが開かない場合も、デモの成功やWordPressへの埋め込み成功を意味しない。

## 今回の目的

一覧表に対して、重要度の絞り込み、フリーワード検索、列見出しの並べ替え、状態セルの編集、架空レコード追加、初期化をブラウザーだけで体験する。データは架空の8行、サーバーへのPOSTも保存もない。

## ファイル配置

- `docs/demos/tabulator-ticket-triage/index.html`：操作画面
- `docs/demos/tabulator-ticket-triage/app.mjs`：Tabulatorへの接続とイベント処理
- `docs/demos/tabulator-ticket-triage/logic.mjs`：独立して確認できる絞り込み関数
- `docs/demos/tabulator-ticket-triage/vendor/`：Tabulator v6.3.1のJS/CSS、公式ライセンスを静的同梱
- `web/tabulator-ticket-triage/tests/logic.test.mjs`：純粋ロジックの回帰テスト

## まず試す

公開ページで「重要度：高」を選び、8行のうち3行が残ることを確かめる。さらに検索欄へ「ネットワーク」と入れると2行になる。表の「状態」欄をクリックして選択すると表示が変わる。追加ボタンはWebの架空チケットを1件追加し、リセットで元の8行に戻す。

ローカル実行するならリポジトリのルートをWebサーバーにし `python3 -m http.server 8000 -d docs` を起動。 `http://localhost:8000/demos/tabulator-ticket-triage/` から試す。Pythonのhttp.serverは検証用で、本番公開用サーバーではない。

## 検証方法

`node --test web/tabulator-ticket-triage/tests/logic.test.mjs` で検索・優先度・集計・0件・コピー分離など8件の自動テストを実施できる。**制作時にNode.jsテストとブラウザー描画が実行できたかは結果に応じて別記する。** GitHubへ置いた事実だけで実行確認済みとしない。

## 1条件だけ変える

重要度を「高」から「中」へ切り替えると、対象件数と合計分数が変わる。キーワードを消すと重要度だけが残る。表示の0件と入力データの8件を混同しない。

## 失敗しやすい点

- JavaScript/CSSが見つからない場合、相対パス `./vendor/` を確認。
- ローカル `file://` 直開きではJavaScriptモジュールがCORSによって拒否されることがあるためHTTP配信を使う。
- セル編集は**ブラウザーの状態だけ**。更新や再読込みで消える。実務用途ならAPI保存の成否と競合、操作履歴を設計する必要がある。
- キーボード操作と画面読み上げはTabulatorのバージョン・ブラウザー実装に依存する。デモの実アクセシビリティ試験は未実施。

## ライブラリと再配布

Tabulator v6.3.1（Copyright © 2015–2025 Oli Folkerd、MIT License）。
- 公式：https://tabulator.info/
- 公式Git：https://github.com/tabulator-tables/tabulator/tree/6.3.1
- バージョン固定で配布用JS/CSSを同梱。ライセンス全文：`docs/demos/tabulator-ticket-triage/vendor/LICENSE.txt`
- 外部CDN不要・課金API不要・GitHub Actions不要。サイト自体の閲覧では通常のHTTP通信が必要。
- JS Git blob SHA：`da324ce5d810cebf65b67269a90f927c8a4f99db`
- CSS Git blob SHA：`474c2c1c8e35131e8474fc8a5169ca33821c22cc`
- ライセンス blob SHA：`8ec4b8936ec9a70fdbe92e8e9a74e78b902328af`

## 公式APIの参考

- https://tabulator.info/docs/6.3/filter
- https://tabulator.info/docs/6.3/update
- https://tabulator.info/docs/6.3/edit
- https://tabulator.info/docs/6.3/events

実際の顧客名・社員名・IP・障害管理ログを投入せず、再現用の架空データだけを使用する。
