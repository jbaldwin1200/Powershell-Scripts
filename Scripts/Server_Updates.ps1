#Questions to figure out
#Will it be too slow if it does one computer at a time, installing updates and then rebooting may take all night to complete a long list of servers
#In that case adjust script to update and reboot the computer it's running on and just scheduule each powershell script in the task scheduler of every server
#emailList sends you an email with log of servers updated and rebooted

Get-WUInstall -ComputerName USFLFPADMIN02 -IgnoreUserInput -Acceptall -Download -Install -Verbose

$emailList = @{
    To         = "you@yourdomain.org"
    From       = "updates@yourdomain.org"
    Subject    = "Server Update and Reboot Results for $(Get-Date)"
    SMTPServer = "exchange.yourdomain.local"
    BodyAsHtml = $true
}

$servers = Get-Content 'C:\'
$Results = ForEach ($Computer in $servers)
{
    Try {
        Install-Module -Name PSWindowsUpdate
        Get-WUInstall -IgnoreUserInput -AcceptAll -Install -Verbose
        #restart server once updates are finished installing - Check running tasks?
        Restart-Computer -ComputerName $computer -Force -ErrorAction Stop
        $Success = $true
    }
    Catch {
        $Success = $false
    }
    #Lists the name, date, and if the computer was reboted in the email
    [PSCustomObject]@{
        ComputerName         = $computer
        TimeStamp            = Get-Date
        SuccessfullyRebooted = $Success
    }
}

$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TR:Nth-Child(Even) {Background-Color: #dddddd;}
TR:Hover TD {Background-Color: #C1D5F8;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
"@

#Email Results
$Body = $Results | ConvertTo-Html -Head $Header | Out-String

Send-MailMessage @emailList -Body $Body