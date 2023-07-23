# create a database in hive
CREATE_DB_CMD_DWH = """
/usr/bin/beeline -u jdbc:hive2://*** -n *** -p *** <<END_SQL
drop database if exists whdb cascade;
create database whdb;
END_SQL
"""

# drop delta tables
DROP_DELTA_TABLES = """
/usr/bin/beeline -u jdbc:hive2://*** -n *** -p *** <<END_SQL
drop table if exists tmp.countries_delta;
drop table if exists tmp.cities_delta;
drop table if exists tmp.nobel_laureates_delta;
END_SQL
"""