/*************************************************************************/
--  Assigment: Conformance- value
--  Description: this medical dept could not prescribe the procedure
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  this medical dept could not prescribe the drug
--  Language: MSSQL
--  Target data: cdm
--> condition_era, condition_occurrence, cost, observation_period, device_exposure
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
  when cv1.tbnm = 'condition_era' and cp1.domain_id in ('Condition','Condition/Device','Condition/Meas','Condition/Obs','Condition/Procedure') then 'N'
	when (cv1.tbnm = 'condition_occurrence' and cv1.stratum2 = 'condition_concept_id') and
        cp1.domain_id in ('Condition','Condition/Device','Condition/Meas','Condition/Obs','Condition/Procedure') then 'N'
  when (cv1.tbnm = 'condition_occurrence' and cv1.stratum2 = 'condition_type_concept_id') and (cp1.domain_id = 'Type Concept' and concept_class_id = 'Condition Type') then 'N'
	when (cv1.tbnm = 'condition_occurrence' and cv1.stratum2 = 'condition_status_concept_id') and cp1.domain_id in ('Condition','Condition/Obs','Observation')  then 'N'
	when (cv1.tbnm = 'cost' and cv1.stratum2 = 'cost_type_concept_id') and (cp1.domain_id = 'Type concept' and cp1.concept_class_id = 'Cost Type') then 'N'
  when (cv1.tbnm = 'cost' and cv1.stratum2 = 'currency_concept_id') and cp1.domain_id = 'Currency' then 'N'
  when (cv1.tbnm = 'cost' and cv1.stratum2 = 'revenue_code_concept_id') and cp1.domain_id = 'Revenue Code' then 'N'
  --> when (cv1.tbnm = 'cost' and cv1.stratum2 = 'drg_concept_id') and cp1.domain_id = 'Revenue Code' then 'N'
  when (cv1.tbnm = 'device_exposure' and cv1.stratum2 = 'device_concept_id') and cp1.domain_id in ('Device','Device/Procedure') then 'N'
  when (cv1.tbnm = 'device_exposure' and cv1.stratum2 = 'device_type_concept_id') and (cp1.domain_id = 'Type Concept' and cp1.concept_class_id = 'Device Type') then 'N'
	when (cv1.tbnm = 'observation_period' and cv1.stratum2 = 'period_type_concept_id') and (cp1.domain_id = 'Type Concept' and cp1.concept_class_id = 'Obs Period Type') then 'N'
  when cv1.stratum3 = 0 then 'N'
  else 'Y'
 end as err_gb
from
  (select
		'condition_era'as tbnm
		,condition_era_id as stratum1
		,'condition_concept_id' as stratum2
		,	condition_concept_id as stratum3
from @cdmSchema.condition_era
where condition_concept_id is not null
union all
select
	 'condition_occurrence'as tbnm
	 ,condition_occurrence_id as stratum1
	 ,'condition_concept_id' as stratum2
	 ,condition_concept_id as stratum3
from @cdmSchema.condition_occurrence
where condition_concept_id is not null
union all
select
		'condition_occurrence'as tbnm
		,condition_occurrence_id as stratum1
		,'condition_type_concept_id' as stratum2
		,condition_type_concept_id as stratum3
from @cdmSchema.condition_occurrence
where condition_type_concept_id is not null
union all
select
		'condition_occurrence'as tbnm
		,condition_occurrence_id as stratum1
		,'condition_status_concept_id' as stratum2
		,	condition_status_concept_id as stratum3
	from @cdmSchema.condition_occurrence
where condition_status_concept_id is not null
union all
select
		'cost'as tbnm
		,cost_id as stratum1
		,'cost_type_concept_id' as stratum2
		,cost_type_concept_id as stratum3
from @cdmSchema.cost
where cost_type_concept_id is not null
union all
select
		'cost'as tbnm
		,cost_id as stratum1
		,'currency_concept_id' as stratum2
		,currency_concept_id as stratum3
from @cdmSchema.cost
where currency_concept_id is not null
union all
select
		'cost'as tbnm
		,cost_id as stratum1
		,'revenue_code_concept_id' as stratum2
		,revenue_code_concept_id as stratum3
from @cdmSchema.cost
where revenue_code_concept_id is not null
/* union all
select
	 'cost'as tbnm
	 ,cost_id as stratum1
	 ,'drg_concept_id' as stratum2
	 ,drg_concept_id as stratum3
from byun_cdmpv1.dbo.cost
where drg_concept_id is not null */
union all
select
		'device_exposure'as tbnm
		,device_exposure_id as stratum1
		,'device_concept_id' as stratum2
		,device_concept_id as stratum3
from @cdmSchema.device_exposure
where device_concept_id is not null
union all
select
	'device_exposure'as tbnm
	,device_exposure_id as stratum1
	,'device_type_concept_id' as stratum2
	,device_type_concept_id as stratum3
from @cdmSchema.device_exposure
where device_type_concept_id is not null
union all
select
	'observation_period'as tbnm
	,observation_period_id as stratum1
	,'period_type_concept_id' as stratum2
	,period_type_concept_id as stratum3
from @cdmSchema.observation_period
where period_type_concept_id is not null) as cv1
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
-- condition_concept_id SNOMED check
insert into @resultSchema.score_log_CDM
select
 'C60' as check_id
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
  when cv1.tbnm = 'condition_era' and cp1.domain_id in ('Condition','Condition/Device','Condition/Meas','Condition/Obs','Condition/Procedure')
       and cp1.VOCABULARY_ID = 'SNOMED'    then 'N'
	when (cv1.tbnm = 'condition_occurrence' and cv1.stratum2 = 'condition_concept_id') and
        cp1.domain_id in ('Condition','Condition/Device','Condition/Meas','Condition/Obs','Condition/Procedure') and cp1.VOCABULARY_ID = 'SNOMED'  then 'N'
  when cv1.stratum3 = 0 then 'N'
  else 'Y'
 end as err_gb
from
(select
		'condition_era'as tbnm
		,condition_era_id as stratum1
		,'condition_concept_id' as stratum2
		,	condition_concept_id as stratum3
from @cdmSchema.condition_era
where condition_concept_id is not null
union all
select
	 'condition_occurrence'as tbnm
	 ,condition_occurrence_id as stratum1
	 ,'condition_concept_id' as stratum2
	 ,condition_concept_id as stratum3
from @cdmSchema.condition_occurrence
where condition_concept_id is not null) as cv1
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

