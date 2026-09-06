function main(workbook: ExcelScript.Workbook) {
  const tables = workbook.getTables();

  if (tables.length === 0) {
    throw new Error("ブック内にExcelテーブルがありません。先に対象範囲をテーブル化してください。");
  }

  const table = tables[0];
  const rowCount = table.getRowCount();

  if (rowCount === 0) {
    console.log(`${table.getName()}: データ行はありません。`);
    return;
  }

  const values = table.getRangeBetweenHeaderAndTotal().getValues();
  let deleted = 0;

  for (let row = values.length - 1; row >= 0; row--) {
    const isBlank = values[row].every(value => String(value).trim() === "");

    if (isBlank) {
      table.deleteRowsAt(row, 1);
      deleted++;
    }
  }

  console.log(`${table.getName()}: 完全空白行を ${deleted} 行削除しました。`);
}
