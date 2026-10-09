# Git設定のoriginとscopeを安全に観察する

Git 2.26以降（--show-scope対応）を想定。サンプルは`mktemp -d`で作った**一時ディレクトリのGit repoにしか書き込みません**。

```bash
bash show-config-source.sh
```

`GIT_CONFIG_NOSYSTEM=1`と`GIT_CONFIG_GLOBAL=/dev/null`により、一般のsystem/global設定を読むことなく`local`と`command`の違いに絞って実験します。終了時に一時ディレクトリを削除します。

結果の中の`file:/tmp/...`のパスは実行ごとに異なります。

```text
=== local setting ===
local   file:/tmp/.../.git/config  Sample Local
=== command-line override ===
command command line:        Sample Override
```

正確なラベルや区切りはGitバージョンに依存するため、期待値を照合してください。

本物の`git config --list`には個人名、メールアドレス、credential.helper、社内プロキシなどが出ることがあります。生ログをブログやGitHubに貼らないでください。

- https://git-scm.com/docs/git-config
- https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration

**検証：Git公式仕様確認済み。Ubuntu実機未実行。**
