--
insert into @resultSchema.dq_check_result
select
 'C336' as check_id
,20 as stratum1
,'drug_exposure' as stratum2
,drug_concept_id as stratum3
,diffday as stratum4
,'check the drug exposure days between startdate and enddate' as stratum5
,count_val
,null as num_val
,null as txt_val
from
 (select
 d1.drug_concept_id
,d1.diffday
,count(*) as count_val
from
(select
 (datediff(day,DRUG_EXPOSURE_START_DATE,DRUG_EXPOSURE_END_DATE)+1) as diffday
,person_id
,drug_concept_id
from @cdmSchema.drug_exposure) as d1
 group by d1.drug_concept_id, d1.diffday)v
--
select * into #drug_concept_and_month_statics from @resultSchema.dq_check_result
where check_id = 'C336'
select
 (datediff(day,DRUG_EXPOSURE_START_DATE,DRUG_EXPOSURE_END_DATE)+1) as diffday
,person_id
,drug_concept_id
into #drug_concept_level_statics
from @cdmSchema.drug_exposure
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
  (select check_id, stratum1, stratum2, stratum3, stratum4,stratum5, count_val from #drug_concept_and_month_statics)as s1
left join
(select distinct
	 drug_concept_id
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(diffday as int)) OVER (PARTITION BY drug_concept_id) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(diffday as int)) OVER (PARTITION BY drug_concept_id) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(diffday as int)) OVER (PARTITION BY drug_concept_id) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(diffday as int)) OVER (PARTITION BY drug_concept_id) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(diffday as int)) OVER (PARTITION BY drug_concept_id) median
  from #drug_concept_level_statics) as p1
on p1.drug_concept_id = s1.stratum3
left join
  (select
  		 drug_concept_id
 			,cast(avg(1.0*cast(diffday as int))as float) as avg_val
			,cast(stdev(cast(diffday as int))as float) as stdev_val
			,min(cast(diffday as int)) as min_val
			,max(cast(diffday as int)) as max_val
		 from #drug_concept_level_statics
			group by  drug_concept_id) as s2
on s1.stratum3 = s2.drug_concept_id ;
--
drop table #drug_concept_level_statics;