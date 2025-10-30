import-module activedirectory
#Import-Module admpwd.ps

#Copy the value from the 'distinguishedName' attibute for the folder in ADUC
$Path = "OU=Azure,OU=Canada,OU=VC,DC=Domain,DC=local"

$ServerADM =         "ADSec-CA-AZV-Servers.adm"
$WorkstationsADM =   "ADSec-CA-AZV-Workstations.adm"
#$ADSecLE1ADM =       "ADSec-BRAZV-Azure-Licensing-E1-All"
#$ADSecLE3ADM =       "ADSec-BRAZV-Azure-Licensing-E3-All"
#$ADSecMFAUsersADM =  "ADSec-BRAZV-MFA-Users"


if(![adsi]::Exists("LDAP://$Path"))
{
    [System.Windows.MessageBox]::Show("OU Path`n`n" + $Path + "`n`ndoes not exist!`n`nScript will exist now.")

}
else
{
    [System.Windows.MessageBox]::Show("OU Path`n`n" + $Path + "`n`nis valid!`n`nScript will create OUs and delegations.")


    if(![adsi]::Exists("LDAP://OU=Disabled,$Path"))                     { New-ADOrganizationalUnit -Name "Disabled" -Path $Path }
    if(![adsi]::Exists("LDAP://OU=Servers,OU=Disabled,$Path"))          { New-ADOrganizationalUnit -Name "Servers" -Path "OU=Disabled,$Path"}
    if(![adsi]::Exists("LDAP://OU=Users,OU=Disabled,$Path"))            { New-ADOrganizationalUnit -Name "Users" -Path "OU=Disabled,$Path"}
    if(![adsi]::Exists("LDAP://OU=Vendors,OU=Disabled,$Path"))          { New-ADOrganizationalUnit -Name "Vendors" -Path "OU=Disabled,$Path"}
    if(![adsi]::Exists("LDAP://OU=Workstations,OU=Disabled,$Path"))     { New-ADOrganizationalUnit -Name "Workstations" -Path "OU=Disabled,$Path"}

    if(![adsi]::Exists("LDAP://OU=Distribution Groups,$Path"))            { New-ADOrganizationalUnit -Name "Distribution Groups" -Path $Path }

    if(![adsi]::Exists("LDAP://OU=Resources,$Path"))                      { New-ADOrganizationalUnit -Name "Resources" -Path $Path }
    if(![adsi]::Exists("LDAP://OU=Service Accounts,OU=Resources,$Path"))  { New-ADOrganizationalUnit -Name "Service Accounts" -Path "OU=Resources,$Path"}
    if(![adsi]::Exists("LDAP://OU=Shared Mailboxes,OU=Resources,$Path"))  { New-ADOrganizationalUnit -Name "Shared Mailboxes" -Path "OU=Resources,$Path"}
    if(![adsi]::Exists("LDAP://OU=Super Users,OU=Resources,$Path"))       { New-ADOrganizationalUnit -Name "Super Users" -Path "OU=Resources,$Path"}
    if(![adsi]::Exists("LDAP://OU=Vendors,OU=Resources,$Path"))           { New-ADOrganizationalUnit -Name "Vendors" -Path "OU=Resources,$Path"}
    if(![adsi]::Exists("LDAP://OU=Contacts,OU=Resources,$Path"))           { New-ADOrganizationalUnit -Name "Contacts" -Path "OU=Resources,$Path"}

    if(![adsi]::Exists("LDAP://OU=Security Groups,$Path"))                      { New-ADOrganizationalUnit -Name "Security Groups" -Path $Path }
    if(![adsi]::Exists("LDAP://OU=File Services,OU=Security Groups,$Path"))     { New-ADOrganizationalUnit -Name "File Services" -Path "OU=Security Groups,$Path"}
    if(![adsi]::Exists("LDAP://OU=IT Administration,OU=Security Groups,$Path")) { New-ADOrganizationalUnit -Name "IT Administration" -Path "OU=Security Groups,$Path"}
    if(![adsi]::Exists("LDAP://OU=Azure,OU=Security Groups,$Path"))              { New-ADOrganizationalUnit -Name "Azure" -Path "OU=Security Groups,$Path"}

    if(![adsi]::Exists("LDAP://OU=Servers,$Path"))                          { New-ADOrganizationalUnit -Name "Servers" -Path $Path }

    if(![adsi]::Exists("LDAP://OU=Users,$Path"))                            { New-ADOrganizationalUnit -Name "Users" -Path $Path }

    if(![adsi]::Exists("LDAP://OU=Workstations,$Path"))                     { New-ADOrganizationalUnit -Name "Workstations" -Path $Path }



    #Create security groups if they do not already exist.
    $GroupExists = Get-ADGroup -LDAPFilter "(SAMAccountName=$ServerADM)"
    if ($GroupExists -eq $NULL) {
        New-ADGroup -GroupCategory: "Security" -GroupScope: "Global" -Name $ServerADM -Path "OU=IT Administration,OU=Security Groups,$Path" `
                    -SamAccountName $ServerADM -Description "Local administrators for Servers in path $PATH"
                     
    }

    $GroupExists = Get-ADGroup -LDAPFilter "(SAMAccountName=$WorkstationsADM)"
    if ($GroupExists -eq $NULL) {
        New-ADGroup -GroupCategory: "Security" -GroupScope: "Global" -Name $WorkstationsADM -Path "OU=IT Administration,OU=Security Groups,$Path" `
                -SamAccountName $WorkstationsADM -Description "Local administrators for Workstations in path $PATH" 
                     
    }

#    $GroupExists = Get-ADGroup -LDAPFilter "(SAMAccountName=$ADSecLE1ADM)"
#    if ($GroupExists -eq $NULL) {
#        New-ADGroup -GroupCategory: "Security" -GroupScope: "Global" -Name $ADSecLE1ADM -Path "OU=Azure,OU=Security Groups,$Path" `
#                -SamAccountName $ADSecLE1ADM -Description "Automatically assigns E1 licenses" 
#                     
#    }

#    $GroupExists = Get-ADGroup -LDAPFilter "(SAMAccountName=$ADSecLE3ADM)"
#    if ($GroupExists -eq $NULL) {
#        New-ADGroup -GroupCategory: "Security" -GroupScope: "Global" -Name $ADSecLE3ADM -Path "OU=Azure,OU=Security Groups,$Path" `
#                -SamAccountName $ADSecLE3ADM -Description "Automatically assigns E3 licenses" 
#                     
#    }

#    $GroupExists = Get-ADGroup -LDAPFilter "(SAMAccountName=$ADSecMFAUsersADM)"
#    if ($GroupExists -eq $NULL) {
#        New-ADGroup -GroupCategory: "Security" -GroupScope: "Global" -Name $ADSecMFAUsersADM -Path "OU=Azure,OU=Security Groups,$Path" `
#                -SamAccountName $ADSecMFAUsersADM -Description "MFA required for O365 services when not at a trusted location." 
#                     
#    }


    $guidmap = @{}
    $rootdse = Get-ADRootDSE
    Get-ADObject -SearchBase ($rootdse.SchemaNamingContext) -LDAPFilter "(schemaidguid=*)" -Properties lDAPDisplayName,schemaIDGUID | 
            % {$guidmap[$_.lDAPDisplayName]=[System.GUID]$_.schemaIDGUID}

    $guid = [guid]'00000000-0000-0000-0000-000000000000'

    #Delegate permissions for Server Administrators
    $Group = Get-ADGroup -LDAPFilter "(SAMAccountName=$ServerADM)"
    if ($Group -ne $NULL) {
        $GroupSID = [System.Security.Principal.SecurityIdentifier] $Group.SID

        # Build Access Control Entry (ACE) for Server Administrators
        #$ace = new-object System.DirectoryServices.ActiveDirectoryAccessRule $identity,$adRights,                 $type,$objectGuid,              $inheritanceType,$inheritedobjectguid
        $ace1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "GenericAll",             "Allow", $guid,                  "Descendents",$guidmap["computer"])
        $ace2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "CreateChild, DeleteChild", "Allow", $guidmap["computer"],"SelfAndChildren")

        for ($i=1;$i-le 2;$i++) 
        {
            if ($i -eq 1) { $ou = "OU=Servers,OU=Disabled,$Path" }
            if ($i -eq 2) { $ou = "OU=Servers,$Path" }

            if([adsi]::Exists("LDAP://$ou"))
            {
                $acl = Get-Acl -Path "AD:$ou"
                $acl.AddAccessRule($ace1)
                $acl.AddAccessRule($ace2)
                Set-Acl -Path "AD:$ou" -AclObject $acl   
                Write-Host "Path $ou has been updated for Server administration for computer objects."                   
            }
        }

        $ace1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "GenericAll",             "Allow", $guid,                  "Descendents",$guidmap["user"])
        $ace2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "CreateChild, DeleteChild", "Allow", $guidmap["user"],"SelfAndChildren")

        $ou = "OU=Service Accounts,OU=Resources,$Path"
        if([adsi]::Exists("LDAP://$ou"))
        {
            $acl = Get-Acl -Path "AD:$ou"
            $acl.AddAccessRule($ace1)
            $acl.AddAccessRule($ace2)
            Set-Acl -Path "AD:$ou" -AclObject $acl                     
            Write-Host "Path $ou has been updated for Server administration for user objects."                   
        }
    }

    $Group = Get-ADGroup -LDAPFilter "(SAMAccountName=$WorkstationsADM)"
    if ($Group -ne $NULL) {
        $GroupSID = [System.Security.Principal.SecurityIdentifier] $Group.SID

        # Build Access Control Entry (ACE) for Workstations Administrators
        #$ace = new-object System.DirectoryServices.ActiveDirectoryAccessRule $identity,$adRights,                 $type,$objectGuid,              $inheritanceType,$inheritedobjectguid
        $ace1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "GenericAll",             "Allow", $guid,                  "Descendents",$guidmap["computer"])
        $ace2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "CreateChild, DeleteChild", "Allow", $guidmap["computer"],"SelfAndChildren")

        for ($i=1; $i -le 2; $i++) 
        {
            if ($i -eq 1) { $ou = "OU=Workstations,OU=Disabled,$Path" }
            if ($i -eq 2) { $ou = "OU=Workstations,$Path" }

            if([adsi]::Exists("LDAP://$ou"))
            {
                $acl = Get-Acl -Path "AD:$ou"
                $acl.AddAccessRule($ace1)
                $acl.AddAccessRule($ace2)
                Set-Acl -Path "AD:$ou" -AclObject $acl                     
                Write-Host "Path $ou has been updated for Workstation administration for computer objects."                   
            }
        }

        # Build Access Control Entry (ACE) for Users Administrators
        #$ace = new-object System.DirectoryServices.ActiveDirectoryAccessRule $identity,$adRights,                 $type,$objectGuid,              $inheritanceType,$inheritedobjectguid
        $ace1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "GenericAll",             "Allow", $guid,                  "Descendents",$guidmap["user"])
        $ace2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "CreateChild, DeleteChild", "Allow", $guidmap["user"],"SelfAndChildren")

        for ($i=1; $i -le 6; $i++) 
        {
            if ($i -eq 1) { $ou = "OU=Users,OU=Disabled,$Path" }
            if ($i -eq 2) { $ou = "OU=Vendors,OU=Disabled,$Path" }
            if ($i -eq 3) { $ou = "OU=Shared Mailboxes,OU=Resources,$Path" }
            if ($i -eq 4) { $ou = "OU=Super Users,OU=Resources,$Path" }
            if ($i -eq 5) { $ou = "OU=Vendors,OU=Resources,$Path" }
            if ($i -eq 6) { $ou = "OU=Users,$Path" }

            if([adsi]::Exists("LDAP://$ou"))
            {
                $acl = Get-Acl -Path "AD:$ou"
                $acl.AddAccessRule($ace1)
                $acl.AddAccessRule($ace2)
                Set-Acl -Path "AD:$ou" -AclObject $acl                     
                Write-Host "Path $ou has been updated for Workstation administration for user objects."                   
            }
        }

        # Build Access Control Entry (ACE) for Group Administrators
        #$ace = new-object System.DirectoryServices.ActiveDirectoryAccessRule $identity,$adRights,                 $type,$objectGuid,              $inheritanceType,$inheritedobjectguid
        $ace1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "GenericAll",             "Allow", $guid,                  "Descendents",$guidmap["group"])
        $ace2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "CreateChild, DeleteChild", "Allow", $guidmap["group"],"SelfAndChildren")

        for ($i=1; $i -le 2; $i++) 
        {
            if ($i -eq 1) { $ou = "OU=Security Groups,$Path" }
            if ($i -eq 2) { $ou = "OU=Distribution Groups,$Path" }

            if([adsi]::Exists("LDAP://$ou"))
            {
                $acl = Get-Acl -Path "AD:$ou"
                $acl.AddAccessRule($ace1)
                $acl.AddAccessRule($ace2)
                Set-Acl -Path "AD:$ou" -AclObject $acl                     
                Write-Host "Path $ou has been updated for Workstation administration for group objects."                   
            }
        }

        # Build Access Control Entry (ACE) for Contact Administrators
        #$ace = new-object System.DirectoryServices.ActiveDirectoryAccessRule $identity,$adRights,                 $type,$objectGuid,              $inheritanceType,$inheritedobjectguid
        $ace1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "GenericAll",             "Allow", $guid,                  "Descendents",$guidmap["contact"])
        $ace2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($GroupSID, "CreateChild, DeleteChild", "Allow", $guidmap["contact"],"SelfAndChildren")

        $ou = "OU=Contacts,OU=Resources,$Path"
        $acl = Get-Acl -Path "AD:$ou"
        $acl.AddAccessRule($ace1)
        $acl.AddAccessRule($ace2)
        Set-Acl -Path "AD:$ou" -AclObject $acl                     
        Write-Host "Path $ou has been updated for Workstation administration for contact objects."                   


    }

    #Write-Host "Must wait 15 seconds for OUs to be created before assigning LAPS permissions."                   
    #Start-Sleep -Seconds 15

    #Set the LAPS permissions
    #Set-AdmPwdComputerSelfPermission -OrgUnit "OU=Servers,$Path"
    #Set-AdmPwdComputerSelfPermission -OrgUnit "OU=Workstations,$Path"

    #Set-AdmPwdReadPasswordPermission -OrgUnit "OU=Servers,$Path" -AllowedPrincipals $ServerADM
    #Set-AdmPwdReadPasswordPermission -OrgUnit "OU=Workstations,$Path" -AllowedPrincipals $WorkstationsADM

    #Set-AdmPwdResetPasswordPermission -OrgUnit "OU=Servers,$Path" -AllowedPrincipals $ServerADM
    #Set-AdmPwdResetPasswordPermission -OrgUnit "OU=Workstations,$Path" -AllowedPrincipals $WorkstationsADM


    [System.Windows.MessageBox]::Show("OUs and groups have been created.")

}



