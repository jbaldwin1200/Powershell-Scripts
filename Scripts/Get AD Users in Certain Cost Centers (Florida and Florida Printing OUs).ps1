## PACKAGING
Get-ADUser -SearchBase "OU=Florida Printing, OU=Enabled Users, OU=User Accounts, DC=MYIGT, DC=com" -Properties LastLogonDate -Filter 'Department -like "*5950*"' |
Select-Object @{expression={$_.GivenName}; label='First Name'}, @{expression={$_.Surname}; label='Last Name'}, @{expression={$_.SamAccountName}; label='Domain Name'}, `
@{expression={$_.LastLogonDate}; label='Last Logon Date'} `
| Export-CSV "$home\Desktop\AD Users for Shannyn (5950, 5951, 5955, 5956).csv" -NoTypeInformation

## PRESS
Get-ADUser -SearchBase "OU=Florida Printing, OU=Enabled Users, OU=User Accounts, DC=MYIGT, DC=com" -Properties LastLogonDate -Filter 'Department -like "*5951*"' |
Select-Object @{expression={$_.GivenName}; label='First Name'}, @{expression={$_.Surname}; label='Last Name'}, @{expression={$_.SamAccountName}; label='Domain Name'}, `
@{expression={$_.LastLogonDate}; label='Last Logon Date'} `
| Export-CSV "$home\Desktop\AD Users for Shannyn (5950, 5951, 5955, 5956).csv" -NoTypeInformation -Append

## EOG
Get-ADUser -SearchBase "OU=Florida Printing, OU=Enabled Users, OU=User Accounts, DC=MYIGT, DC=com" -Properties LastLogonDate -Filter 'Department -like "*5955*"' |
Select-Object @{expression={$_.GivenName}; label='First Name'}, @{expression={$_.Surname}; label='Last Name'}, @{expression={$_.SamAccountName}; label='Domain Name'}, `
@{expression={$_.LastLogonDate}; label='Last Logon Date'} `
| Export-CSV "$home\Desktop\AD Users for Shannyn (5950, 5951, 5955, 5956).csv" -NoTypeInformation -Append

## EOG WHILE DKING AND MMARTINEZ ARE STUCK IN FLORIDA
Get-ADUser -SearchBase "OU=Florida, OU=Enabled Users, OU=User Accounts, DC=MYIGT, DC=com" -Properties LastLogonDate -Filter 'Department -like "*5955*"' |
Select-Object @{expression={$_.GivenName}; label='First Name'}, @{expression={$_.Surname}; label='Last Name'}, @{expression={$_.SamAccountName}; label='Domain Name'}, `
@{expression={$_.LastLogonDate}; label='Last Logon Date'} `
| Export-CSV "$home\Desktop\AD Users for Shannyn (5950, 5951, 5955, 5956).csv" -NoTypeInformation -Append

## MAINTENANCE
Get-ADUser -SearchBase "OU=Florida Printing, OU=Enabled Users, OU=User Accounts, DC=MYIGT, DC=com" -Properties LastLogonDate -Filter 'Department -like "*5956*"' |
Select-Object @{expression={$_.GivenName}; label='First Name'}, @{expression={$_.Surname}; label='Last Name'}, @{expression={$_.SamAccountName}; label='Domain Name'}, `
@{expression={$_.LastLogonDate}; label='Last Logon Date'} `
| Export-CSV "$home\Desktop\AD Users for Shannyn (5950, 5951, 5955, 5956).csv" -NoTypeInformation -Append