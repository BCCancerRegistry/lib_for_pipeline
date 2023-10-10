from conn_manager.sql_conn import SqlserverConn
from conn_manager.postgres_conn import PostgresConn
from logger.pkglogging import get_log_obj

def get_messages(db_type: str, server: str, database: str, username: str, password: str,port:int, source_table:str,col_list:list,date_column:str=None, date_to:str=None, date_from:str=None):
    if db_type == "sql-server":
        with SqlserverConn(server=server, database=database, username=username, password=password) as conn:
            data = conn.execute_sql(f"select {','.join(col_list)} from {source_table} where {date_column} between {date_to} and {date_from};")
    elif db_type == "postgres":
        with PostgresConn(server=server, database_name=database, username=username, password=password,port=port) as conn:
            data = conn.execute_sql(f"select {','.join(col_list)} from {source_table} where {date_column} between {date_to} and {date_from};")
    return data


