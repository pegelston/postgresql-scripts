SELECT
  now() - pg_stat_activity.query_start AS duration, *
FROM pg_stat_activity
WHERE (now() - pg_stat_activity.query_start) > INTERVAL '5 minutes';

-- SELECT pg_cancel_backend(__pid__);