Attribute VB_Name = "AsyncXmlHttpDemo"
Option Explicit

Public Sub DemoAsyncXmlHttp()
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP.6.0")

    Debug.Print "[START] async=True で要求開始"
    http.Open "GET", "https://example.com/", True
    http.send
    Debug.Print "[OBSERVE] send直後 readyState=" & http.readyState

    Do While http.readyState <> 4
        DoEvents
    Loop

    Debug.Print "[RESULT] status=" & http.Status
    Debug.Print "[SUCCESS] readyState=4"
    Set http = Nothing
End Sub
