-- newborn measurement
insert into @resultSchema.score_log_CDM
select
 'C68' as check_id
,24 as tb_id
,'dev_measurement' as stratum1
,'examcd' as stratum2
,MEASUREMENT_id as stratum3
,age as stratum4
,null as stratum5
,MEASUREMENT_concept_id as err_no
from
(select
 m1.MEASUREMENT_id
,m1.person_id
,m1.MEASUREMENT_concept_id
,datediff(day,p1.birth_datetime,convert(varchar,m1.measurement_date,121)) as age
from
(select
 person_id
,MEASUREMENT_concept_id
,MEASUREMENT_id
,measurement_date
from
@cdmSchema.measurement
where measurement_concept_id in (select distinct stratum2 from @resultSchema.dq_check where check_id= 'C68'
 and stratum2 not in ('NULL') and stratum2 not in (0)) ) as m1
inner join
(select
 person_id
,birth_datetime
from @cdmSchema.person) as p1
on p1.person_id = m1.person_id)v
where age > 31
--
insert into @resultSchema.dq_check_result
select
*
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum3 as stratum3
,null as stratum4
,'this result value should be confirmed only newborn(1 month after)' as stratum5
from @resultSchema.score_log_cdm
where check_id = 'C68')v
group by check_id,stratum1,stratum2,stratum3,stratum4,stratum5