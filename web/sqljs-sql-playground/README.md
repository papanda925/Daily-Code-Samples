# SQLite + WebAssembly：SQLで集計する

架空の売上データをブラウザー内SQLiteへ読み込み、SELECTを変更して集計結果を確認します。 初心者でも操作と結果を比較できる、ブラウザー実行型の教材です。

## ライブデモ
[操作する（GitHub Pages）](https://papanda925.github.io/Daily-Code-Samples/demos/sqljs-sql-playground/)

公開URLは配置先を示します。**実際のGitHub Pages到達とブラウザー操作は未検証**です。

## まず試す
1. SQLiteを読み込んでから「SQLを実行」を押す。
2. 本310、食品210、文具130の順を確認する。
3. GROUP BYのcategoryを消す場合は集計列との対応が変わることを観察する。

**期待結果**：架空の5件からカテゴリ別合計が表示される。元の順番は金額降順。結果は毎回新しい一時データベースで実行する。

## しくみ
sql.jsはSQLiteエンジンをWebAssemblyで実行する。JavaScriptがローカルDBを作り、db.execが結果行を返す。

## 実装ファイル
- [HTML](../../docs/demos/sqljs-sql-playground/index.html)
- [JavaScript](../../docs/demos/sqljs-sql-playground/app.js)
- [共通スタイル](../../docs/demos/_shared/interactive-lab.css)

## 変更実験
SUM(amount)をCOUNT(*)へ変更して件数を比較。

## 動かない場合
CDN接続・WASM読み込みがブロックされると準備失敗。SQL構文に問題があればエラーが表示される。多量の行を返すSELECTは重くなる可能性がある。

## 安全と検証
ライブラリ取得に外部通信あり。売上は架空データでサーバーDBへ接続しない。SQLはブラウザー内の一時DBに対してだけ実行。
- 今回は実装内容とリンク・操作の対応を静的に確認。GitHub Actions・有料APIは使わない。
- ブラウザー実行とGitHub Pages配信の実証は未実施。実機テスト済みと表現しない。

## 仕事での応用
CSV等の小さなサンプルを端末内で集計する導入教材です。実務データの保存・監査・アクセス権は別設計です。

## 公式資料
- https://sql.js.org/documentation/
- https://www.sqlite.org/lang_select.html

**対応するブログ記事ID（計画）**：20261125-07。ブログ公開はUbuntuの既設Publisherが担当し、このREADMEの保存だけで公開済みとはしません。
