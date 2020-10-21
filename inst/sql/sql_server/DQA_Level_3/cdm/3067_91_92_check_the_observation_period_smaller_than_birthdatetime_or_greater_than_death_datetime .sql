with rawdata as (
select
 op1.observation_period_id
,case
  when p1.birth_datetime > op1.observation_period_start_date then 'birth_datetime > observation_period_start_date'
  else null
 end as op_stdt_check
,case
  when p1.birth_datetime > op1.observation_period_end_date then 'birth_datetime > observation_period_end_date'
  else null
 end as op_endt_check
from
(select
 person_id
,birth_datetime
from @cdmSchema.person) as p1
inner join
(select
 observation_period_id
,person_id
,observation_period_start_date
,observation_period_end_date
from
(select
 row_number()over(partition by person_id, observation_period_start_date, observation_period_end_date order by person_id ) as seq
,observation_period_id
,person_id
,observation_period_start_date
,observation_period_end_date
from @cdmSchema.observation_period)v
where seq = 1 ) as op1
on p1.person_id = op1.person_id)
--
insert into @resultSchema.score_log_cdm
select
 'C91' as check_id
,s1.tb_id
,op1.tbnm as stratum1
,op1.colnm as stratum2
,op1.stratum3
,null as stratum4
,null as stratum5
,op1.observation_period_id as err_no
from
(select
'observation_period' as tbnm
,'observation_period_start_date' as colnm
,'observation_period_start_date < birth_datetime' as stratum3
,observation_period_id
,op_stdt_check
from rawdata
where
op_stdt_check is not null
union all
select
 'dev_period' as tbnm
,'observation_period_end_date' as colnm
,'observation_period_end_date < birth_datetime' as stratum3
,observation_period_id
,op_endt_check
from rawdata
where
op_endt_check is not null) as op1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = op1.tbnm;
--
with rawdata as (
select
 op1.observation_period_id
,case
  when p1.death_date < op1.observation_period_start_date then 'death_date < op_observation_period_start_date'
  else null
 end as op_stdt_check
,case
  when p1.death_date < op1.observation_period_end_date then 'death_date < observation_period_end_date'
  else null
 end as op_endt_check
from
(select
 *
from
(select
 row_number()over(partition by person_id, death_date order by person_id) as seq
,person_id
,death_date
from @cdmSchema.death)v
where seq = 1) as p1
inner join
(select
observation_period_id
,person_id
,observation_period_start_date
,observation_period_end_date
from
(select
 row_number()over(partition by person_id, observation_period_start_date, observation_period_end_date order by person_id ) as seq
,observation_period_id
,person_id
,observation_period_start_date
,observation_period_end_date
from @cdmSchema.observation_period)v
where seq = 1 ) as op1
on p1.person_id = op1.person_id )
--
insert into @resultSchema.score_log_cdm
select
 'C92' as check_id
,s1.tb_id
,op1.tbnm as stratum1
,op1.colnm as stratum2
,op1.stratum3
,null as stratum4
,null as stratum5
,op1.observation_period_id as err_no
from
(select
'observation_period' as tbnm
,'observation_period_start_date' as colnm
,'death_date < op_observation_period_start_date' as stratum3
,observation_period_id
,op_stdt_check
from rawdata
where
op_stdt_check is not null
union all
select
 'observation_period' as tbnm
,'observation_period_end_date' as colnm
,'death_date < observation_period_end_date' as stratum3
,observation_period_id
,op_endt_check
from rawdata
where
op_endt_check is not null) as op1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = op1.tbnm;
--
insert into @resultSchema.dq_check_result
select
 check_id
,stratum1
,stratum2
,stratum3
,stratum4
,case
    when check_id = 'C91' then stratum2+' is smaller than birth datetime'
    when check_id = 'C92' then stratum2+' is greater than death datetime'
    else null
 end as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,stratum3 as stratum4
,count(*) as count_val
from @resultSchema.score_log_cdm
where check_id in ('C91','C92')
group by  check_id,tb_id,stratum1,stratum2,stratum3)v