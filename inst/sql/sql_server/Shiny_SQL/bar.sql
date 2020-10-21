--bar1 (Summary : divide sex)
select
 'Source' as stage
,'M' as stratum1
, 0 as count_val
union all
select
'Source' as stage_gb
,'F' as stratum1
, 0 as count_val
union all
select
stratum2 as stage_gb
,stratum5 as stratum1
,count_val as count_val
from @resultSchema.dq_check_result
where check_id = 'D10';

--bar2 (Meta Person  : Person count)
select
 'Source' as stage
,'M' as stratum1
, 0 as count_val
union all
select
'Source' as stage_gb
,'F' as stratum1
, 0 as count_val
union all
select
stratum2 as stage_gb
,stratum5 as stratum1
,count_val as count_val
from @resultSchema.dq_check_result
where check_id = 'D10';

--bar3 (CDM Person : Person count)
select
 stratum5 as stage
,'Y' as stratum1
,count_val as count_val
from @resultSchema.dq_check_result
where check_id = 'D10' and stratum2 ='CDM'
union all
select 'M' as stage, 'N' as stratum1, 0 as count_val
union all
select 'F' as stage, 'N' as stratum1, 0 as count_val;

--bar4 (CDM Provider : count of provider (Gender_concept_id))
select
 stratum5 as stage
,'Y' as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D13' and stratum1 ='CDM'
union all
select 'M' as stage, 'N' as stratum1, 0 as count_val
union all
select 'F' as stage, 'N' as stratum1, 0 as count_val;
