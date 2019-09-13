#NEEDS CONFIGURED IN TASK SCHEDULER

$DaysInactive = 10
$time = (Get-Date).Adddays(-($DaysInactive))
$output = Get-ADComputer -SearchBase "OU=Florida Printing, OU=Desktops, OU=Devices, DC=MYIGT, DC=com" -Filter {lastlogontimestamp -lt $time} `
-Properties * | Select-Object Name


foreach ($name in $output){
  if ((Test-Connection -ComputerName $name -Count 1 -ErrorAction SilentlyContinue) -eq $false){
    Add-Content c:\temp\activeDirectory\deletions.txt "$name"
  }
  elseif ($name -eq $false) {
    Send-MailMessage -To "Oliver.Tejada@igt.com" -From "Joshua.Baldwin@igt.com" -Attachments "c:\temp\activeDirectory\deletions.txt" -Subject "Auto Reboot on $name Successful" -Body "See Attachments " -DNO -SmtpServer "mail.myigt.com"; 
  }  

}




  
clear-Content c:\temp\activeDirectory\deletions.txt