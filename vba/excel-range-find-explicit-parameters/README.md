# Excel VBA Range.Findの検索条件を明示する

Range.Findの保存済み設定に依存せず、完全一致、部分一致、0件、複数件を架空データで確認するVBA教材です。

## 前提条件

- Windows版Excelデスクトップアプリ
- マクロを利用できるテスト用.xlsmブック
- VBAエディターへ標準モジュールをインポートできること

Excel for the webではVBAを実行しません。組織のマクロポリシーを回避せず、実データを含まない新規テストブックで試してください。

## まず試す

1. 新規ブックを.xlsmとして保存します。
2. Alt+F11でVBAエディターを開きます。
3. ［ファイル］→［ファイルのインポート］でFindOrders.basを読み込みます。
4. CreateFictionalFindSampleを実行します。
5. Ctrl+Gでイミディエイトウィンドウを開きます。
6. RunRangeFindSmokeTestを実行します。

同名のFindSampleシートがある場合、サンプルは停止します。既存シートを自動消去・上書きしません。

## 期待する出力

~~~text
完全一致の期待値=A3
完全一致の結果=A3
部分一致の期待値=A3,A4 / 件数=2
部分一致の結果=A3
部分一致の結果=A4
部分一致の件数=2
0件の期待値=一致なし
0件の結果=一致なし
~~~

## ここを見る

- LookIn、LookAt、SearchOrder、MatchByteを省略していない
- Afterには検索範囲内の単一セルを指定している
- 完全一致はxlWhole、部分一致はxlPart
- 0件ではNothingを返し、Addressを参照しない
- FindNextが先頭へ戻ったら、最初のアドレスとの比較で終了する

Microsoft Learnでは、LookIn、LookAt、SearchOrder、MatchByteの値が保存され、検索ダイアログの設定とも相互に影響すると説明されています。そのため、再現性が必要なコードでは毎回明示します。

## 1か所変える

FindOrderWholeのLookAt:=xlWholeを一時的にxlPartへ変えると、A-102に対してA3だけでなくA4のXA-102も候補になります。ほかの条件を変えず、完全一致と部分一致の差だけを観察してください。確認後はxlWholeへ戻します。

## 仕事で使うなら

- シート名、列、検索範囲を定数または引数にする
- 数式を探すのか表示値を探すのかを決め、LookInを選ぶ
- 大文字小文字、全角・半角、複数一致時の業務ルールを決める
- 検索中に対象セルを書き換えず、検索と更新を別段階にする
- 速度だけでなく、同じ入力で同じ結果になるかを記録する

大量データでキー検索を繰り返す場合は、Dictionaryやワークシート関数の方が適することもあります。

## 注意点

- このサンプルはExcel/VBA実機で未実行です。コード構造と公式仕様の照合までで、動作確認済みとはしていません。
- 実顧客名、実注文番号、勤務先情報、秘密情報をCopilotや外部サービスへ送らないでください。
- マクロ警告や組織ポリシーを無効化して実行しないでください。
- FindNextは同じ検索条件を引き継ぎます。途中で別のFindを呼ぶ設計では、検索状態が混ざらないよう処理を分離してください。

## 公式情報

- [Range.Find method (Excel)](https://learn.microsoft.com/en-us/office/vba/api/excel.range.find)
- [Range.FindNext method (Excel)](https://learn.microsoft.com/en-us/office/vba/api/excel.range.findnext)

## 検証状況

- Microsoft Learnの仕様確認: 実施
- VBAコードの静的レビュー: 実施
- Excel/VBA実機実行: 未実施
- GitHub Actions: 未実行（通常運用では使用しない）
