# Web Audioの波形観察ラボ（初期ミュート）
## ライブデモ
https://papanda925.github.io/Daily-Code-Samples/demos/audio-waveform-lab/

**公開到達・ブラウザ動作は未確認です。** URLは配置予定のGitHub Pagesパスです。自動再生はしません。

## まず試す
1. 「開始（初期ミュート）」を押します。無音のまま波形を描く設計です。
2. 周波数を220 Hzから440 Hzへ変更します。
3. 波の山の間隔が短くなるか確認します。「停止」でAudioContextを閉じます。

## ここを見る
| 条件 | 期待する変化 |
|---|---|
| 220 Hz | 山の間隔が広い |
| 440 Hz | 同じ時間幅で山が密になる |
| ミュートON | 音は出ないが解析波形は描画される |
| 停止 | 音声処理が終了し平坦な線に戻る |

## 1か所変える
周波数を660 Hzへ上げてください。波形の間隔がさらに狭くなる想定です。描画は時間領域データ1024点を同じCanvas幅に収めます。

## うまく動かないとき
- 開始しない：ユーザー操作後に押しているか、AudioContext対応か、Consoleのエラーを確認。
- 波形が平坦：開始状態、ブラウザのタブ表示、動きを減らす設定を確認。手動の「波形を1回描く」も利用可能。
- 音が鳴らない：初期設定は意図的にミュート。音を出す必要はありません。
- 動作が重い：停止し、タブを閉じてください。

## 自分のPCで動かす
`docs/demos/audio-waveform-lab/index.html` と `app.js` を同じフォルダに置いてブラウザで開く。ブラウザの制限によりローカルfile URLが使えない場合は、許可されたローカルHTTPサーバーを使ってください。公開Pagesの到達・実ブラウザ動作は未確認です。

## 仕事・学習で使うなら
オーディオの周波数・波形の教材や、CanvasとAudioNodeのデータフローの学習に使えます。音量測定器や聴力検査器として使わないでください。

## 公式資料
- https://developer.mozilla.org/en-US/docs/Web/API/AnalyserNode/getByteTimeDomainData
- https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API/Best_practices
- https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API/Using_Web_Audio_API

## 安全・検証・ライセンス
- APIキー、外部ライブラリ、マイク、位置情報、認証、通信送信は不要。
- 初期GainNode=0。明示的な解除後もgain=0.02に制限。
- 可視化はミュート前の解析信号を使用。実測の音圧や聴覚安全性を保証しません。
- 2026-10-31: V8構文検査と純粋関数境界テストのみ。Node/Chromium/Firefox/Safari/モバイル/Pagesの実表示は未実施。
- このサンプルの新規コードはMIT License。既存リポジトリのLICENSEがある場合はその条件に従います。
