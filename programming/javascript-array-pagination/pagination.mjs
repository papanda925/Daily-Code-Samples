function pageOf(items, page, size) {
  if (!Number.isSafeInteger(page) || page < 1 ||
      !Number.isSafeInteger(size) || size < 1) {
    throw new RangeError("page と size は正の整数");
  }

  if (page > Math.ceil(items.length / size)) return [];

  const start = (page - 1) * size;
  return items.slice(start, start + size);
}

const items = ["A", "B", "C", "D", "E"];

console.log(pageOf(items, 1, 2));
console.log(pageOf(items, 2, 2));
console.log(pageOf(items, 3, 2));
console.log(pageOf(items, 4, 2));
