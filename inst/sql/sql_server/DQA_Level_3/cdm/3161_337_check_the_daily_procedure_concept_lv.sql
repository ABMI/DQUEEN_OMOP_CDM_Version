IF OBJECT_ID('tempdb..#procedure_concept_year_and_month_statics', 'U') IS NOT NULL
   DROP TABLE #procedure_concept_year_and_month_statics
IF OBJECT_ID('tempdb..#procedure_concept_quantity_check', 'U') IS NOT NULL
   DROP TABLE #procedure_concept_quantity_check
--
insert into @resultSchema.dq_check_result
select
 'C337' as check_id
,32 as stratum1
,'procedure_occurrence' as stratum2
,procedure_concept_id as stratum3
,sum_quantity as stratum4
,'check the daily procedure per person' as stratum5
,count_val
,null as num_val
,null as txt_val
from
 (select
  d1.procedure_concept_id
,d1.sum_quantity
,count(*) as count_val
from
(select
 person_id
,procedure_date
,procedure_concept_id
,sum(quantity) as sum_quantity
from @cdmSchema.procedure_occurrence
group by person_id, procedure_date, procedure_concept_id) as d1
group by d1.procedure_concept_id,d1.sum_quantity)v
--
select * into #procedure_concept_year_and_month_statics from @resultSchema.dq_check_result
where check_id = 'C337'
--
select
  d1.procedure_concept_id
,d1.sum_quantity
into #procedure_concept_quantity_check
from
(select
 person_id
,procedure_date
,procedure_concept_id
,sum(quantity) as sum_quantity
from @cdmSchema.procedure_occurrence
group by person_id, procedure_date, procedure_concept_id) as d1
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
  (select check_id, stratum1, stratum2, stratum3, stratum4,stratum5, count_val from #procedure_concept_year_and_month_statics)as s1
left join
(select distinct
	 procedure_concept_id
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(sum_quantity as int)) OVER (PARTITION BY procedure_concept_id) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(sum_quantity as int)) OVER (PARTITION BY procedure_concept_id) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(sum_quantity as int)) OVER (PARTITION BY procedure_concept_id) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(sum_quantity as int)) OVER (PARTITION BY procedure_concept_id) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(sum_quantity as int)) OVER (PARTITION BY procedure_concept_id) median
  from #procedure_concept_quantity_check) as p1
on p1.procedure_concept_id = s1.stratum3
left join
  (select
  		 procedure_concept_id
 			,cast(avg(1.0*cast(sum_quantity as int))as float) as avg_val
			,cast(stdev(cast(sum_quantity as int))as float) as stdev_val
			,min(cast(sum_quantity as int)) as min_val
			,max(cast(sum_quantity as int)) as max_val
		 from #procedure_concept_quantity_check
			group by  procedure_concept_id) as s2
on s1.stratum3 = s2.procedure_concept_id ;