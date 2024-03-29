[CmdletBinding(
		SupportsShouldProcess=$True,
		ConfirmImpact="High"
	)]
	param
	(
		[Parameter(ValueFromPipeline=$True,
					ValueFromPipelineByPropertyName=$True)]
		[String[]]$ComputerName = "localhost",
		[String]$PSWUModulePath = "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate",
		[String]$OnlinePSWUSource = "http://gallery.technet.microsoft.com/2d191bcd-3308-4edd-9de2-88dff796b0bc",
		[String]$SourceFileName = "PSWindowsUpdate.zip",
		[String]$LocalPSWUSource,
		[Switch]$CheckOnly,
		[Switch]$Debuger
	)

	Begin 
	{
		If($PSBoundParameters['Debuger'])
		{
			$DebugPreference = "Continue"
		} #End If $PSBoundParameters['Debuger']
		
		$User = [Security.Principal.WindowsIdentity]::GetCurrent()
		$Role = (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

		if(!$Role)
		{
			Write-Warning "To perform some operations you must run an elevated Windows PowerShell console."	
		} #End If !$Role
		
		if($LocalPSWUSource -eq "")
		{
			Write-Debug "Prepare temp location"
			$TEMPDentination = [environment]::GetEnvironmentVariable("Temp")
			#$SourceFileName = $OnlinePSWUSource.Substring($OnlinePSWUSource.LastIndexOf("/")+1)
			$ZipedSource = Join-Path -Path $TEMPDentination -ChildPath $SourceFileName
			$TEMPSource = Join-Path -Path $TEMPDentination -ChildPath "PSWindowsUpdate"
			
			Try
			{
				$WebClient = New-Object System.Net.WebClient
				$WebSite = $WebClient.DownloadString($OnlinePSWUSource)
				$WebSite -match "/file/41459/\d*/PSWindowsUpdate.zip" | Out-Null
				
				$OnlinePSWUSourceFile = $OnlinePSWUSource + $matches[0]
				Write-Debug "Download latest PSWindowsUpdate module from website: $OnlinePSWUSourceFile"	
				#Start-BitsTransfer -Source $OnlinePSWUSource -Destination $TEMPDentination
				
				$WebClient.DownloadFile($OnlinePSWUSourceFile,$ZipedSource)
			} #End Try
			catch
			{
				Write-Error "Can't download the latest PSWindowsUpdate module from website: $OnlinePSWUSourceFile" -ErrorAction Stop
			} #End Catch
			
			Try
			{
				if(Test-Path $TEMPSource)
				{
					Write-Debug "Cleanup old PSWindowsUpdate source"
					Remove-Item -Path $TEMPSource -Force -Recurse
				} #End If Test-Path $TEMPSource
				
				Write-Debug "Unzip the latest PSWindowsUpdate module"
				[Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
				[System.IO.Compression.ZipFile]::ExtractToDirectory($ZipedSource,$TEMPDentination)
				$LocalPSWUSource = Join-Path -Path $TEMPDentination -ChildPath "PSWindowsUpdate"
			} #End Try
			catch
			{
				Write-Error "Can't unzip the latest PSWindowsUpdate module" -ErrorAction Stop
			} #End Catch
			
			Write-Debug "Unblock the latest PSWindowsUpdate module"
			Get-ChildItem -Path $LocalPSWUSource | Unblock-File
		} #End If $LocalPSWUSource -eq ""

		$ManifestPath = Join-Path -Path $LocalPSWUSource -ChildPath "PSWindowsUpdate.psd1"
		$TheLatestVersion = (Test-ModuleManifest -Path $ManifestPath).Version
		Write-Verbose "The latest version of PSWindowsUpdate module is $TheLatestVersion"
	}
	
	Process
	{
		ForEach($Computer in $ComputerName)
		{
			if($Computer -eq [environment]::GetEnvironmentVariable("COMPUTERNAME") -or $Computer -eq ".")
			{
				$Computer = "localhost"
			} #End If $Computer -eq [environment]::GetEnvironmentVariable("COMPUTERNAME") -or $Computer -eq "."
			
			if($Computer -eq "localhost")
			{
				$ModuleTest = Get-Module -ListAvailable -Name PSWindowsUpdate
			} #End if $Computer -eq "localhost"
			else
			{
				if(Test-Connection $Computer -Quiet)
				{
					Write-Debug "Check if PSWindowsUpdate module exist on $Computer"
					Try
					{
						$ModuleTest = Invoke-Command -ComputerName $Computer -ScriptBlock {Get-Module -ListAvailable -Name PSWindowsUpdate} -ErrorAction Stop
					} #End Try
					Catch
					{
						Write-Warning "Can't access to machine $Computer. Try use: winrm qc"
						Continue
					} #End Catch
				} #End If Test-Connection $Computer -Quiet
				else
				{
					Write-Warning "Machine $Computer is not responding."
				} #End Else Test-Connection -ComputerName $Computer -Quiet
			} #End Else $Computer -eq "localhost"
			
			If ($pscmdlet.ShouldProcess($Computer,"Update PSWindowsUpdate module from $($ModuleTest.Version) to $TheLatestVersion")) 
			{
				if($Computer -eq "localhost")
				{
					if($ModuleTest.Version -lt $TheLatestVersion)
					{
						if($CheckOnly)
						{
							Write-Verbose "Current version of PSWindowsUpdate module is $($ModuleTest.Version)"
						} #End If $CheckOnly
						else
						{
							Write-Verbose "Copy source files to PSWindowsUpdate module path"
							Get-ChildItem -Path $LocalPSWUSource | Copy-Item -Destination $ModuleTest.ModuleBase -Force
							
							$AfterUpdateVersion = [String]((Get-Module -ListAvailable -Name PSWindowsUpdate).Version)
							Write-Verbose "$($Computer): Update completed: $AfterUpdateVersion" 
						}#End Else $CheckOnly
					} #End If $ModuleTest.Version -lt $TheLatestVersion
					else
					{
						Write-Verbose "The newest version of PSWindowsUpdate module exist"
					} #ed Else $ModuleTest.Version -lt $TheLatestVersion
				} #End If $Computer -eq "localhost"
				else
				{
					Write-Debug "Connection to $Computer"
					if($ModuleTest -eq $null)
					{
						$PSWUModulePath = $PSWUModulePath -replace ":","$"
						$DestinationPath = "\\$Computer\$PSWUModulePath"

						if($CheckOnly)
						{
							Write-Verbose "PSWindowsUpdate module on machine $Computer doesn't exist"
						} #End If $CheckOnly
						else
						{
							Write-Verbose "PSWindowsUpdate module on machine $Computer doesn't exist. Installing: $DestinationPath"
							Try
							{
								New-Item -ItemType Directory -Path $DestinationPath -Force | Out-Null
								Get-ChildItem -Path $LocalPSWUSource | Copy-Item -Destination $DestinationPath -Force
								
								$AfterUpdateVersion = [string](Invoke-Command -ComputerName $Computer -ScriptBlock {(Get-Module -ListAvailable -Name PSWindowsUpdate).Version} -ErrorAction Stop)
								Write-Verbose "$($Computer): Update completed: $AfterUpdateVersion" 								
							} #End Try	
							Catch
							{
								Write-Warning "Can't install PSWindowsUpdate module on machine $Computer."
							} #End Catch
						} #End Else $CheckOnly
					} #End If $ModuleTest -eq $null
					elseif($ModuleTest.Version -lt $TheLatestVersion)
					{
						$PSWUModulePath = $ModuleTest.ModuleBase -replace ":","$"
						$DestinationPath = "\\$Computer\$PSWUModulePath"
						
						if($CheckOnly)
						{
							Write-Verbose "Current version of PSWindowsUpdate module on machine $Computer is $($ModuleTest.Version)"
						} #End If $CheckOnly
						else
						{
							Write-Verbose "PSWindowsUpdate module version on machine $Computer is ($($ModuleTest.Version)) and it's older then downloaded ($TheLatestVersion). Updating..."							
							Try
							{
								Get-ChildItem -Path $LocalPSWUSource | Copy-Item -Destination $DestinationPath -Force	
								
								$AfterUpdateVersion = [string](Invoke-Command -ComputerName $Computer -ScriptBlock {(Get-Module -ListAvailable -Name PSWindowsUpdate).Version} -ErrorAction Stop)
								Write-Verbose "$($Computer): Update completed: $AfterUpdateVersion" 
							} #End Try
							Catch
							{
								Write-Warning "Can't updated PSWindowsUpdate module on machine $Computer"
							} #End Catch
						} #End Else $CheckOnly
					} #End ElseIf $ModuleTest.Version -lt $TheLatestVersion
					else
					{
						Write-Verbose "Current version of PSWindowsUpdate module on machine $Computer is $($ModuleTest.Version)"
					} #End Else $ModuleTest.Version -lt $TheLatestVersion
				} #End Else $Computer -eq "localhost"
			} #End If $pscmdlet.ShouldProcess($Computer,"Update PSWindowsUpdate module")
		} #End ForEach $Computer in $ComputerName
	}
	
	End 
	{
		if($LocalPSWUSource -eq "")
		{
			Write-Debug "Cleanup PSWindowsUpdate source"
			if(Test-Path $ZipedSource -ErrorAction SilentlyContinue)
			{
				Remove-Item -Path $ZipedSource -Force
			} #End If Test-Path $ZipedSource
			if(Test-Path $TEMPSource -ErrorAction SilentlyContinue)
			{
				Remove-Item -Path $TEMPSource -Force -Recurse
			} #End If Test-Path $TEMPSource	
		}
	}

}