--
IF OBJECT_ID('tempdb.dbo.##measurement_monthly_check', 'U') IS NOT NULL
  DROP TABLE ##measurement_monthly_check; 

IF OBJECT_ID('tempdb.dbo.##measurement_visit_trend_check', 'U') IS NOT NULL
  DROP TABLE ##measurement_visit_trend_check; 


insert into @resultSchema.dq_check_result
select
 'C325' as check_id
,24 as stratum1
,'measurement' as stratum2
,yymm as stratum3
,null as stratum4
,'monthly trend check for measurement' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 measurement_id
,substring(cast(measurement_date as varchar),1,7) as yymm
from @cdmSchema.measurement
where measurement_date is not null)v
group by yymm
--
select
*
into ##measurement_monthly_check
from @resultSchema.dq_check_result
where check_id = 'C325'
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
  (select check_id, stratum1, stratum2, stratum3, stratum4,stratum5, count_val from ##measurement_monthly_check )as s1
left join
(select distinct
	 stratum1
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(count_val as float)) OVER (PARTITION BY stratum1) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(count_val as float)) OVER (PARTITION BY stratum1) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(count_val as float)) OVER (PARTITION BY stratum1) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(count_val as float)) OVER (PARTITION BY stratum1) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(count_val as float)) OVER (PARTITION BY stratum1) median
  from ##measurement_monthly_check ) as p1
on p1.stratum1 = s1.stratum1
left join
  (select
  		 stratum1
 			,cast(avg(1.0*cast(count_val as int))as float) as avg_val
			,cast(stdev(cast(count_val as int))as float) as stdev_val
			,min(cast(count_val as float)) as min_val
			,max(cast(count_val as float)) as max_val
		 from ##measurement_monthly_check
			group by  stratum1) as s2
on s1.stratum1 = s2.stratum1
--
insert into  @resultSchema.dq_check_result
select
 'C326' as check_id
,24 as stratum1
,'measurement' as stratum2
,visit_concept_id as stratum3
,measurement_date as stratum4
,'measurement montly trend check with visit_concept_id' as stratum5
,count_val
,null as num_val
,null as txt_val
from
		(select
 v1.visit_concept_id
,m1.measurement_date
,count(*) as count_val
from
(select
 person_id
,substring(cast(measurement_date as varchar),1,7) as measurement_date
,visit_occurrence_id
from @cdmSchema.measurement
where visit_occurrence_id is not null ) as m1
inner join
(select
	visit_occurrence_id, visit_concept_id
 from @cdmSchema.visit_occurrence) as v1
on m1.visit_occurrence_id = v1.visit_occurrence_id
group by v1.visit_concept_id, m1.measurement_date)v
--
select
*
into ##measurement_visit_trend_check
from @resultSchema.dq_check_result
where check_id = 'C326'
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
  (select check_id, stratum1, stratum2, stratum3, stratum4,stratum5, count_val from ##measurement_visit_trend_check )as s1
left join
(select distinct
	 stratum3
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(count_val as float)) OVER (PARTITION BY stratum3) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(count_val as float)) OVER (PARTITION BY stratum3) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(count_val as float)) OVER (PARTITION BY stratum3) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(count_val as float)) OVER (PARTITION BY stratum3) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(count_val as float)) OVER (PARTITION BY stratum3) median
  from ##measurement_visit_trend_check ) as p1
on p1.stratum3 = s1.stratum3
left join
  (select
  		 stratum3
 			,cast(avg(1.0*cast(count_val as int))as float) as avg_val
			,cast(stdev(cast(count_val as int))as float) as stdev_val
			,min(cast(count_val as float)) as min_val
			,max(cast(count_val as float)) as max_val
		 from ##measurement_visit_trend_check
			group by  stratum3) as s2
on s1.stratum3 = s2.stratum3
--
insert into @resultSchema.dq_check_result
select
 check_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 'C327' as check_id
,24 as stratum1
,'measurement' as stratum2
,'age' as stratum3
,m1.yy - p1.year_of_birth as stratum4
,'age distribution check' as stratum5
from
(select
 person_id
,substring(cast(measurement_date as varchar),1,4) as yy
from @cdmSchema.measurement
where measurement_date is not null) as m1
inner join
(select person_id, year_of_birth from @cdmSchema.person) as p1
on m1.person_id = p1.person_id)v
group by  check_id ,stratum1 ,stratum2 ,stratum3 ,stratum4 ,stratum5
--
insert into @resultSchema.dq_check_result
select
 'C328' as check_id
,24 as stratum1
,'measurement' as stratum2
,'measurement_concept_id' as stratum3
,MEASUREMENT_concept_id as stratum4
,'proportion check of measurement_concept_id' as stratum5
,count_val
,round((cast(count_val as float)/cast((select total_rows from byun_dqueen_v2.dbo.schema_capacity where tbnm = 'measurement') as float)),4) as num_val
,null as txt_val
from
(select
 measurement_concept_id
,count(*) as count_val
from @cdmSchema.measurement
group by measurement_concept_id)v
--
