FROM python:3.12.1

RUN apt-get update && apt-get install -y wget
# fastparquet - was required for reading parquet files in pandas
# jupyter notebook ipykernel - may be required to run jupyter notebooks
# psycopg2-binary - required to connect to postgres (otherwise it will throw error)
RUN pip install pandas sqlalchemy psycopg2 

WORKDIR /app
COPY ingest_data.py ingest_data.py

ENTRYPOINT ["python", "ingest_data.py"]