# ExcelのREGEX関数で抽出・マスクする

Microsoft 365版Excelの `REGEXEXTRACT` / `REGEXREPLACE` を使い、ログや文字列からIDを抜き出したり、メールアドレスの一部をマスクしたりする例です。

## 例

A2に次の文字列がある想定です。

`REQ-20260906 user=tanaka@example.com ip=192.168.1.20`

`formulas.txt` の数式をそのまま試せます。

## 注意

- REGEX関数はMicrosoft 365向けです。
- ExcelのREGEXはPCRE2系の正規表現を使います。
- IPv4例は「見た目がIPv4らしい文字列」を抜く簡易例で、0〜255の厳密検証ではありません。

## 検証状態

Microsoft SupportのREGEXEXTRACT / REGEXREPLACE仕様を確認。対象Excel環境での実行確認は未実施です。

## まず試す

Excelの `REGEXEXTRACT` / `REGEXREPLACE` に対応した環境で、A2に架空の文字列 `REQ-20260906 user=tanaka@example.com ip=192.168.1.20` を入力し、[formulas.txt](formulas.txt) の各式を別のセルに貼り付けます。

**期待結果（未実行）**：ID抽出は`REQ-20260906`、メールアドレスの一部マスクは`***@example.com`を含む文字列、IPv4らしい文字列の抽出は`192.168.1.20`となる見込みです。

## 注意・トラブル・検証

IPv4の正規表現は書式だけを調べるため、`999.999.999.999`も一致し得ます。またメールアドレスの簡易置換は完全匿名化ではありません。 `#NAME?` ならExcelの関数提供状況を確認してください。2026-10-31：保存済み式を照合。実際のExcelでの動作は未検証。
