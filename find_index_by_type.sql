SELECT tab.relname
     , cls.relname
     , am.amname
FROM
    pg_index          idx
        JOIN pg_class cls ON cls.oid = idx.indexrelid
        JOIN pg_class tab ON tab.oid = idx.indrelid
        JOIN pg_am    am ON am.oid = cls.relam
;
