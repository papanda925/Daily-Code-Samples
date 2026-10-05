# curlでHTTP Rangeを確認する

HTTPサーバーへbyte rangeを要求し、通常レスポンスとの違いを確認するサンプルです。

## 実行

```bash
./check-range.sh https://example.com/large-file.bin 0-99
```

対象URLは自分で管理する検証用ファイルや、Range対応が明示された公開リソースを指定してください。

## 観察ポイント

- `curl --range 0-99` は先頭100byteを要求します。
- サーバーが要求を満たす場合、典型的には `206 Partial Content` と `Content-Range` を確認できます。
- `Accept-Ranges: bytes` はRange要求を受け付けることを示す手掛かりですが、実際の応答はサーバーや中継経路の状態に依存します。
- 範囲外なら `416 Range Not Satisfiable` になる場合があります。
- スクリプトは取得本文を保存せず、ヘッダーを観察します。

## 検証状態

RFC 9110とcurlのRangeオプション仕様を確認済みです。外部サーバーへの実通信テストは未実施です。
