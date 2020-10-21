insert into @resultSchema.score_log_meta
select
 'C67' as check_id
,24 as tb_id
,'measurement' as stratum1
,m1.MEASUREMENT_concept_id as stratum2
,p1.gender_concept_id as stratum3
,null as stratum4
,null as stratum5
,m1.measurement_id as err_no
from
(select
 person_id
,MEASUREMENT_concept_id
,measurement_id
from @cdmSchema.measurement
 where measurement_concept_id in (select stratum2
  from @resultSchema.dq_check
  where check_id = 'C67' and stratum2 not in (0))
) as m1
inner join
(select
 person_id
,gender_concept_id
from @cdmSchema.person
where gender_concept_id = '8532' ) as p1
on p1.person_id = m1.person_id
--
insert into @resultSchema.dq_check_result
select
 r1.check_id
,r1.stratum1
,r1.stratum2
,r1.stratum3
,null as stratum4
,d1.check_desc as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,count(*) as count_val
from @resultSchema.score_log_meta
where check_id = 'C67'
group by  check_id , tb_id, stratum1, stratum2, stratum3)as r1
cross join
(select distinct check_desc from @resultSchema.dq_check where check_id = 'C67') as d1
