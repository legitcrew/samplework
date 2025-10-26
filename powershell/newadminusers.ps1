#This script is written by Alojz Cuk. This script creates a new user for Lundin Mining Depending on what permissons are needed


#Prompt the user for their first name
$firstname = Read-Host -Prompt "Enter user's first name: "

#Prompt the user for their last name
$lastname = Read-Host -Prompt "Enter user's last name: "



<#
#########################################################
-----------Initial variables for new user----------------
#########################################################
#>
$firstinitial = $firstname.Substring(0,1).ToLower()


#Standard account variables
$samstandard = "v-$firstinitial$lastname"
$upnstandard = "$samstandard@domain.com"
$emailstandard = $upnstandard
$displaynamestandard = "$firstname $lastname (Standard)"
$descriptionstandard = "Consultant - Standard"
$OUstandard = "OU=Users,OU=CSI,OU=Test,DC=domain,DC=local"
#"OU=Vendors,OU=Resources,OU=Toronto,OU=Canada,OU=LMC,DC=domain,DC=local"
$groupsstandard = @(
    "CN=ADSec-CAAZR-AVD-PoolAdmin,OU=IT Administration,OU=Security Groups,OU=Azure,OU=Canada,OU=LMC,DC=domain,DC=local",
    "CN=ADSec-CA-TOR-MFA-Users-Always-Required,OU=Azure,OU=Security Groups,OU=Toronto,OU=Canada,OU=LMC,DC=domain,DC=local"

    <#AD GROUPS#>
)

#Admin account variables
$samadmin = "v-$firstinitial$lastname.admin"
$upnadmin = "$samdamin@domain.com"
$emailadmin = $upnadmin
$displaynameadmin = "$firstname $lastname (Admin)"
$descriptionadmin = "Consultant - Admin"
$OUadmin = "OU=Vendors,OU=Resources,OU=CSI,OU=Test,DC=domain,DC=local"
#"OU=Super Users,OU=Resources,OU=Toronto,OU=Canada,OU=LMC,DC=domain,DC=local"
$groupsadmin =@(
    "CN=ADSec-CAAZR-AVD-PoolAdmin,OU=IT Administration,OU=Security Groups,OU=Azure,OU=Canada,OU=LMC,DC=domain,DC=local",
    "CN=ADSec-CA-TOR-MFA-Users-Always-Required,OU=Azure,OU=Security Groups,OU=Toronto,OU=Canada,OU=LMC,DC=domain,DC=local"


#Domain Admin account variables
$samda = "v-$firstinitial$lastname.da"
$upnda = "$samda@domain.com"
$emailda = $emailstandard
$displaynameda = "$firstname $lastname (Domain Admin)"
$descriptionda = " Consultant - Domain Admin"
$OUda = "OU=Super Users,OU=Resources,OU=CSI,OU=Test,DC=domain,DC=local"
#"OU=Super Users,OU=Resources,OU=_Global,OU=LMC,DC=domain,DC=local"
$groupsda = "CN=ADSec-CAAZR-AVD-PoolAdmin,OU=IT Administration,OU=Security Groups,OU=Azure,OU=Canada,OU=LMC,DC=domain,DC=local"

#Generic variables
$city = "Vancouver"
$state = "BC"
$postalcode = "V7X 1L2"
$country = "CA"



<#
#########################################################
-------------Functions for new users---------------------
#########################################################
#>

#Function - Create Standard Account
function standardaccountfunction {

    #Prompt the user for their standard password
    $securePasswordstandard = Read-Host Prompt "Enter standard user's password: " -AsSecureString


    New-ADUser `
        -SamAccountName $samstandard `
        -UserPrincipalName $upnstandard `
        -Name "$firstname $lastname" `
        -GivenName $firstname `
        -Surname $lastname `
        -DisplayName $displaynamestandard `
        -Description $descriptionstandard `
        -EmailAddress $emailstandard `
        -City $city `
        -State $state `
        -PostalCode $postalcode `
        -Country $country `
        -AccountPassword $securePasswordstandard `
        -Enabled $true `
        -Path $OUstandard

    #add standard user to groups
    foreach ($standardgroup in $groupsstandard) {
        Add-ADGroupMember -Identity $standardgroup -Members $samstandard
    }
    
    #rename the user to have (Standard)
    Rename-ADObject -Identity "CN=$firstname $lastname,$OUstandard" -NewName "$firstname $lastname (Standard)"
}

#Function - Create Admin Account
function adminaccountfunction {
    
    #Prompt the user for their admin password
    $securePasswordadmin = Read-Host Prompt "Enter admin user's password: " -AsSecureString

    #Craete admin user
    New-ADUser `
        -SamAccountName $samadmin `
        -UserPrincipalName $upnadmin `
        -Name "$firstname $lastname" `
        -GivenName $firstname `
        -Surname $lastname `
        -DisplayName $displaynameadmin `
        -Description $descriptionadmin `
        -EmailAddress $emailadmin `
        -City $city `
        -State $state `
        -PostalCode $postalcode `
        -Country $country `
        -AccountPassword $securePasswordadmin `
        -Enabled $true `
        -Path $OUadmin
    
    #add admin user to groups
    foreach ($admingroup in $groupsadmin) {
        Add-ADGroupMember -Identity $admingroup -Members $samadmin
    }

    #rename the user to have (Admin)
    Rename-ADObject -Identity "CN=$firstname $lastname,$OUadmin" -NewName "$firstname $lastname (Admin)"
}

#Function - Create Domain Admin Account
function daaccountfunction {
    
    #Prompt the user for their Domain Admin password
    $securePasswordda = Read-Host Prompt "Enter domain admin user's password: " -AsSecureString

    #Craete domain admin user
    New-ADUser `
        -SamAccountName $samda `
        -UserPrincipalName $upnda `
        -Name "$firstname $lastname" `
        -GivenName $firstname `
        -Surname $lastname `
        -DisplayName $displaynameda `
        -Description $descriptionda `
        -EmailAddress $emailda `
        -City $city `
        -State $state `
        -PostalCode $postalcode `
        -Country $country `
        -AccountPassword $securePasswordda `
        -Enabled $true `
        -Path $OUda
    
    #add domain admin user to groups
    foreach ($dagroup in $groupsda) {
        Add-ADGroupMember -Identity $dagroup -Members $samda
    }

    #rename the user to have (Domain Admin)
    Rename-ADObject -Identity "CN=$firstname $lastname,$OUda" -NewName "$firstname $lastname (Domain Admin)"
}

<#
#########################################################
--------------Script to create users---------------------
#########################################################
#>

#Options Defined
$option1 = "1 - Standard User"
$option2 = "2 - Admin User"
$option3 = "3 - Domain Admin User"
$option4 = "4 - Standard, Admin, and Domain Admin User"

#Prompt the user to select which account type needs to be created

Write-Host $option1
Write-Host $option2
Write-Host $option3
Write-Host $option4

#Prompt user for input
$selection = Read-Host "Please select which account you want to create:"

#Run functions based on selection

switch ($selection) {
    1 {
        standardaccountfunction
    }

    2 {
        adminaccountfunction
    }

    3 {
        daaccountfunction
    }

    4 {
        standardaccountfunction
        adminaccountfunction
        daaccountfunction
    }

    default {
        Write-Host "Invalid Selection. Please choose a number between 1 and 4"
    }
}
