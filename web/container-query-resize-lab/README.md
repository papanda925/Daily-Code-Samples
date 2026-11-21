# CSS Container Queries：幅で変わるカード

ブラウザー全体ではなく、部品の入れ物の幅でカードの見た目が変わることを試します。 初心者でも操作と結果を比較できる、ブラウザー実行型の教材です。

## ライブデモ
[操作する（GitHub Pages）](https://papanda925.github.io/Daily-Code-Samples/demos/container-query-resize-lab/)

公開URLは配置先を示します。**実際のGitHub Pages到達とブラウザー操作は未検証**です。

## まず試す
1. 幅360pxでカードが縦積みになるのを確認。
2. 500px以上に広げ横並びへ切り替える。
3. ブラウザー幅を変えてコンテナー側と比較。

**期待結果**：狭い幅ではアイコンが上、文章が下。広い幅ではアイコンと文章が横並び。

## しくみ
holderのcontainer-type:inline-sizeで包含コンテナーを宣言し、@container(max-width:400px)で内部要素のスタイルを変える。

## 実装ファイル
- [HTML](../../docs/demos/container-query-resize-lab/index.html)
- [JavaScript](../../docs/demos/container-query-resize-lab/app.js)
- [共通スタイル](../../docs/demos/_shared/interactive-lab.css)

## 変更実験
@containerの400pxを300pxへ変更して切替点を観察。

## 動かない場合
変わらない場合は外側の画面が狭くmax-width:100%で上限になっていないか確認。古いブラウザーでは未対応。

## 安全と検証
通信・権限・保存なし。
- 今回は実装内容とリンク・操作の対応を静的に確認。GitHub Actions・有料APIは使わない。
- ブラウザー実行とGitHub Pages配信の実証は未実施。実機テスト済みと表現しない。

## 仕事での応用
入力を変えたとき何が起きるかを明確に示すUIのプロトタイプや社内研修教材に応用できます。

## 公式資料
- https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_containment/Container_size_and_style_queries
- https://developer.mozilla.org/en-US/docs/Web/CSS/@container

**対応するブログ記事ID（計画）**：20261125-08。ブログ公開はUbuntuの既設Publisherが担当し、このREADMEの保存だけで公開済みとはしません。
