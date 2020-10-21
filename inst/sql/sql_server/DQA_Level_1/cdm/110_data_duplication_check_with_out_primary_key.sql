/*************************************************************************/
--  Assigment: Plausibility - Atemporal
--  Description: this medical dept could not prescribe the procedure
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  this medical dept could not prescribe the drug
--  Language: MSSQL
--  Target data: cdm
--  Except note data (temp....)
-- /*************************************************************************/
insert into @resultSchema.score_log_CDM
select
 'C10' as check_id
,si1.tb_id
,si1.tbnm as stratum1
,null as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,v1.err_no
from
(select
 row_number() over(partition by care_site_name,place_of_service_concept_id,location_id,care_site_source_value,place_of_service_source_value order by care_site_name,place_of_service_concept_id,location_id,care_site_source_value,place_of_service_source_value) as seq
,care_site_id as err_no
,'care_site' as tbnm
from @cdmSchema.care_site
union all
select
 row_number() over(partition by concept_name,domain_id,vocabulary_id,concept_class_id,standard_concept,concept_code,valid_start_date,valid_end_date,invalid_reason order by concept_name,domain_id,vocabulary_id,concept_class_id,standard_concept,concept_code,valid_start_date,valid_end_date,invalid_reason) as seq
,concept_id as err_no
,'concept' as tbnm
from @cdmSchema.concept
union all
select
 row_number() over(partition by person_id,condition_concept_id,condition_era_start_date,condition_era_end_date,condition_occurrence_count order by person_id,condition_concept_id,condition_era_start_date,condition_era_end_date,condition_occurrence_count) as seq
,condition_era_id as err_no
,'condition_era' as tbnm
from @cdmSchema.condition_era
union all
select
 row_number() over(partition by person_id,condition_concept_id,condition_start_date,condition_start_datetime,condition_end_date,condition_end_datetime,condition_type_concept_id,stop_reason,provider_id,visit_occurrence_id,visit_detail_id,condition_source_value,condition_source_concept_id,condition_status_source_value,condition_status_concept_id order by person_id,condition_concept_id,condition_start_date,condition_start_datetime,condition_end_date,condition_end_datetime,condition_type_concept_id,stop_reason,provider_id,visit_occurrence_id,visit_detail_id,condition_source_value,condition_source_concept_id,condition_status_source_value,condition_status_concept_id) as seq
,condition_occurrence_id as err_no
,'condition_occurrence' as tbnm
from @cdmSchema.condition_occurrence
union all
select
 row_number() over(partition by cost_event_id,cost_domain_id,cost_type_concept_id,currency_concept_id,total_charge,total_cost,total_paid,paid_by_payer,paid_by_patient,paid_patient_copay,paid_patient_coinsurance,paid_patient_deductible,paid_by_primary,paid_ingredient_cost,paid_dispensing_fee,payer_plan_period_id,amount_allowed,revenue_code_concept_id,drg_concept_id,drg_source_value order by cost_event_id,cost_domain_id,cost_type_concept_id,currency_concept_id,total_charge,total_cost,total_paid,paid_by_payer,paid_by_patient,paid_patient_copay,paid_patient_coinsurance,paid_patient_deductible,paid_by_primary,paid_ingredient_cost,paid_dispensing_fee,payer_plan_period_id,amount_allowed,revenue_code_concept_id,drg_concept_id,drg_source_value) as seq
,cost_id as err_no
,'cost' as tbnm
from @cdmSchema.cost
union all
select
 row_number() over(partition by death_date,death_datetime,death_type_concept_id,cause_concept_id,cause_source_value,cause_source_concept_id order by death_date,death_datetime,death_type_concept_id,cause_concept_id,cause_source_value,cause_source_concept_id) as seq
,person_id as err_no
,'death'as tbnm
from @cdmSchema.death
union all
select
 row_number() over(partition by person_id,device_concept_id,device_exposure_start_date,device_exposure_start_datetime,device_exposure_end_date,device_exposure_end_datetime,device_type_concept_id,unique_device_id,quantity,provider_id,visit_occurrence_id,visit_detail_id,device_source_value,device_source_concept_id order by person_id,device_concept_id,device_exposure_start_date,device_exposure_start_datetime,device_exposure_end_date,device_exposure_end_datetime,device_type_concept_id,unique_device_id,quantity,provider_id,visit_occurrence_id,visit_detail_id,device_source_value,device_source_concept_id) as seq
,device_exposure_id as err_no
,'device_exposure' as tbnm
from @cdmSchema.device_exposure
union all
select
 row_number() over(partition by person_id,drug_concept_id,unit_concept_id,dose_value,dose_era_start_date,dose_era_end_date order by person_id,drug_concept_id,unit_concept_id,dose_value,dose_era_start_date,dose_era_end_date) as seq
,dose_era_id as err_no
,'dose_era' as tbnm
from @cdmSchema.dose_era
union all
select
 row_number() over(partition by person_id,drug_concept_id,drug_era_start_date,drug_era_end_date,drug_exposure_count,gap_days order by person_id,drug_concept_id,drug_era_start_date,drug_era_end_date,drug_exposure_count,gap_days) as seq
,drug_era_id as err_no
,'drug_era' as tbnm
from @cdmSchema.drug_era
union all
select
 row_number() over(partition by person_id,drug_concept_id,drug_exposure_start_date,drug_exposure_start_datetime,drug_exposure_end_date,drug_exposure_end_datetime,verbatim_end_date,drug_type_concept_id,stop_reason,refills,quantity,days_supply,sig,route_concept_id,lot_number,provider_id,visit_occurrence_id,visit_detail_id,drug_source_value,drug_source_concept_id,route_source_value,dose_unit_source_value order by person_id,drug_concept_id,drug_exposure_start_date,drug_exposure_start_datetime,drug_exposure_end_date,drug_exposure_end_datetime,verbatim_end_date,drug_type_concept_id,stop_reason,refills,quantity,days_supply,sig,route_concept_id,lot_number,provider_id,visit_occurrence_id,visit_detail_id,drug_source_value,drug_source_concept_id,route_source_value,dose_unit_source_value) as seq
,drug_exposure_id as err_no
,'drug_exposure' as tbnm
from @cdmSchema.drug_exposure
union all
select
 row_number() over(partition by address_1,address_2,city,state,zip,county,location_source_value order by address_1,address_2,city,state,zip,county,location_source_value) as seq
,location_id as err_no
,'location' as tbnm
from @cdmSchema.location
union all
select
 row_number() over(partition by person_id,measurement_concept_id,measurement_date,measurement_datetime,measurement_type_concept_id,operator_concept_id,value_as_number,value_as_concept_id,unit_concept_id,range_low,range_high,provider_id,visit_occurrence_id,visit_detail_id,measurement_source_value,measurement_source_concept_id,unit_source_value,value_source_value order by person_id,measurement_concept_id,measurement_date,measurement_datetime,measurement_type_concept_id,operator_concept_id,value_as_number,value_as_concept_id,unit_concept_id,range_low,range_high,provider_id,visit_occurrence_id,visit_detail_id,measurement_source_value,measurement_source_concept_id,unit_source_value,value_source_value) as seq
,measurement_id as err_no
,'measurement'as tbnm
from @cdmSchema.measurement
union all
select
 row_number() over(partition by person_id,note_date,note_datetime,note_type_concept_id,note_class_concept_id,note_title,note_text,encoding_concept_id,language_concept_id,provider_id,visit_occurrence_id,visit_detail_id,note_source_value order by person_id,note_date,note_datetime,note_type_concept_id,note_class_concept_id,note_title,note_text,encoding_concept_id,language_concept_id,provider_id,visit_occurrence_id,visit_detail_id,note_source_value) as seq
,note_id as err_no
,'note' as tbnm	from @cdmSchema.note
union all
select
 row_number() over(partition by note_id,section_concept_id,snippet,offset,lexical_variant,note_nlp_concept_id,note_nlp_source_concept_id,nlp_system,nlp_date,nlp_datetime,term_exists,term_temporal,term_modifiers order by note_id,section_concept_id,snippet,offset,lexical_variant,note_nlp_concept_id,note_nlp_source_concept_id,nlp_system,nlp_date,nlp_datetime,term_exists,term_temporal,term_modifiers) as seq
,note_nlp_id as err_no
,'note_nlp' as tbnm
from @cdmSchema.note_nlp
union all
select
 row_number() over(partition by person_id,observation_concept_id,observation_date,observation_datetime,observation_type_concept_id,value_as_number,value_as_string,value_as_concept_id,qualifier_concept_id,unit_concept_id,provider_id,visit_occurrence_id,visit_detail_id,observation_source_value,observation_source_concept_id,unit_source_value,qualifier_source_value order by person_id,observation_concept_id,observation_date,observation_datetime,observation_type_concept_id,value_as_number,value_as_string,value_as_concept_id,qualifier_concept_id,unit_concept_id,provider_id,visit_occurrence_id,visit_detail_id,observation_source_value,observation_source_concept_id,unit_source_value,qualifier_source_value) as seq
,observation_id as err_no
,'observation' as tbnm
from @cdmSchema.observation
union all
select
 row_number() over(partition by person_id,observation_period_start_date,observation_period_end_date,period_type_concept_id order by person_id,observation_period_start_date,observation_period_end_date,period_type_concept_id) as seq
,observation_period_id as err_no
,'observation_period' as tbnm
from @cdmSchema.observation_period
union all
select
 row_number() over(partition by person_id,payer_plan_period_start_date,payer_plan_period_end_date,payer_concept_id,payer_source_value,payer_source_concept_id,plan_concept_id,plan_source_value,plan_source_concept_id,sponsor_concept_id,sponsor_source_value,sponsor_source_concept_id,family_source_value,stop_reason_concept_id,stop_reason_source_value,stop_reason_source_concept_id order by person_id,payer_plan_period_start_date,payer_plan_period_end_date,payer_concept_id,payer_source_value,payer_source_concept_id,plan_concept_id,plan_source_value,plan_source_concept_id,sponsor_concept_id,sponsor_source_value,sponsor_source_concept_id,family_source_value,stop_reason_concept_id,stop_reason_source_value,stop_reason_source_concept_id) as seq
,payer_plan_period_id as err_no
,'payer_plan_period' as tbnm
from @cdmSchema.payer_plan_period
union all
select
 row_number() over(partition by gender_concept_id,year_of_birth,month_of_birth,day_of_birth,birth_datetime,race_concept_id,ethnicity_concept_id,location_id,provider_id,care_site_id,person_source_value,gender_source_value,gender_source_concept_id,race_source_value,race_source_concept_id,ethnicity_source_value,ethnicity_source_concept_id order by gender_concept_id,year_of_birth,month_of_birth,day_of_birth,birth_datetime,race_concept_id,ethnicity_concept_id,location_id,provider_id,care_site_id,person_source_value,gender_source_value,gender_source_concept_id,race_source_value,race_source_concept_id,ethnicity_source_value,ethnicity_source_concept_id) as seq
,person_id as err_no
,'person' as tbnm
from @cdmSchema.person
union all
select
 row_number() over(partition by person_id,procedure_concept_id,procedure_date,procedure_datetime,procedure_type_concept_id,modifier_concept_id,quantity,provider_id,visit_occurrence_id,visit_detail_id,procedure_source_value,procedure_source_concept_id,modifier_source_value order by person_id,procedure_concept_id,procedure_date,procedure_datetime,procedure_type_concept_id,modifier_concept_id,quantity,provider_id,visit_occurrence_id,visit_detail_id,procedure_source_value,procedure_source_concept_id,modifier_source_value) as seq
,procedure_occurrence_id as err_no
,'procedure_occurrence' as tbnm
from @cdmSchema.procedure_occurrence
union all
select
 row_number() over(partition by provider_name,NPI,DEA,specialty_concept_id,care_site_id,year_of_birth,gender_concept_id,provider_source_value,specialty_source_value,specialty_source_concept_id,gender_source_value,gender_source_concept_id order by provider_name,NPI,DEA,specialty_concept_id,care_site_id,year_of_birth,gender_concept_id,provider_source_value,specialty_source_value,specialty_source_concept_id,gender_source_value,gender_source_concept_id) as seq
,provider_id as err_no
,'provider' as tbnm
from @cdmSchema.provider
union all
select
 row_number() over(partition by person_id,specimen_concept_id,specimen_type_concept_id,specimen_date,specimen_datetime,quantity,unit_concept_id,anatomic_site_concept_id,disease_status_concept_id,specimen_source_id,specimen_source_value,unit_source_value,anatomic_site_source_value,disease_status_source_value order by person_id,specimen_concept_id,specimen_type_concept_id,specimen_date,specimen_datetime,quantity,unit_concept_id,anatomic_site_concept_id,disease_status_concept_id,specimen_source_id,specimen_source_value,unit_source_value,anatomic_site_source_value,disease_status_source_value) as seq
,specimen_id as err_no
,'specimen'as tbnm
from @cdmSchema.specimen
union all
select
 row_number() over(partition by person_id,visit_detail_concept_id,visit_detail_start_date,visit_detail_start_datetime,visit_detail_end_date,visit_detail_end_datetime,visit_detail_type_concept_id,provider_id,care_site_id,admitting_source_concept_id,discharge_to_concept_id,preceding_visit_detail_id,visit_detail_source_value,visit_detail_source_concept_id,admitting_source_value,discharge_to_source_value,visit_detail_parent_id,visit_occurrence_id order by person_id,visit_detail_concept_id,visit_detail_start_date,visit_detail_start_datetime,visit_detail_end_date,visit_detail_end_datetime,visit_detail_type_concept_id,provider_id,care_site_id,admitting_source_concept_id,discharge_to_concept_id,preceding_visit_detail_id,visit_detail_source_value,visit_detail_source_concept_id,admitting_source_value,discharge_to_source_value,visit_detail_parent_id,visit_occurrence_id) as seq
,visit_detail_id as err_no
,'visit_detail' as tbnm
from @cdmSchema.visit_detail
union all
select
 row_number() over(partition by person_id,visit_concept_id,visit_start_date,visit_start_datetime,visit_end_date,visit_end_datetime,visit_type_concept_id,provider_id,care_site_id,visit_source_value,visit_source_concept_id,admitting_source_concept_id,admitting_source_value,discharge_to_concept_id,discharge_to_source_value,preceding_visit_occurrence_id order by person_id,visit_concept_id,visit_start_date,visit_start_datetime,visit_end_date,visit_end_datetime,visit_type_concept_id,provider_id,care_site_id,visit_source_value,visit_source_concept_id,admitting_source_concept_id,admitting_source_value,discharge_to_concept_id,discharge_to_source_value,preceding_visit_occurrence_id) as seq
,visit_occurrence_id as err_no
 ,'visit_occurrence' as tbnm
from @cdmSchema.visit_occurrence)as v1
join
(select distinct tb_id, tbnm from @resultSchema.schema_info
  where stage_gb = 'CDM') as si1
on si1.tbnm = v1.tbnm
where v1.seq > 1;
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'data duplication check with out primary key' as stratum5
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
  where check_id = 'C10'
group by  check_id,tb_id,stratum1,stratum2)v

