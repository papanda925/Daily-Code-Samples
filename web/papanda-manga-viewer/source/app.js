const image = document.getElementById('page-image');
const counter = document.getElementById('page-counter');
const title = document.getElementById('page-title');
const caption = document.getElementById('page-caption');
const tags = document.getElementById('page-tags');
const prevButton = document.getElementById('prev-button');
const nextButton = document.getElementById('next-button');
const status = document.getElementById('status');

let pages = [];
let currentIndex = 0;

function renderPage() {
  const page = pages[currentIndex];
  if (!page) return;

  image.src = page.image;
  image.alt = page.alt ?? '';
  counter.textContent = `${currentIndex + 1} / ${pages.length}`;
  title.textContent = page.title ?? '';
  caption.textContent = page.caption ?? '';

  const pageTags = Array.isArray(page.tags) ? page.tags : [];
  tags.replaceChildren(...pageTags.map((tag) => {
    const item = document.createElement('li');
    item.textContent = tag;
    return item;
  }));

  prevButton.disabled = currentIndex === 0;
  nextButton.disabled = currentIndex === pages.length - 1;
  status.textContent = '';
}

function movePage(step) {
  const nextIndex = currentIndex + step;
  if (nextIndex < 0 || nextIndex >= pages.length) return;
  currentIndex = nextIndex;
  renderPage();
}

prevButton.addEventListener('click', () => movePage(-1));
nextButton.addEventListener('click', () => movePage(1));
document.addEventListener('keydown', (event) => {
  if (event.key === 'ArrowLeft') movePage(-1);
  if (event.key === 'ArrowRight') movePage(1);
});

fetch('./manga.json')
  .then((response) => {
    if (!response.ok) throw new Error(`HTTP ${response.status}`);
    return response.json();
  })
  .then((data) => {
    if (!Array.isArray(data.pages) || data.pages.length === 0) {
      throw new Error('pages が空、または配列ではありません');
    }
    pages = data.pages;
    renderPage();
  })
  .catch((error) => {
    status.textContent = `マンガデータを読み込めませんでした: ${error.message}`;
    prevButton.disabled = true;
    nextButton.disabled = true;
  });
