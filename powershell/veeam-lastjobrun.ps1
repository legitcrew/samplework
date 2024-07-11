#Authored by Alojz Cuk

#What this script Does

#This script checks for the last time that Veeam jobs that run. If a job hasn't run in the set time or no jobs running, it will send an email which feeds into opsgenie to either open or close a ticket
#This is useful as if a job hasn't run in a while, the job may be in a hung state in which it should be investigated
#OpsGenie is then used to automatically open and close tickets with an integration into Slack

#Log onto backup server
$Username = "administrator"
$SecurePassword = Get-Content "C:\securepassword.xml" | ConvertTo-SecureString

Connect-VBRServer -User $Username -Password $SecurePassword -Server 10.10.10.10 -Port 9392

#Get the job
$jobs = Get-VBRJob

$JobRun = @()

#loop to run against each job
foreach ($job in $jobs) {
    #Gets the last job run time
    $jobruntime = Get-VBRBackupSession | Where-Object { $_.jobId -eq $job.Id.Guid } | Sort-Object EndTimeUTC -Descending | Select-Object -First 1
    #If the job hasn't run in the hours alotted, write the name of the job and the time it last ran
    if ($jobruntime | Where-Object EndTime  -lt ((get-date).AddHours(-48))) {
        $JobRun += Write-Output "$($job.name) is over limit. Last run was $($jobruntime.EndTime)"
    }
}

#Email variables
    $MyEmail = "myemail@domain.com"
    $To = "youremail@domain.com" 
    $Subject1 = "Jobs are running properly - veeamjobs" 
    $Body1 = "Jobs are running properly - veeamjobs"
    $Subject2 = "Jobs haven't run for two days - veeamjobs"
    $Body2 = $JobRun | out-string
    $SMTPServer = "smtp.smtp.com"
    $SMTPPort = "25"
    

#functions that sends email - one for empty, one for overdue jobs
function nojob {
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { return $true }
    Send-MailMessage -from $MyEmail -to $To -subject "$Subject1" -body "$Body1" -SmtpServer "$SMTPServer" -Port $SMTPPort }
function job {
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { return $true }
    Send-MailMessage -from $MyEmail -to $To -subject "$Subject2" -body "$Body2" -SmtpServer "$SMTPServer" -Port $SMTPPort }
    

#If the array is empty, email saying jobs are up to date, Else, send email with names of jobs
if ($JobRun.Count -eq 0) {
    nojob
}
else {
  job
}
