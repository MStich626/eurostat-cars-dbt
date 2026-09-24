with population_staging as (
    select * from {{ ref('stg_population') }}
),

filtered_total as (
    select
        country_code,
        year,
        population_count as total_population
    from population_staging
    where sex = 'T'
      and age = 'TOTAL'
)

select * from filtered_total