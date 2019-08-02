-- Adapted from Erwin Brandstetter's solution here: https://stackoverflow.com/a/30971095/1601182
--
-- Explanation
--     1.) In the 1st CTE, identify a master row in each partition with the same key information. Leverage the system ctid value.
--     2.) In the 2nd CTE update_<reference_table>, redirect all rows referencing a dupe to the master row in <table_name>.
--     3.) Finally, delete dupes, leaving only the master row.
--
-- For more information on Data-Modifying CTEs, see the following documentation:
--      https://www.postgresql.org/docs/current/queries-with.html#QUERIES-WITH-MODIFYING
WITH duplicates                 AS (
    SELECT *
    FROM
        (
            SELECT ctid
                 , min(ctid) OVER (
                PARTITION BY
                    key
                ) AS master_ctid
            FROM
                <table_name>
        ) sub
    WHERE
        ctid <> master_ctid -- ... <> self
)
  ,  update_<reference_table>       AS (
    UPDATE <reference_table>
        -- link to master <table_name>_id ...
        SET <table_name>_id = (
            SELECT <table_name>.<table_name>_id
            FROM
                <table_name>
            WHERE
                <table_name>.ctid = duplicates.master_ctid
        )
        FROM duplicates
        WHERE <reference_table>.<table_name>_id = (
            SELECT <table_name>_id
            FROM
                <table_name>
            WHERE
                <table_name>.ctid = duplicates.ctid
        )
)
DELETE
FROM
    <table_name> USING duplicates
WHERE
    <table_name>.ctid = duplicates.ctid
;
