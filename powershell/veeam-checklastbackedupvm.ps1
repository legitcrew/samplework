<#
Authored by Alojz Cuk

Purpose of this script - To check if there are any VMs that havent been backed up in over a month. This usually indicates that a VM has been removed from a job but the VM backup is still
sitting in the backup file. This will alert us to figure out if we want to keep or delete the VM backup.
OpsGenie is then used to automatically open and close tickets with an integration into Slack
#>

#Log onto backup server
$SecurePassword = Get-Content "C:\securepassword.xml" | ConvertTo-SecureString

Connect-VBRServer -User $SecurePassword.user -Password $SecurePassword.password -Server 10.33.10.198 -Port 9392

#Getting VMs
$RestorePoints = Get-VBRRestorePoint
$VMs = $RestorePoints | Select-Object -ExpandProperty VmName -Unique

    


#making an array
$NotBackedVMs = @()

#Gatheres VMs last restore point after a certain amount of hours then puts it in array
foreach ($vm in $vms) {
    $NotBackedVMs += $RestorePoints | Where-Object VMName -eq $vm | Sort-Object -Property CreationTime -Descending | Select-Object -First 1 | Where-Object CreationTime -lt ((Get-Date).AddDays((-30)))
}


#Email variables
    $MyEmail = "myemail@domain.com"
    $To = "youremail@domain.com" 
    $Subject1 = "[Success] - No VMs out of date" 
    $Body1 = "There are no VMs out of date"
    $Subject2 = "[Failed] - There are VMs out of date"
    $Body2 = $NotBackedVMs | out-string
    $SMTPServer = "smtp.smtp.com"
    $SMTPPort = "25"

#functions that sends email - one for empty, one for vms
function novm {
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { return $true }
    Send-MailMessage -from $MyEmail -to $To -subject "$Subject1" -body "$Body1" -SmtpServer "$SMTPServer" -Port $SMTPPort }
function vm {
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { return $true }
    Send-MailMessage -from $MyEmail -to $To -subject "$Subject2" -body "$Body2" -SmtpServer "$SMTPServer" -Port $SMTPPort }
    

#If the array is empty, email saying all VMs fall within backup count, Else, send email with names of VMs
if ($NotBackedVMs.Count -eq 0) {
    novm
}
else {
  vm
}