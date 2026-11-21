# SVG Filters：水面がゆがむ

SVGのノイズと置換フィルターを組み合わせ、波紋の細かさと強さを操作します。 初心者でも操作と結果を比較できる、ブラウザー実行型の教材です。

## ライブデモ
[操作する（GitHub Pages）](https://papanda925.github.io/Daily-Code-Samples/demos/svg-water-ripple/)

公開URLは配置先を示します。**実際のGitHub Pages到達とブラウザー操作は未検証**です。

## まず試す
1. 波の強さを0にして元画像を見る。
2. 75へ上げて縁の歪みを確認する。
3. 細かさを1から9に変更する。

**期待結果**：強さ0では輪郭が滑らか、75で大きく揺らぐ。細かさを上げるとノイズの波の刻みが細かくなる。

## しくみ
feTurbulenceがノイズ画像を作り、feDisplacementMapがそれを置換量に変換する。imgではなくSVG属性をスライダーから直接更新。

## 実装ファイル
- [HTML](../../docs/demos/svg-water-ripple/index.html)
- [JavaScript](../../docs/demos/svg-water-ripple/app.js)
- [共通スタイル](../../docs/demos/_shared/interactive-lab.css)

## 変更実験
feTurbulenceのnumOctavesを2から4へ変更してざらつきを比較。

## 動かない場合
変化が小さいときはscaleを50以上へ。SVGフィルター非対応や古いブラウザーでは効果が出ない場合がある。

## 安全と検証
SVGは固定図形だけを使用。画像アップロード・通信・保存なし。
- 今回は実装内容とリンク・操作の対応を静的に確認。GitHub Actions・有料APIは使わない。
- ブラウザー実行とGitHub Pages配信の実証は未実施。実機テスト済みと表現しない。

## 仕事での応用
入力を変えたとき何が起きるかを明確に示すUIのプロトタイプや社内研修教材に応用できます。

## 公式資料
- https://developer.mozilla.org/en-US/docs/Web/SVG/Element/feTurbulence
- https://developer.mozilla.org/en-US/docs/Web/SVG/Element/feDisplacementMap

**対応するブログ記事ID（計画）**：20261125-05。ブログ公開はUbuntuの既設Publisherが担当し、このREADMEの保存だけで公開済みとはしません。
