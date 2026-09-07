(Source as table) as table =>
let
    NormalizeOne = (tbl as table, candidates as list, target as text) as table =>
        let
            names = Table.ColumnNames(tbl),

            // 同じ意味として扱う候補のうち、実際に存在する列だけを集めます。
            matches = List.Select(candidates, each List.Contains(names, _)),

            // 候補が複数同時に存在すると、どちらを採用すべきか自動では判断できません。
            // 片方を黙って捨てるより、ここで止めて入力CSVを確認する方を安全側とします。
            result =
                if List.Count(matches) = 0 then
                    tbl
                else if List.Count(matches) > 1 then
                    error Error.Record(
                        "SchemaConflict",
                        "同じ意味として扱う候補列が複数あります。自動統合せず確認してください。",
                        [
                            Target = target,
                            Found = Text.Combine(List.Transform(matches, each Text.From(_)), ", ")
                        ]
                    )
                else if matches{0} = target then
                    tbl
                else
                    Table.RenameColumns(tbl, {{matches{0}, target}}, MissingField.Ignore)
        in
            result,

    Step1 = NormalizeOne(Source, {"社員コード", "従業員ID", "社員ID"}, "社員ID"),
    Step2 = NormalizeOne(Step1, {"氏名", "名前", "社員名"}, "名前"),
    Step3 = NormalizeOne(Step2, {"所属", "部署", "部門"}, "部門"),

    // 必要列が不足している場合はMissingField.UseNullでnull列を補い、
    // 月ごとのCSVで列不足があっても最終スキーマを一定にします。
    StandardColumns =
        Table.SelectColumns(
            Step3,
            {"社員ID", "名前", "部門", "金額"},
            MissingField.UseNull
        )
in
    StandardColumns
