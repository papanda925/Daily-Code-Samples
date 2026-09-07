/**
 * Excelテーブルの「全セルが空白」のデータ行だけを削除します。
 * @param tableName 対象テーブル名。ブック内にテーブルが1つだけなら省略できます。
 */
function main(workbook: ExcelScript.Workbook, tableName?: string) {
  const tables = workbook.getTables();

  if (tables.length === 0) {
    throw new Error("ブック内にExcelテーブルがありません。先に対象範囲をテーブル化してください。");
  }

  let table: ExcelScript.Table;

  if (tableName && tableName.trim() !== "") {
    const found = workbook.getTable(tableName);
    if (!found) {
      throw new Error(`指定したテーブル「${tableName}」が見つかりません。`);
    }
    table = found;
  } else {
    // 複数テーブルがあるのに先頭を勝手に選ぶと、別表を削除する事故につながります。
    // そのため1つだけの場合に限って自動選択します。
    if (tables.length > 1) {
      const names = tables.map(t => t.getName()).join(", ");
      throw new Error(`テーブルが複数あります。実行時にtableNameを指定してください: ${names}`);
    }
    table = tables[0];
  }

  const rowCount = table.getRowCount();

  if (rowCount === 0) {
    console.log(`${table.getName()}: データ行はありません。`);
    return;
  }

  // ヘッダーと集計行を除いたデータ部分だけを読みます。
  const values = table.getRangeBetweenHeaderAndTotal().getValues();
  let deleted = 0;

  // 上から削除すると行番号が詰まり、未確認の行を飛ばす可能性があります。
  // 下から上へ1行ずつ削除すれば、まだ確認していない行番号が変わりません。
  for (let row = values.length - 1; row >= 0; row--) {
    const isBlank = values[row].every(value => String(value).trim() === "");

    if (isBlank) {
      table.deleteRowsAt(row, 1);
      deleted++;
    }
  }

  console.log(`${table.getName()}: 完全空白行を ${deleted} 行削除しました。`);
}
