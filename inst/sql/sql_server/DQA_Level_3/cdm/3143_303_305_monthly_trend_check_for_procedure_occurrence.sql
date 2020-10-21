--
IF OBJECT_ID('tempdb.dbo.##procedure_trend_check', 'U') IS NOT NULL
  DROP TABLE ##procedure_trend_check; 

IF OBJECT_ID('tempdb.dbo.##procedure_concept_id_trend_check', 'U') IS NOT NULL
  DROP TABLE ##procedure_concept_id_trend_check; 

  IF OBJECT_ID('tempdb.dbo.##procedure_visit_trend_check', 'U') IS NOT NULL
  DROP TABLE ##procedure_visit_trend_check; 

insert into @resultSchema.dq_check_result
select
 'C303' as check_id
,32 as stratum1
,'procedure_occurrence' as stratum2
,'monthly trend check ' as stratum3
,yymm as stratum4
,null as stratum5
,count(*)  as count_val
,null as num_val
,null as txt_val
from
(select
 person_id
,substring(cast(procedure_date as varchar) ,0,8) as yymm
from
@cdmSchema.procedure_occurrence)v
group by yymm ;
--
select
check_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
into ##procedure_trend_check
from @resultSchema.dq_check_result
where check_id = 'C303'
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
  (select
    check_id, stratum1,stratum2, stratum3, stratum4,stratum5, count_val
   from ##procedure_trend_check)as s1
left join
(select distinct
	 stratum2
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) median
  from ##procedure_trend_check) as p1
on p1.stratum2 = s1.stratum2
left join
  (select
  		 stratum2
 			,cast(avg(1.0*cast(count_val as int))as float) as avg_val
			,cast(stdev(cast(count_val as int))as float) as stdev_val
			,min(cast(count_val as int)) as min_val
			,max(cast(count_val as int)) as max_val
		 from ##procedure_trend_check
			group by  stratum2) as s2
on s1.stratum2 = s2.stratum2;
--
insert into @resultSchema.dq_check_result
select
 'c304' as check_id
,32 as stratum1
,'procedure_occurrence' as stratum2
, procedure_concept_id as stratum3
, yymm  as stratum4
,'monthly trend check by procedure_concept_id' as stratum5
,count(*)  as count_val
,null as num_val
,null as txt_val
from
(select
 procedure_concept_id
,substring(cast(procedure_date as varchar) ,0,8) as yymm
from
@cdmSchema.procedure_occurrence)v
group by procedure_concept_id,yymm;
--
select
check_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
into ##procedure_concept_id_trend_check
from @resultSchema.dq_check_result
where check_id = 'C304'
--
insert into @resultSchema.dq_result_statics
select
   s1.check_id
  ,s1.stratum1
  ,s1.stratum2
  ,s1.stratum3
  ,s1.stratum5 as stratum4
	,null as stratum5
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
  (select
    check_id, stratum1,stratum2, stratum3, stratum4,stratum5, count_val
   from ##procedure_concept_id_trend_check)as s1
left join
(select distinct
	 stratum2
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) median
  from ##procedure_concept_id_trend_check) as p1
on p1.stratum2 = s1.stratum2
left join
  (select
  		 stratum2
 			,cast(avg(1.0*cast(count_val as int))as float) as avg_val
			,cast(stdev(cast(count_val as int))as float) as stdev_val
			,min(cast(count_val as int)) as min_val
			,max(cast(count_val as int)) as max_val
		 from ##procedure_concept_id_trend_check
			group by  stratum2) as s2
on s1.stratum2 = s2.stratum2;
--
insert into @resultSchema.dq_check_result
select
 'C305' as check_id
,32 as stratum1
,'procedure_occurrence' as stratum2
,v1.visit_concept_id as stratum3
,p1.yymm as stratum4
,'monthly trend check with visit_concept_id' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 person_id
,substring(cast(procedure_date as varchar) ,0,8) as yymm
,visit_occurrence_id
from @cdmSchema.procedure_occurrence) as p1
inner join
(select
 visit_occurrence_id
,visit_concept_id
from @cdmSchema.visit_occurrence) as v1
on p1.visit_occurrence_id = v1.visit_occurrence_id
group by v1.visit_concept_id, p1.yymm;
--
select
check_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
into ##procedure_visit_trend_check
from @resultSchema.dq_check_result
where check_id = 'C305'
--
insert into @resultSchema.dq_result_statics
select
   s1.check_id
  ,s1.stratum1
  ,s1.stratum2
  ,s1.stratum3
  ,s1.stratum5 as stratum4
	,null as stratum5
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
  (select
    check_id, stratum1,stratum2, stratum3, stratum4,stratum5, count_val
   from ##procedure_visit_trend_check)as s1
left join
(select distinct
	 stratum3
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum3) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum3) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum3) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum3) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum3) median
  from ##procedure_visit_trend_check) as p1
on p1.stratum3 = s1.stratum3
left join
  (select
  		 stratum3
 			,cast(avg(1.0*cast(count_val as int))as float) as avg_val
			,cast(stdev(cast(count_val as int))as float) as stdev_val
			,min(cast(count_val as int)) as min_val
			,max(cast(count_val as int)) as max_val
		 from ##procedure_visit_trend_check
			group by  stratum3) as s2
on s1.stratum3 = s2.stratum3;

