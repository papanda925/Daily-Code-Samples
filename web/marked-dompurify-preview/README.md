# MarkedとDOMPurifyでMarkdownライブプレビュー：HTMLの無害化を体験

## ライブデモ

[GitHub Pages デモ（現在未公開）](https://papanda925.github.io/Daily-Code-Samples/demos/marked-dompurify-preview/)

GitHub Pages URLは正本にGitHub保存された後だけ到達可能。2026-10-27現在は未公開。

## まず試す

1. `docs/demos/marked-dompurify-preview/index.html`と`app.js`を同じディレクトリに置く。
2. Pythonが使えるならフォルダの親から `python -m http.server 8000` を起動し `http://localhost:8000/` で開く。
3. Markdownを入力すると安全化したHTMLプレビューを表示する。
4. `SUCCESS` / `RUNNING` / `FAILED` の結果と画面の変化を照合する。現時点では実ブラウザ未検証。

## ここを見る

- [JavaScript本体](../../docs/demos/marked-dompurify-preview/app.js)
- [HTML画面](../../docs/demos/marked-dompurify-preview/index.html)
- ポイント：MarkedのparseはMarkdownテキストからHTML文字列を生成します。Markdown自体にHTMLを含められるため、解析結果へonerrorなどのイベント属性が混ざることもあります。MarkedはそのHTMLの無害化を行いません。ブラウザで生成結果をinnerHTMLへ渡す前にDOMPurify.sanitizeで安全な要素へ制限します。今回のデモでは画像・iframe・style・scriptをさらに禁止し、外部リンクもクリック不可にします。これは教材用の制限であり、用途によって許す要素を明確に設計する必要があります。

## 1か所変えてみる

入力へ通常の太字を追加するとstrong要素へ変換されます。一方、画像を含むMarkdownを入力しても、デモでは画像を表示させません。これはあえて外部画像の読み込みを禁止したためです。公開CMSへ組み込む場合は必要なタグだけを許可し、URLのプロトコルとリンクの属性も確認します。Markdown構文とHTMLの許可規則を分けて変更できることが重要です。

## 仕事で使うなら

技術ドキュメントのプレビュー、メモ帳、軽量CMS、社内Wikiの試作などに応用できます。実際の編集権限、改訂履歴、公開フロー、ロールバック、悪意あるファイルのアップロード防止などは別の業務要件です。プレビュー用のライブラリを選ぶだけでは公開基盤全体の安全性は完成しません。

## 注意点・失敗しやすい点

Markdownの変換ライブラリを通ったからといって「安全」と判断するのは誤りです。HTML文字列を加工した後に再び安全でないHTMLを結合すると、無害化した意味が失われます。実務ではHTML Sanitizerの更新、CSP、Trusted Typesなども検討対象です。ユーザー入力をそのまま公開する場合はブラウザだけでなくサーバー側にも適切な検証が必要です。今回のサンプルは簡単なブラウザ表示の実験であり、安全性保証やペネトレーションテストの代わりにはなりません。

- 外部CDNは初回読み込み時の通信が必要。オフラインでは動作しない。
- 一次情報：[MarkedとDOMPurify公式](https://github.com/markedjs/marked)
- 静的構文チェック以外の動作結果は未確認。実際に確認するまで成功例と断定しない。
