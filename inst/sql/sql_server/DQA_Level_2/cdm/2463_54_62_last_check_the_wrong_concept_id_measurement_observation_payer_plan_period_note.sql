/*************************************************************************/
--  Assigment: Conformance- value
--  Description: this medical dept could not prescribe the procedure
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  this medical dept could not prescribe the drug
--  Language: MSSQL
--  Target data: cdm
--> measurement, observation, payer_plan_period, note, note_nlp
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
 when (cv1.tbnm = 'note' and cv1.stratum2= 'note_type_concept_id') and (cp1.domain_id = 'Type Concept'and concept_class_id = 'Note Type') then 'N'
  when (cv1.tbnm = 'note' and cv1.stratum2= 'note_class_conept_id') and (cp1.domain_id = 'Meas Value'and concept_class_id in('Doc Kind','Doc Role','Doc Setting','Doc Subject Matter','Doc Type of Service')) then 'N'
	when (cv1.tbnm = 'note' and cv1.stratum2= 'encoding_concept_id') and (cp1.domain_id = 'Type Concept'and concept_class_id = 'Metadata') then 'N'
  when (cv1.tbnm = 'note' and cv1.stratum2= 'language_concept_id') and (cp1.domain_id = 'Observation'and concept_class_id = 'Qualifier Value') then 'N'
  when (cv1.tbnm = 'observation' and cv1.stratum2= 'observation_concept_id') and cp1.domain_id in ('Condition/Obs','Obs/Procedure','Observation') then 'N'
  when (cv1.tbnm = 'observation' and cv1.stratum2= 'observation_type_concept_id') and (cp1.domain_id = 'Type Concept' and cp1.concept_class_id = 'Observation Type') then 'N'
  when (cv1.tbnm = 'observation' and cv1.stratum2= 'value_as_concept_id') and (cp1.domain_id in ('Observation','Meas Value') and cp1.concept_class_id = 'Qualifier Value') then 'N'
  when (cv1.tbnm = 'observation' and cv1.stratum2= 'qualifier_concept_id') and cp1.domain_id in ('Observation') then 'N'
  when (cv1.tbnm = 'observation' and cv1.stratum2= 'unit_concept_id') and cp1.domain_id in ('Unit') then 'N'
	when (cv1.tbnm = 'payer_plan_period' and cv1.stratum2= 'payer_concept_id') and cp1.domain_id = 'payer' then 'N'
	when (cv1.tbnm = 'payer_plan_period' and cv1.stratum2= 'plan_concept_id') and (cp1.domain_id = 'plan' and cp1.domain_id in ('Benefit','Metal level')) then 'N'
  when (cv1.tbnm = 'payer_plan_period' and cv1.stratum2= 'sponsor_concept_id') and cp1.domain_id = 'sponsor' then 'N'
  when (cv1.tbnm = 'payer_plan_period' and cv1.stratum2= 'stop_reason_concept_id') and cp1.domain_id = 'Plan Stop Reason' then 'N'
	when (cv1.tbnm = 'measurement' and cv1.stratum2 = 'measurement_concept_id') and cp1.domain_id in ('Measurement','Meas/Procedure') then 'N'
  when (cv1.tbnm = 'measurement' and cv1.stratum2 = 'measurement_type_concept_id') and (cp1.domain_id = 'Type Concept' and cp1.concept_class_id = 'Meas Type') then 'N'
  when (cv1.tbnm = 'measurement' and cv1.stratum2 = 'operator_concept_id') and (cp1.domain_id in ('Meas Value Operator','Meas Value') and cp1.concept_class_id ='Qualifier Value') then 'N'
  when (cv1.tbnm = 'measurement' and cv1.stratum2 = 'value_as_concept_id') and cp1.domain_id = 'Meas Value' then 'N'
  when (cv1.tbnm = 'measurement' and cv1.stratum2 = 'unit_concept_id') and cp1.domain_id = 'Unit' then 'N'
  when cv1.stratum3 = 0 then 'N'
  else 'Y'
 end as err_gb
from
  (
select
		'measurement'as tbnm
		,measurement_id as stratum1
		,'measurement_concept_id' as stratum2
		,measurement_concept_id as stratum3
from @cdmSchema.measurement
where measurement_concept_id is not null
union all
select
		'measurement'as tbnm
		,measurement_id as stratum1
		,'measurement_type_concept_id' as stratum2
		,	measurement_type_concept_id as stratum3
from @cdmSchema.measurement
where measurement_type_concept_id is not null
union all
select
		'measurement'as tbnm
		,measurement_id as stratum1
		,	'operator_concept_id' as stratum2
		,	operator_concept_id as stratum3
from @cdmSchema.measurement
where operator_concept_id is not null
union all
select
		'measurement'as tbnm
		,measurement_id as stratum1
		,'value_as_concept_id' as stratum2
		,	value_as_concept_id as stratum3
from @cdmSchema.measurement
where value_as_concept_id is not null
union all
select
		'measurement'as tbnm
		,measurement_id as stratum1
		,'unit_concept_id' as stratum2
		,unit_concept_id as stratum3
from @cdmSchema.measurement
where unit_concept_id is not null
union all
select
		'measurement'as tbnm
		,measurement_id as stratum1
		,'measurement_source_concept_id' as stratum2
		,measurement_source_concept_id as stratum3
from @cdmSchema.measurement
where measurement_source_concept_id is not null
union all
select
		'note'as tbnm
		,note_id as stratum1
		,'note_type_concept_id' as stratum2
		,	note_type_concept_id as stratum3
from @cdmSchema.note
where note_type_concept_id is not null
union all
select
	 'note'as tbnm
		,note_id as stratum1
		,	'note_class_concept_id' as stratum2
		,	note_class_concept_id as stratum3
from @cdmSchema.note
where note_class_concept_id is not null
union all
select
		'note'as tbnm
		,note_id as stratum1
		,'encoding_concept_id' as stratum2
		,	encoding_concept_id
from @cdmSchema.note as stratum3
where encoding_concept_id is not null
union all
select
		'note'as tbnm
		,note_id as stratum1
		,	'language_concept_id' as stratum2
		,	language_concept_id as stratum3
from @cdmSchema.note
where language_concept_id is not null
/* union all
select
		'note_nlp'as tbnm
		,note_nlp_id as stratum1
		,'section_concept_id' as stratum2
		,section_concept_id as stratum3
from @cdmSchema.note_nlp
where section_concept_id is not null
union all
select
		'note_nlp'as tbnm
		,note_nlp_id as stratum1
		,'note_nlp_concept_id' as stratum2
		,	note_nlp_concept_id as stratum3
from @cdmSchema.note_nlp
where note_nlp_concept_id is not null
union all
select
		'note_nlp'as tbnm
		,note_nlp_id as stratum1
		,'note_nlp_source_concept_id' as stratum2
		,note_nlp_source_concept_id as stratum3
from @cdmSchema.note_nlp
where note_nlp_source_concept_id is not null */
union all
select
		'observation'as tbnm
		,observation_id as stratum1
		,'observation_concept_id' as stratum2
		,observation_concept_id as stratum3
from @cdmSchema.observation
where observation_concept_id is not null
union all
select
		'observation'as tbnm
		,observation_id as stratum1
		,'observation_type_concept_id' as stratum2
		,observation_type_concept_id as stratum3
from @cdmSchema.observation
where observation_type_concept_id is not null
union all
select
		'observation'as tbnm
		,observation_id as stratum1
		,'value_as_concept_id' as stratum2
		,value_as_concept_id as stratum3
from @cdmSchema.observation
where value_as_concept_id is not null
union all
select
		'observation'as tbnm
		,observation_id as stratum1
		,'qualifier_concept_id' as stratum2
		,	qualifier_concept_id as stratum3
from @cdmSchema.observation
where qualifier_concept_id is not null
union all
select
		'observation'as tbnm
		,observation_id as stratum1
		,'unit_concept_id' as stratum2
		,	unit_concept_id as stratum3
from @cdmSchema.observation
where unit_concept_id is not null
union all
select
		'observation'as tbnm
		,observation_id as stratum1
		,	'observation_source_concept_id' as stratum2
		,	observation_source_concept_id as stratum3
from @cdmSchema.observation
where observation_source_concept_id is not null
union all
select
		'payer_plan_period'as tbnm
		,payer_plan_period_id as stratum1
		,'payer_concept_id' as stratum2
		,	payer_concept_id as stratum3
from @cdmSchema.payer_plan_period
where payer_concept_id is not null
union all
select
		'payer_plan_period'as tbnm
		,payer_plan_period_id as stratum1
		,	'plan_concept_id' as stratum2
		,	plan_concept_id as stratum3
from @cdmSchema.payer_plan_period
where plan_concept_id is not null
union all
select
		'payer_plan_period'as tbnm
		,payer_plan_period_id as stratum1
		,	'sponsor_concept_id' as stratum2
		,	sponsor_concept_id as stratum3
from @cdmSchema.payer_plan_period
where sponsor_concept_id is not null
union all
select
		'payer_plan_period'as tbnm
		,payer_plan_period_id as stratum1
		,	'stop_reason_concept_id' as stratum2
		,	stop_reason_concept_id as stratum3
from @cdmSchema.payer_plan_period
where stop_reason_concept_id is not null ) as cv1
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
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,case
 when check_id = 'C54' then 'concept from wrong vocabulary: concept_id'
 when check_id = 'C55' then 'concept from wrong vocabulary: type_concept_id'
 when check_id = 'C56' then 'concept from wrong vocabulary: gender;'
 when check_id = 'C57' then 'concept from wrong vocabulary: race;'
 when check_id = 'C58' then 'concept from wrong vocabulary: ethnicity concept id'
 when check_id = 'C59' then 'concept from wrong vocabulary: place of service'
 when check_id = 'C60' then 'concept from wrong vocabulary: condition_concept_id is not SNOMED'
 when check_id = 'C61' then 'concept from wrong vocabulary: Procedure is not CPT, ICD9Proc or HCPCS'
 when check_id = 'C62' then 'concept from wrong vocabulary: Drug is not RxNorm concept'
 else null
end as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id
,stratum1
,stratum2
,count(*) as count_val
from @resultSchema.score_log_CDM
 where check_id in ('C54','C55','C56','C57','C58','C59','C60','C61','C62')
group by check_id, tb_id, stratum1, stratum2)v ;
