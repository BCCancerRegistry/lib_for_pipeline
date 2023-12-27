"""import pyodbc
cnxn_str = ("Driver={ODBC Driver 17 for SQL Server};"
                "Server=spdbsonc001;"
                "Database=OncoLog_Transform;"
                "Trusted_Connection=yes;")


conn = pyodbc.connect("DSN='EMarc_dev'")



"""
import pandas as pd
import pyodbc
class SqlserverConn:
    def __init__(self, server: str, database: str, username: str = None, password: str = None):
        self.connection_string = 'DRIVER={ODBC Driver 17 for SQL Server};' + f"Server={server};Database={database};UID={username};PWD={password};Trusted_Connection=yes;"
        print(self.connection_string)
        self.conn = None
        self.connect()


    def connect(self):
        if not self.conn:
            self.conn = pyodbc.connect(self.connection_string)

    def get_connection(self):
        self.connect()
        return self.conn

    def execute_sql(self,sql):


        data = pd.read_sql(sql, self.conn )
        return data

    def insert_data(self, data: pd.DataFrame, table_name: str):
        data.to_sql(name=table_name, con=self.conn, if_exists='fail', index=False)

    def close(self):
        print("Closing connection")
        if self.conn:
            self.conn.close()
            self.conn = None

    def __enter__(self):
        self.connect()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.close()


# Example usage:
if __name__ == "__main__":
    #connection_string = ("DSN=Emarc_dev")
    # Create a connection object
    #conn = Connection_manager(connection_string)
    with SqlserverConn(server="sddbsmarc001",database="eMaRCPlus_v60Patch") as test:
        data = test.execute_sql("SELECT * FROM HL7MESSAGES")
        print(data.columns)


# Connection is automatically closed when exiting the 'with' block


