Param([string] $configFile)

$scriptDir = (split-path $myinvocation.mycommand.path -parent)
Set-Location $scriptDir

# "========= Initialization =========" #
if($configFile -eq $nul -or $configFile -eq "")
{
	$configFile = "config.azure.xml"
}

# Get the key and account setting from configuration using namespace
[xml]$xml = Get-Content $configFile
[string] $wazPublishSettings = $xml.configuration.windowsAzureSubscription.publishSettingsFile
[string] $webSitesToDelete = $xml.configuration.windowsAzureSubscription.webSitesToDelete
[string] $publishProfileDownloadUrl = $xml.configuration.urls.publishProfileDownloadUrl
[string] $azureServiceNameToDelete = $xml.configuration.windowsAzureSubscription.azureServiceNameToDelete

[string] $SQLAzureServerName = $xmlUserSettings.configuration.azureSqlServer.serverName
[string] $SQLAzureUsername = $xmlUserSettings.configuration.azureSqlServer.username
[string] $SQLAzurePassword = $xmlUserSettings.configuration.azureSqlServer.password
[string] $azureDbName = $xmlUserSettings.configuration.azureSqlServer.dbName


# "========= Main Script =========" #
if (-not ($wazPublishSettings) -or -not (test-path $wazPublishSettings)) {
    Write-Error "You must specify the publish setting profile. After downloading the publish settings profile from the management portal, specify the file location in the configuration file path under the publishSettingsFile element."
	Write-Host "You should save the publish setting profile into a known and safe location to avoid being removed. Then configure the publishSettingFile in the Config.Azure.xml file."
	
    start $publishProfileDownloadUrl
    return
}
   
#========= Importing the Windows Azure Subscription Settings File... =========
& ".\tasks\import-waz-publishsettings.ps1" -wazPublishSettings $wazPublishSettings

#========= Deleting Configured Windows Azure Web Sites... =========
& ".\tasks\waz-delete-websites.ps1" -webSitesToDelete $webSitesToDelete

#========= Deleting Configured SQL Azure Database... =========
& ".\tasks\waz-delete-azure-sqldb.ps1" -SQLAzureServerName $SQLAzureServerName -SQLAzureUsername $SQLAzureUsername -SQLAzurePassword $SQLAzurePassword -azureDbName $azureDbName

#========= Deleting Configured Cloud Service... =========
& ".\tasks\waz-delete-cloud-service.ps1" -wazPublishSettings $wazPublishSettings -azureServiceName $azureServiceNameToDelete

