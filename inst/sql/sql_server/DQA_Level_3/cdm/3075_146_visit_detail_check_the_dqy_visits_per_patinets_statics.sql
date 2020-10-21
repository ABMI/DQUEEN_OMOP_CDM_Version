--
insert into @resultSchema.dq_check_result
 select
		 'C146' as check_id
		,37 as stratum1
	 	,'visit_detail_concept_id' as stratum2
		,'visit_detail_start_date' as stratum3
		,visit_detail_concept_id as stratum4
		,daily_visit as stratum5
		,null as count_val
		,null as num_val
		,null as txt_val
  from
  (
    select
     visit_detail_concept_id
    ,daily_visit
    from
    (select
       person_id
      ,cast(visit_detail_start_date as date) as visit_date
      ,visit_detail_concept_id
      ,count(*) as daily_visit
    from @cdmSchema.visit_detail
    group by person_id,visit_detail_start_date,visit_detail_concept_id)w)v;
--
select
 stratum4
,stratum5
into #statics_vd
from @resultSchema.dq_check_result
where check_id = 'C146'
--
insert into @resultSchema.dq_result_statics
select
   'C146' as check_id
  ,s1.stratum1
  ,s1.stratum4 as stratum2
  ,'check the Day visits per patient' as stratum3
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
from (select check_id, stratum1, stratum4, stratum5, count(*) as count_val  from @resultSchema.dq_check_result
     	where check_id = 'C146'
			group by check_id, stratum1, stratum4, stratum5
     )as s1
left join
(select distinct
	 stratum4
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(stratum5 as int)) OVER (PARTITION BY stratum4) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(stratum5 as int)) OVER (PARTITION BY stratum4) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(stratum5 as int)) OVER (PARTITION BY stratum4) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(stratum5 as int)) OVER (PARTITION BY stratum4) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(stratum5 as int)) OVER (PARTITION BY stratum4) median
from  #statics_vd ) as p1
on p1.stratum4 = s1.stratum4
left join
  (select
  		 stratum4
 			,cast(avg(1.0*cast(stratum5 as int))as float) as avg_val
			,cast(stdev(cast(stratum5 as int))as float) as stdev_val
			,min(cast(stratum5 as int)) as min_val
			,max(cast(stratum5 as int)) as max_val
		 from  #statics_vd
			group by  stratum4) as s2
on s1.stratum4 = s2.stratum4
order by s1.stratum4,s1.stratum5;

