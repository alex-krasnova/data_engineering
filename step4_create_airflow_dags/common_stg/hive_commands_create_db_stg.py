# create a database in hive
CREATE_DB_CMD_STG = """
/usr/bin/beeline -u jdbc:hive2://*** -n *** -p *** <<END_SQL
drop database if exists staging cascade;
create database staging;
drop database if exists tmp cascade;
create database tmp;
END_SQL
"""

