DELETE
FROM
    duplicate a USING (
    SELECT MIN(ctid) AS ctid, key
    FROM
        duplicate
    GROUP BY key
    HAVING
        COUNT(*) > 1
)             b
WHERE
      a.key = b.key
  AND a.ctid <> b.ctid
;
