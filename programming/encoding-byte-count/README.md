# PowerShellでUTF-8とShift_JISのバイト数を比較する

papanda925.com の記事で使うコード／リクエスト例を、再利用しやすい形で保存したサンプルです。

- 元記事ID: `20260906-07`
- 分類: `programming`
- 検証状態: 記事制作時の構文・ロジック確認を引き継ぎます。実機確認済みと明記していないものは、自分の環境で確認してください。

## ファイル

- `Compare-TextByteCount.ps1`

## 注意

実アクセストークン、個人情報、組織固有の値はコミットしないでください。サンプル中のプレースホルダーは自分の検証環境に合わせて置き換えます。

## まず試す

[Compare-TextByteCount.ps1](Compare-TextByteCount.ps1) をPowerShellで実行します。

```powershell
.\Compare-TextByteCount.ps1
```

**期待結果（未実行）**：`ABC` のUTF-8は3バイト、`日本` は6バイト、`A日本` は7バイトです。後半のShift_JIS（コードページ932）では`日本`は4バイトの想定です。`😀` はUTF-8で4バイトですが .NET `String.Length` はUTF-16コード単位2になる点が比較ポイントです。

## 仕組み・注意点

`Encoding.UTF8.GetByteCount` はエンコード後のバイト数、`String.Length` は.NET文字列のUTF-16コード単位数です。文字数や画面上の文字幅とは一致しません。Shift_JISの取得ができない環境では、コードページプロバイダーが使用できるか確認します。実ファイルは読み書きしません。

## うまく動かないとき・検証

`GetEncoding(932)` やプロバイダー登録に失敗したらPowerShell/.NETの種類と環境を確認します。2026-10-31：ソースとの対応を読み取り確認。PowerShellでの実行は未実施。公式：[Encoding.GetByteCount](https://learn.microsoft.com/en-us/dotnet/api/system.text.encoding.getbytecount)。
