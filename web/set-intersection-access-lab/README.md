# Set.intersection()で権限リストの共通部分を調べる

架空の「要求権限」と「許可済み権限」を入力し、両方に含まれるIDを比較する初心者向け教材です。重複した入力が1件にまとめられることと、要求が許可されない場合の差集合を観察できます。

## ライブデモ
[ブラウザで試す（公開先。到達・実ブラウザ動作は未確認）](https://papanda925.github.io/Daily-Code-Samples/demos/set-intersection-access-lab/)

## ファイル
- [デモHTML](../../docs/demos/set-intersection-access-lab/index.html)
- [JavaScript実装](../../docs/demos/set-intersection-access-lab/app.js)

## 実行環境と手順
現行のSet集合演算メソッドに対応したブラウザを使います。ライブラリ、アカウント、ネットワーク通信、権限付与は不要です。
1. ライブデモを開くか、上記HTMLとapp.jsを同じフォルダへ保存してHTMLを開きます。
2. 「要求する権限」に `read, write, delete, read`、「許可済み権限」に `read, export` を入力します。
3. 「照合する」を押し、結果欄を確認します。

## 期待結果と観察ポイント
- 要求数（重複除外）: 3
- 許可数（重複除外）: 2
- 共通: read
- 許可されない要求: delete, write

入力のreadが2回あってもSetでは1件になります。結果の表示順は学習しやすいようにソートしています。

## 仕組みと変更実験
`new Set(...)` は重複を取り除き、`wants.intersection(grants)` は共通要素を新しいSetとして返します。`wants.difference(grants)` は要求側だけに存在する要素を返します。入力を `read, export` に変えると共通が `export, read`、許可されない要求は「なし」になります。元の入力集合は書き換えません。

## うまくいかないとき
- 「未対応」が表示される：`Set.prototype.intersection` の対応状況を確認し、ブラウザを更新してください。古い環境で結果を無理に計算しません。
- 結果が変わらない：「照合する」を押し、カンマが半角か確認してください。大文字小文字は区別します。
- 真っ白になる：index.htmlとapp.jsを同じフォルダに置き、開発者ツールのConsoleで読み込みエラーを確認してください。

## 安全・検証・出典
架空データのみ。外部通信、個人情報の取得、ブラウザ保存、実際のアクセス権変更はありません。これは集合演算の学習用で、認可システムの実装例ではありません。コードの静的レビューを実施。実ブラウザ実行、Pages公開URL到達、全ブラウザ互換性は未確認です。
- [ECMAScript Set.prototype.intersection](https://tc39.es/ecma262/#sec-set.prototype.intersection)
- [MDN Set.prototype.intersection](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set/intersection)
- [MDN Set.prototype.difference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set/difference)

## 対応するブログ記事
記事ID: `20261123-08`。記事では操作、期待値、集合演算の意味と実務上の注意を説明し、このREADMEと実装を完全版として参照します。公開URLは未確定です。
