# PythonでZIPを展開せず事前点検する

受領したZIPをすぐに展開せず、中央ディレクトリのメタデータだけを読み、疑わしいパス・重複名・展開後サイズ・高圧縮率・Unixシンボリックリンクを表示する教材です。ZIP内のデータは解凍・書込みしません。

## 前提環境
- Python 3.9以上（標準ライブラリのみ）。開発・検証環境: Python 3.13.5 / Linux。
- 読み取り権限のあるZIPファイル。管理者権限は不要。
- 判定結果は安全性の証明ではありません。サイズ等はZIPヘッダーの申告値です。ウイルス、暗号化、破損データ、ZIP内ファイル内容、展開先のシンボリックリンクやTOCTOUは検査しません。

## まず試す
作業フォルダで、ダミーZIPを作成します。実在の文書は使いません。

~~~sh
python3 - <<'PY'
from zipfile import ZipFile
with ZipFile('demo.zip', 'w') as z:
    z.writestr('docs/hello.txt', 'hello')
PY
python3 audit_zip.py demo.zip
~~~

期待結果（正常なメタデータの例）:
~~~text
entries=1 declared_uncompressed_bytes=5
RESULT=NO_METADATA_FLAGS
~~~

次に疑わしい相対パスのZIPを作ります。
~~~sh
python3 - <<'PY'
from zipfile import ZipFile
with ZipFile('suspicious.zip', 'w') as z:
    z.writestr('../outside.txt', 'example')
PY
python3 audit_zip.py suspicious.zip
~~~

期待結果: WARN: unsafe_path_component:'../outside.txt' と RESULT=REVIEW_REQUIRED。終了コードは1です。

## ここを見る
ZipFile.infolist() はZIPエントリーの情報を返します。ZipInfo.filename、file_size、compress_size、create_system、external_attr を使い、内容を開かずに判定します。ZIP名の特殊文字や破損の異常は、この簡易版では網羅しません。

- absolute_or_drive_path: /...、C:/...、UNC等
- unsafe_path_component: ..、.、空要素、コロン等
- duplicate_or_case_collision: 同名または大文字小文字のみ違う名前（Windowsで衝突し得る）
- unix_symlink: Unix属性上のシンボリックリンク
- entry_count_exceeded、declared_size_exceeded、compression_ratio_exceeded: 指定上限超過

## 1か所変えてみる
~~~sh
python3 audit_zip.py demo.zip --max-bytes 4
~~~
5バイトのファイルに対し declared_size_exceeded:5>4 が表示されます。上限は --max-entries、--max-bytes、--max-ratio で変更できます。

## テスト
~~~sh
python3 -m unittest -v test_audit_zip.py
python3 -m py_compile audit_zip.py test_audit_zip.py
~~~
開発時の実測: Python 3.13.5 / Linuxで unittest 16件成功、構文検査成功。GitHub Actionsでの実行結果とは別です。Codex CLIは実行していません。

## 終了コード・失敗時の切り分け
| コード | 意味 | 確認点 |
|---|---|---|
| 0 | メタデータ上の警告なし | 内容の安全性まで保証しない |
| 1 | 警告あり | WARN の種類、受領元、展開要否を確認 |
| 2 | ZIPを開けない等 | パス、権限、ファイル破損、ZIP形式を確認 |

オプション不正は argparse により終了コード2です。

## 仕事で使うなら
このコードは受領時の一次スクリーニング専用です。実際の展開時は別途、展開先の権限分離、ファイルサイズ上限の強制、ファイル内容検査、抽出後のファイル種別確認を実施してください。Python標準の extractall() を無条件に呼ぶことを推奨する教材ではありません。

## 一次情報
- [Python 3.13 — zipfile](https://docs.python.org/3.13/library/zipfile.html)
- [Python 3.13 — pathlib](https://docs.python.org/3.13/library/pathlib.html)
- [Python 3.13 — stat](https://docs.python.org/3.13/library/stat.html)
