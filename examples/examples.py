import json
import os
import psycopg2

from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient
from azure.core.exceptions import HttpResponseError

from fastapi import FastAPI, HTTPException


app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/examples")
def read_examples():

    print("DATABASE_HOST", get_environment_variable("DATABASE_HOST"))
    print("DATABASE_PORT", get_environment_variable("DATABASE_PORT", "5432"))
    print("DATABASE_NAME", get_environment_variable("DATABASE_NAME"))
    print("DATABASE_USER", get_environment_variable("DATABASE_USER"))
    print("DATABASE_PASSWORD", get_environment_variable("DATABASE_PASSWORD"))

    # Check if the database is reachable

    try:
        conn = psycopg2.connect(
            host=get_environment_variable("DATABASE_HOST"),
            port=get_environment_variable("DATABASE_PORT", "5432"),
            database=get_environment_variable("DATABASE_NAME"),
            user=get_environment_variable("DATABASE_USER"),
            password=get_environment_variable("DATABASE_PASSWORD"),
            connect_timeout=1,
        )

        cur = conn.cursor()

        # print PostgreSQL Connection properties
        print(conn.get_dsn_parameters(), "\n")

        # print PostgreSQL all tables
        tables = cur.fetchall()
        print("Tables:", tables)

        cur.execute("SELECT * FROM examples")
        examples = cur.fetchall()
        return {"examples": examples}
    except psycopg2.OperationalError as error:
        raise HTTPException(status_code=500, detail=str(error))


def get_environment_variable(key, default=None):
    value = os.environ.get(key, default)

    if value is None:
        raise RuntimeError(f"{key} does not exist")

    return value


@app.get("/quotes")
def read_quotes():
    try:
        account_url = get_environment_variable("STORAGE_ACCOUNT_URL")
        default_credential = DefaultAzureCredential(process_timeout=2)
        blob_service_client = BlobServiceClient(account_url, credential=default_credential)

        container_client = blob_service_client.get_container_client(container="api")
        quotes = json.loads(container_client.download_blob("quotes.json").readall())
    except HttpResponseError as error:
        raise HTTPException(status_code=500, detail=str(error))

    return {"quotes": quotes}
