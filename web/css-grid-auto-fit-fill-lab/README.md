# CSS Gridのauto-fillとauto-fitを比較する

HTML/CSSを学ぶ人や社内ポータルのカード一覧を設計する人向け。同じ枠幅とカード数を2つのグリッドに与え、空き列の扱いによって実際の列幅がどう変わるか観察する。

## ライブデモ

[枠幅・カード数を変える](https://papanda925.github.io/Daily-Code-Samples/demos/css-grid-auto-fit-fill-lab/)（公開URLへの到達は未確認）。

実装: [index.html](../../docs/demos/css-grid-auto-fit-fill-lab/index.html)、[app.js](../../docs/demos/css-grid-auto-fit-fill-lab/app.js)、[ブラウザー検査](../../docs/demos/css-grid-auto-fit-fill-lab/test.py)。

## まず試す

CSS Grid対応ブラウザーとJavaScriptが必要。外部ライブラリー、アカウント、権限は不要。ローカルで試すならindex.htmlとapp.jsを同じフォルダーに置く。ファイルを直接開けない環境では、許可されたローカルWebサーバーで配信する。

1. 枠の幅を540px、カード数を2にする（初期状態）。
2. 上下のカードと「列幅」を見比べる。
3. カード数を4、5へ増やし、枠幅を252px、251pxに変える。幅のスライダーは1px刻み。

| 枠幅 | カード数 | auto-fillの列幅(px) | auto-fitの列幅(px) |
|---|---:|---|---|
| 540 | 2 | 126,126,126,126 | 264,264,0,0 |
| 540 | 4 | 126,126,126,126 | 同左 |
| 540 | 5 | 126,126,126,126 | 同左（2行目に1枚） |
| 252 | 1 | 120,120 | 252,0 |
| 251 | 1 | 251 | 251 |
| 120 | 2 | 120 | 120 |

## 仕組みと変更実験

```css
.grid { display: grid; gap: 12px; }
.fill { grid-template-columns: repeat(auto-fill, minmax(120px, 1fr)); }
.fit { grid-template-columns: repeat(auto-fit, minmax(120px, 1fr)); }
```

120pxの最小列幅と12pxの隙間で収まる列を作る。auto-fitはどの行にもカードがない列を折り畳む。5枚の場合は全列が最初の行で使われるため、2行目の1枚だけを幅いっぱいに伸ばす機能ではない。JavaScriptは入力変更に合わせてカードを作り直し、getComputedStyleでブラウザーの列幅を読む。列数を自前計算するのではない。

最小列幅を160pxに両方同時に変更するか、gapを24pxに変えて境界値を予想してから試す。最小列幅未満の枠は横にはみ出し得るため、この教材は幅120px以上に制限している。比較枠は狭い画面で横スクロール可能。

## うまくいかないとき

カードが出ない場合はJavaScriptの有効化、app.jsの配置、開発者ツールのエラーを確認する。両方式が同じになること自体は異常ではない。幅が狭いか全列が使われていないかを確認する。列幅の小数や表示形式はブラウザーにより異なる場合がある。

## 検証・安全・出典

2026-11-28: Node.js v22.16.0でnode --check app.js成功。Python PlaywrightでChromium 144.0.7559.96を起動し、HTMLをメモリー上に展開してapp.jsを注入する検査で表の6条件、カード数、JS例外なしを確認。検査は python test.py /usr/bin/chromium （PlaywrightとChromiumが利用可能な環境）。ファイルURLへの直接ナビゲーションは環境制限で不可、実公開URL・他のブラウザー・CodeQLは未確認。検査スクリプトは記事公開の依存ではない。

教材は固定の架空カードのみを生成し、入力を外部へ送信・永続保存しない。外部依存なし。リポジトリのMITライセンスに従う。

- [W3C CSS Grid Level 2 — auto-repeat](https://www.w3.org/TR/css-grid-2/#auto-repeat)
- [MDN — repeat()](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/repeat)
- [MDN — minmax()](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/minmax)

ブログでは使い分けと実務上の判断を説明し、この教材は幅を動かして比較する完全版を提供する。
