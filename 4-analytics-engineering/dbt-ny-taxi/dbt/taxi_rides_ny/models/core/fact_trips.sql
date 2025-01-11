{{ config(materialized="table") }}

with
    green_tripdata as (
        select *, 'Green' as service_type from {{ ref("sgt_green_tripdata") }}
    ),
    yellow_tripdata as (
        select *, 'Yellow' as service_type from {{ ref("sgt_yellow_tripdata") }}
    ),
    trips_union as (
        select *
        from green_tripdata
        union all
        select *
        from yellow_tripdata
    ),
    dim_zones as (select * from {{ ref("dim_zones") }} where borough != 'Unknown')

select
    trips_union.tripid,
    trips_union.vendorid,
    trips_union.service_type,
    trips_union.ratecodeid,
    trips_union.pickup_locationid,
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    trips_union.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,
    trips_union.pickup_datetime,
    trips_union.dropoff_datetime,
    trips_union.store_and_fwd_flag,
    trips_union.passenger_count,
    trips_union.trip_distance,
    trips_union.trip_type,
    trips_union.fare_amount,
    trips_union.extra,
    trips_union.mta_tax,
    trips_union.tip_amount,
    trips_union.tolls_amount,
    trips_union.ehail_fee,
    trips_union.improvement_surcharge,
    trips_union.total_amount,
    trips_union.payment_type,
    trips_union.payment_type_description
from trips_union
inner join
    dim_zones as pickup_zone on trips_union.pickup_locationid = pickup_zone.locationid
inner join
    dim_zones as dropoff_zone
    on trips_union.dropoff_locationid = dropoff_zone.locationid
