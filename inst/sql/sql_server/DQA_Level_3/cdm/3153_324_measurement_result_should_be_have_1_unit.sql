insert into @resultSchema.dq_check_result
select
 'C324' as check_id
,24 as stratum1
,'measurement' as stratum2
,'measurement_concept_id' as stratum3
,MEASUREMENT_concept_id as stratum4
,'measurment result value should be have 1 unit' as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 measurement_concept_id
,count(*) as count_val
from
(select
distinct
 measurement_concept_id
,unit_concept_id
from @cdmSchema.measurement
where unit_concept_id is not null)v
group by MEASUREMENT_concept_id)w
where count_val > 1 ;
