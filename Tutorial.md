<a name="title" />
# Contoso Expense Reporting Demo #

---

<a name="Overview" />
## Overview ##

In this demo, you will show how to move an on-premise application to Windows Azure, using Virtual Machines and SQL Databases.

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

(TODO: Insert setup steps here)

---

<a name="Tutorial" />
## Tutorial ##

This demo is composed of the following segments:

1. [Contoso Expense Reporting on-premise](#segment1).
1. [Deploy the Expense demo to a Web Site](#segment2).
1. [Connect application to a SQL Database](#segment3). 
1. [Connect application to Windows Azure Storage](#segment4). 
1. [Create a SQL Database Federations](#segment5). 

<a name="segment1" />
### Contoso Expense Reporting on-premise ###

1. Open **Visual Studio 2012** as an Administrator.

1. Open the **Begin** solution from the **Source** folder of this demo.

1. Run the application. When the Home page is displayed, select **Register** to create a new User.

	![Contoso Expense Reporting Home Page](images/contoso-expense-reporting-home-page.png?raw=true)

	_Contoso Expense Reporting Home Page_

1. Create a new user by entering a username, email and password. Click **Register** to continue.

	![Registering a new user](images/registering-a-new-user.png?raw=true)

	_Registering a New User_

1. Enter the Profile values for **First Name**, **Last Name** and **Title**, and select one of the sample managers from the drop-down list.

	![Creating the User Profile](images/creating-the-user-profile.png?raw=true)

	_Creating the User Profile_

1. Once the user is created, select the **My Reports** menu option and create a new report by clicking the **Add New Report** button.

	![Adding a New Report](images/adding-a-new-report.png?raw=true)

	_Adding a New Report_

1. Set the Report **Title** and **Purpose**. Add two **Expenses** to the report with different values. When prompted, confirm the action.

	![Setting the Expense Report](images/setting-the-expense-report.png?raw=true)

	_Setting the Expense Report_

<a name="segment2" />
### Deploying the Application to a Windows Azure Web Site ###


---

<a name="summary" />
## Summary ##

(TODO: Insert a summary text here. For example:)  
In this tutorial, you saw how to easily start Notepad.