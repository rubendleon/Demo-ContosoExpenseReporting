Param([string] $demoSettingsFile, [string] $userSettingsFile)

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
if($userSettingsFile -eq $nul -or $userSettingsFile -eq "")
{
	$userSettingsFile = "..\config.local.xml"
}

# Get settings from demo configuration file
if($demoSettingsFile -eq $nul -or $demoSettingsFile -eq "")
{
	$demoSettingsFile = "setup.xml"
}

[xml]$userSettingsFile = Get-Content $userSettingsFile
[xml]$xmlDemoSettings = Get-Content $demoSettingsFile

[string] $workingDir = $userSettingsFile.configuration.localPaths.workingDir

[string] $SQLServerName = $userSettingsFile.configuration.localSqlServer.serverName
[string] $dbName = $userSettingsFile.configuration.localSqlServer.dbName

[string] $receiptsAssetsDir = $xmlDemoSettings.configuration.copyAssets.receiptsDir
[string] $federationsAssetsDir = $xmlDemoSettings.configuration.copyAssets.federationsDir
[string] $hadoopAssetsDir = $xmlDemoSettings.configuration.copyAssets.hadoopDir

# ========= Removing current working directory... =========
& ".\tasks\remove-workingdir.ps1" -demoWorkingDir "$workingDir"

# ========= Cleaning up demo related folders... =========
& ".\tasks\cleanup-relatedfolders.ps1" -receiptsAssetsDir "$receiptsAssetsDir" -federationsAssetsDir "$federationsAssetsDir" -hadoopAssetsDir "$hadoopAssetsDir"

# ========= Resetting IIS Express... =========
& ".\tasks\reset-iis-express.ps1"

# ========= Dropping Local Database... =========
& ".\tasks\drop-localdatabase.ps1" -SQLServerName "$SQLServerName" -dbName "$dbName"