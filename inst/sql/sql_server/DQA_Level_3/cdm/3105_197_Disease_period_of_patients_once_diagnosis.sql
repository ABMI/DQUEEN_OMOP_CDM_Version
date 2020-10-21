-- Temporal
insert into @resultSchema.dq_check_result
select
 'C197' as check_id
,13 as stratum1
,'condition_occurrence' as stratum2
,day_diff as stratum3
,null as stratum4
,'Disease period of patients once diagnosis' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 person_id
,condition_occurrence_id
,condition_start_date
,condition_end_date
,datediff(day,condition_start_date, condition_end_date) as day_diff
from @cdmSchema.condition_occurrence)v
group by day_diff
--
select
 'C197' as check_id
,13 as stratum1
,'condition_occurrence' as stratum2
,day_diff as stratum3
into #condition_occurrence_period_statics
from
(select
 person_id
,condition_occurrence_id
,condition_start_date
,condition_end_date
,datediff(day,condition_start_date, condition_end_date) as day_diff
from @cdmSchema.condition_occurrence
where condition_end_date is not null )v
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
  (select check_id, stratum1,stratum2, stratum3, stratum4,stratum5, count_val from @resultSchema.dq_check_result
		where check_id = 'C197')as s1
left join
(select distinct
	 stratum1
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(stratum3 as int)) OVER (PARTITION BY stratum1) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(stratum3 as int)) OVER (PARTITION BY stratum1) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(stratum3 as int)) OVER (PARTITION BY stratum1) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(stratum3 as int)) OVER (PARTITION BY stratum1) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(stratum3 as int)) OVER (PARTITION BY stratum1) median
  from #condition_occurrence_period_statics) as p1
on p1.stratum1 = s1.stratum1
left join
  (select
  		 stratum1
 			,cast(avg(1.0*cast(stratum3 as int))as float) as avg_val
			,cast(stdev(cast(stratum3 as int))as float) as stdev_val
			,min(cast(stratum3 as int)) as min_val
			,max(cast(stratum3 as int)) as max_val
		 from #condition_occurrence_period_statics
			group by  stratum1) as s2
on s1.stratum1 = s2.stratum1;
