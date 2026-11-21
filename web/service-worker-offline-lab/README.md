# Service Worker：オフラインページを体験する

ページを自分のブラウザーに保存し、ネット接続を切ったときの読み込み動作を観察します。 初心者でも操作と結果を比較できる、ブラウザー実行型の教材です。

## ライブデモ
[操作する（GitHub Pages）](https://papanda925.github.io/Daily-Code-Samples/demos/service-worker-offline-lab/)

公開URLは配置先を示します。**実際のGitHub Pages到達とブラウザー操作は未検証**です。

## まず試す
1. HTTPSのGitHub Pagesで「オフライン準備」を押す。
2. ページを再読み込みしてから開発者ツールのネットワークをOfflineにする。
3. 再読み込みできるかを確かめ、最後にオンラインへ戻して「キャッシュを消す」。

**期待結果**：登録後の再読み込みでService Workerがページを制御し、キャッシュされた教材がオフラインでも開けることがある。解除後のオフライン再読み込みは失敗する。

## しくみ
Service Workerはページの外側でfetchを仲介し、CacheStorageに教材のHTML・JS・CSSを保存する。スコープはこの教材フォルダだけ。

## 実装ファイル
- [HTML](../../docs/demos/service-worker-offline-lab/index.html)
- [JavaScript](../../docs/demos/service-worker-offline-lab/app.js)
- [Service Worker](../../docs/demos/service-worker-offline-lab/sw.js)
- [共通スタイル](../../docs/demos/_shared/interactive-lab.css)

## 変更実験
sw.jsのキャッシュ名末尾v1をv2に更新し再インストール時のキャッシュ差を観察。

## 動かない場合
localhost以外のHTTPでは登録不可。初回登録後はページ再読み込みが必要なことが多い。ブラウザーの設定でストレージが無効なら失敗。

## 安全と検証
ローカルのCacheStorageに教材ファイルを保存し、解除ボタンでこの教材のキャッシュのみ削除。個人情報は収集しない。他のサイトのキャッシュは触らない。
- 今回は実装内容とリンク・操作の対応を静的に確認。GitHub Actions・有料APIは使わない。
- ブラウザー実行とGitHub Pages配信の実証は未実施。実機テスト済みと表現しない。

## 仕事での応用
現場で通信が切れるアプリの読み取り専用UIの設計を考える入口です。機密情報のキャッシュは別設計が必要です。

## 公式資料
- https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers
- https://developer.mozilla.org/en-US/docs/Web/API/CacheStorage

**対応するブログ記事ID（計画）**：20261125-10。ブログ公開はUbuntuの既設Publisherが担当し、このREADMEの保存だけで公開済みとはしません。
