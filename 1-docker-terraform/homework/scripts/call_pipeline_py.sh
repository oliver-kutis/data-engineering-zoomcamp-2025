#!/bin/bash

# Define the Python script and the argument
PYTHON_SCRIPT="pipeline.py"

python $PYTHON_SCRIPT \
    --user=postgres \
    --password=postgres \
    --host=localhost \
    --port=5433 \
    --db=ny_taxi \
    --table_name=green_tripdata_2019_10 \
    --csv_file_url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz \
    --csv_file_name="../data/green_tripdata_2019-10.csv.gz" \
    --load_batch_size=300000

# python $PYTHON_SCRIPT \
#     --user=postgres \
#     --password=postgres \
#     --host=localhost \
#     --port=5433 \
#     --db=ny_taxi \
#     --table_name=taxi_zone_lookup \
#     --csv_file_url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv \
#     --csv_file_name="../data/taxi_zone_lookup.csv" \
#     --load_batch_size=300000