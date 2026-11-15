// JSON.stringify が落とす値を、架空の入力だけで比較する。Node.js 20+ / ブラウザ標準JS
export function inspect(input) {
  const encoded = JSON.stringify(input);
  return { encoded, decoded: encoded === undefined ? undefined : JSON.parse(encoded) };
}
export function audit(original, restored) {
  return {
    missing: !Object.hasOwn(restored, "optional"),
    nanBecameNull: restored.score === null && Number.isNaN(original.score),
    infinityBecameNull: restored.limit === null && original.limit === Infinity,
    dateBecameString: typeof restored.at === "string" && original.at instanceof Date,
    arrayHoleBecameNull: restored.items[1] === null
  };
}
export const dummy = () => ({
  id: "DUMMY-001",
  optional: undefined,
  score: NaN,
  limit: Infinity,
  at: new Date("2026-01-01T00:00:00.000Z"),
  items: ["A", undefined, "C"]
});
if (import.meta.url === `file://${process.argv[1]}`) {
  const input = dummy();
  const { encoded, decoded } = inspect(input);
  console.log(encoded);
  console.log(JSON.stringify(audit(input, decoded)));
}
