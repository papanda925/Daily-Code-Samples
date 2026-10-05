# Linux flock と Windows Named Mutex で二重起動を止める

同じ処理を2つ同時に起動し、2つ目がロックを取得できないことを観察する安全なサンプルです。

## Linux

ターミナル1:

```bash
./flock-demo.sh /tmp/papanda-flock-demo.lock 10
```

10秒以内にターミナル2から同じコマンドを実行します。2つ目は `[BLOCKED]` で終了します。

このLinuxサンプルは実行確認済みです。

## Windows PowerShell

PowerShellを2つ開き、両方で次を実行します。

```powershell
./mutex-demo.ps1
```

1つ目がNamed Mutexを保持している間、2つ目は `[BLOCKED]` になります。

Windows実機確認は未実施です。.NETのMutex仕様を確認して作成しています。

## 注意

ロックファイルの「名前」と、カーネルが保持するロックは同じものではありません。実運用中のlockファイルを「邪魔だから削除する」という扱いは避けてください。

複数ロックを使う場合は取得順序を統一し、タイムアウトや保持時間も設計します。
