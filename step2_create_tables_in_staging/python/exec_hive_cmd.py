# Run SQL command in hive
def exec_hive_cmd(sql):
    print("Executing Hive QL command:", sql, "...")
    cmdFile = open("/tmp/sql.txt","w")
    cmdFile.write("!connect  jdbc:hive2://***;\n")
    cmdFile.write(sql + ";")
    cmdFile.close()
    args = [
        'beeline',
        '-f',
        '/tmp/sql.txt'
    ]
    stdErr = open('hive_stderr.txt','w')
    stdOut = open('hive_stdout.txt','w')
    res = subprocess.run(args,stderr=stdErr,stdout=stdOut)
    stdOut.close()
    stdErr.close()
    if res.returncode!=0:
        raise(subprocess.SubprocessError("There were errors while hive-ing, check hive_stderr.txt"))
    print("Done")