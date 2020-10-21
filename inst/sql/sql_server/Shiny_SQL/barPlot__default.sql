--barPlot__default (CDM Provider : Proportion of foreginkey (provider))
select
stratum3 as cateogry
,stratum2 as stratum1
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where check_id = 'C35';