# create a dump of the database - replace parameters (such as host, username, etc.) as needed
pg_dump -h localhost -p 5432 -U postgres -F c -b -v -f  "<path>\dump.bak" db_name
