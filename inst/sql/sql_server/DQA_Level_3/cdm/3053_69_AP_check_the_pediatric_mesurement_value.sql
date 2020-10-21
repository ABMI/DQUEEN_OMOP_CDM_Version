insert into @resultSchema.score_log_cdm
select
'C69' as check_id
,24 as tb_id
,*
from
(select
 'measurement' as stratum1
,'measurement_concept_id' as stratum2
,m1.MEASUREMENT_concept_id as stratum3
,(datediff(month,p1.birth_datetime,m1.MEASUREMENT_date)/12) as stratum4
,null as stratum5
,m1.measurement_id as err_no
from
(select
 person_id
,MEASUREMENT_date
,MEASUREMENT_concept_id
,measurement_id
from
@cdmSchema.measurement
 where
measurement_concept_id in (select stratum2 from @resultSchema.dq_check
  where check_id = 'C69' and stratum2 not in (0,'null'))) as m1
left join
(select person_id, birth_datetime from @cdmSchema.person) as p1
on p1.person_id = m1.person_id )v
where stratum4 < 2 and stratum4  > 12
--
insert into @resultSchema.dq_check_result
select
 r1.check_id
,r1.stratum1
,r1.stratum2
,r1.stratum3
,r1.stratum4
,d1.check_desc as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id as stratum1
,stratum2
,stratum3
,stratum4
,count(*) as count_val
from @resultSchema.score_log_cdm
where check_id = 'C69'
group by check_id, tb_id, stratum2, stratum3, stratum4) as r1
cross join
(select * from @resultSchema.dq_check
 where check_id = 'C69') as d1
