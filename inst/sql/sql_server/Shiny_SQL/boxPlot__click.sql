--boxPlot__click1 (CDM ConditionOccurence : Disease period of once diagnosis with visit type)
select
 stratum3 as patfg
,cast(stratum4 as int)  as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C199' and stratum3 is not null
and cast(stratum4 as int) >= 0;

--boxPlot__click2 (CDM DrugExposure : drug prescription day check by drug concept_level)
select
 stratum3 as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C336';

--boxPlot__click3 (CDM DrugExposure : Quantity of drug exposure with visit_type)
select
stratum3 as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C292';

--boxPlot__click4 (CDM DeviceExposure : day length)
select
 stratum3 as patfg
,cast(stratum4 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C321';

--boxPlot__click5 (CDM ProcedureOccurence : quantity check)
select
 stratum4 as patfg
,cast(stratum3 as int) as diff_date
,cast(count_val as int) as count_val
from @resultSchema.dq_result_statics
where check_id = 'C337';

--boxPlot__click6 (CDM Measurement : Measurement outlier by gender)
select
 stratum2 as patfg
,stratum5 as diff_date
,count_val
from @resultSchema.dq_result_statics
where check_id = 'C331';
