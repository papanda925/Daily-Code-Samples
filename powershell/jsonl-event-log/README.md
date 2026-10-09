# PowerShellでJSON Lines（JSONL）を追記・検査する

PowerShell 7以降向け。ダミーイベント2件をUTF-8（BOMなし）のJSONLへ追記し、わざと壊れた行を追加して、正常な行だけを読み込む教材です。

**状態: implemented／PowerShell実機による実行確認は未実施。** 以下は期待結果の例です。

## まず試す

PowerShell 7以降で、このフォルダーから実行します。外部モジュール、管理者権限、ネットワーク接続は不要です。

```powershell
./Write-ReadJsonlDemo.ps1
```

期待される出力例:

```text
[OK] line=1 event_id=evt-001 status=START
[OK] line=2 event_id=evt-002 status=DONE
WARNING: line 3: invalid record (details omitted)
[RESULT] valid=2 invalid=1
```

WARNINGの見え方はホストによって変わります。

## なぜこの順番なのか

1. ランダム名の新規一時フォルダーを作成。既存ログに触れません。
2. ConvertTo-Json -Compress -Depth 5 で1件を改行のないJSON文字列にします。
3. Add-Content -Encoding utf8NoBOM で1行ずつ追記します。
4. 不正なJSONを意図的に1行追記します。
5. Get-Contentで読み込み、ConvertFrom-Jsonのエラーを行単位で捕捉します。
6. 既定ではfinallyで、この処理が新規作成した一時フォルダーだけを削除します。

## 1か所変える

不正な1行のAdd-Contentをコメントアウトし、再実行してみてください。期待結果が valid=2 invalid=0 に変わります。

生成したJSONLを自分で確認したい場合:

```powershell
./Write-ReadJsonlDemo.ps1 -KeepFiles
```

最後の [FILE] に表示されたパスを調べ、確認後は自分で削除してください。

## JSONLの仕様と限界

- UTF-8、BOMなし。1行に有効なJSON値を1つ保存します。空行は不正です。
- LF区切りが基本で、CRLFも読み取れます。
- JSON配列ファイルとは異なります。
- このサンプルは単一プロセス・少量のローカル学習データ用です。複数プロセスの同時追記、途中書込みの復旧、ローテーション、耐改ざん性を保証しません。
- 本番ログではイベントIDの重複、PIIや秘密情報、ディスク容量、アクセス権、保存期間を別途設計してください。

## 一次情報

- [JSON Lines — format requirements](https://jsonlines.org/)
- [Microsoft Learn — ConvertTo-Json](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertto-json)
- [Microsoft Learn — ConvertFrom-Json](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/convertfrom-json)
- [Microsoft Learn — Add-Content](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/add-content)
- [Microsoft Learn — Get-Content](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-content)
