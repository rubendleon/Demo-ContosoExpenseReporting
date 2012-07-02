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