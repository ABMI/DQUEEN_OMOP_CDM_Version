-- female disease
insert into @resultSchema.score_log_cdm
select
 'C71' as check_id
,13 as tb_id
,'condition_occurrence' as stratum1
,'condition_concept_id' as stratum2
,p1.gender_concept_id as stratum3
,d1.condition_concept_id as stratum4
,null as stratum5
,d1.condition_occurrence_id as err_no
from
(select
 person_id
,condition_concept_id
,condition_occurrence_id
from @cdmSchema.condition_occurrence
 where condition_concept_id in
 (select stratum2 from @resultSchema.dq_check where check_id = 'C71')
and condition_concept_id not in (0)) as d1
inner join
(select
 person_id
,gender_concept_id
from @cdmSchema.person
where gender_concept_id = '8532') as p1
on p1.person_id = d1.person_id
--
insert into @resultSchema.dq_check_result
select
 s1.check_id
,s1.stratum1
,s1.stratum2
,s1.stratum3
,null as stratum4
,d1.check_desc as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id as stratum1
,stratum2
,stratum4 as stratum3
,count(*) as count_val
from @resultSchema.score_log_cdm
where check_id = 'C71'
group by check_id,tb_id,stratum2,stratum4) as s1
cross join
(select distinct check_desc from @resultSchema.dq_check
 where check_id = 'C71') as d1
