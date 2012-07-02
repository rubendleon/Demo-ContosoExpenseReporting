Param([string] $demoSettingsFile, [string] $userSettingsFile)

$scriptDir = (split-path $myinvocation.mycommand.path -parent)
Set-Location $scriptDir

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

if ((Get-PSSnapin -Registered | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Write-Host "Demo Toolkit Snapin not installed." -ForegroundColor Red
	Write-Host "Install it from https://github.com/microsoft-dpe/demo-tools" -ForegroundColor Red
	return;
} 
if ((Get-PSSnapin | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Add-PSSnapin DemoToolkitSnapin	
} 

# Get the key and account setting from configuration using namespace
[xml]$xmlUserSettings = Get-Content $userSettingsFile
[xml]$xmlDemoSettings = Get-Content $demoSettingsFile

[string] $workingDir = $xmlUserSettings.configuration.localPaths.workingDir
[string] $sourceCodeDir = Resolve-Path "..\Begin"
[string] $sqlServerName = $xmlUserSettings.configuration.localSqlserver.sqlServerName

[string] $receiptsAssetsDir = $xmlDemoSettings.configuration.copyAssets.receiptsDir
[string] $federationsAssetsDir = $xmlDemoSettings.configuration.copyAssets.federationsDir
[string] $hadoopAssetsDir = $xmlDemoSettings.configuration.copyAssets.hadoopDir

$receiptsAssetsDir = Resolve-Path $receiptsAssetsDir
$federationsAssetsDir = Resolve-Path $federationsAssetsDir
$hadoopAssetsDir = Resolve-Path $hadoopAssetsDir

[string] $bindingName = $xmlUserSettings.configuration.iis.bindingName
[string] $webSiteProjectFilePath = $xmlUserSettings.configuration.iis.webSiteProjectFilePath
[string] $appPoolName = $xmlUserSettings.configuration.iis.appPoolName
[string] $siteName = $xmlUserSettings.configuration.iis.siteName


# "========= Main Script =========" #
write-host "========= Create working directory... ========="
if (!(Test-Path "$workingDir"))
{
	New-Item "$workingDir" -type directory | Out-Null
}
write-host "Creating working directory done!"

write-host "========= Copying Begin solution to working directory...  ========="
Copy-Item "$sourceCodeDir\*" "$workingDir" -recurse -Force
write-host "Copying Begin solution to working directory done!"

write-host "========= Installing Code Snippets ... ========="
# pending
write-host "Installing Code Snippets done!"

write-host "========= Updating web.config file... ========="
[string] $fileName = Resolve-Path(Join-Path $sourceCodeDir "\Expenses.Web\web.config")
$fileContent = Get-Content $fileName
$fileContent = $fileContent.Replace("Server=.\SQLEXPRESS", "Server=" + $sqlServerName)
Set-Content $fileName $fileContent
write-host "Updating web.config file done!"

write-host "========= Setting up demo related folders... ========="
[string] $desktopFolder = [Environment]::GetFolderPath("Desktop")

[string] $packagesFolder = Join-Path $desktopFolder "Packages"
New-Item "$packagesFolder" -type directory
Add-WindowsExplorerFavorite "Packages" $packagesFolder

[string] $receiptsFolder = Join-Path $desktopFolder "Receipts"
New-Item "$receiptsFolder" -type directory
Copy-Item "$receiptsAssetsDir\*" "$receiptsFolder" -recurse -Force
Add-WindowsExplorerFavorite  "Receipts" $receiptsFolder

[string] $federationsFolder = Join-Path $desktopFolder "Federations"
New-Item "$federationsFolder" -type directory
Copy-Item "$federationsAssetsDir\*" "$federationsFolder" -recurse -Force
Add-WindowsExplorerFavorite  "Federations" $federationsFolder

[string] $hadoopFolder = Join-Path $desktopFolder "Hadoop"
New-Item "$hadoopFolder" -type directory
Copy-Item "$hadoopAssetsDir\*" "$hadoopFolder" -recurse -Force
Add-WindowsExplorerFavorite  "Hadoop" $hadoopFolder
write-host "========= Setting up demo related folders... done! ========="

write-host "========= Deploying the site to IIS ========="
$webSiteProjectFilePath = Resolve-Path $webSiteProjectFilePath 
.\tasks\SetupIIS.cmd $webSiteProjectFilePath $appPoolName $bindingName $siteName $SQLServerName
write-host "Deploying the site to IIS Done!"

write-host "========= Adding Host file entry ========="
.\tasks\addHosts.ps1 127.0.0.1 $bindingName $true
Add-IEProxyException "http://$bindingName"
write-host "Adding Host file entry Done!"

write-host "========= Warming up IIS Sites ========="
Ping-Url ([Xml](get-content .\tasks\WarmupUrls.xml))
write-host "Warming IIS Sites Done!"

write-host "========= Install Node Package ... ========="
$exe = "npm"
& $exe install azure --g
write-host "========= Installing Node Package done! ... ========="
