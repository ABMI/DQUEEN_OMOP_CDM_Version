insert into @resultSchema.dq_check_result
select
'C190' as check_id
,'visit_occurrence' as stratum1
,'condition_occurrence' as stratum2
,null as stratum3
,null as stratum4
,'inpatients should be have over 1 final diagnosis' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
v1.visit_occurrence_id
,c1.condition_status_concept_id
from
(select
 visit_occurrence_id
,visit_concept_id
,person_id
from @cdmSchema.visit_occurrence
where visit_concept_id in (9201,262))as v1
left join
(select
 condition_occurrence_id
,visit_occurrence_id
,condition_status_concept_id
,person_id
from @cdmSchema.condition_occurrence
where condition_status_concept_id = 4230359) as c1
on v1.visit_occurrence_id = c1.visit_occurrence_id
and v1.person_id = c1.person_id
where c1.condition_status_concept_id is null)v
