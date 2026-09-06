$plain=[Text.Encoding]::UTF8.GetBytes("Daily Code AES demo");$a=[Security.Cryptography.Aes]::Create()
try{$a.GenerateKey();$a.GenerateIV();$enc=$a.CreateEncryptor().TransformFinalBlock($plain,0,$plain.Length);$dec=$a.CreateDecryptor().TransformFinalBlock($enc,0,$enc.Length);"Encrypted="+[Convert]::ToBase64String($enc);"Decrypted="+[Text.Encoding]::UTF8.GetString($dec)}finally{$a.Dispose()}
