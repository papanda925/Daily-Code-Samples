(Source as table) as table =>
let
    RenameFirstExisting = (tbl as table, candidates as list, target as text) as table =>
        let
            names = Table.ColumnNames(tbl),
            sourceName = List.First(List.Select(candidates, each List.Contains(names, _)), null),
            result =
                if List.Contains(names, target) or sourceName = null or sourceName = target then
                    tbl
                else
                    Table.RenameColumns(tbl, {{sourceName, target}}, MissingField.Ignore)
        in
            result,

    Step1 = RenameFirstExisting(Source, {"社員コード", "従業員ID", "社員ID"}, "社員ID"),
    Step2 = RenameFirstExisting(Step1, {"氏名", "名前", "社員名"}, "名前"),
    Step3 = RenameFirstExisting(Step2, {"所属", "部署", "部門"}, "部門"),

    StandardColumns =
        Table.SelectColumns(
            Step3,
            {"社員ID", "名前", "部門", "金額"},
            MissingField.UseNull
        )
in
    StandardColumns
