# PHP関連パッケージの状態・版数を確認する

PHPの上流版数、Ubuntu等の配布パッケージ版数、インストール状態、APTの更新候補を混同しないためのサンプルです。PHP2Shellなどの脆弱性対応で、配布元の通知と自分の環境を照合する材料を集めます。

**脆弱性の自動診断ツールではありません。** 終了コード0でも「修正済み」「安全」とは判定していません。

## 前提条件

- Bash、dpkg-query、apt-cacheを利用できるDebian/Ubuntu系環境。
- Ubuntu 24.04の標準PHP 8.3が既定の確認対象。PPA、独自ビルド、コンテナー、別OSの修正済み版数を推測しません。
- 通常ユーザーで実行。sudo、追加ライブラリ、APIキーは不要です。
- インターネットからの取得、apt update、インストール、設定変更、サービス再起動は行いません。APTの表示は既存のローカルキャッシュに基づきます。

## まず試す

```bash
bash check-php-package-status.sh
```

既定では php8.3-cli / php8.3-fpm / php8.3-common を確認します。実際に使っているパッケージが異なる場合は明示します。

```bash
bash check-php-package-status.sh php8.3-fpm php8.3-common
```

存在しないパッケージを、自動的にインストールしたり別の版へ読み替えたりしません。

## 入出力と見方

次は**架空の表示例**です。実機の更新成功ログではありません。

```text
STATE  PACKAGE  VERSION
installed    php8.3-fpm    8.3.6-0ubuntu0.24.04.13
  Installed: 8.3.6-0ubuntu0.24.04.13
  Candidate: 8.3.6-0ubuntu0.24.04.13
```

- STATEが installed：dpkg上でインストール済みの状態。
- config-files等：設定ファイルが残っていてもパッケージはインストール済みではありません。表示された版数だけで適用済みと判断しません。
- Installed：APTが把握するインストール済み版数。
- Candidate：APTのキャッシュが示す更新候補。候補の存在は更新済みの証明ではなく、キャッシュ自体が古い可能性もあります。
- NOT_FOUND：指定名のパッケージをdpkgの照会で取得できなかった状態。PHPが全くない、安全、更新失敗、などとは一律に判定しません。

PHP本家の8.3.36等と、Ubuntuの8.3.6-0ubuntu0.24.04.13等は同じ版数体系ではありません。照合するOSリリース、配布元、対象パッケージを先に確認してください。後日公開された更新も、配布元の案内に従って確認します。

## 終了コード

| 値 | 意味 |
|---|---|
| 0 | 指定パッケージがinstalledで、必要な状態・候補情報を取得できた。脆弱性対策完了の判定ではない |
| 1 | 未導入の対象、照会失敗、APT情報の欠落がある。出力を確認する |
| 2 | 入力形式または必要コマンドに問題があり、処理を開始できない |

## 1か所変える

コマンドの引数だけを、自分が使うパッケージ名へ変えます。ワイルドカードやオプションは受け付けません。すべての入力形式を確認してから照会します。

## 仕事で使うなら

1. OS、PHPの配布元、Web側で使うPHPの動作方式を確認する。
2. このサンプルで対象パッケージの状態と完全な版数を取得する。
3. OS・製品ベンダーのセキュリティ通知の対象と照合する。
4. Web側のPHPが更新後の実体を使っているか、アプリケーションとログを確認する。

`php -v` は呼び出したCLIの確認です。Web側のPHP-FPMやApacheモジュールと同じとは限りません。このサンプルもWebワーカーの稼働版数や再起動完了は保証しません。

## 注意点・失敗しやすい点

- 修正を含むパッケージがインストール済みでも、過去の侵害がなかったとは判定できません。
- 複数のPHPを併用している場合は、使われている全経路を確認してください。先頭を勝手に正解として選びません。
- dpkg-queryの版数だけでなく状態欄を見ます。
- InstalledとCandidateを取り違えないでください。
- クエリーのエラーを握りつぶして成功にはしません。生の診断文やAPTのリポジトリURLは表示しません。
- 実環境のパッケージ構成・版数も公開範囲に注意してください。結果の外部送信・保存はしません。

## 検証範囲

Bash構文、架空のdpkgデータベース、APT出力の試験データで、installed/config-files/未登録・APT失敗・入力不正・コマンド不足・機密値の非表示を確認するテストを添付しています。実UbuntuのPHP更新、実PHP-FPM、実サイトの安全性は未検証です。

```bash
python3 -m unittest discover -s tests -v
```

## 公式情報・一次情報

- [Ubuntu: USN-8948-1](https://ubuntu.com/security/notices/USN-8948-1)
- [Ubuntu: dpkg-queryの公式マニュアル](https://manpages.ubuntu.com/manpages/noble/man1/dpkg-query.1.html)
- [Ubuntu: apt-cacheの公式マニュアル](https://manpages.ubuntu.com/manpages/noble/man8/apt-cache.8.html)
- [PHP: CLIオプション](https://www.php.net/manual/en/features.commandline.options.php)
- [PHP: 公式セキュリティ告知](https://www.php.net/archive/2026.php)
