# Create an external table in Hive from CSV files
def create_ext_table_csv(dbName,tableName,columns,origFileName,location):
    sql = 'create external table ' + dbName + '.' + tableName + '_ext (' + columns + ')\n'
    sql = sql + 'comment \'' + origFileName + ' table - for data in CSV file ' + origFileName + '\'\n'
    sql = sql + 'row format serde \'org.apache.hadoop.hive.serde2.OpenCSVSerde\'\n'
    # sql = sql + 'with serdeproperties ("separatorChar" = ",", "quoteChar" = "\"")
    sql = sql + 'stored as textfile\n'
    sql = sql + 'location \'/' + location + '/' + tableName + '\'\n'
    sql = sql + 'tblproperties (\'skip.header.line.count\'=\'1\')'
    exec_hive_cmd(sql)

# Create an external table in Hive from JSON files
def create_ext_table(dbName,tableName,columns,origFileName,location):
    sql = 'create external table ' + dbName + '.' + tableName + '_ext (' + columns + ')\n'
    sql = sql + 'comment \'' + origFileName + ' table - for data in JSON file ' + origFileName + '\'\n'
    sql = sql + 'row format serde \'org.apache.hive.hcatalog.data.JsonSerDe\'\n'
    sql = sql + 'stored as textfile\n'
    sql = sql + 'location \'/' + location + '/' + tableName + '\''
    exec_hive_cmd(sql)
    
# Create a managed table in Hive from an external Hive table
def create_managed_table(dbName,tableName):
    sql = 'create table ' + dbName + '.' + tableName + ' stored as orc as select * from ' + dbName + '.' + tableName + '_ext'
    exec_hive_cmd(sql)

# Drop an external Hive table
def drop_external_table(dbName,tableName):
    sql = 'drop table ' + dbName + '.' + tableName + '_ext'
    exec_hive_cmd(sql)