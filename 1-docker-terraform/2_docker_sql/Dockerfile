FROM python:3.12.1

RUN apt-get update && apt-get install -y wget
# fastparquet - was required for reading parquet files in pandas
# jupyter notebook ipykernel - may be required to run jupyter notebooks
# psycopg2-binary - required to connect to postgres (otherwise it will throw error)
RUN pip install --upgrade pip
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install pandas sqlalchemy psycopg2-binary fastparquet jupyter

WORKDIR /app
COPY scripts/pipeline.py pipeline.py 

ENTRYPOINT ["python", "pipeline.py"]

# ***** Build and run the container *****
# docker build -t taxi_ingest_data:v001 .
# docker run -it \
#     --network=pg-network \
#     taxi_ingest_data:v001 \ 
#     --user=root \
#     --password=root \
#     --host=postgres \
#     --port=5432 \
#     --db=ny_taxi \
#     --table_name=yellow_taxi_trips \
#     --parquet_file_url=https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet \
#     --parquet_file_name=yellow_tripdata_2021-01.parquet \
#     --load_batch_size=300000

# ***** Alternative: Run the bash script and not the python script *****
# COPY scripts/call_pipeline_py.sh call_pipeline_py.sh
# Make the script executable
# RUN chmod +x call_pipeline_py.sh
# ENTRYPOINT ["./call_pipeline_py.sh"]

## The container would be ran with the following command
# docker run --name taxi_ingest_data_bash -it \
#   --network=pg-network \
#   taxi_ingest_data:v002 