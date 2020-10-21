IF OBJECT_ID('tempdb..#me_Completeness_gb','U') is not null drop table #me_Completeness_gb 
IF OBJECT_ID('tempdb..#me_Conformance_value_gb','U') is not null drop table #me_Conformance_value_gb 
IF OBJECT_ID('tempdb..#me_Conformance_relation_gb','U') is not null drop table #me_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#D_Uniqueness_gb','U') is not null drop table #D_Uniqueness_gb 
IF OBJECT_ID('tempdb..#me_Uniqueness_gb','U') is not null drop table #me_Uniqueness_gb 
IF OBJECT_ID('tempdb..#me_Plausibility_atemporal_gb','U') is not null drop table #me_Plausibility_atemporal_gb 
IF OBJECT_ID('tempdb..#me_Accuracy_gb','U') is not null drop table #me_Accuracy_gb 
IF OBJECT_ID('tempdb..#score_measurement_fn_c','U') is not null drop table #score_measurement_fn_c 
IF OBJECT_ID('tempdb..#score_measurement_fn_cv','U') is not null drop table #score_measurement_fn_cv 
IF OBJECT_ID('tempdb..#score_measurement_fn_cr','U') is not null drop table #score_measurement_fn_cr 
IF OBJECT_ID('tempdb..#score_measurement_fn_ap','U') is not null drop table #score_measurement_fn_ap 
IF OBJECT_ID('tempdb..#score_measurement_fn_U','U') is not null drop table #score_measurement_fn_U 
IF OBJECT_ID('tempdb..#score_measurement_fn_A','U') is not null drop table #score_measurement_fn_A 
IF OBJECT_ID('tempdb..#measurement_score_step1','U') is not null drop table #measurement_score_step1 
IF OBJECT_ID('tempdb..#measurement_score_step2_c','U') is not null drop table #measurement_score_step2_c 
IF OBJECT_ID('tempdb..#measurement_score_step2_cr','U') is not null drop table #measurement_score_step2_cr 
IF OBJECT_ID('tempdb..#measurement_score_step2_cv','U') is not null drop table #measurement_score_step2_cv 
IF OBJECT_ID('tempdb..#measurement_score_step2_u','U') is not null drop table #measurement_score_step2_u 
IF OBJECT_ID('tempdb..#score_measurement_fn_u','U') is not null drop table #score_measurement_fn_u 
IF OBJECT_ID('tempdb..#measurement_score_step2_ap','U') is not null drop table #measurement_score_step2_ap 
IF OBJECT_ID('tempdb..#measurement_score_step2_ac','U') is not null drop table #measurement_score_step2_ac 
IF OBJECT_ID('tempdb..#measurement_score_step3_c','U') is not null drop table #measurement_score_step3_c 
IF OBJECT_ID('tempdb..#measurement_score_step3_cr','U') is not null drop table #measurement_score_step3_cr 
IF OBJECT_ID('tempdb..#measurement_score_step3_cv','U') is not null drop table #measurement_score_step3_cv 
IF OBJECT_ID('tempdb..#measurement_score_step3_u','U') is not null drop table #measurement_score_step3_u 
IF OBJECT_ID('tempdb..#measurement_score_step3_ap','U') is not null drop table #measurement_score_step3_ap 
IF OBJECT_ID('tempdb..#measurement_score_step3_ac','U') is not null drop table #measurement_score_step3_ac 

-- Table score calculation (Drug)
--------------------------------------------------------------------------
--> 1.
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
 into #me_Completeness_gb
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
where sm1.tb_id =24)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #me_Conformance_value_gb
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
where sm1.tb_id =24)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #me_Conformance_relation_gb
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
where sm1.tb_id =24)v
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
into #me_Uniqueness_gb
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
where sm1.tb_id =24)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #me_Plausibility_atemporal_gb
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
where sm1.tb_id =24)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #me_Accuracy_gb
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
where sm1.tb_id =24)v
--------------------------------------------------------------------------
--> 3.
--------------------------------------------------------------------------
-- 1
select
    *
 into  #score_measurement_fn_c
from
(select
 stratum2
,err_no as uniq_no
,1 completeness_gb
 from #me_Completeness_gb)v

--2
select
    *
into  #score_measurement_fn_cv
from
(select
 stratum2
,err_no as uniq_no
, 1 as conformance_value_gb
 from #me_Conformance_value_gb)v ;
-- 3
select
    *
into  #score_measurement_fn_cr
from
(select
 stratum2
,err_no as uniq_no
,1 as conformance_relation_gb
 from #me_Conformance_relation_gb)v ;
-- 4
select
    *
into  #score_measurement_fn_ap
from
(select
 stratum2
,err_no as uniq_no
, 1 as plausibility_atemporal_gb
 from #me_Plausibility_atemporal_gb)v ;
-- 5
select
    *
into  #score_measurement_fn_U
from
(select
 stratum2
,err_no as uniq_no
,1 as Uniqueness_gb
 from #me_Uniqueness_gb)v ;
-- 6
select
    *
into  #score_measurement_fn_A
from
(
select
 stratum2
,err_no as uniq_no
,1 as Accuracy_gb
 from #me_Accuracy_gb)v ;
--------------------------------------------------------------------------
--> 4. 
--------------------------------------------------------------------------
select
measurement_id
into #measurement_score_step1
from  @cdmSchema.measurement;
--------------------------------------------------------------------------
--> 5. 
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1. Completeness
select
 measurement_id as uniq_no
,case
  when stratum2 = 'measurement_id' then completeness_gb
  else 0
 end as measurement_id
,case
  when stratum2 = 'person_id' then completeness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'measurement_concept_id' then completeness_gb
  else 0
 end as measurement_concept_id
,case
  when stratum2 = 'measurement_date' then completeness_gb
  else 0
 end as measurement_date
,case
  when stratum2 = 'measurement_datetime' then completeness_gb
  else 0
 end as measurement_datetime
,case
  when stratum2 = 'measurement_time' then completeness_gb
  else 0
 end as measurement_time
,case
  when stratum2 = 'measurement_type_concept_id' then completeness_gb
  else 0
 end as measurement_type_concept_id
,case
  when stratum2 = 'operator_concept_id' then completeness_gb
  else 0
 end as operator_concept_id
,case
  when stratum2 = 'value_as_number' then completeness_gb
  else 0
 end as value_as_number
,case
  when stratum2 = 'value_as_concept_id' then completeness_gb
  else 0
 end as value_as_concept_id
,case
  when stratum2 = 'unit_concept_id' then completeness_gb
  else 0
 end as unit_concept_id
,case
  when stratum2 = 'range_low' then completeness_gb
  else 0
 end as range_low
,case
  when stratum2 = 'range_high' then completeness_gb
  else 0
 end as range_high
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
  when stratum2 = 'measurement_source_value' then completeness_gb
  else 0
 end as measurement_source_value
,case
  when stratum2 = 'measurement_source_concept_id' then completeness_gb
  else 0
 end as measurement_source_concept_id
,case
  when stratum2 = 'unit_source_value' then completeness_gb
  else 0
 end as unit_source_value
,case
  when stratum2 = 'value_source_value' then completeness_gb
  else 0
 end as value_source_value
 into #measurement_score_step2_c
from #measurement_score_step1  as s1
left outer join #score_measurement_fn_c as p1
on s1.measurement_id = p1.uniq_no
-- 2. Conformance-relation
select
 measurement_id as uniq_no
,case
  when stratum2 = 'person_id' then conformance_relation_gb
  else 0
 end as person_id
,case
  when stratum2 = 'measurement_concept_id' then conformance_relation_gb
  else 0
 end as measurement_concept_id
,case
  when stratum2 = 'measurement_type_concept_id' then conformance_relation_gb
  else 0
 end as measurement_type_concept_id
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
  when stratum2 = 'measurement_source_concept_id' then conformance_relation_gb
  else 0
 end as measurement_source_concept_id
 into #measurement_score_step2_cr
from #measurement_score_step1  as s1
left outer join #score_measurement_fn_cr as p1
on s1.measurement_id = p1.uniq_no
-- 3. Conformance-value
select
 measurement_id as uniq_no
,case
  when stratum2 = 'measurement_id' then conformance_value_gb
  else 0
 end as measurement_id
,case
  when stratum2 = 'person_id' then conformance_value_gb
  else 0
 end as person_id
,case
  when stratum2 = 'measurement_concept_id' then conformance_value_gb
  else 0
 end as measurement_concept_id
,case
  when stratum2 = 'measurement_date' then conformance_value_gb
  else 0
 end as measurement_date
,case
  when stratum2 = 'measurement_datetime' then conformance_value_gb
  else 0
 end as measurement_datetime
,case
  when stratum2 = 'measurement_time' then conformance_value_gb
  else 0
 end as measurement_time
,case
  when stratum2 = 'measurement_type_concept_id' then conformance_value_gb
  else 0
 end as measurement_type_concept_id
,case
  when stratum2 = 'operator_concept_id' then conformance_value_gb
  else 0
 end as operator_concept_id
,case
  when stratum2 = 'value_as_number' then conformance_value_gb
  else 0
 end as value_as_number
,case
  when stratum2 = 'value_as_concept_id' then conformance_value_gb
  else 0
 end as value_as_concept_id
,case
  when stratum2 = 'unit_concept_id' then conformance_value_gb
  else 0
 end as unit_concept_id
,case
  when stratum2 = 'range_low' then conformance_value_gb
  else 0
 end as range_low
,case
  when stratum2 = 'range_high' then conformance_value_gb
  else 0
 end as range_high
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
  when stratum2 = 'measurement_source_value' then conformance_value_gb
  else 0
 end as measurement_source_value
,case
  when stratum2 = 'measurement_source_concept_id' then conformance_value_gb
  else 0
 end as measurement_source_concept_id
,case
  when stratum2 = 'unit_source_value' then conformance_value_gb
  else 0
 end as unit_source_value
,case
  when stratum2 = 'value_source_value' then conformance_value_gb
  else 0
 end as value_source_value
 into #measurement_score_step2_cv
from #measurement_score_step1  as s1
left outer join #score_measurement_fn_cv as p1
on s1.measurement_id = p1.uniq_no
-- 4. uniqueness
select
 measurement_id as uniq_no
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as measurement_id
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as person_id
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as measurement_concept_id
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as measurement_date
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as measurement_datetime
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as measurement_time
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as measurement_type_concept_id
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as operator_concept_id
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as value_as_number
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as value_as_concept_id
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as unit_concept_id
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as range_low
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as range_high
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as provider_id
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as visit_occurrence_id
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as visit_detail_id
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as measurement_source_value
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as measurement_source_concept_id
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as unit_source_value
,case
  when s1.measurement_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as value_source_value
 into #measurement_score_step2_u
from #measurement_score_step1  as s1
left outer join #score_measurement_fn_u as p1
on s1.measurement_id = p1.uniq_no
-- 5. Atemporal
select
 measurement_id as uniq_no
,case
  when stratum2 = 'measurement_id' then plausibility_atemporal_gb
  else 0
 end as measurement_id
,case
  when stratum2 = 'person_id' then plausibility_atemporal_gb
  else 0
 end as person_id
,case
  when stratum2 = 'measurement_concept_id' then plausibility_atemporal_gb
  else 0
 end as measurement_concept_id
,case
  when stratum2 = 'measurement_date' then plausibility_atemporal_gb
  else 0
 end as measurement_date
,case
  when stratum2 = 'measurement_datetime' then plausibility_atemporal_gb
  else 0
 end as measurement_datetime
,case
  when stratum2 = 'measurement_time' then plausibility_atemporal_gb
  else 0
 end as measurement_time
,case
  when stratum2 = 'measurement_type_concept_id' then plausibility_atemporal_gb
  else 0
 end as measurement_type_concept_id
,case
  when stratum2 = 'operator_concept_id' then plausibility_atemporal_gb
  else 0
 end as operator_concept_id
,case
  when stratum2 = 'value_as_number' then plausibility_atemporal_gb
  else 0
 end as value_as_number
,case
  when stratum2 = 'value_as_concept_id' then plausibility_atemporal_gb
  else 0
 end as value_as_concept_id
,case
  when stratum2 = 'unit_concept_id' then plausibility_atemporal_gb
  else 0
 end as unit_concept_id
,case
  when stratum2 = 'range_low' then plausibility_atemporal_gb
  else 0
 end as range_low
,case
  when stratum2 = 'range_high' then plausibility_atemporal_gb
  else 0
 end as range_high
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
  when stratum2 = 'measurement_source_value' then plausibility_atemporal_gb
  else 0
 end as measurement_source_value
,case
  when stratum2 = 'measurement_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as measurement_source_concept_id
,case
  when stratum2 = 'unit_source_value' then plausibility_atemporal_gb
  else 0
 end as unit_source_value
,case
  when stratum2 = 'value_source_value' then plausibility_atemporal_gb
  else 0
 end as value_source_value
 into #measurement_score_step2_ap
from #measurement_score_step1  as s1
left outer join #score_measurement_fn_ap as p1
on s1.measurement_id = p1.uniq_no

-- 6. Accuracy
select
 measurement_id as uniq_no
,case
  when stratum2 = 'measurement_id' then Accuracy_gb
  else 0
 end as measurement_id
,case
  when stratum2 = 'person_id' then Accuracy_gb
  else 0
 end as person_id
,case
  when stratum2 = 'measurement_concept_id' then Accuracy_gb
  else 0
 end as measurement_concept_id
,case
  when stratum2 = 'measurement_date' then Accuracy_gb
  else 0
 end as measurement_date
,case
  when stratum2 = 'measurement_datetime' then Accuracy_gb
  else 0
 end as measurement_datetime
,case
  when stratum2 = 'measurement_time' then Accuracy_gb
  else 0
 end as measurement_time
,case
  when stratum2 = 'measurement_type_concept_id' then Accuracy_gb
  else 0
 end as measurement_type_concept_id
,case
  when stratum2 = 'operator_concept_id' then Accuracy_gb
  else 0
 end as operator_concept_id
,case
  when stratum2 = 'value_as_number' then Accuracy_gb
  else 0
 end as value_as_number
,case
  when stratum2 = 'value_as_concept_id' then Accuracy_gb
  else 0
 end as value_as_concept_id
,case
  when stratum2 = 'unit_concept_id' then Accuracy_gb
  else 0
 end as unit_concept_id
,case
  when stratum2 = 'range_low' then Accuracy_gb
  else 0
 end as range_low
,case
  when stratum2 = 'range_high' then Accuracy_gb
  else 0
 end as range_high
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
  when stratum2 = 'measurement_source_value' then Accuracy_gb
  else 0
 end as measurement_source_value
,case
  when stratum2 = 'measurement_source_concept_id' then Accuracy_gb
  else 0
 end as measurement_source_concept_id
,case
  when stratum2 = 'unit_source_value' then Accuracy_gb
  else 0
 end as unit_source_value
,case
  when stratum2 = 'value_source_value' then Accuracy_gb
  else 0
 end as value_source_value
 into #measurement_score_step2_ac
from #measurement_score_step1  as s1
left outer join #score_measurement_fn_A as p1
on s1.measurement_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 uniq_no
,sum(measurement_id) as measurement_id
,sum(person_id) as person_id
,sum(measurement_concept_id) as measurement_concept_id
,sum(measurement_date) as measurement_date
,sum(measurement_datetime) as measurement_datetime
,sum(measurement_time) as measurement_time
,sum(measurement_type_concept_id) as measurement_type_concept_id
,sum(operator_concept_id) as operator_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_concept_id) as value_as_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(range_low) as range_low
,sum(range_high) as range_high
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(measurement_source_value) as measurement_source_value
,sum(measurement_source_concept_id) as measurement_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(value_source_value) as value_source_value
 into #measurement_score_step3_c
from #measurement_score_step2_c
group by uniq_no
-- 2
select

 sum(person_id) as person_id
,sum(measurement_concept_id) as measurement_concept_id
,sum(measurement_type_concept_id) as measurement_type_concept_id
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(measurement_source_concept_id) as measurement_source_concept_id
 into #measurement_score_step3_cr
from #measurement_score_step2_cr
group by uniq_no
-- 3
select
 sum(measurement_id) as measurement_id
,sum(person_id) as person_id
,sum(measurement_concept_id) as measurement_concept_id
,sum(measurement_date) as measurement_date
,sum(measurement_datetime) as measurement_datetime
,sum(measurement_time) as measurement_time
,sum(measurement_type_concept_id) as measurement_type_concept_id
,sum(operator_concept_id) as operator_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_concept_id) as value_as_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(range_low) as range_low
,sum(range_high) as range_high
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(measurement_source_value) as measurement_source_value
,sum(measurement_source_concept_id) as measurement_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(value_source_value) as value_source_value
 into #measurement_score_step3_cv
from #measurement_score_step2_cv
group by uniq_no
-- 4
select
sum(measurement_id) as measurement_id
,sum(person_id) as person_id
,sum(measurement_concept_id) as measurement_concept_id
,sum(measurement_date) as measurement_date
,sum(measurement_datetime) as measurement_datetime
,sum(measurement_time) as measurement_time
,sum(measurement_type_concept_id) as measurement_type_concept_id
,sum(operator_concept_id) as operator_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_concept_id) as value_as_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(range_low) as range_low
,sum(range_high) as range_high
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(measurement_source_value) as measurement_source_value
,sum(measurement_source_concept_id) as measurement_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(value_source_value) as value_source_value
 into #measurement_score_step3_u
from #measurement_score_step2_u
group by uniq_no
-- 5
select
sum(measurement_id) as measurement_id
,sum(person_id) as person_id
,sum(measurement_concept_id) as measurement_concept_id
,sum(measurement_date) as measurement_date
,sum(measurement_datetime) as measurement_datetime
,sum(measurement_time) as measurement_time
,sum(measurement_type_concept_id) as measurement_type_concept_id
,sum(operator_concept_id) as operator_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_concept_id) as value_as_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(range_low) as range_low
,sum(range_high) as range_high
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(measurement_source_value) as measurement_source_value
,sum(measurement_source_concept_id) as measurement_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(value_source_value) as value_source_value
 into #measurement_score_step3_ap
from #measurement_score_step2_ap
group by uniq_no
-- 6
select
 sum(measurement_id) as measurement_id
,sum(person_id) as person_id
,sum(measurement_concept_id) as measurement_concept_id
,sum(measurement_date) as measurement_date
,sum(measurement_datetime) as measurement_datetime
,sum(measurement_time) as measurement_time
,sum(measurement_type_concept_id) as measurement_type_concept_id
,sum(operator_concept_id) as operator_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_concept_id) as value_as_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(range_low) as range_low
,sum(range_high) as range_high
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(measurement_source_value) as measurement_source_value
,sum(measurement_source_concept_id) as measurement_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(value_source_value) as value_source_value
 into #measurement_score_step3_ac
from #measurement_score_step2_ac
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
,24 as tb_id
,'Completeness' as cateogy
,'Completeness' as sub_cateogry
,((((s2.score_measurement_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_measurement_concept_id/m1.max_uniq_no))+
  ((s2.score_measurement_date/m1.max_uniq_no))+
  ((s2.score_measurement_datetime/m1.max_uniq_no))+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no))+
  ((s2.score_operator_concept_id/m1.max_uniq_no))+
  ((s2.score_value_as_number/m1.max_uniq_no))+
  ((s2.score_value_as_concept_id/m1.max_uniq_no))+
  ((s2.score_unit_concept_id/m1.max_uniq_no))+
  ((s2.score_range_low/m1.max_uniq_no))+
  ((s2.score_range_high/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_measurement_source_value/m1.max_uniq_no))+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no))+
  ((s2.score_unit_source_value/m1.max_uniq_no))+
  ((s2.score_value_source_value/m1.max_uniq_no)))/19)  as err_rate
,cast(1.0-((
  ((s2.score_measurement_id/m1.max_uniq_no)*0.08)+
  ((s2.score_person_id/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_date/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_operator_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.06)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_range_low/m1.max_uniq_no)*0.05)+
  ((s2.score_range_high/m1.max_uniq_no)*0.05)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.05)+
  ((s2.score_measurement_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_value_source_value/m1.max_uniq_no)*0.01))) as float)
from
(select
 cast(sum(measurement_id) as float) as score_measurement_id
,cast(sum(person_id) as float) as score_person_id
,cast(sum(measurement_concept_id) as float) as score_measurement_concept_id
,cast(sum(measurement_date) as float) as score_measurement_date
,cast(sum(measurement_datetime) as float) as score_measurement_datetime
,cast(sum(measurement_time) as float) as score_measurement_time
,cast(sum(measurement_type_concept_id) as float) as score_measurement_type_concept_id
,cast(sum(operator_concept_id) as float) as score_operator_concept_id
,cast(sum(value_as_number) as float) as score_value_as_number
,cast(sum(value_as_concept_id) as float) as score_value_as_concept_id
,cast(sum(unit_concept_id) as float) as score_unit_concept_id
,cast(sum(range_low) as float) as score_range_low
,cast(sum(range_high)as float) as score_range_high
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float) as score_visit_detail_id
,cast(sum(measurement_source_value) as float) as score_measurement_source_value
,cast(sum(measurement_source_concept_id) as float) as score_measurement_source_concept_id
,cast(sum(unit_source_value) as float) as score_unit_source_value
,cast(sum(value_source_value) as float) as score_value_source_value
from #measurement_score_step3_c) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.measurement) as m1
-- 2. Conformance-relation
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,24 as tb_id
,'Conformance' as cateogy
,'relation' as sub_cateogry
,((
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_measurement_concept_id/m1.max_uniq_no))+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no)))/7)  as err_rate
,cast(1.0-((
  ((s2.score_person_id/m1.max_uniq_no)*0.18)+
  ((s2.score_measurement_concept_id/m1.max_uniq_no)*0.18)+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no)*0.14)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.18)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.18)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.18)+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no)*0.14))) as float)
from
(select
 cast(sum(person_id) as float) as score_person_id
,cast(sum(measurement_concept_id) as float) as score_measurement_concept_id
,cast(sum(measurement_type_concept_id) as float) as score_measurement_type_concept_id
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float) as score_visit_detail_id
,cast(sum(measurement_source_concept_id) as float) as score_measurement_source_concept_id
from #measurement_score_step3_cr) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.measurement) as m1
-- 3. conformance-value
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,24 as tb_id
,'Conformance' as cateogy
,'value' as sub_cateogry
,((((s2.score_measurement_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_measurement_concept_id/m1.max_uniq_no))+
  ((s2.score_measurement_date/m1.max_uniq_no))+
  ((s2.score_measurement_datetime/m1.max_uniq_no))+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no))+
  ((s2.score_operator_concept_id/m1.max_uniq_no))+
  ((s2.score_value_as_number/m1.max_uniq_no))+
  ((s2.score_value_as_concept_id/m1.max_uniq_no))+
  ((s2.score_unit_concept_id/m1.max_uniq_no))+
  ((s2.score_range_low/m1.max_uniq_no))+
  ((s2.score_range_high/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_measurement_source_value/m1.max_uniq_no))+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no))+
  ((s2.score_unit_source_value/m1.max_uniq_no))+
  ((s2.score_value_source_value/m1.max_uniq_no)))/19)  as err_rate
,cast(1.0-((
  ((s2.score_measurement_id/m1.max_uniq_no)*0.03)+
  ((s2.score_person_id/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_date/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_operator_concept_id/m1.max_uniq_no)*0.07)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.07)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.07)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_range_low/m1.max_uniq_no)*0.07)+
  ((s2.score_range_high/m1.max_uniq_no)*0.07)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.03)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.04)+
  ((s2.score_measurement_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_value_source_value/m1.max_uniq_no)*0.01))) as float)
from
(select
 cast(sum(measurement_id) as float) as score_measurement_id
,cast(sum(person_id) as float) as score_person_id
,cast(sum(measurement_concept_id) as float) as score_measurement_concept_id
,cast(sum(measurement_date) as float) as score_measurement_date
,cast(sum(measurement_datetime) as float) as score_measurement_datetime
,cast(sum(measurement_time) as float) as score_measurement_time
,cast(sum(measurement_type_concept_id) as float) as score_measurement_type_concept_id
,cast(sum(operator_concept_id) as float) as score_operator_concept_id
,cast(sum(value_as_number) as float) as score_value_as_number
,cast(sum(value_as_concept_id) as float) as score_value_as_concept_id
,cast(sum(unit_concept_id) as float) as score_unit_concept_id
,cast(sum(range_low) as float) as score_range_low
,cast(sum(range_high)as float) as score_range_high
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float) as score_visit_detail_id
,cast(sum(measurement_source_value) as float) as score_measurement_source_value
,cast(sum(measurement_source_concept_id) as float) as score_measurement_source_concept_id
,cast(sum(unit_source_value) as float) as score_unit_source_value
,cast(sum(value_source_value) as float) as score_value_source_value
from #measurement_score_step3_cv) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.measurement) as m1
-- 4. Uniqueness
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,24 as tb_id
,'Plausibility' as cateogy
,'Uniqueness' as sub_cateogry
,((((s2.score_measurement_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_measurement_concept_id/m1.max_uniq_no))+
  ((s2.score_measurement_date/m1.max_uniq_no))+
  ((s2.score_measurement_datetime/m1.max_uniq_no))+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no))+
  ((s2.score_operator_concept_id/m1.max_uniq_no))+
  ((s2.score_value_as_number/m1.max_uniq_no))+
  ((s2.score_value_as_concept_id/m1.max_uniq_no))+
  ((s2.score_unit_concept_id/m1.max_uniq_no))+
  ((s2.score_range_low/m1.max_uniq_no))+
  ((s2.score_range_high/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_measurement_source_value/m1.max_uniq_no))+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no))+
  ((s2.score_unit_source_value/m1.max_uniq_no))+
  ((s2.score_value_source_value/m1.max_uniq_no)))/19)  as err_rate
,cast(1.0-((
  ((s2.score_measurement_id/m1.max_uniq_no)*0.08)+
  ((s2.score_person_id/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_date/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_datetime/m1.max_uniq_no)*0.06)+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_operator_concept_id/m1.max_uniq_no)*0.07)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.07)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.07)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.07)+
  ((s2.score_range_low/m1.max_uniq_no)*0.05)+
  ((s2.score_range_high/m1.max_uniq_no)*0.05)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.04)+
  ((s2.score_measurement_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_value_source_value/m1.max_uniq_no)*0.01))) as float)
from
(select
 cast(sum(measurement_id) as float) as score_measurement_id
,cast(sum(person_id) as float) as score_person_id
,cast(sum(measurement_concept_id) as float) as score_measurement_concept_id
,cast(sum(measurement_date) as float) as score_measurement_date
,cast(sum(measurement_datetime) as float) as score_measurement_datetime
,cast(sum(measurement_time) as float) as score_measurement_time
,cast(sum(measurement_type_concept_id) as float) as score_measurement_type_concept_id
,cast(sum(operator_concept_id) as float) as score_operator_concept_id
,cast(sum(value_as_number) as float) as score_value_as_number
,cast(sum(value_as_concept_id) as float) as score_value_as_concept_id
,cast(sum(unit_concept_id) as float) as score_unit_concept_id
,cast(sum(range_low) as float) as score_range_low
,cast(sum(range_high)as float) as score_range_high
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float) as score_visit_detail_id
,cast(sum(measurement_source_value) as float) as score_measurement_source_value
,cast(sum(measurement_source_concept_id) as float) as score_measurement_source_concept_id
,cast(sum(unit_source_value) as float) as score_unit_source_value
,cast(sum(value_source_value) as float) as score_value_source_value
from #measurement_score_step3_u) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.measurement) as m1
-- 5. Atemporal
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,24 as tb_id
,'Plausibility' as cateogy
,'Atemporal' as sub_cateogry
,((((s2.score_measurement_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_measurement_concept_id/m1.max_uniq_no))+
  ((s2.score_measurement_date/m1.max_uniq_no))+
  ((s2.score_measurement_datetime/m1.max_uniq_no))+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no))+
  ((s2.score_operator_concept_id/m1.max_uniq_no))+
  ((s2.score_value_as_number/m1.max_uniq_no))+
  ((s2.score_value_as_concept_id/m1.max_uniq_no))+
  ((s2.score_unit_concept_id/m1.max_uniq_no))+
  ((s2.score_range_low/m1.max_uniq_no))+
  ((s2.score_range_high/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_measurement_source_value/m1.max_uniq_no))+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no))+
  ((s2.score_unit_source_value/m1.max_uniq_no))+
  ((s2.score_value_source_value/m1.max_uniq_no)))/19)  as err_rate
,cast(1.0-((
  ((s2.score_measurement_id/m1.max_uniq_no)*0.02)+
  ((s2.score_person_id/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_date/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_operator_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.08)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_range_low/m1.max_uniq_no)*0.07)+
  ((s2.score_range_high/m1.max_uniq_no)*0.07)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.03)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.01)+
  ((s2.score_measurement_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_value_source_value/m1.max_uniq_no)*0.01))) as float)
from
(select
 cast(sum(measurement_id) as float) as score_measurement_id
,cast(sum(person_id) as float) as score_person_id
,cast(sum(measurement_concept_id) as float) as score_measurement_concept_id
,cast(sum(measurement_date) as float) as score_measurement_date
,cast(sum(measurement_datetime) as float) as score_measurement_datetime
,cast(sum(measurement_time) as float) as score_measurement_time
,cast(sum(measurement_type_concept_id) as float) as score_measurement_type_concept_id
,cast(sum(operator_concept_id) as float) as score_operator_concept_id
,cast(sum(value_as_number) as float) as score_value_as_number
,cast(sum(value_as_concept_id) as float) as score_value_as_concept_id
,cast(sum(unit_concept_id) as float) as score_unit_concept_id
,cast(sum(range_low) as float) as score_range_low
,cast(sum(range_high)as float) as score_range_high
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float) as score_visit_detail_id
,cast(sum(measurement_source_value) as float) as score_measurement_source_value
,cast(sum(measurement_source_concept_id) as float) as score_measurement_source_concept_id
,cast(sum(unit_source_value) as float) as score_unit_source_value
,cast(sum(value_source_value) as float) as score_value_source_value
from #measurement_score_step3_ap) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.measurement) as m1
-- 6. Accuarcy
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,24 as tb_id
,'Accuracy' as cateogy
,'Accuracy' as sub_cateogry
,((((s2.score_measurement_id/m1.max_uniq_no))+
  ((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_measurement_concept_id/m1.max_uniq_no))+
  ((s2.score_measurement_date/m1.max_uniq_no))+
  ((s2.score_measurement_datetime/m1.max_uniq_no))+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no))+
  ((s2.score_operator_concept_id/m1.max_uniq_no))+
  ((s2.score_value_as_number/m1.max_uniq_no))+
  ((s2.score_value_as_concept_id/m1.max_uniq_no))+
  ((s2.score_unit_concept_id/m1.max_uniq_no))+
  ((s2.score_range_low/m1.max_uniq_no))+
  ((s2.score_range_high/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no))+
  ((s2.score_visit_detail_id/m1.max_uniq_no))+
  ((s2.score_measurement_source_value/m1.max_uniq_no))+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no))+
  ((s2.score_unit_source_value/m1.max_uniq_no))+
  ((s2.score_value_source_value/m1.max_uniq_no)))/19)  as err_rate
,cast(1.0-((
  ((s2.score_measurement_id/m1.max_uniq_no)*0.02)+
  ((s2.score_person_id/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_date/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_measurement_type_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_operator_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.08)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_range_low/m1.max_uniq_no)*0.07)+
  ((s2.score_range_high/m1.max_uniq_no)*0.07)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.03)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.04)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.01)+
  ((s2.score_measurement_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_measurement_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_value_source_value/m1.max_uniq_no)*0.01))) as float)
from
(select
 cast(sum(measurement_id) as float) as score_measurement_id
,cast(sum(person_id) as float) as score_person_id
,cast(sum(measurement_concept_id) as float) as score_measurement_concept_id
,cast(sum(measurement_date) as float) as score_measurement_date
,cast(sum(measurement_datetime) as float) as score_measurement_datetime
,cast(sum(measurement_time) as float) as score_measurement_time
,cast(sum(measurement_type_concept_id) as float) as score_measurement_type_concept_id
,cast(sum(operator_concept_id) as float) as score_operator_concept_id
,cast(sum(value_as_number) as float) as score_value_as_number
,cast(sum(value_as_concept_id) as float) as score_value_as_concept_id
,cast(sum(unit_concept_id) as float) as score_unit_concept_id
,cast(sum(range_low) as float) as score_range_low
,cast(sum(range_high)as float) as score_range_high
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(visit_occurrence_id) as float) as score_visit_occurrence_id
,cast(sum(visit_detail_id) as float) as score_visit_detail_id
,cast(sum(measurement_source_value) as float) as score_measurement_source_value
,cast(sum(measurement_source_concept_id) as float) as score_measurement_source_concept_id
,cast(sum(unit_source_value) as float) as score_unit_source_value
,cast(sum(value_source_value) as float) as score_value_source_value
from #measurement_score_step3_ap) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.measurement) as m1
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
  when sub_category = 'Uniqueness' then cast(score as float) * 0.16
  when sub_category = 'Atemporal' then cast(score as float) * 0.19
  when sub_category = 'Accuracy' then cast(score as float) * 0.15
  else null
end as multiply_weight
from @resultSchema.score_result
where tb_id = 24)v
group by tb_id

select
*
from @resultSchema.score_result
where tb_id = 24