--
insert into @resultSchema.dq_check_result
select
 'C332' as check_id
,24 as stratum1
,measurement_concept_id as stratum2
,gender_concept_id as stratum3
,value_as_number as stratum4
,'outlier detection of measurement result value' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 m1.person_id
,p1.gender_concept_id
,m1.MEASUREMENT_concept_id
,m1.value_as_number
from
(select
 person_id
,substring(cast(measurement_date as varchar),1,4) as measurement_yy
,measurement_concept_id
,cast(value_as_number as float) as value_as_number
from @cdmSchema.measurement
where value_as_number is not null) as m1
inner join
(select
 person_id
,gender_concept_id
,year_of_birth
from @cdmSchema.person) as p1
on p1.person_id = m1.person_id)v
group by MEASUREMENT_concept_id, gender_concept_id, value_as_number;
--
select
*
into ##measurement_gender_IQR
from
@resultSchema.dq_check_result
where check_id = 'C332'
--
select
 'C332' as check_id
,24 as stratum1
,measurement_concept_id as stratum2
,gender_concept_id as stratum3
,value_as_number as stratum4
into ##measurement_gender_sub_IQR
from
(select
 m1.person_id
,p1.gender_concept_id
,m1.MEASUREMENT_concept_id
,m1.value_as_number
from
(select
 person_id
,substring(cast(measurement_date as varchar),1,4) as measurement_yy
,measurement_concept_id
,cast(value_as_number as float) as value_as_number
from @cdmSchema.measurement
where value_as_number is not null) as m1
inner join
(select
 person_id
,gender_concept_id
,year_of_birth
from @cdmSchema.person) as p1
on p1.person_id = m1.person_id)v
group by MEASUREMENT_concept_id, gender_concept_id, value_as_number;
--
insert into @resultSchema.dq_result_statics
select
   s1.check_id
  ,s1.stratum1
  ,s1.stratum2
  ,s1.stratum3
  ,s1.stratum4
	,s1.stratum5
  ,s1.count_val
  ,null as other_val
  ,s2.min_val as min
  ,s2.max_val as max
  ,s2.avg_val as avg
  ,s2.stdev_val as stdev
  ,p1.median
  ,p1.p_10
  ,p1.p_25
  ,p1.p_75
  ,p1.p_90
from
  (select check_id, stratum1, stratum2, stratum3, stratum4,stratum5, count_val from ##measurement_gender_IQR)as s1
left join
(select distinct
	 stratum2,stratum3
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(stratum4 as float)) OVER (PARTITION BY stratum2,stratum3) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(stratum4 as float)) OVER (PARTITION BY stratum2,stratum3) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(stratum4 as float)) OVER (PARTITION BY stratum2,stratum3) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(stratum4 as float)) OVER (PARTITION BY stratum2,stratum3) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(stratum4 as float)) OVER (PARTITION BY stratum2,stratum3) median
  from ##measurement_gender_sub_IQR) as p1
on p1.stratum2 = s1.stratum2 and p1.stratum3 = s1.stratum3
left join
  (select distinct
  		 stratum2,stratum3
 			,round(cast(avg(1.0*cast(stratum4 as float))as float),2) as avg_val
			,round(cast(stdev(cast(stratum4 as float))as float),2) as stdev_val
			,min(cast(stratum4 as float)) as min_val
			,max(cast(stratum4 as float)) as max_val
		 from ##measurement_gender_sub_IQR
			group by  stratum2,stratum3) as s2
on s1.stratum2 = s2.stratum2 and s1.stratum3 = s2.stratum3
--
drop table ##measurement_gender_sub_IQR;
drop table ##measurement_gender_IQR;