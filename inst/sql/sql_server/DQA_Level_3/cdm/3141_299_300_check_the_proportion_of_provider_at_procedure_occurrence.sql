--
insert into @resultSchema.score_log_CDM
select
 'C299' as check_id
,32 as tb_id
,'procedure_occurrence' as stratum1
,'provider_id' as stratum2
,p1.provider_id as stratum3
,null as stratum4
,null as stratum5
,p1.procedure_occurrence_id as err_no
from
(select
 procedure_occurrence_id
,provider_id
from
@cdmSchema.procedure_occurrence) as p1
left join
    (select
 provider_id
,specialty_concept_id
from @cdmSchema.provider
where
 specialty_concept_id not in
(select concept_id  from @cdmSchema.concept
where
(concept_name like '%doctor%'
   or concept_name like '%nurse%')
  and domain_id = 'Provider Specialty')) as p2
on p1.provider_id = p2.provider_id
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'Other supplier should be not act procedure' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @cdmSchema.score_log_CDM
where check_id = 'C299'
group by  check_id,tb_id ,stratum1 ,stratum2 ;
--

select
 o1.specialty_concept_id
,o1.spcialty_count
,o1.total_row
,round((cast(o1.spcialty_count as float)/cast(o1.total_row as float)),2) as proportion
into ##proportion_rawdata
from
(select
specialty_concept_id
,sum(count_val) as spcialty_count
,(select total_rows from @resultSchema.schema_capacity where tbnm= 'procedure_occurrence') as total_row
from
(select
 d1.provider_id
,p1.specialty_concept_id
,d1.count_val
from
(select
 provider_id
,count(*) as count_val
from @cdmSchema.procedure_occurrence
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
--
insert into @resultSchema.dq_check_result
select
 'C300' as check_id
,32 as stratum1
,d1.specialty_name+': '+cast(d1.specialty_concept_id as varchar)+' : '+cast(d1.spcialty_count as varchar) as stratum2
,n1.specialty_name+': '+cast(n1.specialty_concept_id as varchar)+' : '+cast(n1.spcialty_count as varchar) as stratum3
,cast(d1.proportion as varchar)+':'+cast(n1.proportion as varchar) as stratum4
,case
   when cast(d1.proportion as float) > cast(n1.proportion as float) then 'medical doctor proportion high better than practice nurse'
   else 'practice nurse proportion high better than medical doctor'
 end as stratum5
,null as count_val
,null as num_val
,case
   when cast(d1.proportion as float) > cast(n1.proportion as float) then 'Non_DQ_error'
   else 'DQ_error'
 end as txt_val
from
    (select
 'procedure_occurrence' as tbnm
,specialty_concept_id
,spcialty_count
,total_row
,proportion
,'DR' as specialty_name
from ##proportion_rawdata
where specialty_concept_id in
      (select concept_id from @cdmSchema.concept
         where  DOMAIN_ID = 'Provider Specialty'
                  and concept_name like '%doctor%')) as d1
inner join
(select
 'procedure_occurrence' as tbnm
,specialty_concept_id
,spcialty_count
,proportion
,'RN' as specialty_name
from ##proportion_rawdata
where specialty_concept_id in
      (select concept_id from @cdmSchema.concept
         where  DOMAIN_ID = 'Provider Specialty'
                  and concept_name like '%nurse%')) as n1
on n1.tbnm = d1.tbnm
--
drop table ##proportion_rawdata;