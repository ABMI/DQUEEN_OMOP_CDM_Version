insert into @resultSchema.score_log_CDM
select
 'C311' as check_id
,16 as tb_id
,'device_exposure' as stratum1
,'provider_id' as stratum2
,p1.provider_id as stratum3
,null as stratum4
,null as stratum5
,p1.device_exposure_id as err_no
from
(select
 device_exposure_id
,provider_id
from
@cdmSchema.device_exposure) as p1
inner join
    (select
 provider_id
,specialty_concept_id
from @cdmSchema.provider
where
 specialty_concept_id in
(select concept_id  from @cdmSchema.concept
where
 domain_id = 'Provider Specialty'
and concept_name not like '%doctor%'
   and  concept_name not like '%nurse%')) as p2
on p1.provider_id = p2.provider_id
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'Other supplier should be not act Device_exposure' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C311'
group by  check_id,tb_id ,stratum1 ,stratum2 ;
--
select
 o1.specialty_concept_id
,o1.spcialty_count
,o1.total_row
,round((cast(o1.spcialty_count as float)/cast(o1.total_row as float)),4) as proportion
 into ##proportion_rawdata
from
(select
specialty_concept_id
,sum(count_val) as spcialty_count
,(select total_rows from @resultSchema.schema_capacity where tbnm= 'device_exposure') as total_row
from
(select
 d1.provider_id
,p1.specialty_concept_id
,d1.count_val
from
(select
 provider_id
,count(*) as count_val
from @cdmSchema.device_exposure
group by provider_id ) as d1
inner join
(select
 provider_id
,specialty_concept_id
from @cdmSchema.provider
where specialty_concept_id in (select concept_id  from @cdmSchema.concept
where
(concept_name like '%doctor%'
   or concept_name like '%nurse%')
  and domain_id = 'Provider Specialty')) as p1
on p1.provider_id = d1.provider_id)v
group by specialty_concept_id) as o1
--insert into @resultSchema.dq_check_result
select
*
from
		(select
 'C312' as check_id
,16 as stratum1
,cp1.CONCEPT_NAME as stratum2
,d1.proportion as stratum3
,c1.proportion as stratum4
,'check the provider proportion' as stratum5
,null as count_val
,null as num_val
,case
	 when d1.proportion > c1.proportion then 'N'
	 when d1.proportion < c1.proportion then 'Y'
 else null
	end as txt_val
from
(select
 16 as stratum1
,specialty_concept_id
,spcialty_count
,proportion
from ##proportion_rawdata) as d1
inner join
(select
 check_id
,stratum1
,count_val
,round(cast(count_val as float)
 / cast((select total_rows from @resultSchema.schema_capacity
		where tbnm = 'device_exposure') as float),4) as proportion
from @resultSchema.dq_check_result
where check_id = 'C311') as c1
on d1.stratum1 = c1.stratum1
left join
(select concept_id, concept_name from @cdmSchema.concept
	where domain_id = 'Provider Specialty') as cp1
on d1.specialty_concept_id = cp1.CONCEPT_ID)v
where txt_val = 'Y';
--
drop table ##proportion_rawdata;
