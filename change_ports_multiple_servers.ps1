$htmlformat  = '<title>Table</title>'
$htmlformat += '<style type="text/css">'
$htmlformat += 'BODY{background-color:#FFFFFF;color:#000000;font-family:Arial Narrow,sans-serif;font-size:17px;}'
$htmlformat += 'TABLE{border-width: 8px;border-style: solid;border-color: black;border-collapse: collapse;}'
$htmlformat += 'TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:#0085C8}'
$htmlformat += 'TD{border-width: 1px;padding: 8px;border-style: solid;border-color: black;background-color:#BABABA}'
$htmlformat += '</style>'
$bodyformat = "<h3>Port(s) Successfully Changed</h3>" 

#Start Stopwatch
$StartTime = $(get-date)

#Change Servers Here and path to printers to change. You can add multiple servers separated by a comma.
$servers = "SERVER1","SERVER2"
#Location and file name of printers to change. 
$printers = Import-Csv C:\PrinterAddScript\PrinterPorts.csv

foreach ($server in $servers) {
    foreach ($printer in $printers) {
        Add-PrinterPort -ComputerName $server -Name $printer.NewPortName -PrinterHostAddress $printer.NewPortName
        cscript c:\windows\system32\printing_admin_scripts\en-us\prncnfg.vbs -s $server -t -p $Printer.Printername -r $printer.NewPortName
     }
  }
 
 
#Stop Stopwatch
$elapsedTime = $(get-date) - $StartTime
$totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)


#Smtp Settings
$smtpServer = "SMTP Server"
$smtpFrom = "Port Change Status <Portschanged@domain_name>"
#recipients upon completion of script running.
$smtpTo = "RECIPIENT1 <name@domain_name>,RECIPIENT2 <name2@domain_name>"

#Message Info
$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.Subject = "Port(s) Successfully Changed"
$message.IsBodyHTML = $true
$message.Priority = [System.Net.Mail.MailPriority]::High
$Body1 = $printers | Select PrinterName,NewPortName | ConvertTo-Html -Head $htmlformat -Body $bodyformat
$Body2 =  "<H3>Total time to add was" + " " + "$totalTime</H3>"
$message.Body = "$Body1" + "$Body2"

#Send Message Settings 
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($message)
