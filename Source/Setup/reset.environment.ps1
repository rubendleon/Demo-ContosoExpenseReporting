Param([string] $demoSettingsFile, [string] $userSettingsFile)

$scriptDir = (split-path $myinvocation.mycommand.path -parent)
Set-Location $scriptDir

if ((Get-PSSnapin -Registered | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Write-Host "Demo Toolkit Snapin not installed." -ForegroundColor Red
	Write-Host "Install it from https://github.com/microsoft-dpe/demo-tools/downloads" -ForegroundColor Red
	return;
} 
if ((Get-PSSnapin | ?{$_.Name -eq "DemoToolkitSnapin"}) -eq $null) {
	Add-PSSnapin DemoToolkitSnapin	
} 

# "========= Initialization =========" #

# Get settings from user configuration file
if($userSettingsFile -eq $nul -or $userSettingsFile -eq "")
{
	$userSettingsFile = "..\Config.Local.xml"
}

[xml]$xmlUserSettings = Get-Content $userSettingsFile

[string] $workingDir = $xmlUserSettings.configuration.localPaths.workingDir
[string] $sqlServerName = $xmlUserSettings.configuration.localSqlserver.sqlServerName

# Get settings from internal configuration file
if($demoSettingsFile -eq $null -or $demoSettingsFile -eq "")
{
	$demoSettingsFile = "setup.xml"
}

[xml]$xmlDemoSettings = Get-Content $demoSettingsFile

[string] $vsSettingsFile = $xmlDemoSettings.configuration.localPaths.vsSettingsFile

[string] $closeIE = $xmlDemoSettings.configuration.resetEnvironment.closeIE
[string] $closeOpenVSInstances = $xmlDemoSettings.configuration.resetEnvironment.closeOpenVSInstances
[string] $clearIEFormData = $xmlDemoSettings.configuration.resetEnvironment.clearIEFormData
[string] $clearIEHistory = $xmlDemoSettings.configuration.resetEnvironment.clearIEHistory
[string] $clearIECookies = $xmlDemoSettings.configuration.resetEnvironment.clearIECookies
[string] $setIEAutoCompleteSettings = $xmlDemoSettings.configuration.resetEnvironment.setIEAutoCompleteSettings
[string] $clearVSProjectMRUList = $xmlDemoSettings.configuration.resetEnvironment.clearVSProjectMRUList
[string] $clearVSFileMRUList = $xmlDemoSettings.configuration.resetEnvironment.clearVSFileMRUList
[string] $cleanupDownloadsFolder = $xmlDemoSettings.configuration.resetEnvironment.cleanupDownloadsFolder
[string] $removeAzureVSSettings = $xmlDemoSettings.configuration.resetEnvironment.removeAzureVSSettings
[string] $removeDesktopPublishSettings = $xmlDemoSettings.configuration.resetEnvironment.removeDesktopPublishSettings
[string] $resetAzureComputeEmulator = $xmlDemoSettings.configuration.resetEnvironment.resetAzureComputeEmulator
[string] $setVSNewProjectDialogDefaults = $xmlDemoSettings.configuration.resetEnvironment.setVSNewProjectDialogDefaults
[string] $setVSOpenProjectDialogDefaults = $xmlDemoSettings.configuration.resetEnvironment.setVSOpenProjectDialogDefaults
[string] $setNuGetRestoreOnBuild = $xmlDemoSettings.configuration.resetEnvironment.setNuGetRestoreOnBuild
[string] $emptyRecycleBin = $xmlDemoSettings.configuration.resetEnvironment.emptyRecycleBin
[string] $startVS = $xmlDemoSettings.configuration.resetEnvironment.startVS
[string] $startIE = $xmlDemoSettings.configuration.resetEnvironment.startIE
[string] $startSQL =  $xmlDemoSettings.configuration.resetEnvironment.startSQL
[string] $ieOpenTabUrls = $xmlDemoSettings.configuration.resetEnvironment.ieOpenTabUrls
[string] $startVSWithSolutions = $xmlDemoSettings.configuration.resetEnvironment.startVSWithSolutions
$solutions = $xmlDemoSettings.configuration.localPaths.solutions

[string] $fxVersion = $xmlDemoSettings.configuration.resetEnvironment.vsNewProjectDialogDefaults.fxVersion
[string] $templateName = $xmlDemoSettings.configuration.resetEnvironment.vsNewProjectDialogDefaults.templateName
[string] $templateNode = $xmlDemoSettings.configuration.resetEnvironment.vsNewProjectDialogDefaults.templateNode

[Boolean] $autoCompleteForms = [System.Convert]::ToBoolean($xmlDemoSettings.configuration.resetEnvironment.ieAutoCompleteSettings.autoCompleteForms)
[Boolean] $autoCompleteUsernamesAndPasswords = [System.Convert]::ToBoolean($xmlDemoSettings.configuration.resetEnvironment.ieAutoCompleteSettings.autoCompleteUsernamesAndPasswords)
[Boolean] $askBeforeSavingPasswords = [System.Convert]::ToBoolean($xmlDemoSettings.configuration.resetEnvironment.ieAutoCompleteSettings.askBeforeSavingPasswords)


# "========= Main Script =========" #

if($closeOpenVSInstances.ToLower() -eq "true")
{
    write-host "========= Closing Visual Studio... ========="
    Close-VS -Force
    Start-Sleep -s 2
    write-host "Closing Visual Studio Done!"
}

if($closeIE.ToLower() -eq "true")
{
    write-host "========= Closing IE... ========="
    Close-IE -Force
    Start-Sleep -s 2
    write-host "Closing IE Done!"
}

if($clearIEHistory.ToLower() -eq "true")
{
    write-host "========= Clearing IE History ========="
    Clear-IEHistory
    write-host "Clearing IE History Done!"
}

if($clearIECookies.ToLower() -eq "true")
{
    write-host "========= Clearing IE Cookies ========="
    Clear-IECookies
    write-host "Clearing IE Cookies Done!"
}

if($clearIEFormData.ToLower() -eq "true")
{
    write-host "========= Clearing IE Form Data ========="
    Clear-IEFormData -ClearStoredPasswords
    write-host "Clearing IE Form Data Done!"
}

if($setIEAutoCompleteSettings.ToLower() -eq "true")
{
    write-host "========= Set IE AutoComplete Settings ========="
    Set-SetIEAutoCompleteSettings -AutoCompleteForms  $autoCompleteForms -AutoCompleteUsernamesAndPasswords $autoCompleteUsernamesAndPasswords -AskBeforeSavingPasswords $askBeforeSavingPasswords
    write-host "Set IE AutoComplete Settings Done!"
}

if($vsSettingsFile.ToLower() -eq "true")
{
    #========= Importing VS settings... =========
    if($vsSettingsFile -ne $nul -and $vsSettingsFile -ne "") {
	    $vsSettingsFile = Resolve-Path $vsSettingsFile
	    & ".\tasks\import-vssettings.ps1" -vsSettingsFile $vsSettingsFile
    }
}

if($clearVSProjectMRUList.ToLower() -eq "true")
{
    write-host "========= Removing VS most recently used projects... ========="
    Clear-VSProjectMRUList
    write-host "Removing VS most recently used projects done!"
}

if($clearVSFileMRUList.ToLower() -eq "true")
{
    write-host "========= Removing VS most recently used files... ========="
    Clear-VSFileMRUList
    write-host "Removing VS most recently used files done!"
}

if($cleanupDownloadsFolder.ToLower() -eq "true")
{
    #========= Cleaning up Downloads Folder... =========
    & ".\tasks\cleanup-downloads-folder.ps1"
}

if($removeAzureVSSettings.ToLower() -eq "true")
{
    #======== Removing local Windows Azure subscription settings from VS... ========
    & ".\tasks\remove-azure-vssettings.ps1"
}

if($removeDesktopPublishSettings.ToLower() -eq "true")
{
    #========= Removing publishsettings from Desktop (if any)...   =========
    & ".\tasks\remove-desktop-publishsettings.ps1"
}

if($resetAzureComputeEmulator.ToLower() -eq "true")
{
    #========= Resetting Azure Compute Emulator & Dev Storage...  =========
    & ".\tasks\reset-azure-compute-emulator.ps1"
}

if($setVSNewProjectDialogDefaults.ToLower() -eq "true")
{
    write-host "========= Setting VS New Project Dialog Defaults... ========="
    Set-VSNewProjectDialogDefaults -FxVersion "$fxVersion" -TemplateName "$templateName" -TemplateNode "$templateNode" -Path "$workingDir"
    write-host "Setting VS New Project Dialog Defaults done!"
}

if($setVSOpenProjectDialogDefaults.ToLower() -eq "true")
{
    write-host "========= Setting VS Open Project Dialog Defaults... ========="
    Set-VSOpenProjectDialogDefaults -Location "$workingDir" -All
    write-host "Setting VS Open Project Dialog Defaults done!"
}

if($setNuGetRestoreOnBuild.ToLower() -eq "true")
{
    write-host "========= Enabling NuGet Restore on Build... ========="
    Set-NuGetRestoreOnBuild -Enable
    write-host "Enabling NuGet Restore on Build done!"
}

if($emptyRecycleBin.ToLower() -eq "true")
{
	# ========= Removing elements in the recycle bin ... =========
	& ".\tasks\empty-recyclebin.ps1"
}

if($startVS.ToLower() -eq "true")
{
    write-host "========= Starting Visual Studio... ========="
    Start-VS 
    Start-Sleep -s 2
    write-host "Starting Visual Studio Done!"
}

if($startSQL.ToLower() -eq "true")
{
	write-host "========= Starting SQL Manager Studio ========="
	Open-SQLManager -Server $SQLServerName -UseIntegratedAuthentication
	Start-Sleep -s 2
	write-host "Starting SQL Manager Done!"
}

if($startIE.ToLower() -eq "true")
{
	write-host "========= Launching IE ========="
	Start-IE $ieOpenTabUrls
	write-host "Launching IE Done!"
}
