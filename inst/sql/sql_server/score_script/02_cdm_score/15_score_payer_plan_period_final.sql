IF OBJECT_ID('tempdb..#score_payer_plan_period_main','U') is not null drop table #score_payer_plan_period_main 
IF OBJECT_ID('tempdb..#pp_Completeness_gb','U') is not null drop table #pp_Completeness_gb 
IF OBJECT_ID('tempdb..#pp_Conformance_value_gb','U') is not null drop table #pp_Conformance_value_gb 
IF OBJECT_ID('tempdb..#pp_Conformance_relation_gb','U') is not null drop table #pp_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#pp_Uniqueness_gb','U') is not null drop table #pp_Uniqueness_gb 
IF OBJECT_ID('tempdb..#pp_Plausibility_atemporal_gb','U') is not null drop table #pp_Plausibility_atemporal_gb 
IF OBJECT_ID('tempdb..#pp_Accuracy_gb','U') is not null drop table #pp_Accuracy_gb 
IF OBJECT_ID('tempdb..#score_payer_plan_period_fn','U') is not null drop table #score_payer_plan_period_fn 
IF OBJECT_ID('tempdb..#payer_plan_period_score_step1','U') is not null drop table #payer_plan_period_score_step1 
IF OBJECT_ID('tempdb..#score_payer_plan_period_fn_t','U') is not null drop table #score_payer_plan_period_fn_t 

--> 1. order by the table error uniq_number
--> DQ concept of uniq stratum2 null select
--------------------------------------------------------------------------
select
distinct
 tb_id
,stratum2
,err_no as uniq_no
into #score_payer_plan_period_main
from @resultSchema.score_log_CDM
where tb_id = 30;
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
into #pp_Completeness_gb
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
where sm1.tb_id =30)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #pp_Conformance_value_gb
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
where sm1.tb_id =30)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #pp_Conformance_relation_gb
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
where sm1.tb_id =30)v
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
into #pp_Uniqueness_gb
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
where sm1.tb_id =30)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #pp_Plausibility_atemporal_gb
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
where sm1.tb_id =30)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #pp_Accuracy_gb
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
where sm1.tb_id =30)v
--------------------------------------------------------------------------
--> 3. Lable DQ concept
--------------------------------------------------------------------------
select
    *
into #score_payer_plan_period_fn
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
from #score_payer_plan_period_main) as m1
left join
(select
 stratum2
,err_no
 from #pp_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #pp_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #pp_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #pp_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #pp_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #pp_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 4.
--------------------------------------------------------------------------
select
payer_plan_period_id
into #payer_plan_period_score_step1
from  @cdmSchema.payer_plan_period;
--------------------------------------------------------------------------
--> 5.
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 s1.payer_plan_period_id as uniq_no
,case
  when stratum2 = 'payer_plan_period_id' then completeness_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'person_id' then completeness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'payer_plan_period_start_date' then completeness_gb
  else 0
 end as payer_plan_period_start_date
,case
  when stratum2 = 'payer_plan_period_end_date' then completeness_gb
  else 0
 end as payer_plan_period_end_date
,case
  when stratum2 = 'payer_concept_id' then completeness_gb
  else 0
 end as payer_concept_id
,case
  when stratum2 = 'payer_source_value' then completeness_gb
  else 0
 end as payer_source_value
,case
  when stratum2 = 'payer_source_concept_id' then completeness_gb
  else 0
 end as payer_source_concept_id
,case
  when stratum2 = 'plan_concept_id' then completeness_gb
  else 0
 end as plan_concept_id
,case
  when stratum2 = 'plan_source_value' then completeness_gb
  else 0
 end as plan_source_value
,case
  when stratum2 = 'plan_source_concept_id' then completeness_gb
  else 0
 end as plan_source_concept_id
,case
  when stratum2 = 'sponsor_concept_id' then completeness_gb
  else 0
 end as sponsor_concept_id
,case
  when stratum2 = 'sponsor_source_value' then completeness_gb
  else 0
 end as sponsor_source_value
,case
  when stratum2 = 'sponsor_source_concept_id' then completeness_gb
  else 0
 end as sponsor_source_concept_id
,case
  when stratum2 = 'family_source_value' then completeness_gb
  else 0
 end as family_source_value
,case
  when stratum2 = 'stop_reason_concept_id' then completeness_gb
  else 0
 end as stop_reason_concept_id
,case
  when stratum2 = 'stop_reason_source_value' then completeness_gb
  else 0
 end as stop_reason_source_value
,case
  when stratum2 = 'stop_reason_source_concept_id' then completeness_gb
  else 0
 end as stop_reason_source_concept_id
 into #payer_plan_period_score_step2_c
from #payer_plan_period_score_step1  as s1
left join #score_payer_plan_period_fn as p1
on s1.payer_plan_period_id = p1.uniq_no
-- 2
select
 s1.payer_plan_period_id as uniq_no
,case
  when stratum2 = 'payer_plan_period_id' then conformance_relation_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'person_id' then conformance_relation_gb
  else 0
 end as person_id
,case
  when stratum2 = 'payer_plan_period_start_date' then conformance_relation_gb
  else 0
 end as payer_plan_period_start_date
,case
  when stratum2 = 'payer_plan_period_end_date' then conformance_relation_gb
  else 0
 end as payer_plan_period_end_date
,case
  when stratum2 = 'payer_concept_id' then conformance_relation_gb
  else 0
 end as payer_concept_id
,case
  when stratum2 = 'payer_source_value' then conformance_relation_gb
  else 0
 end as payer_source_value
,case
  when stratum2 = 'payer_source_concept_id' then conformance_relation_gb
  else 0
 end as payer_source_concept_id
,case
  when stratum2 = 'plan_concept_id' then conformance_relation_gb
  else 0
 end as plan_concept_id
,case
  when stratum2 = 'plan_source_value' then conformance_relation_gb
  else 0
 end as plan_source_value
,case
  when stratum2 = 'plan_source_concept_id' then conformance_relation_gb
  else 0
 end as plan_source_concept_id
,case
  when stratum2 = 'sponsor_concept_id' then conformance_relation_gb
  else 0
 end as sponsor_concept_id
,case
  when stratum2 = 'sponsor_source_value' then conformance_relation_gb
  else 0
 end as sponsor_source_value
,case
  when stratum2 = 'sponsor_source_concept_id' then conformance_relation_gb
  else 0
 end as sponsor_source_concept_id
,case
  when stratum2 = 'family_source_value' then conformance_relation_gb
  else 0
 end as family_source_value
,case
  when stratum2 = 'stop_reason_concept_id' then conformance_relation_gb
  else 0
 end as stop_reason_concept_id
,case
  when stratum2 = 'stop_reason_source_value' then conformance_relation_gb
  else 0
 end as stop_reason_source_value
,case
  when stratum2 = 'stop_reason_source_concept_id' then conformance_relation_gb
  else 0
 end as stop_reason_source_concept_id
 into #payer_plan_period_score_step2_cr
from #payer_plan_period_score_step1  as s1
left join #score_payer_plan_period_fn as p1
on s1.payer_plan_period_id = p1.uniq_no
-- 3
select
 s1.payer_plan_period_id as uniq_no
,case
  when stratum2 = 'payer_plan_period_id' then conformance_value_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'person_id' then conformance_value_gb
  else 0
 end as person_id
,case
  when stratum2 = 'payer_plan_period_start_date' then conformance_value_gb
  else 0
 end as payer_plan_period_start_date
,case
  when stratum2 = 'payer_plan_period_end_date' then conformance_value_gb
  else 0
 end as payer_plan_period_end_date
,case
  when stratum2 = 'payer_concept_id' then conformance_value_gb
  else 0
 end as payer_concept_id
,case
  when stratum2 = 'payer_source_value' then conformance_value_gb
  else 0
 end as payer_source_value
,case
  when stratum2 = 'payer_source_concept_id' then conformance_value_gb
  else 0
 end as payer_source_concept_id
,case
  when stratum2 = 'plan_concept_id' then conformance_value_gb
  else 0
 end as plan_concept_id
,case
  when stratum2 = 'plan_source_value' then conformance_value_gb
  else 0
 end as plan_source_value
,case
  when stratum2 = 'plan_source_concept_id' then conformance_value_gb
  else 0
 end as plan_source_concept_id
,case
  when stratum2 = 'sponsor_concept_id' then conformance_value_gb
  else 0
 end as sponsor_concept_id
,case
  when stratum2 = 'sponsor_source_value' then conformance_value_gb
  else 0
 end as sponsor_source_value
,case
  when stratum2 = 'sponsor_source_concept_id' then conformance_value_gb
  else 0
 end as sponsor_source_concept_id
,case
  when stratum2 = 'family_source_value' then conformance_value_gb
  else 0
 end as family_source_value
,case
  when stratum2 = 'stop_reason_concept_id' then conformance_value_gb
  else 0
 end as stop_reason_concept_id
,case
  when stratum2 = 'stop_reason_source_value' then conformance_value_gb
  else 0
 end as stop_reason_source_value
,case
  when stratum2 = 'stop_reason_source_concept_id' then conformance_value_gb
  else 0
 end as stop_reason_source_concept_id
 into #payer_plan_period_score_step2_cv
from #payer_plan_period_score_step1  as s1
left join #score_payer_plan_period_fn as p1
on s1.payer_plan_period_id = p1.uniq_no
-- 4
select
 s1.payer_plan_period_id as uniq_no
,case
  when stratum2 = 'payer_plan_period_id' then Uniqueness_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'person_id' then Uniqueness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'payer_plan_period_start_date' then Uniqueness_gb
  else 0
 end as payer_plan_period_start_date
,case
  when stratum2 = 'payer_plan_period_end_date' then Uniqueness_gb
  else 0
 end as payer_plan_period_end_date
,case
  when stratum2 = 'payer_concept_id' then Uniqueness_gb
  else 0
 end as payer_concept_id
,case
  when stratum2 = 'payer_source_value' then Uniqueness_gb
  else 0
 end as payer_source_value
,case
  when stratum2 = 'payer_source_concept_id' then Uniqueness_gb
  else 0
 end as payer_source_concept_id
,case
  when stratum2 = 'plan_concept_id' then Uniqueness_gb
  else 0
 end as plan_concept_id
,case
  when stratum2 = 'plan_source_value' then Uniqueness_gb
  else 0
 end as plan_source_value
,case
  when stratum2 = 'plan_source_concept_id' then Uniqueness_gb
  else 0
 end as plan_source_concept_id
,case
  when stratum2 = 'sponsor_concept_id' then Uniqueness_gb
  else 0
 end as sponsor_concept_id
,case
  when stratum2 = 'sponsor_source_value' then Uniqueness_gb
  else 0
 end as sponsor_source_value
,case
  when stratum2 = 'sponsor_source_concept_id' then Uniqueness_gb
  else 0
 end as sponsor_source_concept_id
,case
  when stratum2 = 'family_source_value' then Uniqueness_gb
  else 0
 end as family_source_value
,case
  when stratum2 = 'stop_reason_concept_id' then Uniqueness_gb
  else 0
 end as stop_reason_concept_id
,case
  when stratum2 = 'stop_reason_source_value' then Uniqueness_gb
  else 0
 end as stop_reason_source_value
,case
  when stratum2 = 'stop_reason_source_concept_id' then Uniqueness_gb
  else 0
 end as stop_reason_source_concept_id
 into #payer_plan_period_score_step2_u
from #payer_plan_period_score_step1  as s1
left join #score_payer_plan_period_fn as p1
on s1.payer_plan_period_id = p1.uniq_no
-- 5
select
 s1.payer_plan_period_id as uniq_no
,case
  when stratum2 = 'payer_plan_period_id' then plausibility_atemporal_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'person_id' then plausibility_atemporal_gb
  else 0
 end as person_id
,case
  when stratum2 = 'payer_plan_period_start_date' then plausibility_atemporal_gb
  else 0
 end as payer_plan_period_start_date
,case
  when stratum2 = 'payer_plan_period_end_date' then plausibility_atemporal_gb
  else 0
 end as payer_plan_period_end_date
,case
  when stratum2 = 'payer_concept_id' then plausibility_atemporal_gb
  else 0
 end as payer_concept_id
,case
  when stratum2 = 'payer_source_value' then plausibility_atemporal_gb
  else 0
 end as payer_source_value
,case
  when stratum2 = 'payer_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as payer_source_concept_id
,case
  when stratum2 = 'plan_concept_id' then plausibility_atemporal_gb
  else 0
 end as plan_concept_id
,case
  when stratum2 = 'plan_source_value' then plausibility_atemporal_gb
  else 0
 end as plan_source_value
,case
  when stratum2 = 'plan_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as plan_source_concept_id
,case
  when stratum2 = 'sponsor_concept_id' then plausibility_atemporal_gb
  else 0
 end as sponsor_concept_id
,case
  when stratum2 = 'sponsor_source_value' then plausibility_atemporal_gb
  else 0
 end as sponsor_source_value
,case
  when stratum2 = 'sponsor_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as sponsor_source_concept_id
,case
  when stratum2 = 'family_source_value' then plausibility_atemporal_gb
  else 0
 end as family_source_value
,case
  when stratum2 = 'stop_reason_concept_id' then plausibility_atemporal_gb
  else 0
 end as stop_reason_concept_id
,case
  when stratum2 = 'stop_reason_source_value' then plausibility_atemporal_gb
  else 0
 end as stop_reason_source_value
,case
  when stratum2 = 'stop_reason_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as stop_reason_source_concept_id
 into #payer_plan_period_score_step2_ap
from #payer_plan_period_score_step1  as s1
left join #score_payer_plan_period_fn as p1
on s1.payer_plan_period_id = p1.uniq_no
-- 6
select
 s1.payer_plan_period_id as uniq_no
,case
  when stratum2 = 'payer_plan_period_id' then Accuracy_gb
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'person_id' then Accuracy_gb
  else 0
 end as person_id
,case
  when stratum2 = 'payer_plan_period_start_date' then Accuracy_gb
  else 0
 end as payer_plan_period_start_date
,case
  when stratum2 = 'payer_plan_period_end_date' then Accuracy_gb
  else 0
 end as payer_plan_period_end_date
,case
  when stratum2 = 'payer_concept_id' then Accuracy_gb
  else 0
 end as payer_concept_id
,case
  when stratum2 = 'payer_source_value' then Accuracy_gb
  else 0
 end as payer_source_value
,case
  when stratum2 = 'payer_source_concept_id' then Accuracy_gb
  else 0
 end as payer_source_concept_id
,case
  when stratum2 = 'plan_concept_id' then Accuracy_gb
  else 0
 end as plan_concept_id
,case
  when stratum2 = 'plan_source_value' then Accuracy_gb
  else 0
 end as plan_source_value
,case
  when stratum2 = 'plan_source_concept_id' then Accuracy_gb
  else 0
 end as plan_source_concept_id
,case
  when stratum2 = 'sponsor_concept_id' then Accuracy_gb
  else 0
 end as sponsor_concept_id
,case
  when stratum2 = 'sponsor_source_value' then Accuracy_gb
  else 0
 end as sponsor_source_value
,case
  when stratum2 = 'sponsor_source_concept_id' then Accuracy_gb
  else 0
 end as sponsor_source_concept_id
,case
  when stratum2 = 'family_source_value' then Accuracy_gb
  else 0
 end as family_source_value
,case
  when stratum2 = 'stop_reason_concept_id' then Accuracy_gb
  else 0
 end as stop_reason_concept_id
,case
  when stratum2 = 'stop_reason_source_value' then Accuracy_gb
  else 0
 end as stop_reason_source_value
,case
  when stratum2 = 'stop_reason_source_concept_id' then Accuracy_gb
  else 0
 end as stop_reason_source_concept_id
 into #payer_plan_period_score_step2_ac
from #payer_plan_period_score_step1  as s1
left join #score_payer_plan_period_fn as p1
on s1.payer_plan_period_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 uniq_no
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(person_id) as person_id
,sum(payer_plan_period_start_date) as payer_plan_period_start_date
,sum(payer_plan_period_end_date) as payer_plan_period_end_date
,sum(payer_concept_id) as payer_concept_id
,sum(payer_source_value) as payer_source_value
,sum(payer_source_concept_id) as payer_source_concept_id
,sum(plan_concept_id) as plan_concept_id
,sum(plan_source_value) as plan_source_value
,sum(plan_source_concept_id) as plan_source_concept_id
,sum(sponsor_concept_id) as sponsor_concept_id
,sum(sponsor_source_value) as sponsor_source_value
,sum(sponsor_source_concept_id) as sponsor_source_concept_id
,sum(family_source_value) as family_source_value
,sum(stop_reason_concept_id) as stop_reason_concept_id
,sum(stop_reason_source_value) as stop_reason_source_value
,sum(stop_reason_source_concept_id) as stop_reason_source_concept_id
 into #payer_plan_period_score_step3_c
from #payer_plan_period_score_step2_c
group by uniq_no
-- 2
select
 uniq_no
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(person_id) as person_id
,sum(payer_plan_period_start_date) as payer_plan_period_start_date
,sum(payer_plan_period_end_date) as payer_plan_period_end_date
,sum(payer_concept_id) as payer_concept_id
,sum(payer_source_value) as payer_source_value
,sum(payer_source_concept_id) as payer_source_concept_id
,sum(plan_concept_id) as plan_concept_id
,sum(plan_source_value) as plan_source_value
,sum(plan_source_concept_id) as plan_source_concept_id
,sum(sponsor_concept_id) as sponsor_concept_id
,sum(sponsor_source_value) as sponsor_source_value
,sum(sponsor_source_concept_id) as sponsor_source_concept_id
,sum(family_source_value) as family_source_value
,sum(stop_reason_concept_id) as stop_reason_concept_id
,sum(stop_reason_source_value) as stop_reason_source_value
,sum(stop_reason_source_concept_id) as stop_reason_source_concept_id
 into #payer_plan_period_score_step3_cr
from #payer_plan_period_score_step2_cr
group by uniq_no
-- 3
select
 uniq_no
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(person_id) as person_id
,sum(payer_plan_period_start_date) as payer_plan_period_start_date
,sum(payer_plan_period_end_date) as payer_plan_period_end_date
,sum(payer_concept_id) as payer_concept_id
,sum(payer_source_value) as payer_source_value
,sum(payer_source_concept_id) as payer_source_concept_id
,sum(plan_concept_id) as plan_concept_id
,sum(plan_source_value) as plan_source_value
,sum(plan_source_concept_id) as plan_source_concept_id
,sum(sponsor_concept_id) as sponsor_concept_id
,sum(sponsor_source_value) as sponsor_source_value
,sum(sponsor_source_concept_id) as sponsor_source_concept_id
,sum(family_source_value) as family_source_value
,sum(stop_reason_concept_id) as stop_reason_concept_id
,sum(stop_reason_source_value) as stop_reason_source_value
,sum(stop_reason_source_concept_id) as stop_reason_source_concept_id
 into #payer_plan_period_score_step3_cv
from #payer_plan_period_score_step2_cv
group by uniq_no
-- 4
select
 uniq_no
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(person_id) as person_id
,sum(payer_plan_period_start_date) as payer_plan_period_start_date
,sum(payer_plan_period_end_date) as payer_plan_period_end_date
,sum(payer_concept_id) as payer_concept_id
,sum(payer_source_value) as payer_source_value
,sum(payer_source_concept_id) as payer_source_concept_id
,sum(plan_concept_id) as plan_concept_id
,sum(plan_source_value) as plan_source_value
,sum(plan_source_concept_id) as plan_source_concept_id
,sum(sponsor_concept_id) as sponsor_concept_id
,sum(sponsor_source_value) as sponsor_source_value
,sum(sponsor_source_concept_id) as sponsor_source_concept_id
,sum(family_source_value) as family_source_value
,sum(stop_reason_concept_id) as stop_reason_concept_id
,sum(stop_reason_source_value) as stop_reason_source_value
,sum(stop_reason_source_concept_id) as stop_reason_source_concept_id
 into #payer_plan_period_score_step3_u
from #payer_plan_period_score_step2_u
group by uniq_no
-- 5
select
 uniq_no
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(person_id) as person_id
,sum(payer_plan_period_start_date) as payer_plan_period_start_date
,sum(payer_plan_period_end_date) as payer_plan_period_end_date
,sum(payer_concept_id) as payer_concept_id
,sum(payer_source_value) as payer_source_value
,sum(payer_source_concept_id) as payer_source_concept_id
,sum(plan_concept_id) as plan_concept_id
,sum(plan_source_value) as plan_source_value
,sum(plan_source_concept_id) as plan_source_concept_id
,sum(sponsor_concept_id) as sponsor_concept_id
,sum(sponsor_source_value) as sponsor_source_value
,sum(sponsor_source_concept_id) as sponsor_source_concept_id
,sum(family_source_value) as family_source_value
,sum(stop_reason_concept_id) as stop_reason_concept_id
,sum(stop_reason_source_value) as stop_reason_source_value
,sum(stop_reason_source_concept_id) as stop_reason_source_concept_id
 into #payer_plan_period_score_step3_ap
from #payer_plan_period_score_step2_ap
group by uniq_no
-- 6
select
 uniq_no
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(person_id) as person_id
,sum(payer_plan_period_start_date) as payer_plan_period_start_date
,sum(payer_plan_period_end_date) as payer_plan_period_end_date
,sum(payer_concept_id) as payer_concept_id
,sum(payer_source_value) as payer_source_value
,sum(payer_source_concept_id) as payer_source_concept_id
,sum(plan_concept_id) as plan_concept_id
,sum(plan_source_value) as plan_source_value
,sum(plan_source_concept_id) as plan_source_concept_id
,sum(sponsor_concept_id) as sponsor_concept_id
,sum(sponsor_source_value) as sponsor_source_value
,sum(sponsor_source_concept_id) as sponsor_source_concept_id
,sum(family_source_value) as family_source_value
,sum(stop_reason_concept_id) as stop_reason_concept_id
,sum(stop_reason_source_value) as stop_reason_source_value
,sum(stop_reason_source_concept_id) as stop_reason_source_concept_id
 into #payer_plan_period_score_step3_ac
from #payer_plan_period_score_step2_ac
group by uniq_no
--------------------------------------------------------------------------
--> 7. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 'Completeness score: Payer_plan_period' as name
,cast(1.0-((
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.1)+
  ((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_start_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_end_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_payer_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_payer_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_plan_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_plan_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_plan_source_concept_id/max_uniq_no)*0.06)+
  ((s2.score_sponsor_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_sponsor_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_sponsor_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_family_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_stop_reason_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_source_concept_id/m1.max_uniq_no)*0.05))) as float)
from
(select
 sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(person_id) as score_person_id
,sum(payer_plan_period_start_date) as score_payer_plan_period_start_date
,sum(payer_plan_period_end_date) as score_payer_plan_period_end_date
,sum(payer_concept_id) as score_payer_concept_id
,sum(payer_source_value) as score_payer_source_value
,sum(payer_source_concept_id) as score_payer_source_concept_id
,sum(plan_concept_id) as score_plan_concept_id
,sum(plan_source_value) as score_plan_source_value
,sum(plan_source_concept_id) as score_plan_source_concept_id
,sum(sponsor_concept_id) as score_sponsor_concept_id
,sum(sponsor_source_value) as score_sponsor_source_value
,sum(sponsor_source_concept_id) as score_sponsor_source_concept_id
,sum(family_source_value) as score_family_source_value
,sum(stop_reason_concept_id) as score_stop_reason_concept_id
,sum(stop_reason_source_value) as score_stop_reason_source_value
,sum(stop_reason_source_concept_id) as score_stop_reason_source_concept_id
from #payer_plan_period_score_step3_c) as s2
cross join
(select count(payer_plan_period_id) as max_uniq_no from @cdmSchema.payer_plan_period) as m1
-- 2
select
 'Conformance-relation score: Payer_plan_period' as name
,cast(1.0-((
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.1)+
  ((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_start_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_end_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_payer_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_payer_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_plan_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_plan_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_plan_source_concept_id/max_uniq_no)*0.06)+
  ((s2.score_sponsor_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_sponsor_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_sponsor_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_family_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_stop_reason_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_source_concept_id/m1.max_uniq_no)*0.05))) as float)
from
(select
 sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(person_id) as score_person_id
,sum(payer_plan_period_start_date) as score_payer_plan_period_start_date
,sum(payer_plan_period_end_date) as score_payer_plan_period_end_date
,sum(payer_concept_id) as score_payer_concept_id
,sum(payer_source_value) as score_payer_source_value
,sum(payer_source_concept_id) as score_payer_source_concept_id
,sum(plan_concept_id) as score_plan_concept_id
,sum(plan_source_value) as score_plan_source_value
,sum(plan_source_concept_id) as score_plan_source_concept_id
,sum(sponsor_concept_id) as score_sponsor_concept_id
,sum(sponsor_source_value) as score_sponsor_source_value
,sum(sponsor_source_concept_id) as score_sponsor_source_concept_id
,sum(family_source_value) as score_family_source_value
,sum(stop_reason_concept_id) as score_stop_reason_concept_id
,sum(stop_reason_source_value) as score_stop_reason_source_value
,sum(stop_reason_source_concept_id) as score_stop_reason_source_concept_id
from #payer_plan_period_score_step3_cr) as s2
cross join
(select count(payer_plan_period_id) as max_uniq_no from @cdmSchema.payer_plan_period) as m1
-- 3
select
 'Conformace-value score: Payer_plan_period' as name
,cast(1.0-((
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.1)+
  ((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_start_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_end_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_payer_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_payer_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_plan_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_plan_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_plan_source_concept_id/max_uniq_no)*0.06)+
  ((s2.score_sponsor_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_sponsor_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_sponsor_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_family_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_stop_reason_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_source_concept_id/m1.max_uniq_no)*0.05))) as float)
from
(select
 sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(person_id) as score_person_id
,sum(payer_plan_period_start_date) as score_payer_plan_period_start_date
,sum(payer_plan_period_end_date) as score_payer_plan_period_end_date
,sum(payer_concept_id) as score_payer_concept_id
,sum(payer_source_value) as score_payer_source_value
,sum(payer_source_concept_id) as score_payer_source_concept_id
,sum(plan_concept_id) as score_plan_concept_id
,sum(plan_source_value) as score_plan_source_value
,sum(plan_source_concept_id) as score_plan_source_concept_id
,sum(sponsor_concept_id) as score_sponsor_concept_id
,sum(sponsor_source_value) as score_sponsor_source_value
,sum(sponsor_source_concept_id) as score_sponsor_source_concept_id
,sum(family_source_value) as score_family_source_value
,sum(stop_reason_concept_id) as score_stop_reason_concept_id
,sum(stop_reason_source_value) as score_stop_reason_source_value
,sum(stop_reason_source_concept_id) as score_stop_reason_source_concept_id
from #payer_plan_period_score_step3_cv) as s2
cross join
(select count(payer_plan_period_id) as max_uniq_no from @cdmSchema.payer_plan_period) as m1
--4
select
 'Uniqueness score: Payer_plan_period' as name
,cast(1.0-((
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.1)+
  ((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_start_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_end_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_payer_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_payer_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_plan_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_plan_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_plan_source_concept_id/max_uniq_no)*0.06)+
  ((s2.score_sponsor_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_sponsor_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_sponsor_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_family_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_stop_reason_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_source_concept_id/m1.max_uniq_no)*0.05))) as float)
from
(select
 sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(person_id) as score_person_id
,sum(payer_plan_period_start_date) as score_payer_plan_period_start_date
,sum(payer_plan_period_end_date) as score_payer_plan_period_end_date
,sum(payer_concept_id) as score_payer_concept_id
,sum(payer_source_value) as score_payer_source_value
,sum(payer_source_concept_id) as score_payer_source_concept_id
,sum(plan_concept_id) as score_plan_concept_id
,sum(plan_source_value) as score_plan_source_value
,sum(plan_source_concept_id) as score_plan_source_concept_id
,sum(sponsor_concept_id) as score_sponsor_concept_id
,sum(sponsor_source_value) as score_sponsor_source_value
,sum(sponsor_source_concept_id) as score_sponsor_source_concept_id
,sum(family_source_value) as score_family_source_value
,sum(stop_reason_concept_id) as score_stop_reason_concept_id
,sum(stop_reason_source_value) as score_stop_reason_source_value
,sum(stop_reason_source_concept_id) as score_stop_reason_source_concept_id
from #payer_plan_period_score_step3_u) as s2
cross join
(select count(payer_plan_period_id) as max_uniq_no from @cdmSchema.payer_plan_period) as m1
--5
select
 'Plausibility-Atemporal score: Payer_plan_period' as name
,cast(1.0-((
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.1)+
  ((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_start_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_end_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_payer_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_payer_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_plan_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_plan_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_plan_source_concept_id/max_uniq_no)*0.06)+
  ((s2.score_sponsor_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_sponsor_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_sponsor_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_family_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_stop_reason_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_source_concept_id/m1.max_uniq_no)*0.05))) as float)
from
(select
 sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(person_id) as score_person_id
,sum(payer_plan_period_start_date) as score_payer_plan_period_start_date
,sum(payer_plan_period_end_date) as score_payer_plan_period_end_date
,sum(payer_concept_id) as score_payer_concept_id
,sum(payer_source_value) as score_payer_source_value
,sum(payer_source_concept_id) as score_payer_source_concept_id
,sum(plan_concept_id) as score_plan_concept_id
,sum(plan_source_value) as score_plan_source_value
,sum(plan_source_concept_id) as score_plan_source_concept_id
,sum(sponsor_concept_id) as score_sponsor_concept_id
,sum(sponsor_source_value) as score_sponsor_source_value
,sum(sponsor_source_concept_id) as score_sponsor_source_concept_id
,sum(family_source_value) as score_family_source_value
,sum(stop_reason_concept_id) as score_stop_reason_concept_id
,sum(stop_reason_source_value) as score_stop_reason_source_value
,sum(stop_reason_source_concept_id) as score_stop_reason_source_concept_id
from #payer_plan_period_score_step3_ap) as s2
cross join
(select count(payer_plan_period_id) as max_uniq_no from @cdmSchema.payer_plan_period) as m1
-- 6
select
 'Accuracy score: Payer_plan_period' as name
,cast(1.0-((
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.1)+
  ((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_start_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_end_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_payer_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_payer_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_plan_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_plan_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_plan_source_concept_id/max_uniq_no)*0.06)+
  ((s2.score_sponsor_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_sponsor_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_sponsor_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_family_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_stop_reason_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_source_concept_id/m1.max_uniq_no)*0.05))) as float)
from
(select
 sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(person_id) as score_person_id
,sum(payer_plan_period_start_date) as score_payer_plan_period_start_date
,sum(payer_plan_period_end_date) as score_payer_plan_period_end_date
,sum(payer_concept_id) as score_payer_concept_id
,sum(payer_source_value) as score_payer_source_value
,sum(payer_source_concept_id) as score_payer_source_concept_id
,sum(plan_concept_id) as score_plan_concept_id
,sum(plan_source_value) as score_plan_source_value
,sum(plan_source_concept_id) as score_plan_source_concept_id
,sum(sponsor_concept_id) as score_sponsor_concept_id
,sum(sponsor_source_value) as score_sponsor_source_value
,sum(sponsor_source_concept_id) as score_sponsor_source_concept_id
,sum(family_source_value) as score_family_source_value
,sum(stop_reason_concept_id) as score_stop_reason_concept_id
,sum(stop_reason_source_value) as score_stop_reason_source_value
,sum(stop_reason_source_concept_id) as score_stop_reason_source_concept_id
from #payer_plan_period_score_step3_ac) as s2
cross join
(select count(payer_plan_period_id) as max_uniq_no from @cdmSchema.payer_plan_period) as m1
--------------------------------------------------------------------------
--> 8. Lable DQ concept
--------------------------------------------------------------------------
select
    *
into #score_payer_plan_period_fn_t
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
from #score_payer_plan_period_main) as m1
left join
(select
 stratum2
,err_no
 from #pp_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #pp_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #pp_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #pp_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #pp_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #pp_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 9.
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 s1.payer_plan_period_id as uniq_no
,case
  when stratum2 = 'payer_plan_period_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as payer_plan_period_id
,case
  when stratum2 = 'person_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as person_id
,case
  when stratum2 = 'payer_plan_period_start_date' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as payer_plan_period_start_date
,case
  when stratum2 = 'payer_plan_period_end_date' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as payer_plan_period_end_date
,case
  when stratum2 = 'payer_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as payer_concept_id
,case
  when stratum2 = 'payer_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as payer_source_value
,case
  when stratum2 = 'payer_source_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as payer_source_concept_id
,case
  when stratum2 = 'plan_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as plan_concept_id
,case
  when stratum2 = 'plan_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as plan_source_value
,case
  when stratum2 = 'plan_source_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as plan_source_concept_id
,case
  when stratum2 = 'sponsor_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as sponsor_concept_id
,case
  when stratum2 = 'sponsor_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as sponsor_source_value
,case
  when stratum2 = 'sponsor_source_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as sponsor_source_concept_id
,case
  when stratum2 = 'family_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as family_source_value
,case
  when stratum2 = 'stop_reason_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as stop_reason_concept_id
,case
  when stratum2 = 'stop_reason_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as stop_reason_source_value
,case
  when stratum2 = 'stop_reason_source_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as stop_reason_source_concept_id
 into #payer_plan_period_score_step2_t
from #payer_plan_period_score_step1  as s1
left join #score_payer_plan_period_fn_t as p1
on s1.payer_plan_period_id = p1.uniq_no
--------------------------------------------------------------------------
--> 10. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 uniq_no
,sum(payer_plan_period_id) as payer_plan_period_id
,sum(person_id) as person_id
,sum(payer_plan_period_start_date) as payer_plan_period_start_date
,sum(payer_plan_period_end_date) as payer_plan_period_end_date
,sum(payer_concept_id) as payer_concept_id
,sum(payer_source_value) as payer_source_value
,sum(payer_source_concept_id) as payer_source_concept_id
,sum(plan_concept_id) as plan_concept_id
,sum(plan_source_value) as plan_source_value
,sum(plan_source_concept_id) as plan_source_concept_id
,sum(sponsor_concept_id) as sponsor_concept_id
,sum(sponsor_source_value) as sponsor_source_value
,sum(sponsor_source_concept_id) as sponsor_source_concept_id
,sum(family_source_value) as family_source_value
,sum(stop_reason_concept_id) as stop_reason_concept_id
,sum(stop_reason_source_value) as stop_reason_source_value
,sum(stop_reason_source_concept_id) as stop_reason_source_concept_id
 into #payer_plan_period_score_step3_t
from #payer_plan_period_score_step2_t
group by uniq_no
--------------------------------------------------------------------------
--> 11. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 'payer_plan_period_score' as name
,cast(1.0-((
  ((s2.score_payer_plan_period_id/m1.max_uniq_no)*0.1)+
  ((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_start_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_plan_period_end_date/m1.max_uniq_no)*0.1)+
  ((s2.score_payer_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_payer_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_payer_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_plan_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_plan_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_plan_source_concept_id/max_uniq_no)*0.06)+
  ((s2.score_sponsor_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_sponsor_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_sponsor_source_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_family_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_stop_reason_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_stop_reason_source_concept_id/m1.max_uniq_no)*0.05))) as float)
from
(select
 sum(payer_plan_period_id) as score_payer_plan_period_id
,sum(person_id) as score_person_id
,sum(payer_plan_period_start_date) as score_payer_plan_period_start_date
,sum(payer_plan_period_end_date) as score_payer_plan_period_end_date
,sum(payer_concept_id) as score_payer_concept_id
,sum(payer_source_value) as score_payer_source_value
,sum(payer_source_concept_id) as score_payer_source_concept_id
,sum(plan_concept_id) as score_plan_concept_id
,sum(plan_source_value) as score_plan_source_value
,sum(plan_source_concept_id) as score_plan_source_concept_id
,sum(sponsor_concept_id) as score_sponsor_concept_id
,sum(sponsor_source_value) as score_sponsor_source_value
,sum(sponsor_source_concept_id) as score_sponsor_source_concept_id
,sum(family_source_value) as score_family_source_value
,sum(stop_reason_concept_id) as score_stop_reason_concept_id
,sum(stop_reason_source_value) as score_stop_reason_source_value
,sum(stop_reason_source_concept_id) as score_stop_reason_source_concept_id
from #payer_plan_period_score_step3_t) as s2
cross join
(select count(payer_plan_period_id) as max_uniq_no from @cdmSchema.payer_plan_period) as m1