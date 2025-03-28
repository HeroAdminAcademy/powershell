
**Remove-IdentityFromOUAcl.ps1**

Example:

Remove-IdentityFromOUAcl -OUDistinguishedName "ou=Workstations Milano,dc=heroadmin,dc=com" -Username "heroadmin\carmelo.cavallo"


**Export-WindowsLAPSPassword**

Example:

.\Export-WindowsLAPSPassword.ps1

.\Export-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM" 

.\Export-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM" | Out-Grid

.\Export-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM" | Export-CSV -Path "LAPSPassword.csv" -Encoding UTF8 -NoTypeInformation


**Get-TemporaryGroupMembers**

Example:
Import-Module Get-TemporaryGroupMembers.ps1
Get-TemporaryGroupMembers






