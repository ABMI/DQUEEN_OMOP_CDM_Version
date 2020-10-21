--linechart__click1 (CDM Mesurement : DQ error message box)
select
 d1.stratum3 as measurement_concept_id
,c1.concept_name as measurement_concept_name
,d1.min as min_measurement_count
,d1.max as max_measurement_count
,d1.avg as average_measurement_count
,d1.stdev as standard_deviation_measurement_count
,d1.median as median_measurement_count
,d1.p_10 as p10_measurement_count
,d1.p_25 as p25_measurement_count
,d1.p_75 as p75_measurement_count
,d1.p_90 as p90_measurement_count
from
(select distinct
stratum2
,stratum3
,min
,max
,avg
,stdev
,median
,p_10
,p_25
,p_75
,p_90
from @resultSchema.dq_result_statics
where check_id = 'C330') as d1
inner join
(select
concept_id
,concept_name
from @cdmSchema.concept) as c1
on d1.stratum3 = c1.concept_id;