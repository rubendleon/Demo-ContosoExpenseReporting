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
if($configFile -eq $nul -or $configFile -eq "")
{
	$configFile = "config.local.xml"
}

[xml]$xml = Get-Content $userSettingsFile

[string] $workingDir = $xml.configuration.localPaths.workingDir

[string] $SQLServerName = $xml.configuration.localSqlServer.serverName
[string] $dbName = $xml.configuration.localSqlServer.dbName

[string] $receiptsAssetsDir = $xml.configuration.copyAssets.receiptsDir
[string] $federationsAssetsDir = $xml.configuration.copyAssets.federationsDir
[string] $hadoopAssetsDir = $xml.configuration.copyAssets.hadoopDir


# ========= Removing current working directory... =========
& ".\tasks\remove-workingdir.ps1" -demoWorkingDir "$workingDir"

# ========= Cleaning up demo related folders... =========
& ".\tasks\cleanup-relatedfolders.ps1" -receiptsAssetsDir "$receiptsAssetsDir" -federationsAssetsDir "$federationsAssetsDir" -hadoopAssetsDir "$hadoopAssetsDir"

# ========= Resetting IIS Express... =========
& ".\tasks\reset-iis-express.ps1"

# ========= Dropping Local Database... =========
& ".\tasks\drop-localdatabase.ps1" -SQLServerName "$SQLServerName" -dbName "$dbName"
