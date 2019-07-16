SELECT *
     , pg_size_pretty(total_bytes) AS total
     , pg_size_pretty(index_bytes) AS index
     , pg_size_pretty(toast_bytes) AS toast
     , pg_size_pretty(table_bytes) AS table_size
FROM
    (
        SELECT *, total_bytes - index_bytes - COALESCE(toast_bytes, 0) AS table_bytes
        FROM
            (
                SELECT c.oid
                     , nspname                               AS table_schema
                     , relname                               AS table_name
                     , c.reltuples                           AS row_estimate
                     , pg_total_relation_size(c.oid)         AS total_bytes
                     , pg_indexes_size(c.oid)                AS index_bytes
                     , pg_total_relation_size(reltoastrelid) AS toast_bytes
                FROM
                    pg_class                   c
                        LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
                WHERE
                    relkind = 'r'
            ) a
    ) a
ORDER BY total_bytes DESC
;