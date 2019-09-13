$servers = Get-content "C:\Users\jbaldwin\OneDrive - IGT PLC\Desktop\servers.txt"

foreach ($name in $servers){
  if (Test-Connection -ComputerName $name -Count 1 -ErrorAction SilentlyContinue){
    Add-Content c:\temp\autoreboottest\Up.txt "$name"
    
    Send-MailMessage -To "Joshua.Baldwin@igt.com; Oliver.Tejada@igt.com" -From "Joshua.Baldwin@IGT.com"   -Attachments "up.txt" -Subject "Auto Reboot on $name Successful" -Body "See Attachments " -SmtpServer "mail.myigt.com"; 

  }
  else{
    Add-Content c:\temp\autoreboottst\down.txt "$name"
    
    Send-MailMessage -To "a@b.com" -From "GPCITADMIN@igt.com"   -Attachments "down.txt" -Subject "Auto Reboot on $name Failed" -Body "See Attachments " -SmtpServer "uswegpaddsi01.MYIGT.com"; 

  }
}

clear-Content c:\temp\autoreboottst\up.txt
clear-Content c:\temp\autoreboottst\down.txt