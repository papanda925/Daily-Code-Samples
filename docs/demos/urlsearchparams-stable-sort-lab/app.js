const input = document.querySelector("#query");
const output = document.querySelector("#result");
document.querySelector("#run").addEventListener("click", () => {
  try {
    const raw = input.value.replace(/^\?/, "");
    const params = new URLSearchParams(raw);
    const before = [...params.entries()];
    params.sort();
    const after = [...params.entries()];
    const expected = after.filter(([key]) => key === "tag").map(([, value]) => value);
    output.textContent = [
      "変更前: " + JSON.stringify(before),
      "変更後: " + JSON.stringify(after),
      "シリアライズ: " + params.toString(),
      "tagの順番: " + JSON.stringify(expected),
      "注意: sort()はキー名順であり、値の順序は並べ替えません。"
    ].join("\n");
  } catch (error) {
    output.textContent = "解析できません: " + error.message;
  }
});
document.querySelector("#run").click();
