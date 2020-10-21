--boxPlot1 (META Visit : visit length of one patient)
select
case
when stratum2 = 262 then 'Emergency Room and Inpatient Visit'
when stratum2 = 9201 then 'Inpatient Visit'
when stratum2 = 9202 then 'Outpatient Visit'
when stratum2 = 9203 then 'Emergency Room Visit'
else null
end as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C146' ;

--boxPlot2 (CDM Visit : visit length of one patient)
select
case
when stratum2 = 262 then 'Emergency Room and Inpatient Visit'
when stratum2 = 9201 then 'Inpatient Visit'
when stratum2 = 9202 then 'Outpatient Visit'
when stratum2 = 9203 then 'Emergency Room Visit'
else null
end as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C146' ;

--boxPlot3 (CDM ConditionOccurence : patinets diagnosis per one day)
select
case
when stratum3 = 262 then 'Emergency Room and Inpatient Visit'
when stratum3 = 9201 then 'Inpatient Visit'
when stratum3 = 9202 then 'Outpatient Visit'
when stratum3 = 9203 then 'Emergency Room Visit'
else null
end as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C196'
order by stratum3, stratum4;

--boxPlot4 (CDM ConditionOccurence : Disease period of once diagnosis)
select
case
when stratum3 = 262 then 'Emergency Room and Inpatient Visit'
when stratum3 = 9201 then 'Inpatient Visit'
when stratum3 = 9202 then 'Outpatient Visit'
when stratum3 = 9203 then 'Emergency Room Visit'
else null
end as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C198';

--boxPlot5 (CDM ConditionOccurence : Disease period of once diagnosis with visit type)
select top 1000
 stratum3 as patfg
,cast(stratum4 as int)  as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C199' and stratum3 is not null
and cast(stratum4 as int) >= 0;

--boxPlot6 (CDM DrugExposure : day length of drug exposure)
select
case
when stratum3 = 262 then 'Emergency Room and Inpatient Visit'
when stratum3 = 9201 then 'Inpatient Visit'
when stratum3 = 9202 then 'Outpatient Visit'
when stratum3 = 9203 then 'Emergency Room Visit'
else null
end as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C289';

--boxPlot7 (CDM DrugExposure : drug prescription day check by drug concept_level)
select top 1000
 stratum3 as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C336';

--boxPlot8 (CDM DrugExposure : Quantity of drug exposure with visit_type)
select top 1000
stratum3 as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C292';

--boxPlot9 (CDM DrugExposure : drug prescription day check by drug concept_level)
select
stratum3 as patfg
,cast(stratum4 as float) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C290';

--boxPlot10 (CDM DeviceExposure : day length)
select
 stratum3 as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C321';

--boxPlot11 (CDM DeviceExposure : quantity check)
select
case
when stratum3 = 262 then 'Emergency Room and Inpatient Visit'
when stratum3 = 9201 then 'Inpatient Visit'
when stratum3 = 9202 then 'Outpatient Visit'
when stratum3 = 9203 then 'Emergency Room Visit'
else null
end as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C310';

--boxPlot12 (CDM ProcedureOccurence : quantity check)
select
case
when stratum3 = 262 then 'Emergency Room and Inpatient Visit'
when stratum3 = 9201 then 'Inpatient Visit'
when stratum3 = 9202 then 'Outpatient Visit'
when stratum3 = 9203 then 'Emergency Room Visit'
else null
end as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C293';
