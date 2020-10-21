with rawdata as (
 select * from
    (select
 m1.measurement_id
,m1.operator_concept_id
,m1.value_as_number
,m1.value_as_concept_id
from @cdmSchema.measurement as m1
where not exists
(select * from (select stratum1
from @resultSchema.dq_check
where check_id = 'C64' and stratum1 not in (0)) as c1
where  m1.measurement_concept_id = c1.stratum1))v
 where operator_concept_id is null
and value_as_number is null
and value_as_concept_id is null    )
insert into @resultSchema.score_log_CDM
select
 'C65' as check_id
,24 as tb_id
,'measurement' as stratum1
,'operator_concept_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,measurement_id
from rawdata
union all
select
 'C65' as check_id
,24 as tb_id
,'measurement' as stratum1
,'value_as_number' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,measurement_id
from rawdata
union all
select
 'C65' as check_id
,24 as tb_id
,'measurement' as stratum1
,'value_as_concept_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,measurement_id
from rawdata ;
--
with observaiton_rawdata as(select
 28 as tb_id
,'observation' as stratum1
,observation_id as err_no
from @cdmSchema.observation
where value_As_number is null
and value_as_string is null
and value_as_concept_id is null
and qualifier_concept_id is null)
insert into @resultSchema.score_log_CDM
select
 'C265' as check_id
,tb_id
,stratum1
,'value_as_number' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,err_no
from observaiton_rawdata
union all
select
 'C265' as check_id
,tb_id
,stratum1
,'value_as_string' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,err_no
from observaiton_rawdata
union all
select
 'C265' as check_id
,tb_id
,stratum1
,'value_as_concept_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,err_no
from observaiton_rawdata
union all
select
 'C265' as check_id
,tb_id
,stratum1
,'qualifier_concept_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,err_no
from observaiton_rawdata ;
--
insert into @resultSchema.score_log_CDM
select
 'C266' as check_id
,24 as tb_id
,stratum1
,stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,measurement_id as err_no
from
(select
'measurement' as stratum1
,'unit' as stratum2
,unit_concept_id
,measurement_id
from @cdmSchema.measurement
where measurement_concept_id in
(select distinct stratum1 from @resultSchema.dq_check where check_id = 'C63'))v
where unit_concept_id is null
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,null as stratum3
,null as stratum4
,case
   when check_id = 'C65' then 'check the missing value of measurment result'
   when check_id = 'C265' then 'check the missing value of observation result'
   when check_id = 'C266' then 'check the missing value of measurment unit'
   else null
  end as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id in ('C65','C265','C266')
group by check_id, tb_id, stratum1


