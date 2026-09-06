$s=[Windows.Media.SpeechSynthesis.SpeechSynthesizer,Windows.Media.SpeechSynthesis,ContentType=WindowsRuntime]::new()
"Default voice: $($s.Voice.DisplayName)"
[Windows.Media.SpeechSynthesis.SpeechSynthesizer]::AllVoices|Select DisplayName,Language,Gender
"SynthesizeTextToStreamAsyncはIAsyncOperationを返すため#220へ続く"
