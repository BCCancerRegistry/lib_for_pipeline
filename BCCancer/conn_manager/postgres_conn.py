from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


class PostgresConn:
    def __init__(self, username, password, host, port, database_name):
        # Define the database URL for SQLAlchemy
        db_url = f"postgresql://{username}:{password}@{host}:{port}/{database_name}"
        
        # Create a database engine
        self.engine = create_engine(db_url)

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

    def execute_sql(self, sql):
        try:
            # Execute the provided SQL statement
            result = self.session.execute(sql)
            self.session.commit()  # Commit the transaction
            return result
        except Exception as e:
            self.session.rollback()  # Rollback the transaction in case of an error
            print(f"Error executing SQL statement: {str(e)}")
            raise e

    def insert_data(self, data, table):
        data.to_sql(name=table, con=self.engine, if_exists='fail', index=False)

    def insert_row(self, row:dict, table:str):
        self.engine.
        cursor.execute(
            """
            INSERT INTO batch (pipeline_name, date_to, date_from, comment)
            VALUES (%s, %s, %s, %s)
            RETURNING batch_id;
            """,
            (pipeline_name, date_to, date_from, comment),
        )

        # Get the generated batch_id
        generated_batch_id = cursor.fetchone()[0]
        print(f"Generated batch_id: {generated_batch_id}")

        # Commit the transaction
        conn.commit()

    def __enter__(self):
        self.connect()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.disconnect()

