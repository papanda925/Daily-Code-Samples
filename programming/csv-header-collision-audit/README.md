# CSVヘッダーの重複・空列をPythonで検出

CSVを辞書型に読み込む前に、同名列や空欄の列を読み取り専用で検出します。元ファイルは変更しません。列名そのものはログに表示せず、1始まりの列番号だけ表示します。

## 前提環境

- Python 3.10以上。標準ライブラリだけで実行可能
- UTF-8またはUTF-8 BOM付きのカンマ区切りCSV
- ネットワーク接続、管理者権限、追加パッケージは不要
- Shift_JIS、TSV、Excel .xlsx、データ行の検査は対象外

## まず試す

このフォルダで架空のCSVを作り、チェックします。

~~~bash
python3 -c "from pathlib import Path; Path('demo.csv').write_text('id,name,id\n', encoding='utf-8')"
python3 check_csv_headers.py demo.csv
~~~

期待する出力（終了コード1）:

~~~text
FAILED: columns=3 blank_positions=[] duplicate_pairs=[(1, 3)]
~~~

正常例は次のようにdemo.csvだけを置き換えます。

~~~bash
python3 -c "from pathlib import Path; Path('demo.csv').write_text('id,name,amount\n', encoding='utf-8')"
python3 check_csv_headers.py demo.csv
~~~

期待する出力（終了コード0）:

~~~text
OK: columns=3 duplicate_pairs=[] blank_positions=[]
~~~

## 仕組み

- csv.readerでヘッダー行をリストとして読み、重複列名を失わないようにします。
- 既定ではNFKC正規化、前後空白除去、casefoldを適用し、CodeとＣＯＤＥの衝突候補を発見します。
- --exactは正規化せず完全一致だけを検査します。業務上の列名照合仕様と使い分けてください。
- UTF-8 BOMはutf-8-sigで読み、引用符内のカンマはcsv.readerが処理します。
- 正規化で同一になっても、業務上同じ意味の列と確定したわけではありません。

## 実行手順

~~~bash
python3 check_csv_headers.py path/to/input.csv
python3 check_csv_headers.py --exact path/to/input.csv
python3 -m unittest discover -s . -p 'test_*.py' -v
python3 -m py_compile check_csv_headers.py test_check_csv_headers.py
~~~

Windowsではpython3をpy -3または利用可能なpythonへ読み替えます。テストは一時ディレクトリだけにファイルを作ります。

## 終了コード・失敗時の切り分け

| コード | 意味 | 確認すること |
|---|---|---|
| 0 | ヘッダーに重複・空列なし | データ行の整合性までは保証しない |
| 1 | 空列または重複列あり | blank_positionsとduplicate_pairsを原本の列番号と照合 |
| 2 | 読み込み不可 | ファイルの存在、権限、文字コード、空ファイル、CSV構文 |

--exactでは空白だけの列も非空として扱うため、通常は既定の正規化モードを推奨します。CSV内容は修復しません。

## 検証結果と限界

- 2026-10-22、隔離されたPython 3.13.5環境でunittest 7件成功、py_compile成功。使用ツールはローカルシェルとPython標準ライブラリです。
- 正常、完全一致重複、正規化衝突と--exact、BOMと空列、引用符内カンマ、空/不正UTF-8、ファイル不存在を検査しました。
- Codex CLIは実行していません。Windows/macOS、巨大CSV、実データ、Excelや外部連携は未検証です。
- CSVデータ行の列数不一致やCSV式インジェクションは検査しません。

## 公式情報

- [Python csv](https://docs.python.org/3.12/library/csv.html) — reader、DictReader、newline指定
- [Python unicodedata](https://docs.python.org/3.12/library/unicodedata.html) — NFKC正規化

## ブログとの役割分担

ブログ記事は重複ヘッダーの危険と最小例を解説し、このフォルダは再利用可能なCLIと境界テストを提供します。
