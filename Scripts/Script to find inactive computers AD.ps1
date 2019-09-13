$DaysInactive = 10
$time = (Get-Date).Adddays(-($DaysInactive))
Get-ADComputer -SearchBase "OU=Florida Printing, OU=Desktops, OU=Devices, DC=MYIGT, DC=com" -Filter {lastlogontimestamp -lt $time} `
-Properties Name,OperatingSystem , lastlogontimestamp | Select-Object Name,OperatingSystem ,@{N='lastlogontimestamp'; `
E={[DateTime]::FromFileTime($_.lastlogontimestamp)}}
