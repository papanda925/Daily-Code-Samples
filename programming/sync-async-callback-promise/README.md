# 同期 / Callback / Promise / async-await を実行順で見る

「同期・非同期・Callback・Promiseの違い」を、実際のconsole出力で観察する最小サンプルです。

## すぐ試す: Node.js

```bash
node demo.js
```

## ブラウザでも試せる

`demo.js` の中身をブラウザのDeveloper ToolsのConsoleへ貼り付けても観察できます。

外部APIやネットワーク通信は使いません。

## 観察するポイント

最初の同期部分は、その場で順番に出力されます。

CallbackとPromiseの例では、タイマー完了前に呼び出し元の次の `console.log` が先へ進みます。

`async / await` はPromiseを別物へ変える魔法ではなく、Promiseの結果を受け取る処理を上から読みやすい形にします。

## 実行例

実行環境では概ね次の関係を観察できます。

- A → B → C は同期的に連続
- D の後、Fを待たず E が出る
- G の後、Iを待たず H が出る
- J の後、Kを待たず呼び出し元の L が出る

タイマーやPromiseの細かなscheduler実装を「別thread」と決めつけないのがポイントです。

## 検証

2026-09-07 に Node.js v22.16.0 で実行し、次を確認しました。

- 同期部分がA/B/Cの順で出力
- Callback完了前にEへ進む
- Promise完了前にHへ進む
- await完了前に呼び出し元のLへ進む
- その後Callback / Promise / awaitの結果が表示される

このサンプルは速度比較ではなく、**待ち方と結果の受け取り方の違いを観察する教材**です。
