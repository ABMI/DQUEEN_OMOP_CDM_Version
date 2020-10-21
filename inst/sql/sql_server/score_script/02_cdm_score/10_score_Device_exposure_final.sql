IF OBJECT_ID('tempdb..#score_device_exposure_main','U') is not null drop table #score_device_exposure_main 
IF OBJECT_ID('tempdb..#de_Completeness_gb','U') is not null drop table #de_Completeness_gb 
IF OBJECT_ID('tempdb..#de_Conformance_value_gb','U') is not null drop table #de_Conformance_value_gb 
IF OBJECT_ID('tempdb..#de_Conformance_relation_gb','U') is not null drop table #de_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#de_Uniqueness_gb','U') is not null drop table #de_Uniqueness_gb 
IF OBJECT_ID('tempdb..#de_Plausibility_atemporal_gb','U') is not null drop table #de_Plausibility_atemporal_gb 
IF OBJECT_ID('tempdb..#de_Accuracy_gb','U') is not null drop table #de_Accuracy_gb 
IF OBJECT_ID('tempdb..#score_device_exposure_fn','U') is not null drop table #score_device_exposure_fn 
IF OBJECT_ID('tempdb..#device_exposure_score_step1','U') is not null drop table #device_exposure_score_step1 
IF OBJECT_ID('tempdb..#device_exposure_score_step2_c','U') is not null drop table #device_exposure_score_step2_c 
IF OBJECT_ID('tempdb..#device_exposure_score_step2_u','U') is not null drop table #device_exposure_score_step2_u 
IF OBJECT_ID('tempdb..#device_exposure_score_step3_c','U') is not null drop table #device_exposure_score_step3_c 
IF OBJECT_ID('tempdb..#device_exposure_score_step3_u','U') is not null drop table #device_exposure_score_step3_u 
IF OBJECT_ID('tempdb..#score_device_exposure_fn_t','U') is not null drop table #score_device_exposure_fn_t 
IF OBJECT_ID('tempdb..#device_exposure_score_step2_t','U') is not null drop table #device_exposure_score_step2_t 
IF OBJECT_ID('tempdb..#device_exposure_score_step3_t','U') is not null drop table #device_exposure_score_step3_t 

--> 1. order by the table error uniq_number
--> DQ concept of uniq stratum2 null select
--------------------------------------------------------------------------
select
distinct
 tb_id
,stratum2
,err_no as uniq_no
into #score_device_exposure_main
from @resultSchema.score_log_CDM
where tb_id = 16;
--------------------------------------------------------------------------
--> 2. Table error
--> DQ concept list for calculation of DQ score
--> 1. Completeness
--> 2. Conformance-value
--> 3. Conformance-relation
--> 4. Plausibility-Uniqueness
--> 5. Plausibility-Atemporal
--> 6. Accuracy
--------------------------------------------------------------------------
--> 1. Completeness
select
distinct
 sub_category
,stratum2
,err_no
into #de_Completeness_gb
from
(select
 sm1.check_id
,dc1.sub_category
,sm1.tb_id
,sm1.stratum1
,sm1.stratum2
,sm1.stratum3
,sm1.stratum4
,sm1.stratum5
,sm1.err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='Completeness') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =16)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #de_Conformance_value_gb
from
(select
 sm1.check_id
,dc1.sub_category
,sm1.tb_id
,sm1.stratum1
,sm1.stratum2
,sm1.stratum3
,sm1.stratum4
,sm1.stratum5
,sm1.err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='Conformance-value') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =16)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #de_Conformance_relation_gb
from
(select
 sm1.check_id
,dc1.sub_category
,sm1.tb_id
,sm1.stratum1
,sm1.stratum2
,sm1.stratum3
,sm1.stratum4
,sm1.stratum5
,sm1.err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='Conformance-relation') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =16)v
--------------------------------------------------------------------------
--> 4. Plausibility-Uniqueness
select
distinct
 sub_category
,case
   when stratum2 is null then 'Uq'
   else stratum2
  end as stratum2
,err_no
into #de_Uniqueness_gb
from
(select
 sm1.check_id
,dc1.sub_category
,sm1.tb_id
,sm1.stratum1
,sm1.stratum2
,sm1.stratum3
,sm1.stratum4
,sm1.stratum5
,sm1.err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='Uniqueness') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =16)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #de_Plausibility_atemporal_gb
from
(select
 sm1.check_id
,dc1.sub_category
,sm1.tb_id
,sm1.stratum1
,sm1.stratum2
,sm1.stratum3
,sm1.stratum4
,sm1.stratum5
,sm1.err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='Plausibility-Atemporal') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =16)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #de_Accuracy_gb
from
(select
 sm1.check_id
,dc1.sub_category
,sm1.tb_id
,sm1.stratum1
,sm1.stratum2
,sm1.stratum3
,sm1.stratum4
,sm1.stratum5
,sm1.err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='Accuracy') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =16)v
--------------------------------------------------------------------------
--> 3. Lable DQ concept score
--------------------------------------------------------------------------
select
    *
into #score_device_exposure_fn
from
(select
 m1.*
,case
   when cp1.stratum2 is not null then 1
   else 0
  end as completeness_gb
,case
   when cv1.stratum2 is not null then 1
   else 0
  end as conformance_value_gb
,case
   when cr1.stratum2 is not null then 1
   else 0
  end as conformance_relation_gb
,case
   when pa1.stratum2 is not null then 1
   else 0
  end as plausibility_atemporal_gb
,case
   when u1.stratum2 = 'Uq' then 1
   when u1.stratum2 = m1.stratum2 then 1
   else 0
  end as Uniqueness_gb
,case
   when a1.stratum2 is not null then 1
   else 0
  end as Accuracy_gb
from
(select
 tb_id
,stratum2
,uniq_no
from #score_device_exposure_main) as m1
left join
(select
 stratum2
,err_no
 from #de_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #de_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #de_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #de_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #de_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #de_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 4. table uniq_no
--------------------------------------------------------------------------
select
device_exposure_id
into #device_exposure_score_step1
from  @cdmSchema.device_exposure;
--------------------------------------------------------------------------
--> 5. table score
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 s1.device_exposure_id as uniq_no
,case
  when stratum2 = 'device_exposure_id' then completeness_gb
  else 0
 end as device_exposure_id
,case
  when stratum2 = 'person_id' then completeness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'device_concept_id' then completeness_gb
  else 0
 end as device_concept_id
,case
  when stratum2 = 'device_exposure_start_date' then completeness_gb
  else 0
 end as device_exposure_start_date
,case
  when stratum2 = 'device_exposure_start_datetime' then completeness_gb
  else 0
 end as device_exposure_start_datetime
,case
  when stratum2 = 'device_exposure_end_date' then completeness_gb
  else 0
 end as device_exposure_end_date
,case
  when stratum2 = 'device_exposure_end_datetime' then completeness_gb
  else 0
 end as device_exposure_end_datetime
,case
  when stratum2 = 'device_type_concept_id' then completeness_gb
  else 0
 end as device_type_concept_id
,case
  when stratum2 = 'unique_device_id' then completeness_gb
  else 0
 end as unique_device_id
,case
  when stratum2 = 'provider_id' then completeness_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'quantity' then completeness_gb
  else 0
 end as quantity
,case
  when stratum2 = 'visit_occurrence_id' then completeness_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then completeness_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'device_source_value' then completeness_gb
  else 0
 end as device_source_value
,case
  when stratum2 = 'device_source_concept_id' then completeness_gb
  else 0
 end as device_source_concept_id
 into #device_exposure_score_step2_c
from #device_exposure_score_step1 as s1
left join #score_device_exposure_fn as p1
on s1.device_exposure_id = p1.uniq_no
-- 2
select
 s1.device_exposure_id as uniq_no
,case
  when stratum2 = 'device_exposure_id' then conformance_relation_gb
  else 0
 end as device_exposure_id
,case
  when stratum2 = 'person_id' then conformance_relation_gb
  else 0
 end as person_id
,case
  when stratum2 = 'device_concept_id' then conformance_relation_gb
  else 0
 end as device_concept_id
,case
  when stratum2 = 'device_exposure_start_date' then conformance_relation_gb
  else 0
 end as device_exposure_start_date
,case
  when stratum2 = 'device_exposure_start_datetime' then conformance_relation_gb
  else 0
 end as device_exposure_start_datetime
,case
  when stratum2 = 'device_exposure_end_date' then conformance_relation_gb
  else 0
 end as device_exposure_end_date
,case
  when stratum2 = 'device_exposure_end_datetime' then conformance_relation_gb
  else 0
 end as device_exposure_end_datetime
,case
  when stratum2 = 'device_type_concept_id' then conformance_relation_gb
  else 0
 end as device_type_concept_id
,case
  when stratum2 = 'unique_device_id' then conformance_relation_gb
  else 0
 end as unique_device_id
,case
  when stratum2 = 'provider_id' then conformance_relation_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'quantity' then conformance_relation_gb
  else 0
 end as quantity
,case
  when stratum2 = 'visit_occurrence_id' then conformance_relation_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then conformance_relation_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'device_source_value' then conformance_relation_gb
  else 0
 end as device_source_value
,case
  when stratum2 = 'device_source_concept_id' then conformance_relation_gb
  else 0
 end as device_source_concept_id
 into #device_exposure_score_step2_cr
from #device_exposure_score_step1 as s1
left join #score_device_exposure_fn as p1
on s1.device_exposure_id = p1.uniq_no
-- 3
select
 s1.device_exposure_id as uniq_no
,case
  when stratum2 = 'device_exposure_id' then conformance_value_gb
  else 0
 end as device_exposure_id
,case
  when stratum2 = 'person_id' then conformance_value_gb
  else 0
 end as person_id
,case
  when stratum2 = 'device_concept_id' then conformance_value_gb
  else 0
 end as device_concept_id
,case
  when stratum2 = 'device_exposure_start_date' then conformance_value_gb
  else 0
 end as device_exposure_start_date
,case
  when stratum2 = 'device_exposure_start_datetime' then conformance_value_gb
  else 0
 end as device_exposure_start_datetime
,case
  when stratum2 = 'device_exposure_end_date' then conformance_value_gb
  else 0
 end as device_exposure_end_date
,case
  when stratum2 = 'device_exposure_end_datetime' then conformance_value_gb
  else 0
 end as device_exposure_end_datetime
,case
  when stratum2 = 'device_type_concept_id' then conformance_value_gb
  else 0
 end as device_type_concept_id
,case
  when stratum2 = 'unique_device_id' then conformance_value_gb
  else 0
 end as unique_device_id
,case
  when stratum2 = 'provider_id' then conformance_value_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'quantity' then conformance_value_gb
  else 0
 end as quantity
,case
  when stratum2 = 'visit_occurrence_id' then conformance_value_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then conformance_value_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'device_source_value' then conformance_value_gb
  else 0
 end as device_source_value
,case
  when stratum2 = 'device_source_concept_id' then conformance_value_gb
  else 0
 end as device_source_concept_id
 into #device_exposure_score_step2_cv
from #device_exposure_score_step1 as s1
left join #score_device_exposure_fn as p1
on s1.device_exposure_id = p1.uniq_no
-- 4
select
 s1.device_exposure_id as uniq_no
,case
  when stratum2 = 'device_exposure_id' then Uniqueness_gb
  else 0
 end as device_exposure_id
,case
  when stratum2 = 'person_id' then Uniqueness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'device_concept_id' then Uniqueness_gb
  else 0
 end as device_concept_id
,case
  when stratum2 = 'device_exposure_start_date' then Uniqueness_gb
  else 0
 end as device_exposure_start_date
,case
  when stratum2 = 'device_exposure_start_datetime' then Uniqueness_gb
  else 0
 end as device_exposure_start_datetime
,case
  when stratum2 = 'device_exposure_end_date' then Uniqueness_gb
  else 0
 end as device_exposure_end_date
,case
  when stratum2 = 'device_exposure_end_datetime' then Uniqueness_gb
  else 0
 end as device_exposure_end_datetime
,case
  when stratum2 = 'device_type_concept_id' then Uniqueness_gb
  else 0
 end as device_type_concept_id
,case
  when stratum2 = 'unique_device_id' then Uniqueness_gb
  else 0
 end as unique_device_id
,case
  when stratum2 = 'provider_id' then Uniqueness_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'quantity' then Uniqueness_gb
  else 0
 end as quantity
,case
  when stratum2 = 'visit_occurrence_id' then Uniqueness_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then Uniqueness_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'device_source_value' then Uniqueness_gb
  else 0
 end as device_source_value
,case
  when stratum2 = 'device_source_concept_id' then Uniqueness_gb
  else 0
 end as device_source_concept_id
 into #device_exposure_score_step2_u
from #device_exposure_score_step1 as s1
left join #score_device_exposure_fn as p1
on s1.device_exposure_id = p1.uniq_no
-- 5
select
 s1.device_exposure_id as uniq_no
,case
  when stratum2 = 'device_exposure_id' then plausibility_atemporal_gb
  else 0
 end as device_exposure_id
,case
  when stratum2 = 'person_id' then plausibility_atemporal_gb
  else 0
 end as person_id
,case
  when stratum2 = 'device_concept_id' then plausibility_atemporal_gb
  else 0
 end as device_concept_id
,case
  when stratum2 = 'device_exposure_start_date' then plausibility_atemporal_gb
  else 0
 end as device_exposure_start_date
,case
  when stratum2 = 'device_exposure_start_datetime' then plausibility_atemporal_gb
  else 0
 end as device_exposure_start_datetime
,case
  when stratum2 = 'device_exposure_end_date' then plausibility_atemporal_gb
  else 0
 end as device_exposure_end_date
,case
  when stratum2 = 'device_exposure_end_datetime' then plausibility_atemporal_gb
  else 0
 end as device_exposure_end_datetime
,case
  when stratum2 = 'device_type_concept_id' then plausibility_atemporal_gb
  else 0
 end as device_type_concept_id
,case
  when stratum2 = 'unique_device_id' then plausibility_atemporal_gb
  else 0
 end as unique_device_id
,case
  when stratum2 = 'provider_id' then plausibility_atemporal_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'quantity' then plausibility_atemporal_gb
  else 0
 end as quantity
,case
  when stratum2 = 'visit_occurrence_id' then plausibility_atemporal_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then plausibility_atemporal_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'device_source_value' then plausibility_atemporal_gb
  else 0
 end as device_source_value
,case
  when stratum2 = 'device_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as device_source_concept_id
 into #device_exposure_score_step2_ap
from #device_exposure_score_step1 as s1
left join #score_device_exposure_fn as p1
on s1.device_exposure_id = p1.uniq_no
-- 6
select
 s1.device_exposure_id as uniq_no
,case
  when stratum2 = 'device_exposure_id' then Accuracy_gb
  else 0
 end as device_exposure_id
,case
  when stratum2 = 'person_id' then Accuracy_gb
  else 0
 end as person_id
,case
  when stratum2 = 'device_concept_id' then Accuracy_gb
  else 0
 end as device_concept_id
,case
  when stratum2 = 'device_exposure_start_date' then Accuracy_gb
  else 0
 end as device_exposure_start_date
,case
  when stratum2 = 'device_exposure_start_datetime' then Accuracy_gb
  else 0
 end as device_exposure_start_datetime
,case
  when stratum2 = 'device_exposure_end_date' then Accuracy_gb
  else 0
 end as device_exposure_end_date
,case
  when stratum2 = 'device_exposure_end_datetime' then Accuracy_gb
  else 0
 end as device_exposure_end_datetime
,case
  when stratum2 = 'device_type_concept_id' then Accuracy_gb
  else 0
 end as device_type_concept_id
,case
  when stratum2 = 'unique_device_id' then Accuracy_gb
  else 0
 end as unique_device_id
,case
  when stratum2 = 'provider_id' then Accuracy_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'quantity' then Accuracy_gb
  else 0
 end as quantity
,case
  when stratum2 = 'visit_occurrence_id' then Accuracy_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then Accuracy_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'device_source_value' then Accuracy_gb
  else 0
 end as device_source_value
,case
  when stratum2 = 'device_source_concept_id' then Accuracy_gb
  else 0
 end as device_source_concept_id
 into #device_exposure_score_step2_ac
from #device_exposure_score_step1 as s1
left join #score_device_exposure_fn as p1
on s1.device_exposure_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 uniq_no
,sum(device_exposure_id) as device_exposure_id
,sum(person_id) as person_id
,sum(device_concept_id) as device_concept_id
,sum(device_exposure_start_date) as device_exposure_start_date
,sum(device_exposure_start_datetime) as device_exposure_start_datetime
,sum(device_exposure_end_date) as device_exposure_end_date
,sum(device_exposure_end_datetime) as device_exposure_end_datetime
,sum(device_type_concept_id) as device_type_concept_id
,sum(unique_device_id) as unique_device_id
,sum(quantity) as quantity
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(device_source_value) as device_source_value
,sum(device_source_concept_id) as device_source_concept_id
 into #device_exposure_score_step3_c
from #device_exposure_score_step2_c
group by uniq_no
-- 2
select
 uniq_no
,sum(device_exposure_id) as device_exposure_id
,sum(person_id) as person_id
,sum(device_concept_id) as device_concept_id
,sum(device_exposure_start_date) as device_exposure_start_date
,sum(device_exposure_start_datetime) as device_exposure_start_datetime
,sum(device_exposure_end_date) as device_exposure_end_date
,sum(device_exposure_end_datetime) as device_exposure_end_datetime
,sum(device_type_concept_id) as device_type_concept_id
,sum(unique_device_id) as unique_device_id
,sum(quantity) as quantity
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(device_source_value) as device_source_value
,sum(device_source_concept_id) as device_source_concept_id
 into #device_exposure_score_step3_cr
from #device_exposure_score_step2_cr
group by uniq_no
-- 3
select
 uniq_no
,sum(device_exposure_id) as device_exposure_id
,sum(person_id) as person_id
,sum(device_concept_id) as device_concept_id
,sum(device_exposure_start_date) as device_exposure_start_date
,sum(device_exposure_start_datetime) as device_exposure_start_datetime
,sum(device_exposure_end_date) as device_exposure_end_date
,sum(device_exposure_end_datetime) as device_exposure_end_datetime
,sum(device_type_concept_id) as device_type_concept_id
,sum(unique_device_id) as unique_device_id
,sum(quantity) as quantity
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(device_source_value) as device_source_value
,sum(device_source_concept_id) as device_source_concept_id
 into #device_exposure_score_step3_cv
from #device_exposure_score_step2_cv
group by uniq_no
-- 4
select
 uniq_no
,sum(device_exposure_id) as device_exposure_id
,sum(person_id) as person_id
,sum(device_concept_id) as device_concept_id
,sum(device_exposure_start_date) as device_exposure_start_date
,sum(device_exposure_start_datetime) as device_exposure_start_datetime
,sum(device_exposure_end_date) as device_exposure_end_date
,sum(device_exposure_end_datetime) as device_exposure_end_datetime
,sum(device_type_concept_id) as device_type_concept_id
,sum(unique_device_id) as unique_device_id
,sum(quantity) as quantity
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(device_source_value) as device_source_value
,sum(device_source_concept_id) as device_source_concept_id
 into #device_exposure_score_step3_u
from #device_exposure_score_step2_u
group by uniq_no
-- 5
select
 uniq_no
,sum(device_exposure_id) as device_exposure_id
,sum(person_id) as person_id
,sum(device_concept_id) as device_concept_id
,sum(device_exposure_start_date) as device_exposure_start_date
,sum(device_exposure_start_datetime) as device_exposure_start_datetime
,sum(device_exposure_end_date) as device_exposure_end_date
,sum(device_exposure_end_datetime) as device_exposure_end_datetime
,sum(device_type_concept_id) as device_type_concept_id
,sum(unique_device_id) as unique_device_id
,sum(quantity) as quantity
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(device_source_value) as device_source_value
,sum(device_source_concept_id) as device_source_concept_id
 into #device_exposure_score_step3_ap
from #device_exposure_score_step2_ap
group by uniq_no
-- 6
select
 uniq_no
,sum(device_exposure_id) as device_exposure_id
,sum(person_id) as person_id
,sum(device_concept_id) as device_concept_id
,sum(device_exposure_start_date) as device_exposure_start_date
,sum(device_exposure_start_datetime) as device_exposure_start_datetime
,sum(device_exposure_end_date) as device_exposure_end_date
,sum(device_exposure_end_datetime) as device_exposure_end_datetime
,sum(device_type_concept_id) as device_type_concept_id
,sum(unique_device_id) as unique_device_id
,sum(quantity) as quantity
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(device_source_value) as device_source_value
,sum(device_source_concept_id) as device_source_concept_id
 into #device_exposure_score_step3_ac
from #device_exposure_score_step2_ac
group by uniq_no
--------------------------------------------------------------------------
--> 7. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1.
select
 'Completeness score: Device_exposure' as name
,cast(1.0-((
  ((s2.score_device_exposure_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_datetime/m1.max_uniq_no)*0.075)+
  ((s2.score_device_exposure_end_date/m1.max_uniq_no)*0.075)+
  ((s2.score_device_exposure_end_datetime/m1.max_uniq_no)*0.075)+
  ((s2.score_device_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_unique_device_id/m1.max_uniq_no)*0.055)+
  ((s2.score_quantity/max_uniq_no)*0.075)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.035)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.055)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.035)+
  ((s2.score_device_source_value/m1.max_uniq_no)*0.035)+
  ((s2.score_device_source_concept_id/m1.max_uniq_no)*0.035))) as float)
from
(select
 sum(device_exposure_id) as score_device_exposure_id
,sum(person_id) as score_person_id
,sum(device_concept_id) as score_device_concept_id
,sum(device_exposure_start_date) as score_device_exposure_start_date
,sum(device_exposure_start_datetime) as score_device_exposure_start_datetime
,sum(device_exposure_end_date) as score_device_exposure_end_date
,sum(device_exposure_end_datetime) as score_device_exposure_end_datetime
,sum(device_type_concept_id) as score_device_type_concept_id
,sum(unique_device_id) as score_unique_device_id
,sum(quantity) as score_quantity
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(device_source_value) as score_device_source_value
,sum(device_source_concept_id) as score_device_source_concept_id
from #device_exposure_score_step3_c) as s2
cross join
(select count(visit_detail_id) as max_uniq_no from @cdmSchema.device_exposure) as m1
-- 2.
select
 'Conformance-relation score: Device_exposure' as name
,cast(1.0-((
  ((s2.score_device_exposure_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_date/m1.max_uniq_no)*0.04)+
  ((s2.score_device_exposure_start_datetime/m1.max_uniq_no)*0.04)+
  ((s2.score_device_exposure_end_date/m1.max_uniq_no)*0.04)+
  ((s2.score_device_exposure_end_datetime/m1.max_uniq_no)*0.04)+
  ((s2.score_device_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_unique_device_id/m1.max_uniq_no)*0.04)+
  ((s2.score_quantity/max_uniq_no)*0.04)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_source_value/m1.max_uniq_no)*0.04)+
  ((s2.score_device_source_concept_id/m1.max_uniq_no)*0.09))) as float)
from
(select
 sum(device_exposure_id) as score_device_exposure_id
,sum(person_id) as score_person_id
,sum(device_concept_id) as score_device_concept_id
,sum(device_exposure_start_date) as score_device_exposure_start_date
,sum(device_exposure_start_datetime) as score_device_exposure_start_datetime
,sum(device_exposure_end_date) as score_device_exposure_end_date
,sum(device_exposure_end_datetime) as score_device_exposure_end_datetime
,sum(device_type_concept_id) as score_device_type_concept_id
,sum(unique_device_id) as score_unique_device_id
,sum(quantity) as score_quantity
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(device_source_value) as score_device_source_value
,sum(device_source_concept_id) as score_device_source_concept_id
from #device_exposure_score_step3_cr) as s2
cross join
(select count(visit_detail_id) as max_uniq_no from @cdmSchema.device_exposure) as m1
-- 3.
select
 'Conformance-value score: Device_exposure' as name
,cast(1.0-((
  ((s2.score_device_exposure_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_device_exposure_end_date/m1.max_uniq_no)*0.08)+
  ((s2.score_device_exposure_end_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_device_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_unique_device_id/m1.max_uniq_no)*0.05)+
  ((s2.score_quantity/max_uniq_no)*0.075)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.035)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.055)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.035)+
  ((s2.score_device_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_device_source_concept_id/m1.max_uniq_no)*0.03))) as float)
from
(select
 sum(device_exposure_id) as score_device_exposure_id
,sum(person_id) as score_person_id
,sum(device_concept_id) as score_device_concept_id
,sum(device_exposure_start_date) as score_device_exposure_start_date
,sum(device_exposure_start_datetime) as score_device_exposure_start_datetime
,sum(device_exposure_end_date) as score_device_exposure_end_date
,sum(device_exposure_end_datetime) as score_device_exposure_end_datetime
,sum(device_type_concept_id) as score_device_type_concept_id
,sum(unique_device_id) as score_unique_device_id
,sum(quantity) as score_quantity
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(device_source_value) as score_device_source_value
,sum(device_source_concept_id) as score_device_source_concept_id
from #device_exposure_score_step3_cv) as s2
cross join
(select count(visit_detail_id) as max_uniq_no from @cdmSchema.device_exposure) as m1
-- 4.
select
 'Uniqueness score: Device_exposure' as name
,cast(1.0-((
  ((s2.score_device_exposure_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_device_exposure_end_date/m1.max_uniq_no)*0.08)+
  ((s2.score_device_exposure_end_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_device_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_unique_device_id/m1.max_uniq_no)*0.05)+
  ((s2.score_quantity/max_uniq_no)*0.075)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.035)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.055)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.035)+
  ((s2.score_device_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_device_source_concept_id/m1.max_uniq_no)*0.03))) as float)
from
(select
 sum(device_exposure_id) as score_device_exposure_id
,sum(person_id) as score_person_id
,sum(device_concept_id) as score_device_concept_id
,sum(device_exposure_start_date) as score_device_exposure_start_date
,sum(device_exposure_start_datetime) as score_device_exposure_start_datetime
,sum(device_exposure_end_date) as score_device_exposure_end_date
,sum(device_exposure_end_datetime) as score_device_exposure_end_datetime
,sum(device_type_concept_id) as score_device_type_concept_id
,sum(unique_device_id) as score_unique_device_id
,sum(quantity) as score_quantity
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(device_source_value) as score_device_source_value
,sum(device_source_concept_id) as score_device_source_concept_id
from #device_exposure_score_step3_u) as s2
cross join
(select count(visit_detail_id) as max_uniq_no from @cdmSchema.device_exposure) as m1
-- 5.
select
 'Plausibility-Atemporal score: Device_exposure' as name
,cast(1.0-((
  ((s2.score_device_exposure_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_device_exposure_end_date/m1.max_uniq_no)*0.08)+
  ((s2.score_device_exposure_end_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_device_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_unique_device_id/m1.max_uniq_no)*0.05)+
  ((s2.score_quantity/max_uniq_no)*0.08)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.03)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.055)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.035)+
  ((s2.score_device_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_device_source_concept_id/m1.max_uniq_no)*0.03))) as float)
from
(select
 sum(device_exposure_id) as score_device_exposure_id
,sum(person_id) as score_person_id
,sum(device_concept_id) as score_device_concept_id
,sum(device_exposure_start_date) as score_device_exposure_start_date
,sum(device_exposure_start_datetime) as score_device_exposure_start_datetime
,sum(device_exposure_end_date) as score_device_exposure_end_date
,sum(device_exposure_end_datetime) as score_device_exposure_end_datetime
,sum(device_type_concept_id) as score_device_type_concept_id
,sum(unique_device_id) as score_unique_device_id
,sum(quantity) as score_quantity
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(device_source_value) as score_device_source_value
,sum(device_source_concept_id) as score_device_source_concept_id
from #device_exposure_score_step3_ap) as s2
cross join
(select count(visit_detail_id) as max_uniq_no from @cdmSchema.device_exposure) as m1
-- 6.
select
 'Accuracy score: Device_exposure' as name
,cast(1.0-((
  ((s2.score_device_exposure_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_device_exposure_end_date/m1.max_uniq_no)*0.08)+
  ((s2.score_device_exposure_end_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_device_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_unique_device_id/m1.max_uniq_no)*0.35)+
  ((s2.score_quantity/max_uniq_no)*0.05)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.035)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.05)+
  ((s2.score_device_source_value/m1.max_uniq_no)*0.06)+
  ((s2.score_device_source_concept_id/m1.max_uniq_no)*0.03))) as float)
from
(select
 sum(device_exposure_id) as score_device_exposure_id
,sum(person_id) as score_person_id
,sum(device_concept_id) as score_device_concept_id
,sum(device_exposure_start_date) as score_device_exposure_start_date
,sum(device_exposure_start_datetime) as score_device_exposure_start_datetime
,sum(device_exposure_end_date) as score_device_exposure_end_date
,sum(device_exposure_end_datetime) as score_device_exposure_end_datetime
,sum(device_type_concept_id) as score_device_type_concept_id
,sum(unique_device_id) as score_unique_device_id
,sum(quantity) as score_quantity
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(device_source_value) as score_device_source_value
,sum(device_source_concept_id) as score_device_source_concept_id
from #device_exposure_score_step3_ac) as s2
cross join
(select count(visit_detail_id) as max_uniq_no from @cdmSchema.device_exposure) as m1
--------------------------------------------------------------------------
--> 8. Lable DQ concept score
--------------------------------------------------------------------------
select
    *
into #score_device_exposure_fn_t
from
(select
 m1.*
,case
   when cp1.stratum2 is not null then 0.5
   else 0
  end as completeness_gb
,case
   when cv1.stratum2 is not null then 0.1
   else 0
  end as conformance_value_gb
,case
   when cr1.stratum2 is not null then 0.1
   else 0
  end as conformance_relation_gb
,case
   when pa1.stratum2 is not null then 0.1
   else 0
  end as plausibility_atemporal_gb
,case
   when u1.stratum2 = 'Uq' then 0.1
   when u1.stratum2 = m1.stratum2 then 0.1
   else 0
  end as Uniqueness_gb
,case
   when a1.stratum2 is not null then 0.1
   else 0
  end as Accuracy_gb
from
(select
 tb_id
,stratum2
,uniq_no
from #score_device_exposure_main) as m1
left join
(select
 stratum2
,err_no
 from #de_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #de_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #de_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #de_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #de_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #de_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 9. table score
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 s1.device_exposure_id as uniq_no
,case
  when stratum2 = 'device_exposure_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as device_exposure_id
,case
  when stratum2 = 'person_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as person_id
,case
  when stratum2 = 'device_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as device_concept_id
,case
  when stratum2 = 'device_exposure_start_date' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as device_exposure_start_date
,case
  when stratum2 = 'device_exposure_start_datetime' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as device_exposure_start_datetime
,case
  when stratum2 = 'device_exposure_end_date' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as device_exposure_end_date
,case
  when stratum2 = 'device_exposure_end_datetime' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as device_exposure_end_datetime
,case
  when stratum2 = 'device_type_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as device_type_concept_id
,case
  when stratum2 = 'unique_device_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as unique_device_id
,case
  when stratum2 = 'provider_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as provider_id
,case
  when stratum2 = 'quantity' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as quantity
,case
  when stratum2 = 'visit_occurrence_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'device_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as device_source_value
,case
  when stratum2 = 'device_source_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as device_source_concept_id
 into #device_exposure_score_step2_t
from #device_exposure_score_step1  as s1
left join #score_device_exposure_fn_t as p1
on s1.device_exposure_id = p1.uniq_no
--------------------------------------------------------------------------
--> 10. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 uniq_no
,sum(device_exposure_id) as device_exposure_id
,sum(person_id) as person_id
,sum(device_concept_id) as device_concept_id
,sum(device_exposure_start_date) as device_exposure_start_date
,sum(device_exposure_start_datetime) as device_exposure_start_datetime
,sum(device_exposure_end_date) as device_exposure_end_date
,sum(device_exposure_end_datetime) as device_exposure_end_datetime
,sum(device_type_concept_id) as device_type_concept_id
,sum(unique_device_id) as unique_device_id
,sum(quantity) as quantity
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(device_source_value) as device_source_value
,sum(device_source_concept_id) as device_source_concept_id
 into #device_exposure_score_step3_t
from #device_exposure_score_step2_t
group by uniq_no
--------------------------------------------------------------------------
--> 11. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 'Table score: Device_exposure' as name
,cast(1.0-((
  ((s2.score_device_exposure_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_device_exposure_start_datetime/m1.max_uniq_no)*0.075)+
  ((s2.score_device_exposure_end_date/m1.max_uniq_no)*0.075)+
  ((s2.score_device_exposure_end_datetime/m1.max_uniq_no)*0.075)+
  ((s2.score_device_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_unique_device_id/m1.max_uniq_no)*0.055)+
  ((s2.score_quantity/max_uniq_no)*0.075)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.035)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.055)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.035)+
  ((s2.score_device_source_value/m1.max_uniq_no)*0.035)+
  ((s2.score_device_source_concept_id/m1.max_uniq_no)*0.035))) as float)
from
(select
 sum(device_exposure_id) as score_device_exposure_id
,sum(person_id) as score_person_id
,sum(device_concept_id) as score_device_concept_id
,sum(device_exposure_start_date) as score_device_exposure_start_date
,sum(device_exposure_start_datetime) as score_device_exposure_start_datetime
,sum(device_exposure_end_date) as score_device_exposure_end_date
,sum(device_exposure_end_datetime) as score_device_exposure_end_datetime
,sum(device_type_concept_id) as score_device_type_concept_id
,sum(unique_device_id) as score_unique_device_id
,sum(quantity) as score_quantity
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(device_source_value) as score_device_source_value
,sum(device_source_concept_id) as score_device_source_concept_id
from #device_exposure_score_step3_t) as s2
cross join
(select count(visit_detail_id) as max_uniq_no from @cdmSchema.device_exposure) as m1