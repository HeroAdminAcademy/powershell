<#
.SYNOPSIS
La Function estrae l'elenco di tutti i gruppi su cui è stata assegnata una Temporary Membership (con il valore del TTL), con i rispettivi utenti di cui ne fanno parte

.DESCRIPTION
La Function estrae l'elenco di tutti i gruppi su cui è stata assegnata una Temporary Membership (con il valore del TTL), con i rispettivi utenti di cui ne fanno parte

.PARAMETER DomainController
E' il parametro opzionale se specifica il DC su cui effettuare la query.


.EXAMPLE
Import-Module .\Get-TemporaryGroupMembers.ps1
Get-TemporaryGroupMembers
Importa la function ed estrai i gruppi


#>

function Get-TemporaryGroupMembers {
    [CmdletBinding()]
    param(
        [string]$DomainController = (Get-ADDomainController).HostName
    )
    
    $groupsWithTempMembers = @()
    try {

        $groups = Get-ADGroup -Filter * -Server $DomainController -ShowMemberTimeToLive -Properties *
        
        foreach ($group in $groups) {
            
            foreach ($m in $group.member) {

             if ($m -match "<TTL=(\d+)>") {
                $number = $matches[1]
                $TimeSpan = New-TimeSpan -Seconds $number

                if ($m -match "CN=([^,]+)") {
                    $username = $matches[1]
                }

                 $groupsWithTempMembers += [PSCustomObject]@{
                    GroupName   = $group.Name
                    AccountName = $username
                    TTL = $TimeSpan 

                    }
                           
                }
            
            }
                       
            
        }

        return $groupsWithTempMembers

    }
    catch {
        Write-Error "Errore durante la ricerca dei membri temporanei: $_"
    }
}
