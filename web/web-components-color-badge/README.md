# Web Components：自作バッジを組み立てる

独自HTMLタグを作り、属性を変えるだけでShadow DOM内の見た目が変わることを確認します。 初心者でも操作と結果を比較できる、ブラウザー実行型の教材です。

## ライブデモ
[操作する（GitHub Pages）](https://papanda925.github.io/Daily-Code-Samples/demos/web-components-color-badge/)

公開URLは配置先を示します。**実際のGitHub Pages到達とブラウザー操作は未検証**です。

## まず試す
1. バッジの文言を「公開待ち」に変える。
2. 色を青からピンクへ切り替える。
3. 下に表示されるcolor-badgeタグの属性を観察。

**期待結果**：テキストと背景色がその場で変わり、HTML側はcolor-badgeという独自要素のまま。

## しくみ
customElements.defineで独自要素を登録。attachShadowでスタイル領域を隔離し、observedAttributesで属性変更を受ける。

## 実装ファイル
- [HTML](../../docs/demos/web-components-color-badge/index.html)
- [JavaScript](../../docs/demos/web-components-color-badge/app.js)
- [共通スタイル](../../docs/demos/_shared/interactive-lab.css)

## 変更実験
tonesオブジェクトへorangeを追加し選択肢も追加する。

## 動かない場合
変化がないときはブラウザーのCustom Elements対応を確認。タグ名にはハイフンが必要。customElements.defineを二重実行すると例外になる。

## 安全と検証
外部通信・データ保存なし。入力はtextContentで描画しHTMLとして実行しない。
- 今回は実装内容とリンク・操作の対応を静的に確認。GitHub Actions・有料APIは使わない。
- ブラウザー実行とGitHub Pages配信の実証は未実施。実機テスト済みと表現しない。

## 仕事での応用
入力を変えたとき何が起きるかを明確に示すUIのプロトタイプや社内研修教材に応用できます。

## 公式資料
- https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements
- https://developer.mozilla.org/en-US/docs/Web/API/Element/attachShadow

**対応するブログ記事ID（計画）**：20261125-09。ブログ公開はUbuntuの既設Publisherが担当し、このREADMEの保存だけで公開済みとはしません。
