# curl + jqでJSON APIの必要項目だけ確認する

Ubuntuで `curl` と `jq` を組み合わせ、JSON APIから必要な項目だけを抜き出す最小サンプルです。

## 使い方

```bash
./check-repo.sh
./check-repo.sh openai/openai-python
```

GitHubの公開Repository APIを例に、`full_name`、`visibility`、`default_branch`、`language`、`updated_at` だけを表示します。

## 前提

`jq` がない場合はUbuntuで次のように導入できます。

```bash
sudo apt update
sudo apt install -y jq
```

## 検証状態

curl / jq / GitHub REST APIの公開仕様に沿ったサンプル。対象Ubuntu実機での再確認は未実施です。
