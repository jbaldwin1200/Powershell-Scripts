$computers = Get-Content "C:\Users\jbaldwin\OneDrive - IGT PLC\Documents\Helpful Notes\Servers_on_81.txt"
$source = "C:\Users\jbaldwin\OneDrive - IGT PLC\Documents\Scripts\Monthly_Server_Updates.ps1"

$destination = "C$\Windows"

foreach ($computer in $computers) {
    Copy-Item $source -Destination \\$computer\$destination -Force -Verbose
}