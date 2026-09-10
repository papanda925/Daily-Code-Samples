# Papanda Manga Viewer — スマホ縦読み版

横向き版と**同じ4枚のマンガ画像**をJSONから読み込み、上から順に並べるスマホ向け縦読みサンプルです。Papandaは `papanda925 Character Sheet v1` を正本として統一しています。

## ライブデモ

- **[▶ スマホ縦読み版をブラウザで開く](https://papanda925.github.io/Daily-Code-Samples/demos/papanda-manga-viewer-vertical/)**
- [▶ 横向き4ページ版を開く](https://papanda925.github.io/Daily-Code-Samples/demos/papanda-manga-viewer/)

## サンプル画像

![スマホ縦読み版](../../docs/demos/papanda-manga-viewer-vertical/vertical-sample.svg)

縦読みビューアが実際に再利用する4枚はこちらです。

![1ページ目](../../docs/demos/papanda-manga-viewer/pages/page-01.svg)
![2ページ目](../../docs/demos/papanda-manga-viewer/pages/page-02.svg)
![3ページ目](../../docs/demos/papanda-manga-viewer/pages/page-03.svg)
![4ページ目](../../docs/demos/papanda-manga-viewer/pages/page-04.svg)

## ソースコードを直接見る

- [index.html](../../docs/demos/papanda-manga-viewer-vertical/index.html)
- [style.css](../../docs/demos/papanda-manga-viewer-vertical/style.css)
- [app.js](../../docs/demos/papanda-manga-viewer-vertical/app.js)
- [manga-vertical.json](../../docs/demos/papanda-manga-viewer-vertical/manga-vertical.json)
- [vertical-sample.svg](../../docs/demos/papanda-manga-viewer-vertical/vertical-sample.svg)
- [共有する4枚の画像](../../docs/demos/papanda-manga-viewer/pages/)

## 横向き版との違い

横向き版は `currentIndex` で現在ページを1つ選んで表示します。縦読み版は全ページを順番にDOMへ追加します。

```javascript
const fragment = document.createDocumentFragment();

data.pages.forEach((page, index) => {
  fragment.append(createPage(page, index, data.pages.length));
});

root.replaceChildren(fragment);
```

1ページ目はすぐ表示し、2ページ目以降はブラウザの遅延読み込みを利用します。

```javascript
image.loading = index === 0 ? 'eager' : 'lazy';
image.decoding = 'async';
```

## ポイント

```text
同じ4枚 + JSON
   ├─ 横向き版: currentIndexで1枚ずつ表示
   └─ 縦読み版: forEachで全部を縦に表示
```

画像データと表示方法を分けることで、画像を複製せずに読み方だけ変えられます。

## 使用技術

- HTML
- CSS
- JavaScript
- JSON
- SVG
- GitHub Pages

外部JavaScriptライブラリは使用していません。
