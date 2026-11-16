# JSZipで架空のテキスト2〜3件をZIPにまとめる

## ライブデモ

https://papanda925.github.io/Daily-Code-Samples/demos/jszip-local-bundle/

制作時点で**GitHub Pagesの到達と実ブラウザーの生成動作は未確認**。HTML・JavaScript・JSZip本体をGitHub Pages `main/docs` に静的配信する構成です。

## 最初の実験

1. 架空のメモ文章を入力する（最大200字）。
2. 「ZIPを作成」を押す。入力文章を含む `memo.txt` と固定 `README.txt` の2ファイルがZIPへ入る。
3. 「チェックリストも含める」を選んで再度作ると `checklist.txt` が加わり3ファイルになる。
4. ブラウザーが表示するサイズ（バイト数）が変わることを観察する。ZIP圧縮後のサイズは文字種・長さ等により異なる。
5. 「ZIPをダウンロード」のクリックは利用者の操作である。JavaScriptはサーバーへアップロードしない。

## ファイルと安全性

- `docs/demos/jszip-local-bundle/index.html`：操作画面
- `docs/demos/jszip-local-bundle/logic.mjs`：固定ファイル名と入力境界（純粋関数）
- `docs/demos/jszip-local-bundle/app.mjs`：JSZip.generateAsyncとBlob URLの生成、旧URLの解放
- `docs/demos/jszip-local-bundle/vendor/jszip.min.js`：版固定の第三者製ライブラリ
- `docs/demos/jszip-local-bundle/vendor/LICENSE.markdown`：ライセンス全文
- `web/jszip-local-bundle/tests/logic.test.mjs`：Node標準ランナーのロジック試験

ユーザーが指定できるのは`memo.txt`のテキスト内容だけ。**ZIP内部のファイル名は固定**しており、入力からパス名を組み立てない。Blob URLは再生成時とページ離脱時に解放する。実機でのメモリー解放・OS固有の保存操作は未確認。ZIP内のテキストを閲覧できる人には内容が読めるため、機密情報は入力しない。

## 検証

`node --test web/jszip-local-bundle/tests/logic.test.mjs` をリポジトリルートで実行すると、2/3件の生成予定、長さ制限、空欄、型検査、ファイル名固定、絵文字文字数のテストを実行できる。**テスト対象は入力と名前付けのロジックで、ZIPバイナリのブラウザー生成の実機試験とは別**。

ローカル実行はリポジトリルートから `python3 -m http.server 8000 -d docs` 、`http://localhost:8000/demos/jszip-local-bundle/` をブラウザーで開く。`file://`ではES modulesが拒否されることがある。

## ライブラリ出典とライセンス

- [JSZip公式](https://stuk.github.io/jszip/)
- [JSZip v3.10.2のタグ](https://github.com/Stuk/jszip/tree/v3.10.2)
- 選択ライセンス：MIT（JSZipはMITまたはGPLv3から選択）
- `vendor/jszip.min.js` Git blob SHA：`cf35e3c945d9600ce6795552eca87eac570b8ec2`
- `vendor/LICENSE.markdown` Git blob SHA：`f8250b37a61862ea61ea9a93d5d423cad395a364`
- 実行時にCDNや外部APIへの接続は不要。通常の静的Web配信は必要。
- [公式API generateAsync](https://stuk.github.io/jszip/documentation/api_jszip/generate_async.html)
- [公式API file](https://stuk.github.io/jszip/documentation/api_jszip/file_data.html)

この教材はブラウザーでZIPを作る考え方の学習用です。暗号化・パスワード保護・ウイルス検査・バックアップ保存の代わりではありません。
