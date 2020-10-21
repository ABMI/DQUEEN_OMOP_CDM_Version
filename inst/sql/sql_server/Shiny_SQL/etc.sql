--checkLevel
select distinct
 stratum1
,num_val as check_level
from @resultSchema.dq_check_result
where check_id = 'D1';

--dataQualityScore
select
s1.stage_gb
,case
when d1.DQ_score is null then 0
else d1.DQ_score
end as DQ_Score
from
(select
  distinct
  stage_gb
  from @resultSchema.schema_info) as s1
left join
(select
  stratum4 as stage_gb
  ,avg(cast(num_val as float)) as DQ_score
  from @resultSchema.dq_check_result
  where check_id = 'D2'
  group by stratum4) as d1
on d1.stage_gb = s1.stage_gb;

--dataStatus
select
stratum1
,stratum2 as stage_gb
,txt_val
from @resultSchema.dq_check_result
where check_id = 'D3';

--dataPopulation
select
stratum1
,stratum2 as stage_gb
,count_val
from @resultSchema.dq_check_result
where check_id = 'D4';

--dataPeriod
select
stratum1
,stratum2 as stdt
,stratum3 as endt
from @resultSchema.dq_check_result
where check_id = 'D5';

--dataVolume
select
stratum1
,stratum2
,num_val
,stratum3
from @resultSchema.dq_check_result
where check_id = 'D6';
