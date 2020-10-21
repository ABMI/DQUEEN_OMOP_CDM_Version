insert into @resultSchema.dq_check_result
select
 'C192' as check_id
,13 as stratum1
,'condition_occurrence' as stratum2
,'person' as stratum3
,age as stratum4
,'check the age distribution of condition_occurrence' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 c1.person_id
,c1.condition_occurrence_id
,c1.condition_start_date
,p1.birth_datetime
,(datediff(day,convert(varchar,p1.birth_datetime,121),convert(varchar,c1.condition_start_date,121))/365) as age
from
(select
 condition_occurrence_id
,condition_start_date
,person_id
from @cdmSchema.condition_occurrence) as c1
inner join
(select
 person_id
,birth_datetime
from @cdmSchema.person) as p1
on p1.person_id = c1.person_id)v
group by age
order by age