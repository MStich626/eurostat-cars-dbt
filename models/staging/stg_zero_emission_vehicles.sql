with source as (
    select * from {{ source('eurostat_raw', 'zero_emission_vehicles') }}
),

renamed as (
    select
        geo as country_code,
        cast(TIME_PERIOD as int64) as year,
        vehicle as vehicle_type,
        mot_nrg as energy_type_code,
        cast(OBS_VALUE as int64) as vehicles_count
    from source
    where OBS_VALUE is not null
)

select * from renamed