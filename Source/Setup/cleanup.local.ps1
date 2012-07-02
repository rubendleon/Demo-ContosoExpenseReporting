Param([string] $userSettingsFile)

$scriptDir = (split-path $myinvocation.mycommand.path -parent)
Set-Location $scriptDir

if ((Get-PSSnapin -Registered | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Write-Host "Demo Toolkit Snapin not installed." -ForegroundColor Red
	Write-Host "Install it from https://github.com/microsoft-dpe/demo-tools/tree/master/demo-toolkit/bin" -ForegroundColor Red
	return;
} 
if ((Get-PSSnapin | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Add-PSSnapin DemoToolkitSnapin	
} 

# "========= Initialization =========" #

# Get settings from user configuration file
if($userSettingsFile -eq $nul -or $userSettingsFile -eq "")
{
	$userSettingsFile = "..\configuration.xml"
}

[xml]$xml = Get-Content $userSettingsFile

[string] $workingDir = $xml.configuration.localPaths.workingDir

[string] $SQLServerName = $xml.configuration.localSqlServer.serverName
[string] $dbName = $xml.configuration.localSqlServer.dbName
[bool] $enableWebSitesDelete = [System.Convert]::ToBoolean($xml.configuration.features.enableWebSitesDelete)
[string] $azureNodeSDKDir = $xml.configuration.azureNodeSDKDir
[string] $webSitesToKeep = $xml.configuration.windowsAzureSubscription.webSitesToKeep

$azureNodeSDKDir = Resolve-Path $azureNodeSDKDir

# ========= Removing current working directory... =========
& ".\tasks\remove-workingdir.ps1" -demoWorkingDir "$workingDir"

# ========= Cleaning up demo related folders... =========
& ".\tasks\cleanup-relatedfolders.ps1"

# ========= Resetting IIS Express... =========
& ".\tasks\reset-iis-express.ps1"

# ========= Dropping Local Database... =========
& ".\tasks\drop-localdatabase.ps1" -SQLServerName "$SQLServerName" -dbName "$dbName"

# ========= Deleting Web sites... =========
if ($enableWebSitesDelete) {
& ".\tasks\delete-websites.ps1" -azureNodeSDKDir "$azureNodeSDKDir" -webSitesToKeep "$webSitesToKeep"
}