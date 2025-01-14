import os
import argparse
from time import time
import pandas as pd
from sqlalchemy import create_engine


def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = int(params.port)
    db = params.db
    table_name = params.table_name
    csv_file_url = params.csv_file_url
    csv_file_name = params.csv_file_name
    batch_size = int(params.load_batch_size)

    # Get the parquet file and save it locally
    os.system(f'wget -O {csv_file_name} {csv_file_url}')
    print("---- Download complete")

    # Create a connection to the postgres DB
    engine = create_engine(
        f'postgresql://{user}:{password}@{host}:{port}/{db}')

    # read parquet file
    if csv_file_name.endswith('.gz'):
        df = pd.read_csv(csv_file_name, encoding='utf-8',
                         compression='gzip', low_memory=False)
    else:
        df = pd.read_csv(csv_file_name, encoding='utf-8', low_memory=False)

    for col in ['lpep_pickup_datetime', 'lpep_dropoff_datetime']:
        if col in df.columns:
            df[col] = pd.to_datetime(df[col])

    # Create schema for the table
    df.head(0).to_sql(table_name, con=engine,
                      index=False, if_exists='replace')

    # Load the data into postgres db table in batches
    print(f'---- Loading data in batches of {batch_size} rows')
    print(f'---- Total rows to load: {len(df)}')
    for i in range(0, len(df), batch_size):
        t_start = time()
        # insert the chunk
        df.iloc[i:i+batch_size].to_sql(table_name,
                                       con=engine, index=False, if_exists='append')

        t_end = time()
        print(f'Inserted {min(i+batch_size, len(df))
                          } rows in {round(t_end - t_start, 3)} seconds')

    print("---- Data load complete")


if __name__ == '__main__':
    # Add arguments to the script
    # postgres DB args
    parser = argparse.ArgumentParser()
    parser.add_argument('--user', help='User for the postgres DB')
    parser.add_argument('--password', help='Password for the postgres DB')
    parser.add_argument('--host', help='Host for the postgres DB')
    parser.add_argument('--port', help='Port for the postgres DB')
    parser.add_argument('--db', help='Database name for the postgres DB')
    parser.add_argument('--table_name', help='Table name for the postgres DB')
    # parquet file args
    parser.add_argument('--csv_file_url', help='CSV file to read')
    parser.add_argument('--csv_file_name', help='CSV file name')
    # load args
    parser.add_argument('--load_batch_size',
                        help='# rows in postgres db load batch')

    args = parser.parse_args()

    # display arguments and values
    print("---- Arguments ----")
    for arg in vars(args):
        print(f'{arg}: {getattr(args, arg)}')

    main(args)
