/*************************************************************************/
--  Assigment: Conformance- value
--  Description: this medical dept could not prescribe the procedure
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  this medical dept could not prescribe the drug
--  Language: MSSQL
--  Target data: cdm
--> visit_detail, visit_occurrence, provider, person, care_site, death
-- /*************************************************************************/

insert into @resultSchema.score_log_CDM
select
case
 when co1.stratum2 like '%type_concept_id' then 'C55'
 when co1.stratum2 = 'gender_concept_id' then 'C56'
 when co1.stratum2 = 'race_concept_id' then 'C57'
 when co1.stratum2 = 'ethnicity_concept_id' then 'C58'
 when co1.stratum2 = 'place_of_service_concept_id' then 'C59'
 else 'C54'
end as check_id
,s1.tb_id
,co1.tbnm as stratum1
,co1.stratum2 as stratum2
,co1.stratum3 as stratum3
,null as stratum4
,null as stratum5
,co1.stratum1 as err_no
from
(select
 cv1.*
,case
--> visit_detial & visit_occurrence :: discharge_to_concept_id
	when (cv1.tbnm = 'visit_detail' and cv1.stratum2 = 'visit_detail_concept_id') and cp1.domain_id = 'Visit' then 'N'
  when cv1.tbnm = 'visit_detail' and cv1.stratum2 = 'visit_detail_type_concept_id' and (cp1.domain_id = 'Type Concept' and cp1.concept_class_id = 'Visit Type') then 'N'
  when (cv1.tbnm = 'visit_detail' and cv1.stratum2 = 'discharge_to_concept_id') and cp1.domain_id = 'Visit' then 'Y'
	when (cv1.tbnm = 'visit_occurrence' and cv1.stratum2 = 'visit_concept_id') and cp1.domain_id = 'Visit' then 'N'
  when cv1.tbnm = 'visit_occurrence' and cv1.stratum2 = 'visit_type_concept_id' and (cp1.domain_id = 'Type Concept' and cp1.concept_class_id = 'Visit Type') then 'N'
  when (cv1.tbnm = 'visit_occurrnece' and cv1.stratum2 = 'discharge_to_concept_id') and cp1.domain_id = 'Visit' then 'Y'
	when (cv1.tbnm = 'provider' and cv1.stratum2 = 'specialty_concept_id') and cp1.domain_id in ('Provider Specialty') then 'N'
  when (cv1.tbnm = 'provider' and cv1.stratum2 = 'gender_concept_id') and cp1.domain_id in ('Gender') then 'N'
	when cv1.tbnm = 'person' and cv1.stratum2 = 'gender_concept_id' and cp1.domain_id = 'Gender'  then 'N'
	when cv1.tbnm = 'person' and cv1.stratum2 = 'race_concept_id' and cp1.domain_id='race' then 'N'
	when cv1.tbnm = 'person' and cv1.stratum2 = 'ethnicity_concept_id' and cp1.domain_id='ethnicity' then 'N'
	when cv1.tbnm = 'care_site' and cp1.domain_id='Place of Service' then 'N'
	when (cv1.tbnm = 'death' and cv1.stratum2= 'death_type_concept_id') and (cp1.domain_id = 'Type Concept' and cp1.concept_class_id = 'Death Type') then 'N'
  when (cv1.tbnm = 'death' and cv1.stratum2= 'cause_concept_id') and cp1.domain_id in ('Condition','Condition/Device','Condition/Meas','Condition/Obs','Condition/Procedure') then 'N'
  when cv1.stratum3 = 0 then 'N'
  else 'Y'
 end as err_gb
from
  (select
		'visit_detail'as tbnm
		,visit_detail_id as stratum1
		,	'visit_detail_concept_id' as stratum2
		,	visit_detail_concept_id as stratum3
from @cdmSchema.visit_detail
where visit_detail_concept_id is not null
union all
select
			 'visit_detail'as tbnm
		,visit_detail_id as stratum1
		,'visit_detail_type_concept_id' as stratum2
		,	visit_detail_type_concept_id as stratum3
from @cdmSchema.visit_detail
where visit_detail_type_concept_id is not null
 union all
select
		'visit_detail'as tbnm
		,visit_detail_id as stratum1
		,'discharge_to_concept_id' as stratum2
		,	discharge_to_concept_id as stratum3
from @cdmSchema.visit_detail
where discharge_to_concept_id is not null
union all
select
		'visit_occurrence'as tbnm
		,visit_occurrence_id as stratum1
		,	'visit_concept_id' as stratum2
		,	visit_concept_id as stratum3
from @cdmSchema.visit_occurrence
where visit_concept_id is not null
union all
select
		'visit_occurrence'as tbnm
		,visit_occurrence_id as stratum1
		,	'visit_type_concept_id' as stratum2
		,	visit_type_concept_id as stratum3
from @cdmSchema.visit_occurrence
where visit_type_concept_id is not null
 union all
select
		'visit_occurrence'as tbnm
		,visit_occurrence_id as stratum1
		,'discharge_to_concept_id' as stratum2
		,	discharge_to_concept_id as stratum3
from @cdmSchema.visit_occurrence
where discharge_to_concept_id is not null
union all
select
		'provider'as tbnm
		,provider_id as stratum1
		,'specialty_concept_id' as stratum2
		,	specialty_concept_id as stratum3
from @cdmSchema.provider
where specialty_concept_id is not null
union all
select
		'provider'as tbnm
		,provider_id as stratum1
		,'gender_concept_id' as stratum2
		,	gender_concept_id as stratum3
from @cdmSchema.provider
where gender_concept_id is not null
union all
select
		'person'as tbnm
		,person_id as stratum1
		,	'gender_concept_id' as stratum2
		,	gender_concept_id as stratum3
from @cdmSchema.person
where gender_concept_id is not null
union all
select
		'person'as tbnm
		,person_id as stratum1
		,	'race_concept_id' as stratum2
		,	race_concept_id as stratum3
from @cdmSchema.person
where race_concept_id is not null
union all
select
		'person'as tbnm
		,person_id as stratum1
		,	'ethnicity_concept_id' as stratum2
		,	ethnicity_concept_id as stratum3
from @cdmSchema.person
where ethnicity_concept_id is not null
union all
select
		'care_site'as tbnm
		,care_site_id as stratum1
		,'place_of_service_concept_id' as stratum2
		,	place_of_service_concept_id as stratum3
from @cdmSchema.care_site
	where place_of_service_concept_id is not null
union all
select
		'death'as tbnm
		,person_id as stratum1
		,'death_type_concept_id' as stratum2
		,death_type_concept_id as stratum3
from @cdmSchema.death
where death_type_concept_id is not null
union all
select
	 'death'as tbnm
	 ,person_id as stratum1
	 ,'cause_concept_id' as stratum2
	 ,cause_concept_id as stratum3
from @cdmSchema.death
where cause_concept_id is not null	) as cv1
inner join
		(select
				 concept_id
				,domain_id
        ,concept_class_id
		 		from
						 @cdmSchema.concept
			where invalid_reason is null ) as cp1
on cp1.concept_id = cv1.stratum3 ) as co1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
  where stage_gb= 'CDM') as s1
on s1.tbnm = co1.tbnm
where co1.err_gb = 'Y'
