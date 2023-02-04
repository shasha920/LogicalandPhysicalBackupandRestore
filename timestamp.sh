#Create a shell script which takes the database name and back up directory as parameters 
#and backsup the database as \_timestamp.sql in the backup directory. 
#If the database doesn't exist, it should display appropriate message. 
#If the backup dir doesn't exist, it should create one.
dbname=$(mysql -e "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = '$1'" | grep $1)

if [ ! -d $2 ]; then 
    mkdir $2
fi

if [ $1 == $dbname ]; then
    sqlfile=$2/$1-$(date +%d-%m-%Y).sql
    if mysqldump  $1 > $sqlfile ; then
    echo 'Sql dump created'
    else
        echo 'Error creating backup!'
    fi
else
    echo "Database doesn't exist"
fi
