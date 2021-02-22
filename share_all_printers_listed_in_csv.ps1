#change print server name. Also change csv file location of printers to share. 
foreach ($server in @("PRINT_SERVER")) {
    foreach ($printer in @(Import-Csv C:\CSV_For_Not_Shared_Printers.csv)) {
        Set-Printer -ComputerName $server -Name $printer.name -Shared $True -ShareName $printer.ShareName -Published $True
    }
}
#This will export the results to a csv file.
Get-Printer -ComputerName PS03 | Export-Csv "C:\Results.csv"
