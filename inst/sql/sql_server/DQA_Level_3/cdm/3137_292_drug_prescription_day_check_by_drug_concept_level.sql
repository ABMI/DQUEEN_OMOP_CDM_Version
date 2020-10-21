insert into @resultSchema.dq_check_result
select
 'C292' as check_id
,20 as stratum1
,'drug_exposure' as stratum2
,diffday as stratum3
,drug_concept_id as stratum4
,'drug prescription day check by drug_concept_level' as stratum5
,count_val
,null as num_val
,null as txt_val
from
 (select
 drug_concept_id
,diffday
,count(*) as count_val
from
(select
 datediff(day,DRUG_EXPOSURE_START_DATE,DRUG_EXPOSURE_END_DATE) as diffday
,person_id
,drug_concept_id
from @cdmSchema.drug_exposure)w
 group by drug_concept_id,diffday)v
--
select * into #drug_concept_lv_statics1 from @resultSchema.dq_check_result
where check_id = 'C292'
select * into #drug_concept_lv_statics2 from @resultSchema.dq_check_result
where check_id = 'C292'
select * into #drug_concept_lv_statics3 from @resultSchema.dq_check_result
where check_id = 'C292'
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
  (select check_id, stratum1, stratum2, stratum3, stratum4,stratum5, count_val from #drug_concept_lv_statics1)as s1
left join
(select distinct
	 stratum4
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(stratum3 as int)) OVER (PARTITION BY stratum4) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(stratum3 as int)) OVER (PARTITION BY stratum4) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(stratum3 as int)) OVER (PARTITION BY stratum4) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(stratum3 as int)) OVER (PARTITION BY stratum4) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(stratum3 as int)) OVER (PARTITION BY stratum4) median
  from #drug_concept_lv_statics2) as p1
on p1.stratum4 = s1.stratum4
left join
  (select
  		 stratum4
 			,cast(avg(1.0*cast(stratum3 as int))as float) as avg_val
			,cast(stdev(cast(stratum3 as int))as float) as stdev_val
			,min(cast(stratum3 as int)) as min_val
			,max(cast(stratum3 as int)) as max_val
		 from #drug_concept_lv_statics3
			group by  stratum4) as s2
on s1.stratum4 = s2.stratum4 ;