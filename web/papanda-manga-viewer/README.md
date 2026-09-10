# Papanda Manga Viewer v0.1

4枚の画像と JSON の付帯データを読み込み、ブラウザで **前のページ / 次のページ** に切り替える最小マンガビューアです。

## ライブデモ

**[▶ ブラウザで Papanda Manga Viewer を開く](https://papanda925.github.io/Daily-Code-Samples/demos/papanda-manga-viewer/)**

GitHub Pages で公開する実行用ファイルは、公開専用ディレクトリに置いています。

- 公開ソース: `docs/demos/papanda-manga-viewer/`
- 公開URL: https://papanda925.github.io/Daily-Code-Samples/demos/papanda-manga-viewer/

## このデモで分かること

- 同じ `<img>` 要素の `src` を差し替えるだけでページ切り替えを作れる
- 画像パスを JavaScript に直書きせず `manga.json` から読み込める
- タイトル・説明・タグなどの付帯データもページと一緒に切り替えられる
- 前後ボタンの端では `disabled` にして範囲外へ進まないようにできる
- 左右の矢印キーでも同じページ移動処理を再利用できる
- HTML / CSS / JavaScript / JSON / 画像だけなので GitHub Pages で静的公開できる

## ファイル構成

```text
docs/demos/papanda-manga-viewer/
├── index.html
├── style.css
├── app.js
├── manga.json
└── pages/
    ├── page-01.svg
    ├── page-02.svg
    ├── page-03.svg
    └── page-04.svg
```

## 中心となる考え方

ページ番号そのものを画像へ固定するのではなく、JavaScript 側では「現在どの配列要素を表示しているか」を `currentIndex` で管理します。

```javascript
function movePage(step) {
  const nextIndex = currentIndex + step;
  if (nextIndex < 0 || nextIndex >= pages.length) return;

  currentIndex = nextIndex;
  renderPage();
}
```

`renderPage()` では、現在ページの画像だけでなくタイトル・説明・タグも同時に差し替えます。

## 画像形式について

このデモではリポジトリを軽く保ち、中身を確認しやすくするため SVG を4枚使っています。

実際のマンガでは、`manga.json` の `image` を PNG / JPEG / WebP などの画像パスへ変更すれば、同じビューアの仕組みを利用できます。

## 検証ポイント

1. 最初は `1 / 4` と表示され、「前のページ」が無効になっている
2. 「次のページ」を押すと画像・タイトル・説明・タグが一緒に変わる
3. 4ページ目では「次のページ」が無効になる
4. キーボードの左右矢印でもページを移動できる
5. 存在しない `manga.json` などで読み込みに失敗した場合は、エラーが画面に表示される

## 使用技術

- HTML
- CSS
- JavaScript
- JSON
- SVG
- GitHub Pages

外部ライブラリは使用していません。
