# 同じサイトの別タブへ表示設定を伝える｜BroadcastChannel

同じサイトを開いた2タブで、`dark` / `light` の通知を送り、カードの配色が変わる流れを試すブラウザー教材です。対象はBroadcastChannelを初めて使うJavaScript初学者です。

記事ID: `20261128-87-02`

## ライブデモ

[BroadcastChannelを2タブで試す](https://papanda925.github.io/Daily-Code-Samples/demos/broadcastchannel-theme/#live)

実装ファイル: [公開HTML](../../docs/demos/broadcastchannel-theme/index.html) · [共通JavaScriptの ID 53](../../docs/demos/browser-library-labs/daily.js)

## 試し方と期待結果

1. 同じ公開URLを同じブラウザーの2タブで開きます。localhost版とGitHub Pages版を混ぜないでください。
2. 両方で「実行」を押します。各タブに見本カードが出て「受信待ち」になります。
3. 片方の入力欄へ `dark` を入れて「送信」を押すと、送信元と相手側のカードが濃い色に変わります。
4. `light` を送ると、両方が明るい配色に戻ります。`DARK`、空欄、空白付きなど `dark` 以外はすべて `light` になります。
5. 送信後に開いたタブには過去のメッセージは再生されません。受信側を先に起動して比べます。

同じオリジンのチャネルに参加した別オブジェクトがmessageイベントを受けます。送信元のオブジェクト自身にはイベントが届かないため、コードは送信ボタン内でもカードを更新します。HTML Standardは同じstorage keyを持つチャネルへ配信を制限するので、埋め込み状況などで範囲が変わる場合があります。

## コードの見どころ

デモは `new BroadcastChannel('DailyCode53')` で参加し、`onmessage` で受信します。送信値が厳密に `dark` なら濃い色、それ以外は明るい色にして、`postMessage()` で文字列を通知します。教材のリセット処理では `close()` を呼びます。

- メッセージは後から参加したタブへ再送されず、保存されません。必要な初期値は別に取得します。
- チャネル名は認証ではありません。同じオリジンで同じ名前を使うスクリプトが参加できるため、秘密や個人情報を送りません。
- 受信処理が同じメッセージを再送しないよう、通知と状態変更を分けます。
- この教材は見本カードを変えるだけです。設定の永続化やサーバー同期は行いません。

## 失敗時の確認

- 相手側が変わらない: 両方で「実行」したあと「送信」したか、同じ公開オリジンか確認します。
- 入力が暗色にならない: 小文字の `dark` と完全一致しているか確認します。
- APIが使えない: 現行ブラウザーのトップレベルページで確認します。ブラウザー別実機試験は未実施です。
- Mermaidの図が見えない: 図の描画は外部CDNに依存します。本文とHTMLの図ソースを参照します。

## 出典・ライセンス・プライバシー

- [WHATWG HTML Standard: Broadcasting to other browsing contexts](https://html.spec.whatwg.org/multipage/web-messaging.html#broadcasting-to-other-browsing-contexts)
- [MDN: BroadcastChannel](https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel)
- [MDN: BroadcastChannel.postMessage()](https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel/postMessage)
- [MDN: BroadcastChannel.close()](https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel/close)
- [Mermaid v11.12.2 License (MIT)](https://github.com/mermaid-js/mermaid/blob/mermaid%4011.12.2/LICENSE)

BroadcastChannelは標準APIで外部ライブラリーではありません。図の描画にはMermaidを外部CDNから読み込みます。テーマ文字列はタブ内のチャネルで扱い、サーバー送信や保存はしません。実データや秘密値を入力しないでください。

関連記事ID: `20261128-87-02`。記事本文はBlog-Ideasの `content/articles/20261128-87-02/body.md` にあります。

## 検証

実施: Node.js 24で構文検査とBroadcastChannelの2オブジェクト間メッセージ確認。HTMLParserで `#live`、`#input`、`#run` を確認。入力条件、記事・HTML・READMEの操作名、外部通信の説明を静的照合しました。

未確認: GitHub Pagesのブラウザー表示・実操作、異なるブラウザー間の試験、第三者コンテキストのpartition差、支援技術、Mermaid描画。Node.js検査はブラウザー試験の代わりではありません。
