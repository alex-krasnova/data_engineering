# data_engineering
Example of Data Modeling, Hive, Spark, Airflow.

### Based on the data in the source datasets, the following steps should be performed:
1. Create:
	- a database model - "Snowflake" schema (for the BI analysis), which will contain all the data from the original datasets for Nobel Laureates, cities, countries and other data, divided into separate entities;
	- a model of one dataset with all the necessary information on Nobel Laureates, their places of birth, work, etc. for further analysis by Data Scientists;
	- SQL scripts for creating tables (in this work, they are created for Oracle DB - for example);
2. Load all original datasets "as is" to Hadoop - Hive database, create a staging (Datalake) database;
3. Transform data using Spark (Pyspark lib of Python): from the original datasets to the structure modeled in step 1 - "Snowflake" (for BI) and "Dataset" (for Data Sciencists). In the example, the data will be taken from the original datasets, in real life - from staging Hive database in a Hadoop cluster, created in step 2.
4. Using SQL queries and Spark code in the steps 2 and 3, create Airflow DAGs that automates a process:
- loading data into Staging;
- creating a snowflake and a dataset tables in the Data Warehouse.
Create (or modify) DAGs that will load updates (staging, snowflakes and datasets).

### Decription of the initial datasets ('data' directory):
- nobel.csv - informaton about Nobel Prizes and Nobel Laureates.<br>
- countries of the world.csv - list of countries with geographic and economic information (region, population, birthrate, etc.).<br>
- worldcitiespop.csv - list of cities with latitude and longtitude - not stored here, load from https://www.kaggle.com/max-mind/world-cities-database<br>
- names.json - list of ISO2 codes of countries.<br>
- continent.json - matching countries and continents.<br>
- capital.json - countries capitals.<br>
- currency.json - countries currencies.<br>
- iso3.json - list of ISO3 codes of countries.<br>
- phone.json - phone's codes in countries.

Original data files are stored in Kaggle:<br>
https://www.kaggle.com/timoboz/country-data<br>
https://www.kaggle.com/fernandol/countries-of-the-world<br>
https://www.kaggle.com/max-mind/world-cities-database<br>
https://www.kaggle.com/nobelfoundation/nobel-laureates<br>
