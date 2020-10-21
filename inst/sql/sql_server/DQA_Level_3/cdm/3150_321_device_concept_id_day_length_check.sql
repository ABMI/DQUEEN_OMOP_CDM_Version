--
IF OBJECT_ID('tempdb.dbo.#device_day_length_statics', 'U') IS NOT NULL
  DROP TABLE #device_day_length_statics; 

IF OBJECT_ID('tempdb.dbo.#device_day_length_statics_2', 'U') IS NOT NULL
  DROP TABLE #device_day_length_statics_2; 

insert into @resultSchema.dq_check_result
select
 'C321' as check_id
,16 as stratum1
,'device_exposure' as stratum2
,device_concept_id as stratum3
,diff_date as stratum4
,'device_exposure day length check' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 device_concept_id
,datediff(day,device_exposure_start_date,device_exposure_end_date) as diff_date
from @cdmSchema.device_exposure)v
group by device_concept_id, diff_date;
--
select
	check_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
into #device_day_length_statics
from @resultSchema.dq_check_result
where check_id = 'C321'
--
select
 'C321' as check_id
,16 as stratum1
,'device_exposure' as stratum2
,device_concept_id as stratum3
,diff_date as stratum4
,'device_exposure day length check' as stratum5
,null as count_val
,null as num_val
,null as txt_val
into #device_day_length_statics_2
from
(select
 device_concept_id
,datediff(day,device_exposure_start_date,device_exposure_end_date) as diff_date
from @cdmSchema.device_exposure)v;
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
  (select check_id, stratum1, stratum2, stratum3, stratum4,stratum5, count_val from #device_day_length_statics)as s1
left join
(select distinct
	 stratum3
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(stratum4 as int)) OVER (PARTITION BY stratum3) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(stratum4 as int)) OVER (PARTITION BY stratum3) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(stratum4 as int)) OVER (PARTITION BY stratum3) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(stratum4 as int)) OVER (PARTITION BY stratum3) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(stratum4 as int)) OVER (PARTITION BY stratum3) median
  from #device_day_length_statics_2) as p1
on p1.stratum3 = s1.stratum3
left join
  (select
  		 stratum3
 			,cast(avg(1.0*cast(stratum4 as int))as float) as avg_val
			,cast(stdev(cast(stratum4 as int))as float) as stdev_val
			,min(cast(stratum4 as int)) as min_val
			,max(cast(stratum4 as int)) as max_val
		 from #device_day_length_statics_2
			group by  stratum3) as s2
on s1.stratum3 = s2.stratum3
--