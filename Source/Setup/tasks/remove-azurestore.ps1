Param([string] $wazStorageAccountName)

write-host "========= Removing Windows Azure Storage Account ... ========="
if (-Not ((Get-AzureStorageAccount | Where { $_.StorageAccountName -eq $wazStorageAccountName }) -eq $nul))
{
	Remove-AzureStorageAccount $wazStorageAccountName
}
write-host "Removing Windows Azure Storage Account done!"

