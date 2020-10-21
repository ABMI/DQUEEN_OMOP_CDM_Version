/*************************************************************************/
--  Assigment: Plausibility - Atemporal
--  Description: this medical dept could not prescribe the procedure
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  this medical dept could not prescribe the drug
--  Language: MSSQL
--  Target data: cdm
--  Except Note data (temp...)
-- /*************************************************************************/
insert into @resultSchema.score_log_CDM
select
 'C9' as check_id
,si1.tb_id
,uq1.tbnm as stratum1
,uq1.colnm as stratum2
,null as stratum3
,null as stratum3
,null as stratum3
,err_no
from
(
select
 'care_site'as tbnm
,'care_site_id'as colnm
,row_number()over(partition by care_site_id order by care_site_id) as seq
,care_site_id as err_no
from @cdmSchema.care_site
union all
select
 'concept'as tbnm
,'concept_id'as colnm
,row_number()over(partition by concept_id order by concept_id) as seq
,concept_id as err_no
from @cdmSchema.concept
union all
select
 'condition_era'as tbnm
,'condition_era_id'as colnm
,row_number()over(partition by condition_era_id order by condition_era_id) as seq
,condition_era_id as err_no
from @cdmSchema.condition_era
union all
select
 'condition_occurrence'as tbnm
,'condition_occurrence_id'as colnm
,row_number()over(partition by condition_occurrence_id order by condition_occurrence_id) as seq
,condition_occurrence_id as err_no
from @cdmSchema.condition_occurrence
union all
select
 'cost'as tbnm
,'cost_id'as colnm
,row_number()over(partition by cost_id order by cost_id) as seq
,cost_id as err_no
from @cdmSchema.cost
union all
select
 'death'as tbnm
,'person_id'as colnm
,row_number()over(partition by person_id order by person_id) as seq
,person_id as err_no
from @cdmSchema.death
union all
select
'device_exposure'as tbnm
,'device_exposure_id'as colnm
,row_number()over(partition by device_exposure_id order by device_exposure_id) as seq
,device_exposure_id as err_no
from @cdmSchema.device_exposure
union all
select
'dose_era'as tbnm
,'dose_era_id'as colnm
,row_number()over(partition by dose_era_id order by dose_era_id) as seq
,dose_era_id as err_no
from @cdmSchema.dose_era
union all
select
'drug_era'as tbnm
,'drug_era_id'as colnm
,row_number()over(partition by drug_era_id order by drug_era_id) as seq
,drug_era_id as err_no
from @cdmSchema.drug_era
union all
select
'drug_exposure'as tbnm
,'drug_exposure_id'as colnm
,row_number()over(partition by drug_exposure_id order by drug_exposure_id) as seq
,drug_exposure_id as err_no
from @cdmSchema.drug_exposure
union all
select
 'location'as tbnm
,'location_id'as colnm
,row_number()over(partition by location_id order by location_id) as seq
,location_id as err_no
from @cdmSchema.location
union all
select
 'measurement'as tbnm
,'measurement_id'as colnm
,row_number()over(partition by measurement_id order by measurement_id) as seq
,measurement_id as err_no
from @cdmSchema.measurement
union all
select
 'note'as tbnm
,'note_id'as colnm
,row_number()over(partition by note_id order by note_id) as seq
,note_id as err_no
from @cdmSchema.note
union all
select
 'note_nlp'as tbnm
,'note_nlp_id'as colnm
,row_number()over(partition by note_nlp_id order by note_nlp_id) as seq
,note_nlp_id as err_no
from @cdmSchema.note_nlp
union all
select
 'observation'as tbnm
,'observation_id'as colnm
,row_number()over(partition by observation_id order by observation_id) as seq
,observation_id as err_no
from @cdmSchema.observation
union all
select
 'observation_period'as tbnm
,'observation_period_id'as colnm
,row_number()over(partition by observation_period_id order by observation_period_id) as seq
,observation_period_id as err_no
from @cdmSchema.observation_period
union all
select
 'payer_plan_period'as tbnm
,'payer_plan_period_id'as colnm
,row_number()over(partition by payer_plan_period_id order by payer_plan_period_id) as seq
,payer_plan_period_id as err_no
from @cdmSchema.payer_plan_period
union all
select
 'person'as tbnm
,'person_id'as colnm
,row_number()over(partition by person_id order by person_id) as seq
,person_id as err_no
from @cdmSchema.person
union all
select
 'procedure_occurrence'as tbnm
,'procedure_occurrence_id'as colnm
,row_number()over(partition by procedure_occurrence_id order by procedure_occurrence_id) as seq
,procedure_occurrence_id as err_no
from @cdmSchema.procedure_occurrence
union all
select
 'provider'as tbnm
,'provider_id'as colnm
,row_number()over(partition by provider_id order by provider_id) as seq
,provider_id as err_no
from @cdmSchema.provider
union all
select
 'specimen'as tbnm
,'specimen_id'as colnm
,row_number()over(partition by specimen_id order by specimen_id) as seq
,specimen_id as err_no
from @cdmSchema.specimen
union all
select
 'visit_detail'as tbnm
,'visit_detail_id'as colnm
,row_number()over(partition by visit_detail_id order by visit_detail_id) as seq
,visit_detail_id as err_no
from @cdmSchema.visit_detail
union all
select
 'visit_occurrence'as tbnm
,'visit_occurrence_id'as colnm
,row_number()over(partition by visit_occurrence_id order by visit_occurrence_id) as seq
,visit_occurrence_id as err_no
from @cdmSchema.visit_occurrence )as uq1
left join
(select
 distinct tb_id, tbnm
 from @resultSchema.schema_info
 where stage_gb='meta') as si1
on uq1.tbnm = si1.tbnm
where uq1.seq > 1;
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'CDM primary key duplication check' as stratum5
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
where check_id = 'C9'
group by check_id, tb_id,stratum1,stratum2)v

