# 画像が読み込まれた瞬間のレイアウト移動を探す｜PerformanceObserver

画像を表示する場所を先に確保すると、後から画像が現れたときに本文が押し下げられるのを防げます。この教材では、場所を予約しない場合と予約する場合を同じブラウザー内で比べ、本文の位置と `layout-shift` 記録を観察します。

## ライブデモ

[画像のレイアウト移動を試す](https://papanda925.github.io/Daily-Code-Samples/demos/performance-layout-shift/#live)

## まず試す

1. デモを開き、「実行」を押します。
2. 「予約なし」を押します。約0.85秒後にサンプル画像が表示されます。
3. 結果欄の「本文の移動px」と「記録」を読みます。
4. 「予約あり」を押して、同じ観察をします。
5. ウィンドウ幅を変えて、画像と本文の動きも比べます。

「予約なし」では画像の領域が最初はありません。画像が現れると、その下にある本文が移動します。「予約あり」では画像要素を最初から表示し、幅・高さ・比率を指定するため、画像の読み込み後も本文は同じ位置にとどまります。移動ピクセル数は画面幅に応じた表示上の高さになるため、常に180pxとは限りません。

`#input` のテキスト欄は共通画面の入力欄です。この実験では入力文字列を使わず、「予約なし」「予約あり」の2つのボタンで条件を切り替えます。

## 結果の読み方

| 表示 | 何を表すか | 観察の目安 |
|---|---|---|
| 本文の移動px | 実験用本文の `offsetTop` の前後差 | 予約なしでは正の値、予約ありでは0に近い値 |
| `記録[].移動値` | ブラウザーが記録した個々のレイアウトシフト値 | 予約なしで記録され、予約ありでは記録されないか小さいことが多い |
| `記録[].時刻` | ページ読み込み開始からの発生時刻（ミリ秒） | 画像表示の遅延後に記録される |
| `記録[].直近入力` | 直近のユーザー入力があったか | `true` はそのエントリーをCLS計算から除外する判断材料 |

結果はブラウザー、画面幅、表示タイミングで変わります。ピクセル差はこの教材の要素位置を測った値で、CLSスコアではありません。Layout Instability APIの `value` はビューポートへの影響範囲と移動距離から計算される個々のシフト値です。実際のCLSは、対象期間内の値をユーザー入力やセッションウィンドウなどの規則に沿って集計します。

## 実装の要点

実装は [公開デモHTML](../../docs/demos/performance-layout-shift/index.html) と [共通デモコード](../../docs/demos/browser-library-labs/daily.js) のID 60です。予約ありは画像を表示したまま寸法を設定し、予約なしは初め `display:none` にしてから表示します。画像は外部ファイルではなく、コード内で作るSVGデータURLです。

この実験で使っている監視処理の要点は次のとおりです。

```js
const supported =
  PerformanceObserver.supportedEntryTypes?.includes("layout-shift");

if (supported) {
  const observer = new PerformanceObserver((list) => {
    for (const entry of list.getEntries()) {
      console.log({
        value: entry.value,
        startTime: entry.startTime,
        hadRecentInput: entry.hadRecentInput,
      });
    }
  });
  observer.observe({ type: "layout-shift" });
}
```

`PerformanceObserver` は登録した種類のパフォーマンス記録を受け取ります。対応する記録種類はブラウザーごとに異なるため、`supportedEntryTypes` で確認してから監視します。実装は実験のたびに前の監視を切断し、二重記録を避けています。

このコードはCLS全体を計算したり、記録をサーバーへ送信したりしません。単一の `layout-shift` エントリーを観察する入門用です。継続的なCLS計測では、除外条件、セッションウィンドウ、ページの表示終了時の処理などが別途必要です。

## 実務で使うとき

- HTMLの画像に `width` と `height` を指定するか、CSSで `aspect-ratio` を決め、読み込み前から領域を確保します。
- 可変サイズの広告、埋め込み動画、遅れて挿入するカードにも、予定する枠やプレースホルダーを用意します。
- 低速回線や実際の端末でも確認し、開発者ツールのレイアウトシフト表示やフィールド計測と組み合わせます。
- ユーザー操作で開くアコーディオンなど、意図が明確な変化まで一律に「不具合」と判定しません。

## うまくいかないとき

- **移動値が出ない**: `PerformanceObserver.supportedEntryTypes` に `layout-shift` があるか確認します。未対応なら本文のピクセル差だけを比較します。
- **予約なしでも0pxになる**: 実行直後に画像が既に表示された、画面幅が狭く本文の基準位置が測りにくい、別の操作で再実行された可能性があります。「実行」からやり直し、ボタンを1つずつ押します。
- **予約ありでも本文が動く**: 表示前後で画像要素の寸法が変わっていないか、開発者ツールで確認します。
- **図が表示されない**: Mermaidを配信するCDNへのアクセスが制限されていないか確認します。図がなくてもデモと文章は利用できます。

## 前提・検証範囲

デモはブラウザー上のHTML/CSS/JavaScriptで動作します。Mermaidによる図の表示は外部CDN通信を使います。実験データはインラインSVGで生成し、入力を送信・保存しません。個人情報を入力せず、説明用の架空データを使ってください。

GitのHTML・README・共通コードは照合しました。Node.jsで共通JavaScriptの構文確認と、HTMLの要素・デモ設定の静的確認を行いました。Pages上で各ブラウザーを操作する実機確認は未実施です。Layout Instability APIは一部のブラウザーで利用できないため、公開環境でも `layout-shift` 記録が得られるとは限りません。

## 公式資料

- [MDN: PerformanceObserver](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceObserver)
- [MDN: PerformanceObserver.observe()](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceObserver/observe)
- [MDN: PerformanceObserver.supportedEntryTypes](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceObserver/supportedEntryTypes_static)
- [MDN: LayoutShift](https://developer.mozilla.org/en-US/docs/Web/API/LayoutShift)
- [WICG: Layout Instability API](https://wicg.github.io/layout-instability/)
- [web.dev: Cumulative Layout Shift](https://web.dev/articles/cls)

本文はAIを利用して作成しました。
