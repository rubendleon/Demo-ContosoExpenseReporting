Param([string] $receiptsAssetsDir,
	[string] $federationsAssetsDir,
	[string] $hadoopAssetsDir)

$receiptsAssetsDir = Resolve-Path $receiptsAssetsDir
$federationsAssetsDir = Resolve-Path $federationsAssetsDir
$hadoopAssetsDir = Resolve-Path $hadoopAssetsDir

write-host "========= Cleaning up demo related folders... ========="
[string] $desktopFolder = [Environment]::GetFolderPath("Desktop")

[string] $packagesFolder = Join-Path $desktopFolder "Packages"
if (Test-Path "$packagesFolder")
{
	Remove-Item "$packagesFolder" -recurse -force
}
[string] $receiptsFolder = Join-Path $desktopFolder "Receipts"
if (Test-Path "$receiptsFolder")
{
	Remove-Item "$receiptsFolder" -recurse -force
}

[string] $federationsFolder = Join-Path $desktopFolder "Federations"
if (Test-Path "$federationsFolder")
{
	Remove-Item "$federationsFolder" -recurse -force
}

# Hadoop -  do not delete the folder
[string] $hadoopFolder = Join-Path $desktopFolder "Hadoop"
if (Test-Path "$hadoopFolder")
{
	Remove-Item "$hadoopFolder" -recurse -force
}
