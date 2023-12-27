from BCCancer.conn_manager.sql_conn import SqlserverConn
from BCCancer.conn_manager.postgres_conn import PostgresConn
from BCCancer.logger.pkglogging import get_log_obj
from urllib.error import HTTPError
import requests

logger = get_log_obj(__name__)
def get_messages(baseurl,from_date:str,to_date:str,auth_token:str, limit=None):
    headers = {
        'accept': 'application/json',
        'Authorization': f'Bearer {auth_token}'
    }
    params = {
        'from_date': from_date,
        'to_date': to_date,
    }
    if limit:
        params['limit']=limit

    response = requests.get(baseurl+"/messages", params=params, headers=headers)
    if response.status_code != 200:
        logger.error(response.json())
        raise HTTPError(response.status_code, response.json())

    return(response.json())


def save_data(url, filepath, auth_token):
    headers = {
        'accept': 'application/json',
        'Authorization': f'Bearer {auth_token}'
    }

    files = {'file': ('test.csv', open(filepath, 'rb'), 'text/csv')}

    response = requests.post(url+"/save_output", headers=headers, files=files)

    if response.status_code != 200:
        logger.error(response.json())
        raise HTTPError(response.status_code, response.json())

    print(response.json())

if __name__=='__main__':
    auth_token='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqb2huZG9lIiwicHJvZmlsZSI6IkFETUlOIiwiZXhwIjoxNzAzMDYzMzY2fQ.650901-Qorxd1dhqgpxLs311qrmWL39W12VnnDTy21Y'
    t=get_messages(r"http://127.0.0.1:8000",from_date="20220101",to_date="20230101",limit=10,auth_token=auth_token)
    print(t)