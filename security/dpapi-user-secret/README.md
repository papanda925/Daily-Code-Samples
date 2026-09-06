# Windows DPAPIで現在ユーザー向けに秘密文字列を保護する

Windows PowerShell 5.1から .NET の `ProtectedData` を使い、秘密文字列を現在のWindowsユーザーにひも付けて暗号化・復号します。

## 実行例

保護:

```powershell
./Protect-Secret.ps1 -Mode Protect -Path .\secret.bin
```

復号:

```powershell
./Protect-Secret.ps1 -Mode Unprotect -Path .\secret.bin
```

## 注意

- これはWindows DPAPIのCurrentUserスコープを使う教材です。
- 同じユーザーなら復号できるため、万能な秘密管理ではありません。
- 復号結果をコンソールに出す処理は学習用です。実運用ではログへ残さないでください。
- Gitやクラウド共有へ秘密ファイルを無条件に置かないでください。

## 検証状態

Microsoft LearnのProtectedData仕様を確認して実装。Windows PowerShell 5.1実機確認は未実施です。
