# Pyodide：ブラウザーでPythonを実行

ブラウザー内のWebAssembly版Pythonを読み込み、短いPython式の結果を観察します。 初心者でも操作と結果を比較できる、ブラウザー実行型の教材です。

## ライブデモ
[操作する（GitHub Pages）](https://papanda925.github.io/Daily-Code-Samples/demos/pyodide-python-playground/)

公開URLは配置先を示します。**実際のGitHub Pages到達とブラウザー操作は未検証**です。

## まず試す
1. 「Pythonを読み込む」を押し、CDNから実行環境を取得する。
2. 「Pythonを実行」を押して55を表示。
3. numbersの5を10へ変更して再実行。

**期待結果**：初期コードは1²+2²+3²+4²+5²=55。リスト末尾を10に変更すると130が表示される。

## しくみ
PyodideはWebAssemblyで動くPython実行環境。loadPyodideで初期化しrunPythonAsyncで入力コードを評価する。

## 実装ファイル
- [HTML](../../docs/demos/pyodide-python-playground/index.html)
- [JavaScript](../../docs/demos/pyodide-python-playground/app.js)
- [共通スタイル](../../docs/demos/_shared/interactive-lab.css)

## 変更実験
sum(x*x for x in numbers)をmax(numbers)に変える。

## 動かない場合
CDN禁止環境・通信オフライン・遅い回線では読み込めない。Python構文エラーは結果表示に出る。サードパーティコードの実行には注意。

## 安全と検証
外部CDNからPyodideを取得するためネットワーク通信あり。個人情報や秘密を入力しない。ブラウザー内実行は完全なセキュリティ境界ではない。
- 今回は実装内容とリンク・操作の対応を静的に確認。GitHub Actions・有料APIは使わない。
- ブラウザー実行とGitHub Pages配信の実証は未実施。実機テスト済みと表現しない。

## 仕事での応用
入力を変えたとき何が起きるかを明確に示すUIのプロトタイプや社内研修教材に応用できます。

## 公式資料
- https://pyodide.org/en/stable/usage/quickstart.html
- https://pyodide.org/en/stable/

**対応するブログ記事ID（計画）**：20261125-04。ブログ公開はUbuntuの既設Publisherが担当し、このREADMEの保存だけで公開済みとはしません。
