--
insert into @resultSchema.dq_check_result
select
 'C320' as check_id
,16 as stratum1
,'device_exposure' as stratum2
,'age' as stratum3
,age as stratum4
,'age distribution check' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
(d1.yy - p1.year_of_birth) as age
from
(select
 person_id
,substring(cast(device_exposure_start_date as varchar),1,4) as yy
from @cdmSchema.device_exposure) as d1
inner join
(select
 person_id
,year_of_birth
from @cdmSchema.person) as p1
on p1.person_id = d1.person_id)v
group by age ;
--

