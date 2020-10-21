--> Atemporal
with proportion_rawdata as (
select
 o1.specialty_concept_id
,o1.spcialty_count
,o1.total_row
,round((cast(o1.spcialty_count as float)/cast(o1.total_row as float)),2) as proportion
from
(select
specialty_concept_id
,sum(count_val) as spcialty_count
,(select total_rows from @resultSchema.schema_capacity where tbnm= 'drug_exposure') as total_row
from
(select
 d1.provider_id
,p1.specialty_concept_id
,d1.count_val
from
(select
 provider_id
,count(*) as count_val
from @cdmSchema.DRUG_EXPOSURE
group by provider_id ) as d1
inner join
(select
 provider_id
,specialty_concept_id
from @cdmSchema.provider
where specialty_concept_id in (4010577,4010474)) as p1
on p1.provider_id = d1.provider_id)v
group by specialty_concept_id) as o1)
--
insert into @resultSchema.dq_check_result
select
 'C268' as check_id
,20 as stratum1
,cast(pr1.specialty_concept_id as varchar)+' : '+cast(pr1.spcialty_count as varchar) as stratum2
,cast(pr2.specialty_concept_id as varchar)+' : '+cast(pr2.spcialty_count as varchar) as stratum3
,cast(pr1.proportion as varchar)+':'+cast(pr2.proportion as varchar) as stratum4
,case
   when cast(pr1.proportion as float) > cast(pr2.proportion as float) then 'medical doctor proportion high better than practice nurse'
   else 'practice nurse proportion high better than medical doctor'
 end as stratum5
,null as count_val
,null as num_val
,case
   when cast(pr1.proportion as float) > cast(pr2.proportion as float) then 'Non_DQ_error'
   else 'DQ_error'
 end as txt_val
from
(select
 'drug_exposure' as tbnm
,*
from proportion_rawdata
where specialty_concept_id = '4010577') pr1
inner join
(select
 'drug_exposure' as tbnm
,*
from proportion_rawdata
where specialty_concept_id = '4010474') pr2
on pr1.tbnm = pr2.tbnm
