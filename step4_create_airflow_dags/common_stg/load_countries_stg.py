# COUNTRIES - staging
# the full list of countries comes, there is no delta of values
# the data in CSV file is in the directory '/staging/countries_of_the_world'

# create Countries table
LOAD_COUNTRIES_STG = """
/usr/bin/beeline -u jdbc:hive2://*** -n *** -p *** <<END_SQL
-- create an external table for the new data
create external table staging.countries_of_the_world_ext (
    country varchar(50),
    region varchar(50),
    population int,
    area_sq_mi int,
    pop_density_per_sq_mi decimal(8,2),
    coastline decimal(7,3),
    net_migration decimal(6,3),
    infant_mortality_per_1000_births decimal(7,3),
    gdp_dol_per_capita int,
    literacy_percent decimal(6,3),
    phones_per_1000 decimal(7,3),
    arable_percent decimal(6,3),
    crops_percent decimal(6,3),
    other_percent decimal(6,3),
    climate decimal(4,2),
    birthrate decimal(6,3),
    deathrate decimal(6,3),
    agriculture decimal(5,4),
    industry decimal(5,4),
    service decimal(5,4)
)
comment 'Countries table - for data in CSV file countries_of_the_world.csv'
row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
with serdeproperties (
   "separatorChar" = ",",
   "quoteChar"     = "\"")
stored as textfile
location '/staging/countries_of_the_world'
tblproperties ('skip.header.line.count'='1');

-- create a temporary managed table of the desired structure, in which new data will be accumulated
-- the table accumulates data before being converted to Data Warehouse tables, then the table is dropped in the Airflow graph
create table if not exists tmp.countries_delta (
    country varchar(50),
    region varchar(50),
    population int,
    area_sq_mi int,
    pop_density_per_sq_mi decimal(8,2),
    coastline decimal(7,3),
    net_migration decimal(6,3),
    infant_mortality_per_1000_births decimal(7,3),
    gdp_dol_per_capita int,
    literacy_percent decimal(6,3),
    phones_per_1000 decimal(7,3),
    arable_percent decimal(6,3),
    crops_percent decimal(6,3),
    other_percent decimal(6,3),
    climate decimal(4,2),
    birthrate decimal(6,3),
    deathrate decimal(6,3),
    agriculture decimal(5,4),
    industry decimal(5,4),
    service decimal(5,4),
	upd_date date -- new field, loading date
);

-- insert from external table into temporary
insert into table tmp.countries_delta select * from 
(
	(select * from staging.countries_of_the_world_ext), 
	current_date
);

-- create a managed table
create table if not exists staging.countries_of_the_world (
    country varchar(50),
    region varchar(50),
    population int,
    area_sq_mi int,
    pop_density_per_sq_mi decimal(8,2),
    coastline decimal(7,3),
    net_migration decimal(6,3),
    infant_mortality_per_1000_births decimal(7,3),
    gdp_dol_per_capita int,
    literacy_percent decimal(6,3),
    phones_per_1000 decimal(7,3),
    arable_percent decimal(6,3),
    crops_percent decimal(6,3),
    other_percent decimal(6,3),
    climate decimal(4,2),
    birthrate decimal(6,3),
    deathrate decimal(6,3),
    agriculture decimal(5,4),
    industry decimal(5,4),
    service decimal(5,4)
)
partitioned by (
	upd_date date
)
stored as orc;

-- specify that the partitioning is dynamic
set hive.exec.dynamic.partition.mode=nonstrict
-- insert data from temporary table
insert into staging.countries_of_the_world partition (upd_date) select * from tmp.countries_delta;

-- drop external table
drop table staging.countries_of_the_world_ext;
END_SQL
"""