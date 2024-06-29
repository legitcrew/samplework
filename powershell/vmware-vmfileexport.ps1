<#
Authored by Alojz Cuk

What this sript does - Does a full VM export from v1 and v2 vcenter and transfers files into the software drive
#>

#vcenter1 details
$v1vmcsv = "C:\powershell\\vmlist\vcenter1.domain.local-vmlist-$((Get-Date).ToString('dd-MM-yyyy')).csv"
$v1vcentercreds = Get-VICredentialStoreItem -Host vcenter1.domain.local -File C:\git\creds\vcenter1.domain.local-vcentercreds.txt
$homefolder = "C:\powershell\vmlist\"

#vcenter2 details
$v2vmcsv = "C:\powershell\\vmlist\vcenter2.domain.local-vmlist-$((Get-Date).ToString('dd-MM-yyyy')).csv"
$v2vcentercreds = Get-VICredentialStoreItem -Host vcenter2.domain.local -File C:\git\creds\vcenter2.domain.local-vcentercreds.txt

#fileshare details
$v1Source = $v1vmcsv
$v2Source = $v2vmcsv
$Destination = "X:\"
$Password  = "C:\powershell\creds\veeam-filetransfercreds.txt"
$User = "domain\veeam-filetransfer"
$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user,(Get-Content $Password | ConvertTo-SecureString)

#Setting execution policy so it runs properly
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope CurrentUser





#log onto vcenter1
Connect-VIServer vcenter1.domain.local -User $v1vcentercreds.User -Password $v1vcentercreds.Password

#Gets list of all VMs from phx-v1-vcenter
Get-VM | Select-Object * | Export-Csv -Path $v1vmcsv

#Disconnects from v1 vcenter
Disconnect-VIServer vcenter1.domain.local -Force -Confirm:$False

#log onto v2-vcneter
Connect-VIServer vcenter2.domain.local -User $v2vcentercreds.User -Password $v2vcentercreds.Password


#Gets list of all VMs from v2 vcenter
Get-VM | Select-Object * | Export-Csv -Path $v2vmcsv

#Disconnects from v2 vcenter
Disconnect-VIServer vcenter2.domain.local -Force -Confirm:$False


#Connects to shared folder
New-PSDrive -Name X -PSProvider FileSystem -Root "\\phx-v1-fs01\software\Powershell\VMware\vm-list" -Credential $credentials

#Copy files to destination
Copy-Item $v1Source -Destination $Destination
Copy-Item $v2Source -Destination $Destination




#Deletes files in destination folder older than 30 days
Get-ChildItem �Path $Destination -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-30))} | Remove-Item

#Deletes files in home folder older than 30 days
Get-ChildItem �Path $homefolder | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-30))} | Remove-Item




#Disconnects from shared folder
Remove-PSDrive -Name X
