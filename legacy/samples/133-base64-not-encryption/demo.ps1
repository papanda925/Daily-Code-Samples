$plain='学習用テキスト';$b64=[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($plain));$back=[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($b64));"Base64=$b64";"Decoded=$back"
