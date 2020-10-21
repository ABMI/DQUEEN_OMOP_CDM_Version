/*************************************************************************/
--  Assigment: Conformance- value
--  Description: this medical dept could not prescribe the procedure
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  this medical dept could not prescribe the drug
--  Language: MSSQL
--  Target data: cdm
--> procedure_occurrence, specimen, dose_era,drug_era, drug_exposure, drug_strength
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
	when cv1.tbnm = 'procedure_occurrence' and cv1.stratum2= 'procedure_concept_id'
       and cp1.domain_id in ('Condition/Procedure','Device/Procedure','Drug/Procedure','Meas/Procedure','Obs/Procedure','Procedure') then 'N'
	when cv1.tbnm = 'procedure_occurrence' and cv1.stratum2= 'procedure_type_concept_id'
       and( cp1.domain_id = 'Type Concept' and cp1.concept_class_id in ('procedure', 'Procedure Type')) then 'N'
	when (cv1.tbnm = 'specimen' and stratum2 = 'specimen_concept_id') and cp1.domain_id = 'specimen' then 'N'
	when (cv1.tbnm = 'specimen' and stratum2 = 'specimen_type_concept_id') and (cp1.domain_id = 'Type Concept' and cp1.domain_id = 'Specimen Type') then 'N'
	when (cv1.tbnm = 'specimen' and stratum2 = 'unit_concept_id') and cp1.domain_id = 'unit' then 'N'
	when (cv1.tbnm = 'specimen' and stratum2 = 'anatomic_site_concept_id') and cp1.domain_id = 'Spec Anatomic Site' then 'N'
	when (cv1.tbnm = 'specimen' and stratum2 = 'disease_status_concept_id') and cp1.domain_id = 'Spec Disease Status' then 'N'
	when (cv1.tbnm = 'dose_era' and cv1.stratum2 = 'drug_concept_id') and cp1.domain_id in ('Drug','Drug/Procedure') then 'N'
  when (cv1.tbnm = 'dose_era' and cv1.stratum2 = 'unit_concept_id') and cp1.domain_id = 'unit' then 'N'
	when (cv1.tbnm = 'drug_era' and cv1.stratum2 = 'drug_concept_id') and cp1.domain_id in ('Drug','Drug/Procedure') then 'N'
  when (cv1.tbnm = 'drug_exposure' and cv1.stratum2 = 'drug_concept_id') and cp1.domain_id in ('Drug','Drug/Procedure') then 'N'
	when (cv1.tbnm = 'drug_exposure' and cv1.stratum2 = 'drug_type_concept_id') and (cp1.domain_id = 'Type Concept'and cp1.concept_class_id = 'Drug Type') then 'N'
  when (cv1.tbnm = 'drug_exposure' and cv1.stratum2 = 'route_concept_id') and cp1.domain_id = 'Route' then 'N'
	when (cv1.tbnm = 'drug_strength' and cv1.stratum2 = 'drug_concept_id') and cp1.domain_id in ('Drug','Drug/Procedure') then 'N'
	when (cv1.tbnm = 'drug_strength' and cv1.stratum2 = 'ingredient_concept_id') and (cp1.domain_id in ('Drug','Drug/Procedure') and concept_class_id = 'Ingredient') then 'N'
	when (cv1.tbnm = 'drug_strength' and cv1.stratum2 = 'amount_unit_concept_id') and cp1.domain_id ='unit' then 'N'
	when (cv1.tbnm = 'drug_strength' and cv1.stratum2 = 'numerator_unit_concept_id') and cp1.domain_id ='unit' then 'N'
 	when (cv1.tbnm = 'drug_strength' and cv1.stratum2 = 'denominator_unit_concept_id') and cp1.domain_id ='unit' then 'N'
  when cv1.stratum3 = 0 then 'N'
  else 'Y'
 end as err_gb
from
  (
select
		'dose_era'as tbnm
		,dose_era_id as stratum1
		,'drug_concept_id' as stratum2
		,drug_concept_id as stratum3
from @cdmSchema.dose_era
where drug_concept_id is not null
union all
select
		'dose_era'as tbnm
		,dose_era_id as stratum1
		,	'unit_concept_id' as stratum2
		,	unit_concept_id as stratum3
from @cdmSchema.dose_era
where unit_concept_id is not null
union all
select
		'drug_era'as tbnm
		,drug_era_id as stratum1
		,'drug_concept_id' as stratum2
		,	drug_concept_id as stratum3
from @cdmSchema.drug_era
where drug_concept_id is not null
union all
select
		'drug_exposure'as tbnm
		,drug_exposure_id as stratum1
		,	'drug_concept_id' as stratum2
		,	drug_concept_id as stratum3
from @cdmSchema.drug_exposure
where drug_concept_id is not null
union all
select
		'drug_exposure'as tbnm
		,drug_exposure_id as stratum1
		,	'drug_type_concept_id' as stratum2
		,	drug_type_concept_id as stratum3
from @cdmSchema.drug_exposure
where drug_type_concept_id is not null
union all
select
		'drug_exposure'as tbnm
		,drug_exposure_id as stratum1
		,	'route_concept_id' as stratum2
		,	route_concept_id as stratum3
from @cdmSchema.drug_exposure
where route_concept_id is not null
union all
select
		'drug_strength'as tbnm
		,drug_concept_id as stratum1
		,	'drug_concept_id' as stratum2
		,	drug_concept_id as stratum3
from @cdmSchema.drug_strength
where drug_concept_id is not null
union all
select
		'drug_strength'as tbnm
		,drug_concept_id as stratum1
		,	'ingredient_concept_id' as stratum2
		,	ingredient_concept_id as stratum3
from @cdmSchema.drug_strength
where ingredient_concept_id is not null
union all
select
		'drug_strength'as tbnm
		,drug_concept_id as stratum1
		,	'amount_unit_concept_id' as stratum2
		,	amount_unit_concept_id as stratum3
from @cdmSchema.drug_strength
where amount_unit_concept_id is not null or amount_unit_concept_id = ''
union all
select
		'drug_strength'as tbnm
		,drug_concept_id as stratum1
		,	'numerator_unit_concept_id' as stratum2
		,	numerator_unit_concept_id as stratum3
from @cdmSchema.drug_strength
where numerator_unit_concept_id is not null or numerator_unit_concept_id = ''
union all
select
		'drug_strength'as tbnm
		,drug_concept_id as stratum1
		,'denominator_unit_concept_id' as stratum2
		,denominator_unit_concept_id as stratum3
from @cdmSchema.drug_strength
where denominator_unit_concept_id is not null or denominator_unit_concept_id = ''
union all
select
		'procedure_occurrence'as tbnm
		,procedure_occurrence_id as stratum1
		,	'procedure_concept_id' as stratum2
		,	procedure_concept_id as stratum3
from @cdmSchema.procedure_occurrence
where procedure_concept_id is not null
union all
select
		'procedure_occurrence'as tbnm
		,procedure_occurrence_id as stratum1
		,	'procedure_type_concept_id' as stratum2
		,	procedure_type_concept_id as stratum3
from @cdmSchema.procedure_occurrence
where procedure_type_concept_id is not null
/* union all
select
		'procedure_occurrence'as tbnm
		,procedure_occurrence_id as stratum1
		,'modifier_concept_id' as stratum2
		, modifier_concept_id as stratum3
from byun_cdmpv1.dbo.procedure_occurrence
where modifier_concept_id is not null */
union all
select
		'specimen'as tbnm
		,specimen_id as stratum1
		,'specimen_concept_id' as stratum2
		,	specimen_concept_id as stratum3
from @cdmSchema.specimen
where specimen_concept_id is not null
union all
select
		'specimen'as tbnm
		,specimen_id as stratum1
		,	'specimen_type_concept_id' as stratum2
		,	specimen_type_concept_id as stratum3
from @cdmSchema.specimen
where specimen_type_concept_id is not null
union all
select
			 'specimen'as tbnm
		,specimen_id as stratum1
		,	'unit_concept_id' as stratum2
		,	unit_concept_id as stratum3
from @cdmSchema.specimen
where unit_concept_id is not null
union all
select
		'specimen'as tbnm
		,specimen_id as stratum1
		,'anatomic_site_concept_id' as stratum2
		,	anatomic_site_concept_id  as stratum3
from @cdmSchema.specimen
where anatomic_site_concept_id is not null
union all
select
		'specimen'as tbnm
		,specimen_id as stratum1
		,'disease_status_concept_id' as stratum2
		,	disease_status_concept_id as stratum3
from @cdmSchema.specimen
where disease_status_concept_id is not null ) as cv1
inner join
		(select
				 concept_id
				,domain_id
        ,concept_class_id
        ,VOCABULARY_ID
		 		from
						 @cdmSchema.concept
			where invalid_reason is null ) as cp1
on cp1.concept_id = cv1.stratum3 ) as co1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
  where stage_gb= 'CDM') as s1
on s1.tbnm = co1.tbnm
where co1.err_gb in ('Y')
-- procedure_concept_id, drug_concept_id check
insert into @resultSchema.score_log_CDM
select
 case
  when co1.tbnm = 'procedure_occurrence' then 'C61'
  else 'C62'
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
	when cv1.tbnm = 'procedure_occurrence' and cv1.stratum2= 'procedure_concept_id'
       and cp1.domain_id in ('Condition/Procedure','Device/Procedure','Drug/Procedure','Meas/Procedure','Obs/Procedure','Procedure')
       and cp1.VOCABULARY_ID in ('CPT4','ICD9Proc','HCPCS')  then 'N'
	when (cv1.tbnm = 'dose_era' and cv1.stratum2 = 'drug_concept_id') and cp1.domain_id in ('Drug','Drug/Procedure')
        and cp1.VOCABULARY_ID in ('RxNorm','RxNorm Extension') then 'N'
	when (cv1.tbnm = 'drug_era' and cv1.stratum2 = 'drug_concept_id') and cp1.domain_id in ('Drug','Drug/Procedure')
       and cp1.VOCABULARY_ID in ('RxNorm','RxNorm Extension') then 'N'
  when (cv1.tbnm = 'drug_exposure' and cv1.stratum2 = 'drug_concept_id') and cp1.domain_id in ('Drug','Drug/Procedure')
       and cp1.VOCABULARY_ID in ('RxNorm','RxNorm Extension') then 'N'
  when cv1.stratum3 = 0 then 'N'
  else 'Y'
 end as err_gb
from
(
select
		'drug_era'as tbnm
		,drug_era_id as stratum1
		,'drug_concept_id' as stratum2
		,drug_concept_id as stratum3
from @cdmSchema.drug_era
where drug_concept_id is not null
union all
select
		'dose_era'as tbnm
		,dose_era_id as stratum1
		,'drug_concept_id' as stratum2
		,drug_concept_id as stratum3
from @cdmSchema.dose_era
where drug_concept_id is not null
union all
select
		'drug_exposure'as tbnm
		,drug_exposure_id as stratum1
		,	'drug_concept_id' as stratum2
		,	drug_concept_id as stratum3
from @cdmSchema.drug_exposure
where drug_concept_id is not null
union all
select
		'procedure_occurrence'as tbnm
		,procedure_occurrence_id as stratum1
		,	'procedure_concept_id' as stratum2
		,	procedure_concept_id as stratum3
from @cdmSchema.procedure_occurrence
where procedure_concept_id is not null
) as cv1
inner join
		(select
				 concept_id
				,domain_id
        ,concept_class_id
        ,VOCABULARY_ID
		 		from
						 @cdmSchema.concept
			where invalid_reason is null ) as cp1
on cp1.concept_id = cv1.stratum3 ) as co1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
  where stage_gb= 'CDM') as s1
on s1.tbnm = co1.tbnm
where co1.err_gb in ('Y')
