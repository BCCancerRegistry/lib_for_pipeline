from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from BCCancer.logger.pkglogging import get_log_obj
import pandas as pd

logger=get_log_obj()
class PostgresConn:
    def __init__(self, username, password, host, port, database_name, echo=False):
        # Define the database URL for SQLAlchemy
        db_url = f"postgresql://{username}:{password}@{host}:{port}/{database_name}"
        
        # Create a database engine
        self.engine = create_engine(db_url, echo=echo)

        # Create a session factory
        session = sessionmaker(bind=self.engine)
        self.session = session()

    def connect(self):
        try:
            # Attempt to establish a database connection
            self.engine.connect()
            print("Connected to the database")
        except Exception as e:
            print(f"Error connecting to the database: {str(e)}")

    def disconnect(self):
        try:
            # Close the session and disconnect from the database
            self.session.close()
            self.engine.dispose()
            print("Disconnected from the database")
        except Exception as e:
            print(f"Error disconnecting from the database: {str(e)}")

    def execute_sql(self, sql: str):
        try:
            # Execute the provided SQL statement
            sql = text(sql)
            result = self.session.execute(sql)
            self.session.commit()  # Commit the transaction
            return result
        except Exception as e:
            self.session.rollback()  # Rollback the transaction in case of an error
            print(f"Error executing SQL statement: {str(e)}")
            raise e

    def get_data(self, sql: str, columns: [None, list] = None):
        output = self.execute_sql(sql)
        output = pd.DataFrame.from_records(output.fetchall(), columns=columns)
        return output

    def insert_data(self, data, table, schema='public'):
        data.to_sql(name=table, schema=schema, con=self.engine, if_exists='append', index=False)


    def insert_row(self, table_name: str, column_values: dict):

        try:
            # Use the class object variable session
            session = self.session
            sql = f"INSERT INTO {table_name} ({', '.join(column_values.keys())}) VALUES ({', '.join([':' + col for col in column_values.keys()])}) RETURNING *;"
            logger.info(sql)
            print(sql)
            # Generate the SQL query
            insert_query = text(
                sql
            )

            # Execute the SQL query using the session
            result = session.execute(insert_query, column_values)

            # Commit the transaction
            session.commit()

            # Return the inserted record as a dictionary
            inserted_record = result.fetchone()
            return dict(inserted_record)

        except Exception as e:
            print(f"Error: {e}")
            raise e

    def __enter__(self):
        self.connect()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.session.close()
        self.disconnect()