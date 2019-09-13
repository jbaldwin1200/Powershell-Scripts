$ADsession = New-PSSession -Computername USFLFPEADMIN02 -Credential jbaldwin
        Import-PSSession -Session $ADsession -Module PSWindowsUpdate
        Invoke-Command -Session $ADsession {Get-WUInstall -IgnoreUserInput -AcceptAll -Install -Verbose}
        