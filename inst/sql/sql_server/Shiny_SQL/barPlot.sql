--barPlot1 (META Main : DQ error distribution)
select
 case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum3 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D11';

--barPlot2 (META Person : DQ error distribution)
select
 case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum3 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D11';

--barPlot3 (META Visit : DQ error distribution)
select
 case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum3 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D11';

--barPlot4 (CDM Main : DQ error distribution)
select
 case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum3 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D11';

--barPlot5 (CDM Person : DQ error distribution)
select
case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum4 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D14'
and stratum3 = 'person';

--barPlot6 (CDM Visit : DQ error distribution)
select
case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum4 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D14'
and stratum3 = 'visit_occurrence';

--barPlot7 (CDM Provider : DQ error distribution)
select
case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum4 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D14'
and stratum3 = 'provider';

--barPlot8 (CDM Death : DQ error distribution)
select
case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum4 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D14'
and stratum3 = 'death';

--barPlot9 (CDM CareSite : DQ error distribution)
select
case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum4 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D14'
and stratum3 = 'care_site';

--barPlot10 (CDM ConditionOccurence : DQ error distribution)
select
case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum4 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D14'
and stratum3 = 'condition_occurrence';

--barPlot11 (CDM DrugExposure : DQ error distribution)
select
case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum4 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D14'
and stratum3 = 'drug_exposure';

--barPlot12 (CDM DeviceExposure : DQ error distribution)
select
case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum4 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D14'
and stratum3 = 'device_exposure';

--barPlot13 (CDM ProcedureOccurence : DQ error distribution)
select
case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum4 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D14'
and stratum3 = 'procedure_occurrence';

--barPlot14 (CDM Mesurement : DQ error distribution)
select
case
when stratum1 = 'conformance-relation' then 'relation'
when stratum1 = 'plausibility-atemporal' then 'atemporal'
when stratum1 = 'plausibility-uniquness' then 'uniqueness'
when stratum1 = 'conformance-value' then 'value'
else stratum1
end as category
,stratum4 as stratum1
,count_val
from @resultSchema.dq_check_result
where check_id = 'D14'
and stratum3 = 'measurement';