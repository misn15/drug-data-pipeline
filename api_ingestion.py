import requests
import os
from dotenv import load_dotenv
from pathlib import Path
import psycopg

PRODUCT_COLUMNS = [
    "product_id",
    "product_ndc",
    "generic_name",
    "labeler_name",
    "brand_name",
    "brand_name_base",
    "finished",
    "listing_expiration_date",
    "marketing_category",
    "dosage_form",
    "spl_id",
    "product_type",
    "marketing_start_date",
    "application_number",
]

def connection_string():
    return psycopg.connect(
        user=os.environ.get("DB_USER"),
        password=os.environ.get("DB_PASSWORD"),
        host=os.environ.get("DB_HOST"),
        port=os.environ.get("DB_PORT"),
        dbname=os.environ.get("DB_NAME")
    )

def load_env():
    load_dotenv(Path(__file__).resolve().parent / ".env")

def fetch_data_from_ndc_api(api_url, limit=5):
    """
    Fetch data from the FDA NDC API endpoint.

    Args:
        api_url (str): The URL of the API endpoint.
    """

    try:
        response = requests.get(api_url, params={"limit": limit})
        response.raise_for_status()  # Raise an error for bad responses (4xx or 5xx)
        data = response.json()  # Parse the JSON response
        return data
    except requests.exceptions.RequestException as e:
        print(f"An error occurred while fetching data from the API: {e}")
        return None

def connect():
    with connection_string() as conn:
        yield conn

def load_raw_data(api_url, conn: psycopg.Connection):
    data = fetch_data_from_ndc_api(api_url)
    rows = transform_products(data)

    with conn.cursor() as cur:
        cur.executemany("""
            INSERT INTO raw.raw_ndc_product(product_id, product_ndc, generic_name, labeler_name, brand_name, brand_name_base, finished, listing_expiration_date, marketing_category, dosage_form, spl_id, product_type, marketing_start_date, application_number) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT DO NOTHING
        """,
                (rows)
            )

def transform_products(data):
    return [
        tuple(drug.get(column) for column in PRODUCT_COLUMNS)
        for drug in data["results"]
    ]

def main():
    load_env()
    api_url = "https://api.fda.gov/drug/ndc.json"
    with connection_string() as conn:
        load_raw_data(api_url, conn)
    print("done")


if __name__ == "__main__":
    main()