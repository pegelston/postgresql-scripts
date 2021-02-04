SELECT relname          AS tablename
     , n_live_tup       AS livetuples
     , n_dead_tup       AS deadtuples
     , last_autovacuum  AS autovacuum
     , last_autoanalyze AS autoanalyze
FROM
    pg_stat_user_tables
ORDER BY
    deadtuples DESC
;
