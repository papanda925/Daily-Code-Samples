Option Explicit
Public Sub XmlDemo():Dim x As Object:Set x=CreateObject("MSXML2.DOMDocument.6.0"):x.LoadXML "<root><item id='1'>A</item></root>":Debug.Print x.SelectSingleNode("/root/item").Text:End Sub
