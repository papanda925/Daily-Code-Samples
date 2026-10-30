# Canvas花火実験：クリックで広がる粒子

## ライブデモ
https://papanda925.github.io/Daily-Code-Samples/demos/canvas-fireworks-accessible/

**公開・ブラウザ動作は未確認**。GitHub Pagesの反映を確認できない場合はローカルで実行してください。

## まず試す
1. デモを開いて「花火を打つ」を押します。夜空をクリックしても発射できます。
2. 粒子数を24個から48個へ変更し、再び打ちます。
3. 「一時停止」「再開」「消去」を試します。

期待結果は、初期24個→変更後48個、クリック位置から放射状に広がることです。画面の回数・粒子数は文字でも表示します。これはソースからの期待値で、実ブラウザ測定ではありません。

## 自分のPCで動かす
`docs/demos/canvas-fireworks-accessible/index.html` と `app.js` を同じフォルダへ保存します。
外部ライブラリやAPIキーは不要です。HTMLをブラウザで開くか、`python3 -m http.server 8000 --bind 127.0.0.1` で配信します。

## ここを見る
- `launch()` は粒子の初期位置と方向を決めます。
- `tick()` は速度・重力・寿命を少しずつ更新します。
- `requestAnimationFrame()` は次の描画を予約します。
- `matchMedia("(prefers-reduced-motion: reduce)")` が有効なら静止表示します。
- `cancelAnimationFrame()` は停止・消去で予約済みフレームを取り消します。

## 1か所変える
`p.vy += 0.045` の 0.045 を 0.09 にすると、粒子が早めに下へ曲がると予想できます。数値は教材用で物理単位ではありません。

## 失敗したとき
空が暗いままなら、まず「花火を打つ」を押し、画面下の状態表示を確認します。何も変わらなければConsoleでJavaScriptエラー、`app.js` の読み込み、Canvas 2D対応を確認します。画面の縮尺はウィンドウ変更で再調整します。

## 安全・ライセンス
- 架空の描画のみ。カメラ、マイク、GPS、外部通信、Cookie、保存機能はありません。
- 音や高頻度の点滅はなく、動きの停止ボタンを用意しています。
- コードは学習用としてMIT Licenseで公開（リポジトリ全体のライセンス方針を優先）。第三者の画像素材は使用していません。
- 参照一次資料: https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API ; https://developer.mozilla.org/en-US/docs/Web/API/Window/requestAnimationFrame ; https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion
- 公式資料確認日: 2026-10-31（JST）。ブラウザ実行試験は未実施。

## 仕事で使うなら
オンボーディングの進捗表示やイベント案内などに応用できます。ただし重要な情報は動きだけで伝えず、テキストも併記してください。
