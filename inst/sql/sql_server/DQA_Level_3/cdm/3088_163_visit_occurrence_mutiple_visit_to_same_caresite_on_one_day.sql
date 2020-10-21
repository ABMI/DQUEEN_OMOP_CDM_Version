insert into @resultSchema.dq_check_result
select
 'C163' as check_id
,38 as stratum1
,visit_concept_id as stratum2
,visit_start_date as stratum3
,care_site_id as stratum4
,'check the multiple visit to same care_sitie on the day' as stratum5
,daily_count_val as count_val
,null as num_val
,null as txt_val
from
(select
 person_id
,visit_concept_id
,visit_start_date
,care_site_id
,count(*) as daily_count_val
from
 @cdmSchema.visit_occurrence
group by  person_id,visit_concept_id,visit_start_date,care_site_id)v ;
--
select * into #multi_visit_count_vs from @resultSchema.dq_check_result
where check_id = 'C163'
--
insert into @resultSchema.dq_result_statics
select distinct
   check_id
  ,s1.stratum1
  ,s1.stratum2
  ,s1.stratum4 as stratum3
  ,'multiple visit to same care_site on the day'as stratum4
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
  (select check_id, stratum1, stratum2, stratum4, count_val from #multi_visit_count_vs) as s1
left join
(select distinct
	 stratum2
	,stratum4
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2,stratum4) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2,stratum4) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2,stratum4) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2,stratum4) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum2,stratum4) median
  from #multi_visit_count_vs
			 ) as p1
on p1.stratum2 = s1.stratum2
			and p1.stratum4 = s1.stratum4
left join
  (select
  		 stratum2
			,stratum4
 			,cast(avg(1.0*cast(count_val as int))as float) as avg_val
			,cast(stdev(cast(count_val as int))as float) as stdev_val
			,min(cast(count_val as int)) as min_val
			,max(cast(count_val as int)) as max_val
		 from #multi_visit_count_vs
			group by  stratum2,stratum4) as s2
on s1.stratum2 = s2.stratum2
		and s1.stratum4 = s2.stratum4 ;
