# Promise.all と Promise.allSettled：一件失敗したときの結果を比較

Node.js 18以上、標準APIのみ。ネットワーク通信、外部API、ファイル変更、個人情報はありません。

## まず試す
`node app.cjs`：3件のうち2件目だけ失敗させ、3件それぞれの結果を表示。
`node app.cjs all`：同じ入力で Promise.all を使用し、全体の失敗を表示。
`node app.cjs settled success`：失敗条件を一つ変え、全件成功。
`node test.cjs`：4シナリオの期待結果を検査。

## ここを見る
allSettledは入力順の3結果を保持し、2件目だけ rejected となります。all は1件の拒否で reject し、他の結果を配列として返しません。ただし残りの非同期処理を自動停止するわけではありません。

## 注意
setTimeoutで作った架空処理です。外部通信、AbortController、実ブラウザ、実業務APIの動作は検証していません。実運用ではエラー理由に秘密を含めず、再試行・タイムアウト・キャンセル・同時実行数を別途設計してください。
