// 画面と独立したロジック。Node / ブラウザーの両方で呼び出す。
export const SAMPLE_QUERY = "tag=red&tag=blue&task=check+only&empty=";
export function inspectQuery(query, key) {
  // クエリーの先頭に?がある場合のみ外す。URL全体は受け取らない。
  const raw = String(query).startsWith("?") ? String(query).slice(1) : String(query);
  const params = new URLSearchParams(raw);
  const name = String(key);
  return {
    exists: params.has(name),
    first: params.get(name),
    all: params.getAll(name),
    entries: Array.from(params.entries()),
    encoded: params.toString(),
  };
}
export function updateQuery(query, key, value, mode) {
  const name = String(key);
  if (!name.trim()) throw new Error("検索キーを入力してください");
  const raw = String(query).startsWith("?") ? String(query).slice(1) : String(query);
  const params = new URLSearchParams(raw);
  if (mode === "append") params.append(name, String(value));
  else if (mode === "set") params.set(name, String(value));
  else throw new Error("不明な操作です");
  return params.toString();
}
