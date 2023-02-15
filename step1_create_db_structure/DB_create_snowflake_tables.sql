/* 
The LAUREATE_TYPES table contains information about the laureate type, "Individual" or "Organization".
The information is taken from the "Nobel Laureates" dataset (nobel.csv).
*/
CREATE TABLE LAUREATE_TYPES (
	LAUREATE_TYPE_ID number(38) GENERATED AS IDENTITY, 
	LAYREATE_TYPE varchar2(20) NOT NULL, 
	PRIMARY KEY (LAUREATE_TYPE_ID)
);

/* 
The CATHEGORIES table contains information about the categories of the Nobel Prize, such as "Peace" or "Physics".
The information is taken from the "Nobel Laureates" dataset.
*/
CREATE TABLE CATEGORIES (
	CATEGORY_ID number(38) NOT NULL, 
	CATEGORY varchar2(30) NOT NULL, 
	PRIMARY KEY (CATEGORY_ID)
);

/* 
The PRIZE_TYPES table contains information about the types of Prizes, for example, "The Nobel Prize in Physics 2011".
The information is taken from the "Nobel Laureates" dataset (nobel.csv).
*/
CREATE TABLE PRIZE_TYPES (
	PRIZE_TYPE_ID number(38) GENERATED AS IDENTITY, 
	PRIZE_TYPE varchar2(255) NOT NULL, 
	PRIMARY KEY (PRIZE_TYPE_ID)
);

/* 
The GENDERS table contains information about the laureate's gender, "Male" or "Female".
The information is taken from the "Nobel Laureates" dataset (nobel.csv).
*/
CREATE TABLE GENDERS (
	GENDER_ID number(38) NOT NULL, 
	GENDER varchar2(30) NOT NULL, 
	PRIMARY KEY (GENDER_ID)
);

/* 
The REGIONS table contains information about the regions in which the cities are located.
The information is taken from the "World Cities Database" dataset (worldcitiespop.csv) - "Region" column.
*/
CREATE TABLE REGIONS (
	REGION_ID number(38) GENERATED AS IDENTITY, 
	REGION_NAME varchar2(50) NOT NULL, 
	PRIMARY KEY (REGION_ID)
);

/* 
The CONTINENTS table contains information about continents.
The information is taken from the "Continent" dataset (continent.json).
*/
CREATE TABLE CONTINENTS (
	CONTINENT_ID number(38) GENERATED AS IDENTITY, 
	CONTINENT_NAME varchar2(50) NOT NULL, 
	CONTINENT_CODE varchar2(5) NOT NULL, 
	PRIMARY KEY (CONTINENT_ID)
);

/* 
The CURRENCY_CODES table contains information about currencies.
The information is taken from the "Currencies" dataset (currency.json).
*/
CREATE TABLE CURRENCY_CODES (
	CURRENCY_CODE_ID number(38) NOT NULL, 
	CURRENCY_CODE varchar2(5) NOT NULL, 
	PRIMARY KEY (CURRENCY_CODE_ID)
);

/* 
The COUNTRIES table contains information about countries: the region of the country, its population, currency, etc.
The information is taken from the "Countries of the World" (countries of the world.csv), "Continents" (continent.json) and "Capitals" (capital.json) datasets.
Has links to tables:
	REGIONS - the region in which the country is located (Region column in "Countries of the World").
	CONTINENTS - the continent where the country is located.
	COUNTRIES - a link to another entry in the same table in case the country changed its name. The parent record must contain the modern name of the country, the child record - the name of the country at the time of the Prize.
*/
CREATE TABLE COUNTRIES (
	COUNTRY_ID number(38) GENERATED AS IDENTITY, 
	COUNTRY_NAME varchar2(50) NOT NULL, 
	REGION_ID number(38) NOT NULL, 
	CONTINENT_ID number(38) NOT NULL, 
	PARENT_COUNTRY_ID number(38), 
	CAPITAL_NAME varchar2(50), 
	POPULATION number(38), 
	AREA_SQ_MILES number(38), 
	POP_DENCITY_PER_SQ_MILE number(38, 12), 
	COASTLINE number(38, 12), 
	NET_MIGRATION number(38, 12), 
	INFANT_MORTALITY_PER_1000 number(38, 12), 
	GDB_DOLLAR_PER_CAPITA number(38), 
	PERCENT_LITERACY number(38, 12), 
	PHONES_PER_1000 number(38, 12), 
	PERCENT_ARABLE number(38, 12), 
	PERCENT_CROPS number(38, 12), 
	PERCENT_OTHER number(38, 12), 
	CLIMATE number(38, 12), 
	BIRTHRATE number(38, 12), 
	DEATHRATE number(38, 12), 
	AGRICULTURE number(38, 12), 
	INDUSTRY number(38, 12), 
	SERVICE number(38, 12), 
	PRIMARY KEY (COUNTRY_ID)
);

ALTER TABLE COUNTRIES ADD CONSTRAINT FKCOUNTRIES631556 FOREIGN KEY (REGION_ID) REFERENCES REGIONS (REGION_ID);
ALTER TABLE COUNTRIES ADD CONSTRAINT FKCOUNTRIES264430 FOREIGN KEY (CONTINENT_ID) REFERENCES CONTINENTS (CONTINENT_ID);
ALTER TABLE COUNTRIES ADD CONSTRAINT FKCOUNTRIES601390 FOREIGN KEY (PARENT_COUNTRY_ID) REFERENCES COUNTRIES (COUNTRY_ID);

/* 
The COUNTRY_CODES table contains information about codes: ISO2, ISO3, Phone code, Currency code.
Information is taken from the "Names and ISO2 codes" (names.json), "ISO3 Codes" (iso3.json), "Currencies" (currency.json), "Phone Codes" (phone.json) datasets.
Has a link to a table:
	COUNTRIES - information about the country in which the country code is used.
	CURRENCY_CODES - information about the currency code used in the country.
	
*/
CREATE TABLE COUNTRY_CODES (
	COUNTRY_CODE_ID number(38) NOT NULL, 
	COUNTRY_ID number(38) NOT NULL,
	CODE_NAME number(10), 
	ISO2_CODE varchar2(5) NOT NULL, 
	ISO3_CODE varchar2(5), 
	CURRENCY_CODE_ID number(38) NOT NULL, 
	PHONE_CODE varchar2(10), 
	PRIMARY KEY (COUNTRY_CODE_ID)
);

ALTER TABLE COUNTRY_CODES ADD CONSTRAINT FKCOUNTRY_CO41491 FOREIGN KEY (CURRENCY_CODE_ID) REFERENCES CURRENCY_CODES (CURRENCY_CODE_ID);
ALTER TABLE COUNTRY_CODES ADD CONSTRAINT FKCOUNTRY_CO571745 FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRIES (COUNTRY_ID);

/* 
The CITIES table contains information about cities: country, population, etc.
The information is taken from the "Cities" dataset (worldcitiespop.csv).
Has a link to a table:
	COUNTRIES - information about the country in which the city is located.
*/
CREATE TABLE CITIES (
	CITY_ID number(38) NOT NULL, 
	CITY_NAME varchar2(50) NOT NULL, 
	ACCENT_CITY_NAME varchar2(255), 
	COUNTRY_ID number(38) NOT NULL, 
	CITY_REGION varchar2(10), 
	POPULATION number(38), 
	LATITUDE varchar2(100), 
	LONGITUDE varchar2(100), 
	PRIMARY KEY (CITY_ID)
);

ALTER TABLE CITIES ADD CONSTRAINT FKCITIES752676 FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRIES (COUNTRY_ID);

/* 
The SOCIETIES table contains information about the laureates with laureate type = "Organization".
The information is taken from the "Nobel Laureates" dataset (nobel.csv).
*/
CREATE TABLE SOCIETIES (
	LAUREATE_ID number(38) GENERATED AS IDENTITY, 
	SOCIETY_NAME varchar2(255) NOT NULL, 
	PRIMARY KEY (LAUREATE_ID)
);

/* 
The LAUREATE_PERSONS table contains information about Nobel laureates - persons, (for records with laureate type = "Individual").
The information is taken from the "Nobel Laureates" dataset (nobel.csv).
Has links to tables:
	GENDERS - the gender of the laureate, "Male" or "Female".
	CITIES - refers to the table twice, link 1 - information about the city of birth of the laureate, link 2 - information about the city in which the laureate died.
	COUNTRIES - refers to the table twice, link 1 - information about the country of birth of the laureate, link 2 - information about the country in which the laureate died.
*/
CREATE TABLE LAUREATE_PERSONS (
	LAUREATE_ID number(38) GENERATED AS IDENTITY, 
	FULL_NAME varchar2(255) NOT NULL, 
	GENDER_ID number(38) NOT NULL, 
	BIRTH_DATE date, 
	BIRTH_CITY_ID number(38), 
	BIRTH_COUNTRY_ID number(38) NOT NULL, 
	DEATH_DATE date, 
	DEATH_CITY_ID number(38), 
	DEATH_COUNTRY_ID number(38) NOT NULL, 
	PRIMARY KEY (LAUREATE_ID)
);

ALTER TABLE LAUREATE_PERSONS ADD CONSTRAINT FKLAUREATE_P646534 FOREIGN KEY (GENDER_ID) REFERENCES GENDERS (GENDER_ID);
ALTER TABLE LAUREATE_PERSONS ADD CONSTRAINT FKLAUREATE_P454949 FOREIGN KEY (BIRTH_CITY_ID) REFERENCES CITIES (CITY_ID);
ALTER TABLE LAUREATE_PERSONS ADD CONSTRAINT FKLAUREATE_P190428 FOREIGN KEY (DEATH_CITY_ID) REFERENCES CITIES (CITY_ID);
ALTER TABLE LAUREATE_PERSONS ADD CONSTRAINT FKLAUREATE_P327921 FOREIGN KEY (BIRTH_COUNTRY_ID) REFERENCES COUNTRIES (COUNTRY_ID);
ALTER TABLE LAUREATE_PERSONS ADD CONSTRAINT FKLAUREATE_P421091 FOREIGN KEY (DEATH_COUNTRY_ID) REFERENCES COUNTRIES (COUNTRY_ID);

/* 
The ORGANIZATIONS table contains information about organizations - institutions where the laureate worked (Organization columns in the Nobel Laureates dataset).
The information is taken from the "Nobel Laureates" dataset (nobel.csv).
Has links to tables:
	CITIES - information about the city in which the organization is located.
	COUNTRIES - information about the country in which the organization is located.
	ORGANIZATIONS - a link to another row in the same table, i.e. on Parent Id in the case when the same organizations have subdivisions or different names in the dataset. For example, "Harvard University, Biological Laboratories" and "Harvard University" are most likely one organization, and the first name should refer to the second.
*/
CREATE TABLE ORGANIZATIONS (
	ORGANIZATION_ID number(38) GENERATED AS IDENTITY, 
	ORGANIZATION_NAME varchar2(255) NOT NULL, 
	ORGANIZATION_COUNTRY_ID number(38) NOT NULL, 
	ORGANIZATION_CITY_ID number(38) NOT NULL, 
	PARENT_ORGANIZATION_ID number(38), 
	PRIMARY KEY (ORGANIZATION_ID)
);

ALTER TABLE ORGANIZATIONS ADD CONSTRAINT FKORGANIZATI570967 FOREIGN KEY (ORGANIZATION_CITY_ID) REFERENCES CITIES (CITY_ID);
ALTER TABLE ORGANIZATIONS ADD CONSTRAINT FKORGANIZATI976871 FOREIGN KEY (ORGANIZATION_COUNTRY_ID) REFERENCES COUNTRIES (COUNTRY_ID);
ALTER TABLE ORGANIZATIONS ADD CONSTRAINT FKORGANIZATI325887 FOREIGN KEY (PARENT_ORGANIZATION_ID) REFERENCES ORGANIZATIONS (ORGANIZATION_ID);

/* 
The PERSONS_IN_ORGANIZATIONS table links a laureates to the organizations they worked for.
The information is taken from the LAUREATE_PERSONS and ORGANIZATIONS DB tables.
Moved to a separate table, because the laureate could work in 2 or more organizations at the time of receiving the Prize.
Has links to tables:
	ORGANIZATIONS - the organization in which the laureate worked.
	LAUREATE_PERSONS - information about the laureate.
*/
CREATE TABLE PERSONS_IN_ORGANIZATIONS (
	PER_ORG_ID number(38) GENERATED AS IDENTITY, 
	LAUREATE_ID number(38) NOT NULL, 
	ORGANIZATION_ID number(38) NOT NULL, 
	PRIMARY KEY (PER_ORG_ID)
);

ALTER TABLE PERSONS_IN_ORGANIZATIONS ADD CONSTRAINT FKPERSONS_IN674603 FOREIGN KEY (ORGANIZATION_ID) REFERENCES ORGANIZATIONS (ORGANIZATION_ID);
ALTER TABLE PERSONS_IN_ORGANIZATIONS ADD CONSTRAINT FKPERSONS_IN137992 FOREIGN KEY (LAUREATE_ID) REFERENCES LAUREATE_PERSONS (LAUREATE_ID);

/* 
The NOBEL_PRIZES table contains information about the Nobel Prize.
The information is taken from the "Nobel Laureates" dataset (nobel.csv).
Has links to tables:
	LAUREATE_TYPES - laureate type, "Individual" or "Organization".
	CATEGORIES - category of the Prize, for example, "Peace" or "Physics".
	PRIZE_TYPES - name of the Prize, for example, "The Nobel Prize in Physics 2011".
	LAUREATE_PERSONS - Nobel laureate - person (for records with laureate type = "Individual").
	SOCIETIES - Nobel laureate - society (for records with laureate type = "Organization").	
*/
CREATE TABLE NOBEL_PRIZES (
	NOBEL_PRIZE_ID number(38) GENERATED AS IDENTITY, 
	YEAR number(38), 
	CATHEGORY_ID number(38) NOT NULL, 
	LAUREATE_ID number(38) NOT NULL, 
	LAUREATE_TYPE_ID number(38) NOT NULL, 
	PRIZE_TYPE_ID number(38) NOT NULL, 
	PRIZE_SHARE number(38, 12), 
	MOTIVATION varchar2(255), 
	PRIMARY KEY (NOBEL_PRIZE_ID)
);

ALTER TABLE NOBEL_PRIZES ADD CONSTRAINT FKNOBEL_PRIZ504992 FOREIGN KEY (LAUREATE_TYPE_ID) REFERENCES LAUREATE_TYPES (LAUREATE_TYPE_ID);
ALTER TABLE NOBEL_PRIZES ADD CONSTRAINT FKNOBEL_PRIZ4342 FOREIGN KEY (CATHEGORY_ID) REFERENCES CATEGORIES (CATEGORY_ID);
ALTER TABLE NOBEL_PRIZES ADD CONSTRAINT FKNOBEL_PRIZ244115 FOREIGN KEY (PRIZE_TYPE_ID) REFERENCES PRIZE_TYPES (PRIZE_TYPE_ID);
ALTER TABLE NOBEL_PRIZES ADD CONSTRAINT FKNOBEL_PRIZ84225 FOREIGN KEY (LAUREATE_ID) REFERENCES LAUREATE_PERSONS (LAUREATE_ID);
ALTER TABLE NOBEL_PRIZES ADD CONSTRAINT FKNOBEL_PRIZ378469 FOREIGN KEY (LAUREATE_ID) REFERENCES SOCIETIES (LAUREATE_ID);
