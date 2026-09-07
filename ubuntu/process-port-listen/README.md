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

## ローカル確認記録

2026-09-07に次の環境でロジック確認を実施しました。

- Debian GNU/Linux 13 (trixie)
- Bash 5.2.37
- iproute2 / `ss` 6.15.0
- `bash -n`: 成功
- 未使用ポートを指定: `No listening TCP socket found` を確認
- 不正入力 `abc`: exit code 2 を確認
- localhostで一時TCPサーバーを起動: LISTEN socketとpython3のPID/process表示を確認

Ubuntu実機での確認ではないため、記事側は「実機確認済み」ではなくロジック確認済みとして扱います。

## 公式・一次情報

- [ss(8) — Linux manual page](https://www.man7.org/linux/man-pages/man8/ss.8.html)
