-- disconnect from the database to be renamed
\c postgres

-- force disconnect all other clients from the database to be renamed
SELECT pg_terminate_backend(pid)
FROM
    pg_stat_activity
WHERE
      pid <> pg_backend_pid()
  AND datname = '<database>';

-- rename the database (it should now have zero clients)
ALTER DATABASE "<database>" RENAME TO "<new_database>";
