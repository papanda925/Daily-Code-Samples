// Power Query M. Paste each `let ... in ...` query separately into Advanced Editor.
// Query 1: inspect the schema of a small in-memory table.
let
    Source = Table.FromRows(
        {
            {1001, "Sales", 1250.5},
            {1002, "Support", 900.0},
            {1003, "Sales", 0.0}
        },
        type table [OrderId = Int64.Type, Department = text, Amount = number]
    ),
    Schema = Table.Schema(Source),
    ImportantFields = Table.SelectColumns(
        Schema, {"Name", "Position", "TypeName", "Kind", "IsNullable"}
    )
in
    ImportantFields

// Query 2 (separate query): stop before processing a missing required column.
let
    Source = Table.FromRows(
        {
            {1001, "Sales"},
            {1002, "Support"}
        },
        type table [OrderId = Int64.Type, Department = text]
    ),
    Required = {"OrderId", "Amount"},
    Existing = Table.ColumnNames(Source),
    Missing = List.Difference(Required, Existing),
    Checked =
        if List.IsEmpty(Missing)
        then Source
        else error "Required column(s) missing: " & Text.Combine(Missing, ", ")
in
    Checked

// Query 3 (separate query): boolean-only gate for specified columns.
let
    Source = #table(
        type table [OrderId = Int64.Type, Amount = number],
        {{1001, 12.5}, {1002, 18.0}}
    ),
    HasRequired = Table.HasColumns(Source, {"OrderId", "Amount"}),
    HasOptional = Table.HasColumns(Source, {"OrderId", "Owner"})
in
    #table(
        type table [Check = text, Exists = logical],
        {{"OrderId + Amount", HasRequired}, {"OrderId + Owner", HasOptional}}
    )
