insert into @resultSchema.score_log_CDM
select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,err_no
from
(select
 u1.check_id
,u1.tb_id
,m1.tbnm as stratum1
,m1.colnm as stratum2
,m1.measurement_concept_id as stratum3
,m1.unit_concept_id as stratum4
,u1.stratum2 as stratum5
,case
   when m1.unit_concept_id = u1.stratum2 then 'N'
   else 'Y'
 end as err_gb
,m1.measurement_id as err_no
from
(select
 'measurement' as tbnm
,'unit_concept_id' as colnm
,measurement_concept_id
,unit_concept_id
,measurement_id
from @cdmSchema.measurement
 where unit_concept_id is not null ) as m1
inner join
(select
 check_id
,24 as tb_id
,stratum1
,stratum2
from @resultSchema.dq_check
where check_id = 'C63'
and stratum2 not in (0) ) as u1
on u1.stratum1 = m1.MEASUREMENT_concept_id)v
where err_gb = 'Y'

insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum2 as stratum2
,stratum3 as stratum3
,stratum4 as stratum4
,'this measurement unit should be wrong (unit is differ from refrence unit) ' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C63'
group by check_id, tb_id,stratum2,stratum3,stratum4