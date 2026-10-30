# CSVの改行数とレコード数を比較するPythonサンプル

CSVは、引用符で囲まれたセルの中に改行を含められます。そのためファイルの「物理行数」と、CSVとして読み取った「データレコード数」は一致しないことがあります。入力を変更せず、数だけ比較する教材です。

## 前提環境

- Python 3.9以降（標準ライブラリのみ、pip不要）。型注釈の dict[str, int] を使用します。
- Linux/Python 3.13.5で2026-10-30にテスト12件成功。Windows/macOSでは未検証です。
- 読み取り専用。ネットワーク接続・実データ送信・管理者権限は不要。
- UTF-8（BOMあり・なし）を対象。1 MiBを超えるファイルは安全のため処理しません。

## まず試す

サンプルフォルダで次を実行します。

~~~bash
python3 audit_csv.py demo.csv
python3 -m unittest discover -p 'test_*.py' -v
python3 -m py_compile audit_csv.py test_audit_csv.py
~~~

WindowsではPythonの導入状態に応じて python3 を py -3 に読み替えます（Windows実機は未検証）。

期待する出力（Linux/Python 3.13.5で実測）:

~~~text
STATUS=OK
PHYSICAL_LINES=4
CSV_RECORDS=2
HEADER_COLUMNS=2
MULTILINE_RECORDS=1
~~~

demo.csvは、ヘッダー1レコード、データ2レコードの計3レコードです。Aのnote欄に改行が1つ入っているため、物理行は4行です。CSV_RECORDSはヘッダーを含みません。

## ここを見る

- PHYSICAL_LINES: CRLFを1つとして数えたファイル上の物理行数。引用符内の改行も数えます。
- CSV_RECORDS: csv.readerが返すデータレコード数。ヘッダーは除きます。
- MULTILINE_RECORDS: 2物理行以上にまたがるデータレコード数。
- HEADER_COLUMNS: ヘッダーの列数。データ行の列数が違えばエラーにします。
- csv.reader.line_numは「読み取った物理行」の位置であり、データレコードの通し番号ではありません。

## 1か所変える

demo.csvのAのnoteを1行の「line1」に変えて別名のCSVを作り、同じコマンドを実行してください。期待値はPHYSICAL_LINES=3、CSV_RECORDS=2、MULTILINE_RECORDS=0です。元のdemo.csvは保持してください。

## 失敗時の切り分け

| 表示 | 原因候補・確認点 |
| --- | --- |
| STATUS=INVALID_CSV ISSUE=FIELD_COUNT_MISMATCH（exit 2） | データレコードの列数がヘッダーと違う。区切り文字や引用符を確認。 |
| STATUS=INVALID_CSV ISSUE=PARSE_OR_ENCODING_ERROR（exit 2） | 引用符の閉じ忘れ、不正UTF-8など。データ本文は出力しません。 |
| STATUS=INVALID_CSV ISSUE=EMPTY_OR_NO_HEADER（exit 2） | 空ファイル、ヘッダーがない入力。 |
| STATUS=READ_ERROR ISSUE=READ_ERROR（exit 3） | ファイル不存在、権限不足、パスの指定ミスなど。 |
| STATUS=READ_ERROR ISSUE=TOO_LARGE（exit 3） | 1 MiBを超えた。小さい架空ファイルで試す。 |

## 仕事で使うなら

物理行数だけで受注件数や取込件数を推定しないでください。CSVの形式、文字コード、ヘッダーの有無、空行、複数行セル、列数の整合を確認します。本サンプルは数を調べる教材であり、データ内容の正しさ、スキーマ、機密情報の安全性を保証しません。ファイル全体をメモリへ読み込むため、サイズ上限があります。巨大ファイルの検査にはストリーミング方式を別途設計してください。

## 検証記録

2026-10-30: 隔離Linuxコンテナ Python 3.13.5。unittest 12件成功、py_compile成功、demo.csvのCLI終了0、存在しないファイルのCLI終了3。Codex CLIは起動していません。GitHub Actionsは起動していません。Windows/macOS、1 MiBを超える実ファイル、実業務データは未検証です。

## 公式情報

- Python公式 csv.reader / newline='' / line_num: https://docs.python.org/ja/3.13/library/csv.html
- Python公式 argparse: https://docs.python.org/ja/3.13/library/argparse.html
- Python公式 unittest: https://docs.python.org/ja/3.13/library/unittest.html
