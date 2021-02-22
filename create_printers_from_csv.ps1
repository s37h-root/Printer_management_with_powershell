$htmlformat  = '<title>Table</title>'
$htmlformat += '<style type="text/css">'
$htmlformat += 'BODY{background-color:#FFFFFF;color:#000000;font-family:Arial Narrow,sans-serif;font-size:17px;}'
$htmlformat += 'TABLE{border-width: 8px;border-style: solid;border-color: black;border-collapse: collapse;}'
$htmlformat += 'TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:#0085C8}'
$htmlformat += 'TD{border-width: 1px;padding: 8px;border-style: solid;border-color: black;background-color:#BABABA}'
$htmlformat += '</style>'
$bodyformat = "<h3>Printer(s) Successfully Added</h3>" 

#Start Stopwatch
$StartTime = $(get-date)

#Change Servers Here and path to printers to add separate servers with comma
$servers = "SERVER1","SERVER2""
#CSV location and file name
$printers = Import-Csv C:\PrinterAddScript\PrinterList.csv

foreach ($server in $servers) {
    foreach ($printer in $printers) {
        Add-PrinterPort -ComputerName $server -Name $printer.IPAddress -PrinterHostAddress $printer.IPAddress
        Add-Printer -ComputerName $server -Name $printer.Printername -DriverName $printer.Driver -PortName $printer.IPAddress -Comment $printer.Comment -Location $printer.Location
        cscript c:\windows\system32\printing_admin_scripts\en-us\prncnfg.vbs -s $server -t -p $Printer.Printername -r $printer.IPAddress +rawonly -enablebidi +docompletefirst
     }
  }
 
#Stop Stopwatch
$elapsedTime = $(get-date) - $StartTime
$totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)

#Smtp Settings
$smtpServer = "SMTP_SERVER"
$smtpFrom = "Add Printers Status <PrintersAdded@domain>"
#recipients
$smtpTo = "Nick Warner<nwarner@rchsd.org>,Roger Lueneburg <rlueneburg@rchsd.org>"

#Message Info
$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.Subject = "Printer(s) Added Successfully"
$message.IsBodyHTML = $true
$message.Priority = [System.Net.Mail.MailPriority]::High
$Body1 = $printers | Select PrinterName,IPAddress,Driver | ConvertTo-Html -Head $htmlformat -Body $bodyformat
$Body2 =  "<H3>Total time to add was" + " " + "$totalTime</H3>"
$message.Body = "$Body1" + "$Body2"

#Send Message Settings 
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($message)
