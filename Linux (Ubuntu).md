//==========MySQL==========//
Execute a SQL file from URL; Import SQL file:
    curl 'https://raw.githubusercontent.com/user/repo/data.sql' | mysql -uroot -p123

Install mysql-server
    apt install -y mysql-server
Start mysql:
    usermod -d /var/lib/mysql/ mysql && service mysql start

Run mysql_secure_installation

If there's an error running mysql_secure_installation, run the following commands in mysql to enable mysql_secure_installation:
    mysql
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123';
    FLUSH PRIVILEGES;
    EXIT;
    
Log in:
    mysql -u<user> -p<password>
    mysql -uroot -p123

Log out
    exit;

Commands:
    SHOW DATABASES;
    SHOW TABLES;
    SHOW @@PORT;
    USE `databaseName`;
    DESCRIBE `tableName`;
//==========MySQL==========//

//==========PostgreSQL==========//
Install postgresql
    apt install -y postgresql postgresql-contrib

Start postgresql:
    service postgresql start
    
Add password:
    sudo passwd postgres
    
Enable postgres=# prompt:
    sudo -i -u postgres

Access postgres=# prompt:
    psql

Shorthand for enabling and accessing postgres=#:
    sudo -u postgres psql
    
    *exit
    \q

Log out:
    \q
    exit
    
Create new role:
    *if logged in to postgres=#
        createuser --interactive

    sudo -u postgres createuser --interactive
    
List databases;
    \l
    
List tables:
    \dt
    
Delete all tables; remove all tables:
    DROP SCHEMA public CASCADE;
    CREATE SCHEMA PUBLIC;
    
Use database:
    \c database_name
    
Dump database:
    pg_dump -d database_name -h localhost -p 5432 -U root > database_name.sql

    pg_dump --schema-only -d database_name -h localhost -p 5432 -U root > database_name_schema.sql

    pg_dump --data-only -d database_name -h localhost -p 5432 -U root > database_name_data.sql
//==========PostgreSQL==========//