Param([string] $vmSQLServerName, [string] $vmSQLUsername, [string] $vmSQLPassword, [string] $vmDbName)

write-host "========= Dropping Windows Azure VM Database... ========="
& "SqlCmd" @("-S", "$vmSQLServerName", "-U", "$vmSQLUsername", "-P", "$vmSQLPassword", "-Q", "ALTER DATABASE  $vmDbName SET SINGLE_USER WITH ROLLBACK IMMEDIATE;");
& "SqlCmd" @("-S", "$vmSQLServerName", "-U", "$vmSQLUsername", "-P", "$vmSQLPassword", "-Q", "DROP DATABASE  $vmDbName;");
write-host "Dropping Windows Azure VM Database Done!"
