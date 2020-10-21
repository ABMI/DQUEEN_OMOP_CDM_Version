insert into @resultSchema.dq_check_result
select
 'C191' as check_id
,13 as stratum1
,'condition_occurrence' as stratum2
,'condition_start_date' as stratum3
,'condition_end_date' as stratum4
,'1 condition have period' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 condition_occurrence_id
,condition_start_date
,condition_end_date
,datediff(day,condition_start_date,condition_end_date) as diff_day
from @cdmSchema.condition_occurrence)v
where diff_day > 365