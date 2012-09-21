Param([string] $wazVMHostName,
      [string] $wazPublishSettings)


write-host "========= Deleting Windows Azure VM ... ========="

# Ensure that we are loading the Azure module from the correct folder
Import-Module "${env:ProgramFiles(x86)}\Microsoft SDKs\Windows Azure\PowerShell\Azure\Azure.psd1"

# Importing the Windows Azure Subscription Settings File
$wazPublishSettings = Resolve-Path $wazPublishSettings
Import-AzurePublishSettingsFile $wazPublishSettings

Get-AzureVM | Where { $_.ServiceName -eq $wazVMHostName } | Remove-AzureVM

write-host "Deleting Windows Azure VMs done!"
