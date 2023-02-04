#Prepare database
wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0110EN-SkillsNetwork/datasets/sakila/sakila_mysql_dump.sql

#start MySQL
start_mysql

#Open .my.cnf
sudo nano ~/.my.cnf

#Add password
[mysql]
host = 127.0.0.1
port = 3306
user = root
password = <Your MySQL Password>

[mysqlimport]
host = 127.0.0.1
port = 3306
user = root
password = <Your MySQL Password>

[mysqldump]
host = 127.0.0.1
port = 3306
user = root
password = <Your MySQL Password>

[mysqlshow]
host = 127.0.0.1
port = 3306
user = root
password = <Your MySQL Password>

[mysqlcheck]
host = 127.0.0.1
port = 3306
user = root
password = <Your MySQL Password>

[mysqladmin]
host = 127.0.0.1
port = 3306
user = root
password = <Your MySQL Password>

#Initiate MySQL
mysql

#create database
create database sakila;

#Restore Data
use sakila;
source sakila_mysql_dump.sql;
SHOW FULL TABLES WHERE table_type = 'BASE TABLE';

#create sqlbackup.sh folder(see same name .sh file in same branch

#executable permission for the shell script file
sudo chmod u+x+r sqlbackup.sh
mkdir /home/theia/backups

#setting up Cron Job
crontab -e
*/2 * * * * /home/project/sqlbackup.sh > /home/project/backup.log
#create a backup every week on Monday at 12:00 a.m
#0 12 * * 1 /home/project/sqlbackup.sh > /home/project/backup.log
#create a backup every day at 6:00 a.m
#0 6 * * * /home/project/sqlbackup.sh > /home/project/backup.log

#start cron service
sudo service cron start

#check whether the backup file are created
ls -l /home/theia/backups

#Stop the cron service
sudo service cron stop

#Truncate the Tables

#create truncate.sh folder(see same name .sh file in same branch

#Change the permission
sudo chmod u+x+r truncate.sh

#Execute the script to truncate
sudo ./truncate.sh

#check whether the tables in the database are truncated
mysql
use sakila;
show tables;
select * from staff;
\q


#Restore the Database
#find the list of backup files that have been created
ls -l /home/theia/backups

#Unzip the file and extract the SQL file from the backup file
gunzip /home/theia/backups/<backup zip file name>

#Populate and restore the database with the sqlfile that results from the unzip operation
mysql sakila < /home/theia/backups/<backup sql file name>

#check the restored database
mysql
use sakila;
select * from staff;
\q
