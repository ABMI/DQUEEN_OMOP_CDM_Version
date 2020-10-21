--daliyVisitType1 (META Visit : Daily visit count by visit type)
select
case
  when stratum2 = 262 then 'Emergency Room and Inpatient Visit'
  when stratum2 = 9201 then 'Inpatient Visit'
  when stratum2 = 9202 then 'Outpatient Visit'
  when stratum2 = 9203 then 'Emergency Room Visit'
  else null
 end as patfg
,cast(stratum4 as int) as daily_visit_cnt
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C145';

--daliyVisitType2 (CDM Visit : Daily visit count by visit type)
select
case
  when stratum2 = 262 then 'Emergency Room and Inpatient Visit'
  when stratum2 = 9201 then 'Inpatient Visit'
  when stratum2 = 9202 then 'Outpatient Visit'
  when stratum2 = 9203 then 'Emergency Room Visit'
  else null
 end as patfg
,cast(stratum4 as int) as daily_visit_cnt
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C145';