--visitDataPlot1 (META Visit : Visit Date by year table)
select
 tbnm
,patfg
,visit_year
,cast(count_val as int) as count_val
,p_25
from
(select
 'visit_occurrence' as tbnm
,case
  when stratum3 = 262 then 'Emergency Room and Inpatient Visit'
  when stratum3 = 9201 then 'Inpatient Visit'
  when stratum3 = 9202 then 'Outpatient Visit'
  when stratum3 = 9203 then 'Emergency Room Visit'
  else null
 end as patfg
,stratum4 as visit_year
,cast(count_val as int) as count_val
,p_25
from @resultSchema.dq_result_statics
where check_id = 'C156')v
order by patfg, visit_year;

--visitDataPlot2 (CDM Visit : Visit Date by year table)
select
 tbnm
,patfg
,visit_year
,cast(count_val as int) as count_val
,p_25
from
(select
 'visit_occurrence' as tbnm
,case
  when stratum3 = 262 then 'Emergency Room and Inpatient Visit'
  when stratum3 = 9201 then 'Inpatient Visit'
  when stratum3 = 9202 then 'Outpatient Visit'
  when stratum3 = 9203 then 'Emergency Room Visit'
  else null
 end as patfg
,stratum4 as visit_year
,cast(count_val as int) as count_val
,p_25
from @resultSchema.dq_result_statics
where check_id = 'C156')v
order by patfg, visit_year;
