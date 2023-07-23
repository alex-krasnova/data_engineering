# COUNTRIES - staging
# take the delta values
# the data in CSV file is in the directory '/staging/nobel_laureates'

LOAD_NOB_PRIZES_STG = """
/usr/bin/beeline -u jdbc:hive2://*** -n *** -p *** <<END_SQL
-- create an external table for the new data
create external table staging.nobel_laureates_ext (
    year int,
    category varchar(20),
    prize varchar(50),
    motivation varchar(255),
    prize_share varchar(10),
    laureate_id int,
    laureate_type varchar(20),
    full_name varchar(255),
    birth_date date,
    birth_city varchar(50),
    birth_country varchar(50),
    gender varchar(10),
    organization_name varchar(255),
    organization_city varchar(50),
    organization_country varchar(50),
    deathdate date,
    death_city varchar(50),
    death_country varchar(50)
)
comment 'Nobel Laureate table - for data in CSV file nobel.csv'
row format serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
with serdeproperties (
   "separatorChar" = ",",
   "quoteChar"     = "\"")
stored as textfile
location '/staging/nobel_laureates'
tblproperties ('skip.header.line.count'='1');

-- create a temporary managed table of the required structure that will contain the delta
create table if not exists tmp.nobel_laureates_delta (
    year int,
    prize varchar(50),
    motivation varchar(255),
    prize_share varchar(10),
    laureate_id int,
    laureate_type varchar(20),
    full_name varchar(255),
    birth_date date,
    birth_city varchar(50),
    birth_country varchar(50),
    gender varchar(10),
    organization_name varchar(255),
    organization_city varchar(50),
    organization_country varchar(50),
    deathdate date,
    death_city varchar(50),
    death_country varchar(50),
	category varchar(20),
	upd_date date -- new field, loading date
);

-- insert from external table into temporary
-- the table accumulates data before being converted to Data Warehouse tables, then the table is dropped in the Airflow graph
insert into table tmp.nobel_laureates_delta select * from 
(
	(select 
		year, prize, motivation, prize_share, laureate_id, laureate_type, full_name, birth_date, birth_city, birth_country,
		gender, organization_name, organization_city, organization_country, deathdate, death_city, death_country, category
	from staging.nobel_laureates_ext), 
	current_date
);

-- create a managed table
create table if not exists staging.nobel_laureates (
    year int,
    prize varchar(50),
    motivation varchar(255),
    prize_share varchar(10),
    laureate_id int,
    laureate_type varchar(20),
    full_name varchar(255),
    birth_date date,
    birth_city varchar(50),
    birth_country varchar(50),
    gender varchar(10),
    organization_name varchar(255),
    organization_city varchar(50),
    organization_country varchar(50),
    deathdate date,
    death_city varchar(50),
    death_country varchar(50)
)
partitioned by (
	category varchar(20),
	upd_date date
)
clustered by (laureate_id) into 16 buckets
stored as orc;

-- specify that the partitioning is dynamic
set hive.exec.dynamic.partition.mode=nonstrict
-- insert data from temporary table
insert into staging.nobel_laureates partition (category,upd_date) select * from tmp.nobel_laureates_delta;

-- drop external table
drop table staging.nobel_laureates_ext;
END_SQL
"""