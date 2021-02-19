# usage:
# params must be in this order
# PGPASSWORD=<password> ./vacuum_analyze_schema.sh <your-pg-schema> <your-pg-db> <your-pg-user> <your-pg-host>

# vacuum analyze only the tables in the specified schema

# postgres info can be supplied by either passing it as parameters to this
# function, setting environment variables or a combination of the two
pg_schema="${1:-${PG_SCHEMA}}"
pg_db="${2:-${PG_DB}}"
pg_user="${3:-${PG_USER}}"
pg_host="${4:-${PG_HOST}}"

echo "Vacuuming schema \`${pg_schema}\`:"

# extract schema table names from psql output and put them in a bash array
psql_tbls="\dt ${pg_schema}.*"
sed_str="s/${pg_schema}\s+\|\s+(\w+)\s+\|.*/\1/p"
table_names=$( echo "${psql_tbls}" | psql -d "${pg_db}" -U "${pg_user}" -h "${pg_host}"  | sed -nr "${sed_str}" )
tables_array=( $( echo "${table_names}" | tr '\n' ' ' ) )

# loop through the table names creating and executing a vacuum
# command for each one
for t in "${tables_array[@]}"; do
    echo "doing table \`${t}\`..."
    psql -d "${pg_db}" -U "${pg_user}" -h "${pg_host}" \
        -c "VACUUM FULL VERBOSE ANALYZE ${pg_schema}.${t};"
done