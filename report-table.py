import os
import json
import pandas as pd

result_json = os.environ.get('RESULT_JSON')

def generate_table():
    with open('result_json', 'r') as arquivo_json:
        data = json.load(arquivo_json)
        df = pd.Dataframe(data)
        print (df)
        return df
    
generate_table()