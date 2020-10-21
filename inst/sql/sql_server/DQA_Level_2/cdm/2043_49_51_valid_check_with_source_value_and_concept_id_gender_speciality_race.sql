
insert into @resultSchema.score_log_CDM
select
 'C49' as check_id
, 33 as tb_id
,'provider' as stratum1
,'specialty_concept_id' as stratum2
,'specialty_source_value' as stratum3
,null as stratum4
,null as stratum5
,provider_id as err_no
from
(select
 provider_id
,specialty_concept_id
,specialty_source_value
,case
  when specialty_concept_id in (4010577,4010474) and  specialty_source_value is null then 'Y'
  else 'N'
 end as err_gb
from @cdmSchema.provider)v
where err_gb = 'Y';
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,stratum3 as stratum4
,'if the specialty_source_value is null may be specialty_concept_id not to be DR & RN (local rule)' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
  where check_id ='C49' group by check_id, tb_id, stratum1, stratum2, stratum3 ;
---------------------------------------------------------------------------------------------------
with raw_data as (
select
 person_id
,race_concept_id
,race_source_value
,case
    when race_concept_id = '38003585' and race_source_value in (0,1,2,3,4,9) then 'N'
    when (race_concept_id = '45431577' or race_concept_id is null)
           and  (race_source_value in (0,1,2,3,4,9,'') or race_source_value is null) then 'N'
  else 'Y'
 end as race_err_gb
from
(select
 person_id
,race_concept_id
,race_source_value
from
@cdmSchema.person)v
)
insert into @resultSchema.score_log_CDM
select
 'C50' as check_id
,31 as tb_id
,'person' as stratum1
,'race_concept_id' as stratum2
,'race_source_value' as stratum3
,null as stratum4
,null as stratum5
,person_id as err_no
from raw_data
  where race_err_gb = 'Y';
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,'race_source_value' as stratum4
,'compare with race_concept_id and race_sourc_value (only KR)' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
	where check_id = 'C50'
group by check_id,tb_id, stratum1,stratum2;
--
with raw_data as (
select
 tbnm
,colnm
,err_no
,stratum1
,stratum2
,case
    when stratum2 = 'M' and stratum1= '8507' then 'N'
    when stratum2 = 'F' and stratum1= '8532' then 'N'
  else 'Y'
 end as gender_err_gb
from
(select
 'person' as tbnm
,'gender_concept_id' as colnm
,person_id as err_no
,gender_concept_id as stratum1
,gender_source_value collate Korean_Wansung_CI_AS as stratum2
from
@cdmSchema.person
union all
select
 'provider' as tbnm
,'gender_concept_id' as colnm
,provider_id as err_no
,gender_concept_id as stratum1
,gender_source_value as stratum2
from
@cdmSchema.provider
)v)
insert into @resultSchema.score_log_CDM
select
 'C51' as check_id
,s1.tb_id
,r1.tbnm as stratum1
,r1.colnm as stratum2
,'gender_source_value' as stratum3
,null as stratum4
,null as stratum5
,err_no
from raw_data as r1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = r1.tbnm
  where gender_err_gb = 'Y';
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,stratum3 as stratum4
,'compare with gender_concept_id and source_value' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
	where check_id = 'C51'
group by check_id,tb_id, stratum1,stratum2,stratum3;
--
