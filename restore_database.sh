# restore the dump to a local server
pg_restore -h localhost -p 5432 -U postgres -d db_name -v "<path>\dump.bak"
