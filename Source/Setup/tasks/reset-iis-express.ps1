write-host "========= Closing and Cleaning up IIS Express Resources... ========="
Close-Process "iisexpress"
[string] $documentsFolder = [Environment]::GetFolderPath("MyDocuments")
if (-NOT (test-path "$documentsFolder"))
{
    $documentsFolder = "$env:UserProfile\Documents";
}
[string] $iisExpressFolder = Join-Path "$documentsFolder" "IISExpress"
if (Test-Path "$iisExpressFolder")
{
	Remove-Item "$iisExpressFolder" -recurse -force
}
write-host "Closing and Cleaning up IIS Express Resources done!"