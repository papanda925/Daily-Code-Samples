# IntersectionObserverでカードの可視率を観察する

画面全体ではなく、**スクロール領域の内側でカードが何割見えているか**を観察する教材です。架空のタスク3枚だけを使用し、APIキー、ログイン、位置情報、外部ライブラリ、外部通信は不要です。教材コードはリポジトリのMITライセンスに従います。

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/intersection-observer-visibility-lab/

**GitHub Pagesの反映・ブラウザでの描画と操作は未確認です。** 404の場合は docs/demos/intersection-observer-visibility-lab/index.html と app.js を同じフォルダへ保存し、index.html をブラウザで開いてください。

## まず試す

1. 青い枠内をスクロールしてカードが緑色になる場所を探す。キーボードの場合は枠にフォーカスして矢印キーを使う。
2. 「可視率の条件」を25%から75%へ変え、同じ位置で判定が変わるか観察する。
3. 「観察停止」を押してスクロールする。最後の通知値で表示が固定される。「観察再開」で追従する。

| 条件 | コード上の期待結果 |
|---|---|
| 可視率30%、閾値25% | 条件を満たす |
| 可視率30%、閾値75% | 条件未満 |
| 観察停止 | 更新しない |

**可視率は画面上の明るさ・視認性そのものではありません。** intersectionRatio は対象の面積がrootの表示範囲と交差する割合です。通知は閾値を跨いだとき等に非同期で届ます。表示数値は最後の通知時点のもので、スクロール量の連続測定ではありません。

## なぜ動くのか

root は青いスクロール領域です。3枚のカードを observe() し、entry.intersectionRatio と entry.isIntersecting から条件判定します。threshold: [0, 選択値, 1] で閾値を跨ぐ通知を受けます。

閾値の設定は作成後に変更できないため、25%→75%の変更時には古いobserverを disconnect() し、新しいobserverを作ります。観察停止中の閾値変更は再開時に反映されます。

## 1か所変えてみる

index.html の75% optionを50%へ変えて、可視率60%付近のカードが条件を満たすか比べてください。変更後は再読み込みが必要です。元の75%へ戻せば再比較できます。

## うまく動かないとき

- 画面が白い：HTMLとapp.jsが同じフォルダにあるか、Consoleにエラーがないか確認。
- 数値が変わらない：「観察停止」か、閾値を跨ぐほどスクロールしていないか確認。
- カードが緑色にならない：青い枠内をスクロールし、25%へ戻して試す。
- 未対応の表示：IntersectionObserver対応ブラウザを利用。古いブラウザは非対応。
- PDFでは動かない：印刷は静止状態。本文の表と説明で条件を理解する。

## 仕事・学習で使うなら

学習コンテンツのセクションが表示領域へ入ったことを知らせたり、画像の遅延読み込みの開始条件を考えたりできます。ただし「25%見えた」ことは、読者が読了したことや本人が操作したことの証拠ではありません。閲覧履歴の送信・追跡はこの教材には実装しません。

## 検証範囲

2026-11-01、Node.js 22.16.0でJavaScript構文検査を実施。DOMとIntersectionObserverのモックを用いたテストで、25%/75%判定、閾値変更時の切替、停止・再開・リセット・後始末を確認しました。実ブラウザ・GitHub Pages到達・モバイル・WordPress実表示・PDF印刷は未実施です。

## ファイル

- docs/demos/intersection-observer-visibility-lab/index.html — デモ画面と専用CSS
- docs/demos/intersection-observer-visibility-lab/app.js — 監視、可視率、停止・再開
- web/intersection-observer-visibility-lab/README.md — 本教材

## 公式資料（2026-11-01確認）

- https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API
- https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver
