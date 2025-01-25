
**Remove-IdentityFromOUAcl.ps1**

Example:

Remove-IdentityFromOUAcl -OUDistinguishedName "ou=Workstations Milano,dc=heroadmin,dc=com" -Username "heroadmin\carmelo.cavallo"


**Export-WindowsLAPSPassword**

Example:

Extracts the LAPS Passwords of all computers in the domain
.\Extract-WindowsLAPSPassword.ps1

Extracts the LAPS Passwords of the computers in a specific OU
.\Extract-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM" 

.\Extract-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM" | Out-Grid

Extracts the LAPS Passwords of computers in a specific OU and exports them to a CSV file
.\Extract-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM" | Export-CSV -Path "LAPSPassword.csv" -Encoding UTF8 -NoTypeInformation






