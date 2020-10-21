--rader
select 0 as atemporal, 0 as accuracy, 0 as completness, 0 as value, 0 as relation, 0 as uniqueness
union all
SELECT [atemporal], [accuracy], [completeness], [value], [relation], [uniqueness]
FROM (
SELECT stratum3, case when round(num_val,0) is null then 0 else round(num_val,0) end as num_val
FROM @resultSchema.dq_check_result
where check_id = 'D7' and stratum2 = 'CDM' ) AS A
PIVOT (
MIN(num_val)
FOR stratum3 IN ([atemporal], [accuracy], [completeness], [value], [relation], [uniqueness]) ) A;