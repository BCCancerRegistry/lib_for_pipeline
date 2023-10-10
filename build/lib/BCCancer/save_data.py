import pandas as pd

from conn_manager.postgres_conn import PostgresConn
from conn_manager.sql_conn import SqlserverConn


def save_data(db_type: str, server: str, database: str, username: str, password: str, dest_table:str,data:pd.DataFrame,port:int):
    if db_type == "sql-server":
        with SqlserverConn(server=server, database=database, username=username, password=password) as conn:
            conn.insert_data(data=data,table_name=dest_table)
    elif db_type == "postgres":
        with PostgresConn(server=server, database_name=database, username=username, password=password,port=port) as conn:
            conn.insert_data(data=data,table=dest_table)

