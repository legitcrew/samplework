#Grabs core and thread count for each hosts
$result = @()
$vmhost = get-vmhost
    foreach ($esxi in $vmhost) {
        $HostCPU = $esxi.ExtensionData.Summary.Hardware.NumCpuPkgs
        $HostCPUcore = $esxi.ExtensionData.Summary.Hardware.NumCpuCores/$HostCPU
        $obj = new-object psobject
        $obj | Add-Member -MemberType NoteProperty -Name name -Value $esxi.Name
        $obj | Add-Member -MemberType NoteProperty -Name CPUSocket -Value $HostCPU
        $obj | Add-Member -MemberType NoteProperty -Name Corepersocket -Value $HostCPUcore
        $result += $obj
    }
    $result