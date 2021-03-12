-- view partition information for a table
SELECT pt.relname                                 AS partition_name
     , PG_GET_EXPR(pt.relpartbound, pt.oid, TRUE) AS partition_expression
FROM
    pg_class             base_tb
        JOIN pg_inherits i ON i.inhparent = base_tb.oid
        JOIN pg_class    pt ON pt.oid = i.inhrelid
WHERE
    base_tb.oid = '<schema>.<table>'::REGCLASS
;
