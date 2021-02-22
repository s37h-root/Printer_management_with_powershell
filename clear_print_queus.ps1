#User name that has access to print servers to clear queues from.
$username = "USER@DOMAIN_NAME"

#password for user that has access to print servers. You can create a variable or another way to prompt for credentials. 
$pwd = "PASSWORD"

$secpwd = $pwd | ConvertTo-SecureString -AsPlainText -Force 
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secpwd

#Server names for print servers to clear. Multiple servers can be listed separted by a comma. 
$servers = "SERVER1" , "SERVER2"
ForEach ($server in $servers){$queue = Get-WMIObject win32_printer -credential $creds -computername $server | where {$_.PrinterState -eq "2"}
If ($queue){$queue | % {$_.CancelAllJobs() | Out-Null}}}
