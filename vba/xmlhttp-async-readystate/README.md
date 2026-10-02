# VBA XMLHTTP async=True のreadyState観察

MSXML2.XMLHTTP.6.0を使い、非同期要求で `send` 後に処理が戻り、readyStateが変化する入口を観察する教材です。

## 試し方

`AsyncXmlHttpDemo.bas` をExcel VBAの標準モジュールへ取り込み、`DemoAsyncXmlHttp` を実行します。

このサンプルは学習用の簡易ポーリングです。本格運用ではtimeout、イベント通知、失敗status、認証情報管理を別途設計してください。

[Microsoft Learn — IXMLHTTPRequest::open](https://learn.microsoft.com/previous-versions/windows/desktop/ms757849(v=vs.85))

検証状態: Microsoft MSXML仕様確認済み。Excel実機再確認は未実施。
