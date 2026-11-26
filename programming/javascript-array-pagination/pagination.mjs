import { pathToFileURL } from 'node:url';

// 画面のページ番号は1始まり、配列の位置は0始まりです。
export function pageOf(items, page, size) {
  if (!Array.isArray(items)) throw new TypeError('items must be an array');
  if (!Number.isSafeInteger(page) || page < 1 ||
      !Number.isSafeInteger(size) || size < 1) {
    throw new RangeError('page and size must be positive safe integers');
  }
  // 先に最終ページを確認し、範囲外の巨大なページ番号で掛け算しないようにします。
  if (page > Math.ceil(items.length / size)) return [];
  const start = (page - 1) * size;
  // sliceは終了位置を含まず、新しい配列を返します。元配列は変更しません。
  return items.slice(start, start + size);
}

// 直接実行した場合だけデモを表示します。テストからimportした場合は表示しません。
if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  const items = ['A', 'B', 'C', 'D', 'E'];
  for (let page = 1; page <= 4; page++) {
    console.log(page, JSON.stringify(pageOf(items, page, 2)));
  }
}
