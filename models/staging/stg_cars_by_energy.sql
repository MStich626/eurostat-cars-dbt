with source as (
    select * from {{ source('eurostat_raw', 'cars_by_energy_type') }}
),

renamed as (
    select
        geo as country_code,
        cast(TIME_PERIOD as int64) as year,
        mot_nrg as energy_type_code,
        Motor_energy as energy_type_name,
        cast(OBS_VALUE as int64) as cars_count
    from source
    where OBS_VALUE is not null
)

select * from renamed