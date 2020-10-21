-- C322
insert into @resultSchema.dq_check_result
select
 m3.check_id
,24 as stratum1
,m3.stratum3 as stratum2
,m3.concept_tot_count as stratum3
,m3.rslt_null_count as stratum4
,'missing result value count of measurement_concept_id' as stratum5
,null as count_val
,round(cast(propoortion_of_null as float),4) as num_val
,null as txt_val
from
(select
 m1.check_id
,'measurement' as stratum2
,m1.stratum3
,m1.concept_tot_count
,m2.rslt_null_count
,1.0*(cast(m2.rslt_null_count as float)/cast(m1.concept_tot_count as float)) as propoortion_of_null
from
(select
 'C322' as check_id
,measurement_concept_id as stratum3
,count(*) as concept_tot_count
from @cdmSchema.measurement
group by MEASUREMENT_concept_id) as m1
inner join
(select
 'C322' as check_id
,measurement_concept_id as stratum3
,count(*) as rslt_null_count
from @cdmSchema.measurement
where value_as_number is null
and value_as_concept_id is null
and operator_concept_id is null
group by MEASUREMENT_concept_id) as m2
on m1.check_id = m2.check_id
	and m1.stratum3 = m2.stratum3) as m3 ;
