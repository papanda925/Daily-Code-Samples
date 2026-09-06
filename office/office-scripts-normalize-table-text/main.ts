function main(workbook: ExcelScript.Workbook) {
  const tables = workbook.getTables();

  if (tables.length === 0) {
    throw new Error("ブック内にExcelテーブルがありません。");
  }

  const range = tables[0].getRangeBetweenHeaderAndTotal();
  const values = range.getValues();
  const formulas = range.getFormulas();
  let changed = 0;

  for (let row = 0; row < values.length; row++) {
    for (let col = 0; col < values[row].length; col++) {
      const hasFormula =
        typeof formulas[row][col] === "string" &&
        String(formulas[row][col]).startsWith("=");

      if (hasFormula || typeof values[row][col] !== "string") {
        continue;
      }

      const before = String(values[row][col]);
      const after = before
        .replace(/\u3000/g, " ")
        .replace(/\s+/g, " ")
        .trim();

      if (before !== after) {
        range.getCell(row, col).setValue(after);
        changed++;
      }
    }
  }

  console.log(`文字列を ${changed} セル整形しました。`);
}
