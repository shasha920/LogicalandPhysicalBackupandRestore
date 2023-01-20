#look at the original entry for the passenger in the "tickets" table
SELECT * FROM tickets WHERE booking_ref = '0002D8';

#Modify the entry for this passenger
UPDATE tickets SET passenger_name = 'SANYA KORELEVA' WHERE booking_ref = '0002D8';

#perform a full backup of the database
pg_dump --username=postgres --host=localhost restored_demo > restored_demo_backup.sql

