Param([string] $demoWorkingDir)

write-host "========= Removing current working directory... ========="
if (Test-Path "$demoWorkingDir")
{
	Remove-Item "$demoWorkingDir" -recurse -force
}

write-host "Removing current working directory done!"