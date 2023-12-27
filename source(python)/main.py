from abc import ABC, abstractmethod
import mysql.connector
from pymongo import MongoClient

class DatabaseConnector(ABC):
    def __init__(self, **kwargs):
        pass

    @abstractmethod
    def connect(self):
        pass

    @abstractmethod
    def fetch_data(self, table_or_collection):
        pass

    @abstractmethod
    def close_connection(self):
        pass

class MySQLConnector(DatabaseConnector):
    def __init__(self, host, user, password, database):
        super().__init__()
        self.host = host
        self.user = user
        self.password = password
        self.database = database
        self.connection = None
        self.cursor = None

    def connect(self):
        try:
            self.connection = mysql.connector.connect(
                host=self.host,
                user=self.user,
                password=self.password,
                database=self.database
            )

            if self.connection.is_connected():
                print("Connected to MySQL database")
                self.cursor = self.connection.cursor()

        except mysql.connector.Error as e:
            print(f"Error: {e}")

    def fetch_data(self, table_name):
        if not self.connection or not self.connection.is_connected():
            print("Not connected to the database. Call connect() first.")
            return

        query = f"SELECT * FROM {table_name}"
        self.cursor.execute(query)
        rows = self.cursor.fetchall()
        return rows

    def close_connection(self):
        if self.cursor:
            self.cursor.close()
        if self.connection and self.connection.is_connected():
            self.connection.close()
            print("MySQL Connection closed")

class MongoDBConnector(DatabaseConnector):
    def __init__(self, host, port, database):
        super().__init__()
        self.host = host
        self.port = port
        self.database = database
        self.client = None
        self.db = None
    
    def connect(self):
        try:
            self.client = MongoClient(self.host, self.port)
            self.db = self.client[self.database]
            print("Connected to MongoDB server")

        except Exception as e:
            print(f"Error: {e}")

    def fetch_data(self, collection_name):
        if not self.client:
            print("Not connected to the database. Call connect() first.")
            return

        collection = self.db[collection_name]
        data = list(collection.find())
        return data

    def close_connection(self):
        if self.client:
            self.client.close()
            print("MongoDB Connection closed")

class DatabaseConnectorFactory:
    @staticmethod
    def create_connector(database_type, **kwargs):
        if database_type == 'mysql':
            return MySQLConnector(**kwargs)
        elif database_type == 'mongodb':
            return MongoDBConnector(**kwargs)
        else:
            raise ValueError(f"Unsupported database type: {database_type}")


if __name__ == "__main__":

    mysql_connector = DatabaseConnectorFactory.create_connector(
        database_type='mysql',
        host='localhost',
        user='hongson',
        password='Password@123',
        database='hrm'
    )

    mysql_connector.connect()
    mysql_data = mysql_connector.fetch_data('Role')
    print("MySQL Fetched data:", mysql_data)
    mysql_connector.close_connection()


    mongodb_connector = DatabaseConnectorFactory.create_connector(
        database_type='mongodb',
        host='localhost',
        port=27017,  # your MongoDB port
        database='test'
    )

    mongodb_connector.connect()
    mongodb_data = mongodb_connector.fetch_data('people')
    print("MongoDB Fetched data:", mongodb_data)
    mongodb_connector.close_connection()
