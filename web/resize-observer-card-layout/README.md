# ResizeObserverでカード幅を観察する

ブラウザ標準のResizeObserverで、架空のカード枠の**要素自体の幅**を測ります。画面全体の幅に応じたCSSメディアクエリとの違いを、指定値と実測値で観察します。APIキー・個人情報・外部ライブラリ・外部通信なし。MITライセンス（リポジトリのLICENSE）。

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/resize-observer-card-layout/

**GitHub Pagesへの反映・ブラウザ動作は未確認です。** 404の場合は下記のHTMLとJavaScriptを同じフォルダに保存して開いてください。

## まず試す

1. 「300px」を押し、縦並びと実測値を見る。
2. 「520px」を押し、横並びに変わるかを見る。
3. 「観察停止」を押して幅を変え、実測表示が更新されないことを確認する。再開で追従します。

| 指定幅 | 期待する表示（十分広い画面） |
|---|---|
| 300px | 実測約296px、縦並び |
| 520px | 実測約516px、横並び |
| 520px / 狭い画面 | 実測値は指定より小さくなり得る |

実測値はborder幅を除いたcontent boxであり、表示倍率・画面幅・端数丸めで変わります。360pxの判定は**実測コンテンツ幅**に対して行います。実機未確認のため表は期待値です。

## 原理と一条件変更

`observer.observe(stage)`で枠のサイズ変更を監視し、`entry.contentBoxSize`（利用できなければ`contentRect.width`）で幅を読みます。コールバック内で監視枠自体の幅は変更しないため、循環リサイズを避けます。

`const modeFor = (width) => width < 360 ? "compact" : "wide";` の **360** を **420** に変え、実測400px付近で縦並びのままになるかを予想して比べます。戻すには360へ戻します。

## うまく動かないとき

- 「未対応」：ResizeObserverの対応ブラウザか確認。IEなど古いブラウザでは使用できません。
- 520pxにしても横並びにならない：画面が狭い場合はmax-width:100%で制限されます。**指定幅ではなく実測幅**を見る。
- 表示が更新されない：「観察停止」になっていないか確認し「観察再開」を押す。
- 真っ白：HTMLとapp.jsの相対パス、ブラウザConsoleを確認。
- `ResizeObserver loop completed with undelivered notifications`：監視対象のサイズをコールバックで繰返し変更していないか確認。本教材では監視対象の幅をコールバックから変更しません。

## 検証範囲

MDN一次資料を2026-11-01に確認。JavaScript構文と幅判定の純粋ロジックをV8で検査予定／実施結果は記事側の検証記録を参照。実ブラウザ、スマートフォン、GitHub Pages公開、WordPress表示は未確認。

## ファイル

- `docs/demos/resize-observer-card-layout/index.html` — 操作画面とデモ専用CSS
- `docs/demos/resize-observer-card-layout/app.js` — ResizeObserver監視・停止/再開・表示
- `web/resize-observer-card-layout/README.md` — この教材

## 公式資料

- https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver
- https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserverEntry
- https://developer.mozilla.org/ja/docs/Web/API/ResizeObserver/observe
