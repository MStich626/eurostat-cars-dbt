import functions_framework
import requests
from google.cloud import storage

BUCKET_NAME = "cars-raw-data"

# Dictionary - file_name : URL
DATASETS = {
    "cars_by_energy_type.csv": "https://ec.europa.eu/eurostat/api/dissemination/sdmx/3.0/data/dataflow/ESTAT/road_eqr_carpda/1.0?compress=false&format=csvdata&formatVersion=2.0&lang=en&labels=name",
    "zero_emission_vehicles.csv": "https://ec.europa.eu/eurostat/api/dissemination/sdmx/3.0/data/dataflow/ESTAT/road_eqr_zev/1.0?compress=false&format=csvdata&formatVersion=2.0&lang=en&labels=name",
    # Usunięto &labels=name, aby uniknąć powielonych kolumn z etykietami
    "population_jan_1.csv": "https://ec.europa.eu/eurostat/api/dissemination/sdmx/3.0/data/dataflow/ESTAT/demo_pjan/1.0?compress=false&format=csvdata&formatVersion=2.0&lang=en"
}


@functions_framework.http
def download_cars_data_to_gcs(request):
    storage_client = storage.Client()
    bucket = storage_client.bucket(BUCKET_NAME)
    saved_files = []

    try:
        for file_name, url in DATASETS.items():
            # Download data from Eurostat
            response = requests.get(url)
            response.raise_for_status()
            csv_data = response.text

            # Overwriting latest files
            destination_blob_name = f"raw/latest/{file_name}"

            # Save to GCS
            blob = bucket.blob(destination_blob_name)
            blob.upload_from_string(csv_data, content_type='text/csv')

            saved_files.append(destination_blob_name)

        return f"Success! Overwritten {len(saved_files)} files in gs://{BUCKET_NAME}/: {', '.join(saved_files)}", 200

    except Exception as e:
        return f"Error while processing datasets: {str(e)}", 500