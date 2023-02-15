/* 
Types of columns:

1. main columns - main properties of Nobel Prizes: laureate name, gender, year of prize, type - individual or organization, cathegory of Prize, etc.

2. birth date, city and country description columns - detailed information about city and country of birth of laureate to explore conditions of birth. Contain economic and geographic characteristics of places.

3. death date, city and country description columns - detailed information about city and country of death of laureate. Do not contain economic and geographic characteristics of places, just conditions for man: GDP, CITY/country population, coastline, etc.

4. organization name, city and country description columns - detailed information about city and country of laureate's organizations. Contain main characteristics only: city and country names, regions, continents, city/country population, GDP. Laureates can work in more than 1 organization (max count of organization for 1 laureate = 3). 3 sets of organization columns will be created.
*/

CREATE TABLE LAUREATES
(
	-- main columns
	LAUREATE_ID number(38) GENERATED AS IDENTITY, -- PK
	YEAR number(38), -- for analyisis by years of prizes and groupings of co-authors
	CATHEGORY varchar2(30), -- cathegory of prize: Medicine, Physics, Chemistry, etc, for analysis by prize cathegirues and groupings of co-authors
	PRIZE varchar2(255), -- for analysis by prize types
	PRIZE_SHARE number(38, 12), -- shows if the prize was shared, for analysis of collectivity
	LAYREATE_TYPE varchar2(20) -- type of laureate: individual or organization, for analysis by types
	MOTIVATION varchar2(255), -- for analysis of text and themes

	-- laureate persons main columns
	LAUREATE_PERSON_NAME varchar2(255), -- name of laureate (person), for reports
	LAUREATE_GENDER varchar2(10), -- male/female, for analysis by gender
	
	-- laureate societies main columns
	SOCIETY_NAME varchar2(255), -- name of laureate (society), for reports

	-- birth date, city and country description columns
	BIRTH_DATE date, -- for analysis by age
	BIRTH_CITY_NAME varchar2(50), -- for analysis by place of birth
	BIRTH_CITY_REGION varchar2(10), -- region of city in the country, for analysis by place of birth
	BIRTH_CITY_POPULATION number(38), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_CITY_LATITUDE number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_CITY_LONGITUDE number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_NAME varchar2(50), -- for analysis by place of birth
	BIRTH_COUNTRY_PARENT_NAME varchar2(50), -- modern name of a country if a name was changed (or a same name), for analysis by history
	BIRTH_REGION_NAME varchar2(50), -- for analysis by place of birth
	BIRTH_CONTINENT_NAME varchar2(50), -- for analysis by place of birth
	BIRTH_COUNTRY_POPULATION number(38), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_AREA_SQ_MILES number(38), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_POP_DENCITY_PER_SQ_MILE number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_COASTLINE number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_NET_MIGRATION number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_INFANT_MORTALITY_PER_1000 number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_GDB number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_PERCENT_LITERACY number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_PHONES_PER_1000 number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_PERCENT_ARABLE number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_PERCENT_CROPS number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_PERCENT_OTHER number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_CLIMATE number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_BIRTHRATE number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_DEATHRATE number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_AGRICULTURE number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_INDUSTRY number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	BIRTH_COUNTRY_SERVICE number(38, 12), -- for analysis according to the conditions of the birth of the laureate
	
	-- death date, city and country description columns
	DEATH_DATE date, -- for analysis by life expectancy
	DEATH_CITY_NAME varchar2(50), -- for analysis by place of end of life
	DEATH_CITY_REGION varchar2(10), -- region of city in the country, for analysis by place of end of life
	DEATH_CITY_POPULATION number(38), -- for analysis according to the conditions of the end of life of the laureate
	DEATH_CITY_LATITUDE number(38, 12), -- for analysis according to the conditions of the end of life of the laureate
	DEATH_CITY_LONGITUDE number(38, 12), -- for analysis according to the conditions of the end of life of the laureate
	DEATH_COUNTRY_NAME varchar2(50), -- for analysis by place of end of life
	DEATH_COUNTRY_PARENT_NAME varchar2(50), -- modern name of a country if a name was changed (or a same name), for analysis by history
	DEATH_REGION_NAME varchar2(50), -- for analysis by place of end of life
	DEATH_CONTINENT_NAME varchar2(50), -- for analysis by place of end of life
	DEATH_COUNTRY_POPULATION number(38), -- for analysis according to the conditions of the end of life of the laureate
	DEATH_COUNTRY_GDB number(38, 12), -- for analysis according to the conditions of the end of life of the laureate
	DEATH_COUNTRY_COASTLINE number(38, 12), -- for analysis according to the conditions of the end of life of the laureate
	DEATH_COUNTRY_CLIMATE number(38, 12), -- for analysis according to the conditions of the end of life of the laureate
	
	-- organization 1 name, city and country description columns
	ORGANIZATION_NAME1 varchar2(255), -- for analysis by place of work
	ORGANIZATION_PARENT_NAME1 varchar2(255), -- parent name of an organization if a name was changed (or a same name), for analysis by history
	ORGANIZATION_CITY_NAME1 varchar2(50), -- for analysis by place of work
	ORGANIZATION_CITY_REGION1 varchar2(10), -- region of CITY in the country, for analysis by place of work
	ORGANIZATION_CITY_POPULATION1 number(38), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_CITY_LATITUDE1 number(38, 12), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_CITY_LONGITUDE1 number(38, 12), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_COUNTRY_NAME1 varchar2(50), -- for analysis by place of work
	ORGANIZATION_COUNTRY_PARENT_NAME1 varchar2(50), -- modern name of a country if a name was changed (or a same name), for analysis by history
	ORGANIZATION_REGION_NAME1 varchar2(50), -- for analysis by place of work
	ORGANIZATION_CONTINENT_NAME1 varchar2(50), -- for analysis by place of work
	ORGANIZATION_COUNTRY_POPULATION1 number(38), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_COUNTRY_GDB1 number(38, 12), -- for analysis according to the conditions of the work of the laureate
	
	-- organization 2 name, city and country description columns
	ORGANIZATION_NAME2 varchar2(255), -- for analysis by place of work
	ORGANIZATION_PARENT_NAME2 varchar2(255), -- parent name of an organization if a name was changed (or a same name), for analysis by history
	ORGANIZATION_CITY_NAME2 varchar2(50), -- for analysis by place of work
	ORGANIZATION_CITY_REGION2 varchar2(10), -- region of CITY in the country, for analysis by place of work
	ORGANIZATION_CITY_POPULATION2 number(38), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_CITY_LATITUDE2 number(38, 12), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_CITY_LONGITUDE2 number(38, 12), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_COUNTRY_NAME2 varchar2(50), -- for analysis by place of work
	ORGANIZATION_COUNTRY_PARENT_NAME2 varchar2(50), -- modern name of a country if a name was changed (or a same name), for analysis by history
	ORGANIZATION_REGION_NAME2 varchar2(50), -- for analysis by place of work
	ORGANIZATION_CONTINENT_NAME2 varchar2(50), -- for analysis by place of work
	ORGANIZATION_COUNTRY_POPULATION2 number(38), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_COUNTRY_GDB2 number(38, 12), -- for analysis according to the conditions of the work of the laureate
	
	-- organization 3 name, city and country description columns
	ORGANIZATION_NAME3 varchar2(255), -- for analysis by place of work
	ORGANIZATION_PARENT_NAME3 varchar2(255), -- parent name of an organization if a name was changed (or a same name), for analysis by history
	ORGANIZATION_CITY_NAME3 varchar2(50), -- for analysis by place of work
	ORGANIZATION_CITY_REGION3 varchar2(10), -- region of CITY in the country, for analysis by place of work
	ORGANIZATION_CITY_POPULATION3 number(38), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_CITY_LATITUDE3 number(38, 12), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_CITY_LONGITUDE3 number(38, 12), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_COUNTRY_NAME3 varchar2(50), -- for analysis by place of work
	ORGANIZATION_COUNTRY_PARENT_NAME3 varchar2(50), -- modern name of a country if a name was changed (or a same name), for analysis by history
	ORGANIZATION_REGION_NAME3 varchar2(50), -- for analysis by place of work
	ORGANIZATION_CONTINENT_NAME3 varchar2(50), -- for analysis by place of work
	ORGANIZATION_COUNTRY_POPULATION3 number(38), -- for analysis according to the conditions of the work of the laureate
	ORGANIZATION_COUNTRY_GDB3 number(38, 12), -- for analysis according to the conditions of the work of the laureate
);