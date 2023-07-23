# CITIES - staging
# the full list of cities comes, there is no delta of values
# data is stored in MySQL table

# sqoop data from mysql to hive
SQOOP_CITIES_STG = """
hdfs dfs -rm -r -skipTrash /tmp/cities >/dev/null 2>&1
sqoop import --connect jdbc:mysql://*** --username *** --password *** \
--table mysqldb.cities --hive-import --hive-table staging.cities_mysql \
--hs2-url jdbc:hive2://***
exit $?
"""

# update Cities table
LOAD_CITIES_STG = """
/usr/bin/beeline -u jdbc:hive2://*** -n *** -p *** <<END_SQL
-- create a temporary managed table of the desired structure, in which new data will be accumulated
-- the table accumulates data before being converted to Data Warehouse tables, then the table is dropped in the Airflow graph
create table if not exists tmp.cities_delta (
    city string,
    accentcity string,
    region int,
    population int,
    latitude decimal(20,17),
    longitude decimal(20,17),
	country string,
	upd_date date -- new field, loading date
);

-- insert from sqoop table into temporary
insert into table tmp.cities_delta select * from 
(
	(select city, accentcity, region, population, latitude, longitude, country from staging.cities_mysql), 
	current_date
);

-- create a managed table
create table if not exists staging.cities (
    city string,
    accentcity string,
    region int,
    population int,
    latitude decimal(20,17),
    longitude decimal(20,17)
)
partitioned by (
	country string,
	upd_date date
)
clustered by (region,accentcity) into 16 buckets
stored as orc;

-- specify that the partitioning is dynamic
set hive.exec.dynamic.partition.mode=nonstrict
-- insert data from temporary table
insert into staging.cities partition (country,upd_date) select * from tmp.cities_delta;

-- drop sqoop table
drop table staging.cities_mysql;
END_SQL
"""


