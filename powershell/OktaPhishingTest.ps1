<#
Authored by Alojz Cuk

This Script will input a list of users, then randomly send a Okta verify Push notification. Each time the script is run, a new user will be targeted.

The Okta powershell module can be found here: https://toolkit.okta.com/apps/okta-psmodule/
Ensure you run through the setup to configure the Okta API in the Okta_org.psm1 file (within the Okta PS Module), otherwise the below script will not be able to query the data needed.
Before running this script, ensure both the Okta powershell module and the ActiveDirectory powershell module are available to be imported.
#>

Import-Module Okta
$YourEmail = "slackchannelemail@domain.com"
$OktaOrg = "OktaOrg"
$OutputPath = "c:\Scripts\OktaVerifyResult.csv"
#$OktaGroup below is "main-employees" in Okta
$OktaGroup = "OktaGroupID"
$users = oktaGetGroupMembersbyId -oOrg $OktaOrg -gid $OktaGroup | Where-Object {$_.STATUS -eq "ACTIVE"} | Select-Object -ExpandProperty profile | Select-Object email


function Get-TimeStamp {
    
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    
}

function CheckPushStatus {
    
    Param($RandomUserPush)
    $PushCheck
    $PushDevice = oktaGetFactorsbyUser -oOrg $OktaOrg -username $RandomUserPush | Select-Object factorType
    if ($PushDevice.factorType -contains "PUSH"){
        $PushCheck = "YES"
        }
    else{
    $PushCheck = "NO"
    }

}


function OktaVerifyPhish {

    try{
        $randomUser = Get-Random -InputObject $users
        $CheckUser = Import-Csv $OutputPath
        $UserList = @{}
        $TargetUser
        Import-Csv $OutputPath | ForEach-Object { $UserList[$_.user] = $_ }
        #Check if selected user has already been targeted and if they had a SUCCESS or REJECTED result
        if($UserList[$randomUser.email].user -in $CheckUser.user -and $UserList[$randomUser.email].factorResult -ne "TIMEOUT" ){

        $randomUser = Get-Random -InputObject $users
        OktaVerifyPhish
        #"Pick another user"

        }
        else{

        $Push = CheckPushStatus -RandomUserPush $randomUser.email
        $Push
        if($Push = "YES"){
        #"Run Okta Verify"
        $TargetUser = $randomUser
        OktaVerify
        }
        else{
        OktaVerifyPhish
        }

        }
}
catch {
    $_ | Out-File C:\Scripts\OktaVerify_ErrorLog.txt -Append
    }
}

function OktaVerify {
$factors = oktaGetFactorsbyUser -oOrg $OktaOrg -username $TargetUser.email
$outputresult = ForEach($factor in $factors){ switch ($factor.factorType)
    {
    push { oktaVerifyPushbyUser -oOrg $OktaOrg -username $TargetUser.email -fid $factor.id}
    }}

    $outputlist =  [PSCustomObject]@{
    timestamp = Get-TimeStamp
    user = $TargetUser.email
    factorResult = $outputresult.factorResult
    profile = $outputresult.profile
    _links = $outputresult._links
    }
    $from = "OktaPhishingResult@domain.com"
    $smtpip = [System.Net.Dns]::GetHostAddresses("smtprelay.domain.com")
    $factorResult = $outputresult.factorResult
    $timestamp = Get-TimeStamp
    $SMTPUser = $outputlist.user

    if ($outputresult.factorResult -eq "SUCCESS"){
        
        Send-MailMessage -To $YourEmail -From $from -Subject ":alert::alert::alert:$SMTPUser ACCEPTED OKTA PHISHING TEST:alert::alert:cmd" -Body "$timestamp This email is to notify that $SMTPUser selected 'Yes, It's me' on the Okta Verify Phishing test. Result: $factorResult" -BodyAsHTML -SmtpServer $smtpip.IPAddressToString
        $outputlist | Export-csv $OutputPath -NoTypeInformation -Append
        }
        else {
        Send-MailMessage -To $YourEmail -From $from -Subject "User $SMTPUser was the target of the Okta Phishing test" -Body "$timestamp This email is to notify that $SMTPUser has been targeted in the Okta Phishing test. A Okta Verify prompt was sent to their device, the result of this test was $factorResult" -BodyAsHTML -SmtpServer $smtpip.IPAddressToString
        $outputlist | Export-csv $OutputPath -NoTypeInformation -Append
        }


}

OktaVerifyPhish
#Clear-Variable -Name "UserList"
Start-Sleep -Seconds 60
OktaVerifyPhish
#Clear-Variable -Name "UserList"
Start-Sleep -Seconds 60
OktaVerifyPhish
