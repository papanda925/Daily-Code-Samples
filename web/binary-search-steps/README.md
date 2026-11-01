# 二分探索を目で追う：15個の数字を半分ずつ探す

## ライブデモ
https://papanda925.github.io/Daily-Code-Samples/demos/binary-search-steps/

※GitHub Pagesへの実到達・ブラウザ操作は未確認です。実在するソースから公開される想定のURLであり、動作確認済みとは記載しません。

## まず試す
1. スライダーで「8」を選びます（初期値8）。
2. 「次の比較」を押します。
3. 緑の8と「1回目」の表示を見ます。次に15を選び直し、4回押すと比較回数の違いが分かります。

## ここを見る
青は残った候補、灰は除外、黄は比較中、緑は発見。色を見分けにくい場合は「比較した履歴」を読みます。

## 1か所変える
目標を8から15に変更すると、比較回数が1回から4回に増えます。1〜15のどれを選んでも最大4回で見つかる想定です。

## 自分のPCで動かす
`docs/demos/binary-search-steps/index.html` と同じ階層の `app.js` を保存し、index.htmlをブラウザで開いてください。ネットワーク通信は不要です。

## 実装の仕組み
`Math.floor((low + high) / 2)` で中央を選び、目標より小さければ左半分、大きければ右半分を除外します。前提は昇順に整列済みの配列です。未整列データには適用できません。

## うまく動かないとき
- 画面が動かない：同じフォルダにapp.jsがあるか、開発者ツールのConsoleで読み込みエラーを確認。
- 数字が変わらない：検索終了後は「最初から」、目標変更時は自動でリセット。
- ブラウザが古い：`Element.replaceChildren` 対応状況を確認。

## 仕事・学習で使うなら
整列済みのID一覧、ページ索引、辞書検索の「候補を半分に減らす」考え方を学べます。実務の検索対象が未整列・頻繁に変化する場合は、先に並べ替えるコストも評価してください。

## 公式資料
- Math.floor: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/floor
- Element.replaceChildren: https://developer.mozilla.org/en-US/docs/Web/API/Element/replaceChildren
- HTMLElement change/input events: https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/change_event

## 検証状態（2026-11-02）
コードの純粋な探索ロジックを15件の目標と範囲境界で確認予定。ブラウザ実機・GitHub Pages到達・WordPress表示・モバイル印刷は未確認。第三者画像や外部CDNなし。教材コードはMITライセンス方針に従います。
