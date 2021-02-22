#specify print server to export from
$printserver = "SERVER"
#change file name and export location of csv location. Also specify which info you want exported.
Get-Printer -computer $printserver | Select PortName,Name,ShareName,Shared,Published | Export-CSV -path 'C:\PS03_Printers.csv'
