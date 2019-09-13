$DST = Get-Date
try{
    Import-Module 'C:\Program Files\WindowsPowerShell\Modules\PSWindowsUpdate\2.0.0.0\PSWindowsUpdate.psd1'
    Get-WUInstall -IgnoreUserInput -AcceptAll -Install -Verbose
}
catch{
    "Couldn't update $env:computername on $DST" | Out-File '\\uslaldjbaldwin\C$\Users\jbaldwin\OneDrive - IGT PLC\Desktop\Updates_Failed.txt' -Append
}