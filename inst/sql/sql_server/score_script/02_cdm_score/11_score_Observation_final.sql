IF OBJECT_ID('tempdb..#score_observation_main','U') is not null drop table #score_observation_main 
IF OBJECT_ID('tempdb..#ob_Completeness_gb','U') is not null drop table #ob_Completeness_gb 
IF OBJECT_ID('tempdb..#ob_Conformance_value_gb','U') is not null drop table #ob_Conformance_value_gb 
IF OBJECT_ID('tempdb..#ob_Conformance_relation_gb','U') is not null drop table #ob_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#ob_Uniqueness_gb','U') is not null drop table #ob_Uniqueness_gb 
IF OBJECT_ID('tempdb..#ob_Plausibility_atemporal_gb','U') is not null drop table #ob_Plausibility_atemporal_gb 
IF OBJECT_ID('tempdb..#ob_Accuracy_gb','U') is not null drop table #ob_Accuracy_gb 
IF OBJECT_ID('tempdb..#score_observation_fn','U') is not null drop table #score_observation_fn 
IF OBJECT_ID('tempdb..#observation_score_step1','U') is not null drop table #observation_score_step1 
IF OBJECT_ID('tempdb..#observation_score_step2_c','U') is not null drop table #observation_score_step2_c 
IF OBJECT_ID('tempdb..#observation_score_step2_cr','U') is not null drop table #observation_score_step2_cr 
IF OBJECT_ID('tempdb..#observation_score_step2_cv','U') is not null drop table #observation_score_step2_cv 
IF OBJECT_ID('tempdb..#observation_score_step2_u','U') is not null drop table #observation_score_step2_u 
IF OBJECT_ID('tempdb..#observation_score_step2_ap','U') is not null drop table #observation_score_step2_ap 
IF OBJECT_ID('tempdb..#observation_score_step2_ac','U') is not null drop table #observation_score_step2_ac 
IF OBJECT_ID('tempdb..#observation_score_step3_c','U') is not null drop table #observation_score_step3_c 
IF OBJECT_ID('tempdb..#observation_score_step3_cr','U') is not null drop table #observation_score_step3_cr 
IF OBJECT_ID('tempdb..#observation_score_step3_cv','U') is not null drop table #observation_score_step3_cv 
IF OBJECT_ID('tempdb..#observation_score_step3_u','U') is not null drop table #observation_score_step3_u 
IF OBJECT_ID('tempdb..#observation_score_step3_ap','U') is not null drop table #observation_score_step3_ap 
IF OBJECT_ID('tempdb..#observation_score_step3_ac','U') is not null drop table #observation_score_step3_ac 
IF OBJECT_ID('tempdb..#score_observation_fn_t','U') is not null drop table #score_observation_fn_t 
IF OBJECT_ID('tempdb..#observation_score_step2_t','U') is not null drop table #observation_score_step2_t 
IF OBJECT_ID('tempdb..#observation_score_step3_t','U') is not null drop table #observation_score_step3_t 

--> 1. order by the table error uniq_number
--> DQ concept of uniq stratum2 null select
--------------------------------------------------------------------------
select
distinct
 tb_id
,stratum2
,err_no as uniq_no
into #score_observation_main
from @resultSchema.score_log_CDM
where tb_id = 28 ;
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
into #ob_Completeness_gb
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
where sm1.tb_id =28)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #ob_Conformance_value_gb
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
where sm1.tb_id =28)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #ob_Conformance_relation_gb
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
where sm1.tb_id =28)v
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
into #ob_Uniqueness_gb
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
where sm1.tb_id =28)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #ob_Plausibility_atemporal_gb
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
where sm1.tb_id =28)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #ob_Accuracy_gb
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
where sm1.tb_id =28)v
--------------------------------------------------------------------------
--> 3.
--------------------------------------------------------------------------
select
    *
into #score_observation_fn
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
from #score_observation_main) as m1
left join
(select
 stratum2
,err_no
 from #ob_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #ob_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #ob_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #ob_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #ob_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #ob_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 4.
--------------------------------------------------------------------------
select
observation_id
into #observation_score_step1
from  @cdmSchema.observation;
--------------------------------------------------------------------------
--> 5. 
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1.
select
 observation_id as uniq_no
,case
  when stratum2 = 'observation_id' then completeness_gb
  else 0
 end as observation_id
,case
  when stratum2 = 'person_id' then completeness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'observation_concept_id' then completeness_gb
  else 0
 end as observation_concept_id
,case
  when stratum2 = 'observation_date' then completeness_gb
  else 0
 end as observation_date
,case
  when stratum2 = 'observation_datetime' then completeness_gb
  else 0
 end as observation_datetime
,case
  when stratum2 = 'observation_type_concept_id' then completeness_gb
  else 0
 end as observation_type_concept_id
,case
  when stratum2 = 'value_as_number' then completeness_gb
  else 0
 end as value_as_number
,case
  when stratum2 = 'value_as_string' then completeness_gb
  else 0
 end as value_as_string
,case
  when stratum2 = 'value_as_concept_id' then completeness_gb
  else 0
 end as value_as_concept_id
,case
  when stratum2 = 'qualifier_concept_id' then completeness_gb
  else 0
 end as qualifier_concept_id
,case
  when stratum2 = 'unit_concept_id' then completeness_gb
  else 0
 end as unit_concept_id
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
  when stratum2 = 'observation_source_value' then completeness_gb
  else 0
 end as observation_source_value
,case
  when stratum2 = 'observation_source_concept_id' then completeness_gb
  else 0
 end as observation_source_concept_id
,case
  when stratum2 = 'unit_source_value' then completeness_gb
  else 0
 end as unit_source_value
,case
  when stratum2 = 'qualifier_source_value' then completeness_gb
  else 0
 end as qualifier_source_value
 into #observation_score_step2_c
from #observation_score_step1  as s1
left outer join #score_observation_fn as p1
on s1.observation_id = p1.uniq_no
-- 2.
select
 observation_id as uniq_no
,case
  when stratum2 = 'observation_id' then conformance_relation_gb
  else 0
 end as observation_id
,case
  when stratum2 = 'person_id' then conformance_relation_gb
  else 0
 end as person_id
,case
  when stratum2 = 'observation_concept_id' then conformance_relation_gb
  else 0
 end as observation_concept_id
,case
  when stratum2 = 'observation_date' then conformance_relation_gb
  else 0
 end as observation_date
,case
  when stratum2 = 'observation_datetime' then conformance_relation_gb
  else 0
 end as observation_datetime
,case
  when stratum2 = 'observation_type_concept_id' then conformance_relation_gb
  else 0
 end as observation_type_concept_id
,case
  when stratum2 = 'value_as_number' then conformance_relation_gb
  else 0
 end as value_as_number
,case
  when stratum2 = 'value_as_string' then conformance_relation_gb
  else 0
 end as value_as_string
,case
  when stratum2 = 'value_as_concept_id' then conformance_relation_gb
  else 0
 end as value_as_concept_id
,case
  when stratum2 = 'qualifier_concept_id' then conformance_relation_gb
  else 0
 end as qualifier_concept_id
,case
  when stratum2 = 'unit_concept_id' then conformance_relation_gb
  else 0
 end as unit_concept_id
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
  when stratum2 = 'observation_source_value' then conformance_relation_gb
  else 0
 end as observation_source_value
,case
  when stratum2 = 'observation_source_concept_id' then conformance_relation_gb
  else 0
 end as observation_source_concept_id
,case
  when stratum2 = 'unit_source_value' then conformance_relation_gb
  else 0
 end as unit_source_value
,case
  when stratum2 = 'qualifier_source_value' then conformance_relation_gb
  else 0
 end as qualifier_source_value
 into #observation_score_step2_cr
from #observation_score_step1  as s1
left outer join #score_observation_fn as p1
on s1.observation_id = p1.uniq_no
-- 3.
select
 observation_id as uniq_no
,case
  when stratum2 = 'observation_id' then conformance_value_gb
  else 0
 end as observation_id
,case
  when stratum2 = 'person_id' then conformance_value_gb
  else 0
 end as person_id
,case
  when stratum2 = 'observation_concept_id' then conformance_value_gb
  else 0
 end as observation_concept_id
,case
  when stratum2 = 'observation_date' then conformance_value_gb
  else 0
 end as observation_date
,case
  when stratum2 = 'observation_datetime' then conformance_value_gb
  else 0
 end as observation_datetime
,case
  when stratum2 = 'observation_type_concept_id' then conformance_value_gb
  else 0
 end as observation_type_concept_id
,case
  when stratum2 = 'value_as_number' then conformance_value_gb
  else 0
 end as value_as_number
,case
  when stratum2 = 'value_as_string' then conformance_value_gb
  else 0
 end as value_as_string
,case
  when stratum2 = 'value_as_concept_id' then conformance_value_gb
  else 0
 end as value_as_concept_id
,case
  when stratum2 = 'qualifier_concept_id' then conformance_value_gb
  else 0
 end as qualifier_concept_id
,case
  when stratum2 = 'unit_concept_id' then conformance_value_gb
  else 0
 end as unit_concept_id
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
  when stratum2 = 'observation_source_value' then conformance_value_gb
  else 0
 end as observation_source_value
,case
  when stratum2 = 'observation_source_concept_id' then conformance_value_gb
  else 0
 end as observation_source_concept_id
,case
  when stratum2 = 'unit_source_value' then conformance_value_gb
  else 0
 end as unit_source_value
,case
  when stratum2 = 'qualifier_source_value' then conformance_value_gb
  else 0
 end as qualifier_source_value
 into #observation_score_step2_cv
from #observation_score_step1  as s1
left outer join #score_observation_fn as p1
on s1.observation_id = p1.uniq_no
--4
select
 observation_id as uniq_no
,case
  when stratum2 = 'observation_id' then Uniqueness_gb
  else 0
 end as observation_id
,case
  when stratum2 = 'person_id' then Uniqueness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'observation_concept_id' then Uniqueness_gb
  else 0
 end as observation_concept_id
,case
  when stratum2 = 'observation_date' then Uniqueness_gb
  else 0
 end as observation_date
,case
  when stratum2 = 'observation_datetime' then Uniqueness_gb
  else 0
 end as observation_datetime
,case
  when stratum2 = 'observation_type_concept_id' then Uniqueness_gb
  else 0
 end as observation_type_concept_id
,case
  when stratum2 = 'value_as_number' then Uniqueness_gb
  else 0
 end as value_as_number
,case
  when stratum2 = 'value_as_string' then Uniqueness_gb
  else 0
 end as value_as_string
,case
  when stratum2 = 'value_as_concept_id' then Uniqueness_gb
  else 0
 end as value_as_concept_id
,case
  when stratum2 = 'qualifier_concept_id' then Uniqueness_gb
  else 0
 end as qualifier_concept_id
,case
  when stratum2 = 'unit_concept_id' then Uniqueness_gb
  else 0
 end as unit_concept_id
,case
  when stratum2 = 'provider_id' then Uniqueness_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'visit_occurrence_id' then Uniqueness_gb
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then Uniqueness_gb
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'observation_source_value' then Uniqueness_gb
  else 0
 end as observation_source_value
,case
  when stratum2 = 'observation_source_concept_id' then Uniqueness_gb
  else 0
 end as observation_source_concept_id
,case
  when stratum2 = 'unit_source_value' then Uniqueness_gb
  else 0
 end as unit_source_value
,case
  when stratum2 = 'qualifier_source_value' then Uniqueness_gb
  else 0
 end as qualifier_source_value
 into #observation_score_step2_u
from #observation_score_step1  as s1
left outer join #score_observation_fn as p1
on s1.observation_id = p1.uniq_no
--5
select
 observation_id as uniq_no
,case
  when stratum2 = 'observation_id' then plausibility_atemporal_gb
  else 0
 end as observation_id
,case
  when stratum2 = 'person_id' then plausibility_atemporal_gb
  else 0
 end as person_id
,case
  when stratum2 = 'observation_concept_id' then plausibility_atemporal_gb
  else 0
 end as observation_concept_id
,case
  when stratum2 = 'observation_date' then plausibility_atemporal_gb
  else 0
 end as observation_date
,case
  when stratum2 = 'observation_datetime' then plausibility_atemporal_gb
  else 0
 end as observation_datetime
,case
  when stratum2 = 'observation_type_concept_id' then plausibility_atemporal_gb
  else 0
 end as observation_type_concept_id
,case
  when stratum2 = 'value_as_number' then plausibility_atemporal_gb
  else 0
 end as value_as_number
,case
  when stratum2 = 'value_as_string' then plausibility_atemporal_gb
  else 0
 end as value_as_string
,case
  when stratum2 = 'value_as_concept_id' then plausibility_atemporal_gb
  else 0
 end as value_as_concept_id
,case
  when stratum2 = 'qualifier_concept_id' then plausibility_atemporal_gb
  else 0
 end as qualifier_concept_id
,case
  when stratum2 = 'unit_concept_id' then plausibility_atemporal_gb
  else 0
 end as unit_concept_id
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
  when stratum2 = 'observation_source_value' then plausibility_atemporal_gb
  else 0
 end as observation_source_value
,case
  when stratum2 = 'observation_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as observation_source_concept_id
,case
  when stratum2 = 'unit_source_value' then plausibility_atemporal_gb
  else 0
 end as unit_source_value
,case
  when stratum2 = 'qualifier_source_value' then plausibility_atemporal_gb
  else 0
 end as qualifier_source_value
 into #observation_score_step2_ap
from #observation_score_step1  as s1
left outer join #score_observation_fn as p1
on s1.observation_id = p1.uniq_no
--6
select
 observation_id as uniq_no
,case
  when stratum2 = 'observation_id' then Accuracy_gb
  else 0
 end as observation_id
,case
  when stratum2 = 'person_id' then Accuracy_gb
  else 0
 end as person_id
,case
  when stratum2 = 'observation_concept_id' then Accuracy_gb
  else 0
 end as observation_concept_id
,case
  when stratum2 = 'observation_date' then Accuracy_gb
  else 0
 end as observation_date
,case
  when stratum2 = 'observation_datetime' then Accuracy_gb
  else 0
 end as observation_datetime
,case
  when stratum2 = 'observation_type_concept_id' then Accuracy_gb
  else 0
 end as observation_type_concept_id
,case
  when stratum2 = 'value_as_number' then Accuracy_gb
  else 0
 end as value_as_number
,case
  when stratum2 = 'value_as_string' then Accuracy_gb
  else 0
 end as value_as_string
,case
  when stratum2 = 'value_as_concept_id' then Accuracy_gb
  else 0
 end as value_as_concept_id
,case
  when stratum2 = 'qualifier_concept_id' then Accuracy_gb
  else 0
 end as qualifier_concept_id
,case
  when stratum2 = 'unit_concept_id' then Accuracy_gb
  else 0
 end as unit_concept_id
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
  when stratum2 = 'observation_source_value' then Accuracy_gb
  else 0
 end as observation_source_value
,case
  when stratum2 = 'observation_source_concept_id' then Accuracy_gb
  else 0
 end as observation_source_concept_id
,case
  when stratum2 = 'unit_source_value' then Accuracy_gb
  else 0
 end as unit_source_value
,case
  when stratum2 = 'qualifier_source_value' then Accuracy_gb
  else 0
 end as qualifier_source_value
 into #observation_score_step2_ac
from #observation_score_step1  as s1
left outer join #score_observation_fn as p1
on s1.observation_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 uniq_no
,sum(observation_id) as observation_id
,sum(person_id) as person_id
,sum(observation_concept_id) as observation_concept_id
,sum(observation_date) as observation_date
,sum(observation_datetime) as observation_datetime
,sum(observation_type_concept_id) as observation_type_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_string) as value_as_string
,sum(value_as_concept_id) as value_as_concept_id
,sum(qualifier_concept_id) as qualifier_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(observation_source_value) as observation_source_value
,sum(observation_source_concept_id) as observation_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(qualifier_source_value) as qualifier_source_value
 into #observation_score_step3_c
from #observation_score_step2_c
group by uniq_no
--2
select
 uniq_no
,sum(observation_id) as observation_id
,sum(person_id) as person_id
,sum(observation_concept_id) as observation_concept_id
,sum(observation_date) as observation_date
,sum(observation_datetime) as observation_datetime
,sum(observation_type_concept_id) as observation_type_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_string) as value_as_string
,sum(value_as_concept_id) as value_as_concept_id
,sum(qualifier_concept_id) as qualifier_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(observation_source_value) as observation_source_value
,sum(observation_source_concept_id) as observation_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(qualifier_source_value) as qualifier_source_value
 into #observation_score_step3_cr
from #observation_score_step2_cr
group by uniq_no
--3
select
 uniq_no
,sum(observation_id) as observation_id
,sum(person_id) as person_id
,sum(observation_concept_id) as observation_concept_id
,sum(observation_date) as observation_date
,sum(observation_datetime) as observation_datetime
,sum(observation_type_concept_id) as observation_type_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_string) as value_as_string
,sum(value_as_concept_id) as value_as_concept_id
,sum(qualifier_concept_id) as qualifier_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(observation_source_value) as observation_source_value
,sum(observation_source_concept_id) as observation_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(qualifier_source_value) as qualifier_source_value
 into #observation_score_step3_cv
from #observation_score_step2_cv
group by uniq_no
--4
select
 uniq_no
,sum(observation_id) as observation_id
,sum(person_id) as person_id
,sum(observation_concept_id) as observation_concept_id
,sum(observation_date) as observation_date
,sum(observation_datetime) as observation_datetime
,sum(observation_type_concept_id) as observation_type_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_string) as value_as_string
,sum(value_as_concept_id) as value_as_concept_id
,sum(qualifier_concept_id) as qualifier_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(observation_source_value) as observation_source_value
,sum(observation_source_concept_id) as observation_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(qualifier_source_value) as qualifier_source_value
 into #observation_score_step3_u
from #observation_score_step2_u
group by uniq_no
--5
select
 uniq_no
,sum(observation_id) as observation_id
,sum(person_id) as person_id
,sum(observation_concept_id) as observation_concept_id
,sum(observation_date) as observation_date
,sum(observation_datetime) as observation_datetime
,sum(observation_type_concept_id) as observation_type_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_string) as value_as_string
,sum(value_as_concept_id) as value_as_concept_id
,sum(qualifier_concept_id) as qualifier_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(observation_source_value) as observation_source_value
,sum(observation_source_concept_id) as observation_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(qualifier_source_value) as qualifier_source_value
 into #observation_score_step3_ap
from #observation_score_step2_ap
group by uniq_no
--6
select
 uniq_no
,sum(observation_id) as observation_id
,sum(person_id) as person_id
,sum(observation_concept_id) as observation_concept_id
,sum(observation_date) as observation_date
,sum(observation_datetime) as observation_datetime
,sum(observation_type_concept_id) as observation_type_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_string) as value_as_string
,sum(value_as_concept_id) as value_as_concept_id
,sum(qualifier_concept_id) as qualifier_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(observation_source_value) as observation_source_value
,sum(observation_source_concept_id) as observation_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(qualifier_source_value) as qualifier_source_value
 into #observation_score_step3_ac
from #observation_score_step2_ac
group by uniq_no
--------------------------------------------------------------------------
--> 7. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1 :: 18
select
 'Completeness score: Observation' as name
,cast(1.0-((
  ((s2.score_observation_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_date/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_datetime/m1.max_uniq_no)*0.06)+
  ((s2.score_observation_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.06)+
  ((s2.score_value_as_string/m1.max_uniq_no)*0.06)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_qualifier_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.05)+
  ((s2.score_observation_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_observation_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_qualifier_source_value/m1.max_uniq_no)*0.01))) as float)
from
(select
 sum(observation_id) as score_observation_id
,sum(person_id) as score_person_id
,sum(observation_concept_id) as score_observation_concept_id
,sum(observation_date) as score_observation_date
,sum(observation_datetime) as score_observation_datetime
,sum(observation_type_concept_id) as score_observation_type_concept_id
,sum(value_as_number) as score_value_as_number
,sum(value_as_string) as score_value_as_string
,sum(value_as_concept_id) as score_value_as_concept_id
,sum(qualifier_concept_id) as score_qualifier_concept_id
,sum(unit_concept_id) as score_unit_concept_id
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(observation_source_value) as score_observation_source_value
,sum(observation_source_concept_id) as score_observation_source_concept_id
,sum(unit_source_value) as score_unit_source_value
,sum(qualifier_source_value) as score_qualifier_source_value
from #observation_score_step3_c) as s2
cross join
(select count(observation_id) as max_uniq_no from @cdmSchema.observation) as m1
-- 2
select
 'Conformance-relation score: Observation' as name
,cast(1.0-((
  ((s2.score_observation_id/m1.max_uniq_no)*0.08)+
  ((s2.score_person_id/m1.max_uniq_no)*0.08)+
  ((s2.score_observation_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_observation_date/m1.max_uniq_no)*0.01714285716)+
  ((s2.score_observation_datetime/m1.max_uniq_no)*0.01714285714)+
  ((s2.score_observation_type_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.01714285714)+
  ((s2.score_value_as_string/m1.max_uniq_no)*0.01714285714)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_qualifier_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.08)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.08)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.08)+
  ((s2.score_observation_source_value/m1.max_uniq_no)*0.01714285714)+
  ((s2.score_observation_source_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.01714285714)+
  ((s2.score_qualifier_source_value/m1.max_uniq_no)*0.01714285714))) as float)
from
(select
 sum(observation_id) as score_observation_id
,sum(person_id) as score_person_id
,sum(observation_concept_id) as score_observation_concept_id
,sum(observation_date) as score_observation_date
,sum(observation_datetime) as score_observation_datetime
,sum(observation_type_concept_id) as score_observation_type_concept_id
,sum(value_as_number) as score_value_as_number
,sum(value_as_string) as score_value_as_string
,sum(value_as_concept_id) as score_value_as_concept_id
,sum(qualifier_concept_id) as score_qualifier_concept_id
,sum(unit_concept_id) as score_unit_concept_id
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(observation_source_value) as score_observation_source_value
,sum(observation_source_concept_id) as score_observation_source_concept_id
,sum(unit_source_value) as score_unit_source_value
,sum(qualifier_source_value) as score_qualifier_source_value
from #observation_score_step3_cr) as s2
cross join
(select count(observation_id) as max_uniq_no from @cdmSchema.observation) as m1
-- 3
select
 'Conformance-value score: Observation' as name
,cast(1.0-((
  ((s2.score_observation_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_date/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_datetime/m1.max_uniq_no)*0.06)+
  ((s2.score_observation_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.06)+
  ((s2.score_value_as_string/m1.max_uniq_no)*0.06)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_qualifier_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.05)+
  ((s2.score_observation_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_observation_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_qualifier_source_value/m1.max_uniq_no)*0.01))) as float)
from
(select
 sum(observation_id) as score_observation_id
,sum(person_id) as score_person_id
,sum(observation_concept_id) as score_observation_concept_id
,sum(observation_date) as score_observation_date
,sum(observation_datetime) as score_observation_datetime
,sum(observation_type_concept_id) as score_observation_type_concept_id
,sum(value_as_number) as score_value_as_number
,sum(value_as_string) as score_value_as_string
,sum(value_as_concept_id) as score_value_as_concept_id
,sum(qualifier_concept_id) as score_qualifier_concept_id
,sum(unit_concept_id) as score_unit_concept_id
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(observation_source_value) as score_observation_source_value
,sum(observation_source_concept_id) as score_observation_source_concept_id
,sum(unit_source_value) as score_unit_source_value
,sum(qualifier_source_value) as score_qualifier_source_value
from #observation_score_step3_cv) as s2
cross join
(select count(observation_id) as max_uniq_no from @cdmSchema.observation) as m1
--4
select
 'Uniqueness score: Observation' as name
,cast(1.0-((
  ((s2.score_observation_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_date/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_datetime/m1.max_uniq_no)*0.06)+
  ((s2.score_observation_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.06)+
  ((s2.score_value_as_string/m1.max_uniq_no)*0.06)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_qualifier_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.05)+
  ((s2.score_observation_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_observation_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_qualifier_source_value/m1.max_uniq_no)*0.01))) as float)
from
(select
 sum(observation_id) as score_observation_id
,sum(person_id) as score_person_id
,sum(observation_concept_id) as score_observation_concept_id
,sum(observation_date) as score_observation_date
,sum(observation_datetime) as score_observation_datetime
,sum(observation_type_concept_id) as score_observation_type_concept_id
,sum(value_as_number) as score_value_as_number
,sum(value_as_string) as score_value_as_string
,sum(value_as_concept_id) as score_value_as_concept_id
,sum(qualifier_concept_id) as score_qualifier_concept_id
,sum(unit_concept_id) as score_unit_concept_id
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(observation_source_value) as score_observation_source_value
,sum(observation_source_concept_id) as score_observation_source_concept_id
,sum(unit_source_value) as score_unit_source_value
,sum(qualifier_source_value) as score_qualifier_source_value
from #observation_score_step3_u) as s2
cross join
(select count(observation_id) as max_uniq_no from @cdmSchema.observation) as m1
--5
select
 'Plausibility-Atemporal score: Observation' as name
,cast(1.0-((
  ((s2.score_observation_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_date/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_observation_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.05)+
  ((s2.score_value_as_string/m1.max_uniq_no)*0.05)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_qualifier_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.05)+
  ((s2.score_observation_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_observation_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_qualifier_source_value/m1.max_uniq_no)*0.01))) as float)
from
(select
 sum(observation_id) as score_observation_id
,sum(person_id) as score_person_id
,sum(observation_concept_id) as score_observation_concept_id
,sum(observation_date) as score_observation_date
,sum(observation_datetime) as score_observation_datetime
,sum(observation_type_concept_id) as score_observation_type_concept_id
,sum(value_as_number) as score_value_as_number
,sum(value_as_string) as score_value_as_string
,sum(value_as_concept_id) as score_value_as_concept_id
,sum(qualifier_concept_id) as score_qualifier_concept_id
,sum(unit_concept_id) as score_unit_concept_id
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(observation_source_value) as score_observation_source_value
,sum(observation_source_concept_id) as score_observation_source_concept_id
,sum(unit_source_value) as score_unit_source_value
,sum(qualifier_source_value) as score_qualifier_source_value
from #observation_score_step3_ap) as s2
cross join
(select count(observation_id) as max_uniq_no from @cdmSchema.observation) as m1
--6
select
 'Accuracy score: Observation' as name
,cast(1.0-((
  ((s2.score_observation_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_date/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_datetime/m1.max_uniq_no)*0.08)+
  ((s2.score_observation_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.05)+
  ((s2.score_value_as_string/m1.max_uniq_no)*0.05)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_qualifier_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.01)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.01)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.01)+
  ((s2.score_observation_source_value/m1.max_uniq_no)*0.05)+
  ((s2.score_observation_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.05)+
  ((s2.score_qualifier_source_value/m1.max_uniq_no)*0.05))) as float)
from
(select
 sum(observation_id) as score_observation_id
,sum(person_id) as score_person_id
,sum(observation_concept_id) as score_observation_concept_id
,sum(observation_date) as score_observation_date
,sum(observation_datetime) as score_observation_datetime
,sum(observation_type_concept_id) as score_observation_type_concept_id
,sum(value_as_number) as score_value_as_number
,sum(value_as_string) as score_value_as_string
,sum(value_as_concept_id) as score_value_as_concept_id
,sum(qualifier_concept_id) as score_qualifier_concept_id
,sum(unit_concept_id) as score_unit_concept_id
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(observation_source_value) as score_observation_source_value
,sum(observation_source_concept_id) as score_observation_source_concept_id
,sum(unit_source_value) as score_unit_source_value
,sum(qualifier_source_value) as score_qualifier_source_value
from #observation_score_step3_ac) as s2
cross join
(select count(observation_id) as max_uniq_no from @cdmSchema.observation) as m1
--------------------------------------------------------------------------
--> 8
--------------------------------------------------------------------------
select
    *
into #score_observation_fn_t
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
from #score_observation_main) as m1
left join
(select
 stratum2
,err_no
 from #ob_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #ob_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #ob_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #ob_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #ob_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #ob_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 9. 
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 observation_id as uniq_no
,case
  when stratum2 = 'observation_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as observation_id
,case
  when stratum2 = 'person_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as person_id
,case
  when stratum2 = 'observation_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as observation_concept_id
,case
  when stratum2 = 'observation_date' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as observation_date
,case
  when stratum2 = 'observation_datetime' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as observation_datetime
,case
  when stratum2 = 'observation_type_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as observation_type_concept_id
,case
  when stratum2 = 'value_as_number' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as value_as_number
,case
  when stratum2 = 'value_as_string' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as value_as_string
,case
  when stratum2 = 'value_as_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as value_as_concept_id
,case
  when stratum2 = 'qualifier_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as qualifier_concept_id
,case
  when stratum2 = 'unit_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as unit_concept_id
,case
  when stratum2 = 'provider_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as provider_id
,case
  when stratum2 = 'visit_occurrence_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_occurrence_id
,case
  when stratum2 = 'visit_detail_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'observation_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as observation_source_value
,case
  when stratum2 = 'observation_source_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as observation_source_concept_id
,case
  when stratum2 = 'unit_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as unit_source_value
,case
  when stratum2 = 'qualifier_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as qualifier_source_value
 into #observation_score_step2_t
from #observation_score_step1  as s1
left outer join #score_observation_fn_t as p1
on s1.observation_id = p1.uniq_no
--------------------------------------------------------------------------
--> 10. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 uniq_no
,sum(observation_id) as observation_id
,sum(person_id) as person_id
,sum(observation_concept_id) as observation_concept_id
,sum(observation_date) as observation_date
,sum(observation_datetime) as observation_datetime
,sum(observation_type_concept_id) as observation_type_concept_id
,sum(value_as_number) as value_as_number
,sum(value_as_string) as value_as_string
,sum(value_as_concept_id) as value_as_concept_id
,sum(qualifier_concept_id) as qualifier_concept_id
,sum(unit_concept_id) as unit_concept_id
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(observation_source_value) as observation_source_value
,sum(observation_source_concept_id) as observation_source_concept_id
,sum(unit_source_value) as unit_source_value
,sum(qualifier_source_value) as qualifier_source_value
 into #observation_score_step3_t
from #observation_score_step2_t
group by uniq_no
--------------------------------------------------------------------------
--> 11. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 'Table score: Observation' as name
,cast(1.0-((
  ((s2.score_observation_id/m1.max_uniq_no)*0.09)+
  ((s2.score_person_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_date/m1.max_uniq_no)*0.09)+
  ((s2.score_observation_datetime/m1.max_uniq_no)*0.06)+
  ((s2.score_observation_type_concept_id/m1.max_uniq_no)*0.09)+
  ((s2.score_value_as_number/m1.max_uniq_no)*0.06)+
  ((s2.score_value_as_string/m1.max_uniq_no)*0.06)+
  ((s2.score_value_as_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_qualifier_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_unit_concept_id/m1.max_uniq_no)*0.06)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_occurrence_id/m1.max_uniq_no)*0.05)+
  ((s2.score_visit_detail_id/m1.max_uniq_no)*0.05)+
  ((s2.score_observation_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_observation_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.score_unit_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_qualifier_source_value/m1.max_uniq_no)*0.01))) as float)
from
(select
 sum(observation_id) as score_observation_id
,sum(person_id) as score_person_id
,sum(observation_concept_id) as score_observation_concept_id
,sum(observation_date) as score_observation_date
,sum(observation_datetime) as score_observation_datetime
,sum(observation_type_concept_id) as score_observation_type_concept_id
,sum(value_as_number) as score_value_as_number
,sum(value_as_string) as score_value_as_string
,sum(value_as_concept_id) as score_value_as_concept_id
,sum(qualifier_concept_id) as score_qualifier_concept_id
,sum(unit_concept_id) as score_unit_concept_id
,sum(provider_id) as score_provider_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
,sum(visit_detail_id) as score_visit_detail_id
,sum(observation_source_value) as score_observation_source_value
,sum(observation_source_concept_id) as score_observation_source_concept_id
,sum(unit_source_value) as score_unit_source_value
,sum(qualifier_source_value) as score_qualifier_source_value
from #observation_score_step3_t) as s2
cross join
(select count(observation_id) as max_uniq_no from @cdmSchema.observation) as m1