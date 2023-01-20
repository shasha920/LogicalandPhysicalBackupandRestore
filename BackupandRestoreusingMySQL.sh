#Perform Logical Backup and Restore
#Fetch the scripts files
wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0231EN-SkillsNetwork/datasets/World/world_mysql_script.sql
wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0231EN-SkillsNetwork/datasets/World/world_mysql_update_1.sql

#Create a new database
create database world_P1;
use world_P1;

#complete the database
source world_mysql_script.sql;

#updating the database cript
source world_mysql_update_1.sql;

#retrieve table
SELECT * FROM city WHERE countrycode='BGD';

#Perform a logical backup of the table
\q
mysqldump --host=127.0.0.1 --port=3306 --user=root --password world_P1 city > world_P1_city_mysql_backup.sql

#Drop the table
mysql --host=127.0.0.1 --port=3306 --user=root --password --execute="DROP TABLE world_P1.city;"
mysql --host=127.0.0.1 --port=3306 --user=root --password --execute="SELECT * FROM world_P1.city;"
mysql --host=127.0.0.1 --port=3306 --user=root --password world_P1 < world_P1_city_mysql_backup.sql
mysql --host=127.0.0.1 --port=3306 --user=root --password --execute="SELECT * FROM world_P1.city;"


#Perform Physical Backup and Restore
#Create a new database
create database world_P2;
use world_P2;

#complete the database creation process
source world_mysql_script.sql;

#updating the database
source world_mysql_update_2.sql;

#retrieve all the records
SELECT * FROM country WHERE code in ('BGD','CAN');
SELECT * FROM countrylanguage WHERE countrycode in ('BGD','CAN');
SELECT * FROM city WHERE countrycode in ('BGD','CAN');

#Perform a physical backup of the database
\q
docker cp mysql-mysql-1:/var/lib/mysql/world_P2 /home/project/mysql_world_P2_backup

#Remove the database directory from the mysql server
docker exec mysql-mysql-1 rm -rf /var/lib/mysql/world_P2
docker exec -it mysql-mysql-1 mysqladmin -p shutdown
#necessary after making changes to the mysql server data directory
mysql --host=127.0.0.1 --port=3306 --user=root --password --execute="SELECT * FROM world_P2.city;"
docker cp /home/project/mysql_world_P2_backup/. mysql-mysql-1:/var/lib/mysql/world_P2
docker exec -it mysql-mysql-1 mysqladmin -p shutdown
#necessary after making changes to the mysql server data directory
mysql --host=127.0.0.1 --port=3306 --user=root --password --execute="SELECT * FROM world_P2.city;"


#Perform Point-in-Time Backup and Restore
#First create a full logical backup
mysqldump --host=127.0.0.1 --port=3306 --user=root --password --flush-logs --delete-master-logs  --databases world > world_mysql_full_backup.sql
use world;

#List all the table names
SHOW TABLES;

#update script
source world_mysql_update_B.sql;

#Retrieve the table
SELECT * FROM city WHERE countrycode='CAN';

#Quit the MySQL command
\q

#create a scenario where a database crash will be conducted intentionally which will result a significant loss of your world database files
docker exec mysql-mysql-1 rm -rf /var/lib/mysql/world
docker exec -it mysql-mysql-1 mysqladmin -p shutdown

#Try to retrieve records from any table
mysql --host=127.0.0.1 --port=3306 --user=root --password --execute="SELECT * FROM world.city;"

#Display the binary logs using the command
mysql --host=127.0.0.1 --port=3306 --user=root --password --execute="SHOW BINARY LOGS;"

#Write the contents of all binary log files listed
docker exec mysql-mysql-1 mysqlbinlog /var/lib/mysql/binlog.000003 /var/lib/mysql/binlog.000004 > logfile.sql

#perform point-in-time restore
mysql --host=127.0.0.1 --port=3306 --user=root --password < world_mysql_full_backup.sql

#verify have the updates from the update script
mysql --host=127.0.0.1 --port=3306 --user=root --password --execute="SELECT * FROM world.city WHERE countrycode='CAN';"
mysql --host=127.0.0.1 --port=3306 --user=root --password < logfile.sql


