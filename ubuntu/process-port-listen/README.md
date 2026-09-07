# Ubuntuで待受ポートとプロセスを確認する

「5000番ポートを誰が使っているか」を `ss` で確認するための小さな診断スクリプトです。

## 使い方

```bash
chmod +x find-listening-port.sh
./find-listening-port.sh 5000
```

プロセス情報が十分に表示されない場合は、必要性を確認したうえで `sudo` を付けます。

```bash
sudo ./find-listening-port.sh 5000
```

## 見る場所

- `LISTEN`: TCP接続を待ち受けている状態
- `Local Address:Port`: 待受IPアドレスとポート
- `Process`: PIDやプロセス名。権限によって見え方が変わる場合があります

## 検証状態

iproute2の `ss(8)` マニュアルでlistening/process表示オプションを確認して実装。対象Ubuntu環境での実行確認は未実施です。

## 公式・一次情報

- [ss(8) — Linux manual page](https://www.man7.org/linux/man-pages/man8/ss.8.html)
