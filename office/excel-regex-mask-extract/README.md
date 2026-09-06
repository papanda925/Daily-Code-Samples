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
