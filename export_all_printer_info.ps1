#change server name and export location/file name.
Get-Printer -ComputerName SERVER_NAME | Export-Csv "C:\PrinterExport.csv"
