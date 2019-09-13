$list = Get-content "C:\Users\jbaldwin\OneDrive - IGT PLC\Documents\Helpful Notes\Servers_on_81.txt"
$Credes = Get-Credential

foreach ($server in $list){
    try{
    Invoke-Command -ComputerName $server -Credential $Credes -Scriptblock {

        $action = New-ScheduledTaskAction -Execute 'C:\Windows\Monthly_Server_Updates'
        $trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 2 -DaysOfWeek Sunday -At 3am
        $user = New-ScheduledTaskPrincipal -GroupID "BUILTIN\Administrators" -RunLevel Highest
        Register-ScheduledTask -Action $action -Trigger $trigger $user -TaskName "windowsUpdates" -User "SYSTEM" -Description "Perform windows updates every 2 weeks" -Verbose
    }
}catch{
    "Couldn't schedule task on $server" | Out-File '\\uslaldjbaldwin\C$\Users\jbaldwin\OneDrive - IGT PLC\Desktop\unavailable_server.txt' -Append
}
}
