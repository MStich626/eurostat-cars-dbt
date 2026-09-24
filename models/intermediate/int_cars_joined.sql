with cars_by_energy_staging as (
    select * from {{ ref('stg_cars_by_energy') }}
),

cars_zero_emission_staging as (
    select * from {{ ref('stg_zero_emission_vehicles') }}
),

cars_joined as (
    select
        c.country_code,
        c.year,
        c.energy_type_code,
        c.cars_count,
        coalesce(z.vehicles_count, 0) as zero_emission_cars_count
    from cars_by_energy_staging c
    left join cars_zero_emission_staging z
        on c.country_code = z.country_code
        and c.year = z.year
        and c.energy_type_code = z.energy_type_code
)

select * from cars_joined