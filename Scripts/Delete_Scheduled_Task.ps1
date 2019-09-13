$servers = get-content "C:\Users\jbaldwin\OneDrive - IGT PLC\Documents\Helpful Notes\Servers_on_81.txt"

foreach ($server in $servers){
  try{
    Invoke-Command -ComputerName $server -Credential $Credes -Scriptblock {
    Unregister-ScheduledTask -TaskName "windowsUpdates" -Confirm:$false
  }
}catch{
  "Couldn't unschedule task on $server" | Out-File '\\uslaldjbaldwin\C$\Users\jbaldwin\OneDrive - IGT PLC\Desktop\unavailable_server.txt' -Append
}
}