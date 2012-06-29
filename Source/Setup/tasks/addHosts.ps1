# Adds a new host entry on the hosts file as shown:
#
# add-host 127.0.0.1 www.southworks.net [optional $true|$false]
#
# the third parameter indicates whether if exists it should be overwritten

param (
    [string]$address, [string]$hostname, [string]$override
)

function Add-Host {
 # map parameters
 $override = ($override -eq $true)
 
 # generte some basics
 $ipAddressRegex = "(\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b)"
 $hostsPath = $env:windir + "\System32\drivers\etc\hosts"
 $hosts, $entry = (gc $hostsPath), "$address $hostname"

 if([regex]::match($hosts, "\s*$ipAddressRegex\s*$hostname\s*").success){
  # it already existed but chose not override
  if(-not $override) { return; }
  clear-content $hostsPath
  $hosts | where-object{[regex]::match($_, "\s*$ipAddressRegex\s*$hostname\s*.*$").success -eq $false} | add-content $hostsPath
 }
 
 # now append it
 add-content $hostsPath $entry
}

Add-Host

