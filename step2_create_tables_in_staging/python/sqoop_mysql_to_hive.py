import os


# import table from mysql to hive
def sqoop_mysql_to_hive(tabName,dbName='default'):
    # run sqoop, connect 
    print("Importing", tabName, "table into database", dbName, "with sqoop import...")
    stdErr = open('sqoop_stderr.txt','w')
    stdOut = open('sqoop_stdout.txt','w')
    subprocess.run(["hdfs","dfs","-rm","-r","-f","-skipTrash",tabName],stderr=stdErr,stdout=stdOut) 
    os.environ['JAVA_HOME'] = "/usr"
    args = [
        '/usr/lib/sqoop/bin/sqoop',
        'import',
        '--connect', 'jdbc:mysql://***',
        '--username', '***',
        '--password', '***',
        '--hive-import',
        '-m', '1',
        '--table', tabName,
        '--hive-table', dbName+"."+tabName
    ]
    res = subprocess.run(args,stderr=stdErr,stdout=stdOut)
    stdOut.close()
    stdErr.close()
    if res.returncode!=0:
        raise(subprocess.SubprocessError("There were errors while sqooping, check sqoop_stderr.txt"))
    print("Done")