--piePlot1 (META Main : DQ Error Proportion)
select
 s1.stage_gb as stage
,s1.stratum1 as category
,case
when d1.num_val is null then cast(0 as float)
else cast(d1.num_val as float)
end as count_val
from
(select
'CDM' as stage_gb
,stratum1
from @resultSchema.dq_check_result
where check_id = 'D8') as s1
left join
(select
stratum1
,stratum2
,stratum3
,num_val
from @resultSchema.dq_check_result
where check_id = 'D9') as d1
on s1.stage_gb = d1.stratum2
and s1.stratum1 = d1.stratum3;

--piePlot2 (META Person : DQ Error Proportion)
select
 s1.stage_gb as stage
,s1.stratum1 as category
,case
when d1.num_val is null then cast(0 as float)
else cast(d1.num_val as float)
end as count_val
from
(select
'CDM' as stage_gb
,stratum1
from @resultSchema.dq_check_result
where check_id = 'D8') as s1
left join
(select
stratum1
,stratum2
,stratum3
,num_val
from @resultSchema.dq_check_result
where check_id = 'D9') as d1
on s1.stage_gb = d1.stratum2
and s1.stratum1 = d1.stratum3;

--piePlot3 (META Visit : DQ Error Proportion)
select
 s1.stage_gb as stage
,s1.stratum1 as category
,case
when d1.num_val is null then cast(0 as float)
else cast(d1.num_val as float)
end as count_val
from
(select
'CDM' as stage_gb
,stratum1
from @resultSchema.dq_check_result
where check_id = 'D8') as s1
left join
(select
stratum1
,stratum2
,stratum3
,num_val
from @resultSchema.dq_check_result
where check_id = 'D9') as d1
on s1.stage_gb = d1.stratum2
and s1.stratum1 = d1.stratum3;

--piePlot4 (CDM Main : DQ Error Proportion)
select
 s1.stage_gb as stage
,s1.stratum1 as category
,case
when d1.num_val is null then cast(0 as float)
else cast(d1.num_val as float)
end as count_val
from
(select
'CDM' as stage_gb
,stratum1
from @resultSchema.dq_check_result
where check_id = 'D8') as s1
left join
(select
stratum1
,stratum2
,stratum3
,num_val
from @resultSchema.dq_check_result
where check_id = 'D9') as d1
on s1.stage_gb = d1.stratum2
and s1.stratum1 = d1.stratum3;

--piePlot5 (CDM Person : DQ Error Proportion)
select
case
when sub_category = 'conformance-relation' then 'relation'
when sub_category = 'plausibility-atemporal' then 'atemporal'
when sub_category = 'plausibility-uniquness' then 'uniqueness'
when sub_category = 'conformance-value' then 'value'
else sub_category
end as category
,'person' as stratum1
,round(cast(err_rate as float)*100,0) as count_val
from @resultSchema.score_result
where tb_id = 31 and sub_category not in ('Complex','Table score');

--piePlot6 (CDM Visit : DQ Error Proportion)
select
case
when sub_category = 'conformance-relation' then 'relation'
when sub_category = 'plausibility-atemporal' then 'atemporal'
when sub_category = 'plausibility-uniquness' then 'uniqueness'
when sub_category = 'conformance-value' then 'value'
else sub_category
end as category
,'visit_occurrence' as stratum1
,round(cast(err_rate as float)*100,0) as count_val
from @resultSchema.score_result
where tb_id = 38 and sub_category not in ('Complex','Table score');

--piePlot7 (CDM Provider : DQ Error Proportion)
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
where check_id = 'D11'
and stratum3 = 'provider';

--piePlot8 (CDM Death : DQ Error Proportion)
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
where check_id = 'D11'
and stratum3 = 'death';

--piePlot9 (CDM Caresite : DQ Error Proportion)
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
where check_id = 'D11'
and stratum3 = 'care_site';

--piePlot10 (CDM ConditionOccurence : DQ Error Proportion)
select
case
when sub_category = 'conformance-relation' then 'relation'
when sub_category = 'plausibility-atemporal' then 'atemporal'
when sub_category = 'plausibility-uniquness' then 'uniqueness'
when sub_category = 'conformance-value' then 'value'
else sub_category
end as category
,'condition_occurrence' as stratum1
,round(cast(err_rate as float)*100,0) as count_val
from @resultSchema.score_result
where tb_id = 13 and sub_category not in ('Complex','Table score');

--piePlot11 (CDM DrugExposure : DQ Error Proportion)
select
case
when sub_category = 'conformance-relation' then 'relation'
when sub_category = 'plausibility-atemporal' then 'atemporal'
when sub_category = 'plausibility-uniquness' then 'uniqueness'
when sub_category = 'conformance-value' then 'value'
else sub_category
end as category
,'condition_occurrence' as stratum1
,round(cast(err_rate as float)*100,0) as count_val
from @resultSchema.score_result
where tb_id = 20 and sub_category not in ('Complex','Table score');

--piePlot12 (CDM DeviceExposure : DQ Error Proportion)
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
where check_id = 'D11'
and stratum3 = 'device_exposure';

--piePlot13 (CDM ProcedureOccurence : DQ Error Proportion)
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
where check_id = 'D11'
and stratum3 = 'procedure_occurrence';

--piePlot14 (CDM Measurement : DQ Error Proportion)
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
where check_id = 'D11'
and stratum3 = 'measurement';

--piePlot15 (CDM Provider : Proportion of specialty_concept_id)
select
 c1.concept_name as category
,p1.specialty_concept_id as stratum1
,cast(p1.count_val as int) as count_val
from
(select
 specialty_concept_id
,count(*) as count_val
from @cdmSchema.provider
group by specialty_concept_id) as p1
inner join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = p1.specialty_concept_id;

--piePlot16 (CDM Provider : Proportion of care_site_id)
select
 c2.care_site_name as category
,c1.care_site_id as strtum1
,cast(c1.count_val as int) as count_val
from
(select
 care_site_id
,count(*) as count_val
from @cdmSchema.provider
group by care_site_id) as c1
inner join
(select care_site_id, care_site_name from @cdmSchema.care_site) as c2
on c2.care_site_id = c1.care_site_id;

--piePlot17 (CDM Death : Proportion of death_type_concept_id)
select
 c2.CONCEPT_NAME as category
,c1.death_type_concept_id as strtum1
,cast(c1.count_val as int) as count_val
from
(select
 death_type_concept_id
,count(*) as count_val
from @cdmSchema.death
group by death_type_concept_id) as c1
inner join
(select concept_id, concept_name from @cdmSchema.concept) as c2
on c2.concept_id = c1.death_type_concept_id;

--piePlot18 (CDM Death : Proportion of cause_concept_id)
select
 c2.CONCEPT_NAME as category
,c1.cause_concept_id as strtum1
,cast(c1.count_val as int) as count_val
from
(select
 cause_concept_id
,count(*) as count_val
from @cdmSchema.death
group by cause_concept_id) as c1
inner join
(select concept_id, concept_name from @cdmSchema.concept) as c2
on c2.concept_id = c1.cause_concept_id;

--piePlot19 (CDM ConditionOccurence : Proportion of gender)
select
 stratum3 as category
,'Data relation check' as stratum1
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where  stratum1 = '13' and
 check_id in ('C32','C35','C36','C37','C38');

 --piePlot20 (CDM ConditionOccurence : Proportion of condition occurrence)
select
 stratum4 as category
,stratum2 as stratum1
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where  check_id = 'C7' and stratum1 = '13';

--piePlot21 (CDM DrugExposure : Proportion of provider)
select
 stratum3 as category
,'Data relation check' as stratum1
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where  stratum1 = '20' and
 check_id in ('C32','C35','C36','C37','C38');

--piePlot22 (CDM DrugExposure : Proportion of drug exposure)
select
 stratum4 as category
,stratum2 as stratum1
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where  check_id = 'C7' and stratum1 = '20';

--piePlot23 (CDM DeviceExposure : Proportion of provider)
select
 stratum3 as category
,'Data relation check' as stratum1
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where  stratum1 = '16' and
 check_id in ('C32','C35','C36','C37','C38');

--piePlot24 (CDM DeviceExposure : Proportion of device exposure)
select
 stratum4 as category
,stratum2 as stratum1
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where  check_id = 'C7' and stratum1 = '16';

--piePlot25 (CDM ProcedureOccurence : Proportion of provider)
select
 stratum3 as category
,'Data relation check' as stratum1
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where  stratum1 = '32' and
 check_id in ('C32','C35','C36','C37','C38');

--piePlot26 (CDM ProcedureOccurence : Proportion of procedure occurrence)
select
 stratum4 as category
,stratum2 as stratum1
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where  check_id = 'C7' and stratum1 = '32';

--piePlot27 (CDM Measurement : )
select
 stratum3 as category
,'Data relation check' as stratum1
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where  stratum1 = '24' and
 check_id in ('C32','C35','C36','C37','C38');

--piePlot28 (CDM Measurement : )
select
 stratum4 as category
,stratum2 as stratum1
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where  check_id = 'C7' and stratum1 = '24';