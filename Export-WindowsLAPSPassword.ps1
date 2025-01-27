<#
.SYNOPSIS
Lo script estrae le password di Windows LAPS

.DESCRIPTION
Lo script estrae le password di Windows LAPS.

.PARAMETER OU
E' il parametro opzionale che indica la OU in cui si trovano i computer le cui password vanno esportate.
Se omesso ricercherà tutti i computer dell'interno dominio.

.EXAMPLE
.\Export-WindowsLAPSPassword.ps1
Estrae le password LAPS di tutti i computer del dominio

.EXAMPLE
.\Export-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM"
Estrae le password LAPS di tutti i computer all'interno della OU "LABS"

.EXAMPLE
.\Export-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM" | Out-Grid
Visualizza le password LAPS di tutti i computer all'interno della OU "LABS" in formato "griglia"

.EXAMPLE
.\Export-WindowsLAPSPassword.ps1 -OU "OU=LABS,DC=Heroadmin,DC=COM" | Export-CSV -Path "LAPSPassword.csv" -Encoding UTF8 -NoTypeInformation
Esporta le password LAPS dei computer all'interno della OU "LABS" in formato CSV all'interno del file "LAPSPassword.csv"

#>

[cmdletbinding()]
param(
    [string]$OU = ""  # Valore di default
)

# Controlla se l'utente ha impostato la OU e verifica se è valida
if ($OU -ne "") {
    $OUSelected = Get-ADOrganizationalUnit -Identity $OU

    Write-Verbose "$($OUSelected.distinguishedname) trovata"
}


try {

if ($OU) {
    # Restituisce tutti i computer della OU specificata
    $computers = Get-ADComputer -Filter * -SearchBase $OUSelected -Properties OperatingSystem | Select-Object Name, OperatingSystem, DistinguishedName

}
else {
    # Restituisce tutti i computer del dominio
    $computers = Get-ADComputer -Filter * -Properties OperatingSystem | Select-Object Name, OperatingSystem, DistinguishedName
}

# Inizializza la lista che verrà restituita allo script
$ComputersList = [System.Collections.Generic.List[Object]]::new()


# Cicla tutti i computer ottenuti e crea l'oggetto PSCustomObject che verrà restituito allo script
foreach ($computer in $computers) {
    try {

        # Uso la cmdlet Get-LapsADPassword per leggere le info sugli attributi del LAPS
        $passwordObject = Get-LapsADPassword $computer.Name -AsPlainText
        $password = $passwordObject.Password
        $adminaccount = $passwordObject.Account
        $expirationTimestamp = $passwordObject.ExpirationTimestamp

        # Creo l'oggetto Custom da restituire allo script
        $rowObject = [PSCustomObject]@{
            ComputerName      = $computer.Name
            LapsPassword      = $password
            ExpirationTime    = $expirationTimestamp
            LocalAdminAccount = "$adminaccount"
            OperatingSystem   = $computer.OperatingSystem
            DistinguishedName = $computer.DistinguishedName
        }

        $ComputersList.Add($rowObject)
    }
    
    catch {
        # Restituisce l'eccezione
        Write-Host "Eccezione su $($computer.Name): $_" -ForegroundColor Red
    }
     

}

   $ComputersList | Sort-Object Computername 
      

}
catch {

Write-Host "Error: $($_.Exception.Message)"

}

