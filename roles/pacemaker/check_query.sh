. {{ cbdb_base_dir }}/cloudberry-db/greenplum_path.sh && psql -tAc "SELECT 100 FROM pg_database WHERE datname='{{ madlib_database_name }}'" )
