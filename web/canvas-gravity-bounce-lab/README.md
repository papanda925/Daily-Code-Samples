# Canvasで跳ねるボール：重力と反発を比較する

外部ライブラリ、ログイン、APIキーなし。Canvas 2DとrequestAnimationFrameを使い、架空のボールの落下・衝突を観察する学習サンプルです。

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/canvas-gravity-bounce-lab/

GitHub Pagesの反映・公開到達・実ブラウザ描画は未確認。表示されない場合はdocs/demos/canvas-gravity-bounce-lab/index.htmlとapp.jsを同じフォルダに保存して開いてください。

## まず試す

1. 「再生」で落下と跳ね返りを観察。
2. 反発係数0.80→0.45に変え、リセットから比較。
3. 重力を600→1000 px/s²へ変え、リセットから比較。
4. 「停止」と「0.2秒進める」も試す。

## 期待する結果（ブラウザ未実測）

| 条件 | 期待する傾向 |
|---|---|
| 係数0.80 | 高く跳ねる |
| 係数0.45 | 低く跳ねる |
| 重力600→1000 | 落下が速くなる |
| 停止 | 位置と衝突回数を保持 |
| 0.2秒進める | 0.2秒の計算だけ行い静止表示 |
| 動き軽減が有効 | 再生を無効にし、コマ送りは使用可能 |

重力はpx/s²、床の高さは描画座標330pxです。現実の物理量への換算には対応しません。

## 仕組み

- 毎回 vy = vy + g×dt、y = y + vy×dt と更新。
- 床を越えたら y を床位置へ戻し、vyを -vy×反発係数にする。
- 位置計算の細分化で1秒あたり120回程度の刻みを使い、描画はrequestAnimationFrameの時刻差を最大0.05秒に制限。
- 画面が非表示になったら停止。prefers-reduced-motionのときは自動的に静止表示。
- canvasの内部座標は720×360、モバイルはCSS縮小表示。
- 音・点滅・位置情報・認証・外部送信はありません。

## 1条件変更

gravityのHTML初期値を600→1000へ変更し、反発係数と初期位置をそろえて比べます。コマ送り操作なら動きを見続ける必要がありません。

## 失敗時

「読み込み中」のままならapp.jsの配置とConsole、ボールが動かない場合は端末の動き軽減設定、衝突回数が増えない場合は床に到達するまでの経過時間を確認します。設定を変えると現在の速度は保持されるので、比較時はリセットしてください。

## 公式出典（確認日：2026-10-31 JST）

- https://developer.mozilla.org/ja/docs/Web/API/Canvas_API/Tutorial/Advanced_animations
- https://developer.mozilla.org/ja/docs/Web/API/Window/requestAnimationFrame
- https://developer.mozilla.org/ja/docs/Web/CSS/Reference/At-rules/%40media/prefers-reduced-motion

## 検証範囲

GitHub保存・読戻しとJS構文・純粋計算テストは別途記録。GitHub Pages到達、実ブラウザ、WordPressの表示、モバイル/A4/PDF実機は未確認です。
