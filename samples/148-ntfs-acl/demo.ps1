(Get-Acl $env:TEMP).Access|Select IdentityReference,FileSystemRights,AccessControlType,IsInherited
