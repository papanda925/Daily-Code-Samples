# 申請JSONのどの項目が不正か表示する｜Zod

Zod 4.6.7 のオブジェクトスキーマで、JSONの `quantity` が数値の整数かを検証します。文字列の `"2"` と数値の `2` の違い、エラーの項目パスを試せます。

対応記事ID: `20261128-79-02`

## ライブデモ

[申請JSONの数量を検証するデモ](https://papanda925.github.io/Daily-Code-Samples/demos/zod-quantity-validation/#live)

## 試し方

1. 初期値 `{"quantity":"2"}` のまま「実行」を押します。
2. 結果にエラーの位置 `quantity` が表示されます。JSONでは引用符の有無で文字列と数値が異なります。
3. `{"quantity":2}` に変えて実行します。整数なので成功し、検証済みデータが表示されます。
4. `{"quantity":2.5}` を試します。数値ではありますが整数ではないため失敗します。
5. `{"quantity":-1}` を試します。このスキーマは整数を求めるだけなので成功します。負数も禁止したい業務なら条件を追加してください。

## 仕組み

`JSON.parse` で文字列をJSON値に変換し、`z.object({ quantity: z.number().int() }).safeParse(...)` でスキーマに照らします。失敗時は `error.issues` の `path` と `message` を画面に表示します。`z.number()` は文字列を自動で数値に直しません。変換したい入力は、型変換を明示し、変換前後をそれぞれテストします。

この教材は Zod **4.6.7** に固定しています。Zod 4では `.int()` がJavaScriptの安全な整数範囲も検査します。極端に大きな整数をJSON Numberに入れると、Zodへ渡る前にJavaScriptで精度が失われる場合があります。非常に大きな整数を扱う設計では、文字列など別の表現を検討してください。

デモはJSON構文の解析を先に行います。そのためJSONとして壊れた入力はZodの項目エラーではなく、JSON.parseの構文エラーになります。項目不足・型違い・小数は、構文が正しいJSONをスキーマが検査します。

## 業務利用での注意

- `z.number().int()` は負数や業務上の最大数を制限しません。必要な場合は `.nonnegative()`、`.positive()`、`.min()`、`.max()` などを要件に合わせて追加します。
- ブラウザー側の検証は入力体験の改善です。信頼境界ではないため、サーバー/APIでも同じ制約を検証してください。
- エラーメッセージに利用者の入力値や機密情報を追加で含めないでください。ログに保存するデータも絞ります。
- サンプル入力は画面内で処理され、サーバー保存・送信はありません。ZodはESモジュール配信元から読み込まれ、ページの図はMermaidの外部配信を使います。

## トラブルシューティング

- `quantity` のエラーになる: 値が引用符付き文字列でないか、JSONの項目名と型を確認します。
- 数値なのに失敗する: `2.5` は整数ではありません。入力の小数を許可するのか、数量の業務要件を確認します。
- Zodのエラーが表示されない: JSON構文が無効だと、検証前の `JSON.parse` で止まります。括弧、カンマ、引用符を確認します。
- CDNから読み込めない: ネットワーク制限やブラウザーの開発者コンソールを確認します。
- 余分なJSON項目がある: デモのスキーマは `quantity` だけを明示しています。外部APIで未知のキーを受け付けるか拒否するかも仕様として決めてください。

## 公式資料・ライセンス

- [Zod基本の使い方（公式）](https://zod.dev/basics) — `safeParse` と成功・失敗の結果
- [Zodエラーのカスタマイズ（公式）](https://zod.dev/error-customization) — issue配列、メッセージ、path
- [Zod 4移行ガイド（公式）](https://zod.dev/v4/changelog) — `.int()` の安全な整数制約
- [Zod v4.6.7 package metadata](https://github.com/colinhacks/zod/blob/v4.6.7/packages/zod/package.json)
- [Zod v4.6.7 LICENSE](https://github.com/colinhacks/zod/blob/v4.6.7/LICENSE)
- [実装HTML](../../docs/demos/zod-quantity-validation/index.html) · [共通JavaScript](../../docs/demos/browser-library-labs/daily.js)

ZodはMITライセンスです。

## 検証状況

実施: 現行HTML・共通JavaScript・原稿の操作名、初期値、Zodのバージョン、出力パスを照合。Node構文検査とHTML構造検査を行う予定です。

未確認: Day.js/Zodなど外部モジュールが実際に読み込まれるブラウザー環境、Pages上の操作、スクリーンリーダーによる確認。Zod実装の実行テストは外部npm取得が実行環境で失敗したため未実施です。
