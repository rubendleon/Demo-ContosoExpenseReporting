Param([string] $configFile)

$scriptDir = (split-path $myinvocation.mycommand.path -parent)
Set-Location $scriptDir

if ((Get-PSSnapin -Registered | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Write-Host "Demo Toolkit Snapin not installed." -ForegroundColor Red
	Write-Host "Install it from https://github.com/microsoft-dpe/demo-tools" -ForegroundColor Red
	return;
} 
if ((Get-PSSnapin | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Add-PSSnapin DemoToolkitSnapin	
} 

# "========= Initialization =========" #
pushd ".."

if($configFile -eq $nul -or $configFile -eq "")
{
	$configFile = "configuration.xml"
}
[xml] $xml = get-Content $configFile
[string] $beginSolutionDir = $xml.configuration.beginSolutionDir
[string] $demoWorkingDir = $xml.configuration.demoWorkingDir
[string] $demoSolutionFile = $xml.configuration.demoSolutionFile
[string] $azureNodeSDKDir = $xml.configuration.azureNodeSDKDir
[string] $nuGetLocalDir = $xml.configuration.nuGetLocalDir

[string] $receiptsAssetsDir = $xml.configuration.copyAssets.receiptsDir
[string] $federationsAssetsDir = $xml.configuration.copyAssets.federationsDir
[string] $hadoopAssetsDir = $xml.configuration.copyAssets.hadoopDir

[string] $CSharpSnippets = $xml.configuration.codeSnippets.cSharp
[string] $htmlSnippets = $xml.configuration.codeSnippets.html
[string] $xmlSnippets = $xml.configuration.codeSnippets.xml

[string] $SQLServerName = $xml.configuration.localSqlServer.serverName
[string] $dbName = $xml.configuration.localSqlServer.dbName

[string] $vmSQLServerName = $xml.configuration.vmSqlServer.serverName
[string] $vmSQLUsername = $xml.configuration.vmSqlServer.username
[string] $vmSQLPassword = $xml.configuration.vmSqlServer.password
[string] $vmDbName = $xml.configuration.vmSqlServer.dbName

[string] $bindingName = $xml.configuration.iis.bindingName
[string] $webSiteProjectFilePath = $xml.configuration.iis.webSiteProjectFilePath
[string] $appPoolName = $xml.configuration.iis.appPoolName
[string] $siteName = $xml.configuration.iis.siteName

[string] $wazPublishSettings = $xml.configuration.windowsAzureSubscription.publishSettingsFile
[string] $wazStorageAccountName = $xml.configuration.windowsAzureSubscription.storageAccountName
[string] $webSitesToKeep = $xml.configuration.windowsAzureSubscription.webSitesToKeep
[string] $sqlManagementEndpoint = $xml.configuration.windowsAzureSubscription.sqlManagementEndpoint

[string] $manualResetFile = $xml.configuration.manualResetFile

[string] $windowsAzureMgmtPortal = $xml.configuration.urls.windowsAzureMgmtPortal

[bool] $enableWebSitesDelete = [System.Convert]::ToBoolean($xml.configuration.features.enableWebSitesDelete)

[string]$cd = Get-Location
$beginSolutionDir = Resolve-Path $beginSolutionDir
$demoWorkingDir = Join-Path $cd $demoWorkingDir
$azureNodeSDKDir = Resolve-Path $azureNodeSDKDir
$nuGetLocalDir = Resolve-Path $nuGetLocalDir
$demoSolutionFile = Join-Path $cd $demoSolutionFile
$CSharpSnippets = Resolve-Path $CSharpSnippets
$htmlSnippets = Resolve-Path $htmlSnippets
$xmlSnippets = Resolve-Path $xmlSnippets
$webSiteProjectFilePath = Resolve-Path $webSiteProjectFilePath
$wazPublishSettings = Resolve-Path $wazPublishSettings
$receiptsAssetsDir = Resolve-Path $receiptsAssetsDir
$federationsAssetsDir = Resolve-Path $federationsAssetsDir
$hadoopAssetsDir = Resolve-Path $hadoopAssetsDir
$manualResetFile = Resolve-Path $manualResetFile

popd

# "========= Main Script =========" #

write-host "========= Closing Visual Studio... ========="
Close-VS -Force
Start-Sleep -s 2
write-host "Closing Visual Studio Done!"

write-host "========= Closing SQL Manager Studio... ========="
Close-SQLManager -Force
Start-Sleep -s 2
write-host "Closing SQL Manager Studio Done!"

write-host "========= Closing IE... ========="
Close-IE -Force
Start-Sleep -s 2
write-host "Closing IE Done!"

write-host "========= Clearing IE History... ========="
Clear-IECookies
write-host "Clearing IE History Done!"

write-host "========= Removing current working directory... ========="
if (Test-Path "$demoWorkingDir")
{
	Remove-Item "$demoWorkingDir" -recurse -force
}
New-Item "$demoWorkingDir" -type directory
write-host "Removing current working directory done!"

write-host "========= Updating web.config file... ========="
[string] $fileName = Resolve-Path(Join-Path $beginSolutionDir "\Expenses.Web\web.config")
$fileContent = Get-Content $fileName
$fileContent = $fileContent.Replace("Server=.\SQLEXPRESS", "Server=" + $SQLServerName)
Set-Content $fileName $fileContent
write-host "Updating web.config file done!"

write-host "========= Copying Begin solution to working directory... ========="
Copy-Item "$beginSolutionDir\*" "$demoWorkingDir" -recurse -Force
write-host "Copying Begin solution to working directory done!"

write-host "========= Cleaning up demo related folders... ========="
[string] $desktopFolder = [Environment]::GetFolderPath("Desktop")

[string] $packagesFolder = Join-Path $desktopFolder "Packages"
if (Test-Path "$packagesFolder")
{
	Remove-Item "$packagesFolder" -recurse -force
}
New-Item "$packagesFolder" -type directory
Add-WindowsExplorerFavorite "Packages" $packagesFolder

[string] $receiptsFolder = Join-Path $desktopFolder "Receipts"
if (Test-Path "$receiptsFolder")
{
	Remove-Item "$receiptsFolder" -recurse -force
}
New-Item "$receiptsFolder" -type directory
Copy-Item "$receiptsAssetsDir\*" "$receiptsFolder" -recurse -Force
Add-WindowsExplorerFavorite  "Receipts" $receiptsFolder

[string] $federationsFolder = Join-Path $desktopFolder "Federations"
if (Test-Path "$federationsFolder")
{
	Remove-Item "$federationsFolder" -recurse -force
}
New-Item "$federationsFolder" -type directory
Copy-Item "$federationsAssetsDir\*" "$federationsFolder" -recurse -Force
Add-WindowsExplorerFavorite  "Federations" $federationsFolder

# Hadoop -  do not delete the folder
[string] $hadoopFolder = Join-Path $desktopFolder "Hadoop"
if (-Not (Test-Path "$hadoopFolder"))
{
	New-Item "$hadoopFolder" -type directory
}
Copy-Item "$hadoopAssetsDir\*" "$hadoopFolder" -recurse -Force
Add-WindowsExplorerFavorite  "Hadoop" $hadoopFolder
write-host "Cleaning up demo related folders... done!"

write-host "========= Removing publishsettings from Desktop...   ========="
[string] $desktopFolder = [Environment]::GetFolderPath("Desktop")
$removeSettings = "$desktopFolder\*.publishsettings"
Remove-Item $removeSettings -Force
write-host "Removing publishsettings Done!"

write-host "========= Dropping Local Database... ========="
& "SqlCmd" @("-S", "$SQLServerName", "-E", "-Q", "ALTER DATABASE  $dbName SET SINGLE_USER WITH ROLLBACK IMMEDIATE;");
& "SqlCmd" @("-S", "$SQLServerName", "-E", "-Q", "DROP DATABASE  $dbName;");
write-host "Dropping local database Done!"

write-host "========= Dropping Windows Azure VM Database... ========="
& "SqlCmd" @("-S", "$vmSQLServerName", "-U", "$vmSQLUsername", "-P", "$vmSQLPassword", "-Q", "ALTER DATABASE  $vmDbName SET SINGLE_USER WITH ROLLBACK IMMEDIATE;");
& "SqlCmd" @("-S", "$vmSQLServerName", "-U", "$vmSQLUsername", "-P", "$vmSQLPassword", "-Q", "DROP DATABASE  $vmDbName;");
write-host "Dropping Windows Azure VM Database Done!"

write-host "========= Deploying the site to IIS ========="
.\SetupIIS.cmd $webSiteProjectFilePath $appPoolName $bindingName $siteName $SQLServerName
write-host "Deploying the site to IIS Done!"

write-host "========= Adding Host file entry ========="
.\addHosts.ps1 127.0.0.1 $bindingName $true
Add-IEProxyException "http://$bindingName"
write-host "Adding Host file entry Done!"

write-host "========= Warming up IIS Sites ========="
Ping-Url ([Xml](get-content WarmupUrls.xml))
write-host "Warming IIS Sites Done!"

write-host "========= Installing Code Snippets ... ========="
[string] $documentsFolder = [Environment]::GetFolderPath("MyDocuments")
if (-NOT (test-path "$documentsFolder"))
{
    $documentsFolder = "$env:UserProfile\Documents";
}
[string] $myCSharpSnippetsLocation = "$documentsFolder\Visual Studio 2012\Code Snippets\Visual C#\My Code Snippets"
[string] $myHtmlSnippetsLocation = "$documentsFolder\Visual Studio 2012\Code Snippets\Visual Web Developer\My HTML Snippets"
[string] $myXmlSnippetsLocation = "$documentsFolder\Visual Studio 2012\Code Snippets\XML\My Xml Snippets"

Copy-Item "$CSharpSnippets\*.snippet" "$myCSharpSnippetsLocation" -force
Copy-Item "$htmlSnippets\*.snippet" "$myHtmlSnippetsLocation" -force
Copy-Item "$xmlSnippets\*.snippet" "$myXmlSnippetsLocation" -force
write-host "Installing Code Snippets done!"

# Windows Azure Reset Stuff...
if ($wazPublishSettings -ne "" -and $wazPublishSettings -ne $nul) {
write-host "========= Importing the Windows Azure Subscription Settings File... ========="
$azureCmd = (Join-Path $azureNodeSDKDir "node.exe") + " " + (Join-Path $azureNodeSDKDir "bin\azure")
$accountImport = "$azureCmd " + 'account import "' + $wazPublishSettings + '"'
Invoke-Expression $accountImport
write-host "Importing the Windows Azure Subscription Settings File done!"

if ($enableWebSitesDelete) {
write-host "========= Deleting all Web Sites... ========="
[array] $keepList = $webSitesToKeep.Split(",") | % { $_.Trim() }
[regex]::matches((Invoke-Expression "$azureCmd site list"), "data:\s+(\S+)\s+([^-\s]+)") | Where { $keepList -notcontains $_.Groups[1].value -and $_.Groups[2].value -ne "State" } | foreach-object { Invoke-Expression ("$azureCmd site delete -q " + $_.Groups[1].value) }
write-host "Deleting all Web Sites done!"
}
}

write-host "========= Importing the Windows Azure Management Module... ========="
Import-Module Microsoft.WindowsAzure.ManagementTools.PowerShell.ServiceManagement
Import-Module Microsoft.WindowsAzure.ManagementTools.PowerShell.SqlDB
write-host "Importing the Windows Azure Management Module done!"

write-host "========= Importing the Windows Azure Subscription Settings File... ========="
Import-AzureSubscription $wazPublishSettings
Get-AzureSubscription | Set-AzureSubscription -SqlAzureServiceEndpoint "$sqlManagementEndpoint"
write-host "Importing the Windows Azure Subscription Settings File done!"

write-host "========= Removing Windows Azure Storage Account ... ========="
if (-Not ((Get-AzureStorageAccount | Where { $_.StorageAccountName -eq $wazStorageAccountName }) -eq $nul))
{
	Remove-AzureStorageAccount $wazStorageAccountName
}
write-host "Removing Windows Azure Storage Account done!"

write-host "========= Removing All SQL Azure Servers ... ========="
Get-AzureSqlDBServer | Remove-AzureSqlDBServer
write-host "Removing Windows Azure VMs done!"

write-host "========= Adding local NuGet source... ========="
Add-NugetSource "WindowsAzure.Storage" $nuGetLocalDir -Force
write-host "Adding local NuGet source Done!"

# write-host "========= Removing Windows Azure VMs ... ========="
# Get-AzureVM | Where { -Not($_.ServiceName -eq "mysqlvm1") } | Remove-AzureVM
# write-host "Removing Windows Azure VMs done!"

# Setting demo initial state...
write-host "========= Starting SQL Manager Studio ========="
Open-SQLManager -Server $SQLServerName -UseIntegratedAuthentication
Start-Sleep -s 2
write-host "Starting SQL Manager Done!"

write-host "========= Starting Visual Studio ========="
[string] $solution = Resolve-Path $demoSolutionFile
Start-VS -SolutionFile $solution
Start-Sleep -s 2
write-host "Starting Visual Studio Done!"

write-host "========= Launching IE ========="
Start-IE "http://contosoexpense; $windowsAzureMgmtPortal"
write-host "Launching IE Done!"

write-host "========= Opening Manual Reset steps file... ========="
[string] $desktopFolder = [Environment]::GetFolderPath("Desktop")
$manualResetFile = Resolve-Path $manualResetFile
& "notepad" @("$manualResetFile")
write-host "Opening Manual Reset steps file Done!"

