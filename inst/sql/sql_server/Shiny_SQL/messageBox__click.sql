--meassageBox__click1 (CDM ConditionOccurence : Disease period of once diagnosis with visit type (IQR))
select
 stratum3 as concept_id
,case
when stratum3 is null then 'total'
else c1.concept_name
end as condition_concept_name
,min as min_of_condition_period
,max as max_of_condition_period
,avg as average_of_condition_period
,median as median_of_condition_period
,p_10  as p_10_of_condition_period
,p_25 as p_25_of_condition_period
,p_75 as p_75_of_condition_period
,p_90 as p_90_of_condition_period
from
(select
distinct
stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C199') as d1
left join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = stratum3
order by concept_name;

--meassageBox__click2 (CDM DrugExposure : drug prescription day check by drug concept_level  (IQR))
select
 stratum3 as concept_id
,case
when stratum3 is null then 'total'
else c1.concept_name
end as drug_exposure_concept_name
,min as min_of_drug_exposure_concept_length
,max as max_of_drug_exposure_concept_length
,avg as average_of_drug_exposure_concept_length
,median as median_of_drug_exposure_concept_length
,p_10  as p_10_of_drug_exposure_concept_length
,p_25 as p_25_of_drug_exposure_concept_length
,p_75 as p_75_of_drug_exposure_concept_length
,p_90 as p_90_of_drug_exposure_concept_length
from
(select
distinct
stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C336') as d1
left join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = stratum3
where c1.concept_name is not null
order by concept_name;

--meassageBox__click3 (CDM DrugExposure : Quantity of drug exposure with visit type (IQR))
select
 stratum3 as concept_id
,case
when stratum3 is null then 'total'
else c1.concept_name
end as drug_exposure_concept_name
,min as min_of_daily_drug_prescription_count
,max as max_of_daily_drug_prescription_count
,avg as average_of_daily_drug_prescription_count
,median as median_of_daily_drug_prescription_count
,p_10  as p_10_of_daily_drug_prescription_count
,p_25 as p_25_of_daily_drug_prescription_count
,p_75 as p_75_of_daily_drug_prescription_count
,p_90 as p_90_of_daily_drug_prescription_count
from
(select
distinct
stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C292') as d1
left join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = stratum3
where c1.concept_name is not null
order by concept_name;

--meassageBox__click4 (CDM DeviceExposure : day length of drug exposure)
select
 stratum3 as concept_id
,case
when stratum3 is null then 'total'
else c1.concept_name
end as device_concept_name
,min as min_of_device_expousre_length
,max as max_of_device_expousre_length
,avg as average_of_device_expousre_length
,median as median_of_device_expousre_length
,p_10  as p_10_of_device_expousre_length
,p_25 as p_25_of_device_expousre_length
,p_75 as p_75_of_device_expousre_length
,p_90 as p_90_of_device_expousre_length
from
(select
distinct
stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C321') as d1
left join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = stratum3
order by concept_name;

--messageBox__click5 (CDM ProcedureOccurence : Daily procedure per person)
select
 stratum4 as concept_id
,case
when stratum4 is null then 'total'
else c1.concept_name
end as procedure_concept_name
,min as min_of_daily_procedure
,max as max_of_daily_procedure
,avg as average_of_daily_procedure
,median as median_of_daily_procedure
,p_10  as p_10_of_daily_procedure
,p_25 as p_25_of_daily_procedure
,p_75 as p_75_of_daily_procedure
,p_90 as p_90_of_daily_procedure
from
(select
distinct
stratum4,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C337') as d1
left join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = stratum4
order by concept_name;

--messageBox__click6 (CDM Mesurement : Descriptive statistics)
select
*
from
(select
d1.stratum2 as concept_id
,c1.concept_name
,d1.stratum3 as gender_concept_id
,d1.gender_concept_name
,d1.stratum4
,d1.min
,d1.max
,d1.avg
,d1.stdev
,d1.median
,d1.p_10
,d1.p_25
,d1.p_75
,d1.p_90
from
(select distinct
stratum2
,stratum3
,case
when stratum3 = 8532 then 'F'
when stratum3 = 8507 then 'M'
else null
end as gender_concept_name
,stratum4
,min
,max
,avg
,stdev
,median
,p_10
,p_25
,p_75
,p_90
from @resultSchema.dq_result_statics
where check_id = 'C331') as d1
inner join
(select
concept_id
,concept_name
from @cdmSchema.concept) as c1
on d1.stratum2 = c1.concept_id
where (stratum2 is not null and stratum2 not in (0))
and stratum4 is not null )v;