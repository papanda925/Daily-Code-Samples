# CSS View Transitions：カードが変身する

カードを拡大・縮小して、DOM更新を滑らかにつなぐ仕組みを観察します。 初心者でも操作と結果を比較できる、ブラウザー実行型の教材です。

## ライブデモ
[操作する（GitHub Pages）](https://papanda925.github.io/Daily-Code-Samples/demos/view-transition-card-morph/)

公開URLは配置先を示します。**実際のGitHub Pages到達とブラウザー操作は未検証**です。

## まず試す
1. 「カードを変身」を押す。
2. 拡大状態からもう一度押して戻す。
3. 色相スライダーを動かし背景色を変える。

**期待結果**：カードが左右2列から幅いっぱいに広がり、対応ブラウザーでは移行アニメーションが見える。未対応では瞬時に切り替わる。

## しくみ
document.startViewTransition()はDOMの変更前後を捉える。view-transition-nameを1要素へ与えると対応関係を指定できる。

## 実装ファイル
- [HTML](../../docs/demos/view-transition-card-morph/index.html)
- [JavaScript](../../docs/demos/view-transition-card-morph/app.js)
- [共通スタイル](../../docs/demos/_shared/interactive-lab.css)

## 変更実験
CSSのborder-radius:54pxを8pxへ変え、角の丸みの変化を比較。

## 動かない場合
動きがない場合はView Transitions API非対応、またはOSの動き低減設定を確認。色だけが変わる場合はカードを押す。

## 安全と検証
通信・権限・保存なし。激しい点滅は使わずOSの動き低減設定を尊重。
- 今回は実装内容とリンク・操作の対応を静的に確認。GitHub Actions・有料APIは使わない。
- ブラウザー実行とGitHub Pages配信の実証は未実施。実機テスト済みと表現しない。

## 仕事での応用
入力を変えたとき何が起きるかを明確に示すUIのプロトタイプや社内研修教材に応用できます。

## 公式資料
- https://developer.mozilla.org/en-US/docs/Web/API/Document/startViewTransition
- https://developer.mozilla.org/en-US/docs/Web/CSS/view-transition-name

**対応するブログ記事ID（計画）**：20261125-01。ブログ公開はUbuntuの既設Publisherが担当し、このREADMEの保存だけで公開済みとはしません。
