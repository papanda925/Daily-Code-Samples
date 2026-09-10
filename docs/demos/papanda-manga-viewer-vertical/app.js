const root = document.getElementById('vertical-pages');
const status = document.getElementById('status');

function createPage(page, index, total) {
  const article = document.createElement('article');
  article.className = 'manga-page';
  article.id = `page-${index + 1}`;

  const counter = document.createElement('p');
  counter.className = 'counter';
  counter.textContent = `${index + 1} / ${total}`;

  const image = document.createElement('img');
  image.src = page.image;
  image.alt = page.alt ?? '';
  image.loading = index === 0 ? 'eager' : 'lazy';
  image.decoding = 'async';

  const title = document.createElement('h2');
  title.textContent = page.title ?? '';

  const caption = document.createElement('p');
  caption.textContent = page.caption ?? '';

  const tags = document.createElement('ul');
  tags.className = 'tags';
  tags.setAttribute('aria-label', 'ページのタグ');
  const pageTags = Array.isArray(page.tags) ? page.tags : [];
  pageTags.forEach((tag) => {
    const item = document.createElement('li');
    item.textContent = tag;
    tags.append(item);
  });

  article.append(counter, image, title, caption, tags);
  return article;
}

fetch('./manga-vertical.json')
  .then((response) => {
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return response.json();
  })
  .then((data) => {
    if (!Array.isArray(data.pages) || data.pages.length === 0) {
      throw new Error('pages が空、または配列ではありません');
    }

    const fragment = document.createDocumentFragment();
    data.pages.forEach((page, index) => {
      fragment.append(createPage(page, index, data.pages.length));
    });
    root.replaceChildren(fragment);
    status.textContent = '';
  })
  .catch((error) => {
    status.textContent = `縦読みデータを読み込めませんでした: ${error.message}`;
  });
