# Microsoft GraphへBearerトークンを付けて送るHTTPリクエスト例

papanda925.com の記事で使うコード／リクエスト例を、再利用しやすい形で保存したサンプルです。

- 元記事ID: `20260906-08`
- 分類: `network`
- 検証状態: 記事制作時の構文・ロジック確認を引き継ぎます。実機確認済みと明記していないものは、自分の環境で確認してください。

## ファイル

- `request.http`

## 注意

実アクセストークン、個人情報、組織固有の値はコミットしないでください。サンプル中のプレースホルダーは自分の検証環境に合わせて置き換えます。

## このサンプルで分かること

`request.http` は Microsoft Graph の `GET /v1.0/me` 要求の**書式だけ**を示すテンプレートです。`Authorization: Bearer <access-token>` はプレースホルダーであり、このまま動作する要求ではありません。

## ファイルと確認手順

1. [request.http](request.http) をテキストエディターで開きます。
2. リクエスト行、`Host: graph.microsoft.com`、`Authorization` の3行を確認します。
3. `/me` はサインインした本人の情報を取得するエンドポイントで、実際の送信には適切な認可とアクセス権が必要だと理解します。

**期待結果**：実行ではなく、HTTP要求の構造を説明できること。リポジトリ内のコードだけではAPI応答は得られません。

## 失敗時・安全上の注意

認証エラーが出ても実トークンをREADME、Git、スクリーンショットやログへ貼り付けないでください。トークンは秘密情報です。実テナントでの送信・権限検査は実施していません。関連仕様：[Microsoft Graph /me](https://learn.microsoft.com/en-us/graph/api/user-get)、[Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/access-tokens)。

## 検証

2026-10-31：`request.http` の3行をGitHub上で読み取り確認。実ネットワーク要求・認証試験は未実施。
