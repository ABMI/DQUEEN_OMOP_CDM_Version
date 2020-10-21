insert into @resultSchema.dq_check_result
select
 'C280' as check_id
,20 as stratum1
,'drug_exposure' as stratum2
,yyyymm as stratum3
,null as stratum4
,'check the monthly data count' as stratum5
,count_val
,null as num_val
,null as txt_val
from
 (select
 d1.yyyymm
,count(*) as count_val
from
(select
 substring(convert(varchar,drug_exposure_start_date,121),1,7) as yyyymm
,person_id
,visit_occurrence_id
from @cdmSchema.drug_exposure) as d1
 group by  d1.yyyymm)v
--
select * into #drug__month_statics from @resultSchema.dq_check_result
where check_id = 'C280'
--
insert into @resultSchema.dq_result_statics
select
   s1.check_id
  ,s1.stratum1
  ,s1.stratum2
  ,s1.stratum4 as stratum3
  ,s1.stratum3 as stratum4
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
  (select check_id, stratum1, stratum2, stratum3, stratum4,stratum5, count_val from #drug__month_statics)as s1
left join
(select distinct
	 stratum1
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum1) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum1) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum1) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum1) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum1) median
  from #drug__month_statics) as p1
on p1.stratum1 = s1.stratum1
left join
  (select
  		 stratum1
 			,cast(avg(1.0*cast(count_val as int))as float) as avg_val
			,cast(stdev(cast(count_val as int))as float) as stdev_val
			,min(cast(count_val as int)) as min_val
			,max(cast(count_val as int)) as max_val
		 from #drug__month_statics
			group by  stratum1) as s2
on s1.stratum1 = s2.stratum1 ;