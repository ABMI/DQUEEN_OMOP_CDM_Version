-- Temporal
insert into @resultSchema.dq_check_result
select
 'C200' as check_id
,13 as stratum1
,'condition_occurrence' as stratum2
,condition_concept_id as stratum3
,condition_source_value  as stratum4
,'Condotion_concept_id porportion check with condition_source_value (compare with meta)' as stratum5
, count_val
,cast(cast(count_val as float)/(select cast(count(*) as float) from @cdmSchema.condition_occurrence) as float) as num_val
,null as txt_val
from
(select
 condition_concept_id
,condition_source_value
,count(*) as count_val
from @cdmSchema.condition_occurrence
group by  condition_concept_id,condition_source_value)v
