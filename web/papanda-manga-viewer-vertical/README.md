# Papanda Manga Viewer — スマホ縦読み版

横向きのページ切り替え版と**同じ4枚のマンガ画像**を、JSONから読み込んで上から順に並べるスマホ向け縦読みサンプルです。

## ライブデモ

- **[▶ スマホ縦読み版をブラウザで開く](https://papanda925.github.io/Daily-Code-Samples/demos/papanda-manga-viewer-vertical/)**
- [▶ 横向き4ページ版を開く](https://papanda925.github.io/Daily-Code-Samples/demos/papanda-manga-viewer/)

## サンプル画像

縦読み版の説明用に作成した Papanda のサンプル画像です。

![スマホで縦に読む Papanda Manga Viewer](../../docs/demos/papanda-manga-viewer-vertical/vertical-sample.webp)

実際の縦読みビューアでは、横向き版で使っている次の4枚を同じ順番で再利用しています。

![1ページ目](../../docs/demos/papanda-manga-viewer/pages/page-01.webp)
![2ページ目](../../docs/demos/papanda-manga-viewer/pages/page-02.webp)
![3ページ目](../../docs/demos/papanda-manga-viewer/pages/page-03.webp)
![4ページ目](../../docs/demos/papanda-manga-viewer/pages/page-04.webp)

## ソースコードを直接見る

実行用ソースは GitHub Pages 公開ディレクトリにあります。

- [index.html](../../docs/demos/papanda-manga-viewer-vertical/index.html)
- [style.css](../../docs/demos/papanda-manga-viewer-vertical/style.css)
- [app.js](../../docs/demos/papanda-manga-viewer-vertical/app.js)
- [manga-vertical.json](../../docs/demos/papanda-manga-viewer-vertical/manga-vertical.json)
- [vertical-sample.webp](../../docs/demos/papanda-manga-viewer-vertical/vertical-sample.webp)

横向き版の説明とソースは [Papanda Manga Viewer v0.1](../papanda-manga-viewer/) にあります。

## ファイル構成

```text
docs/demos/papanda-manga-viewer-vertical/
├── index.html
├── style.css
├── app.js
├── manga-vertical.json
└── vertical-sample.webp

# 実際の4ページ画像は横向き版と共有
docs/demos/papanda-manga-viewer/pages/
├── page-01.webp
├── page-02.webp
├── page-03.webp
└── page-04.webp
```

## 横向き版との違い

横向き版は `currentIndex` で現在ページを1つ選び、`renderPage()` で同じ `<img>` の `src` を差し替えます。

縦読み版は4ページをすべてDOMへ追加します。

```javascript
const fragment = document.createDocumentFragment();

data.pages.forEach((page, index) => {
  fragment.append(createPage(page, index, data.pages.length));
});

root.replaceChildren(fragment);
```

そのため、スマホでは「次へ」を押さず、そのまま下へスクロールできます。

## 画像読み込み

1ページ目はすぐ表示し、2ページ目以降はブラウザの遅延読み込みを使います。

```javascript
image.loading = index === 0 ? 'eager' : 'lazy';
image.decoding = 'async';
```

ページ数が増えた場合、最初からすべての画像を急いで読み込ませないための最小対策です。

## このデモで確認すること

1. 4枚の画像が `1 / 4` から `4 / 4` まで上から順に表示される
2. スマホ幅でも画像が画面からはみ出さない
3. タイトル・説明・タグが各画像の下に表示される
4. 横向き版と同じ画像データを再利用できる
5. JSON読み込み失敗時はエラー内容が表示される

## 使用技術

- HTML
- CSS
- JavaScript
- JSON
- WebP
- GitHub Pages

外部JavaScriptライブラリは使用していません。
