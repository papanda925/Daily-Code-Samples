Get-ChildItem Cert:\CurrentUser\My -EA 0|Select Subject,NotBefore,NotAfter,Thumbprint|Sort NotAfter
