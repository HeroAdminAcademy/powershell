
**Remove-IdentityFromOUAcl.ps1**

Example:

Remove-IdentityFromOUAcl -OUDistinguishedName "ou=Workstations Milano,dc=heroadmin,dc=com" -Username "heroadmin\carmelo.cavallo"


**Export-WindowsLAPSPassword**

Example:

.\Extract-WindowsLAPSPassword.ps1

.\Extract-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM" 

.\Extract-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM" | Out-Grid

.\Extract-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM" | Export-CSV -Path "LAPSPassword.csv" -Encoding UTF8 -NoTypeInformation






