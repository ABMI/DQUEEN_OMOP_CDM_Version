--------------------------------------------------------------------------
--> 1. Table error info
--> DQ concept list for calculation of DQ score
--> 1. Completeness
--> 2. Conformance-value
--> 3. Conformance-relation
--> 4. Plausibility-Uniqueness
--> 5. Plausibility-Atemporal
--> 6. Accuracy
--------------------------------------------------------------------------

IF OBJECT_ID('tempdb..#v_Completeness_gb','U') is not null drop table #v_Completeness_gb 
IF OBJECT_ID('tempdb..#v_Conformance_value_gb','U') is not null drop table #v_Conformance_value_gb 
IF OBJECT_ID('tempdb..#v_Conformance_relation_gb','U') is not null drop table #v_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#D_Uniqueness_gb','U') is not null drop table #D_Uniqueness_gb 
IF OBJECT_ID('tempdb..#v_Uniqueness_gb','U') is not null drop table #v_Uniqueness_gb 
IF OBJECT_ID('tempdb..#v_Plausibility_atemporal_gb','U') is not null drop table #v_Plausibility_atemporal_gb 
IF OBJECT_ID('tempdb..#v_Accuracy_gb','U') is not null drop table #v_Accuracy_gb 
IF OBJECT_ID('tempdb..#score_visit_fn_c','U') is not null drop table #score_visit_fn_c 
IF OBJECT_ID('tempdb..#score_visit_fn_cv','U') is not null drop table #score_visit_fn_cv 
IF OBJECT_ID('tempdb..#score_visit_fn_cr','U') is not null drop table #score_visit_fn_cr 
IF OBJECT_ID('tempdb..#score_visit_fn_ap','U') is not null drop table #score_visit_fn_ap 
IF OBJECT_ID('tempdb..#score_visit_fn_u','U') is not null drop table #score_visit_fn_u 
IF OBJECT_ID('tempdb..#score_visit_fn_a','U') is not null drop table #score_visit_fn_a 
IF OBJECT_ID('tempdb..#visit_score_step1','U') is not null drop table #visit_score_step1 
IF OBJECT_ID('tempdb..#visit_score_step2_c','U') is not null drop table #visit_score_step2_c 
IF OBJECT_ID('tempdb..#visit_score_step2_cr','U') is not null drop table #visit_score_step2_cr 
IF OBJECT_ID('tempdb..#visit_score_step2_cv','U') is not null drop table #visit_score_step2_cv 
IF OBJECT_ID('tempdb..#visit_score_step2_u','U') is not null drop table #visit_score_step2_u 
IF OBJECT_ID('tempdb..#visit_score_step2_ap','U') is not null drop table #visit_score_step2_ap 
IF OBJECT_ID('tempdb..#visit_score_step2_ac','U') is not null drop table #visit_score_step2_ac 
IF OBJECT_ID('tempdb..#visit_score_step3_c','U') is not null drop table #visit_score_step3_c 
IF OBJECT_ID('tempdb..#visit_score_step3_cr','U') is not null drop table #visit_score_step3_cr 
IF OBJECT_ID('tempdb..#visit_score_step3_cv','U') is not null drop table #visit_score_step3_cv 
IF OBJECT_ID('tempdb..#visit_score_step3_u','U') is not null drop table #visit_score_step3_u 
IF OBJECT_ID('tempdb..#visit_score_step3_ap','U') is not null drop table #visit_score_step3_ap 
IF OBJECT_ID('tempdb..#visit_score_step3_ac','U') is not null drop table #visit_score_step3_ac 

--> 1. Completeness
select
distinct
 sub_category
,stratum2
,err_no
 into #v_Completeness_gb
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
where sm1.tb_id =38)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #v_Conformance_value_gb
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
where sm1.tb_id =38)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #v_Conformance_relation_gb
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
where sm1.tb_id =38)v
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
into #v_Uniqueness_gb
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
where sm1.tb_id =38)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #v_Plausibility_atemporal_gb
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
where sm1.tb_id =38)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #v_Accuracy_gb
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
where sm1.tb_id =38)v
--------------------------------------------------------------------------
--> 3. Lable DQ concept
--------------------------------------------------------------------------
-- 1
select
    *
 into  #score_visit_fn_c
from
(select
 stratum2
,err_no as uniq_no
,1 completeness_gb
 from #v_Completeness_gb)v

--2
select
    *
into  #score_visit_fn_cv
from
(select
 stratum2
,err_no as uniq_no
, 1 as conformance_value_gb
 from #v_Conformance_value_gb)v ;
-- 3
select
    *
into  #score_visit_fn_cr
from
(select
 stratum2
,err_no as uniq_no
,1 as conformance_relation_gb
 from #v_Conformance_relation_gb)v ;
-- 4
select
    *
into  #score_visit_fn_ap
from
(select
 stratum2
,err_no as uniq_no
, 1 as plausibility_atemporal_gb
 from #v_Plausibility_atemporal_gb)v ;
-- 5
select
    *
into  #score_visit_fn_u
from
(select
 stratum2
,err_no as uniq_no
,1 as Uniqueness_gb
 from #v_Uniqueness_gb)v ;
-- 6
select
    *
into  #score_visit_fn_a
from
(
select
 stratum2
,err_no as uniq_no
,1 as Accuracy_gb
 from #v_Accuracy_gb)v ;
--------------------------------------------------------------------------
--> 4. table uniq_no
--------------------------------------------------------------------------
select
visit_occurrence_id
into #visit_score_step1
from  @cdmSchema.visit_occurrence;
--------------------------------------------------------------------------
--> 5. table score
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1. Completeness
select
 visit_occurrence_id as uniq_no
,case
  when stratum2 = 'visit_occurrence_id' then completeness_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'person_id' then completeness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'visit_concept_id' then completeness_gb
  else 0
 end as visit_concept_id
,case
  when stratum2 = 'visit_start_date' then completeness_gb
  else 0
 end as visit_start_date
,case
  when stratum2 = 'visit_start_datetime' then completeness_gb
  else 0
 end as visit_start_datetime
,case
  when stratum2 = 'visit_end_date' then completeness_gb
  else 0
 end as visit_end_date
,case
  when stratum2 = 'visit_end_datetime' then completeness_gb
  else 0
 end as visit_end_datetime
,case
  when stratum2 = 'visit_type_concept_id' then completeness_gb
  else 0
 end as visit_type_concept_id
,case
  when stratum2 = 'provider_id' then completeness_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'care_site_id' then completeness_gb
  else 0
 end as care_site_id
,case
  when stratum2 = 'visit_source_value' then completeness_gb
  else 0
 end as visit_source_value
,case
  when stratum2 = 'visit_source_concept_id'then completeness_gb
  else 0
 end as visit_source_concept_id
,case
  when stratum2 = 'admitting_source_concept_id' then completeness_gb
  else 0
 end as admitting_source_concept_id
,case
  when stratum2 = 'admitting_source_value' then completeness_gb
  else 0
 end as admitting_source_value
,case
  when stratum2 = 'discharge_to_concept_id' then completeness_gb
  else 0
 end as discharge_to_concept_id
,case
  when stratum2 = 'discharge_to_source_value' then completeness_gb
  else 0
 end as discharge_to_source_value
,case
  when stratum2 = 'preceding_visit_occurrence_id' then completeness_gb
  else 0
 end as preceding_visit_occurrence_id
 into #visit_score_step2_c
from #visit_score_step1  as s1
left outer join #score_visit_fn_c as p1
on s1.visit_occurrence_id = p1.uniq_no
-- 2. Conformance-relation
select
 visit_occurrence_id as uniq_no
,case
  when stratum2 = 'visit_occurrence_id' then conformance_relation_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'person_id' then conformance_relation_gb
  else 0
 end as person_id
,case
  when stratum2 = 'visit_concept_id' then conformance_relation_gb
  else 0
 end as visit_concept_id
,case
  when stratum2 = 'visit_type_concept_id' then conformance_relation_gb
  else 0
 end as visit_type_concept_id
,case
  when stratum2 = 'provider_id' then conformance_relation_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'care_site_id' then conformance_relation_gb
  else 0
 end as care_site_id
,case
  when stratum2 = 'discharge_to_concept_id' then conformance_relation_gb
  else 0
 end as discharge_to_concept_id
 into #visit_score_step2_cr
from #visit_score_step1  as s1
left outer join #score_visit_fn_cr as p1
on s1.visit_occurrence_id = p1.uniq_no
-- 3. Conformance-value
select
 visit_occurrence_id as uniq_no
,case
  when stratum2 = 'visit_occurrence_id' then conformance_value_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'person_id' then conformance_value_gb
  else 0
 end as person_id
,case
  when stratum2 = 'visit_concept_id' then conformance_value_gb
  else 0
 end as visit_concept_id
,case
  when stratum2 = 'visit_start_date' then conformance_value_gb
  else 0
 end as visit_start_date
,case
  when stratum2 = 'visit_start_datetime' then conformance_value_gb
  else 0
 end as visit_start_datetime
,case
  when stratum2 = 'visit_end_date' then conformance_value_gb
  else 0
 end as visit_end_date
,case
  when stratum2 = 'visit_end_datetime' then conformance_value_gb
  else 0
 end as visit_end_datetime
,case
  when stratum2 = 'visit_type_concept_id' then conformance_value_gb
  else 0
 end as visit_type_concept_id
,case
  when stratum2 = 'provider_id' then conformance_value_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'care_site_id' then conformance_value_gb
  else 0
 end as care_site_id
,case
  when stratum2 = 'visit_source_value' then conformance_value_gb
  else 0
 end as visit_source_value
,case
  when stratum2 = 'visit_source_concept_id'then conformance_value_gb
  else 0
 end as visit_source_concept_id
,case
  when stratum2 = 'admitting_source_concept_id' then conformance_value_gb
  else 0
 end as admitting_source_concept_id
,case
  when stratum2 = 'admitting_source_value' then conformance_value_gb
  else 0
 end as admitting_source_value
,case
  when stratum2 = 'discharge_to_concept_id' then conformance_value_gb
  else 0
 end as discharge_to_concept_id
,case
  when stratum2 = 'discharge_to_source_value' then conformance_value_gb
  else 0
 end as discharge_to_source_value
,case
  when stratum2 = 'preceding_visit_occurrence_id' then conformance_value_gb
  else 0
 end as preceding_visit_occurrence_id
 into #visit_score_step2_cv
from #visit_score_step1  as s1
left outer join #score_visit_fn_cv as p1
on s1.visit_occurrence_id = p1.uniq_no
-- 4. uniqueness
select
 visit_occurrence_id as uniq_no
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as visit_occurrence_id
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as person_id
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as visit_concept_id
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as visit_start_date
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as visit_start_datetime
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as visit_end_date
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as visit_end_datetime
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as visit_type_concept_id
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as provider_id
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as care_site_id
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as visit_source_value
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as visit_source_concept_id
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as admitting_source_concept_id
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as admitting_source_value
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as discharge_to_concept_id
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as discharge_to_source_value
,case
  when s1.visit_occurrence_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as preceding_visit_occurrence_id
 into #visit_score_step2_u
from #visit_score_step1  as s1
left outer join #score_visit_fn_u as p1
on s1.visit_occurrence_id = p1.uniq_no
-- 5. Atemporal
select
 visit_occurrence_id as uniq_no
,case
  when stratum2 = 'visit_occurrence_id' then plausibility_atemporal_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'person_id' then plausibility_atemporal_gb
  else 0
 end as person_id
,case
  when stratum2 = 'visit_concept_id' then plausibility_atemporal_gb
  else 0
 end as visit_concept_id
,case
  when stratum2 = 'visit_start_date' then plausibility_atemporal_gb
  else 0
 end as visit_start_date
,case
  when stratum2 = 'visit_start_datetime' then plausibility_atemporal_gb
  else 0
 end as visit_start_datetime
,case
  when stratum2 = 'visit_end_date' then plausibility_atemporal_gb
  else 0
 end as visit_end_date
,case
  when stratum2 = 'visit_end_datetime' then plausibility_atemporal_gb
  else 0
 end as visit_end_datetime
,case
  when stratum2 = 'visit_type_concept_id' then plausibility_atemporal_gb
  else 0
 end as visit_type_concept_id
,case
  when stratum2 = 'provider_id' then plausibility_atemporal_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'care_site_id' then plausibility_atemporal_gb
  else 0
 end as care_site_id
,case
  when stratum2 = 'visit_source_value' then plausibility_atemporal_gb
  else 0
 end as visit_source_value
,case
  when stratum2 = 'visit_source_concept_id'then plausibility_atemporal_gb
  else 0
 end as visit_source_concept_id
,case
  when stratum2 = 'admitting_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as admitting_source_concept_id
,case
  when stratum2 = 'admitting_source_value' then plausibility_atemporal_gb
  else 0
 end as admitting_source_value
,case
  when stratum2 = 'discharge_to_concept_id' then plausibility_atemporal_gb
  else 0
 end as discharge_to_concept_id
,case
  when stratum2 = 'discharge_to_source_value' then plausibility_atemporal_gb
  else 0
 end as discharge_to_source_value
,case
  when stratum2 = 'preceding_visit_occurrence_id' then plausibility_atemporal_gb
  else 0
 end as preceding_visit_occurrence_id
 into #visit_score_step2_ap
from #visit_score_step1  as s1
left outer join #score_visit_fn_ap as p1
on s1.visit_occurrence_id = p1.uniq_no

-- 6. Accuracy
select
 visit_occurrence_id as uniq_no
,case
  when stratum2 = 'visit_occurrence_id' then Accuracy_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'person_id' then Accuracy_gb
  else 0
 end as person_id
,case
  when stratum2 = 'visit_concept_id' then Accuracy_gb
  else 0
 end as visit_concept_id
,case
  when stratum2 = 'visit_start_date' then Accuracy_gb
  else 0
 end as visit_start_date
,case
  when stratum2 = 'visit_start_datetime' then Accuracy_gb
  else 0
 end as visit_start_datetime
,case
  when stratum2 = 'visit_end_date' then Accuracy_gb
  else 0
 end as visit_end_date
,case
  when stratum2 = 'visit_end_datetime' then Accuracy_gb
  else 0
 end as visit_end_datetime
,case
  when stratum2 = 'visit_type_concept_id' then Accuracy_gb
  else 0
 end as visit_type_concept_id
,case
  when stratum2 = 'provider_id' then Accuracy_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'care_site_id' then Accuracy_gb
  else 0
 end as care_site_id
,case
  when stratum2 = 'visit_source_value' then Accuracy_gb
  else 0
 end as visit_source_value
,case
  when stratum2 = 'visit_source_concept_id'then Accuracy_gb
  else 0
 end as visit_source_concept_id
,case
  when stratum2 = 'admitting_source_concept_id' then Accuracy_gb
  else 0
 end as admitting_source_concept_id
,case
  when stratum2 = 'admitting_source_value' then Accuracy_gb
  else 0
 end as admitting_source_value
,case
  when stratum2 = 'discharge_to_concept_id' then Accuracy_gb
  else 0
 end as discharge_to_concept_id
,case
  when stratum2 = 'discharge_to_source_value' then Accuracy_gb
  else 0
 end as discharge_to_source_value
,case
  when stratum2 = 'preceding_visit_occurrence_id' then Accuracy_gb
  else 0
 end as preceding_visit_occurrence_id
 into #visit_score_step2_ac
from #visit_score_step1  as s1
left outer join #score_visit_fn_a as p1
on s1.visit_occurrence_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1. completeness
select
 sum(visit_occurrence_id) as visit_occurrence_id
,sum(person_id) as person_id
,sum(visit_concept_id) as visit_concept_id
,sum(visit_start_date) as visit_start_date
,sum(visit_start_datetime) as visit_start_datetime
,sum(visit_end_date) as visit_end_date
,sum(visit_end_datetime) as visit_end_datetime
,sum(visit_type_concept_id) as visit_type_concept_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(visit_source_value) as visit_source_value
,sum(visit_source_concept_id) as visit_source_concept_id
,sum(admitting_source_concept_id) as admitting_source_concept_id
,sum(admitting_source_value) as admitting_source_value
,sum(discharge_to_concept_id) as discharge_to_concept_id
,sum(discharge_to_source_value) as discharge_to_source_value
,sum(preceding_visit_occurrence_id) as preceding_visit_occurrence_id
 into #visit_score_step3_c
from #visit_score_step2_c
group by uniq_no
-- 2. conformance-relation
select
 sum(visit_occurrence_id) as visit_occurrence_id
,sum(person_id) as person_id
,sum(visit_concept_id) as visit_concept_id
,sum(visit_type_concept_id) as visit_type_concept_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(discharge_to_concept_id) as discharge_to_concept_id
 into #visit_score_step3_cr
from #visit_score_step2_cr
group by uniq_no
-- 3. conformance-value
select
 uniq_no
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(person_id) as person_id
,sum(visit_concept_id) as visit_concept_id
,sum(visit_start_date) as visit_start_date
,sum(visit_start_datetime) as visit_start_datetime
,sum(visit_end_date) as visit_end_date
,sum(visit_end_datetime) as visit_end_datetime
,sum(visit_type_concept_id) as visit_type_concept_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(visit_source_value) as visit_source_value
,sum(visit_source_concept_id) as visit_source_concept_id
,sum(admitting_source_concept_id) as admitting_source_concept_id
,sum(admitting_source_value) as admitting_source_value
,sum(discharge_to_concept_id) as discharge_to_concept_id
,sum(discharge_to_source_value) as discharge_to_source_value
,sum(preceding_visit_occurrence_id) as preceding_visit_occurrence_id
 into #visit_score_step3_cv
from #visit_score_step2_cv
group by uniq_no
-- 4. uniqueness
select
 uniq_no
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(person_id) as person_id
,sum(visit_concept_id) as visit_concept_id
,sum(visit_start_date) as visit_start_date
,sum(visit_start_datetime) as visit_start_datetime
,sum(visit_end_date) as visit_end_date
,sum(visit_end_datetime) as visit_end_datetime
,sum(visit_type_concept_id) as visit_type_concept_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(visit_source_value) as visit_source_value
,sum(visit_source_concept_id) as visit_source_concept_id
,sum(admitting_source_concept_id) as admitting_source_concept_id
,sum(admitting_source_value) as admitting_source_value
,sum(discharge_to_concept_id) as discharge_to_concept_id
,sum(discharge_to_source_value) as discharge_to_source_value
,sum(preceding_visit_occurrence_id) as preceding_visit_occurrence_id
 into #visit_score_step3_u
from #visit_score_step2_u
group by uniq_no
-- 5. atemporal
select
 uniq_no
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(person_id) as person_id
,sum(visit_concept_id) as visit_concept_id
,sum(visit_start_date) as visit_start_date
,sum(visit_start_datetime) as visit_start_datetime
,sum(visit_end_date) as visit_end_date
,sum(visit_end_datetime) as visit_end_datetime
,sum(visit_type_concept_id) as visit_type_concept_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(visit_source_value) as visit_source_value
,sum(visit_source_concept_id) as visit_source_concept_id
,sum(admitting_source_concept_id) as admitting_source_concept_id
,sum(admitting_source_value) as admitting_source_value
,sum(discharge_to_concept_id) as discharge_to_concept_id
,sum(discharge_to_source_value) as discharge_to_source_value
,sum(preceding_visit_occurrence_id) as preceding_visit_occurrence_id
 into #visit_score_step3_ap
from #visit_score_step2_ap
group by uniq_no
-- 6. accuracy
select
 uniq_no
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(person_id) as person_id
,sum(visit_concept_id) as visit_concept_id
,sum(visit_start_date) as visit_start_date
,sum(visit_start_datetime) as visit_start_datetime
,sum(visit_end_date) as visit_end_date
,sum(visit_end_datetime) as visit_end_datetime
,sum(visit_type_concept_id) as visit_type_concept_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(visit_source_value) as visit_source_value
,sum(visit_source_concept_id) as visit_source_concept_id
,sum(admitting_source_concept_id) as admitting_source_concept_id
,sum(admitting_source_value) as admitting_source_value
,sum(discharge_to_concept_id) as discharge_to_concept_id
,sum(discharge_to_source_value) as discharge_to_source_value
,sum(preceding_visit_occurrence_id) as preceding_visit_occurrence_id
 into #visit_score_step3_ac
from #visit_score_step2_ac
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
,38 as tb_id
,'Completeness' as cateogy
,'Completeness' as sub_cateogry
,((((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_visit_concept_id/m1.max_uniq_no))+
  ((s2.score_visit_start_date/m1.max_uniq_no))+
  ((s2.score_visit_start_datetime/m1.max_uniq_no))+
  ((s2.score_visit_end_date/m1.max_uniq_no))+
  ((s2.score_visit_end_datetime/m1.max_uniq_no))+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_visit_source_value/m1.max_uniq_no))+
  ((s2.score_visit_source_concept_id/m1.max_uniq_no))+
  ((s2.score_admitting_source_concept_id/m1.max_uniq_no))+
  ((s2.score_admitting_source_value/m1.max_uniq_no))+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no))+
  ((s2.score_discharge_to_source_value/m1.max_uniq_no))+
  ((s2.score_preceding_visit_occurrence_id/m1.max_uniq_no))))/17 as err_rate
,cast(1.0-(((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_visit_end_date/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.03)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_visit_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_admitting_source_concept_id/m1.max_uniq_no)*0.05)+
  ((s2.score_admitting_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no)*0.05)+
  ((s2.score_discharge_to_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_preceding_visit_occurrence_id/m1.max_uniq_no)*0.03)) as float)
from
(select
 cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(person_id) as float)  as score_person_id
,cast(sum(visit_concept_id) as float)  as score_visit_concept_id
,cast(sum(visit_start_date) as float)  as score_visit_start_date
,cast(sum(visit_start_datetime) as float)  as score_visit_start_datetime
,cast(sum(visit_end_date) as float)  as score_visit_end_date
,cast(sum(visit_end_datetime) as float)  as score_visit_end_datetime
,cast(sum(visit_type_concept_id) as float)  as score_visit_type_concept_id
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(care_site_id) as float)  as score_care_site_id
,cast(sum(visit_source_value) as float)  as score_visit_source_value
,cast(sum(visit_source_concept_id) as float)  as score_visit_source_concept_id
,cast(sum(admitting_source_concept_id) as float)  as score_admitting_source_concept_id
,cast(sum(admitting_source_value) as float)  as score_admitting_source_value
,cast(sum(discharge_to_concept_id) as float)  as score_discharge_to_concept_id
,cast(sum(discharge_to_source_value) as float)  as score_discharge_to_source_value
,cast(sum(preceding_visit_occurrence_id) as float)  as score_preceding_visit_occurrence_id
from #visit_score_step3_c) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.visit_occurrence) as m1
-- 2. value
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,38 as tb_id
,'conformance' as cateogy
,'value' as sub_cateogry
,((((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_visit_concept_id/m1.max_uniq_no))+
  ((s2.score_visit_start_date/m1.max_uniq_no))+
  ((s2.score_visit_start_datetime/m1.max_uniq_no))+
  ((s2.score_visit_end_date/m1.max_uniq_no))+
  ((s2.score_visit_end_datetime/m1.max_uniq_no))+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_visit_source_value/m1.max_uniq_no))+
  ((s2.score_visit_source_concept_id/m1.max_uniq_no))+
  ((s2.score_admitting_source_concept_id/m1.max_uniq_no))+
  ((s2.score_admitting_source_value/m1.max_uniq_no))+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no))+
  ((s2.score_discharge_to_source_value/m1.max_uniq_no))+
  ((s2.score_preceding_visit_occurrence_id/m1.max_uniq_no))))/17 as err_rate
,cast(1.0-(((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.07)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_start_datetime/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_end_date/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.03)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_visit_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_admitting_source_concept_id/m1.max_uniq_no)*0.05)+
  ((s2.score_admitting_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no)*0.05)+
  ((s2.score_discharge_to_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_preceding_visit_occurrence_id/m1.max_uniq_no)*0.03)) as float)
from
(select
 cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(person_id) as float)  as score_person_id
,cast(sum(visit_concept_id) as float)  as score_visit_concept_id
,cast(sum(visit_start_date) as float)  as score_visit_start_date
,cast(sum(visit_start_datetime) as float)  as score_visit_start_datetime
,cast(sum(visit_end_date) as float)  as score_visit_end_date
,cast(sum(visit_end_datetime) as float)  as score_visit_end_datetime
,cast(sum(visit_type_concept_id) as float)  as score_visit_type_concept_id
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(care_site_id) as float)  as score_care_site_id
,cast(sum(visit_source_value) as float)  as score_visit_source_value
,cast(sum(visit_source_concept_id) as float)  as score_visit_source_concept_id
,cast(sum(admitting_source_concept_id) as float)  as score_admitting_source_concept_id
,cast(sum(admitting_source_value) as float)  as score_admitting_source_value
,cast(sum(discharge_to_concept_id) as float)  as score_discharge_to_concept_id
,cast(sum(discharge_to_source_value) as float)  as score_discharge_to_source_value
,cast(sum(preceding_visit_occurrence_id) as float)  as score_preceding_visit_occurrence_id
from #visit_score_step3_cv) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.visit_occurrence) as m1
-- 3. relation
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,38 as tb_id
,'conformance' as cateogy
,'relation' as sub_cateogry
,((((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_visit_concept_id/m1.max_uniq_no))+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no))))/7  as err_rate
,cast(1.0-(((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.15)+
  ((s2.score_person_id/m1.max_uniq_no)*0.15)+
  ((s2.score_visit_concept_id/m1.max_uniq_no)*0.15)+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no)*0.15)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.15)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.15)+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no)*0.1)) as float)
from
(select
 cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(person_id) as float)  as score_person_id
,cast(sum(visit_concept_id) as float)  as score_visit_concept_id
,cast(sum(visit_type_concept_id) as float)  as score_visit_type_concept_id
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(care_site_id) as float)  as score_care_site_id
,cast(sum(discharge_to_concept_id) as float)  as score_discharge_to_concept_id
from #visit_score_step3_cr) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.visit_occurrence) as m1
-- 4. Uniqueness
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,38 as tb_id
,'plausibility' as cateogy
,'uniqueness' as sub_cateogry
,((((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_visit_concept_id/m1.max_uniq_no))+
  ((s2.score_visit_start_date/m1.max_uniq_no))+
  ((s2.score_visit_start_datetime/m1.max_uniq_no))+
  ((s2.score_visit_end_date/m1.max_uniq_no))+
  ((s2.score_visit_end_datetime/m1.max_uniq_no))+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_visit_source_value/m1.max_uniq_no))+
  ((s2.score_visit_source_concept_id/m1.max_uniq_no))+
  ((s2.score_admitting_source_concept_id/m1.max_uniq_no))+
  ((s2.score_admitting_source_value/m1.max_uniq_no))+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no))+
  ((s2.score_discharge_to_source_value/m1.max_uniq_no))+
  ((s2.score_preceding_visit_occurrence_id/m1.max_uniq_no))))/17 as err_rate
,cast(1.0-(((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_visit_end_date/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.03)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_visit_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_admitting_source_concept_id/m1.max_uniq_no)*0.05)+
  ((s2.score_admitting_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no)*0.05)+
  ((s2.score_discharge_to_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_preceding_visit_occurrence_id/m1.max_uniq_no)*0.03)) as float)
from
(select
 cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(person_id) as float)  as score_person_id
,cast(sum(visit_concept_id) as float)  as score_visit_concept_id
,cast(sum(visit_start_date) as float)  as score_visit_start_date
,cast(sum(visit_start_datetime) as float)  as score_visit_start_datetime
,cast(sum(visit_end_date) as float)  as score_visit_end_date
,cast(sum(visit_end_datetime) as float)  as score_visit_end_datetime
,cast(sum(visit_type_concept_id) as float)  as score_visit_type_concept_id
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(care_site_id) as float)  as score_care_site_id
,cast(sum(visit_source_value) as float)  as score_visit_source_value
,cast(sum(visit_source_concept_id) as float)  as score_visit_source_concept_id
,cast(sum(admitting_source_concept_id) as float)  as score_admitting_source_concept_id
,cast(sum(admitting_source_value) as float)  as score_admitting_source_value
,cast(sum(discharge_to_concept_id) as float)  as score_discharge_to_concept_id
,cast(sum(discharge_to_source_value) as float)  as score_discharge_to_source_value
,cast(sum(preceding_visit_occurrence_id) as float)  as score_preceding_visit_occurrence_id
from #visit_score_step3_u) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.visit_occurrence) as m1
--5 atmeporal
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,38 as tb_id
,'plausibility' as cateogy
,'atemporal' as sub_cateogry
,((((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_visit_concept_id/m1.max_uniq_no))+
  ((s2.score_visit_start_date/m1.max_uniq_no))+
  ((s2.score_visit_start_datetime/m1.max_uniq_no))+
  ((s2.score_visit_end_date/m1.max_uniq_no))+
  ((s2.score_visit_end_datetime/m1.max_uniq_no))+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_visit_source_value/m1.max_uniq_no))+
  ((s2.score_visit_source_concept_id/m1.max_uniq_no))+
  ((s2.score_admitting_source_concept_id/m1.max_uniq_no))+
  ((s2.score_admitting_source_value/m1.max_uniq_no))+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no))+
  ((s2.score_discharge_to_source_value/m1.max_uniq_no))+
  ((s2.score_preceding_visit_occurrence_id/m1.max_uniq_no))))/17 as err_rate
,cast(1.0-(((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_visit_end_date/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.03)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_visit_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_admitting_source_concept_id/m1.max_uniq_no)*0.05)+
  ((s2.score_admitting_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no)*0.05)+
  ((s2.score_discharge_to_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_preceding_visit_occurrence_id/m1.max_uniq_no)*0.03)) as float)
from
(select
 cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(person_id) as float)  as score_person_id
,cast(sum(visit_concept_id) as float)  as score_visit_concept_id
,cast(sum(visit_start_date) as float)  as score_visit_start_date
,cast(sum(visit_start_datetime) as float)  as score_visit_start_datetime
,cast(sum(visit_end_date) as float)  as score_visit_end_date
,cast(sum(visit_end_datetime) as float)  as score_visit_end_datetime
,cast(sum(visit_type_concept_id) as float)  as score_visit_type_concept_id
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(care_site_id) as float)  as score_care_site_id
,cast(sum(visit_source_value) as float)  as score_visit_source_value
,cast(sum(visit_source_concept_id) as float)  as score_visit_source_concept_id
,cast(sum(admitting_source_concept_id) as float)  as score_admitting_source_concept_id
,cast(sum(admitting_source_value) as float)  as score_admitting_source_value
,cast(sum(discharge_to_concept_id) as float)  as score_discharge_to_concept_id
,cast(sum(discharge_to_source_value) as float)  as score_discharge_to_source_value
,cast(sum(preceding_visit_occurrence_id) as float)  as score_preceding_visit_occurrence_id
from #visit_score_step3_ap) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.visit_occurrence) as m1
-- 6. accuracy
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,38 as tb_id
,'accuracy' as cateogy
,'accuracy' as sub_cateogry
,((((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_visit_concept_id/m1.max_uniq_no))+
  ((s2.score_visit_start_date/m1.max_uniq_no))+
  ((s2.score_visit_start_datetime/m1.max_uniq_no))+
  ((s2.score_visit_end_date/m1.max_uniq_no))+
  ((s2.score_visit_end_datetime/m1.max_uniq_no))+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_visit_source_value/m1.max_uniq_no))+
  ((s2.score_visit_source_concept_id/m1.max_uniq_no))+
  ((s2.score_admitting_source_concept_id/m1.max_uniq_no))+
  ((s2.score_admitting_source_value/m1.max_uniq_no))+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no))+
  ((s2.score_discharge_to_source_value/m1.max_uniq_no))+
  ((s2.score_preceding_visit_occurrence_id/m1.max_uniq_no))))/17  as err_rate
,cast(1.0-(((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_start_date/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_visit_end_date/m1.max_uniq_no)*0.09)+
  ((s2.score_visit_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_visit_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.03)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_visit_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_admitting_source_concept_id/m1.max_uniq_no)*0.05)+
  ((s2.score_admitting_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_discharge_to_concept_id/m1.max_uniq_no)*0.05)+
  ((s2.score_discharge_to_source_value/m1.max_uniq_no)*0.03)+
  ((s2.score_preceding_visit_occurrence_id/m1.max_uniq_no)*0.03)) as float)
from
(select
 cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(person_id) as float)  as score_person_id
,cast(sum(visit_concept_id) as float)  as score_visit_concept_id
,cast(sum(visit_start_date) as float)  as score_visit_start_date
,cast(sum(visit_start_datetime) as float)  as score_visit_start_datetime
,cast(sum(visit_end_date) as float)  as score_visit_end_date
,cast(sum(visit_end_datetime) as float)  as score_visit_end_datetime
,cast(sum(visit_type_concept_id) as float)  as score_visit_type_concept_id
,cast(sum(provider_id) as float)  as score_provider_id
,cast(sum(care_site_id) as float)  as score_care_site_id
,cast(sum(visit_source_value) as float)  as score_visit_source_value
,cast(sum(visit_source_concept_id) as float)  as score_visit_source_concept_id
,cast(sum(admitting_source_concept_id) as float)  as score_admitting_source_concept_id
,cast(sum(admitting_source_value) as float)  as score_admitting_source_value
,cast(sum(discharge_to_concept_id) as float)  as score_discharge_to_concept_id
,cast(sum(discharge_to_source_value) as float)  as score_discharge_to_source_value
,cast(sum(preceding_visit_occurrence_id) as float)  as score_preceding_visit_occurrence_id
from #visit_score_step3_ac) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.visit_occurrence) as m1

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
where tb_id = 38)v
group by tb_id