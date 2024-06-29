<#
This is a template that I found online but made my own edits. A firewall script that allows to open all ports needed for Veeam to work properly
#>


$seconds = 30
Write-Host "Please reset the firewall to default now. Counting down from " -NoNewLine
do {
	Start-Sleep -Seconds 1
	Write-Host "$seconds " -NoNewLine
} while($seconds-- -gt 0)
Write-Host "..."

## INBOUND RULES

[System.Collections.ArrayList]$rules = @()

## SolarWinds

<# You can add/replace here any existing firewall rules that your remote access tool(s)
need #>

$params = @{
	DisplayName = "NableUpdateService";
	Enabled = 'True';
	Action = "Allow";
	Direction = "Inbound";
	Protocol = "TCP";
	LocalPort = 15000;
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Take Control Agent - [N-Central] - TCP";
	Description = "Take Control Agent - [N-Central]";
	Enabled = 'True';
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files (x86)\BeAnywhere Support Express\GetSupportService_N-Central\BASupSrvc.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Take Control Agent - [N-Central] - UDP";
	Description = "Take Control Agent - [N-Central]";
	Enabled = 'True';
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files (x86)\BeAnywhere Support Express\GetSupportService_N-Central\BASupSrvc.exe";
	Protocol = "UDP";
	Profile = "Any";
}
$rules.Add($params) > $Null

## Veeam

#Remote Address IPs for firewall
$RemoteAddress = "10.10.10.210-10.10.10.220", "10.10.20.210-10.10.20.220"

$params = @{

	DisplayName = "Veeam Backup Management Service (In)";
	Description = "Inbound rule for Veeam Backup Management Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.Service.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Backup Remote PowerShell Manager (In)";
	Description = "Inbound rule for Veeam Backup Remote PowerShell Manager";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.PSManager.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Backup Secure Communication (In)";
	Description = "Inbound rule for secure connections between Veeam Backup & Replication components";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Protocol = "TCP";
	LocalPort = 9401
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null


$params = @{
	DisplayName = "Veeam RPC (In)";
	Description = "Inbound rule for RPC functions";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Protocol = "TCP";
	LocalPort = 6160
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Backup UI Server (In)";
	Description = "Inbound rule for Veeam Backup UI Server";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.UIServer.exe";
	Protocol = "TCP";
	LocalPort = 9396;
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Backup VSS Integration Service (In)";
	Description = "Inbound rule for Veeam Backup VSS Integration Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup File System VSS Integration\VeeamFilesysVssSvc.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Broker Service (In)";
	Description = "Inbound rule for Veeam Broker Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.BrokerService.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Catalog Service (In)";
	Description = "Inbound rule for Veeam Catalog Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup Catalog\Veeam.Backup.CatalogDataService.exe";
	Protocol = "TCP";
	LocalPort = 9393;
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Cloud Connect Service (In)";
	Description = "Inbound rule for Veeam Cloud Connect Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.CloudService.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Data Mover (In)";
	Description = "Inbound rule for Veeam Data Mover included with Veeam Backup and Replication";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\WinAgent\VeeamAgent.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Data Mover (Veeam Catalog Service) (In)";
	Description = "Inbound rule for Veeam Data Mover included with Veeam Catalog Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup Catalog\WinAgent\VeeamAgent.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Data Mover (Veeam Transport Service) (In)";
	Description = "Inbound rule for Veeam Data Mover included with Veeam Transport Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files (x86)\Veeam\Backup Transport\x86\VeeamAgent.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Data Mover x64 (Veeam Transport Service) (In)";
	Description = "Inbound rule for Veeam Data Mover x64 included with Veeam Transport Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files (x86)\Veeam\Backup Transport\x64\VeeamAgent.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Distribution Service (In)";
	Description = "Inbound rule for Veeam Distribution Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Veeam Distribution Service\Veeam.Backup.Agent.ConfigurationService.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Guest Interaction Proxy (In)";
	Description = "Inbound rule for Veeam Guest Interaction Proxy";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files (x86)\Veeam\Backup Transport\GuestInteraction\Veeam.Guest.Interaction.Proxy.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Installer Service (Veeam Backup and Replication) (In)";
	Description = "Inbound rule for Veeam Installer Service included with Veeam Backup and Replication";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Windows\Veeam\Backup and Replication\VeeamDeploymentSvc.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Installer Service (Veeam Backup and Replication) (In)";
	Description = "Inbound rule for Veeam Installer Service included with Veeam Backup and Replication";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Windows\Veeam\Backup and Replication\VeeamDeploymentSvc.exe";
	Protocol = "UDP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam NetBIOS (In)";
	Description = "Inbound rule for Veeam Adding Proxy";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Protocol = "TCP";
	LocalPort = "135-139";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam NetBIOS (In)";
	Description = "Inbound rule for Veeam Adding Proxy";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Protocol = "UDP";
	LocalPort = "135-139";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Restore Veeam Backup & Replication console (In)";
	Description = "Inbound rule for Veeam Adding Proxy";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Protocol = "TCP";
	LocalPort = "445";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Restore Veeam Backup & Replication console (In)";
	Description = "Inbound rule for Veeam Adding Proxy";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Protocol = "UDP";
	LocalPort = "445";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Mount Service (In)";
	Description = "Inbound rule for Veeam Mount Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Common Files\Veeam\Backup and Replication\Mount Service\Veeam.Backup.MountService.exe";
	Protocol = "TCP";
	LocalPort = 6170;
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Traffic Redirector (In)";
	Description = "Inbound rule for Veeam Traffic Redirector included with Veeam Backup & Replication";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\VeeamNetworkRedirector.exe";
	Protocol = "TCP";
	LocalPort = 6170;
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Traffic Redirector (Veeam Backup & Replication console) (In)";
	Description = "Inbound rule for Veeam Network Traffic included with Veeam Backup & Replication console";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Console\VeeamNetworkRedirector.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Transport Service (In)";
	Description = "Inbound rule for Veeam Transport Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files (x86)\Veeam\Backup Transport\VeeamTransportSvc.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam vPower NFS Service (In)";
	Description = "Inbound rule for Veeam vPower NFS Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files (x86)\Veeam\vPowerNFS\VeeamNFSSvc.exe";
	Protocol = "TCP";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam.Backup.Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.Service.exe";
	Protocol = "UDP";
	LocalPort = "Any";
	RemotePort = "Any";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam.Backup.Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.Service.exe";
	Protocol = "TCP";
	LocalPort = "Any";
	RemotePort = "Any";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "VeeamAgent";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup Catalog\WinAgent\VeeamAgent.exe";
	Protocol = "UDP";
	LocalPort = "Any";
	RemotePort = "Any";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "VeeamAgent";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup Catalog\WinAgent\VeeamAgent.exe";
	Protocol = "TCP";
	LocalPort = "Any";
	RemotePort = "Any";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam WMI communication (In)";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Inbound";
	Protocol = "TCP";
	LocalPort = "49152-65535";
	RemotePort = "Any";
	Profile = "Any";
    RemoteAddress = $RemoteAddress;
}
$rules.Add($params) > $Null

## OUTBOUND RULES

$params = @{
	DisplayName = "Veeam Backup Management Service (Out)";
	Description = "Outbound rule for Veeam Backup Management Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.Service.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Backup Remote PowerShell Manager (Out)";
	Description = "Outbound rule for Veeam Backup Remote PowerShell Manager";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.PSManager.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Backup Secure Communication (Out)";
	Description = "Outbound rule for secure connections between Veeam Backup & Replication components";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Protocol = "TCP";
	LocalPort = 9401;
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Backup UI Server (Out)";
	Description = "Outbound rule for Veeam Backup UI Server";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.UIServer.exe";
	Protocol = "TCP";
	LocalPort = 9396;
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Backup VSS Integration Service (Out)";
	Description = "Outbound rule for Veeam Backup VSS Integration Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Backup File System VSS Integration\VeeamFilesysVssSvc.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Broker Service (Out)";
	Description = "Outbound rule for Veeam Broker Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.BrokerService.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Catalog Service (Out)";
	Description = "Outbound rule for Veeam Catalog Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup Catalog\Veeam.Backup.CatalogDataService.exe";
	Protocol = "TCP";
	LocalPort = 9393;
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Cloud Connect Service (Out)";
	Description = "Outbound rule for Veeam Cloud Connect Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.CloudService.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Data Mover (Out)";
	Description = "Outbound rule for Veeam Data Mover included with Veeam Backup and Replication";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\WinAgent\VeeamAgent.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Data Mover (Veeam Catalog Service) (Out)";
	Description = "Outbound rule for Veeam Data Mover included with Veeam Catalog Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup Catalog\WinAgent\VeeamAgent.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Data Mover (Veeam Transport Service) (Out)";
	Description = "Outbound rule for Veeam Data Mover included with Veeam Transport Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files (x86)\Veeam\Backup Transport\x86\VeeamAgent.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Data Mover x64 (Veeam Transport Service) (Out)";
	Description = "Outbound rule for Veeam Data Mover x64 included with Veeam Transport Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files (x86)\Veeam\Backup Transport\x64\VeeamAgent.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Distribution Service (Out)";
	Description = "Outbound rule for Veeam Distribution Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Veeam Distribution Service\Veeam.Backup.Agent.ConfigurationService.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Guest Interaction Proxy (Out)";
	Description = "Outbound rule for Veeam Guest Interaction Proxy";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files (x86)\Veeam\Backup Transport\GuestInteraction\Veeam.Guest.Interaction.Proxy.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Installer Service (Veeam Backup and Replication) (Out)";
	Description = "Outbound rule for Veeam Installer Service included with Veeam Backup and Replication";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Windows\Veeam\Backup and Replication\VeeamDeploymentSvc.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Management Agent Configurator port (Out)";
	Description = "Outbound rule for Veeam Management Agent Configurator";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Availability Console\CommunicationAgent\Veeam.MBP.AgentConfigurator.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Management Agent port (Out)";
	Description = "Outbound rule for Veeam Management Agent";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Availability Console\CommunicationAgent\Veeam.MBP.Agent.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Mount Service (Out)";
	Description = "Outbound rule for Veeam Mount Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Common Files\Veeam\Backup and Replication\Mount Service\Veeam.Backup.MountService.exe";
	Protocol = "TCP";
	LocalPort = 6170;
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Traffic Redirector (Out)";
	Description = "Outbound rule for Veeam Traffic Redirector included with Veeam Backup & Replication";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Backup\VeeamNetworkRedirector.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Traffic Redirector (Veeam Backup & Replication console) (Out)";
	Description = "Outbound rule for Veeam Network Traffic included with Veeam Backup & Replication console";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files\Veeam\Backup and Replication\Console\VeeamNetworkRedirector.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam Transport Service (Out)";
	Description = "Outbound rule for Veeam Transport Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files (x86)\Veeam\Backup Transport\VeeamTransportSvc.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

$params = @{
	DisplayName = "Veeam vPower NFS Service (Out)";
	Description = "Outbound rule for Veeam vPower NFS Service";
	Enabled = 'True';
	Group = "Veeam Networking";
	Action = "Allow";
	Direction = "Outbound";
	Program = "C:\Program Files (x86)\Veeam\vPowerNFS\VeeamNFSSvc.exe";
	Protocol = "TCP";
	Profile = "Any";
}
$rules.Add($params) > $Null

## Add the firewall rules

<# This is just a simple loop that creates the rules again. #>

$rules | % {
	Write-Host $("{0} {1}" -f $($_.DisplayName), $($_.LocalPort))
	New-NetFirewallRule @_
}

## Failsafe

<# This failsafe section will disable the firewall after 30 seconds so you can get back in in the unlikely event
you missed adding a rule that your remote access tool(s) need. #>

$seconds = 30
Write-Host "Please confirm if you have access by pressing CTRL+Z to break out of this script. If you do not, so you can get back in, the firewall will disable in " -NoNewLine
do {
	Start-Sleep -Seconds 1
	Write-Host "$seconds " -NoNewLine
} while($seconds-- -gt 0)
Write-Host "..."

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
