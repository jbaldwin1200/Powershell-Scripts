$computers = Get-Content "C:\Users\jbaldwin\OneDrive - IGT PLC\Desktop\servers.txt"
$source = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate\2.0.0.0\"

$destination = "C$\Program Files\WindowsPowerShell\Modules\PSWindowsUpdate"

foreach ($computer in $computers) {
	if(!(Test-Path -Path \\$computer\$destination)) {
		New-Item -ItemType directory -Path \\$computer\$destination -Force -Verbose -Recurse
	} 
    if (!(Test-Path -Path \\$computer\$destination\$source)) {
        Copy-Item $source -Destination \\$computer\$destination -Force -Verbose -Recurse
    } else {
		"\\$computer\$destination is not reachable or does not exist"
	}
}