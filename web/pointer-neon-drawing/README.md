# Pointer Events：光るお絵描き

マウス・タッチ・ペンを同じPointer Eventsで受け取り、光る線を描く教材です。 初心者でも操作と結果を比較できる、ブラウザー実行型の教材です。

## ライブデモ
[操作する（GitHub Pages）](https://papanda925.github.io/Daily-Code-Samples/demos/pointer-neon-drawing/)

公開URLは配置先を示します。**実際のGitHub Pages到達とブラウザー操作は未検証**です。

## まず試す
1. マウスを押しながらキャンバス上を動かす。
2. 「光の強さ」を3から30に変えて描く。
3. 「消去」と「サンプルを描く」を試す。

**期待結果**：線が虹色に変わりながら残る。光の強さでぼかしが変わる。「消去」でキャンバスが空になる。

## しくみ
pointerdown・pointermove・pointerupを統一して受け、Canvas 2DのshadowBlurとstrokeで線を描く。座標は表示サイズから内部座標へ変換。

## 実装ファイル
- [HTML](../../docs/demos/pointer-neon-drawing/index.html)
- [JavaScript](../../docs/demos/pointer-neon-drawing/app.js)
- [共通スタイル](../../docs/demos/_shared/interactive-lab.css)

## 変更実験
app.jsのctx.lineWidth=5を12に変更し線幅を比較。

## 動かない場合
タッチ端末でページが動く場合はcanvasのtouch-action:noneとブラウザーを確認。描画中の線が途切れる場合はpointercancelの発生を調べる。

## 安全と検証
ユーザー操作の座標を描画に使うだけ。カメラ・保存・ネットワークなし。
- 今回は実装内容とリンク・操作の対応を静的に確認。GitHub Actions・有料APIは使わない。
- ブラウザー実行とGitHub Pages配信の実証は未実施。実機テスト済みと表現しない。

## 仕事での応用
入力を変えたとき何が起きるかを明確に示すUIのプロトタイプや社内研修教材に応用できます。

## 公式資料
- https://developer.mozilla.org/en-US/docs/Web/API/Pointer_events
- https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/shadowBlur

**対応するブログ記事ID（計画）**：20261125-02。ブログ公開はUbuntuの既設Publisherが担当し、このREADMEの保存だけで公開済みとはしません。
