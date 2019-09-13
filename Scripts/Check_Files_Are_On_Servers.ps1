$servers = Get-content "C:\Users\jbaldwin\OneDrive - IGT PLC\Documents\Scripts\servers_to_schedule_task.txt"

foreach ($name in $servers){
    if (!Test-Path "\\$server\c$\Windows\Monthly_Server_Updates.ps1") {
        Add-Content c:\Windows\notExists.txt "$server"
        }
}