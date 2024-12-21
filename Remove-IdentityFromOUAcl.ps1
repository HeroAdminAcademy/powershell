function Remove-IdentityFromOUAcl {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$OUDistinguishedName,

        [Parameter(Mandatory = $true)]
        [string]$Username
    )

    try {
    

        $OU = Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$OUDistinguishedName'"
        if (-not $OU) {
            Write-Error "OU not found: $OUPath"
            return
        }
        
        # Get the security descriptor for the OU
        $acl = Get-Acl -Path "AD:$OUDistinguishedName"

        # Find the user's access rule
        $identityReference = New-Object System.Security.Principal.NTAccount($Username)
        $accessRules = $acl.Access | Where-Object { $_.IdentityReference -eq $identityReference }

        if (-not $accessRules) {
            Write-Warning "No access rules found for user $Username in OU $OUDistinguishedName"
            return
        }

        # Remove all access rules for the user
        foreach ($rule in $accessRules) {
            $acl.RemoveAccessRule($rule) | Out-Null
        }

        # Set the updated ACL back to the OU
        Set-Acl -Path "AD:$OUDistinguishedName" -AclObject $acl
        Write-Host "Successfully removed user '$Username' from ACL of OU '$OUDistinguishedName'" -ForegroundColor Green


    }
    catch {
        Write-Error "An error occurred: $_"
    }
}
