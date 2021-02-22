#server to change driver one
$server = "SERVER"
#import printers from txt file to change drivers.
$printers = gc C:\PrinterAddScript\PrinterDriverChange.txt

#change driver name
foreach ($server in $servers) {
    foreach ($printer in $printers) {
Set-Printer -ComputerName $server -Name $printers -DriverName "HP Universal Printing PCL 6"
  }
}

#SMTP Setting
$strFromAddress = "Driver Changed <driverchange@DOMAIN_NAME>"
$strToAddress = "NAME1 <NAME1@DOMAIN_NAME>,NAME2 <NAME2@DOMAIN_NAME>"
$strMessageSubject = "Drivers changed successfully"
$strMessageBody = "Drivers changed successfully"
$strSendingServer = "smtp.rchsd.org"

# Email objects
$objSMTPMessage = New-Object System.Net.Mail.MailMessage $strFromAddress, $strToAddress, $strMessageSubject, $strMessageBody
$objSMTPClient = New-Object System.Net.Mail.SMTPClient $strSendingServer
$objSMTPClient.Send($objSMTPMessage)
