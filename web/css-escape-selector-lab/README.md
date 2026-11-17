# CSS.escape と querySelector の特殊文字実験

## ライブデモ
https://papanda925.github.io/Daily-Code-Samples/demos/css-escape-selector-lab/

静的HTMLとブラウザー標準APIのみ。第三者ライブラリ、CDN、APIキー、外部通信は不要。ブラウザー実操作とPages到達は未確認。

## まず試す
index.html をブラウザーで開く。初期ID `ticket:01` を検索すると「通常チケット」が見つかる想定。対象は架空データのみ。

## 1か所変える
入力を `ticket.02`、`123-start`、`a b`、`missing` に変えて比較。最後は一致なし。空文字も一致なし。

## 原理
CSSセレクター内のコロンやピリオドは構文上の意味を持つため、単純な `"#"+id` では正しく検索できない。CSS.escape(id)で識別子をエスケープする。テキスト挿入には textContent を使う。

## 異常系・安全
80文字超過、CSS.escape非対応は明示エラー。個人情報を貼らない。検索対象はこのデモ内の4件だけ。入力は送信・保存しない。実際の業務DOMに適用する前に、重複ID・ブラウザー対応・DOMの更新タイミングを確認。

## テスト
Node.jsで依存注入した疑似rootを使い、正しいエスケープ呼出し、未検出、長さ制限、非対応を検証可能。ブラウザーの実CSSパーサー挙動は未検証。

## 一次資料
- https://developer.mozilla.org/en-US/docs/Web/API/CSS/escape_static
- https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector
- https://drafts.csswg.org/cssom/#the-css.escape()-method
