IF OBJECT_ID('tempdb..#score_condition_era_main','U') is not null drop table #score_condition_era_main 
IF OBJECT_ID('tempdb..#cera_Completeness_gb','U') is not null drop table #cera_Completeness_gb 
IF OBJECT_ID('tempdb..#cera_Conformance_value_gb','U') is not null drop table #cera_Conformance_value_gb 
IF OBJECT_ID('tempdb..#cera_Conformance_relation_gb','U') is not null drop table #cera_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#cera_Uniqueness_gb','U') is not null drop table #cera_Uniqueness_gb 
IF OBJECT_ID('tempdb..#cera_Accuracy_gb','U') is not null drop table #cera_Accuracy_gb 
IF OBJECT_ID('tempdb..#score_condition_era_fn','U') is not null drop table #score_condition_era_fn 
IF OBJECT_ID('tempdb..#condition_era_score_step1','U') is not null drop table #condition_era_score_step1 
IF OBJECT_ID('tempdb..#condition_era_score_step2_c','U') is not null drop table #condition_era_score_step2_c 
IF OBJECT_ID('tempdb..#condition_era_score_step2_cr','U') is not null drop table #condition_era_score_step2_cr 
IF OBJECT_ID('tempdb..#condition_era_score_step2_cv','U') is not null drop table #condition_era_score_step2_cv 
IF OBJECT_ID('tempdb..#condition_era_score_step2_u','U') is not null drop table #condition_era_score_step2_u 
IF OBJECT_ID('tempdb..#condition_era_score_step2_ap','U') is not null drop table #condition_era_score_step2_ap 
IF OBJECT_ID('tempdb..#condition_era_score_step2_ac','U') is not null drop table #condition_era_score_step2_ac 
IF OBJECT_ID('tempdb..#condition_era_score_step3_c','U') is not null drop table #condition_era_score_step3_c 
IF OBJECT_ID('tempdb..#condition_era_score_step3_cr','U') is not null drop table #condition_era_score_step3_cr 
IF OBJECT_ID('tempdb..#condition_era_score_step3_cv','U') is not null drop table #condition_era_score_step3_cv 
IF OBJECT_ID('tempdb..#condition_era_score_step3_u','U') is not null drop table #condition_era_score_step3_u 
IF OBJECT_ID('tempdb..#condition_era_score_step3_ap','U') is not null drop table #condition_era_score_step3_ap 
IF OBJECT_ID('tempdb..#condition_era_score_step3_ac','U') is not null drop table #condition_era_score_step3_ac 
IF OBJECT_ID('tempdb..#score_condition_era_fn_t','U') is not null drop table #score_condition_era_fn_t 
IF OBJECT_ID('tempdb..#condition_era_score_step2_t','U') is not null drop table #condition_era_score_step2_t 
IF OBJECT_ID('tempdb..#condition_era_score_step3_t','U') is not null drop table #condition_era_score_step3_t 

--> 1. order by the table error uniq_number
--> DQ concept of uniq  stratum2 null select
--------------------------------------------------------------------------
select
distinct
 tb_id
,stratum2
,err_no as uniq_no
into #score_condition_era_main
from @resultSchema.score_log_CDM
where tb_id = 12;
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
into #cera_Completeness_gb
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
where sm1.tb_id =12)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #cera_Conformance_value_gb
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
where sm1.tb_id =12)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #cera_Conformance_relation_gb
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
where sm1.tb_id =12)v
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
into #cera_Uniqueness_gb
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
where sm1.tb_id =12)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #cera_Plausibility_atemporal_gb
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
where sm1.tb_id =12)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #cera_Accuracy_gb
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
where sm1.tb_id =12)v
--------------------------------------------------------------------------
--> 3.
--------------------------------------------------------------------------
select
    *
into #score_condition_era_fn
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
from #score_condition_era_main) as m1
left join
(select
 stratum2
,err_no
 from #cera_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #cera_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #cera_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #cera_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #cera_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #cera_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 4. 
--------------------------------------------------------------------------
select
condition_era_id
into #condition_era_score_step1
from  @cdmSchema.condition_era;
--------------------------------------------------------------------------
--> 5.
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 s1.condition_era_id as uniq_no
,case
  when stratum2 = 'condition_era_id' then completeness_gb
  else 0
 end as condition_era_id
,case
  when stratum2 = 'person_id' then completeness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id' then completeness_gb
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_era_start_date' then completeness_gb
  else 0
 end as condition_era_start_date
,case
  when stratum2 = 'condition_era_end_date' then completeness_gb
  else 0
 end as condition_era_end_date
,case
  when stratum2 = 'condition_occurrence_count' then completeness_gb
  else 0
 end as condition_occurrence_count
 into #condition_era_score_step2_c
from #condition_era_score_step1  as s1
left join #score_condition_era_fn as p1
on s1.condition_era_id = p1.uniq_no
-- 2
select
 s1.condition_era_id as uniq_no
,case
  when stratum2 = 'condition_era_id' then conformance_relation_gb
  else 0
 end as condition_era_id
,case
  when stratum2 = 'person_id' then conformance_relation_gb
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id' then conformance_relation_gb
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_era_start_date' then conformance_relation_gb
  else 0
 end as condition_era_start_date
,case
  when stratum2 = 'condition_era_end_date' then conformance_relation_gb
  else 0
 end as condition_era_end_date
,case
  when stratum2 = 'condition_occurrence_count' then conformance_relation_gb
  else 0
 end as condition_occurrence_count
 into #condition_era_score_step2_cr
from #condition_era_score_step1  as s1
left join #score_condition_era_fn as p1
on s1.condition_era_id = p1.uniq_no
-- 3
select
 s1.condition_era_id as uniq_no
,case
  when stratum2 = 'condition_era_id' then conformance_value_gb
  else 0
 end as condition_era_id
,case
  when stratum2 = 'person_id' then conformance_value_gb
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id' then conformance_value_gb
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_era_start_date' then conformance_value_gb
  else 0
 end as condition_era_start_date
,case
  when stratum2 = 'condition_era_end_date' then conformance_value_gb
  else 0
 end as condition_era_end_date
,case
  when stratum2 = 'condition_occurrence_count' then conformance_value_gb
  else 0
 end as condition_occurrence_count
 into #condition_era_score_step2_cv
from #condition_era_score_step1  as s1
left join #score_condition_era_fn as p1
on s1.condition_era_id = p1.uniq_no
-- 4
select
 s1.condition_era_id as uniq_no
,case
  when stratum2 = 'condition_era_id' then Uniqueness_gb
  else 0
 end as condition_era_id
,case
  when stratum2 = 'person_id' then Uniqueness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id' then Uniqueness_gb
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_era_start_date' then Uniqueness_gb
  else 0
 end as condition_era_start_date
,case
  when stratum2 = 'condition_era_end_date' then Uniqueness_gb
  else 0
 end as condition_era_end_date
,case
  when stratum2 = 'condition_occurrence_count' then Uniqueness_gb
  else 0
 end as condition_occurrence_count
 into #condition_era_score_step2_u
from #condition_era_score_step1  as s1
left join #score_condition_era_fn as p1
on s1.condition_era_id = p1.uniq_no
-- 5
select
 s1.condition_era_id as uniq_no
,case
  when stratum2 = 'condition_era_id' then plausibility_atemporal_gb
  else 0
 end as condition_era_id
,case
  when stratum2 = 'person_id' then plausibility_atemporal_gb
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id' then plausibility_atemporal_gb
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_era_start_date' then plausibility_atemporal_gb
  else 0
 end as condition_era_start_date
,case
  when stratum2 = 'condition_era_end_date' then plausibility_atemporal_gb
  else 0
 end as condition_era_end_date
,case
  when stratum2 = 'condition_occurrence_count' then plausibility_atemporal_gb
  else 0
 end as condition_occurrence_count
 into #condition_era_score_step2_ap
from #condition_era_score_step1  as s1
left join #score_condition_era_fn as p1
on s1.condition_era_id = p1.uniq_no
-- 6
select
 s1.condition_era_id as uniq_no
,case
  when stratum2 = 'condition_era_id' then Accuracy_gb
  else 0
 end as condition_era_id
,case
  when stratum2 = 'person_id' then Accuracy_gb
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id' then Accuracy_gb
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_era_start_date' then Accuracy_gb
  else 0
 end as condition_era_start_date
,case
  when stratum2 = 'condition_era_end_date' then Accuracy_gb
  else 0
 end as condition_era_end_date
,case
  when stratum2 = 'condition_occurrence_count' then Accuracy_gb
  else 0
 end as condition_occurrence_count
 into #condition_era_score_step2_ac
from #condition_era_score_step1  as s1
left join #score_condition_era_fn as p1
on s1.condition_era_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 uniq_no
,sum(condition_era_id) as condition_era_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_era_start_date) as condition_era_start_date
,sum(condition_era_end_date) as condition_era_end_date
,sum(condition_occurrence_count) as condition_occurrence_count
 into #condition_era_score_step3_c
from #condition_era_score_step2_c
group by uniq_no
-- 2
select
 uniq_no
,sum(condition_era_id) as condition_era_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_era_start_date) as condition_era_start_date
,sum(condition_era_end_date) as condition_era_end_date
,sum(condition_occurrence_count) as condition_occurrence_count
 into #condition_era_score_step3_cr
from #condition_era_score_step2_cr
group by uniq_no
-- 3
select
 uniq_no
,sum(condition_era_id) as condition_era_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_era_start_date) as condition_era_start_date
,sum(condition_era_end_date) as condition_era_end_date
,sum(condition_occurrence_count) as condition_occurrence_count
 into #condition_era_score_step3_cv
from #condition_era_score_step2_cv
group by uniq_no
-- 4
select
 uniq_no
,sum(condition_era_id) as condition_era_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_era_start_date) as condition_era_start_date
,sum(condition_era_end_date) as condition_era_end_date
,sum(condition_occurrence_count) as condition_occurrence_count
 into #condition_era_score_step3_u
from #condition_era_score_step2_u
group by uniq_no
-- 5
select
 uniq_no
,sum(condition_era_id) as condition_era_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_era_start_date) as condition_era_start_date
,sum(condition_era_end_date) as condition_era_end_date
,sum(condition_occurrence_count) as condition_occurrence_count
 into #condition_era_score_step3_ap
from #condition_era_score_step2_ap
group by uniq_no
-- 6
select
 uniq_no
,sum(condition_era_id) as condition_era_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_era_start_date) as condition_era_start_date
,sum(condition_era_end_date) as condition_era_end_date
,sum(condition_occurrence_count) as condition_occurrence_count
 into #condition_era_score_step3_ac
from #condition_era_score_step2_ac
group by uniq_no
--------------------------------------------------------------------------
--> 7. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 'Completeness score: Condition_era' as name
,cast(1.0-((
  ((s2.score_condition_era_id/m1.max_uniq_no)*0.18)+
  ((s2.score_person_id/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_era_start_date/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_era_end_date/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_occurrence_count/m1.max_uniq_no)*1))) as float)
from
(select
 sum(condition_era_id) as score_condition_era_id
,sum(person_id) as score_person_id
,sum(condition_concept_id) as score_condition_concept_id
,sum(condition_era_start_date) as score_condition_era_start_date
,sum(condition_era_end_date) as score_condition_era_end_date
,sum(condition_occurrence_count) as score_condition_occurrence_count
from #condition_era_score_step3_c) as s2
cross join
(select count(condition_era_id) as max_uniq_no from @cdmSchema.condition_era) as m1
-- 2
select
 'Conformance-relation score: Condition_era' as name
,cast(1.0-((
  ((s2.score_condition_era_id/m1.max_uniq_no)*0.2)+
  ((s2.score_person_id/m1.max_uniq_no)*0.2)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.2)+
  ((s2.score_condition_era_start_date/m1.max_uniq_no)*0.133333333334)+
  ((s2.score_condition_era_end_date/m1.max_uniq_no)*0.133333333333)+
  ((s2.score_condition_occurrence_count/m1.max_uniq_no)*0.133333333333))) as float)
from
(select
 sum(condition_era_id) as score_condition_era_id
,sum(person_id) as score_person_id
,sum(condition_concept_id) as score_condition_concept_id
,sum(condition_era_start_date) as score_condition_era_start_date
,sum(condition_era_end_date) as score_condition_era_end_date
,sum(condition_occurrence_count) as score_condition_occurrence_count
from #condition_era_score_step3_cr) as s2
cross join
(select count(condition_era_id) as max_uniq_no from @cdmSchema.condition_era) as m1
-- 3
select
 'Conformance-value score: Condition_era' as name
,cast(1.0-((
  ((s2.score_condition_era_id/m1.max_uniq_no)*0.18)+
  ((s2.score_person_id/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_era_start_date/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_era_end_date/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_occurrence_count/m1.max_uniq_no)*1))) as float)
from
(select
 sum(condition_era_id) as score_condition_era_id
,sum(person_id) as score_person_id
,sum(condition_concept_id) as score_condition_concept_id
,sum(condition_era_start_date) as score_condition_era_start_date
,sum(condition_era_end_date) as score_condition_era_end_date
,sum(condition_occurrence_count) as score_condition_occurrence_count
from #condition_era_score_step3_cv) as s2
cross join
(select count(condition_era_id) as max_uniq_no from @cdmSchema.condition_era) as m1
-- 4
select
 'Uniqueness score: Condition_era' as name
,cast(1.0-((
  ((s2.score_condition_era_id/m1.max_uniq_no)*0.18)+
  ((s2.score_person_id/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_era_start_date/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_era_end_date/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_occurrence_count/m1.max_uniq_no)*1))) as float)
from
(select
 sum(condition_era_id) as score_condition_era_id
,sum(person_id) as score_person_id
,sum(condition_concept_id) as score_condition_concept_id
,sum(condition_era_start_date) as score_condition_era_start_date
,sum(condition_era_end_date) as score_condition_era_end_date
,sum(condition_occurrence_count) as score_condition_occurrence_count
from #condition_era_score_step3_u) as s2
cross join
(select count(condition_era_id) as max_uniq_no from @cdmSchema.condition_era) as m1
-- 5
select
 'Plausibility-Atemporal score: Condition_era' as name
,cast(1.0-((
  ((s2.score_condition_era_id/m1.max_uniq_no)*0.17)+
  ((s2.score_person_id/m1.max_uniq_no)*0.17)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.17)+
  ((s2.score_condition_era_start_date/m1.max_uniq_no)*0.2)+
  ((s2.score_condition_era_end_date/m1.max_uniq_no)*0.2)+
  ((s2.score_condition_occurrence_count/m1.max_uniq_no)*0.9))) as float)
from
(select
 sum(condition_era_id) as score_condition_era_id
,sum(person_id) as score_person_id
,sum(condition_concept_id) as score_condition_concept_id
,sum(condition_era_start_date) as score_condition_era_start_date
,sum(condition_era_end_date) as score_condition_era_end_date
,sum(condition_occurrence_count) as score_condition_occurrence_count
from #condition_era_score_step3_ap) as s2
cross join
(select count(condition_era_id) as max_uniq_no from @cdmSchema.condition_era) as m1
-- 6
select
 'Accuracy score: Condition_era' as name
,cast(1.0-((
  ((s2.score_condition_era_id/m1.max_uniq_no)*0.18)+
  ((s2.score_person_id/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_era_start_date/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_era_end_date/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_occurrence_count/m1.max_uniq_no)*1))) as float)
from
(select
 sum(condition_era_id) as score_condition_era_id
,sum(person_id) as score_person_id
,sum(condition_concept_id) as score_condition_concept_id
,sum(condition_era_start_date) as score_condition_era_start_date
,sum(condition_era_end_date) as score_condition_era_end_date
,sum(condition_occurrence_count) as score_condition_occurrence_count
from #condition_era_score_step3_ac) as s2
cross join
(select count(condition_era_id) as max_uniq_no from @cdmSchema.condition_era) as m1
--------------------------------------------------------------------------
--> 8. 
--------------------------------------------------------------------------
select
    *
into #score_condition_era_fn_t
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
from #score_condition_era_main) as m1
left join
(select
 stratum2
,err_no
 from #cera_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #cera_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #cera_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #cera_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #cera_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #cera_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 9.
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 s1.condition_era_id as uniq_no
,case
  when stratum2 = 'condition_era_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as condition_era_id
,case
  when stratum2 = 'person_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as person_id
,case
  when stratum2 = 'condition_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as condition_concept_id
,case
  when stratum2 = 'condition_era_start_date' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as condition_era_start_date
,case
  when stratum2 = 'condition_era_end_date' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as condition_era_end_date
,case
  when stratum2 = 'condition_occurrence_count' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb+Accuracy_gb)
  else 0
 end as condition_occurrence_count
 into #condition_era_score_step2_t
from #condition_era_score_step1  as s1
left join #score_condition_era_fn_t as p1
on s1.condition_era_id = p1.uniq_no
--------------------------------------------------------------------------
--> 10. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 uniq_no
,sum(condition_era_id) as condition_era_id
,sum(person_id) as person_id
,sum(condition_concept_id) as condition_concept_id
,sum(condition_era_start_date) as condition_era_start_date
,sum(condition_era_end_date) as condition_era_end_date
,sum(condition_occurrence_count) as condition_occurrence_count
 into #condition_era_score_step3_t
from #condition_era_score_step2_t
group by uniq_no
--------------------------------------------------------------------------
--> 11. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 'Table score: Condition_era' as name
,cast(1.0-((
  ((s2.score_condition_era_id/m1.max_uniq_no)*0.18)+
  ((s2.score_person_id/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_concept_id/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_era_start_date/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_era_end_date/m1.max_uniq_no)*0.18)+
  ((s2.score_condition_occurrence_count/m1.max_uniq_no)*1))) as float)
from
(select
 sum(condition_era_id) as score_condition_era_id
,sum(person_id) as score_person_id
,sum(condition_concept_id) as score_condition_concept_id
,sum(condition_era_start_date) as score_condition_era_start_date
,sum(condition_era_end_date) as score_condition_era_end_date
,sum(condition_occurrence_count) as score_condition_occurrence_count
from #condition_era_score_step3_t) as s2
cross join
(select count(condition_era_id) as max_uniq_no from @cdmSchema.condition_era) as m1