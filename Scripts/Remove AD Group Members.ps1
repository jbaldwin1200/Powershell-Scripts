Import-Module ActiveDirectory 

ForEach ($item in (Import-CSV C:\Users\jbaldwin\Desktop\Users.csv)) {
  $email = $item.'Email Address' #whatever your field name
  Get-ADUser -Filter "mail -eq '$email'" | 
  % { Remove-ADGroupMember -Identity "GPCGMD" -Members $_ -confirm:$false}
}