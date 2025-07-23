
function Find-GPOCriticalRights {
    [CmdletBinding()]
    param ()

    $gpoContainerDN = "CN=Policies,CN=System," + (Get-ADDomain).DistinguishedName
    $gpoList = Get-ADObject -SearchBase $gpoContainerDN -Filter 'ObjectClass -eq "groupPolicyContainer"' -Properties ntSecurityDescriptor, displayName

    $results = foreach ($gpo in $gpoList) {
        $acl = $gpo.ntSecurityDescriptor

        foreach ($ace in $acl.Access) {
            $identity = $ace.IdentityReference.ToString().ToLower()

            if (-not $ace.IsInherited -and $identity -notmatch 'creator owner|nt authority\\system') {
                if ($ace.ActiveDirectoryRights -match 'CreateChild|WriteProperty|WriteDACL|WriteOwner') {
                    [PSCustomObject]@{
                        GPOName     = $gpo.displayName
                        Identity    = $ace.IdentityReference
                        Rights      = $ace.ActiveDirectoryRights.ToString()
                        
                    }
                }
            }
        }
    }

    # Ordina e Rimuove eventuali duplicati 
    $results | Sort-Object GPOName, Identity, Rights -Unique | Format-List

    }



    

