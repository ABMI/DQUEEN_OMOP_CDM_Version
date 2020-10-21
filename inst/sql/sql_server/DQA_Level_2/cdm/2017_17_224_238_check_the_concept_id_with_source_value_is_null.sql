/*************************************************************************/
--  Assigment: Conformance- value
--  Description: this medical dept could not prescribe the procedure
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  this medical dept could not prescribe the drug
--  Language: MSSQL
--  Target data: cdm
-- /*************************************************************************/
--
insert into @resultSchema.dq_check_result
select
 case
   when stratum1 = 2 then 'C224'
   when stratum1 = 13 then 'C225'
   when stratum1 = 14 then 'C226'
   when stratum1 = 15 then 'C227'
   when stratum1 = 16 then 'C228'
   when stratum1 = 20 then 'C229'
   when stratum1 = 24 then 'C230'
   when stratum1 = 26 then 'C231'
   when stratum1 = 28 then 'C232'
   when stratum1 = 30 then 'C233'
   when stratum1 = 31 then 'C17'
   when stratum1 = 32 then 'C234'
   when stratum1 = 33 then 'C235'
   when stratum1 = 36 then 'C238'
   when stratum1 = 37 then 'C236'
   when stratum1 = 38 then 'C237'
   else null
 end as check_id
,*
from
(select
 s1.tb_id as stratum1
,cm1.stratum2
,cm1.stratum3
,cm1.stratum4
,'conditional null check that'+cm1.stratum4+' is null but '+stratum3+' is null ' as stratum5
, count_val
,null as num_val
,null as txt_val
from
(select
 'care_site' as stratum2
,'care_site_id' as stratum3
,'care_site_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.care_site
where care_site_id is not null
and care_site_source_value is null
union all
select
 'care_site' as stratum2
,'place_of_service_concept_id' as stratum3
,'place_of_service_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.care_site
where place_of_service_concept_id is not null
and place_of_service_source_value is null
union all
select
 'condition_occurrence' as stratum2
,'condition_concept_id' as stratum3
,'condition_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.condition_occurrence
where condition_concept_id is not null
and condition_source_value is null
union all
select
 'condition_occurrence' as stratum2
,'condition_status_concept_id' as stratum3
,'condition_status_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.condition_occurrence
where condition_status_concept_id is not null
and condition_status_source_value is null
union all
select
 'cost' as stratum2
,'revenue_code_concept_id' as stratum3
,'revenue_code_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.cost
where revenue_code_concept_id is not null
and revenue_code_source_value is null
union all
select
 'cost' as stratum2
,'drg_concept_id' as stratum3
,'drg_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.cost
where drg_concept_id is not null
and drg_source_value is null
union all
select
 'death' as stratum2
,'cause_concept_id' as stratum3
,'cause_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.death
where cause_concept_id is not null
and cause_source_value is null
union all
select
 'device_exposure' as stratum2
,'device_concept_id' as stratum3
,'device_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.device_exposure
where device_concept_id is not null
and device_source_value is null
union all
select
 'drug_exposure' as stratum2
,'route_concept_id' as stratum3
,'route_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.drug_exposure
where route_concept_id is not null
and route_source_value is null
union all
select
 'drug_exposure' as stratum2
,'drug_concept_id' as stratum3
,'drug_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.drug_exposure
where drug_concept_id is not null
and drug_source_value is null
union all
select
 'measurement' as stratum2
,'unit_concept_id' as stratum3
,'unit_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.measurement
where unit_concept_id is not null
and unit_source_value is null
union all
select
 'measurement' as stratum2
,'measurement_concept_id' as stratum3
,'measurement_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.measurement
where measurement_concept_id is not null
and measurement_source_value is null
union all
select
 'measurement' as stratum2
,'operator_concept_id/value_as_number/value_as_concept_id' as stratum3
,'measurement_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.measurement
where (operator_concept_id is not null or value_as_number is not null or value_as_concept_id is not null)
and value_source_value is null
union all
select
 'note' as stratum2
,'note_type_concept_id' as stratum3
,'measurement_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.note
where note_type_concept_id is not null
and note_source_value is null
union all
select
 'observation' as stratum2
,'qualifier_concept_id' as stratum3
,'qualifier_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.observation
where qualifier_concept_id is not null
and qualifier_source_value is null
union all
select
 'observation' as stratum2
,'unit_concept_id' as stratum3
,'unit_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.observation
where unit_concept_id is not null
and unit_source_value is null
union all
select
 'observation' as stratum2
,'observation_concept_id' as stratum3
,'observation_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.observation
where observation_concept_id is not null
and observation_source_value is null
union all
select
 'payer_plan_period' as stratum2
,'stop_reason_concept_id' as stratum3
,'stop_reason_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.payer_plan_period
where stop_reason_concept_id is not null
and stop_reason_source_value is null
union all
select
 'payer_plan_period' as stratum2
,'sponsor_concept_id' as stratum3
,'sponsor_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.payer_plan_period
where sponsor_concept_id is not null
and sponsor_source_value is null
union all
select
 'payer_plan_period' as stratum2
,'plan_concept_id' as stratum3
,'plan_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.payer_plan_period
where plan_concept_id is not null
and plan_source_value is null
union all
select
 'payer_plan_period' as stratum2
,'payer_concept_id' as stratum3
,'payer_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.payer_plan_period
where payer_concept_id is not null
and payer_source_value is null
union all
select
 'person' as stratum2
,'ethnicity_concept_id' as stratum3
,'ethnicity_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.person
where ethnicity_concept_id is not null
and ethnicity_source_value is null
union all
select
 'person' as stratum2
,'race_concept_id' as stratum3
,'race_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.person
where race_concept_id is not null
and race_source_value is null
union all
select
 'person' as stratum2
,'gender_concept_id' as stratum3
,'gender_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.person
where gender_concept_id is not null
and gender_source_value is null
union all
select
 'person' as stratum2
,'person_id' as stratum3
,'person_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.person
where person_id is not null
and person_source_value is null
union all
select
 'procedure_occurrence' as stratum2
,'modifier_concept_id' as stratum3
,'modifier_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.procedure_occurrence
where modifier_concept_id is not null
and modifier_source_value is null
union all
select
 'procedure_occurrence' as stratum2
,'procedure_concept_id' as stratum3
,'procedure_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.procedure_occurrence
where procedure_concept_id is not null
and procedure_source_value is null
union all
select
 'provider' as stratum2
,'provider_id' as stratum3
,'provider_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.provider
where provider_id is not null
and provider_source_value is null
union all
select
 'provider' as stratum2
,'specialty_concept_id' as stratum3
,'specialty_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.provider
where specialty_concept_id is not null
and specialty_source_value is null
union all
select
 'provider' as stratum2
,'gender_concept_id' as stratum3
,'gender_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.provider
where gender_concept_id is not null
and gender_source_value is null
union all
select
 'specimen' as stratum2
,'specimen_concept_id' as stratum3
,'specimen_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.specimen
where specimen_concept_id is not null
and specimen_source_value is null
union all
select
 'specimen' as stratum2
,'unit_concept_id' as stratum3
,'unit_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.specimen
where unit_concept_id is not null
and unit_source_value is null
union all
select
 'specimen' as stratum2
,'anatomic_site_concept_id' as stratum3
,'anatomic_site_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.specimen
where anatomic_site_concept_id is not null
and anatomic_site_source_value is null
union all
select
 'specimen' as stratum2
,'disease_status_concept_id' as stratum3
,'disease_status_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.specimen
where disease_status_concept_id is not null
and disease_status_source_value is null
union all
select
 'visit_detail' as stratum2
,'discharge_to_concept_id' as stratum3
,'discharge_to_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.visit_detail
where discharge_to_concept_id is not null
and discharge_to_source_value is null
union all
select
 'visit_detail' as stratum2
,'visit_detail_concept_id' as stratum3
,'visit_detail_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.visit_detail
where visit_detail_concept_id is not null
and visit_detail_source_value is null
union all
select
 'visit_occurrence' as stratum2
,'visit_concept_id' as stratum3
,'visit_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.visit_occurrence
where visit_concept_id is not null
and visit_source_value is null
union all
select
 'visit_occurrence' as stratum2
,'discharge_to_concept_id' as stratum3
,'discharge_to_source_value' as stratum4
,count(*) as count_val
from
@cdmSchema.visit_occurrence
where discharge_to_concept_id is not null
and discharge_to_source_value is null) as cm1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = cm1.stratum2)v


