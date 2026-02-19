import requests
import json
from datetime import datetime
from azure.storage.blob import BlobServiceClient
from config import (
    API_BASE_URL,
    API_TOKEN,
    AZURE_STORAGE_CONNECTION_STRING,
    BLOB_CONTAINER,
)


def fetch_product_usage(start_date: str, end_date: str):
    """
    Calls the product usage API for a given date range.
    """

    headers = {
        "Authorization": f"Bearer {API_TOKEN}",
        "Content-Type": "application/json"
    }

    params = {
        "start_date": start_date,
        "end_date": end_date
    }

    print(f"Calling API from {start_date} to {end_date}...")

    response = requests.get(API_BASE_URL, headers=headers, params=params)

    if response.status_code != 200:
        raise Exception(f"API call failed: {response.status_code} - {response.text}")

    return response.json()


def upload_to_blob(data: dict, start_date: str, end_date: str):
    """
    Upload raw JSON data to Azure Blob Storage.
    """

    blob_service_client = BlobServiceClient.from_connection_string(
        AZURE_STORAGE_CONNECTION_STRING
    )

    file_name = f"product_usage_{start_date}_{end_date}.json"

    blob_client = blob_service_client.get_blob_client(
        container=BLOB_CONTAINER,
        blob=file_name
    )

    blob_client.upload_blob(json.dumps(data), overwrite=True)

    print(f"Uploaded file: {file_name}")


def run_ingestion(start_date: str, end_date: str):
    """
    Main execution function.
    """

    try:
        data = fetch_product_usage(start_date, end_date)
        upload_to_blob(data, start_date, end_date)
        print("Ingestion completed successfully.")

    except Exception as e:
        print(f"Ingestion failed: {str(e)}")
        raise


if __name__ == "__main__":
    # Example execution
    run_ingestion("2026-01-01", "2026-01-07")