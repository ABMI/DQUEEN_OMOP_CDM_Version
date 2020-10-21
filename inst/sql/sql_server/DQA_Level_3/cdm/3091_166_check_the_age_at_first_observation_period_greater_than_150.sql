--
insert into @resultSchema.score_log_CDM
select
*
from
(select
 'C166' as check_id
,31 as tb_id
,'person' as stratum1
,'year_of_birth' as stratum2
,'observation_period' as stratum3
,'observation_start_date' as statum4
,(datepart(year,op1.observation_period_strat_date) - p1.year_of_birth)+1 as stratum5
,p1.person_id as err_no
from
(select
 person_id
,year_of_birth
from @cdmSchema.person) as p1
left join
(select
 person_id
,min(observation_period_start_date) as observation_period_strat_date
from @cdmSchema.observation_period
group by person_id) as op1
on p1.person_id=op1.person_id)v
where stratum5 > 149;
--
insert into @resultSchema.dq_check_result
select
 'C166' as check_id
,31 as stratum1
,'person' as stratum2
,'year_of_birth' as stratum3
,null as stratum4
,'age at first observation period should not be greater than 150' as stratum5
, count_val
,null as num_val
,null as txt_val
from
(select
  count(*) count_val
from @resultSchema.score_log_CDM
where check_id = 'C166')v
