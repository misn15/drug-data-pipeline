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
    "application_number"
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
    prod = transform_products(data)
    ingred = transform_active_ingredients(data)
    pharm_class = transform_pharm_class(data)
    

    with conn.cursor() as cur:
        cur.executemany("""
            INSERT INTO raw.raw_ndc_product(product_id, product_ndc, generic_name, labeler_name, brand_name, brand_name_base, finished, listing_expiration_date, marketing_category, dosage_form, spl_id, product_type, marketing_start_date, application_number) 
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        ON CONFLICT DO NOTHING
        """,
                (prod)
            )
        
        cur.executemany("""
            INSERT INTO raw.raw_ndc_active_ingredient(product_id, product_ndc, ingredient, strength) 
            VALUES (%s, %s, %s, %s)
                        ON CONFLICT DO NOTHING
        """,
                (ingred)
            )
        
        cur.executemany("""
            INSERT INTO raw.raw_ndc_pharm_class(product_id, product_ndc, pharm_class) 
            VALUES (%s, %s, %s)
                        ON CONFLICT DO NOTHING
        """,
                (pharm_class)
            )

def transform_products(data):
    return [
        tuple(drug.get(column) for column in PRODUCT_COLUMNS)
        for drug in data["results"]
    ]

def transform_active_ingredients(data):
    return [
        (
            drug.get("product_id"),
            drug.get("product_ndc"),
            ingredient.get("name"),
            ingredient.get("strength")
        )
        for drug in data["results"]
        for ingredient in drug.get("active_ingredients", [])
    ]

def transform_pharm_class(data):
    return [
        (
            drug.get("product_id"),
            drug.get("product_ndc"),
            pharm_class
        )
        for drug in data["results"]
        for pharm_class in drug.get("pharm_class", [])
    ]


def main():
    load_env()
    api_url = "https://api.fda.gov/drug/ndc.json"
    with connection_string() as conn:
        load_raw_data(api_url, conn)
    print("done")


if __name__ == "__main__":
    main()