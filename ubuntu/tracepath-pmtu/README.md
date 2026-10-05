# Linux tracepathで経路とPath MTUを確認する

`tracepath` で宛先までのhopとPath MTU（PMTU）を観察するサンプルです。

## 実行

```bash
./check-tracepath.sh example.com
```

直接試す場合:

```bash
tracepath example.com
tracepath -n example.com
tracepath -4 example.com
tracepath -6 example.com
```

## 観察ポイント

- hop番号と応答元
- `pmtu` 表示
- `resume` / 最終サマリー
- `-n` で名前解決を省いたときの違い
- IPv4 / IPv6の経路差

## 注意

経路はネットワーク、VPN、FW、ISP、時刻によって変わります。出力例を固定の正解として扱わず、自分の環境の結果を読みます。

## 検証状態

iputils tracepathの一次資料を確認済みです。この実行環境にはtracepathコマンドがないため、実通信テストは未実施です。
