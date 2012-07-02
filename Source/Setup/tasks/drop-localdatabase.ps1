Param([string] $SQLServerName, [string] $dbName)

write-host "========= Dropping Local Database... ========="
& "SqlCmd" @("-S", "$SQLServerName", "-E", "-Q", "ALTER DATABASE  $dbName SET SINGLE_USER WITH ROLLBACK IMMEDIATE;");
& "SqlCmd" @("-S", "$SQLServerName", "-E", "-Q", "DROP DATABASE  $dbName;");
write-host "Dropping local database Done!"
