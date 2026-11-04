# Intl.Collator 日本語ファイル名の自然順ソート
対象: 現行のIntl.Collator対応ブラウザー / Node.js 20+（OS非依存の純粋ロジック）。外部ライブラリ、CDN、API、通信、保存なし。実在の業務ファイル名や個人情報を入力しないでください。

## 操作
1. `index.html` をブラウザーで開く。表示できない場合はリポジトリ直下で `python3 -m http.server 8000`、`http://localhost:8000/web/japanese-natural-sort/` を開く。
2. 初期値 `資料10 / 資料2 / 資料1 / 資料20` で「並べ替える」を押す。
3. 数字比較ONなら `資料1 / 資料2 / 資料10 / 資料20`、OFFなら `資料1 / 資料10 / 資料2 / 資料20` になることを比較。
4. 入力を戻すときは「初期値に戻す」。外部保存はない。

## コード・検証
`sort.js` が `Intl.Collator("ja-JP",{numeric:true,sensitivity:"base"})` で比較し、元の配列を変更せず新しい配列を返す。`app.js` は結果を `textContent` で表示。入力は100件・各120文字以内、空行はUIで除去する。数字比較は数値部分の自然順を助けるが、漢字の読み仮名推測や人名・会社名の正規化を保証しない。

`node --test web/japanese-natural-sort/test.cjs` でNode標準テスト9件を実行可能。実行結果は実際の実行ログがある場合のみ「PASS」と記録する。ブラウザー・GitHub Pages・WordPress実表示は別検証。

## 失敗時
- 結果が空: 開発者ツールで `sort.js` / `app.js` の読み込みを確認。
- 想定と異なる: numeric設定、sensitivity、実行環境のIntl/ICU版を確認。
- 入力エラー: 行数と1行の長さを確認し、実データではなく架空例で再現する。

## 仕事での利用
請求書番号や資料番号の画面一覧を人が読みやすくするための学習例。ファイルシステムを操作・変更しない。実務では原本の順序や識別子を保持し、ロケールやICUバージョン差を別途確認する。

公式: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/Collator
仕様: https://tc39.es/ecma402/#collator-objects
