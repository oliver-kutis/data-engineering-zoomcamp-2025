#!/bin/bash

# Define the Python script and the argument
PYTHON_SCRIPT="pipeline.py"

python $PYTHON_SCRIPT \
    --user=root \
    --password=root \
    --host=postgres \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --parquet_file_url=https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet \
    --parquet_file_name=yellow_tripdata_2021-01.parquet \
    --load_batch_size=300000