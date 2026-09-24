with cars as (
    select
        country_code,
        year,
        sum(cars_count) as total_cars_count,
        sum(zero_emission_cars_count) as total_zero_emission_cars_count
    from {{ ref('int_cars_joined') }}
    group by country_code, year
),

population as (
    select
        country_code,
        year,
        total_population
    from {{ ref('int_population_aggregated') }}
),

final as (
    select
        c.country_code,
        c.year,
        c.total_cars_count,
        c.total_zero_emission_cars_count,
        p.total_population,

        -- Wskaźnik 1: Liczba samochodów na 1000 mieszkańców
        case
            when p.total_population > 0
            then round((c.total_cars_count / p.total_population) * 1000, 2)
            else null
        end as cars_per_1000_capita,

        -- Wskaźnik 2: Procentowy udział pojazdów bezemisyjnych we flocie (%)
        case
            when c.total_cars_count > 0
            then round((c.total_zero_emission_cars_count / c.total_cars_count) * 100, 2)
            else 0
        end as zero_emission_share_pct

    from cars c
    inner join population p
        on c.country_code = p.country_code
        and c.year = p.year
)

select * from final