<a name="title" />
# Contoso Expense Reporting Demo #

---

<a name="Overview" />
## Overview ##

This demo illustrates an end-to-end scenario highlighting the Windows Azure cloud-ready data services, including Windows Azure SQL Database, Windows Azure Storage, and SQL Server 2012 in a Windows Azure Virtual Machine. This demo will showcase the rich and powerful features of the Windows Azure data services including easy provisioning of the services, fluid migration options, and the high-performing, scalable and feature-rich data options.

<a id="goals" />
### Goals ###
In this demo, you will see the following things:

1. Contoso Expense Reporting application running on-premise.

1. Deploy the application to a Windows Azure Web Site.

1. Connect the application to a Windows Azure SQL Database.

1. Connect the application to use Windows Azure Storage.

1. Create SQL Database Federations.

<a name="setup" />
### Setup and Configuration ###

This demo requires an already provisioned and configured VM with SQL Server. Once provisioned, the following steps are required to allow connection from on-premises SSMS.

1.	Create endpoint on VM
1.	Create a new SQL user with appropriate privileges to import and export dacpac’s.
1.	In the VM, open a port in the Windows Firewall for TCP access

---

<a name="Demo" />
## Demo ##

Throughout the course of this session, we will show the power and flexibility of Windows Azure by taking an on-premises application and associated database, and migrate them to Windows Azure. We will first use our IaaS services to migrate the database to a Virtual machine with SQL Server 2012 and the application to a Windows  Azure Cloud Service. We will then highlight our PaaS services by migrating the database to SQL Azure and extending the functionality of the application to use our Windows Azure storage services.

This demo is composed of the following segments:

1. [Contoso Expense Reporting Application Overview](#segment1).
1. [Migrating to Windows Azure with Virtual Machines & SQL Server 2012](#segment2).
1. [Windows Azure SQL Database](#segment3). 
1. [Windows Azure SQL Federation](#segment4). 
1. [Windows Azure Storage](#segment5). 

<a name="segment1" />
### Contoso Expense Reporting on-premise ###

1. Open the Web Browser and navigate to the application at <http://ExpenseApp>.

	![Expense Reportin App running Locally](Images/expense-reportin-app-running-locally.png?raw=true "Expense Reportin App running Locally")

	_Expense Reportin App running Locally_

	>**Speaking Point**
	>
	> We’re first going to log in as a user and submit a simple expense report.
	>
	> As part of this we’re going to highlight some of the challenges the company has today with the system, including the challenge of attaching receipts and verifying expenses.

1. Click **Login as user**.

	![Log in as User](Images/log-in-as-user.png?raw=true "Log in as User")

	_Log in as User_

	>**Speaking Point**
	>
	> We’re first going to log in as a user to illustrate some of the pain points we have with this application in submitting expense reports and highlight some of the areas where this application can be expanded and improved.


1. Select **My Reports** in the toolbar and then click **Add New Report**.

	![Application Dashboard](Images/application-dashboard.png?raw=true "Application Dashboard")

	_Application Dashboard_

	>**Speaking Point**
	>
	> In my Dashboard view, I can see expenses I have submitted and are awaiting approval from my manager, as well as those that have been approved and rejected.

1.	Enter the following information:
	- Name
	- Purpose

1. Next, click **Add New Expense** and fill in the following fields:
	- Category
	- Description
	- Merchant
	- Billed Amount
	- Transaction Amount

	![Expense Reporting - New Report](Images/expense-reporting-new-report.png?raw=true "Expense Reporting - New Report")

	_Expense Reporting - New Report_

	>**Speaking Point**
	>
	> Highlight the fact that because of limitations on-premises, receipts are still submitted manually and are not physically associated or attached with the Expense report.

1. Click **Save Draft**.

	![Expense Reporting - Save Draft](Images/expense-reporting-save-draft.png?raw=true "Expense Reporting - Save Draft")

	_Expense Reporting - Save Draft_

	>**Speaking Point**
	>
	> We are going to save this expense report as a draft because we will come back to it several times during this demo.

1. Show **Visual Studio**. 
1. Open the **Solution Explorer** window.

	![Application's Solution Explorer](Images/applications-solution-explorer.png?raw=true "Application's Solution Explorer")

	_Application's Solution Explorer_

	>**Speaking Point**
	>
	> Standard MVC web application. Common to most of you. Most have running in enterprise.

<a name="segment2" />
### Migrating to Windows Azure with Virtual Machines & SQL Server 2012 ###

1. Open the Web browser and navigate to the Windows Azure Portal at <http://windows.azure.com>

1. Sign in with your Live ID.


	![Sign in](Images/sign-in.png?raw=true "Windows Azure Portal Sign in")

	Windows Azure Portal Sign in

	>**Speaking Point**
	>
	> The first step in migrating our application to Windows Azure is to create a VM.
	>
	> Let us first navigate to the Windows Azure portal and get signed in.
	>
	> We use Live ID for authentication on the portal, so let’s log in.

1. Click **New** | **Virtual Machine** | **From Gallery**.

	![Creating Virtual Machine from Gallery](Images/creating-virtual-machine-from-gallery.png?raw=true "Creating Virtual Machine from Gallery")

	_Creating a virtual machine from the Gallery_

	>**Speaking Point**
	>
	> Now that we’re logged in, creating a virtual machine via the portal is easy. Let’s select the virtual machines option in the navigation pane.
	>
	> At least one virtual machine will be created, but we’re going to create a new virtual machine that has SQL Server 2012. To do that, we’re going to select the **FROM GALLERY** option.
	>
	>You can use **Quick Create** if you only need one virtual machine that doesn’t need to be load-balanced or joined to a virtual network or
**From Gallery** if you have more complex solution. With the latter, you have more flexibility in how the machine is used in advanced scenarios.

1.	In the **CREATE VIRTUAL MACHINE** dialog, select the **SQL Server 2012 Evaluation** option.
1.	Click the right arrow (Next).


	![Selecting Virtual Machine OS version](Images/selecting-virtual-machine-os-version.png?raw=true "Selecting Virtual Machine OS version")

	_Selecting Virtual Machine OS version_

	>**Speaking Point**
	>
	> Notice all the different VM’s that we have in our gallery. As you can see, we have many VMs that include Linux, as well as several Server 2008 R2 and Server 2012 VMs.
	>
	>We also have, as you can see, a SQL Server 2012 VM. This VM is running SQL Server 2012 Enterprise Evaluation edition which is the VM we want to create, so let’s select that one.

1.	The second page of the **Create Virtual Machine** wizard is the **VM Configuration**. Enter the following:
	- **Virtual Machine Name**: ContosExpenseVM
	- **Password**: Passw0rd!

1.	Enter password for the administrator account, then re-enter the password for confirmation.
1. Select the _Large_ VM **size**.

	![VM Configuration page](Images/vm-configuration-page.png?raw=true "VM Configuration page")

	_VM Configuration page_

	>**Speaking Point**
	>
	> Now what we need to do is give our virtual machine a name. This is the portal display name.
	>
	>We also need to supply an administrator password. 
	>
	>More  importantly, however, we also need to select the size of the VM. There are several size options:
	>
	>	- Extra Small
	>	- Small
	>	- Medium
	>	- Large
	>	- Extra Large
	>
	>These sizes differ, as we can see, in the amount of CPU cores and memory allotted to the VM. It is important that the VM we select will suffice for our needs.

1.	The third page of the **CREATE VIRTUAL MACHINE** wizard is the **VM Mode.** Select the **STANDALONE VIRTUAL MACHINE** option.
1.	Enter a _unique_ **DNS NAME** for the virtual machine.
1.	For the **STORAGE ACCOUNT**, leave the default at **Use Automatically Generated Storage Account**.
1. Choose a suitable **REGION/AFFINITY GROUP/VIRTUAL NETWORK** where the VM will be deployed.

	![VM Mode page](Images/vm-mode-page.png?raw=true "VM Mode page")

	_VM Mode page_

	>**Speaking Point**
	>
	> Next we need to select the type of virtual machine. In other words, is this going to be new standalone virtual machine, or are we connecting to an existing virtual machine? With the new IaaS domain features, we have the ability to join this VM to an existing domain. However, for the purposes of this demo, we’ll simply create a standalone VM.
	>
	> Next we need to supply a DNS name for this VM. 
	> 
	> These VMs are stored in blob storage and we need to specify whether our VM will use a Windows Azure account tied to our subscription if we created one, or use an automatically generated storage account. Since we haven’t created a storage account yet, we’ll use the automatically generated account.
Lastly, we need specify in which region to create the VM. 


1.	The fourth and final page of the **CREATE VIRTUAL MACHINE** wizard is the **VM Options.** 
1.	Select **Create Availability Set**, and set the **NAME** to **MyAvailSet**.
1. Click Finish (check mark).

	![VM Options page](Images/vm-options-page.png?raw=true "VM Options page")

	_VM Options page_

	>**Speaking Point**
	>
	> Lastly, we need to select an availability set in which to create the VM. 
	>
	> An availability set is a group of machines that are deployed across multiple locations (commonly called fault domains). Availability sets are used to protect from outages.
	> 
	>So, we’ll select the **Create Availability Set** option and name the availability set as _MyAvailSet_.
	>
	>Great, we are done! We can see in the portal that our VM is being provisioned.

1. At this point, you may switch over to an already provisioned virtual machine that has been configured with an endpoint for SQL Server Management and that has the corresponding port (1433) opened in its firewall, as well as having an additional SQL Server login which you can use to connect remotely. Otherwise, follow these steps to complete the required configuration. 

1.	In the **Windows Azure Portal**, select the VM you created previously.
1.	Click  the **ENDPOINTS link.**
1.	Click **ADD ENDPOINT** in the command bar.
1.	In the **ADD ENDPOINT** dialog, select **Add Endpoint** and then click the right arrow to go to the next page.

	![Add Endpoint to Virtual Machine page](Images/add-endpoint-to-virtual-machine-page.png?raw=true "Add Endpoint to Virtual Machine page")

	_Adding an endpoint to a virtual machine_

1.	In the second page of the **ADD ENDPOINT** dialog, enter a **NAME** for the endpoint, select **TCP** as the **PROTOCOL**, and enter **1433** for both the **PUBLIC PORT** and **PRIVATE PORT** . 

	![Add Endpoint To Virtual Machine page](Images/add-endpoint-to-virtual-machine-page2.png?raw=true "Add Endpoint To Virtual Machine page")

	_Configuring the virtual machine endpoint_

	>**Speaking Point**
	>
	> Highlight the fact that in order to gain access to SQL Server inside the VM from external, we needed to create an **Endpoint** for port 1433.
	>
	>**Virtual machines** use endpoints to communicate within Windows Azure and with other resources on the Internet
	>
	>Creating the endpoint allows us to access the VM remotely to connect to SQL Server.

	![Endpoints Section](Images/endpoints-section.png?raw=true "Endpoints Section")

1.	Ensure that you are on the **DASHBOARD** page.

1. In the **DASHBOARD**, highlight and copy the **DNS** name of the virtual machine to the clipboard.

	![Virtual Machine's DNS](Images/virtual-machines-dns.png?raw=true "Virtual Machine's DNS")

	_Virtual machine's DNS_

	>**Speaking Point**
	>
	> However, before we connect to the VM, we need to grab some information from it. 
	>
	> In order to connect to SQL Server in the VM, we need its DNS name. We’ll be using it shortly to connect to SQL Server.

1.	Now, click **Connect** on the command bar.
1.	Save the RDP file to the desktop or another suitable location.
1. Minimize the browser.

	![Connect to the Virtual Machine](Images/connect-to-the-virtual-machine.png?raw=true "Connect to the Virtual Machine")

	_Connecting to the virtual machine_

	>**Speaking Point**
	>
	> We’re going to connect to this VM and to do that, we simply select the VM in the portal and click **CONNECT**, which downloads a Remote Desktop Connection file and asks us to open it or save it to disk. 
	>
	> For our existing VM, we will save this shortcut to our desktop.

1.	On the desktop, double-click the RDP file.
2.	In the **Windows Security** dialog, enter the password
	- Password: Passw0rd!
1. Click **OK**.

	![Connecting Virtual Machine - Entering Credentials](Images/connecting-virtual-machine-entering-credent.png?raw=true "Connecting Virtual Machine - Entering Credentials")

	_Entering credentials for the Remote Desktop Connection_

	>**Speaking Point**
	>
	> Let’s log into the virtual machine by entering the password we configured earlier. 

1.	Inside the remote desktop session, click **Run** on the **Start** menu, type **WF.msc**, and then click **OK**.
1.	In the **Windows Firewall with Advanced Security** management console, select **Inbound Rules** in the tree view on the left pane, and then click **New Rule** in the action pane.
1.	In the **Rule Type** dialog box, select **Port**, and then click **Next**.
1.	In the **Protocol and Ports** dialog box, select **TCP**. Select **Specific local ports**, and then type the port number of the instance of the Database Engine, such as **1433** for the default instance. Click **Next**.
1.	In the **Action** dialog box, select **Allow the connection**, and then click **Next**.
1.	In the **Profile** dialog box, select any profiles that describe the computer connection environment when you want to connect to the Database Engine, and then click **Next**.
1.	In the **Name** dialog box, type a name and description for this rule, and then click **Finish**.
new-inbound-firewall-rule.png

	![New Inbound Firewall Rule](Images/new-inbound-firewall-rule.png?raw=true"New Inbound Firewall Rule")

	_Creating a firewall rule for SQL Server access_

	>**Speaking Point**
	> 
	> To gain access to SQL Server in the VM, we need to open port 1433 on the Windows Firewall to allow inbound connections.

1.	Now, open SQL Server Management Studio in the remote desktop session and log in to SQL Server using Windows Authentication.
	![Management Studio's Object Explorer](Images/management-studios-object-explorer.png?raw=true "Management Studio's Object Explorer")

	_Management Studio's Object Explorer_

	>**Speaking Point**
	>
	> Call out the fact that is indeed SQL Server 2012, FULL FUNCTIONALITY.

1. Expand the databases node to illustrate that there are no user databases.
1. Right-click the (root) server node and then select **Properties**.
1. In the **Server Properties** dialog, select the **Security** page.
1. Under **Server authentication**, select the option labeled **SQL Server and Windows Authentication mode** and then click **OK**.

	![Enabling SQL Server Authentication](Images/enabling-sql-server-authentication.png?raw=true "Enabling SQL Server Authentication")

	_Enabling SQL Server Authentication_

	>**Speaking Point**
	> 
	> For this demo, we will enable SQL Server authentication mode and create login that we can use to connect remotely.

1. Now, right-click the (root) server node again and select **Restart** to allow the change in authentication mode to take effect.

1. Expand the **Security** node, right-click **Logins**, and then select **New Login**.
1. In the **Login - New** dialog, type a new **Login name**, for example _demouser_, select **SQL Server authentication**, clear the option labeled **User must change password at next login**, and then click **OK**.

	![New SQL Server Login](Images/sql-server-create-login.png?raw=true"New SQL Server Login")

	_Adding a new SQL Server login_

	>**Speaking Point**
	>
	> For simplicity sake, we also need to create a new SQL Server login with which to connect to SQL Server in the VM.

1. Minimize the remote desktop session for the VM.

1.	Open Management Studio for SQL Server 2012 in your local machine (on-premises).
1.	In the **Connect to Server** dialog, log into the on-premise SQL Server using Windows Authentication.
1. Expand the database node and point to the database that is going to be migrated to the VM. 

	![Connecting to on-premises SQL Server](Images/connecting-to-on-premises-sql-server.png?raw=true "Connecting to on-premises SQL Server")

	_Connecting to the on-premises SQL Server_

	>**Speaking Point**
	>
	> Our first task is to connect to our on-premises SQL Server. This is where our source database is coming from.

1.	Create a second SQL Server connection. In the **Server name** field, paste in the DNS name of the VM copied earlier from the portal.
1. Use SQL Authentication, and type _demouser_ and _Passw0rd1!_ for the login name and password.

	![Creating to SQL Server using VM's DNS Name](Images/creating-to-sql-server-using-vms-dns-name.png?raw=true "Creating to SQL Server using VM's DNS Name")

	_Connecting to the SQL Server in Windows Azure using the VM's DNS name_

	>**Speaking Point**
	>
	> We also need to connect to SQL Server in the VM. 
	>
	>This is simply as easy as specifying the DNS name of the VM. 
	>
	>We copied this name to the clipboard earlier.

1.	You should now have two connections, one for on-premises and one for SQL Server in the VM.
1.	In the on-premises connection, right-click the database to export and select **Tasks** -> **Export Data-Tier Application** in the context menu.
1. In the **Introduction** screen, click **Next**.

	![Exporting Data-tier Application](Images/exporting-data-tier-application.png?raw=true "Exporting Data-tier Application")

	_Exporting Data-tier Application_

	>**Speaking Point**
	>
	> We actually have several ways of getting our database from on-premises to the VM, including the Generate Scripts wizard or backup/restore. 
	>
	> **However, new in Sql Server 2012 is the ability to export and import a database using what are called BACPACs**.

1.	In the **Export Settings** page, select the option labeled **Save to local disk**.
1.	Click Browse.
1.	In the Save As dialog, navigate to the C:\DAC Packages folder and enter **Expenses** for the filename.
1.	Click Save on the Save As dialog.
1.	Click Next.
1. Click Finish on Summary Page.

	![Exporting bacpac file](Images/exporting-bacpac-file.png?raw=true "Exporting bacpac file")

	_Exporting bacpac file_

	>**Speaking Point**
	>
	> **Highlight the following:**
	>
	>	- BACPACs - schema and data
	>	- Save to Windows Azure BLOB storage

1.	We will now import the dacpac i
1.	In the SQL/VM connection in Object explorer, right mouse-click on Databases node.
1.	Select Import Data-Tier Application from context menu.
1. Click Next on the Introduction page.

	![Importing Data-tier Application](Images/importing-data-tier-application.png?raw=true "Importing Data-tier Application")

	_Importing Data-tier Application_

	>**Speaking Point**
	>
	> Again we go back to SQL Server 2012, but this time we select our destination server, which is SQL Server running in the VM.

1.	On the Import Settings page, click the Browse button and navigate to C:\DAC Packages.
1.	Select the xx bacpac file and click Open.
1.	Click Next.
1.	Click Next on the Database Settings page.
1. Click Finish on the Summary page.

	![Importing bacpac file](Images/importing-bacpac-file.png?raw=true "Importing bacpac file")

	_Importing bacpac file_

	>**Speaking Point**
	>
	> Now we’re going to import from the export bacpac file. 
	>
	> Again, Highlight the following:
	>	- BACPACs - schema and data
	>	- Import FROM Windows Azure BLOB storage
	>
	> POINT: No need to create the database! This process will create it for you!**

1.	Maximize the VM, and in SSMS, refresh the databases node.
1. Expand the Tables node.
1.	In Visual Studio. Open the **web.config** .
1.	Remove the existing connection string.
1.	CTL+K, CTL+X.
1.	Select **My XML Snippets**.
1. Insert the **VMConnectionString** snippet.

	![Updating connection stirng within Web.config](Images/updating-connection-stirng-within-webconfig.png?raw=true "Updating connection stirng within Web.config")

	_Updating connection stirng within Web.config_

	>**Speaking Point**
	>
	> We now need to deploy the application to Windows Azure, but we now want it to connect to our database in the VM, so the first thing we need to do is modify the connection string.

1. Press **F5**.

	<!-- TODO: Add application's screenshot -->

	>**Speaking Point**
	>
	> Let’s build our application to ensure we’re good.

1.	Go back to the portal.
1.	Click **NEW** | **WEB SITE** | **QUICK CREATE**. 
1. Enter **ContosoExpense** for the **URL**.
1.	Keep the default **REGION**.
1. Click **Create Web Site**.

	![Creating a new Web Site](Images/creating-a-new-web-site.png?raw=true "Creating a new Web Site")

	_Creating a new Web Site_

	>**Speaking Point**
	>
	> **Quick Create** when you don’t need database connectivity or you will be setting up a database separately.
	>
	> **From Gallery** when you want to quickly build a web site from one of several available templates.
	>
	> **Custom Create** a website if you plan to deploy a completed web application to your Window Azure and you want to simultaneously set up a database for use with your website.
	>
	> We need to specify the URL by which this app will be access. We also need to specify in which region our application will be hosted.
	>
	> POINT: **Notice how fast our WEB SITE was provisioned**.

1. Once provisioned, select the newly created web site **NAME** in the list.

	![Selecting Web Site's name](Images/selecting-web-sites-name.png?raw=true "Selecting Web Site's name")

	_Selecting Web Site's name_

1. In the **DASHBOARD**, click the **Download publish profile** link.

	![Downloading Publish Profile](Images/downloading-publish-profile.png?raw=true "Downloading Publish Profile")

	_Downloading Publish Profile_

1. Save the file to the Desktop.

	>**Speaking Point**
	>
	> POINT: All of the information required to publish a web application to a Windows Azure website for each enabled publication method is stored in an XML file known as a **publish profile**. The publish profile contains the URLs, user credentials and database strings required to connect to and authenticate against each of the endpoints for which a publication method is enabled.

1.	Go back to **Visual Studio**. Right mouse click the **Web Project** and select **Publish** from the context menu.
1.	In the **Publish Web** dialog, click the **Import** button.
1. Browse to the **.PublishSettings** file on the **Desktop**. Click **Open**.

	![Importin Publish Settings File](Images/importin-publish-settings-file.png?raw=true "Importin Publish Settings File")

	_Importin Publish Settings File_

	>**Speaking Point**
	>
	> POINT: **MAXIMUM COMPATABILITY!**

1.	Click **Next**
1.	Click **Publish**
1.	Click **ACCEPT** on the certificate dialog
1. The web site will automatically load after the deployment is finished.

	![Publish Web Application Page](Images/publish-web-application-page.png?raw=true "Publish Web Application Page")

	_Publish Web Application Page_

	>**Speaking Point**
	>
	> The **Web Deploy** settings will be automatically populated according to the settings in the **.PublishSettings** file.
	>
	> We need to accept the **certificate for deployment** when prompted.
	>
	> **POINT:** With a few clicks we have deploy both app and database to the cloud with NO CODE except for changing the connection string. Familiar tools, careful of the migration message.

<a name="segment3" />
#### Windows Azure SQL Database ####

1.	Back in to the Windows Azure portal, select the **SQL Databases** option in the navigation pane
1. Click New.

	![Azure Portal SQL Databases](Images/azure-portal-sql-databases.png?raw=true "Azure Portal SQL Databases")

	_Azure Portal SQL Databases_

	>**Speaking Point**
	>
	> We have multiple options for creating servers and databases. Previously we clicked NEW on the nav bar.
	> Here we simply need to create a server. So  we’re going to go another route and go back to the Navigation bar and select SQL Databases.

1.	Select the **SERVERS** menu option.
1. Click **CREATE A SQL SERVER**.

	![Servers Section](Images/servers-section.png?raw=true "Servers Section")

	_Servers Section_

	>**Speaking Point**
	>
	> From here, we’re going to click the **SERVERS** option because we simply need to provision a server.

1.	In the **SERVER SETTNGS** page, enter the following:
	- Admin Name:  **AzureAdmin**
	- Password: **Passw0rd!**
1.	Ensure the **Allow Windows Azure Services to access the server is checked**.
1.	Click **OK**.
1. Once the server is provisioned, click on the Name in the list.

	![Database server settings](Images/database-server-settings.png?raw=true "Database server settings")

	_Database server settings_

	>**Speaking Point**
	>
	> The admin account is much like the sa account in on-prem SQL Server. This account is the main administrator for the WA SQL Database server.
	> You can create other accounts and assign different permissions just like you can on-prem.

1. Click the **CONFIGURE** menu option.

	![Configure Option](Images/configure-option.png?raw=true "Configure Option")

	_Configure Option_

	>**Speaking Point**
	>
	> With our server provisioned, we need to configure a few things.

1.	Add a Firewall Rule for the current IP ADDRESS.
1. Click the **check mark** on the Rule.

	![Add Firewall Rule](Images/add-firewall-rule.png?raw=true "Add Firewall Rule")

	Add Firewall Rule

1. Click **Save**.

	>**Speaking Point**
	>
	> One of the great features of WA SQL DB is its built-in security. Firewall rules helps protect your data by preventing all access to your server until you specify who, which computers, have permission.
	>
	>Firewall rules grant access based on originating IP Addresses of each request.
	>
	> Let's Save the changes.

1. In the portal, select the DASHBOARD menu option.
1. Copy the **FQDN** of the server to the clipboard.

	![Manage URL](Images/manage-url.png?raw=true "Manage URL")

	_Manage URL_

	>**Speaking Point**
	>
	> Unchanged is how to connect to WA SQL DB; via a DNS endpoint.

1.	Go back to SQL Server Management Studio.
2.	In **Object Explorer**, click **Connect -> Database Engine**.
3.	Enter the following:
	- Login: AzureAdmin
	- Password: Passw0rd!

	![Connecting to Azure SQL Database](Images/connecting-to-azure-sql-database.png?raw=true "Connecting to Azure SQL Database")

	_Connecting to Azure SQL Database_

	>**Speaking Point**
	>
	> We now have every relational database option in a single tool!
	>
	>	- On-Premises
	>	- SQL in a VM
	>	- WA SQL DB

1.	We now need to import the database into WA SQL Database.
1.	In Object Explorer, right mouse-click on Databases node for WA SQL Database and select Import Data-Tier Application from context menu.
1. Click **Next** on the Introduction page.


	![Import Data-tier Application](Images/import-data-tier-application2.png?raw=true "Import Data-tier Application")

	_Import Data-tier Application 2_

	>**Speaking Point**
	>
	> Let’s now import that same bacpac that we used earlier to also import into Azure SQL Database.

1.	On the Import Settings page, click the Browse button and navigate to C:\DAC Packages.
1.	Select the xx bacpac file and click Open.
1. Click **Next**.

	![Importing bacpac file](Images/importing-bacpac-file2.png?raw=true "Importing bacpac file")

	_Importing bacpac file_

	>**Speaking Point**
	>
	> POINT: COMPATIBILTY ON EXPORT.

1.	In the Database Settings page enter the following:
	- New Database Name: Expenses
	- Edition/Size: Keep Default
1. Click **Finish** on the **Summary** page.

	![Specify Settings for the new SQL Database](Images/specify-settings-for-the-new-sql-database.png?raw=true "Specify Settings for the new SQL Database")

	_Specify Settings for the new SQL Database_

	>**Speaking Point**
	>
	> Highlight the fact that it is important to know the size of the database so you can select the right edition and size.
	> Also point out that this process will create the database for you.

1.	In the Portal, select the **Databases** option in the **Navigation** pane.
1. Select the **database NAME**.	
	
	![SQL Databases section](Images/sql-databases-section.png?raw=true "SQL Databases section")

	_SQL Databases section_

1. In the DASHBOARD, click the **Show Connection Strings** link.

	![Show Connection Strings](Images/show-connection-strings.png?raw=true "Show Connection Strings")

	_Show Connection Strings_

1. Highlight and copy the ADO.NET connection string.

	![Connection String](Images/connection-string.png?raw=true "Connection String")

	_Connection String_


1.	In Visual Studio. Open the **web.config** 
1.	Remove the existing connection string
1.	CTL+K, CTL+X
1.	Select **My XML Snippets**
1.	Insert the **AzureConnectionString**
1.	Paste the connection string from the portal into the placeholder.
1. Update the password with:

	![Updating Web.config with Azure Connection String](Images/updating-webconfig-with-azure-connection-stri.png?raw=true "Updating Web.config with Azure Connection String")

	_Updating Web.config with Azure Connection String_

	>**Speaking Point**
	>
	> We now need to deploy the application to Windows Azure, but we now want it to connect to our database in the VM, so the first thing we need to do is modify the connection string.

1. Right mouse click the **Web Project** and select **Publish** from the context menu.

	![Re-deploying application](Images/re-deploying-application.png?raw=true "Re-deploying application")

	_Re-deploying application_

	>**Speaking Point**
	>
	> Simply by changing the connection string and redeploying I running completely in Azure managed services. 


<a name="segment4" />
### Windows Azure SQL Federation ###

1. In SQL Server Management Studio, expand SQL Azure Connection in Object Explorer and select the Databases node.

	![Management Studio's Object Explorer](Images/management-studios-object-explorer-.png?raw=true "Management Studio's Object Explorer")

	>**Speaking Point**
	>
	> The database we have been using up to this point is a single Azure SQL Database. Since we just discussed SQL Federations, we’re going to illustrate how to create a Federated version of our expense report database.
	> In SSMS, we need to create a new database from which we will create our federations. 

1.	Open a new query window and create a new database named **ContosoFED**.
Execute the script.

	![Creating a new database](Images/creating-a-new-database.png?raw=true "Creating a new database")

	_Creating a new database_

	>**Speaking Point**
	>
	> Let’s open a new query window and create a new database. We’ll call this database TechEdDemoDB2. 
	>
	> We need to make sure that the connection for this query window is connected to the Master database.

1.	Once the database is created, open the SQL script on the desktop called ContosoFedDB in SSMS. Ensure that the query window connection is for the new database.
1. Execute the script.

	![Create Federation script](Images/create-federation-script.png?raw=true "Create Federation script")

	_Create Federation script_

	>**Speaking Point**
	>
	> Before we run the script that will create our federation and federated objects, let’s spend a minute looking at the script and Federation syntax. 
	>	- CREATE FED statement
	>	- USE FED statement
	>	- Table changes for FEDs
	>	- Use of GUIDS and why
	>
	> With our root database created, let’s run the script that will create our federation and associated federated objects.

1.	In Object Explorer in SSMS, expand the Federations node of the new database.
1. Right mouse click on the Expense_Federation.

	![Azure SQL Database Connection](Images/azure-sql-database-connection.png?raw=true "Azure SQL Database Connection")
	
	_Azure SQL Database Connection_

	>**Speaking Point**
	>
	> SQL Server 2012 now includes the ability to work directly with Federations. Talking Points:
	>	- Connect to a specific Fed - The ability to connect and query a specific federation
	>	- Split - Scale the database by partitioning the database via the designated key.

1.	Open the SQL script on the desktop called ContosoExpenseFed_Split in SSMS.
1.	Execute the First Statement
1.	Execute the 2nd set of statements (the DMV’s)
1. Execute the SELECT queries

	![Execute Federation Script](Images/execute-federation-script.png?raw=true "Execute Federation Script")

	_Execute Federation Script_

	>**Speaking Point**
	>
	> Walk through the examples of:
	>	- Looking at the metadata
	>	- Split operation
	>	- Querying a specific fed mem

1.	Back in the portal, select **SQL DATABASES** from the navigation menu.
1.	Select the **Databases** option.
1. Click the Federated database **NAME** from the list.

	![SQL Databases page](Images/sql-databases-page.png?raw=true "SQL Databases page")

	_SQL Databases page_

	>**Speaking Point**
	>
	> The Management Portal for SQL Azure is a lightweight and easy-to-use database management tool. It allows you to conveniently manage your SQL Azure databases and to quickly develop, deploy, and manage your data-driven applications in the cloud.

1. In the **Dashboard** for the **Federated** database, click the **MANAGE URL** link.

	![Manage URL](Images/manage-url2.png?raw=true "Manage URL")

	_Manage URL_

1.	Login in with the following:
	1.	AzureAdmin
	1.	Passw0rd!
1. Click **Log On**.

	![Log in to Azure SQL Database portal](Images/log-in-to-azure-sql-database-portal.png?raw=true "Log in to Azure SQL Database portal")

	_Log in to Azure SQL Database portal_

1. In the **Summary Page** of the SQL Database portal, click the **right arrow** in the Federations section to show all Federation Members.

	![SQL Portal showing federations](Images/sql-portal-showing-federations.png?raw=true "SQL Portal showing federations")

	_SQL Portal showing federations_

	>**Speaking Point**
	>
	> Database sharding is a technique of horizontal partitioning data across multiple physical servers to provide application scale-out. SQL Azure combined with database sharding techniques provides for virtually unlimited scalability of data for an application.

1.	In the **Federation Member** grid, click the grey area.
1.	In the **Federation Member** dialog, select the **Split** option.
1.	Enter the value of **40**.
1. Click **Split**.

	![Federation Member](Images/federation-member.png?raw=true "Federation Member")

	_Federation Member_

	>**Speaking Point**
	>
	> Here we’re going to specify the value on which to split the federation, thus creating a second federation member.

1.	Go back to SSMS
1. Talk through the **USE FEDERATION** statements to query the different **Federation Members**.


<a name="segment5" />
### Windows Azure Storage ###

1. Open the **Windows Azure Management portal** and select the **STORAGE ACCOUNTS** option in the **Navigation Pane**.

	![Selecting the Sorage Accounts](Images/selecting-the-sorage-accounts.png?raw=true "Selecting the Sorage Accounts")

	_Selecting the Sorage Accounts_

	>**Speaking Point**
	>
	> There are three options for unstructured and non-relational data storage in Windows Azure: the **Blob**, **Table**, and **Queue** services.
	>
	> A storage account is scoped to a primary geographic region and is configured by default to seamlessly replicate itself to a secondary region in case of a major failure in the primary region.

1. Click **New | STORAGE ACCOUNT | QUICK CREATE**.	

	![Quick Create Storage Account](Images/quick-create-storage-account.png?raw=true "Quick Create Storage Account")

	_Quick Create a Storage Account_

1. In **CREATE A NEW STORAGE ACCOUNT**, enter **contosostorage** for the storage account name.

	![Creating the Storage Account](Images/creating-the-storage-account.png?raw=true "Creating the Storage Account")

	_Creating the Storage Account_

	>**Speaking Point**
	>
	> You can specify either a **geographic region** or an **affinity group** for your storage. By specifying an affinity group, you can co-locate your cloud apps in the same data center with your storage
	>
	> Geo-replication is turned on by default. During geo-replication, your data is replicated to a secondary location, at no cost to you, so that your storage fails over seamlessly to a secondary location in the event of a major failure that can't be handled in the primary location. The secondary location is assigned automatically, and can't be changed**

1. Click **CREATE STORAGE ACCOUNT**.	

1. Open **Visual Studio** and go to **Tools | Library Manager Console menu | Package Manager Console**.

	> By running the following command at the **Package Manager Console** we are adding the Windows Azure Storage Client libraries to the project.

1. In the Package Manager Console, type: **Install-Package WindowsAzure.Storage**.

	![Using the Package Manager Console](Images/using-the-package-manager-console.png?raw=true "Using the Package Manager Console")

	_Using the Package Manager Console_

1. In the Web.config, within the appsettings section, find the comment that says “**Windows Azure Storage Account**”

	>**Speaking Point**
	>
	> Let’s add the storage account snippet. This information allows us to securely access our storage services.

1. Press **CTL+K**, **CTL+X**, select **My XML Snippets** and insert the **StorageAccountInfo** snippet.

	![Editing Web.config values](Images/editing-webconfig-values.png?raw=true "Editing Web.config values")

	_Editing Web.config values_

1. Replace the Key with your Storage Account value.

1. Open **Views | Reports | EditorTemplates | ExpenseReportDetail.cshtml**

	>**Speaking Point**
	>
	> Let’s add the code so show the **attach receipt**  link/icon for each expense line item.

1. Add a new line after line 17. Enter **attachlink** and press **TAB** to install the code snippet.

	![Editing ExtenseReportDetail.cshtml](Images/editing-extensereportdetailcshtml.png?raw=true "Editing ExtenseReportDetail.cshtml")

	_Editing ExtenseReportDetail.cshtml_

1. Open **Views | Reports | Edit.cshtml**

	>**Speaking Point**
	>
	> Next, let’s add the **Submit Receipt** form.

1. At line 85, enter **attachform** and press **TAB** to install the code snippet.	

	![Editing Edit.cshtml](Images/editing-editcshtml.png?raw=true "Editing Edit.cshtml")

	_Editing Edit.cshtml_

1. Open **Controllers | ReportsController**

	>**Speaking Point**
	>
	> Next, let’s add the code to **save the receipt into blob storage**.

1. Add a new line after line 112, enter **attachmethod** and press **TAB** to install the code snippet.

	![Editing ReportsController.cs](Images/editing-reportscontrollercs.png?raw=true "Editing ReportsController.cs")

	_Editing ReportsController.cs_

1. Go back to the **Azure Management portal** and select **STORAGE** from the navigation pane.

	![Selecing Storage from the Management Portal](Images/selecing-storage-from-the-management-portal.png?raw=true "Selecing Storage from the Management Portal")

	_Selecing Storage from the Management Portal_

1. Select the newly created storage account **NAME** in the list of storage accounts.

	![Selecting the Storage Account Name](Images/selecting-the-storage-account-name.png?raw=true "Selecting the Storage Account Name")

	_Selecting the Storage Account Name_

1. Select the **CONFIGURE** menu option.

	![Selecting Configure Option](Images/selecting-configure-option.png?raw=true "Selecting Configure Option")

	_Selecting Configure Option_

	>**Speaking Point**
	>
	> The Blob Monitoring **Minimal** value collects metrics such as ingress/egress, availability, latency, and success percentages summarized at the Blob, Table, and Queue service level.
	>
	> The Blob Monitoring **VERBOSE** value collects metrics at the API operation level in addition to the service-level metrics. Verbose metrics enable closer analysis of issues that occur during application operations

1. In the **MONITORING** section for **BLOBS**, set the monitoring level to **MINIMAL**.

	![Selecting Monitoring Blobs Option](Images/selecting-monitoring-blobs-option.png?raw=true "Selecting Monitoring Blobs Option")

	_Selecting Monitoring Blobs Option_

	>**Speaking Point**
	>
	> Let’s go grab our **account key**. Let’s go back to the portal and select our storage account, and click **MANAGE KEYS**.

1. Click **MANAGE KEYS**.

	![Clicking Manage Keys](Images/clicking-manage-keys.png?raw=true "Clicking Manage Keys")

1. Copy the **Primary Access Key** to the clipboard.

	![Copying the Primary Access Key](Images/copying-the-primary-access-key.png?raw=true "Copying the Primary Access Key")

	_Copying the Primary Access Key_

1. Scroll to the end of that line and paste in the **account key** from step 34.

	![Editing Web.config AccountKey](Images/editing-webconfig-accountkey.png?raw=true "Editing Web.config AccountKey")

	_Editing Web.config AccountKey_

	>**Speaking Point**
	>
	> Every account has a set of unique keys. We need to update the key in our web.config with the key or the account we just generated.

1. Right mouse click the **Web Project** and select **Publish** from the context menu. Follow the Wizard until the application is deployed.

	![Redeploying the application](Images/redeploying-the-application.png?raw=true "Redeploying the application")

	_Redeploying the application_

	>**Speaking Point**
	>
	> Finally, let’s re-deploy the application.

1. In the expense App, log in as a user and modify the Expense Report to attach a receipt.

1. Click the **Attach receipt** link.

	![Clicking Attach Receipt](Images/attach-receipt.png?raw=true "Clicking Attach Receipt")

	_Clicking Attach Receipt_

1. In the **Attach Receipt** dialog, click **Browse**.

	![Clicking Browse Receipt](Images/clicking-browse-receipt.png?raw=true "Clicking Browse Receipt")

	_Clicking Browse Receipt_

1. In the favourites window, select the Receipts folder and double-click a receipt.

1. Click **Submit** on the **Attach Receipt** dialog.	

	![Submiting a Receipt](Images/submiting-a-receipt.png?raw=true "Submiting a Receipt")

	_Submiting a Receipt_

1. **Save** and **Submit** the expense report.

	![Saving and Submiting](Images/saving-and-submiting.png?raw=true "Saving and Submiting")

	_Saving and Submiting_

1. Log off as a user.

1. Log in as a manager, approve the expense report and view the Receipt.

	>**Speaking Point**
	>
	> Types of data store and manage. Query with familiar tools.

1. Back in the portal, click the **MONITOR** option.	

	![Portal Monitor Option](Images/portal-monitor-option.png?raw=true "Portal Monitor Option")

	_Portal Monitor Option_

	>**Speaking Point**
	>
	> Hopefully there will be some data.

---
<a name="Appendix" />
## Appendix ##


<a name="Appendix1" />
### Appendix 1: How to open a port in the Windows firewall for TCP access ###

1.	On the **Start** menu, click **Run**, type **WF.msc**, and then click **OK**.
1.	In the **Windows Firewall with Advanced Security**, in the left pane, right-click **Inbound Rules**, and then click **New Rule** in the action pane.
1.	In the **Rule Type** dialog box, select **Port**, and then click **Next**.
1.	In the **Protocol and Ports** dialog box, select **TCP**. Select **Specific local ports**, and then type the port number of the instance of the Database Engine, such as **1433** for the default instance. Click **Next**.
1.	In the **Action** dialog box, select **Allow the connection**, and then click **Next**.
1.	In the **Profile** dialog box, select any profiles that describe the computer connection environment when you want to connect to the Database Engine, and then click **Next**.
1.	In the **Name** dialog box, type a name and description for this rule, and then click **Finish**.


<a name="Appendix2" />
### Appendix 2: To add an Virtual Machine Endpoint ###

1.	In the **Windows Azure Portal**, select the VM you want to create the endpoint on.
1.	Click  the **ENDPOINTS link.**
1.	Click **ADD ENDPOINT**.
1.	In the first page of the **ADD ENDPOINT** dialog, select the **Add Endpoint** option then click the right arrow to go to the second page.

	![Add Endpoint to Virtual Machine page](Images/add-endpoint-to-virtual-machine-page.png?raw=true "Add Endpoint to Virtual Machine page")

	_Add Endpoint to Virtual Machine page_

1.	In the second page of the **ADD ENDPOINT** dialog, enter a **NAME** for the endpoint, select **TCP** for the **protocol**, and enter **1433** for the **PUBLIC** and **PRIVATE** ports. 

	![Add Endpoint To Virtual Machine page](Images/add-endpoint-to-virtual-machine-page2.png?raw=true "Add Endpoint To Virtual Machine page")

	_Add Endpoint To Virtual Machine page_


---
<a name="summary" />
## Summary ##

In this demo, you learned how to:

1. Deploy applications to Windows Azure Web Sites.

1. Connect applications to a Windows Azure SQL Database.

1. Connect applications to use Windows Azure Storage.

1. Create SQL Database Federations.