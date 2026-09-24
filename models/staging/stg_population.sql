with source as (
    select * from {{ source('eurostat_raw', 'population_jan_1') }}
),

renamed as (
    select
        geo as country_code,
        cast(TIME_PERIOD as int64) as year,
        sex,
        age,
        cast(OBS_VALUE as int64) as population_count
    from source
    where OBS_VALUE is not null
)

select * from renamed