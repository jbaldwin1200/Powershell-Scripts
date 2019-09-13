$names = Get-content "C:\Users\jbaldwin\OneDrive - IGT PLC\Documents\Helpful Notes\Servers_on_AD_without_IPAddress.txt"
foreach ($name in $names){
  if (Test-Connection -ComputerName $name -Count 1 -ErrorAction SilentlyContinue){
    Write-Host "$name,up"
  }
  else{
    Write-Host "$name,down"
  }
}