$langs=[Windows.Media.Ocr.OcrEngine,Windows.Media.Ocr,ContentType=WindowsRuntime]::AvailableRecognizerLanguages;$langs|Select LanguageTag,DisplayName
"画像→SoftwareBitmap→OcrEngine.RecognizeAsyncという層を確認"
