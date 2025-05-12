# For MSSQL

The following commands for installing SQL Server point to the RHEL 8 repository.

To configure SQL Server on RHEL, run the following commands in a terminal to install the `mssql-server` package:

1.  Download the SQL Server 2022 (16.x) Red Hat repository configuration file:
    
    BashCopy
    
    ```
    sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/8/mssql-server-2022.repo
    ```
    
     Tip
    
    If you want to install a different version of SQL Server, see the [SQL Server 2017 (14.x)](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-linux-2017&preserve-view=true#install) or [SQL Server 2019 (15.x)](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-linux-ver15&preserve-view=true#install) versions of this article.
    
2.  Run the following command to install SQL Server:
    
    BashCopy
    
    ```
    sudo yum install -y mssql-server
    ```
    
3.  After the package installation finishes, run `mssql-conf setup` using its full path, and follow the prompts to set the SA password and choose your edition. As a reminder, the following SQL Server editions are freely licensed: Evaluation, Developer, and Express.
    
    BashCopy
    
    ```
    sudo /opt/mssql/bin/mssql-conf setup
    ```
    
    Remember to specify a strong password for the SA account. You need a minimum length 8 characters, including uppercase and lowercase letters, base-10 digits and/or non-alphanumeric symbols.
    
4.  Once the configuration is done, verify that the service is running:
    
    BashCopy
    
    ```
    systemctl status mssql-server
    ```
    
5.  To allow remote connections, open the SQL Server port on the RHEL firewall. The default SQL Server port is TCP 1433. If you're using **FirewallD** for your firewall, you can use the following commands:
    
    BashCopy
    
    ```
    sudo firewall-cmd --zone=public --add-port=1433/tcp --permanent
    sudo firewall-cmd --reload
    ```
    

At this point, SQL Server is running on your RHEL machine and is ready to use!

## [](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver16#tools)Install the SQL Server command-line tools

To create a database, you need to connect with a tool that can run Transact-SQL statements on SQL Server. The following steps install the SQL Server command-line tools: [sqlcmd](https://learn.microsoft.com/en-us/sql/tools/sqlcmd-utility?view=sql-server-ver16) and [bcp](https://learn.microsoft.com/en-us/sql/tools/bcp-utility?view=sql-server-ver16).

1.  Download the Red Hat repository configuration file.
    
    BashCopy
    
    ```
    sudo curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/8/prod.repo
    ```
    
2.  If you had a previous version of **mssql-tools** installed, remove any older unixODBC packages.
    
    BashCopy
    
    ```
    sudo yum remove unixODBC-utf16 unixODBC-utf16-devel
    ```
    
3.  Run the following commands to install **mssql-tools** with the unixODBC developer package. For more information, see [Install the Microsoft ODBC driver for SQL Server (Linux)](https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver16).
    
    BashCopy
    
    ```
    sudo yum install -y mssql-tools unixODBC-devel
    ```
    
4.  For convenience, add `/opt/mssql-tools/bin/` to your `PATH` environment variable, to make **sqlcmd** or **bcp** accessible from the bash shell.
    
    For interactive sessions, modify the `PATH` environment variable in your `~/.bash_profile` file with the following command:
    
    BashCopy
    
    ```
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
    ```
    
    For non-interactive sessions, modify the `PATH` environment variable in your `~/.bashrc` file with the following command:
    
    BashCopy
    
    ```
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
    source ~/.bashrc
    ```
    

## [](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver16#connect-locally)Connect locally

The following steps use **sqlcmd** to locally connect to your new SQL Server instance.

1.  Run **sqlcmd** with parameters for your SQL Server name (`-S`), the user name (`-U`), and the password (`-P`). In this tutorial, you are connecting locally, so the server name is `localhost`. The user name is `sa` and the password is the one you provided for the SA account during setup.
    
    BashCopy
    
    ```
    sqlcmd -S localhost -U sa -P '<YourPassword>'
    ```
    
    You can omit the password on the command line to be prompted to enter it.
    
    If you later decide to connect remotely, specify the machine name or IP address for the `-S` parameter, and make sure port 1433 is open on your firewall.
    
2.  If successful, you should get to a **sqlcmd** command prompt: `1>`.
    
3.  If you get a connection failure, first attempt to diagnose the problem from the error message. Then review the [connection troubleshooting recommendations](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-troubleshooting-guide?view=sql-server-ver16#connection).
    

## [](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver16#create-and-query-data)Create and query data

The following sections walk you through using **sqlcmd** to create a new database, add data, and run a simple query.

For more information about writing Transact-SQL statements and queries, see [Tutorial: Writing Transact-SQL Statements](https://learn.microsoft.com/en-us/sql/t-sql/tutorial-writing-transact-sql-statements?view=sql-server-ver16).

### [](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver16#create-a-new-database)Create a new database

The following steps create a new database named `TestDB`.

1.  From the **sqlcmd** command prompt, paste the following Transact-SQL command to create a test database:
    
    SQLCopy
    
    ```
    CREATE DATABASE TestDB;
    ```
    
2.  On the next line, write a query to return the name of all of the databases on your server:
    
    SQLCopy
    
    ```
    SELECT Name from sys.databases;
    ```
    
3.  The previous two commands were not executed immediately. You must type `GO` on a new line to execute the previous commands:
    
    SQLCopy
    
    ```
    GO
    ```
    

### [](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver16#insert-data)Insert data

Next create a new table, `dbo.Inventory`, and insert two new rows.

1.  From the **sqlcmd** command prompt, switch context to the new `TestDB` database:
    
    SQLCopy
    
    ```
    USE TestDB;
    ```
    
2.  Create new table named `dbo.Inventory`:
    
    SQLCopy
    
    ```
    CREATE TABLE dbo.Inventory (
       id INT, name NVARCHAR(50),
       quantity INT
    );
    ```
    
3.  Insert data into the new table:
    
    SQLCopy
    
    ```
    INSERT INTO dbo.Inventory VALUES (1, 'banana', 150);
    INSERT INTO dbo.Inventory VALUES (2, 'orange', 154);
    ```
    
4.  Type `GO` to execute the previous commands:
    
    SQLCopy
    
    ```
    GO
    ```
    

### [](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver16#select-data)Select data

Now, run a query to return data from the `dbo.Inventory` table.

1.  From the **sqlcmd** command prompt, enter a query that returns rows from the `dbo.Inventory` table where the quantity is greater than 152:
    
    SQLCopy
    
    ```
    SELECT * FROM dbo.Inventory
    WHERE quantity > 152;
    ```
    
2.  Execute the command:
    
    SQLCopy
    
    ```
    GO
    ```
    

### [](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver16#exit-the-sqlcmd-command-prompt)Exit the sqlcmd command prompt

To end your **sqlcmd** session, type `QUIT`:

SQLCopy

```
QUIT
```

## [](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver16#performance-best-practices)Performance best practices

After installing SQL Server on Linux, review the best practices for configuring Linux and SQL Server to improve performance for production scenarios. For more information, see [Performance best practices and configuration guidelines for SQL Server on Linux](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-performance-best-practices?view=sql-server-ver16).

## [](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver16#cross-platform-data-tools)Cross-platform data tools

In addition to **sqlcmd**, you can use the following cross-platform tools to manage SQL Server:

Tool

Description

[Azure Data Studio](https://learn.microsoft.com/en-us/sql/azure-data-studio/?view=sql-server-ver16)

A cross-platform GUI database management utility.

[Visual Studio Code](https://learn.microsoft.com/en-us/sql/tools/visual-studio-code/sql-server-develop-use-vscode?view=sql-server-ver16)

A cross-platform GUI code editor that run Transact-SQL statements with the mssql extension.

[PowerShell Core](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-manage-powershell-core?view=sql-server-ver16)

A cross-platform automation and configuration tool based on cmdlets.

[mssql-cli](https://github.com/dbcli/mssql-cli/tree/master/doc)

A cross-platform command-line interface for running Transact-SQL commands.

## [](https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-red-hat?view=sql-server-ver16#connecting-from-windows)Connecting from Windows

SQL Server tools on Windows connect to SQL Server instances on Linux in the same way they would connect to any remote SQL Server instance.

If you have a Windows machine that can connect to your Linux machine, try the same steps in this topic from a Windows command-prompt running **sqlcmd**. You must use the target Linux machine name or IP address rather than `localhost`, and make sure that TCP port 1433 is open on the SQL Server machine. If you have any problems connecting from Windows, see [connection troubleshooting recommendations](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-troubleshooting-guide?view=sql-server-ver16#connection).

For other tools that run on Windows but connect to SQL Server on Linux, see:

-   [SQL Server Management Studio (SSMS)](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-manage-ssms?view=sql-server-ver16)
-   [Windows PowerShell](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-manage-powershell?view=sql-server-ver16)
-   [SQL Server Data Tools (SSDT)](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-develop-use-ssdt?view=sql-server-ver16)

# For .Net

```
dnf install dotnet-sdk-7.0
dnf install aspnetcore-runtime-7.0

For .Net 6

dnf install dotnet-sdk-6.0
dnf install aspnetcore-runtime-6.0
```