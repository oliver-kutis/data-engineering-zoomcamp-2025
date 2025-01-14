with _base as (
	select 
		distinct
		md5(concat(lpep_pickup_datetime, "VendorID", lpep_dropoff_datetime, "PULocationID", "DOLocationID", "trip_distance")) as trip_id,
		case
			when trip_distance <= 1 then 0
			when trip_distance > 1 and trip_distance <= 3 then 1
			when trip_distance > 3 and trip_distance <= 7 then 3
			when trip_distance > 7 and trip_distance <= 10 then 7
			when trip_distance > 10 then 10
			else 11
		end as trip_distance_bin,
		pu_zones."Zone" as pickup_zone,
		do_zones."Zone" as dropoff_zone,
		*
	from 
		green_tripdata_2019_10 as trips
	left join taxi_zone_lookup as pu_zones on trips."PULocationID" = pu_zones."LocationID"
	left join taxi_zone_lookup as do_zones on trips."DOLocationID" = do_zones."LocationID"
)

, q_3_distances_count as (
	select 
		trip_distance_bin,
		/* 
			Only works if data are not duplicated.
			Otherwise, we'd need to use count(distinct trip_id)
		*/
		count(trip_id) as count_trips 
	from 
		_base
	where
		lpep_pickup_datetime >= '2019-10-01' and lpep_dropoff_datetime < '2019-11-01'
	group by 
		trip_distance_bin
	order by trip_distance_bin
)
, q_4_top_days as (
	select 
		date_trunc('day', lpep_pickup_datetime) as lpep_pickup_date,
		max(trip_distance) as max_trip_distance
	from 
		_base
	group by 
		date_trunc('day', lpep_pickup_datetime)
	order by max_trip_distance desc
	limit 1
)
, q_5_top_3_pu_zones as (
select
	pickup_zone,
	sum(total_amount) as total_amount
from 
	_base
where 
	date_trunc('day', lpep_pickup_datetime) = '2019-10-18'
group by 
	pickup_zone
having 
	sum(total_amount) > 13000
order by 
	sum(total_amount) desc
limit 3
)
, q_6_largest_tip as (
	select 
		dropoff_zone,
		max(tip_amount) as max_tip
	from _base
	where lpep_dropoff_datetime >= '2019-10-01' and lpep_dropoff_datetime < '2019-11-01'
		and pickup_zone = 'East Harlem North'
	group by dropoff_zone
	order by max_tip desc 
	limit 1
)

-- select * from q_3_distances_count;
-- select * from q_4_top_days;
-- select * from q_5_top_3_pu_zones;
-- select * from q_6_largest_tip;