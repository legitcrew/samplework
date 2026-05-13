<# 
Authored By Alojz Cuk
The Purpose of this script is to get a list of all Windows VMs in netbox that has a Standard License attached to it.
This is used for reporting purposes
#>

$SecurePassword = Get-Content "C:\securepassword.xml" | ConvertTo-SecureString
$api_base_url = "https://api.netbox.domain.com/api"
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", 'Token '$SecurePassword.password)
$headers.Add("Content-Type", 'application/json')
$headers.Add("Accept", 'application/json')
# Fetch information about host and select hosts with status 'Active'
$getDeviceInfo = (Invoke-RestMethod -Uri $api_base_url/dcim/devices/?tag=os-windows -Headers $headers).results | Where-Object { $_.status.value -eq 'active' }

$newCollection = @()

ForEach ($server in $getDeviceInfo) {

    $newCollection += New-Object -TypeName PSObject -Property @{
        Name       = $server.display
        Edition    = (($server.tags.display | Select-String "Edition-ServerSta*" ).Line.Trim('Edition-')) -replace "[^a-z]"
        Year       = (($server.tags.display | Select-String "WindowsVersion-*" ).Line.Trim('WindowsVersion-')) -replace "[^0-9]"
        ProductKey = ($server.tags.display | Select-String "ProductKey" ).Line.Trim('ProductKey-')
        Cores      = $server.custom_fields.server_cores
        Threads    = $server.custom_fields.server_threads
    }
}

$newCollection | Export-Csv "C:\git\output\report$(get-date -f yyyy-MM-dd).csv"
$newCollection


#Email variables
    $MyEmail = "myemail@domain.com"
    $To = "slackchannel@slack.com" 
    $Subject = "SPLA physical datacenter report"
    $file = "C:\git\output\report$(get-date -f yyyy-MM-dd).csv"
    $Body = $newCollection | out-string
    $SMTPServer = "smtp.smtp.com"
    $SMTPPort = "25"

 #Send email
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { return $true }
    Send-MailMessage -from $MyEmail -to $To -subject "$Subject" -body "$Body" -SmtpServer "$SMTPServer" -Port $SMTPPort -Attachment $file
