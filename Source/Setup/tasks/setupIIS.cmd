@ECHO OFF
setlocal
cd /D %~dp0

SET WebSiteProjectFilePath=%1
SET WebSiteProdPath=C:\inetpub\%2
SET IISAppPool=%2
SET IISBinding=%3
SET IISSiteName=%4
SET SqlServer=%5


ECHO.
ECHO Building Web Sites...
"%WINDIR%\Microsoft.NET\Framework\v4.0.30319\MsBuild" /t:ResolveReferences;_WPPCopyWebApplication /p:BuildingProject=true;WebProjectOutputDir=%WebSiteProdPath% %WebSiteProjectFilePath%

IF %ERRORLEVEL% GTR 0 GOTO end

ECHO.
ECHO Removing Web Sites and Application Pools...
ECHO.
"%systemroot%\system32\inetsrv\appcmd.exe" delete site %IISSiteName% 
"%systemroot%\system32\inetsrv\appcmd.exe" delete apppool /apppool.name:%IISAppPool%

ECHO.
ECHO Creating Application Pools...
ECHO.
"%systemroot%\system32\inetsrv\appcmd.exe" set config -section:system.applicationHost/applicationPools /+"[name='%IISAppPool%',managedRuntimeVersion='v4.0']" /commit:apphost
"%systemroot%\system32\inetsrv\appcmd.exe" set config -section:applicationPools /[name='%IISAppPool%'].processModel.loadUserProfile:false

ECHO.
ECHO Creating production Web Sites...
ECHO.
"%systemroot%\system32\inetsrv\appcmd.exe" add site /name:%IISSiteName% /physicalPath:%WebSiteProdPath% /bindings:http/*:80:%IISBinding%

ECHO.
ECHO Setting application pools for production applications...
ECHO.
"%systemroot%\system32\inetsrv\appcmd.exe" set app %IISSiteName%/ /applicationPool:%IISAppPool%

ECHO.
ECHO Restarting IIS...
ECHO.
IISRESET

ECHO.
ECHO Adding permissions to the application pool users in SQL Express...
ECHO.
SqlCmd -S %SqlServer% -d master -Q "CREATE LOGIN [IIS APPPOOL\%IISAppPool%] FROM WINDOWS"
SqlCmd -S %SqlServer% -d master -Q "EXEC sp_addsrvrolemember 'IIS APPPOOL\%IISAppPool%', 'sysadmin'"

ECHO.
ECHO IIS setup process is completed!
ECHO.
ECHO.

:end