# SHA-256の1文字差を可視化する教材

## ライブデモ
[SHA-256を比較する](https://papanda925.github.io/Daily-Code-Samples/demos/sha256-one-character-lab/)（GitHub Pagesの公開・ブラウザ動作は未確認）

## まず試す
1. デモを開き、架空文字列 \`papanda\` と \`papandb\` を「比較する」。
2. 256ビット中の差と、32バイトの差を観察する。
3. Bを \`papanda\` に戻し、差が0になることを予想して比較する。

## ここを見る
- SHA-256は32バイト=256ビット=16進数64桁。
- AとBが同じ文字列なら差分ビットは0。
- 1文字だけ違っても出力の多数のビットが変わり得るが、毎回128ビット差と決まっているわけではない。
- UTF-8では日本語の1文字は一般に複数バイト。バイト数表示も比較する。

## 自分のPCで動かす
\`docs/demos/sha256-one-character-lab/index.html\` と \`app.js\` を同じフォルダに置く。
Web Cryptoは安全なコンテキストが必要なため、HTTPS配信またはlocalhostの開発用サーバーで開く。外部ライブラリ・CDN・APIキーは不要。

## 1か所変える
Bの最後の1文字だけを変えて比較する。元に戻すボタンで再試験する。

## 仕事で使うなら
同じ入力が同じハッシュを返す性質は、ファイル・文字列の変更検出を理解する入り口になる。ただし本教材は文字列専用であり、ファイル整合性や署名、改ざん者への対抗策を提供しない。SHA-256は暗号化でもパスワード保存方式でもない。

## 注意
- 個人情報、秘密、パスワードを入力しない。
- 入力はページ内で計算し、送信・保存・分析しない（外部の配信サーバーのアクセスログまではこの教材では管理しない）。
- 表示・動作・モバイル・印刷/PDFは未実ブラウザ検証。
- \`SubtleCrypto.digest\` は入力全体をメモリに載せる。教材は80文字制限。

## 公式資料
- [MDN SubtleCrypto.digest](https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto/digest)
- [MDN TextEncoder](https://developer.mozilla.org/en-US/docs/Web/API/TextEncoder)
- [W3C Web Cryptography Level 2](https://www.w3.org/TR/WebCryptoAPI/)

ライセンス：本教材の新規サンプルコードはリポジトリのライセンスに従う。第三者ライブラリは使用しない。
