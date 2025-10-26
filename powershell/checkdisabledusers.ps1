<#
##############################################################################
----------------Get disabled users in global & corporate---------------------
##############################################################################
#>


# Define the distinguished names of the two OUs
$ou1 = "OU=_Global,OU=domain,DC=domain,DC=local"
$ou2 = "OU=Canada,OU=domain,DC=domain,DC=local"

#csvpath
$csvPath = ".\Disabled-Users-global-and-corporate.csv"

# Search for users in the first OU
$usersInOU1 = Get-ADUser -SearchBase $ou1 -Filter {enabled -eq $false} -Properties DisplayName, SamAccountName, DisplayName, DistinguishedName 

# Search for users in the second OU
$usersInOU2 = Get-ADUser -SearchBase $ou2 -Filter {enabled -eq $false} -Properties DisplayName, SamAccountName, DisplayName, DistinguishedName 

# Combine the results from both OUs
$combinedUsers = $usersInOU1 + $usersInOU2

# Output the combined results
$combinedUsers | Export-Csv -Path $csvPath -NoTypeInformation


<#
##############################################################################
--------------Get disabled computers in global & corporate-------------------
##############################################################################
#>


# Define the distinguished names of the two OUs
$ou1 = "OU=_Global,OU=domain,DC=domain,DC=local"
$ou2 = "OU=Canada,OU=domain,DC=domain,DC=local"

# CSV path
$csvPath = ".\Disabled-Computers-global-and-corporate.csv"

# Search for computers in the first OU
$computersInOU1 = Get-ADComputer -SearchBase $ou1 -Filter {enabled -eq $false} -Properties Name, SamAccountName, DistinguishedName

# Search for computers in the second OU
$computersInOU2 = Get-ADComputer -SearchBase $ou2 -Filter {enabled -eq $false} -Properties Name, SamAccountName, DistinguishedName

# Combine the results from both OUs
$combinedComputers = $computersInOU1 + $computersInOU2

# Output the combined results
$combinedComputers | Export-Csv -Path $csvPath -NoTypeInformation


<#
##############################################################################
---------Get disabled users in global & corporate not in disabled OU----------
##############################################################################
#>


# Define the distinguished names of the two OUs
$ou1 = "OU=_Global,OU=domain,DC=domain,DC=local"
$ou2 = "OU=Canada,OU=domain,DC=domain,DC=local"

#csvpath
$csvPath = ".\Disabled-Users-not-disabled-ou-global-and-corporate.csv"

# Search for users in the first OU
$usersInOU1 = Get-ADUser -SearchBase $ou1 -Filter {enabled -eq $false} -Properties DisplayName, SamAccountName, DisplayName, DistinguishedName |
    Where-Object { $_.DistinguishedName -notlike "*OU=disabled*" }

    # Search for users in the second OU
$usersInOU2 = Get-ADUser -SearchBase $ou2 -Filter {enabled -eq $false} -Properties DisplayName, SamAccountName, DisplayName, DistinguishedName |
Where-Object { $_.DistinguishedName -notlike "*OU=disabled*" }

# Combine the results from both OUs
$combinedUsers = $usersInOU1 + $usersInOU2

# Output the combined results
$combinedUsers | Export-Csv -Path $csvPath -NoTypeInformation


<#
##############################################################################
-------Get disabled computers in global & corporate not in disabled OU--------
##############################################################################
#>


# Define the distinguished names of the two OUs
$ou1 = "OU=_Global,OU=domain,DC=domain,DC=local"
$ou2 = "OU=Canada,OU=domain,DC=domain,DC=local"

# CSV path
$csvPath = ".\Disabled-Computers-not-disabled-ou-global-and-corporate.csv"

# Search for computers in the first OU and exclude those with "disabled" in DistinguishedName
$computersInOU1 = Get-ADComputer -SearchBase $ou1 -Filter {enabled -eq $false} -Properties Name, SamAccountName, DistinguishedName | 
    Where-Object { $_.DistinguishedName -notlike "*OU=disabled*" }

# Search for computers in the second OU and exclude those with "disabled" in DistinguishedName
$computersInOU2 = Get-ADComputer -SearchBase $ou2 -Filter {enabled -eq $false} -Properties Name, SamAccountName, DistinguishedName | 
    Where-Object { $_.DistinguishedName -notlike "*OU=disabled*" }

# Combine the results from both OUs
$combinedComputers = $computersInOU1 + $computersInOU2

# Output the combined results to a CSV
$combinedComputers | Export-Csv -Path $csvPath -NoTypeInformation