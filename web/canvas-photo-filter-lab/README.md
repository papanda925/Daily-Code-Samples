# File API + Canvas：写真加工研究室

端末から選んだ画像を送信せずブラウザー内でプレビューし、彩度とぼかしを調整します。 初心者でも操作と結果を比較できる、ブラウザー実行型の教材です。

## ライブデモ
[操作する（GitHub Pages）](https://papanda925.github.io/Daily-Code-Samples/demos/canvas-photo-filter-lab/)

公開URLは配置先を示します。**実際のGitHub Pages到達とブラウザー操作は未検証**です。

## まず試す
1. 6MB以下の画像を選ぶ（画像は外部送信しない）。
2. 彩度を100から0にして白黒に近づける。
3. ぼかしを0から8に変更し、初期化で戻す。

**期待結果**：画像がキャンバス内に収まり、彩度0で灰色に近づき、ぼかしが増す。ファイル選択前は無地。

## しくみ
File APIで選択したBlobのObject URLをImageへ渡し、CanvasRenderingContext2D.filterをdrawImageに適用する。Object URLは後で解放する。

## 実装ファイル
- [HTML](../../docs/demos/canvas-photo-filter-lab/index.html)
- [JavaScript](../../docs/demos/canvas-photo-filter-lab/app.js)
- [共通スタイル](../../docs/demos/_shared/interactive-lab.css)

## 変更実験
filterのsaturateの代わりにsepia(80%)を加え色味を比較。

## 動かない場合
写真が見えない場合はサイズ6MB上限や非対応画像形式を確認。大きな画像ではメモリを使うので小さな画像で試す。

## 安全と検証
選択画像は自分のブラウザー内で処理。通信・アップロード・永続保存なし。共有PCでは選ぶ画像の内容に注意。
- 今回は実装内容とリンク・操作の対応を静的に確認。GitHub Actions・有料APIは使わない。
- ブラウザー実行とGitHub Pages配信の実証は未実施。実機テスト済みと表現しない。

## 仕事での応用
入力を変えたとき何が起きるかを明確に示すUIのプロトタイプや社内研修教材に応用できます。

## 公式資料
- https://developer.mozilla.org/en-US/docs/Web/API/URL/createObjectURL_static
- https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/filter

**対応するブログ記事ID（計画）**：20261125-03。ブログ公開はUbuntuの既設Publisherが担当し、このREADMEの保存だけで公開済みとはしません。
