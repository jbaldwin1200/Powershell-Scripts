$temp = Get-Content "C:\Users\jbaldwin\OneDrive - IGT PLC\Desktop\AD_Groups.txt"

foreach($group in $temp) 
{ 
write-output "GroupName:$group " 
Write-output "GroupMembers:" 
Get-ADGroupMember $group |ft displayname,alias,primarysmtpaddress 
write-output ‘ ‘ 
}



foreach ($group in $temp) 
{ 
Get-ADGroup $group | ft @{expression={$_.displayname};Label=”$group”} | Out-File "C:\Users\jbaldwin\OneDrive - IGT PLC\Desktop\AD_Members.txt" -append