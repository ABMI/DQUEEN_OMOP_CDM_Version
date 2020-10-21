--
insert into @resultSchema.dq_check_result
select
 'C335' as check_id
,15 as stratum1
,'death' as stratum2
,'death_date' as stratum3
,'year_of_birth' as stratum4
,age as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(
select
 d1.person_id
,(d1.death_date - p1.year_of_birth ) as age
from
(select
person_id
,substring(convert(varchar,death_date,121),1,4) as death_date
from @cdmSchema.death) as d1
inner join
(select person_id, year_of_birth from @cdmSchema.person) as p1
on p1.person_id = d1.person_id)v
group by age ;
--
select * into #death_age_statics from @resultSchema.dq_check_result
where check_id = 'C335'
--
insert into @resultSchema.dq_result_statics
select
   s1.check_id
  ,s1.stratum1
  ,s1.stratum2
  ,'age distrubition check for death table' as stratum3
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
  (select check_id, stratum1, stratum2, stratum5, count_val from #death_age_statics)as s1
left join
(select distinct
	 stratum2
	,PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY cast(stratum5 as int)) OVER (PARTITION BY stratum2) p_10
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cast(stratum5 as int)) OVER (PARTITION BY stratum2) p_25
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cast(stratum5 as int)) OVER (PARTITION BY stratum2) p_75
	,PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY cast(stratum5 as int)) OVER (PARTITION BY stratum2) p_90
	,PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY cast(stratum5 as int)) OVER (PARTITION BY stratum2) median
  from  #death_age_statics ) as p1
on p1.stratum2 = s1.stratum2
left join
  (select
  		 stratum2
 			,cast(avg(1.0*cast(stratum5 as int))as float) as avg_val
			,cast(stdev(cast(stratum5 as int))as float) as stdev_val
			,min(cast(stratum5 as int)) as min_val
			,max(cast(stratum5 as int)) as max_val
		 from  #death_age_statics
			group by  stratum2) as s2
on s1.stratum2 = s2.stratum2 ;
--
drop table #death_age_statics;