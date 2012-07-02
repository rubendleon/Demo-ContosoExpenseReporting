Param([string] $localSettingsFile, [string] $azureSettingsFile)

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
if(-not $localSettingsFile)
{
	$localSettingsFile = "configuration.xml"
}
[xml] $xmlLocalSettings = Get-Content $localSettingsFile

[string] $vmSQLServerName = $xml.configuration.vmSqlServer.serverName
[string] $vmSQLUsername = $xml.configuration.vmSqlServer.username
[string] $vmSQLPassword = $xml.configuration.vmSqlServer.password
[string] $vmDbName = $xml.configuration.vmSqlServer.dbName
[bool] $enableWebSitesDelete = [System.Convert]::ToBoolean($xml.configuration.features.enableWebSitesDelete)
[string] $azureNodeSDKDir = $xml.configuration.azureNodeSDKDir
[string] $webSitesToDelete = $xml.configuration.windowsAzureSubscription.webSitesToDelete
[string] $wazStorageAccountName = $xml.configuration.windowsAzureSubscription.storageAccountName

$azureNodeSDKDir = Resolve-Path $azureNodeSDKDir

# ========= Dropping Azure Database... =========
& ".\tasks\drop-azuredatabase.ps1" -vmSQLServerName "$vmSQLServerName" -vmSQLUsername "$vmSQLUsername" -vmSQLPassword "$vmSQLPassword" -vmDbName "$vmDbName"

# ========= Remove Azure Storage Account... =========
& ".\tasks\remove-azurestore.ps1" -wazStorageAccountName "$wazStorageAccountName"

# ========= Deleting Web sites... =========
if ($enableWebSitesDelete) {
& ".\tasks\waz-delete-websites.ps1" -azureNodeSDKDir "$azureNodeSDKDir" -webSitesToDelete "$webSitesToDelete"
}
