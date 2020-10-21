IF OBJECT_ID('tempdb..#score_cost_main','U') is not null drop table #score_cost_main 
IF OBJECT_ID('tempdb..#cs_Completeness_gb','U') is not null drop table #cs_Completeness_gb 
IF OBJECT_ID('tempdb..#cs_Conformance_value_gb','U') is not null drop table #cs_Conformance_value_gb 
IF OBJECT_ID('tempdb..#cs_Conformance_relation_gb','U') is not null drop table #cs_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#cs_Uniqueness_gb','U') is not null drop table #cs_Uniqueness_gb 
IF OBJECT_ID('tempdb..#cs_Plausibility_atemporal_gb','U') is not null drop table #cs_Plausibility_atemporal_gb 
IF OBJECT_ID('tempdb..#cs_Accuracy_gb','U') is not null drop table #cs_Accuracy_gb 
IF OBJECT_ID('tempdb..#score_cost_fn','U') is not null drop table #score_cost_fn 
IF OBJECT_ID('tempdb..#cost_score_step1','U') is not null drop table #cost_score_step1 
IF OBJECT_ID('tempdb..#cost_score_step2_c','U') is not null drop table #cost_score_step2_c 
IF OBJECT_ID('tempdb..#cost_score_step2_cr','U') is not null drop table #cost_score_step2_cr 
IF OBJECT_ID('tempdb..#cost_score_step2_cv','U') is not null drop table #cost_score_step2_cv 
IF OBJECT_ID('tempdb..#cost_score_step2_u','U') is not null drop table #cost_score_step2_u 
IF OBJECT_ID('tempdb..#cost_score_step2_ap','U') is not null drop table #cost_score_step2_ap 
IF OBJECT_ID('tempdb..#cost_score_step2_ac','U') is not null drop table #cost_score_step2_ac 
IF OBJECT_ID('tempdb..#cost_score_step3_c','U') is not null drop table #cost_score_step3_c 
IF OBJECT_ID('tempdb..#cost_score_step3_cr','U') is not null drop table #cost_score_step3_cr 
IF OBJECT_ID('tempdb..#cost_score_step3_cv','U') is not null drop table #cost_score_step3_cv 
IF OBJECT_ID('tempdb..#cost_score_step3_u','U') is not null drop table #cost_score_step3_u 
IF OBJECT_ID('tempdb..#cost_score_step3_ap','U') is not null drop table #cost_score_step3_ap 
IF OBJECT_ID('tempdb..#cost_score_step3_ac','U') is not null drop table #cost_score_step3_ac 
IF OBJECT_ID('tempdb..#score_cost_fn_t','U') is not null drop table #score_cost_fn_t 
IF OBJECT_ID('tempdb..#cost_score_step2_t','U') is not null drop table #cost_score_step2_t 
IF OBJECT_ID('tempdb..#cost_score_step3_t','U') is not null drop table #cost_score_step3_t 

--> 1. order by the table error uniq_number
--> DQ concept of uniq stratum2 null select
--------------------------------------------------------------------------
select
distinct
 tb_id
,stratum2
,err_no as uniq_no
into #score_cost_main
from @resultSchema.score_log_CDM
where tb_id = 14;
--------------------------------------------------------------------------
--> 2. 
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
into #cs_Completeness_gb
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
where sm1.tb_id =14)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #cs_Conformance_value_gb
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
where sm1.tb_id =14)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #cs_Conformance_relation_gb
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
where sm1.tb_id =14)v
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
into #cs_Uniqueness_gb
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
where sm1.tb_id =14)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #cs_Plausibility_atemporal_gb
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
where sm1.tb_id =14)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #cs_Accuracy_gb
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
where sm1.tb_id =14)v
--------------------------------------------------------------------------
--> 3.
--------------------------------------------------------------------------
select
    *
into #score_cost_fn
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
from #score_cost_main) as m1
left join
(select
 stratum2
,err_no
 from #cs_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #cs_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #cs_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #cs_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #cs_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #cs_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 4.
--------------------------------------------------------------------------
select
cost_id
into #cost_score_step1
from  @cdmSchema.cost;
--------------------------------------------------------------------------
--> 5.
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 s1.cost_id as uniq_no
,case
  when stratum2 = 'cost_id' then completeness_gb
  else 0
 end as cost_id
,case
  when stratum2 = 'cost_event_id' then completeness_gb
  else 0
 end as cost_event_id
,case
  when stratum2 = 'cost_domain_id' then completeness_gb
  else 0
 end as cost_domain_id
,case
  when stratum2 = 'cost_type_concept_id' then completeness_gb
  else 0
 end as cost_type_concept_id
,case
  when stratum2 = 'currency_concept_id' then completeness_gb
  else 0
 end as currency_concept_id
,case
  when stratum2 = 'total_charge' then completeness_gb
  else 0
 end as total_charge
,case
  when stratum2 = 'total_cost' then completeness_gb
  else 0
 end as total_cost
,case
  when stratum2 = 'total_paid' then completeness_gb
  else 0
 end as total_paid
,case
  when stratum2 = 'paid_by_payer' then completeness_gb
  else 0
 end as paid_by_payer
,case
  when stratum2 = 'paid_by_patient' then completeness_gb
  else 0
 end as paid_by_patient
,case
  when stratum2 = 'paid_patient_copay' then completeness_gb
  else 0
 end as paid_patient_copay
,case
  when stratum2 = 'paid_patient_coinsurance' then completeness_gb
  else 0
 end as paid_patient_coinsurance
,case
  when stratum2 = 'paid_patient_deductible' then completeness_gb
  else 0
 end as paid_patient_deductible
,case
  when stratum2 = 'paid_by_primary' then completeness_gb
  else 0
 end as paid_by_primary
,case
  when stratum2 = 'paid_ingredient_cost' then completeness_gb
  else 0
 end as paid_ingredient_cost
,case
  when stratum2 = 'paid_dispensing_fee' then completeness_gb
  else 0
 end as paid_dispensing_fee
,case
  when stratum2 = 'payer_plan_period_id' then completeness_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'amount_allowed' then completeness_gb
  else 0
 end as amount_allowed
,case
  when stratum2 = 'revenue_code_concept_id' then completeness_gb
  else 0
 end as revenue_code_concept_id
,case
  when stratum2 = 'reveue_code_source_value' then completeness_gb
  else 0
 end as reveue_code_source_value
,case
  when stratum2 = 'drg_concept_id' then completeness_gb
  else 0
 end as drg_concept_id
,case
  when stratum2 = 'drg_source_value' then completeness_gb
  else 0
 end as drg_source_value
 into #cost_score_step2_c
from #cost_score_step1  as s1
left join #score_cost_fn as p1
on s1.cost_id = p1.uniq_no
-- 2
select
 s1.cost_id as uniq_no
,case
  when stratum2 = 'cost_id' then conformance_relation_gb
  else 0
 end as cost_id
,case
  when stratum2 = 'cost_event_id' then conformance_relation_gb
  else 0
 end as cost_event_id
,case
  when stratum2 = 'cost_domain_id' then conformance_relation_gb
  else 0
 end as cost_domain_id
,case
  when stratum2 = 'cost_type_concept_id' then conformance_relation_gb
  else 0
 end as cost_type_concept_id
,case
  when stratum2 = 'currency_concept_id' then conformance_relation_gb
  else 0
 end as currency_concept_id
,case
  when stratum2 = 'total_charge' then conformance_relation_gb
  else 0
 end as total_charge
,case
  when stratum2 = 'total_cost' then conformance_relation_gb
  else 0
 end as total_cost
,case
  when stratum2 = 'total_paid' then conformance_relation_gb
  else 0
 end as total_paid
,case
  when stratum2 = 'paid_by_payer' then conformance_relation_gb
  else 0
 end as paid_by_payer
,case
  when stratum2 = 'paid_by_patient' then conformance_relation_gb
  else 0
 end as paid_by_patient
,case
  when stratum2 = 'paid_patient_copay' then conformance_relation_gb
  else 0
 end as paid_patient_copay
,case
  when stratum2 = 'paid_patient_coinsurance' then conformance_relation_gb
  else 0
 end as paid_patient_coinsurance
,case
  when stratum2 = 'paid_patient_deductible' then conformance_relation_gb
  else 0
 end as paid_patient_deductible
,case
  when stratum2 = 'paid_by_primary' then conformance_relation_gb
  else 0
 end as paid_by_primary
,case
  when stratum2 = 'paid_ingredient_cost' then conformance_relation_gb
  else 0
 end as paid_ingredient_cost
,case
  when stratum2 = 'paid_dispensing_fee' then conformance_relation_gb
  else 0
 end as paid_dispensing_fee
,case
  when stratum2 = 'payer_plan_period_id' then conformance_relation_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'amount_allowed' then conformance_relation_gb
  else 0
 end as amount_allowed
,case
  when stratum2 = 'revenue_code_concept_id' then conformance_relation_gb
  else 0
 end as revenue_code_concept_id
,case
  when stratum2 = 'reveue_code_source_value' then conformance_relation_gb
  else 0
 end as reveue_code_source_value
,case
  when stratum2 = 'drg_concept_id' then conformance_relation_gb
  else 0
 end as drg_concept_id
,case
  when stratum2 = 'drg_source_value' then conformance_relation_gb
  else 0
 end as drg_source_value
 into #cost_score_step2_cr
from #cost_score_step1  as s1
left join #score_cost_fn as p1
on s1.cost_id = p1.uniq_no
-- 3
select
 s1.cost_id as uniq_no
,case
  when stratum2 = 'cost_id' then conformance_value_gb
  else 0
 end as cost_id
,case
  when stratum2 = 'cost_event_id' then conformance_value_gb
  else 0
 end as cost_event_id
,case
  when stratum2 = 'cost_domain_id' then conformance_value_gb
  else 0
 end as cost_domain_id
,case
  when stratum2 = 'cost_type_concept_id' then conformance_value_gb
  else 0
 end as cost_type_concept_id
,case
  when stratum2 = 'currency_concept_id' then conformance_value_gb
  else 0
 end as currency_concept_id
,case
  when stratum2 = 'total_charge' then conformance_value_gb
  else 0
 end as total_charge
,case
  when stratum2 = 'total_cost' then conformance_value_gb
  else 0
 end as total_cost
,case
  when stratum2 = 'total_paid' then conformance_value_gb
  else 0
 end as total_paid
,case
  when stratum2 = 'paid_by_payer' then conformance_value_gb
  else 0
 end as paid_by_payer
,case
  when stratum2 = 'paid_by_patient' then conformance_value_gb
  else 0
 end as paid_by_patient
,case
  when stratum2 = 'paid_patient_copay' then conformance_value_gb
  else 0
 end as paid_patient_copay
,case
  when stratum2 = 'paid_patient_coinsurance' then conformance_value_gb
  else 0
 end as paid_patient_coinsurance
,case
  when stratum2 = 'paid_patient_deductible' then conformance_value_gb
  else 0
 end as paid_patient_deductible
,case
  when stratum2 = 'paid_by_primary' then conformance_value_gb
  else 0
 end as paid_by_primary
,case
  when stratum2 = 'paid_ingredient_cost' then conformance_value_gb
  else 0
 end as paid_ingredient_cost
,case
  when stratum2 = 'paid_dispensing_fee' then conformance_value_gb
  else 0
 end as paid_dispensing_fee
,case
  when stratum2 = 'payer_plan_period_id' then conformance_value_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'amount_allowed' then conformance_value_gb
  else 0
 end as amount_allowed
,case
  when stratum2 = 'revenue_code_concept_id' then conformance_value_gb
  else 0
 end as revenue_code_concept_id
,case
  when stratum2 = 'reveue_code_source_value' then conformance_value_gb
  else 0
 end as reveue_code_source_value
,case
  when stratum2 = 'drg_concept_id' then conformance_value_gb
  else 0
 end as drg_concept_id
,case
  when stratum2 = 'drg_source_value' then conformance_value_gb
  else 0
 end as drg_source_value
 into #cost_score_step2_cv
from #cost_score_step1  as s1
left join #score_cost_fn as p1
on s1.cost_id = p1.uniq_no
-- 4
select
 s1.cost_id as uniq_no
,case
  when stratum2 = 'cost_id' then Uniqueness_gb
  else 0
 end as cost_id
,case
  when stratum2 = 'cost_event_id' then Uniqueness_gb
  else 0
 end as cost_event_id
,case
  when stratum2 = 'cost_domain_id' then Uniqueness_gb
  else 0
 end as cost_domain_id
,case
  when stratum2 = 'cost_type_concept_id' then Uniqueness_gb
  else 0
 end as cost_type_concept_id
,case
  when stratum2 = 'currency_concept_id' then Uniqueness_gb
  else 0
 end as currency_concept_id
,case
  when stratum2 = 'total_charge' then Uniqueness_gb
  else 0
 end as total_charge
,case
  when stratum2 = 'total_cost' then Uniqueness_gb
  else 0
 end as total_cost
,case
  when stratum2 = 'total_paid' then Uniqueness_gb
  else 0
 end as total_paid
,case
  when stratum2 = 'paid_by_payer' then Uniqueness_gb
  else 0
 end as paid_by_payer
,case
  when stratum2 = 'paid_by_patient' then Uniqueness_gb
  else 0
 end as paid_by_patient
,case
  when stratum2 = 'paid_patient_copay' then Uniqueness_gb
  else 0
 end as paid_patient_copay
,case
  when stratum2 = 'paid_patient_coinsurance' then Uniqueness_gb
  else 0
 end as paid_patient_coinsurance
,case
  when stratum2 = 'paid_patient_deductible' then Uniqueness_gb
  else 0
 end as paid_patient_deductible
,case
  when stratum2 = 'paid_by_primary' then Uniqueness_gb
  else 0
 end as paid_by_primary
,case
  when stratum2 = 'paid_ingredient_cost' then Uniqueness_gb
  else 0
 end as paid_ingredient_cost
,case
  when stratum2 = 'paid_dispensing_fee' then Uniqueness_gb
  else 0
 end as paid_dispensing_fee
,case
  when stratum2 = 'payer_plan_period_id' then Uniqueness_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'amount_allowed' then Uniqueness_gb
  else 0
 end as amount_allowed
,case
  when stratum2 = 'revenue_code_concept_id' then Uniqueness_gb
  else 0
 end as revenue_code_concept_id
,case
  when stratum2 = 'reveue_code_source_value' then Uniqueness_gb
  else 0
 end as reveue_code_source_value
,case
  when stratum2 = 'drg_concept_id' then Uniqueness_gb
  else 0
 end as drg_concept_id
,case
  when stratum2 = 'drg_source_value' then Uniqueness_gb
  else 0
 end as drg_source_value
 into #cost_score_step2_u
from #cost_score_step1  as s1
left join #score_cost_fn as p1
on s1.cost_id = p1.uniq_no
-- 5
select
 s1.cost_id as uniq_no
,case
  when stratum2 = 'cost_id' then plausibility_atemporal_gb
  else 0
 end as cost_id
,case
  when stratum2 = 'cost_event_id' then plausibility_atemporal_gb
  else 0
 end as cost_event_id
,case
  when stratum2 = 'cost_domain_id' then plausibility_atemporal_gb
  else 0
 end as cost_domain_id
,case
  when stratum2 = 'cost_type_concept_id' then plausibility_atemporal_gb
  else 0
 end as cost_type_concept_id
,case
  when stratum2 = 'currency_concept_id' then plausibility_atemporal_gb
  else 0
 end as currency_concept_id
,case
  when stratum2 = 'total_charge' then plausibility_atemporal_gb
  else 0
 end as total_charge
,case
  when stratum2 = 'total_cost' then plausibility_atemporal_gb
  else 0
 end as total_cost
,case
  when stratum2 = 'total_paid' then plausibility_atemporal_gb
  else 0
 end as total_paid
,case
  when stratum2 = 'paid_by_payer' then plausibility_atemporal_gb
  else 0
 end as paid_by_payer
,case
  when stratum2 = 'paid_by_patient' then plausibility_atemporal_gb
  else 0
 end as paid_by_patient
,case
  when stratum2 = 'paid_patient_copay' then plausibility_atemporal_gb
  else 0
 end as paid_patient_copay
,case
  when stratum2 = 'paid_patient_coinsurance' then plausibility_atemporal_gb
  else 0
 end as paid_patient_coinsurance
,case
  when stratum2 = 'paid_patient_deductible' then plausibility_atemporal_gb
  else 0
 end as paid_patient_deductible
,case
  when stratum2 = 'paid_by_primary' then plausibility_atemporal_gb
  else 0
 end as paid_by_primary
,case
  when stratum2 = 'paid_ingredient_cost' then plausibility_atemporal_gb
  else 0
 end as paid_ingredient_cost
,case
  when stratum2 = 'paid_dispensing_fee' then plausibility_atemporal_gb
  else 0
 end as paid_dispensing_fee
,case
  when stratum2 = 'payer_plan_period_id' then plausibility_atemporal_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'amount_allowed' then plausibility_atemporal_gb
  else 0
 end as amount_allowed
,case
  when stratum2 = 'revenue_code_concept_id' then plausibility_atemporal_gb
  else 0
 end as revenue_code_concept_id
,case
  when stratum2 = 'reveue_code_source_value' then plausibility_atemporal_gb
  else 0
 end as reveue_code_source_value
,case
  when stratum2 = 'drg_concept_id' then plausibility_atemporal_gb
  else 0
 end as drg_concept_id
,case
  when stratum2 = 'drg_source_value' then plausibility_atemporal_gb
  else 0
 end as drg_source_value
 into #cost_score_step2_ap
from #cost_score_step1  as s1
left join #score_cost_fn as p1
on s1.cost_id = p1.uniq_no
-- 6
select
 s1.cost_id as uniq_no
,case
  when stratum2 = 'cost_id' then Accuracy_gb
  else 0
 end as cost_id
,case
  when stratum2 = 'cost_event_id' then Accuracy_gb
  else 0
 end as cost_event_id
,case
  when stratum2 = 'cost_domain_id' then Accuracy_gb
  else 0
 end as cost_domain_id
,case
  when stratum2 = 'cost_type_concept_id' then Accuracy_gb
  else 0
 end as cost_type_concept_id
,case
  when stratum2 = 'currency_concept_id' then Accuracy_gb
  else 0
 end as currency_concept_id
,case
  when stratum2 = 'total_charge' then Accuracy_gb
  else 0
 end as total_charge
,case
  when stratum2 = 'total_cost' then Accuracy_gb
  else 0
 end as total_cost
,case
  when stratum2 = 'total_paid' then Accuracy_gb
  else 0
 end as total_paid
,case
  when stratum2 = 'paid_by_payer' then Accuracy_gb
  else 0
 end as paid_by_payer
,case
  when stratum2 = 'paid_by_patient' then Accuracy_gb
  else 0
 end as paid_by_patient
,case
  when stratum2 = 'paid_patient_copay' then Accuracy_gb
  else 0
 end as paid_patient_copay
,case
  when stratum2 = 'paid_patient_coinsurance' then Accuracy_gb
  else 0
 end as paid_patient_coinsurance
,case
  when stratum2 = 'paid_patient_deductible' then Accuracy_gb
  else 0
 end as paid_patient_deductible
,case
  when stratum2 = 'paid_by_primary' then Accuracy_gb
  else 0
 end as paid_by_primary
,case
  when stratum2 = 'paid_ingredient_cost' then Accuracy_gb
  else 0
 end as paid_ingredient_cost
,case
  when stratum2 = 'paid_dispensing_fee' then Accuracy_gb
  else 0
 end as paid_dispensing_fee
,case
  when stratum2 = 'payer_plan_period_id' then Accuracy_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'amount_allowed' then Accuracy_gb
  else 0
 end as amount_allowed
,case
  when stratum2 = 'revenue_code_concept_id' then Accuracy_gb
  else 0
 end as revenue_code_concept_id
,case
  when stratum2 = 'reveue_code_source_value' then Accuracy_gb
  else 0
 end as reveue_code_source_value
,case
  when stratum2 = 'drg_concept_id' then Accuracy_gb
  else 0
 end as drg_concept_id
,case
  when stratum2 = 'drg_source_value' then Accuracy_gb
  else 0
 end as drg_source_value
 into #cost_score_step2_ac
from #cost_score_step1  as s1
left join #score_cost_fn as p1
on s1.cost_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 uniq_no
,sum(cost_id) as cost_id
,sum(cost_event_id) as cost_event_id
,sum(cost_domain_id) as cost_domain_id
,sum(cost_type_concept_id) as cost_type_concept_id
,sum(currency_concept_id) as currency_concept_id
,sum(total_charge) as total_charge
,sum(total_cost) as total_cost
,sum(total_paid) as total_paid
,sum(paid_by_payer) as paid_by_payer
,sum(paid_by_patient) as paid_by_patient
,sum(paid_patient_copay) as paid_patient_copay
,sum(paid_patient_coinsurance) as paid_patient_coinsurance
,sum(paid_patient_deductible) as paid_patient_deductible
,sum(paid_by_primary) as paid_by_primary
,sum(paid_ingredient_cost) as paid_ingredient_cost
,sum(paid_dispensing_fee) as paid_dispensing_fee
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(amount_allowed) as amount_allowed
,sum(revenue_code_concept_id) as revenue_code_concept_id
,sum(reveue_code_source_value) as reveue_code_source_value
,sum(drg_concept_id) as drg_concept_id
,sum(drg_source_value) as drg_source_value
 into #cost_score_step3_c
from #cost_score_step2_c
group by uniq_no
-- 2
select
 uniq_no
,sum(cost_id) as cost_id
,sum(cost_event_id) as cost_event_id
,sum(cost_domain_id) as cost_domain_id
,sum(cost_type_concept_id) as cost_type_concept_id
,sum(currency_concept_id) as currency_concept_id
,sum(total_charge) as total_charge
,sum(total_cost) as total_cost
,sum(total_paid) as total_paid
,sum(paid_by_payer) as paid_by_payer
,sum(paid_by_patient) as paid_by_patient
,sum(paid_patient_copay) as paid_patient_copay
,sum(paid_patient_coinsurance) as paid_patient_coinsurance
,sum(paid_patient_deductible) as paid_patient_deductible
,sum(paid_by_primary) as paid_by_primary
,sum(paid_ingredient_cost) as paid_ingredient_cost
,sum(paid_dispensing_fee) as paid_dispensing_fee
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(amount_allowed) as amount_allowed
,sum(revenue_code_concept_id) as revenue_code_concept_id
,sum(reveue_code_source_value) as reveue_code_source_value
,sum(drg_concept_id) as drg_concept_id
,sum(drg_source_value) as drg_source_value
 into #cost_score_step3_cr
from #cost_score_step2_cr
group by uniq_no
-- 3
select
 uniq_no
,sum(cost_id) as cost_id
,sum(cost_event_id) as cost_event_id
,sum(cost_domain_id) as cost_domain_id
,sum(cost_type_concept_id) as cost_type_concept_id
,sum(currency_concept_id) as currency_concept_id
,sum(total_charge) as total_charge
,sum(total_cost) as total_cost
,sum(total_paid) as total_paid
,sum(paid_by_payer) as paid_by_payer
,sum(paid_by_patient) as paid_by_patient
,sum(paid_patient_copay) as paid_patient_copay
,sum(paid_patient_coinsurance) as paid_patient_coinsurance
,sum(paid_patient_deductible) as paid_patient_deductible
,sum(paid_by_primary) as paid_by_primary
,sum(paid_ingredient_cost) as paid_ingredient_cost
,sum(paid_dispensing_fee) as paid_dispensing_fee
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(amount_allowed) as amount_allowed
,sum(revenue_code_concept_id) as revenue_code_concept_id
,sum(reveue_code_source_value) as reveue_code_source_value
,sum(drg_concept_id) as drg_concept_id
,sum(drg_source_value) as drg_source_value
 into #cost_score_step3_cv
from #cost_score_step2_cv
group by uniq_no
-- 4
select
 uniq_no
,sum(cost_id) as cost_id
,sum(cost_event_id) as cost_event_id
,sum(cost_domain_id) as cost_domain_id
,sum(cost_type_concept_id) as cost_type_concept_id
,sum(currency_concept_id) as currency_concept_id
,sum(total_charge) as total_charge
,sum(total_cost) as total_cost
,sum(total_paid) as total_paid
,sum(paid_by_payer) as paid_by_payer
,sum(paid_by_patient) as paid_by_patient
,sum(paid_patient_copay) as paid_patient_copay
,sum(paid_patient_coinsurance) as paid_patient_coinsurance
,sum(paid_patient_deductible) as paid_patient_deductible
,sum(paid_by_primary) as paid_by_primary
,sum(paid_ingredient_cost) as paid_ingredient_cost
,sum(paid_dispensing_fee) as paid_dispensing_fee
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(amount_allowed) as amount_allowed
,sum(revenue_code_concept_id) as revenue_code_concept_id
,sum(reveue_code_source_value) as reveue_code_source_value
,sum(drg_concept_id) as drg_concept_id
,sum(drg_source_value) as drg_source_value
 into #cost_score_step3_u
from #cost_score_step2_u
group by uniq_no
-- 5
select
 uniq_no
,sum(cost_id) as cost_id
,sum(cost_event_id) as cost_event_id
,sum(cost_domain_id) as cost_domain_id
,sum(cost_type_concept_id) as cost_type_concept_id
,sum(currency_concept_id) as currency_concept_id
,sum(total_charge) as total_charge
,sum(total_cost) as total_cost
,sum(total_paid) as total_paid
,sum(paid_by_payer) as paid_by_payer
,sum(paid_by_patient) as paid_by_patient
,sum(paid_patient_copay) as paid_patient_copay
,sum(paid_patient_coinsurance) as paid_patient_coinsurance
,sum(paid_patient_deductible) as paid_patient_deductible
,sum(paid_by_primary) as paid_by_primary
,sum(paid_ingredient_cost) as paid_ingredient_cost
,sum(paid_dispensing_fee) as paid_dispensing_fee
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(amount_allowed) as amount_allowed
,sum(revenue_code_concept_id) as revenue_code_concept_id
,sum(reveue_code_source_value) as reveue_code_source_value
,sum(drg_concept_id) as drg_concept_id
,sum(drg_source_value) as drg_source_value
 into #cost_score_step3_ap
from #cost_score_step2_ap
group by uniq_no
-- 6
select
 uniq_no
,sum(cost_id) as cost_id
,sum(cost_event_id) as cost_event_id
,sum(cost_domain_id) as cost_domain_id
,sum(cost_type_concept_id) as cost_type_concept_id
,sum(currency_concept_id) as currency_concept_id
,sum(total_charge) as total_charge
,sum(total_cost) as total_cost
,sum(total_paid) as total_paid
,sum(paid_by_payer) as paid_by_payer
,sum(paid_by_patient) as paid_by_patient
,sum(paid_patient_copay) as paid_patient_copay
,sum(paid_patient_coinsurance) as paid_patient_coinsurance
,sum(paid_patient_deductible) as paid_patient_deductible
,sum(paid_by_primary) as paid_by_primary
,sum(paid_ingredient_cost) as paid_ingredient_cost
,sum(paid_dispensing_fee) as paid_dispensing_fee
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(amount_allowed) as amount_allowed
,sum(revenue_code_concept_id) as revenue_code_concept_id
,sum(reveue_code_source_value) as reveue_code_source_value
,sum(drg_concept_id) as drg_concept_id
,sum(drg_source_value) as drg_source_value
 into #cost_score_step3_ac
from #cost_score_step2_ac
group by uniq_no
--------------------------------------------------------------------------
--> 7. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 'Completeness score: Cost' as name
,cast(1.0-((
  ((s2.score_cost_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_event_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_domain_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_type_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_currency_concept_id/m1.max_uniq_no)*0.03333333339)+
  ((s2.score_total_charge/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_total_cost/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_total_paid/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_payer/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_patient/max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_copay/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_coinsurance/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_deductible/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_primary/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_ingredient_cost/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_dispensing_fee/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_amount_allowed/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_revenue_code_concept_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_reveue_code_source_value/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_drg_concept_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_drg_source_value/m1.max_uniq_no)*0.03333333333))) as float)
from
(select
 sum(cost_id) as score_cost_id
,sum(cost_event_id) as score_cost_event_id
,sum(cost_domain_id) as score_cost_domain_id
,sum(cost_type_concept_id) as score_cost_type_concept_id
,sum(currency_concept_id) as score_currency_concept_id
,sum(total_charge) as score_total_charge
,sum(total_cost) as score_total_cost
,sum(total_paid) as score_total_paid
,sum(paid_by_payer) as score_paid_by_payer
,sum(paid_by_patient) as score_paid_by_patient
,sum(paid_patient_copay) as score_paid_patient_copay
,sum(paid_patient_coinsurance) as score_paid_patient_coinsurance
,sum(paid_patient_deductible) as score_paid_patient_deductible
,sum(paid_by_primary) as score_paid_by_primary
,sum(paid_ingredient_cost) as score_paid_ingredient_cost
,sum(paid_dispensing_fee) as score_paid_dispensing_fee
,sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(amount_allowed) as score_amount_allowed
,sum(revenue_code_concept_id) as score_revenue_code_concept_id
,sum(reveue_code_source_value) as score_reveue_code_source_value
,sum(drg_concept_id) as score_drg_concept_id
,sum(drg_source_value) as score_drg_source_value
from #cost_score_step3_c) as s2
cross join
(select count(cost_id) as max_uniq_no from @cdmSchema.cost) as m1
-- 2
select
 'Conformance-relation score: Cost' as name
,cast(1.0-((
  ((s2.score_cost_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_event_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_domain_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_type_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_currency_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_total_charge/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_total_cost/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_total_paid/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_paid_by_payer/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_paid_by_patient/max_uniq_no)*0.01428571423)+
  ((s2.score_paid_patient_copay/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_paid_patient_coinsurance/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_paid_patient_deductible/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_paid_by_primary/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_paid_ingredient_cost/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_paid_dispensing_fee/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.1)+
  ((s2.score_amount_allowed/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_revenue_code_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_reveue_code_source_value/m1.max_uniq_no)*0.01428571423)+
  ((s2.score_drg_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_drg_source_value/m1.max_uniq_no)*0.01428571423))) as float)
from
(select
 sum(cost_id) as score_cost_id
,sum(cost_event_id) as score_cost_event_id
,sum(cost_domain_id) as score_cost_domain_id
,sum(cost_type_concept_id) as score_cost_type_concept_id
,sum(currency_concept_id) as score_currency_concept_id
,sum(total_charge) as score_total_charge
,sum(total_cost) as score_total_cost
,sum(total_paid) as score_total_paid
,sum(paid_by_payer) as score_paid_by_payer
,sum(paid_by_patient) as score_paid_by_patient
,sum(paid_patient_copay) as score_paid_patient_copay
,sum(paid_patient_coinsurance) as score_paid_patient_coinsurance
,sum(paid_patient_deductible) as score_paid_patient_deductible
,sum(paid_by_primary) as score_paid_by_primary
,sum(paid_ingredient_cost) as score_paid_ingredient_cost
,sum(paid_dispensing_fee) as score_paid_dispensing_fee
,sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(amount_allowed) as score_amount_allowed
,sum(revenue_code_concept_id) as score_revenue_code_concept_id
,sum(reveue_code_source_value) as score_reveue_code_source_value
,sum(drg_concept_id) as score_drg_concept_id
,sum(drg_source_value) as score_drg_source_value
from #cost_score_step3_cr) as s2
cross join
(select count(cost_id) as max_uniq_no from @cdmSchema.cost) as m1
-- 3
select
 'Conformance-value score: Cost' as name
,cast(1.0-((
  ((s2.score_cost_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_cost_event_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_cost_domain_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_cost_type_concept_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_currency_concept_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_total_charge/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_total_cost/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_total_paid/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_by_payer/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_by_patient/max_uniq_no)*0.04545454546)+
  ((s2.score_paid_patient_copay/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_patient_coinsurance/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_patient_deductible/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_by_primary/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_ingredient_cost/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_dispensing_fee/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_amount_allowed/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_revenue_code_concept_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_reveue_code_source_value/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_drg_concept_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_drg_source_value/m1.max_uniq_no)*0.04545454546))) as float)
from
(select
 sum(cost_id) as score_cost_id
,sum(cost_event_id) as score_cost_event_id
,sum(cost_domain_id) as score_cost_domain_id
,sum(cost_type_concept_id) as score_cost_type_concept_id
,sum(currency_concept_id) as score_currency_concept_id
,sum(total_charge) as score_total_charge
,sum(total_cost) as score_total_cost
,sum(total_paid) as score_total_paid
,sum(paid_by_payer) as score_paid_by_payer
,sum(paid_by_patient) as score_paid_by_patient
,sum(paid_patient_copay) as score_paid_patient_copay
,sum(paid_patient_coinsurance) as score_paid_patient_coinsurance
,sum(paid_patient_deductible) as score_paid_patient_deductible
,sum(paid_by_primary) as score_paid_by_primary
,sum(paid_ingredient_cost) as score_paid_ingredient_cost
,sum(paid_dispensing_fee) as score_paid_dispensing_fee
,sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(amount_allowed) as score_amount_allowed
,sum(revenue_code_concept_id) as score_revenue_code_concept_id
,sum(reveue_code_source_value) as score_reveue_code_source_value
,sum(drg_concept_id) as score_drg_concept_id
,sum(drg_source_value) as score_drg_source_value
from #cost_score_step3_cv) as s2
cross join
(select count(cost_id) as max_uniq_no from @cdmSchema.cost) as m1
-- 4
select
 'Uniqueness score: Cost' as name
,cast(1.0-((
  ((s2.score_cost_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_cost_event_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_cost_domain_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_cost_type_concept_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_currency_concept_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_total_charge/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_total_cost/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_total_paid/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_by_payer/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_by_patient/max_uniq_no)*0.04545454546)+
  ((s2.score_paid_patient_copay/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_patient_coinsurance/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_patient_deductible/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_by_primary/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_ingredient_cost/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_paid_dispensing_fee/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_amount_allowed/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_revenue_code_concept_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_reveue_code_source_value/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_drg_concept_id/m1.max_uniq_no)*0.04545454546)+
  ((s2.score_drg_source_value/m1.max_uniq_no)*0.04545454546))) as float)
from
(select
 sum(cost_id) as score_cost_id
,sum(cost_event_id) as score_cost_event_id
,sum(cost_domain_id) as score_cost_domain_id
,sum(cost_type_concept_id) as score_cost_type_concept_id
,sum(currency_concept_id) as score_currency_concept_id
,sum(total_charge) as score_total_charge
,sum(total_cost) as score_total_cost
,sum(total_paid) as score_total_paid
,sum(paid_by_payer) as score_paid_by_payer
,sum(paid_by_patient) as score_paid_by_patient
,sum(paid_patient_copay) as score_paid_patient_copay
,sum(paid_patient_coinsurance) as score_paid_patient_coinsurance
,sum(paid_patient_deductible) as score_paid_patient_deductible
,sum(paid_by_primary) as score_paid_by_primary
,sum(paid_ingredient_cost) as score_paid_ingredient_cost
,sum(paid_dispensing_fee) as score_paid_dispensing_fee
,sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(amount_allowed) as score_amount_allowed
,sum(revenue_code_concept_id) as score_revenue_code_concept_id
,sum(reveue_code_source_value) as score_reveue_code_source_value
,sum(drg_concept_id) as score_drg_concept_id
,sum(drg_source_value) as score_drg_source_value
from #cost_score_step3_u) as s2
cross join
(select count(cost_id) as max_uniq_no from @cdmSchema.cost) as m1
-- 5
select
 'Plausibility-Atemporal score: Cost' as name
,cast(1.0-((
  ((s2.score_cost_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_event_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_domain_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_type_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_currency_concept_id/m1.max_uniq_no)*0.03333333339)+
  ((s2.score_total_charge/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_total_cost/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_total_paid/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_payer/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_patient/max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_copay/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_coinsurance/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_deductible/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_primary/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_ingredient_cost/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_dispensing_fee/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_amount_allowed/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_revenue_code_concept_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_reveue_code_source_value/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_drg_concept_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_drg_source_value/m1.max_uniq_no)*0.03333333333))) as float)
from
(select
 sum(cost_id) as score_cost_id
,sum(cost_event_id) as score_cost_event_id
,sum(cost_domain_id) as score_cost_domain_id
,sum(cost_type_concept_id) as score_cost_type_concept_id
,sum(currency_concept_id) as score_currency_concept_id
,sum(total_charge) as score_total_charge
,sum(total_cost) as score_total_cost
,sum(total_paid) as score_total_paid
,sum(paid_by_payer) as score_paid_by_payer
,sum(paid_by_patient) as score_paid_by_patient
,sum(paid_patient_copay) as score_paid_patient_copay
,sum(paid_patient_coinsurance) as score_paid_patient_coinsurance
,sum(paid_patient_deductible) as score_paid_patient_deductible
,sum(paid_by_primary) as score_paid_by_primary
,sum(paid_ingredient_cost) as score_paid_ingredient_cost
,sum(paid_dispensing_fee) as score_paid_dispensing_fee
,sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(amount_allowed) as score_amount_allowed
,sum(revenue_code_concept_id) as score_revenue_code_concept_id
,sum(reveue_code_source_value) as score_reveue_code_source_value
,sum(drg_concept_id) as score_drg_concept_id
,sum(drg_source_value) as score_drg_source_value
from #cost_score_step3_ap) as s2
cross join
(select count(cost_id) as max_uniq_no from @cdmSchema.cost) as m1
-- 6
select
 'Accuracy score: Cost' as name
,cast(1.0-((
  ((s2.score_cost_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_event_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_domain_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_type_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_currency_concept_id/m1.max_uniq_no)*0.03333333339)+
  ((s2.score_total_charge/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_total_cost/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_total_paid/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_payer/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_patient/max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_copay/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_coinsurance/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_deductible/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_primary/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_ingredient_cost/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_dispensing_fee/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_amount_allowed/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_revenue_code_concept_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_reveue_code_source_value/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_drg_concept_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_drg_source_value/m1.max_uniq_no)*0.03333333333))) as float)
from
(select
 sum(cost_id) as score_cost_id
,sum(cost_event_id) as score_cost_event_id
,sum(cost_domain_id) as score_cost_domain_id
,sum(cost_type_concept_id) as score_cost_type_concept_id
,sum(currency_concept_id) as score_currency_concept_id
,sum(total_charge) as score_total_charge
,sum(total_cost) as score_total_cost
,sum(total_paid) as score_total_paid
,sum(paid_by_payer) as score_paid_by_payer
,sum(paid_by_patient) as score_paid_by_patient
,sum(paid_patient_copay) as score_paid_patient_copay
,sum(paid_patient_coinsurance) as score_paid_patient_coinsurance
,sum(paid_patient_deductible) as score_paid_patient_deductible
,sum(paid_by_primary) as score_paid_by_primary
,sum(paid_ingredient_cost) as score_paid_ingredient_cost
,sum(paid_dispensing_fee) as score_paid_dispensing_fee
,sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(amount_allowed) as score_amount_allowed
,sum(revenue_code_concept_id) as score_revenue_code_concept_id
,sum(reveue_code_source_value) as score_reveue_code_source_value
,sum(drg_concept_id) as score_drg_concept_id
,sum(drg_source_value) as score_drg_source_value
from #cost_score_step3_ac) as s2
cross join
(select count(cost_id) as max_uniq_no from @cdmSchema.cost) as m1
--------------------------------------------------------------------------
--> 8. Lable DQ concept
--------------------------------------------------------------------------
select
    *
into #score_cost_fn_t
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
from #score_cost_main) as m1
left join
(select
 stratum2
,err_no
 from #cs_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #cs_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #cs_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #cs_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #cs_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #cs_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 9.
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 s1.cost_id as uniq_no
,case
  when stratum2 = 'cost_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as cost_id
,case
  when stratum2 = 'cost_event_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as cost_event_id
,case
  when stratum2 = 'cost_domain_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as cost_domain_id
,case
  when stratum2 = 'cost_type_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as cost_type_concept_id
,case
  when stratum2 = 'currency_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as currency_concept_id
,case
  when stratum2 = 'total_charge' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as total_charge
,case
  when stratum2 = 'total_cost' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as total_cost
,case
  when stratum2 = 'total_paid' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as total_paid
,case
  when stratum2 = 'paid_by_payer' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as paid_by_payer
,case
  when stratum2 = 'paid_by_patient' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as paid_by_patient
,case
  when stratum2 = 'paid_patient_copay' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as paid_patient_copay
,case
  when stratum2 = 'paid_patient_coinsurance' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as paid_patient_coinsurance
,case
  when stratum2 = 'paid_patient_deductible' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as paid_patient_deductible
,case
  when stratum2 = 'paid_by_primary' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as paid_by_primary
,case
  when stratum2 = 'paid_ingredient_cost' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as paid_ingredient_cost
,case
  when stratum2 = 'paid_dispensing_fee' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as paid_dispensing_fee
,case
  when stratum2 = 'payer_plan_period_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'amount_allowed' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as amount_allowed
,case
  when stratum2 = 'revenue_code_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as revenue_code_concept_id
,case
  when stratum2 = 'reveue_code_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as reveue_code_source_value
,case
  when stratum2 = 'drg_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as drg_concept_id
,case
  when stratum2 = 'drg_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as drg_source_value
 into #cost_score_step2_t
from #cost_score_step1  as s1
left join #score_cost_fn_t as p1
on s1.cost_id = p1.uniq_no
--------------------------------------------------------------------------
--> 10. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 uniq_no
,sum(cost_id) as cost_id
,sum(cost_event_id) as cost_event_id
,sum(cost_domain_id) as cost_domain_id
,sum(cost_type_concept_id) as cost_type_concept_id
,sum(currency_concept_id) as currency_concept_id
,sum(total_charge) as total_charge
,sum(total_cost) as total_cost
,sum(total_paid) as total_paid
,sum(paid_by_payer) as paid_by_payer
,sum(paid_by_patient) as paid_by_patient
,sum(paid_patient_copay) as paid_patient_copay
,sum(paid_patient_coinsurance) as paid_patient_coinsurance
,sum(paid_patient_deductible) as paid_patient_deductible
,sum(paid_by_primary) as paid_by_primary
,sum(paid_ingredient_cost) as paid_ingredient_cost
,sum(paid_dispensing_fee) as paid_dispensing_fee
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(amount_allowed) as amount_allowed
,sum(revenue_code_concept_id) as revenue_code_concept_id
,sum(reveue_code_source_value) as reveue_code_source_value
,sum(drg_concept_id) as drg_concept_id
,sum(drg_source_value) as drg_source_value
 into #cost_score_step3_t
from #cost_score_step2_t
group by uniq_no
--------------------------------------------------------------------------
--> 11. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 'Table score: Cost' as name
,cast(1.0-((
  ((s2.score_cost_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_event_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_domain_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cost_type_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_currency_concept_id/m1.max_uniq_no)*0.03333333339)+
  ((s2.score_total_charge/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_total_cost/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_total_paid/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_payer/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_patient/max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_copay/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_coinsurance/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_patient_deductible/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_by_primary/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_ingredient_cost/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_paid_dispensing_fee/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_amount_allowed/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_revenue_code_concept_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_reveue_code_source_value/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_drg_concept_id/m1.max_uniq_no)*0.03333333333)+
  ((s2.score_drg_source_value/m1.max_uniq_no)*0.03333333333))) as float)
from
(select
 sum(cost_id) as score_cost_id
,sum(cost_event_id) as score_cost_event_id
,sum(cost_domain_id) as score_cost_domain_id
,sum(cost_type_concept_id) as score_cost_type_concept_id
,sum(currency_concept_id) as score_currency_concept_id
,sum(total_charge) as score_total_charge
,sum(total_cost) as score_total_cost
,sum(total_paid) as score_total_paid
,sum(paid_by_payer) as score_paid_by_payer
,sum(paid_by_patient) as score_paid_by_patient
,sum(paid_patient_copay) as score_paid_patient_copay
,sum(paid_patient_coinsurance) as score_paid_patient_coinsurance
,sum(paid_patient_deductible) as score_paid_patient_deductible
,sum(paid_by_primary) as score_paid_by_primary
,sum(paid_ingredient_cost) as score_paid_ingredient_cost
,sum(paid_dispensing_fee) as score_paid_dispensing_fee
,sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(amount_allowed) as score_amount_allowed
,sum(revenue_code_concept_id) as score_revenue_code_concept_id
,sum(reveue_code_source_value) as score_reveue_code_source_value
,sum(drg_concept_id) as score_drg_concept_id
,sum(drg_source_value) as score_drg_source_value
from #cost_score_step3_t) as s2
cross join
(select count(cost_id) as max_uniq_no from @cdmSchema.cost) as m1