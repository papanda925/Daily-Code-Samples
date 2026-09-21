# URLエンコードをencodeURIComponentで観察する

## まず試す

ブラウザの開発者ツールConsoleで実行します。

```javascript
const value = '東京駅 A&B';
const encoded = encodeURIComponent(value);
console.log('[START]', value);
console.log('[RESULT]', encoded);
console.log('[SUCCESS]', decodeURIComponent(encoded));
```

## ここを見る

空白、日本語、`&` がそのままではなく `%` を含む表現へ変わります。復号すると元の文字列へ戻ります。

## 1か所変える

`A&B` を `A=B` へ変え、予約文字の変化を観察します。

## 仕事で使うなら

検索URLやAPI query parameterを組み立てるときに使います。URL全体をencodeURIComponentへ渡すのではなく、通常は値の部分をエンコードします。

## 注意点

秘密情報をURL queryへ入れる設計は避けてください。履歴やログへ残る可能性があります。

検証状態: 実装済み・ブラウザ実機未確認。
