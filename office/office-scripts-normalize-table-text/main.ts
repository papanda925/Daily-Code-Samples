function main(workbook: ExcelScript.Workbook) {
  // ブック内にあるExcelテーブルをすべて取得します。
  //
  // このサンプルでは「最初のテーブル」を対象にします。
  // 実務で複数テーブルがある場合は、
  // workbook.getTable("Table1") のように名前で限定する方が安全です。
  const tables = workbook.getTables();

  // テーブルが1つもない状態で続行すると、
  // tables[0] が存在せず後続処理が失敗します。
  //
  // そこで、何が足りないのか分かるメッセージを出して停止します。
  if (tables.length === 0) {
    throw new Error("ブック内にExcelテーブルがありません。");
  }

  // ヘッダー行と合計行を除き、
  // 実際のデータ部分だけを処理対象にします。
  const range = tables[0].getRangeBetweenHeaderAndTotal();

  // getValues():
  //   セルに見えている値を2次元配列で取得します。
  //
  // getFormulas():
  //   同じ範囲の数式を取得します。
  //
  // 数式セルを値で上書きしないため、両方を取得しています。
  const values = range.getValues();
  const formulas = range.getFormulas();

  // 何セル変更したかを最後に表示するためのカウンターです。
  let changed = 0;

  // 行 → 列の順で、表の全セルを1つずつ確認します。
  for (let row = 0; row < values.length; row++) {
    for (let col = 0; col < values[row].length; col++) {
      // 数式セルかどうかを確認します。
      //
      // Office ScriptsのgetFormulas()では、
      // 数式があるセルは "=" で始まる文字列として取得できます。
      const hasFormula =
        typeof formulas[row][col] === "string" &&
        String(formulas[row][col]).startsWith("=");

      // このサンプルでは、
      // 1) 数式セル
      // 2) 文字列以外のセル（数値・日付など）
      //
      // は変更しません。
      //
      // 「文字列の空白だけを掃除する」という目的に限定し、
      // 余計なデータ変換を避けるためです。
      if (hasFormula || typeof values[row][col] !== "string") {
        continue;
      }

      const before = String(values[row][col]);

      // 文字列を3段階で整えます。
      //
      // 1) \u3000
      //    日本語でよく混ざる「全角スペース」を半角スペースへ変換
      //
      // 2) \s+
      //    連続する空白文字を1つの半角スペースへまとめる
      //
      // 3) trim()
      //    文字列の先頭・末尾にある余分な空白を削除
      const after = before
        .replace(/\u3000/g, " ")
        .replace(/\s+/g, " ")
        .trim();

      // 値が変わるセルだけを書き戻します。
      //
      // 変更のないセルまでsetValue()しないことで、
      // 不要な書き込みを減らします。
      if (before !== after) {
        range.getCell(row, col).setValue(after);
        changed++;
      }
    }
  }

  // 実行結果をログへ表示します。
  // 「処理した」だけでなく、何件変わったかが分かるようにします。
  console.log(`文字列を ${changed} セル整形しました。`);
}
