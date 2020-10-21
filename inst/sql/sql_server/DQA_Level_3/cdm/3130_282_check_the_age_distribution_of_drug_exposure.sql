insert into @resultSchema.dq_check_result
select
 'C282' as check_id
,20 as stratum1
,'drug_exposure' as stratum2
,'drug_exposure_start_date' as stratum3
,age as stratum4
,'age distribution check for drug_exposure' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
d1.DRUG_EXPOSURE_ID
,(datediff(day,p1.birth_datetime,d1.DRUG_EXPOSURE_START_DATE)/365) as age
from
(select
 person_id
,drug_exposure_start_date
,drug_exposure_id
from @cdmSchema.drug_exposure) as d1
inner join
(select
 person_id
,birth_datetime
from @cdmSchema.person) as p1
on p1.person_id = d1.person_id)v
group by age ;