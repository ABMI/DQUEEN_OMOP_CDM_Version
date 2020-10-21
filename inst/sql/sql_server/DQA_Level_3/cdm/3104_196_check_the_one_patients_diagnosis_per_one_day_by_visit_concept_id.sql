-- Temporal
insert into @resultSchema.dq_check_result
select
 'C196' as check_id
,13 as stratum1
,'condition_occurrence' as stratum2
,visit_concept_id as stratum3
,count_val as stratum4
,'check the one patients diagnosis per one day by visit_concept_id' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(
select
 c1.person_id
,v1.visit_concept_id
,c1.condition_start_date
,count(*) as count_val
from
(select
 condition_occurrence_id
,condition_start_date
,person_id
,visit_occurrence_id
from @cdmSchema.condition_occurrence) as c1
inner join
(select
 person_id
,visit_occurrence_id
,visit_concept_id
from @cdmSchema.visit_occurrence) as v1
on c1.visit_occurrence_id = v1.visit_occurrence_id
group by  c1.person_id,v1.visit_concept_id,c1.condition_start_date)v
group by visit_concept_id, count_val
--
select
 'C196' as check_id
,13 as stratum1
,'condition_occurrence' as stratum2
,visit_concept_id as stratum3
,null as stratum4
,'check the one patients diagnosis per one day by visit_concept_id' as stratum5
,count_val
,null as num_val
,null as txt_val
into #condition_occurrence_visit_once_condition_statics
from
(
select
 c1.person_id
,v1.visit_concept_id
,c1.condition_start_date
,count(*) as count_val
from
(select
 condition_occurrence_id
,condition_start_date
,person_id
,visit_occurrence_id
from @cdmSchema.condition_occurrence) as c1
inner join
(select
 person_id
,visit_occurrence_id
,visit_concept_id
from @cdmSchema.visit_occurrence) as v1
on c1.visit_occurrence_id = v1.visit_occurrence_id
group by  c1.person_id,v1.visit_concept_id,c1.condition_start_date)v
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
		where check_id = 'C196')as s1
left join
(select distinct
	 stratum3
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum3) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum3) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum3) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum3) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(count_val as int)) OVER (PARTITION BY stratum3) median
  from #condition_occurrence_visit_once_condition_statics) as p1
on p1.stratum3 = s1.stratum3
left join
  (select
  		 stratum3
 			,cast(avg(1.0*cast(count_val as int))as float) as avg_val
			,cast(stdev(cast(count_val as int))as float) as stdev_val
			,min(cast(count_val as int)) as min_val
			,max(cast(count_val as int)) as max_val
		 from #condition_occurrence_visit_once_condition_statics
			group by  stratum3) as s2
on s1.stratum3 = s2.stratum3;
