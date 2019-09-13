Get-ADComputer -Server "gtk.gtech.com" -SearchBase "CN=Computers,DC=GTK,DC=GTECH,DC=COM" -Filter 'Name -like "USLAL*"' -Property * |
Select-Object Name,OperatingSystem,OperatingSystemVersion,ipv4Address | 
Export-CSV -Path "C:\Users\jbaldwin\OneDrive - IGT PLC\Desktop\ADcomputerslist2.csv" -NoTypeInformation -Encoding UTF8