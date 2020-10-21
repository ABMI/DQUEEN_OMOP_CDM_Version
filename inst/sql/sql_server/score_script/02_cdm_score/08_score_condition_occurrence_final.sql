IF OBJECT_ID('tempdb..#c_Completeness_gb','U') is not null drop table #c_Completeness_gb 
IF OBJECT_ID('tempdb..#c_Conformance_value_gb','U') is not null drop table #c_Conformance_value_gb 
IF OBJECT_ID('tempdb..#c_Conformance_relation_gb','U') is not null drop table #c_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#D_Uniqueness_gb','U') is not null drop table #D_Uniqueness_gb 
IF OBJECT_ID('tempdb..#c_Uniqueness_gb','U') is not null drop table #c_Uniqueness_gb 
IF OBJECT_ID('tempdb..#c_Plausibility_atemporal_gb','U') is not null drop table #c_Plausibility_atemporal_gb 
IF OBJECT_ID('tempdb..#c_Accuracy_gb','U') is not null drop table #c_Accuracy_gb 

-- Table score calculation (Drug)
--------------------------------------------------------------------------
--> 1. Table error
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
 into #c_Completeness_gb
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
,case
    when sm1.err_no is null or sm1.err_no = '' then 'NA'
    else sm1.err_no
  end as err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='Completeness') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =13)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #c_Conformance_value_gb
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
,case
    when sm1.err_no is null or sm1.err_no = '' then 'NA'
    else sm1.err_no
  end as err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='conformance-value') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =13)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #c_Conformance_relation_gb
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
,case
    when sm1.err_no is null or sm1.err_no = '' then 'NA'
    else sm1.err_no
  end as err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='Conformance-relation') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =13)v
--------------------------------------------------------------------------
--> 4. Plausibility-Uniqueness select * from #D_Uniqueness_gb
select
distinct
 sub_category
,case
   when stratum2 is null or stratum2 = '' then 'Uq'
   else stratum2
  end as stratum2
,err_no
into #c_Uniqueness_gb
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
,case
    when sm1.err_no is null or sm1.err_no = '' then 'NA'
    else sm1.err_no
  end as err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='Uniqueness') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =13)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #c_Plausibility_atemporal_gb
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
,case
    when sm1.err_no is null or sm1.err_no = '' then 'NA'
    else sm1.err_no
  end as err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='Plausibility-Atemporal') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =13)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #c_Accuracy_gb
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
,case
    when sm1.err_no is null or sm1.err_no = '' then 'NA'
    else sm1.err_no
  end as err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check
 where sub_category ='Accuracy') as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id =13)v
--------------------------------------------------------------------------
--> 3. Lable DQ concept score
--------------------------------------------------------------------------
-- 1
select
    *
 into  #score_condition_occurrence_fn_c
from
(select
 stratum2
,err_no as uniq_no
,1 completeness_gb
 from #c_Completeness_gb)v

--2
select
    *
into  #score_condition_occurrence_fn_cv
from
(select
 stratum2
,err_no as uniq_no
, 1 as conformance_value_gb
 from #c_Conformance_value_gb)v ;
-- 3
select
    *
into  #score_condition_occurrence_fn_cr
from
(select
 stratum2
,err_no as uniq_no
,1 as conformance_relation_gb
 from #c_Conformance_relation_gb)v ;
-- 4
select
    *
into  #score_condition_occurrence_fn_ap
from
(select
 stratum2
,err_no as uniq_no
, 1 as plausibility_atemporal_gb
 from #c_Plausibility_atemporal_gb)v ;
-- 5
select
    *
into  #score_condition_occurrence_fn_u
from
(select
 stratum2

,err_no as uniq_no
,1 as Uniqueness_gb
 from #c_Uniqueness_gb)v ;
-- 6
select
    *
into  #score_condition_occurrence_fn_a
from
(
select
 stratum2
,err_no as uniq_no
,1 as Accuracy_gb
 from #c_Accuracy_gb)v ;
--------------------------------------------------------------------------
--> 4. table uniq_no
--------------------------------------------------------------------------
select
condition_occurrence_id
into #condition_occurrence_score_step1
from  @cdmSchema.condition_occurrence;
--------------------------------------------------------------------------
--> 5. table score
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
--1
select
 s1.condition_occurrence_id as uniq_no
,case
  when stratum2 = 'condition_occurrence_id' then completeness_gb
  else 0
 end as condition_occurrence_id
,case
  when stratum2 = 'person_id' then completeness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id'  then completeness_gb
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_start_date' then completeness_gb
  else 0
 end as condition_start_date
,case
  when stratum2 = 'condition_start_datetime' then completeness_gb
  else 0
 end as condition_start_datetime
,case
  when stratum2 = 'condition_end_date' then completeness_gb
  else 0
 end as condition_end_date
,case
  when stratum2 = 'condition_end_datetime' then completeness_gb
  else 0
 end as condition_end_datetime
,case
  when stratum2 = 'condition_type_concept_id' then completeness_gb
  else 0
 end as condition_type_concept_id
,case
  when stratum2 = 'stop_reason' then completeness_gb
  else 0
 end as stop_reason
,case
  when stratum2 = 'provider_id' then completeness_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'visit_occurrence_id' then completeness_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then completeness_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'condition_source_value' then completeness_gb
  else 0
 end as condition_source_value
,case
  when stratum2 = 'condition_source_concept_id' then completeness_gb
  else 0
 end as condition_source_concept_id
,case
  when stratum2 = 'condition_status_source_value' then completeness_gb
  else 0
 end as condition_status_source_value
,case
  when stratum2 = 'condition_status_concept_id' then completeness_gb
  else 0
 end as condition_status_concept_id
 into #condition_occurrence_score_step2_c
from #condition_occurrence_score_step1  as s1
left join #score_condition_occurrence_fn_c as p1
on s1.condition_occurrence_id = p1.uniq_no
-- 2. Conformance-relation
select
 s1.condition_occurrence_id as uniq_no
,case
  when stratum2 = 'person_id' then conformance_relation_gb
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id'  then conformance_relation_gb
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_type_concept_id' then conformance_relation_gb
  else 0
 end as condition_type_concept_id
,case
  when stratum2 = 'provider_id' then conformance_relation_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'visit_occurrence_id' then conformance_relation_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then conformance_relation_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'condition_status_concept_id' then conformance_relation_gb
  else 0
 end as condition_status_concept_id
 into #condition_occurrence_score_step2_cr
from #condition_occurrence_score_step1  as s1
left join #score_condition_occurrence_fn_cr as p1
on s1.condition_occurrence_id = p1.uniq_no
-- 3
select
 s1.condition_occurrence_id as uniq_no
,case
  when stratum2 = 'condition_occurrence_id' then conformance_value_gb
  else 0
 end as condition_occurrence_id
,case
  when stratum2 = 'person_id' then conformance_value_gb
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id'  then conformance_value_gb
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_start_date' then conformance_value_gb
  else 0
 end as condition_start_date
,case
  when stratum2 = 'condition_start_datetime' then conformance_value_gb
  else 0
 end as condition_start_datetime
,case
  when stratum2 = 'condition_end_date' then conformance_value_gb
  else 0
 end as condition_end_date
,case
  when stratum2 = 'condition_end_datetime' then conformance_value_gb
  else 0
 end as condition_end_datetime
,case
  when stratum2 = 'condition_type_concept_id' then conformance_value_gb
  else 0
 end as condition_type_concept_id
,case
  when stratum2 = 'stop_reason' then conformance_value_gb
  else 0
 end as stop_reason
,case
  when stratum2 = 'provider_id' then conformance_value_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'visit_occurrence_id' then conformance_value_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then conformance_value_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'condition_source_value' then conformance_value_gb
  else 0
 end as condition_source_value
,case
  when stratum2 = 'condition_source_concept_id' then conformance_value_gb
  else 0
 end as condition_source_concept_id
,case
  when stratum2 = 'condition_status_source_value' then conformance_value_gb
  else 0
 end as condition_status_source_value
,case
  when stratum2 = 'condition_status_concept_id' then conformance_value_gb
  else 0
 end as condition_status_concept_id
 into #condition_occurrence_score_step2_cv
from #condition_occurrence_score_step1  as s1
left join #score_condition_occurrence_fn_cv as p1
on s1.condition_occurrence_id = p1.uniq_no
--4
select
 s1.condition_occurrence_id as uniq_no
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as condition_occurrence_id
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as person_id
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar)  then Uniqueness_gb
  else 0
 end as condition_concept_id
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as condition_start_date
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as condition_start_datetime
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as condition_end_date
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as condition_end_datetime
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as condition_type_concept_id
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as stop_reason
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar)then Uniqueness_gb
  else 0
 end as provider_id
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as visit_occurrence_id
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as visit_detail_id
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as condition_source_value
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as condition_source_concept_id
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as condition_status_source_value
,case
  when  cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar) then Uniqueness_gb
  else 0
 end as condition_status_concept_id
 into #condition_occurrence_score_step2_u
from #condition_occurrence_score_step1  as s1
left join #score_condition_occurrence_fn_u as p1
on cast(s1.condition_occurrence_id as varchar) = cast(p1.uniq_no as varchar)
--5
select
 s1.condition_occurrence_id as uniq_no
,case
  when stratum2 = 'condition_occurrence_id' then plausibility_atemporal_gb
  else 0
 end as condition_occurrence_id
,case
  when stratum2 = 'person_id' then plausibility_atemporal_gb
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id'  then plausibility_atemporal_gb
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_start_date' then plausibility_atemporal_gb
  else 0
 end as condition_start_date
,case
  when stratum2 = 'condition_start_datetime' then plausibility_atemporal_gb
  else 0
 end as condition_start_datetime
,case
  when stratum2 = 'condition_end_date' then plausibility_atemporal_gb
  else 0
 end as condition_end_date
,case
  when stratum2 = 'condition_end_datetime' then plausibility_atemporal_gb
  else 0
 end as condition_end_datetime
,case
  when stratum2 = 'condition_type_concept_id' then plausibility_atemporal_gb
  else 0
 end as condition_type_concept_id
,case
  when stratum2 = 'stop_reason' then plausibility_atemporal_gb
  else 0
 end as stop_reason
,case
  when stratum2 = 'provider_id' then plausibility_atemporal_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'visit_occurrence_id' then plausibility_atemporal_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then plausibility_atemporal_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'condition_source_value' then plausibility_atemporal_gb
  else 0
 end as condition_source_value
,case
  when stratum2 = 'condition_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as condition_source_concept_id
,case
  when stratum2 = 'condition_status_source_value' then plausibility_atemporal_gb
  else 0
 end as condition_status_source_value
,case
  when stratum2 = 'condition_status_concept_id' then plausibility_atemporal_gb
  else 0
 end as condition_status_concept_id
 into #condition_occurrence_score_step2_ap
from #condition_occurrence_score_step1  as s1
left join #score_condition_occurrence_fn_ap as p1
on s1.condition_occurrence_id = p1.uniq_no

-- 6
select
 s1.condition_occurrence_id as uniq_no
,case
  when stratum2 = 'condition_occurrence_id' then Accuracy_gb
  else 0
 end as condition_occurrence_id
,case
  when stratum2 = 'person_id' then Accuracy_gb
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id'  then Accuracy_gb
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_start_date' then Accuracy_gb
  else 0
 end as condition_start_date
,case
  when stratum2 = 'condition_start_datetime' then Accuracy_gb
  else 0
 end as condition_start_datetime
,case
  when stratum2 = 'condition_end_date' then Accuracy_gb
  else 0
 end as condition_end_date
,case
  when stratum2 = 'condition_end_datetime' then Accuracy_gb
  else 0
 end as condition_end_datetime
,case
  when stratum2 = 'condition_type_concept_id' then Accuracy_gb
  else 0
 end as condition_type_concept_id
,case
  when stratum2 = 'stop_reason' then Accuracy_gb
  else 0
 end as stop_reason
,case
  when stratum2 = 'provider_id' then Accuracy_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'visit_occurrence_id' then Accuracy_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then Accuracy_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'condition_source_value' then Accuracy_gb
  else 0
 end as condition_source_value
,case
  when stratum2 = 'condition_source_concept_id' then Accuracy_gb
  else 0
 end as condition_source_concept_id
,case
  when stratum2 = 'condition_status_source_value' then Accuracy_gb
  else 0
 end as condition_status_source_value
,case
  when stratum2 = 'condition_status_concept_id' then Accuracy_gb
  else 0
 end as condition_status_concept_id
 into #condition_occurrence_score_step2_ac
from #condition_occurrence_score_step1  as s1
left join #score_condition_occurrence_fn_a as p1
on s1.condition_occurrence_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 sum(condition_occurrence_id) as condition_occurrence_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_start_date) as condition_start_date
,sum(condition_start_datetime) as condition_start_datetime
,sum(condition_end_date) as condition_end_date
,sum(condition_end_datetime) as condition_end_datetime
,sum(condition_type_concept_id) as condition_type_concept_id
,sum(stop_reason) as stop_reason
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(condition_source_value) as condition_source_value
,sum(condition_source_concept_id) as condition_source_concept_id
,sum(condition_status_source_value) as condition_status_source_value
,sum(condition_status_concept_id) as condition_status_concept_id
 into #condition_occurrence_score_step3_c
from #condition_occurrence_score_step2_c
group by uniq_no
-- 2
select
 sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_type_concept_id) as condition_type_concept_id
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(condition_status_concept_id) as condition_status_concept_id
 into #condition_occurrence_score_step3_cr
from #condition_occurrence_score_step2_cr
group by uniq_no
-- 3
select
 sum(condition_occurrence_id) as condition_occurrence_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_start_date) as condition_start_date
,sum(condition_start_datetime) as condition_start_datetime
,sum(condition_end_date) as condition_end_date
,sum(condition_end_datetime) as condition_end_datetime
,sum(condition_type_concept_id) as condition_type_concept_id
,sum(stop_reason) as stop_reason
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(condition_source_value) as condition_source_value
,sum(condition_source_concept_id) as condition_source_concept_id
,sum(condition_status_source_value) as condition_status_source_value
,sum(condition_status_concept_id) as condition_status_concept_id
 into #condition_occurrence_score_step3_cv
from #condition_occurrence_score_step2_cv
group by uniq_no
--4
select
 sum(condition_occurrence_id) as condition_occurrence_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_start_date) as condition_start_date
,sum(condition_start_datetime) as condition_start_datetime
,sum(condition_end_date) as condition_end_date
,sum(condition_end_datetime) as condition_end_datetime
,sum(condition_type_concept_id) as condition_type_concept_id
,sum(stop_reason) as stop_reason
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(condition_source_value) as condition_source_value
,sum(condition_source_concept_id) as condition_source_concept_id
,sum(condition_status_source_value) as condition_status_source_value
,sum(condition_status_concept_id) as condition_status_concept_id
 into #condition_occurrence_score_step3_u
from #condition_occurrence_score_step2_u
group by uniq_no
--5
select
 sum(condition_occurrence_id) as condition_occurrence_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_start_date) as condition_start_date
,sum(condition_start_datetime) as condition_start_datetime
,sum(condition_end_date) as condition_end_date
,sum(condition_end_datetime) as condition_end_datetime
,sum(condition_type_concept_id) as condition_type_concept_id
,sum(stop_reason) as stop_reason
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(condition_source_value) as condition_source_value
,sum(condition_source_concept_id) as condition_source_concept_id
,sum(condition_status_source_value) as condition_status_source_value
,sum(condition_status_concept_id) as condition_status_concept_id
 into #condition_occurrence_score_step3_ap
from #condition_occurrence_score_step2_ap
group by uniq_no
--6
select
 sum(condition_occurrence_id) as condition_occurrence_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_start_date) as condition_start_date
,sum(condition_start_datetime) as condition_start_datetime
,sum(condition_end_date) as condition_end_date
,sum(condition_end_datetime) as condition_end_datetime
,sum(condition_type_concept_id) as condition_type_concept_id
,sum(stop_reason) as stop_reason
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(condition_source_value) as condition_source_value
,sum(condition_source_concept_id) as condition_source_concept_id
,sum(condition_status_source_value) as condition_status_source_value
,sum(condition_status_concept_id) as condition_status_concept_id
 into #condition_occurrence_score_step3_ac
from #condition_occurrence_score_step2_ac
group by uniq_no
--------------------------------------------------------------------------
--> 7. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1. Completeness
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,13 as tb_id
,'Completeness' as cateogy
,'Completeness' as sub_cateogry
,((
  ((s2.score_condition_occurrence_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_condition_concept_id/m1.max_uniq_no))+
  ((s2.score_condition_start_date/m1.max_uniq_no))+
  ((s2.score_condition_start_datetime/m1.max_uniq_no))+
  ((s2.score_condition_end_date/m1.max_uniq_no))+
  ((s2.score_condition_end_datetime/m1.max_uniq_no))+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no))+
  ((s2.score_stop_reason/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_condition_source_value/m1.max_uniq_no))+
  ((s2.score_condition_source_concept_id/m1.max_uniq_no))+
  ((s2.score_condition_status_source_value/m1.max_uniq_no))+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no))))/16  as err_rate
,cast(1.0-((
  ((s2.score_condition_occurrence_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_condition_end_date/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_stop_reason/m1.max_uniq_no)*0.03)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.06)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.04)+
  ((s2.score_condition_source_value/m1.max_uniq_no)*0.06)+
  ((s2.score_condition_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_condition_status_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no)*0.03))) as float) as score
from
(select
 cast(sum(condition_occurrence_id) as float) as score_condition_occurrence_id
,cast(sum(person_id) as float)  as score_person_id
,cast(sum(condition_concept_id) as float)  as score_condition_concept_id
,cast(sum(condition_start_date) as float)  as score_condition_start_date
,cast(sum(condition_start_datetime) as float)  as score_condition_start_datetime
,cast(sum(condition_end_date) as float)  as score_condition_end_date
,cast(sum(condition_end_datetime) as float)  as score_condition_end_datetime
,cast(sum(condition_type_concept_id) as float)  as score_condition_type_concept_id
,cast(sum(stop_reason) as float)  as score_stop_reason
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(visit_occurrence_id) as float)  as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float)  as score_visit_detail_id
,cast(sum(condition_source_value) as float)  as score_condition_source_value
,cast(sum(condition_source_concept_id) as float)  as score_condition_source_concept_id
,cast(sum(condition_status_source_value) as float)  as score_condition_status_source_value
,cast(sum(condition_status_concept_id) as float)  as score_condition_status_concept_id
from #condition_occurrence_score_step3_c) as s2
cross join
(select cast(count(condition_occurrence_id) as float)  as max_uniq_no from @cdmSchema.condition_occurrence) as m1
-- 2. value
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,13 as tb_id
,'conformance' as cateogy
,'value' as sub_cateogry
,((
  ((s2.score_condition_occurrence_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_condition_concept_id/m1.max_uniq_no))+
  ((s2.score_condition_start_date/m1.max_uniq_no))+
  ((s2.score_condition_start_datetime/m1.max_uniq_no))+
  ((s2.score_condition_end_date/m1.max_uniq_no))+
  ((s2.score_condition_end_datetime/m1.max_uniq_no))+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no))+
  ((s2.score_stop_reason/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_condition_source_value/m1.max_uniq_no))+
  ((s2.score_condition_source_concept_id/m1.max_uniq_no))+
  ((s2.score_condition_status_source_value/m1.max_uniq_no))+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no))))/16  as err_rate
,cast(1.0-((
  ((s2.score_condition_occurrence_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_condition_end_date/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_stop_reason/m1.max_uniq_no)*0.03)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.06)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.04)+
  ((s2.score_condition_source_value/m1.max_uniq_no)*0.06)+
  ((s2.score_condition_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_condition_status_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no)*0.03))) as float) as score
from
(select
 cast(sum(condition_occurrence_id) as float) as score_condition_occurrence_id
,cast(sum(person_id) as float)  as score_person_id
,cast(sum(condition_concept_id) as float)  as score_condition_concept_id
,cast(sum(condition_start_date) as float)  as score_condition_start_date
,cast(sum(condition_start_datetime) as float)  as score_condition_start_datetime
,cast(sum(condition_end_date) as float)  as score_condition_end_date
,cast(sum(condition_end_datetime) as float)  as score_condition_end_datetime
,cast(sum(condition_type_concept_id) as float)  as score_condition_type_concept_id
,cast(sum(stop_reason) as float)  as score_stop_reason
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(visit_occurrence_id) as float)  as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float)  as score_visit_detail_id
,cast(sum(condition_source_value) as float)  as score_condition_source_value
,cast(sum(condition_source_concept_id) as float)  as score_condition_source_concept_id
,cast(sum(condition_status_source_value) as float)  as score_condition_status_source_value
,cast(sum(condition_status_concept_id) as float)  as score_condition_status_concept_id
from #condition_occurrence_score_step3_cv) as s2
cross join
(select cast(count(condition_occurrence_id) as float)  as max_uniq_no from @cdmSchema.condition_occurrence) as m1
-- 3. relation
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,13 as tb_id
,'conformance' as cateogy
,'relation' as sub_cateogry
,((
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_condition_concept_id/m1.max_uniq_no))+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no))))/7  as err_rate
,cast(1.0-((
  ((s2.score_person_id/m1.max_uniq_no)*0.15)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.15)+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no)*0.15)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.15)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.15)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.15)+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no)*0.1))) as float) as score
from
(select
 cast(sum(person_id) as float)  as score_person_id
,cast(sum(condition_concept_id) as float)  as score_condition_concept_id
,cast(sum(condition_type_concept_id) as float)  as score_condition_type_concept_id
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(visit_occurrence_id) as float)  as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float)  as score_visit_detail_id
,cast(sum(condition_status_concept_id) as float)  as score_condition_status_concept_id
from #condition_occurrence_score_step3_cr) as s2
cross join
(select cast(count(condition_occurrence_id) as float)  as max_uniq_no from @cdmSchema.condition_occurrence) as m1
-- 4. uniqueness
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,13 as tb_id
,'plausibility' as cateogy
,'uniqueness' as sub_cateogry
,((
  ((s2.score_condition_occurrence_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_condition_concept_id/m1.max_uniq_no))+
  ((s2.score_condition_start_date/m1.max_uniq_no))+
  ((s2.score_condition_start_datetime/m1.max_uniq_no))+
  ((s2.score_condition_end_date/m1.max_uniq_no))+
  ((s2.score_condition_end_datetime/m1.max_uniq_no))+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no))+
  ((s2.score_stop_reason/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_condition_source_value/m1.max_uniq_no))+
  ((s2.score_condition_source_concept_id/m1.max_uniq_no))+
  ((s2.score_condition_status_source_value/m1.max_uniq_no))+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no))))/16  as err_rate
,cast(1.0-((
  ((s2.score_condition_occurrence_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_condition_end_date/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_stop_reason/m1.max_uniq_no)*0.03)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.06)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.04)+
  ((s2.score_condition_source_value/m1.max_uniq_no)*0.06)+
  ((s2.score_condition_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_condition_status_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no)*0.03))) as float)
from
(select
 cast(sum(condition_occurrence_id) as float) as score_condition_occurrence_id
,cast(sum(person_id) as float)  as score_person_id
,cast(sum(condition_concept_id) as float)  as score_condition_concept_id
,cast(sum(condition_start_date) as float)  as score_condition_start_date
,cast(sum(condition_start_datetime) as float)  as score_condition_start_datetime
,cast(sum(condition_end_date) as float)  as score_condition_end_date
,cast(sum(condition_end_datetime) as float)  as score_condition_end_datetime
,cast(sum(condition_type_concept_id) as float)  as score_condition_type_concept_id
,cast(sum(stop_reason) as float)  as score_stop_reason
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(visit_occurrence_id) as float)  as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float)  as score_visit_detail_id
,cast(sum(condition_source_value) as float)  as score_condition_source_value
,cast(sum(condition_source_concept_id) as float)  as score_condition_source_concept_id
,cast(sum(condition_status_source_value) as float)  as score_condition_status_source_value
,cast(sum(condition_status_concept_id) as float)  as score_condition_status_concept_id
from #condition_occurrence_score_step3_u) as s2
cross join
(select cast(count(condition_occurrence_id) as float)  as max_uniq_no from @cdmSchema.condition_occurrence) as m1
-- 5. uniqueness
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,13 as tb_id
,'plausibility' as cateogy
,'atemporal' as sub_cateogry
,((
  ((s2.score_condition_occurrence_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_condition_concept_id/m1.max_uniq_no))+
  ((s2.score_condition_start_date/m1.max_uniq_no))+
  ((s2.score_condition_start_datetime/m1.max_uniq_no))+
  ((s2.score_condition_end_date/m1.max_uniq_no))+
  ((s2.score_condition_end_datetime/m1.max_uniq_no))+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no))+
  ((s2.score_stop_reason/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_condition_source_value/m1.max_uniq_no))+
  ((s2.score_condition_source_concept_id/m1.max_uniq_no))+
  ((s2.score_condition_status_source_value/m1.max_uniq_no))+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no))))/16  as err_rate
,cast(1.0-((
  ((s2.score_condition_occurrence_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_condition_end_date/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_stop_reason/m1.max_uniq_no)*0.03)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.06)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.04)+
  ((s2.score_condition_source_value/m1.max_uniq_no)*0.06)+
  ((s2.score_condition_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_condition_status_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no)*0.03))) as float)
from
(select
 cast(sum(condition_occurrence_id) as float) as score_condition_occurrence_id
,cast(sum(person_id) as float)  as score_person_id
,cast(sum(condition_concept_id) as float)  as score_condition_concept_id
,cast(sum(condition_start_date) as float)  as score_condition_start_date
,cast(sum(condition_start_datetime) as float)  as score_condition_start_datetime
,cast(sum(condition_end_date) as float)  as score_condition_end_date
,cast(sum(condition_end_datetime) as float)  as score_condition_end_datetime
,cast(sum(condition_type_concept_id) as float)  as score_condition_type_concept_id
,cast(sum(stop_reason) as float)  as score_stop_reason
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(visit_occurrence_id) as float)  as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float)  as score_visit_detail_id
,cast(sum(condition_source_value) as float)  as score_condition_source_value
,cast(sum(condition_source_concept_id) as float)  as score_condition_source_concept_id
,cast(sum(condition_status_source_value) as float)  as score_condition_status_source_value
,cast(sum(condition_status_concept_id) as float)  as score_condition_status_concept_id
from #condition_occurrence_score_step3_ap) as s2
cross join
(select cast(count(condition_occurrence_id) as float)  as max_uniq_no from @cdmSchema.condition_occurrence) as m1
-- 6. Accuracy
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,13 as tb_id
,'accuracy' as cateogy
,'accuracy' as sub_cateogry
,((
  ((s2.score_condition_occurrence_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_condition_concept_id/m1.max_uniq_no))+
  ((s2.score_condition_start_date/m1.max_uniq_no))+
  ((s2.score_condition_start_datetime/m1.max_uniq_no))+
  ((s2.score_condition_end_date/m1.max_uniq_no))+
  ((s2.score_condition_end_datetime/m1.max_uniq_no))+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no))+
  ((s2.score_stop_reason/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_condition_source_value/m1.max_uniq_no))+
  ((s2.score_condition_source_concept_id/m1.max_uniq_no))+
  ((s2.score_condition_status_source_value/m1.max_uniq_no))+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no))))/16  as err_rate
,cast(1.0-((
  ((s2.score_condition_occurrence_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_condition_end_date/m1.max_uniq_no)*0.09)+
  ((s2.score_condition_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_condition_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_stop_reason/m1.max_uniq_no)*0.03)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.06)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.04)+
  ((s2.score_condition_source_value/m1.max_uniq_no)*0.06)+
  ((s2.score_condition_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_condition_status_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_condition_status_concept_id/m1.max_uniq_no)*0.03))) as float)
from
(select
 cast(sum(condition_occurrence_id) as float) as score_condition_occurrence_id
,cast(sum(person_id) as float)  as score_person_id
,cast(sum(condition_concept_id) as float)  as score_condition_concept_id
,cast(sum(condition_start_date) as float)  as score_condition_start_date
,cast(sum(condition_start_datetime) as float)  as score_condition_start_datetime
,cast(sum(condition_end_date) as float)  as score_condition_end_date
,cast(sum(condition_end_datetime) as float)  as score_condition_end_datetime
,cast(sum(condition_type_concept_id) as float)  as score_condition_type_concept_id
,cast(sum(stop_reason) as float)  as score_stop_reason
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(visit_occurrence_id) as float)  as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float)  as score_visit_detail_id
,cast(sum(condition_source_value) as float)  as score_condition_source_value
,cast(sum(condition_source_concept_id) as float)  as score_condition_source_concept_id
,cast(sum(condition_status_source_value) as float)  as score_condition_status_source_value
,cast(sum(condition_status_concept_id) as float)  as score_condition_status_concept_id
from #condition_occurrence_score_step3_ac) as s2
cross join
(select cast(count(condition_occurrence_id) as float)  as max_uniq_no from @cdmSchema.condition_occurrence) as m1

--
insert into @resultSchema.score_result
select
 'CDM' as stage_gb
,tb_id
,'complex' as category
,'Table score' as sub_category
,avg(cast(err_rate as float)) as err_rate
,sum(multiply_weight) as score
from
(select
 *
, case
  when sub_category = 'Completeness' then cast(score as float) * 0.22
  when sub_category = 'value' then cast(score as float) * 0.13
  when sub_category = 'relation' then cast(score as float) * 0.15
  when sub_category = 'uniqueness' then cast(score as float) * 0.16
  when sub_category = 'atemporal' then cast(score as float) * 0.19
  when sub_category = 'accuracy' then cast(score as float) * 0.15
  else null
end as multiply_weight
from @resultSchema.score_result
where tb_id = 13)v
group by tb_id
--
select
*
from @resultSchema.score_result
where tb_id = 13

    select
    b.sub_category
    ,a.*
        from
    (select check_id,stratum2,count(*) as count_val  from @resultSchema.score_log_CDM
where tb_id= 38
    group by check_id, stratum2) as a
inner join
    (select distinct  check_id, sub_category from @resultSchema.dq_check
where sub_category ='Conformance-value') as b
        on lower(a.check_id) = lower(b.check_id)
