# Pythonで改行コードの混在を検出する

ファイルを読み取り専用で開き、CRLF、LF、CRの出現数を数えます。入力ファイルは変更しません。

## 前提環境
Python 3.9以降。標準ライブラリのみ。

## まず試す
```sh
python -c "from pathlib import Path; Path('demo.txt').write_bytes(b'a\r\nb\nc\r')"
python check_line_endings.py demo.txt
```

期待結果:
```text
CRLF: 1
LF: 1
CR: 1
```

改行が混在していれば終了コード1、1種類以下なら0です。

## ここを見る
CRLFを先に数え、LFとCRのカウントから差し引いて二重計上を防ぎます。

## 1か所変える
入力を `b'a\nb\n'` に変えるとLFのみ2件で終了コード0になります。

## テスト
```sh
python -m unittest -v test_check_line_endings.py
python -m py_compile check_line_endings.py
```

## 仕事で使うなら
CSVや設定ファイルの変換前に点検できます。UTF-16などの多バイト文字コードやバイナリファイルでは誤解釈の可能性があるため、文字コードと形式を別途確認してください。

## 失敗時の切り分け
- ファイルがない: パスを確認
- 権限エラー: 読み取り権限を確認
- すべて0件: 改行なし、またはUTF-16などの可能性
- 終了コード1: 混在を検出した正常な判定

公式情報: https://docs.python.org/3/library/stdtypes.html#bytes.count 、 https://docs.python.org/3/library/pathlib.html#pathlib.Path.read_bytes
