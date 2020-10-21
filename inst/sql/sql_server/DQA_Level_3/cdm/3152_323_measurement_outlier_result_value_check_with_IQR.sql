-- C333
IF OBJECT_ID('tempdb.dbo.##measurement_IQR', 'U') IS NOT NULL
  DROP TABLE ##measurement_IQR;

IF OBJECT_ID('tempdb.dbo.##measurement_main_IQR', 'U') IS NOT NULL
  DROP TABLE ##measurement_main_IQR;


insert into @resultSchema.dq_check_result
select
 'C323' as check_id
,24 as stratum1
,'measurement' as stratum2
,measurement_concept_id as stratum3
,value_as_number as stratum4
,'detect the outlier result value of measurement (IQR)' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 measurement_concept_id
,cast(value_as_number as float) as value_as_number
from @cdmSchema.measurement
where value_as_number is not null)v
group by measurement_concept_id, value_as_number;
--
select
 'C323' as check_id
,24 as stratum1
,'measurement' as stratum2
,measurement_concept_id as stratum3
,value_as_number as stratum4
into ##measurement_IQR
from @cdmSchema.measurement
where value_as_number is not null
--
select
 check_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
into ##measurement_main_IQR
from @resultSchema.dq_check_result
where check_id = 'C323'
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
  (select check_id, stratum1, stratum2, stratum3, stratum4,stratum5, count_val from ##measurement_main_IQR)as s1
left join
(select distinct
	 stratum3
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(stratum4 as float)) OVER (PARTITION BY stratum3) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(stratum4 as float)) OVER (PARTITION BY stratum3) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(stratum4 as float)) OVER (PARTITION BY stratum3) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(stratum4 as float)) OVER (PARTITION BY stratum3) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(stratum4 as float)) OVER (PARTITION BY stratum3) median
  from ##measurement_IQR) as p1
on p1.stratum3 = s1.stratum3
left join
  (select
  		 stratum3
 			,round(cast(avg(1.0*cast(stratum4 as float))as float),2) as avg_val
			,round(cast(stdev(cast(stratum4 as float))as float),2) as stdev_val
			,min(cast(stratum4 as float)) as min_val
			,max(cast(stratum4 as float)) as max_val
		 from ##measurement_IQR
			group by  stratum3) as s2
on s1.stratum3 = s2.stratum3
