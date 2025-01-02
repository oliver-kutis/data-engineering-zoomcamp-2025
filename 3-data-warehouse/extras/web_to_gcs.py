import io
import os
import requests
import pandas as pd
from google.cloud import storage, bigquery

"""
Pre-reqs: 
1. `pip install pandas pyarrow google-cloud-storage`
2. Set GOOGLE_APPLICATION_CREDENTIALS to your project/service-account key
3. Set GCP_GCS_BUCKET as your bucket or change default value of BUCKET
"""
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "/Users/kutis/Documents/Github/data-engineering-zoomcamp-2025/1-docker-terraform/1_terraform_gcp/keys/credentials.json"

# services = ['fhv','green','yellow']
init_url = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/'
# switch out the bucketname
BUCKET = os.environ.get("GCP_GCS_BUCKET", "dtc-data-lake-bucketname")


def upload_to_gcs(bucket, object_name, local_file):
    """
    Ref: https://cloud.google.com/storage/docs/uploading-objects#storage-upload-object-python
    """
    # # WORKAROUND to prevent timeout for files > 6 MB on 800 kbps upload speed.
    # # (Ref: https://github.com/googleapis/python-storage/issues/74)
    # storage.blob._MAX_MULTIPART_SIZE = 5 * 1024 * 1024  # 5 MB
    # storage.blob._DEFAULT_CHUNKSIZE = 5 * 1024 * 1024  # 5 MB

    # storage
    client = storage.Client(project='data-engineering-zoomcamp-2025')
    bucket = client.bucket(bucket)
    blob = bucket.blob(object_name)
    blob.upload_from_filename(local_file)


def web_to_gcs(year, service):
    for i in range(12):

        # sets the month part of the file_name string
        month = '0'+str(i+1)
        month = month[-2:]

        # csv file_name
        file_name = f"{service}_tripdata_{year}-{month}.csv.gz"

        # download it using requests via a pandas df
        request_url = f"{init_url}{service}/{file_name}"
        r = requests.get(request_url)
        open(file_name, 'wb').write(r.content)
        print(f"Local: {file_name}")

        # read it back into a parquet file
        df = pd.read_csv(file_name, compression='gzip')
        file_name = file_name.replace('.csv.gz', '.parquet')
        df.to_parquet(file_name, engine='pyarrow')
        print(f"Parquet: {file_name}")

        # upload it to gcs
        upload_to_gcs(BUCKET, f"{service}/{file_name}", file_name)
        print(f"GCS: {service}/{file_name}")


def web_to_bq(year, service):
    dataset_id = 'nyc_tripdata'
    bq_client = bigquery.Client()
    year_df = pd.DataFrame()
    table_id = f"{service}_{year}"
    table_ref = bq_client.dataset(dataset_id).table(table_id)
    job_config = bigquery.LoadJobConfig()

    for i in range(12):
        # sets the month part of the file_name string
        month = '0'+str(i+1)
        month = month[-2:]

        # get the data with panda
        request_url = f"{init_url}{
            service}/{service}_tripdata_{year}-{month}.csv.gz"
        df = pd.read_csv(request_url, compression='gzip')
        year_df = pd.concat([year_df, df])

        print(f"Loaded: {service}_{year}-{month}.csv.gz")
        print(f"Total rows: {year_df.shape[0]}")

    # upload to bq
    print(f"Uploading to BQ: {table_id}")
    try:
        bq_client.get_table(table_ref)
        job_config.write_disposition = bigquery.WriteDisposition.WRITE_TRUNCATE
    except:
        # crate the table
        job_config.write_disposition = bigquery.WriteDisposition.WRITE_APPEND
        job_config.autodetect = True
        table = bigquery.Table(table_ref, )
        table = bq_client.create_table(table, )

        load_job = bq_client.load_table_from_dataframe(
            year_df, table_ref, job_config=job_config
        )
        print(f"Loaded {load_job.output_rows} rows into {table_id}")


# web_to_bq('2019', 'fhv')
web_to_gcs('2019', 'fhv')
# web_to_gcs('2019', 'green')
# web_to_gcs('2020', 'green')
# web_to_gcs('2019', 'yellow')
# web_to_gcs('2020', 'yellow')
