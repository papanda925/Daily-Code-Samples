# Web Speech API：読み上げ声と速さを変える

入力した短い文章を読み上げ、声・速度・高さの違いを試せます。 初心者でも操作と結果を比較できる、ブラウザー実行型の教材です。

## ライブデモ
[操作する（GitHub Pages）](https://papanda925.github.io/Daily-Code-Samples/demos/speech-synthesis-voice-lab/)

公開URLは配置先を示します。**実際のGitHub Pages到達とブラウザー操作は未検証**です。

## まず試す
1. 「読み上げ」で音を出す（音量注意）。
2. 速さを10から15に変えて再生する。
3. 「停止」で止め、声の候補を切り替える。

**期待結果**：初期文章が読み上げられる。速度15は約1.5倍、5は約0.5倍。選べる声はOS・ブラウザーごとに異なる。

## しくみ
SpeechSynthesisUtteranceを作り、speechSynthesis.speakでキューへ渡す。cancelで読み上げを解除する。

## 実装ファイル
- [HTML](../../docs/demos/speech-synthesis-voice-lab/index.html)
- [JavaScript](../../docs/demos/speech-synthesis-voice-lab/app.js)
- [共通スタイル](../../docs/demos/_shared/interactive-lab.css)

## 変更実験
rateを10から7にして聞き取りやすさを比較。

## 動かない場合
声の一覧が空でも既定音声で試せる。音が出なければ端末の音量とブラウザーの音声機能を確認。OSによって音声データの取得が必要。

## 安全と検証
テキストの処理はOS・ブラウザーの音声実装に依存し、オンライン処理の可能性がある。個人情報・秘密を入力しない。
- 今回は実装内容とリンク・操作の対応を静的に確認。GitHub Actions・有料APIは使わない。
- ブラウザー実行とGitHub Pages配信の実証は未実施。実機テスト済みと表現しない。

## 仕事での応用
入力を変えたとき何が起きるかを明確に示すUIのプロトタイプや社内研修教材に応用できます。

## 公式資料
- https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesis
- https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesisUtterance

**対応するブログ記事ID（計画）**：20261125-06。ブログ公開はUbuntuの既設Publisherが担当し、このREADMEの保存だけで公開済みとはしません。
