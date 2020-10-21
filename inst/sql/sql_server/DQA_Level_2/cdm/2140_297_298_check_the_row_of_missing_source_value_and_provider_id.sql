--
insert into @resultSchema.dq_check_result
select
 'C297' as check_id
,32 as stratum1
,'procedure_occurrence.procedure_concept_id' as stratum2
,'procedure_occurrence.procedure_source_value' as stratum3
,procedure_concept_id as stratum4
,'procedure_source_value should be not null' as stratum5
, count(*) as count_val
,null as num_val
,null as txt_val
from
 @cdmSchema.procedure_occurrence
where procedure_source_value is null
group by procedure_concept_id ;
--
insert into @resultSchema.dq_check_result
select
 'C298' as check_id
,32 as stratum1
,'procedure_occurrence.procedure_concept_id' as stratum2
,'procedure_occurrence.provider_id' as stratum3
,procedure_concept_id as stratum4
,'procedure_source_value should be not null' as stratum5
, count(*) as count_val
,null as num_val
,null as txt_val
from
 @cdmSchema.procedure_occurrence
where provider_id is null
group by procedure_concept_id;
--