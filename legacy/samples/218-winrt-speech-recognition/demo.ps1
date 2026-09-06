$r=[Windows.Media.SpeechRecognition.SpeechRecognizer,Windows.Media.SpeechRecognition,ContentType=WindowsRuntime]::new();$r|Select CurrentLanguage,State
"マイク権限・言語設定が必要。CompileConstraintsAsync / RecognizeAsyncはWinRT非同期API"
