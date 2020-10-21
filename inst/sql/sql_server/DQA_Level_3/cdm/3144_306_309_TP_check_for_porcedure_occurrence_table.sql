--
IF OBJECT_ID('tempdb.dbo.##daily_procedure_count_visit', 'U') IS NOT NULL
  DROP TABLE ##daily_procedure_count_visit; 

IF OBJECT_ID('tempdb.dbo.##daily_procedure_count', 'U') IS NOT NULL
  DROP TABLE ##daily_procedure_count; 


select
 'C306' as check_id
,32 as stratum1
,'procedure_occurrence' as stratum2
,procedure_date as stratum3
,visit_concept_id as stratum4
,'Daily procedure count by visit type' as stratum5
,count_val
into ##daily_procedure_count_visit
from
(select
 p1.person_id
,p1.procedure_date
,v1.visit_concept_id
,count(*) as count_val
from
(select
person_id
,procedure_date
,visit_occurrence_id
from @cdmSchema.procedure_occurrence) as p1
inner join
(select
		visit_occurrence_id, visit_concept_id
 from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = p1.visit_occurrence_id
group by  p1.person_id,p1.procedure_date,v1.visit_concept_id
) as pv1 ;
--
insert into @resultSchema.dq_result_statics
select
   s1.check_id
  ,s1.stratum1
  ,s1.stratum2
  ,s1.stratum4 as stratum3
  ,s1.stratum5 as stratum4
  ,s1.count_val as stratum5
  ,s1.count_val2 as count_val
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
  (select
    check_id, stratum1,stratum2,stratum4,stratum5,count_val, count(*) as count_val2
   from ##daily_procedure_count_visit
    group by check_id, stratum1,stratum2,stratum4,stratum5,count_val )as s1
left join
(select distinct
	 stratum4
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum4) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum4) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum4) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum4) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum4) median
  from ##daily_procedure_count_visit) as p1
on p1.stratum4 = s1.stratum4
left join
  (select
  		 stratum4
 			,cast(avg(1.0*cast(count_val as int))as float) as avg_val
			,cast(stdev(cast(count_val as int))as float) as stdev_val
			,min(cast(count_val as int)) as min_val
			,max(cast(count_val as int)) as max_val
		 from ##daily_procedure_count_visit
			group by  stratum4) as s2
on s1.stratum4 = s2.stratum4 ;
--
select
 'C307' as check_id
,32 as stratum1
,'procedure_occurrence' as stratum2
,procedure_date as stratum3
,null as stratum4
,'Daily procedure count by initial person' as stratum5
,count_val
 into ##daily_procedure_count
from
(select
 p1.person_id
,p1.procedure_date
,count(*) as count_val
from
(select
 person_id
,procedure_date
,procedure_occurrence_id
from @cdmSchema.procedure_occurrence) as p1
group by  p1.person_id,p1.procedure_date) as pv1 ;
--
insert into @resultSchema.dq_result_statics
select
   s1.check_id
  ,s1.stratum1
  ,s1.stratum2
  ,s1.stratum4 as stratum3
  ,s1.stratum5 as stratum4
  ,s1.count_val as stratum5
  ,s1.count_val2 as count_val
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
  (select
    check_id, stratum1,stratum2,stratum4,stratum5,count_val, count(*) as count_val2
   from ##daily_procedure_count
    group by check_id, stratum1,stratum2,stratum4,stratum5,count_val )as s1
left join
(select distinct
	 stratum1
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum1) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum1) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum1) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum1) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum1) median
  from ##daily_procedure_count) as p1
on p1.stratum1 = s1.stratum1
left join
  (select
  		 stratum1
 			,cast(avg(1.0*cast(count_val as int))as float) as avg_val
			,cast(stdev(cast(count_val as int))as float) as stdev_val
			,min(cast(count_val as int)) as min_val
			,max(cast(count_val as int)) as max_val
		 from ##daily_procedure_count
			group by  stratum1) as s2
on s1.stratum1 = s2.stratum1 ;
--
insert into @resultSchema.dq_check_result
select
 'C308' as check_id
,32 as stratum1
,'procedure_occurrence' as stratum2
,'procedure_concept_id' as stratum3
,p1.procedure_concept_id as stratum4
,'proportion of porcedure_concept_id in procedure_occurrence' as stratum5
,p1.count_val
,1.0*(cast(p1.count_val as float)/cast(p2.tot_count as float)) as num_val
,null as txt_val
from
(select
 procedure_concept_id
,count(*) as count_val
,32 as stratum1
from @cdmSchema.procedure_occurrence
group by procedure_concept_id) as p1
inner join
(select
 32 as stratum1
,count(*) as tot_count
 from @cdmSchema.procedure_occurrence) as p2
on p1.stratum1 = p2.stratum1;
--
insert into @resultSchema.dq_check_result
select
 'C309' as check_id
,32 as stratum1
,'procedure_occurrence' as stratum2
,'age' as stratum3
,age as stratum4
,'check the age distribution' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 p1.person_id
,p1.yy - p2.year_of_birth as age
from
(select
 distinct
 person_id
,substring(cast(procedure_date as varchar),0,5) as yy
from @cdmSchema.procedure_occurrence) as p1
inner join
(select
 person_id
,year_of_birth
from @cdmSchema.person) as p2
on p1.person_id = p2.person_id)v
group by age ;