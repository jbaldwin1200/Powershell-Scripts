Invoke-Command -ComputerName 172.29.81.121 -Credential $Credes -Scriptblock {
    $action = New-ScheduledTaskAction -Execute 'C:\Windows\Monthly_Server_Updates'
    $trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 2 -DaysOfWeek Sunday -At 3am
    $user = New-ScheduledTaskPrincipal -GroupID "BUILTIN\Administrators" -RunLevel Highest
    Register-ScheduledTask -Action $action -Trigger $trigger $user -TaskName "windowsUpdates" -User "SYSTEM" -Description "Perform windows updates every 2 weeks" -Verbose
}