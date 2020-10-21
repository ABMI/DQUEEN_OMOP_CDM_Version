--countBarTypePlot1 (CDM Contion Occurence : Monthly trend of Condition occurrence with visit type)
select
'condition_occurrence' as table_nm
,case
when cast(stratum3 as int) = 262 then 'Emergency Room and Inpatient Visit'
when cast(stratum3 as int) = 9201 then 'Inpatient Visit'
when cast(stratum3 as int) = 9202 then 'Outpatient Visit'
when cast(stratum3 as int) = 9203 then 'Emergency Room Visit'
else null
end as patfg
,stratum2 as visit_year
,cast(count_val as int) as count_val
,p_25
,p_75
,median
from @resultSchema.dq_result_statics
where check_id = 'C194'

order by stratum3, visit_year;
--countBarTypePlot2 (CDM DrugExposure : Monthly trend of Condition occurrence with visit type)
select 'drug_exposure' as table_nm
,case
  when cast(stratum3 as int) = 262 then 'Emergency Room and Inpatient Visit'
  when cast(stratum3 as int) = 9201 then 'Inpatient Visit'
  when cast(stratum3 as int) = 9202 then 'Outpatient Visit'
  when cast(stratum3 as int) = 9203 then 'Emergency Room Visit'
  else null
 end as patfg
,stratum4 as visit_year
,cast(count_val as int) as count_val
,p_25
,p_75
,median
from @resultSchema.dq_result_statics
where check_id = 'C279'
order by stratum3, visit_year;

--countBarTypePlot3 (CDM DeviceExposure : Monthly trend with visit type)
select 'device_exposure' as table_nm
,case
  when cast(stratum4 as int) = 262 then 'Emergency Room and Inpatient Visit'
  when cast(stratum4 as int) = 9201 then 'Inpatient Visit'
  when cast(stratum4 as int) = 9202 then 'Outpatient Visit'
  when cast(stratum4 as int) = 9203 then 'Emergency Room Visit'
  else null
 end as patfg
,stratum3 as visit_year
,cast(count_val as int) as count_val
,p_25
,p_75
,median
from @resultSchema.dq_result_statics
where check_id = 'C319'
order by stratum4, visit_year;

--countBarTypePlot4 (CDM ProcesureOccurence : Monthly trend with visit type)
select
 'procedure_occurrence' as table_nm
,case
  when cast(stratum3 as int) = 262 then 'Emergency Room and Inpatient Visit'
  when cast(stratum3 as int) = 9201 then 'Inpatient Visit'
  when cast(stratum3 as int) = 9202 then 'Outpatient Visit'
  when cast(stratum3 as int) = 9203 then 'Emergency Room Visit'
  else null
 end as patfg
,stratum4 as visit_year
,cast(count_val as int) as count_val
,p_25
,p_75
,median
from @resultSchema.dq_result_statics
where check_id = 'C305'
order by stratum3, visit_year;

--countBarTypePlot5 (CDM Mesurement : Monthly trend with visit type)
select
 'measurement' as table_nm
,case
  when cast(stratum3 as int) = 262 then 'Emergency Room and Inpatient Visit'
  when cast(stratum3 as int) = 9201 then 'Inpatient Visit'
  when cast(stratum3 as int) = 9202 then 'Outpatient Visit'
  when cast(stratum3 as int) = 9203 then 'Emergency Room Visit'
  else null
 end as patfg
,stratum4 as visit_year
,cast(count_val as int) as count_val
,p_25
,p_75
,median
from @resultSchema.dq_result_statics
where check_id = 'C326'
order by stratum3, visit_year;