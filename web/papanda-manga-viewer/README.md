# Papanda Manga Viewer v0.1

4枚の Papanda マンガ画像と JSON の付帯データを読み込み、ブラウザで **前のページ / 次のページ** に切り替える最小マンガビューアです。

同じ4枚を縦に並べて読む **スマホ縦読み版** も用意しています。

## ライブデモ

- **[▶ 横向き4ページ版をブラウザで開く](https://papanda925.github.io/Daily-Code-Samples/demos/papanda-manga-viewer/)**
- **[▶ スマホ縦読み版をブラウザで開く](https://papanda925.github.io/Daily-Code-Samples/demos/papanda-manga-viewer-vertical/)**

## サンプル画像

実際の横向きビューアで読み込んでいる4枚です。以前の仮SVGではなく、papanda925向けに作成したアニメ調の Papanda 画像へ差し替えています。

### 1 / 4 — ブラウザでページを切り替える

![1ページ目](../../docs/demos/papanda-manga-viewer/pages/page-01.webp)

### 2 / 4 — 画像と付帯データを分けて持つ

![2ページ目](../../docs/demos/papanda-manga-viewer/pages/page-02.webp)

### 3 / 4 — 前へ・次へでページを切り替える

![3ページ目](../../docs/demos/papanda-manga-viewer/pages/page-03.webp)

### 4 / 4 — GitHub Pagesで公開する

![4ページ目](../../docs/demos/papanda-manga-viewer/pages/page-04.webp)

スマホ縦読み版の紹介画像はこちらです。

![スマホ縦読み版](../../docs/demos/papanda-manga-viewer-vertical/vertical-sample.webp)

## ソースコードを直接見る

GitHub Pagesで動いている実体をそのまま確認できます。

- [index.html — ビューアのHTML](../../docs/demos/papanda-manga-viewer/index.html)
- [style.css — レスポンシブ表示とボタンのCSS](../../docs/demos/papanda-manga-viewer/style.css)
- [app.js — ページ切り替えロジック](../../docs/demos/papanda-manga-viewer/app.js)
- [manga.json — 画像パスと付帯データ](../../docs/demos/papanda-manga-viewer/manga.json)
- [pages/ — 4枚のサンプル画像](../../docs/demos/papanda-manga-viewer/pages/)
- [スマホ縦読み版のREADMEとソース](../papanda-manga-viewer-vertical/)

## ファイル構成

```text
docs/demos/papanda-manga-viewer/
├── index.html
├── style.css
├── app.js
├── manga.json
└── pages/
    ├── page-01.webp
    ├── page-02.webp
    ├── page-03.webp
    └── page-04.webp
```

## このデモで分かること

- 同じ `<img>` 要素の `src` を差し替えるだけでページ切り替えを作れる
- 画像パスを JavaScript に直書きせず `manga.json` から読み込める
- タイトル・説明・タグなどの付帯データもページと一緒に切り替えられる
- 前後ボタンの端では `disabled` にして範囲外へ進まないようにできる
- 左右の矢印キーでも同じページ移動処理を再利用できる
- 同じ画像を、別の縦読みUIから再利用できる
- HTML / CSS / JavaScript / JSON / WebP だけなので GitHub Pages で静的公開できる

## 中心となる考え方

JavaScript側では、現在どの配列要素を表示しているかを `currentIndex` で管理します。

```javascript
function movePage(step) {
  const nextIndex = currentIndex + step;
  if (nextIndex < 0 || nextIndex >= pages.length) return;

  currentIndex = nextIndex;
  renderPage();
}
```

`renderPage()` では画像だけでなくタイトル・説明・タグも同時に差し替えます。

```javascript
function renderPage() {
  const page = pages[currentIndex];
  if (!page) return;

  image.src = page.image;
  image.alt = page.alt ?? '';
  counter.textContent = `${currentIndex + 1} / ${pages.length}`;
  title.textContent = page.title ?? '';
  caption.textContent = page.caption ?? '';
}
```

## 横向き版と縦読み版

横向き版は「1ページを選んで表示」、縦読み版は「全ページを順にDOMへ追加」という違いがあります。

```text
同じ4枚のWebP + JSON
        ├─ 横向き版: currentIndex → 1枚ずつ表示
        └─ 縦読み版: forEach → 上から順に全部表示
```

データと表示方法を分けておくことで、画像を複製せずに別の読み方を作れるのが今回のポイントです。

## 検証ポイント

1. 最初は `1 / 4` と表示され、「前のページ」が無効になっている
2. 「次のページ」を押すと画像・タイトル・説明・タグが一緒に変わる
3. 4ページ目では「次のページ」が無効になる
4. キーボードの左右矢印でもページを移動できる
5. 存在しない `manga.json` などで読み込みに失敗した場合は、エラーが画面に表示される
6. スマホ縦読み版では同じ4画像が上から順に表示される

## 使用技術

- HTML
- CSS
- JavaScript
- JSON
- WebP
- GitHub Pages

外部JavaScriptライブラリは使用していません。
