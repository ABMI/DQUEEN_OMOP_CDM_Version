--heatmap__regression1 (CDM Measurement : heatmap)
select
 m1.measurement_concept_id as concept_id
,c1.concept_name
,m1.count
from
(select
  measurement_concept_id
,count(*) as count
from @cdmSchema.measurement
where value_as_number is not null
and isnumeric(cast(value_as_number as int))= 1
group by measurement_concept_id )as m1
inner join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = m1.MEASUREMENT_concept_id;