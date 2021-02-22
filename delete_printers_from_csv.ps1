$htmlformat  = '<title>Table</title>'
$htmlformat += '<style type="text/css">'
$htmlformat += 'BODY{background-color:#FFFFFF;color:#000000;font-family:Arial Narrow,sans-serif;font-size:17px;}'
$htmlformat += 'TABLE{border-width: 8px;border-style: solid;border-color: black;border-collapse: collapse;}'
$htmlformat += 'TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:#0085C8}'
$htmlformat += 'TD{border-width: 1px;padding: 8px;border-style: solid;border-color: black;background-color:#BABABA}'
$htmlformat += '</style>'
$bodyformat = "<h3>Printer(s) Successfully Deleted</h3>" 

#Start Stopwatch
$StartTime = $(get-date)

#Change Servers Here and path to printers to delete. You can add multiple servers separated by a comma. 
$servers = "SERVER1","SERVER2"
#Location and file name for printers to delete.
$printers = Import-Csv C:\PrinterAddScript\PrinterList.csv

foreach ($server in $servers) {
    foreach ($printer in $printers) {
       cscript c:\windows\system32\printing_admin_scripts\en-us\Prnmngr.vbs -d -s $server -p $Printer.Printername
       cscript c:\windows\system32\printing_admin_scripts\en-us\Prnport.vbs -d -s $server -r $Printer.IPAddress
     }
  }
 
#Stop Stopwatch
$elapsedTime = $(get-date) - $StartTime
$totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)

#Smtp Settings
$smtpServer = "SMTP_SERVER"
$smtpFrom = "Delete Printers Status <PrintersRemoved@DOMAIN_NAME>"
$smtpTo = "NAME1 <NAME1@DOMAIN_NAME>,NAME2 <NAME2@DOMAIN_NAME>"

#Message Info
$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.Subject = "Printer(s) Successfully Deleted"
$message.IsBodyHTML = $true
$message.Priority = [System.Net.Mail.MailPriority]::High
$Body1 = $printers | Select PrinterName,IPAddress | ConvertTo-Html -Head $htmlformat -Body $bodyformat
$Body2 =  "<H3>Total time to add was" + " " + "$totalTime</H3>"
$message.Body = "$Body1" + "$Body2"

#Send Message Settings 
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($message)
