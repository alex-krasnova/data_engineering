import os
import json
import pandas as pd


# Convert a json file of format {key:val, key:val,...} to a csv file, save the file in the HDFS directory
# This function is used for converting JSON files from the 'data' directory to CSV format for creating tables in Hive
def convert_csv_to_json_file(filename,column1,column2,destDir):
    path = os.path.join('/home/deng/Data',filename)
    
    with open(path, 'r') as f:
        data = json.load(f)

    df = pd.DataFrame.from_dict(data, orient='index')
    df.reset_index(inplace=True)
    df.columns=[column1,column2]
    
    filename_upd = '/tmp/db/' + destDir + '.csv'
    df.to_csv(filename_upd, sep=',', index=False)
        
    os.environ['JAVA_HOME'] = "/usr"
    args = [
        'hdfs',
        'dfs',
        '-put',
        filename_upd,
        '/akrasnova/'+destDir
    ]
    stdErr = open('json_stderr.txt','w')
    stdOut = open('json_stdout.txt','w')
    res = subprocess.run(args,stderr=stdErr,stdout=stdOut)
    stdOut.close()
    stdErr.close()
    if res.returncode!=0:
        raise(subprocess.SubprocessError("There were errors while hive-ing, check json_stderr.txt"))
    print("Done")

# Convert a json file of format {key:val, key:val,...) to format [{column1:key,column2:value}, {column1:key,column2:value},...], 
# save the file in the HDFS directory
def convert_json_file(filename,column1,column2,destDir):
    path = os.path.join('/home/deng/Data',filename)
    
    with open(path, 'r') as f:
        data = json.load(f)

    df = pd.DataFrame.from_dict(data, orient='index')
    df.reset_index(inplace=True)
    df.columns=[column1,column2]
    
    data_upd = df.to_json(orient = 'records')[1:-1].replace('},{', '}\n{')
    #print(data_upd)
    
    filename_upd = '/tmp/akrasnova/upd_' + filename
    with open(filename_upd, "w") as outfile:
        outfile.write(data_upd)
        
    os.environ['JAVA_HOME'] = "/usr"
    args = [
        'hdfs',
        'dfs',
        '-put',
        filename_upd,
        '/akrasnova/'+destDir
    ]
    stdErr = open('json_stderr.txt','w')
    stdOut = open('json_stdout.txt','w')
    res = subprocess.run(args,stderr=stdErr,stdout=stdOut)
    stdOut.close()
    stdErr.close()
    if res.returncode!=0:
        raise(subprocess.SubprocessError("There were errors while hive-ing, check json_stderr.txt"))
    print("Done")