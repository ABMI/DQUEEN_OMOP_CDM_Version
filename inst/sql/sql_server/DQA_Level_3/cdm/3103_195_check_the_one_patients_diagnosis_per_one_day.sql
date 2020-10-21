-- Temporal
insert into @resultSchema.dq_check_result
select
 'C195' as check_id
,13 as stratum1
,'condition_occurrence' as stratum2
,count_val as stratum3
,null as stratum4
,'check the one patients diagnosis per one day' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 person_id
,condition_start_date
,count(*) as count_val
from @cdmSchema.condition_occurrence
group by  person_id,condition_start_date)v
group by count_val
--
select
 'C195' as check_id
,13 as stratum1
,'condition_occurrence' as stratum2
,condition_start_date as stratum3
,null as stratum4
,'check the one patients diagnosis per one day' as stratum5
,count_val
,null as num_val
,null as txt_val
 into #condition_occurrence_once_condition_statics
from
(select
 person_id
,condition_start_date
,count(*) as count_val
from @cdmSchema.condition_occurrence
group by  person_id,condition_start_date)v
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
  (select check_id, stratum1,stratum2, stratum3, stratum4,stratum5, count_val from @resultSchema.dq_check_result
		where check_id = 'C195')as s1
left join
(select distinct
	 stratum2
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2) median
  from #condition_occurrence_once_condition_statics) as p1
on p1.stratum2 = s1.stratum2
left join
  (select
  		 stratum2
 			,cast(avg(1.0*cast(count_val as int))as float) as avg_val
			,cast(stdev(cast(count_val as int))as float) as stdev_val
			,min(cast(count_val as int)) as min_val
			,max(cast(count_val as int)) as max_val
		 from #condition_occurrence_once_condition_statics
			group by  stratum2) as s2
on s1.stratum2 = s2.stratum2;
