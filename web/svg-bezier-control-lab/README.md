# SVGベジェ曲線の制御点をスライダーで動かす

ブラウザ標準のSVGとJavaScriptだけで、架空の曲線を変形する教材です。外部ライブラリ、APIキー、位置情報、音声、保存機能は使いません。

## ライブデモ

[SVGベジェ曲線の操作デモ（GitHub Pagesへの反映・実ブラウザ動作は未確認）](https://papanda925.github.io/Daily-Code-Samples/demos/svg-bezier-control-lab/)

## まず試す

1. デモを開き、制御点1のスライダーを70から160へ動かします。
2. 青い曲線と下のSVG命令の数値が変わるか確認します。
3. 「直線にする」を押すと両方の制御点のY座標が160になります。

## ここを見る

| 操作 | 期待結果（隔離Chromiumで確認。一般端末は未検証） |
|---|---|
| 初期表示 | M 60 160 C 200 70 400 250 540 160 |
| 制御点1を160にする | Cの最初のY値が160になる |
| 直線にする | C 200 160 400 160 540 160 |
| 初期値に戻す | 70、250に戻る |

SVGの`M`は始点、`C`は2つの制御点と終点を指定する三次ベジェ曲線です。制御点は必ずしも曲線上にはありません。2点とも始点・終点と同じ高さなら直線になります。

## ファイル

- `docs/demos/svg-bezier-control-lab/index.html`: 操作UIとSVG、最小限のCSS
- `docs/demos/svg-bezier-control-lab/app.js`: 数値から`d`属性を更新する処理

HTMLとJavaScriptを同じフォルダに保存して`index.html`を開けば、ネットワーク不要で動く設計です。隔離Chromium 144（Linux、headless）で実際のHTML/JSを使った操作テスト12項目がPASSしました。GitHub Pages公開URL・WordPress・一般端末の動作は未確認です。

## 1か所変えてみる

`app.js`の初期値`topSlider.value = "70"`はリセット処理で使用します。`"70"`を`"120"`に変更すると「初期値に戻す」の形だけが変わります。HTMLの初期`value`も同じ値にそろえたい場合は、両ファイルを更新してください。異なる場合は初回表示とリセット後が違うので注意してください。

## うまく動かないとき

- 文字が「読み込み中」のまま：`app.js`の配置とブラウザConsoleを確認。
- 線が変わらない：スライダーの値と`pathCode`の数値が更新されるか確認。
- 表示が小さい：SVGは`viewBox`で拡大縮小されます。画面幅を確認。
- 印刷時：スライダーは非表示にし、最後に選んだ線と数値を印刷する想定です。印刷実機未確認。

## 仕事・学習で使うなら

工程のつながりを示す説明図、画面内の流れを表す矢印、数学の曲線教材に応用できます。地図の実ルートや測量の正確性を保証するものではありません。重要な数値は線だけでなくテキストでも示します。

## 公式資料

- [MDN SVG d属性](https://developer.mozilla.org/en-US/docs/Web/SVG/Reference/Attribute/d)
- [MDN SVG Paths](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorials/SVG_from_scratch/Paths)
- [MDN setAttribute](https://developer.mozilla.org/en-US/docs/Web/API/Element/setAttribute)

## 検証

2026-10-31: MDNの仕様確認、V8構文検査、既存mock DOM 6件PASS。追加でGitHub取得のHTML/JSとGit blob SHAを一致照合し、隔離LinuxのChromium 144.0.7559.96（Playwright）でデスクトップ/モバイル12項目PASS。初期パス、スライダー、制御点、直線化、状態文、リセット、SVG描画、JSエラーなし、モバイル表示幅を確認。ローカルfile://直接移動は実行環境の管理制限で拒否されたため、同一HTMLをset_contentし同一JSをadd_script_tagで実行。公開Pages到達、実ユーザー端末、WordPress描画、印刷・支援技術は未確認。外部画像・素材なし。GitHub Actions未使用。

### ブラウザ検証を再実行（任意）

Python 3.9以降、PlaywrightとChromiumが必要です（通常のデモ閲覧には不要）。リポジトリのルートで `python -m pip install playwright`、`python -m playwright install chromium` を実行した検証環境で `python web/svg-bezier-control-lab/tests/browser_smoke.py` を実行します。組織端末ではパッケージ導入前にポリシーを確認してください。既存のChromiumを使う場合は環境変数 `CHROMIUM_PATH` に実行ファイルを指定します。12項目PASSとブラウザバージョンが出れば、隔離環境の操作テストが完了です。外部サイトの到達性は検査しません。
