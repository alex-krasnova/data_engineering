# Task Description

Using SQL queries and Spark code in the steps 2 and 3, create Airflow DAGs that automates a process:
- loading data into Staging;
- creating a snowflake and a dataset tables in the Data Warehouse.

Create (or modify) DAGs that will load updates (staging, snowflakes and datasets).

Initially, the data is stored:
- in the MySQL table - information about cities, 
- in the CSV - information about countries and Nobel Prizes,
- in the JSON files - information about continents, currencies, country codes, capitals.

## DAGs Airflow

af_load_to_staging.py - DAG Airflow for loading and update data in Staging.
af_load_to_datawarehouse.py - DAG Airflow for loading and updating data from Staging to DWH.

Each DAG Airflow can work in the mode of initial loading and data transformation or in the mode of loading updated data. Each DAG must be called with a parameter that specifies the mode: CREATE (initial data loading) or UPDATE (loading updated data).

The code for transform data from Staging to Data Warehouse is in the dwh_common directory.
The code for loading into Staging is in the stg_common directory.

## Description of Staging and Staging Delta tables

In CREATE mode, data will be loaded into the following Staging tables:
staging.nobel_laureates
staging.countries_of_the_world
staging.cities
staging.country_continents
staging.country_currencies
staging.country_iso3
staging.country_names
staging.country_phones
staging.country_capital

CREATE mode creates tables in the Data Warehouse with data from all these datasets.

It is assumed that new data will regularly load in the following 3 Staging tables:
City - comes the full list of cities, not delta, quarterly
Country - comes the full list of countries, not delta, quarterly
Nobel Prizes - delta values coming weekly - Nobel Prize facts

For these three Staging tables, the information in which will be updated (i.e., supplemented with new partitions), delta tables are created that store new data:
tmp.countries_delta
tmp.cities_delta
tmp.nobel_laureates_delta

The process of loading data into Staging and Staging Delta tables for Countries, Cities and Nobel Prizes tables will not differ in CREATE and UPDATE modes.

The data will be accumulated in these delta tables with the upd_date column - the date the data was saved in the table, so that they can then be loaded into DWH.
The last statement in the DWH column is to delete the delta tables so that they can be recreated when the next piece of data arrives in Staging.

## Description of Data Warehouse tables

The updated data of the City and Country datasets will be stored in the DWH table in new partitions, i.e. the data of 2 tables become history tables:

whdb.cities - city information
whdb.countries - country information

For more convenient data processing in UPDATE mode, 2 additional up-to-date tables are created in the DWH column:
whdb.countries_uptodate - for each country, only the row loaded last remains, i.e. with the maximum value of upd_date
whdb.cities_uptodate - for each city, only the row loaded last remains, i.e. with the maximum value of upd_date

When updating data (in UPDATE mode), Nobel Laureates, because a delta arrives with new values, some DWH tables will also store the last loaded row for each logical key. Here are the tables with data aggregation:

whdb.laureate_persons - for each Laureate Person, only the row loaded last, i.e. with the maximum value of upd_date, remains
whdb.organizations - for each Organization, only the row loaded last, i.e. with the maximum value of upd_date, remains
whdb.prize_types - for each type of Prizes, only the row loaded last, i.e. with the maximum value of upd_date, remains
whdb.societies - for each Laureate Society, only the row loaded last, i.e. with the maximum value of upd_date, remains
whdb.persons_in_orgs - for each laureate_id+org_name pair, only the row loaded last, i.e. with the maximum value of upd_date, remains

Tables created from the Nobel Prizes dataset, without data aggregation:

whdb.nobel_prizes 
	- this table is loaded as 1-to-1 from the Staging Delta table with data on the facts of the Nobel Prize, i.e. all incoming values must be new.
whdb.dataset 
	- this is an extended table nobel_prizes with additional information about the Nobel Prizes, their organizations, countries, cities. New values are also simply loaded into tables, and the table is not aggregated further.
whdb.codes_in_countries
	- the table contains the relationship between Country Code Id and Country Id. With each transformation, a new Country Id is calculated and all data in the table is overwritten.
