let
    // 1. CSVを置いたフォルダーを指定します。
    //    最初は業務フォルダーではなく、テスト用フォルダーを使ってください。
    Source = Folder.Files("C:\Temp\CSV"),

    // 2. フォルダー内から .csv だけを残します。
    CsvOnly = Table.SelectRows(
        Source,
        each Text.Lower([Extension]) = ".csv"
    ),

    // 3. 各CSVの中身を表として読み込みます。
    //    Encoding=65001 はUTF-8の例です。
    AddData = Table.AddColumn(
        CsvOnly,
        "Data",
        each Table.PromoteHeaders(
            Csv.Document(
                [Content],
                [
                    Delimiter = ",",
                    Encoding = 65001,
                    QuoteStyle = QuoteStyle.Csv
                ]
            )
        )
    ),

    // 4. 各ファイルから読み込んだ表を縦方向にまとめます。
    Combined = Table.Combine(AddData[Data])
in
    Combined
