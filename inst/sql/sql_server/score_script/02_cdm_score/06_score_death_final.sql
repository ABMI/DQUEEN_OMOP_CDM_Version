IF OBJECT_ID('tempdb..#score_death_main','U') is not null drop table #score_death_main 
IF OBJECT_ID('tempdb..#dt_Completeness_gb','U') is not null drop table #dt_Completeness_gb 
IF OBJECT_ID('tempdb..#dt_Conformance_value_gb','U') is not null drop table #dt_Conformance_value_gb 
IF OBJECT_ID('tempdb..#dt_Conformance_relation_gb','U') is not null drop table #dt_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#dt_Uniqueness_gb','U') is not null drop table #dt_Uniqueness_gb 
IF OBJECT_ID('tempdb..#dt_Plausibility_atemporal_gb','U') is not null drop table #dt_Plausibility_atemporal_gb 
IF OBJECT_ID('tempdb..#dt_Accuracy_gb','U') is not null drop table #dt_Accuracy_gb 
IF OBJECT_ID('tempdb..#score_death_fn','U') is not null drop table #score_death_fn 
IF OBJECT_ID('tempdb..#death_score_step1','U') is not null drop table #death_score_step1 
IF OBJECT_ID('tempdb..#death_score_step2_c','U') is not null drop table #death_score_step2_c 
IF OBJECT_ID('tempdb..#death_score_step2_cr','U') is not null drop table #death_score_step2_cr 
IF OBJECT_ID('tempdb..#death_score_step2_cv','U') is not null drop table #death_score_step2_cv 
IF OBJECT_ID('tempdb..#death_score_step2_u','U') is not null drop table #death_score_step2_u 
IF OBJECT_ID('tempdb..#death_score_step2_ap','U') is not null drop table #death_score_step2_ap 
IF OBJECT_ID('tempdb..#death_score_step2_ac','U') is not null drop table #death_score_step2_ac 
IF OBJECT_ID('tempdb..#death_score_step3_c','U') is not null drop table #death_score_step3_c 
IF OBJECT_ID('tempdb..#death_score_step3_cr','U') is not null drop table #death_score_step3_cr 
IF OBJECT_ID('tempdb..#death_score_step3_cv','U') is not null drop table #death_score_step3_cv 
IF OBJECT_ID('tempdb..#death_score_step3_u','U') is not null drop table #death_score_step3_u 
IF OBJECT_ID('tempdb..#death_score_step3_ap','U') is not null drop table #death_score_step3_ap 
IF OBJECT_ID('tempdb..#death_score_step3_ac','U') is not null drop table #death_score_step3_ac 
IF OBJECT_ID('tempdb..#score_death_fn_t','U') is not null drop table #score_death_fn_t 
IF OBJECT_ID('tempdb..#death_score_step2_t','U') is not null drop table #death_score_step2_t 
IF OBJECT_ID('tempdb..#death_score_step3_t','U') is not null drop table #death_score_step3_t 

--> 1. order by the table error uniq_number
--> DQ concept of uniq stratum2 null select
--------------------------------------------------------------------------
select
distinct
 tb_id
,stratum2
,err_no as uniq_no
into #score_death_main
from @resultSchema.score_log_CDM
where tb_id = 15;
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
into #dt_Completeness_gb
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
where sm1.tb_id =15)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #dt_Conformance_value_gb
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
where sm1.tb_id =15)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #dt_Conformance_relation_gb
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
where sm1.tb_id =15)v
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
into #dt_Uniqueness_gb
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
where sm1.tb_id =15)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #dt_Plausibility_atemporal_gb
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
where sm1.tb_id =15)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #dt_Accuracy_gb
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
where sm1.tb_id =15)v
--------------------------------------------------------------------------
--> 3. Lable DQ concept score
--------------------------------------------------------------------------
select
    *
into #score_death_fn
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
from #score_death_main) as m1
left join
(select
 stratum2
,err_no
 from #dt_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #dt_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #dt_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #dt_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #dt_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #dt_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 4. table uniq_no 
--------------------------------------------------------------------------
select
person_id
into #death_score_step1
from  @cdmSchema.death;
--------------------------------------------------------------------------
--> 5. table score
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
--1
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id' then completeness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'death_date' then completeness_gb
  else 0
 end as death_date
,case
  when stratum2 = 'death_datetime' then completeness_gb
  else 0
 end as death_datetime
,case
  when stratum2 = 'death_type_concept_id' then completeness_gb
  else 0
 end as death_type_concept_id
,case
  when stratum2 = 'cause_concept_id' then completeness_gb
  else 0
 end as cause_concept_id
,case
  when stratum2 = 'cause_source_value' then completeness_gb
  else 0
 end as cause_source_value
,case
  when stratum2 = 'cause_source_concept_id' then completeness_gb
  else 0
 end as cause_source_concept_id
 into #death_score_step2_c
from #death_score_step1  as s1
left join #score_death_fn as p1
on s1.person_id = p1.uniq_no
-- 2
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id' then conformance_relation_gb
  else 0
 end as person_id
,case
  when stratum2 = 'death_date' then conformance_relation_gb
  else 0
 end as death_date
,case
  when stratum2 = 'death_datetime' then conformance_relation_gb
  else 0
 end as death_datetime
,case
  when stratum2 = 'death_type_concept_id' then conformance_relation_gb
  else 0
 end as death_type_concept_id
,case
  when stratum2 = 'cause_concept_id' then conformance_relation_gb
  else 0
 end as cause_concept_id
,case
  when stratum2 = 'cause_source_value' then conformance_relation_gb
  else 0
 end as cause_source_value
,case
  when stratum2 = 'cause_source_concept_id' then conformance_relation_gb
  else 0
 end as cause_source_concept_id
 into #death_score_step2_cr
from #death_score_step1  as s1
left join #score_death_fn as p1
on s1.person_id = p1.uniq_no
-- 3
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id' then conformance_value_gb
  else 0
 end as person_id
,case
  when stratum2 = 'death_date' then conformance_value_gb
  else 0
 end as death_date
,case
  when stratum2 = 'death_datetime' then conformance_value_gb
  else 0
 end as death_datetime
,case
  when stratum2 = 'death_type_concept_id' then conformance_value_gb
  else 0
 end as death_type_concept_id
,case
  when stratum2 = 'cause_concept_id' then conformance_value_gb
  else 0
 end as cause_concept_id
,case
  when stratum2 = 'cause_source_value' then conformance_value_gb
  else 0
 end as cause_source_value
,case
  when stratum2 = 'cause_source_concept_id' then conformance_value_gb
  else 0
 end as cause_source_concept_id
 into #death_score_step2_cv
from #death_score_step1  as s1
left join #score_death_fn as p1
on s1.person_id = p1.uniq_no
-- 4
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id' then Uniqueness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'death_date' then Uniqueness_gb
  else 0
 end as death_date
,case
  when stratum2 = 'death_datetime' then Uniqueness_gb
  else 0
 end as death_datetime
,case
  when stratum2 = 'death_type_concept_id' then Uniqueness_gb
  else 0
 end as death_type_concept_id
,case
  when stratum2 = 'cause_concept_id' then Uniqueness_gb
  else 0
 end as cause_concept_id
,case
  when stratum2 = 'cause_source_value' then Uniqueness_gb
  else 0
 end as cause_source_value
,case
  when stratum2 = 'cause_source_concept_id' then Uniqueness_gb
  else 0
 end as cause_source_concept_id
 into #death_score_step2_u
from #death_score_step1  as s1
left join #score_death_fn as p1
on s1.person_id = p1.uniq_no
--5
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id' then plausibility_atemporal_gb
  else 0
 end as person_id
,case
  when stratum2 = 'death_date' then plausibility_atemporal_gb
  else 0
 end as death_date
,case
  when stratum2 = 'death_datetime' then plausibility_atemporal_gb
  else 0
 end as death_datetime
,case
  when stratum2 = 'death_type_concept_id' then plausibility_atemporal_gb
  else 0
 end as death_type_concept_id
,case
  when stratum2 = 'cause_concept_id' then plausibility_atemporal_gb
  else 0
 end as cause_concept_id
,case
  when stratum2 = 'cause_source_value' then plausibility_atemporal_gb
  else 0
 end as cause_source_value
,case
  when stratum2 = 'cause_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as cause_source_concept_id
 into #death_score_step2_ap
from #death_score_step1  as s1
left join #score_death_fn as p1
on s1.person_id = p1.uniq_no
-- 6
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id' then Accuracy_gb
  else 0
 end as person_id
,case
  when stratum2 = 'death_date' then Accuracy_gb
  else 0
 end as death_date
,case
  when stratum2 = 'death_datetime' then Accuracy_gb
  else 0
 end as death_datetime
,case
  when stratum2 = 'death_type_concept_id' then Accuracy_gb
  else 0
 end as death_type_concept_id
,case
  when stratum2 = 'cause_concept_id' then Accuracy_gb
  else 0
 end as cause_concept_id
,case
  when stratum2 = 'cause_source_value' then Accuracy_gb
  else 0
 end as cause_source_value
,case
  when stratum2 = 'cause_source_concept_id' then Accuracy_gb
  else 0
 end as cause_source_concept_id
 into #death_score_step2_ac
from #death_score_step1  as s1
left join #score_death_fn as p1
on s1.person_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
--1
select
 uniq_no
,sum(person_id) as person_id
,sum(death_date) as death_date
,sum(death_datetime) as death_datetime
,sum(death_type_concept_id) as death_type_concept_id
,sum(cause_concept_id) as cause_concept_id
,sum(cause_source_value) as cause_source_value
,sum(cause_source_concept_id) as cause_source_concept_id
 into #death_score_step3_c
from #death_score_step2_c
group by uniq_no
--2
select
 uniq_no
,sum(person_id) as person_id
,sum(death_date) as death_date
,sum(death_datetime) as death_datetime
,sum(death_type_concept_id) as death_type_concept_id
,sum(cause_concept_id) as cause_concept_id
,sum(cause_source_value) as cause_source_value
,sum(cause_source_concept_id) as cause_source_concept_id
 into #death_score_step3_cr
from #death_score_step2_cr
group by uniq_no
--3
select
 uniq_no
,sum(person_id) as person_id
,sum(death_date) as death_date
,sum(death_datetime) as death_datetime
,sum(death_type_concept_id) as death_type_concept_id
,sum(cause_concept_id) as cause_concept_id
,sum(cause_source_value) as cause_source_value
,sum(cause_source_concept_id) as cause_source_concept_id
 into #death_score_step3_cv
from #death_score_step2_cv
group by uniq_no
--4
select
 uniq_no
,sum(person_id) as person_id
,sum(death_date) as death_date
,sum(death_datetime) as death_datetime
,sum(death_type_concept_id) as death_type_concept_id
,sum(cause_concept_id) as cause_concept_id
,sum(cause_source_value) as cause_source_value
,sum(cause_source_concept_id) as cause_source_concept_id
 into #death_score_step3_u
from #death_score_step2_u
group by uniq_no
--5
select
 uniq_no
,sum(person_id) as person_id
,sum(death_date) as death_date
,sum(death_datetime) as death_datetime
,sum(death_type_concept_id) as death_type_concept_id
,sum(cause_concept_id) as cause_concept_id
,sum(cause_source_value) as cause_source_value
,sum(cause_source_concept_id) as cause_source_concept_id
 into #death_score_step3_ap
from #death_score_step2_ap
group by uniq_no
--6
select
 uniq_no
,sum(person_id) as person_id
,sum(death_date) as death_date
,sum(death_datetime) as death_datetime
,sum(death_type_concept_id) as death_type_concept_id
,sum(cause_concept_id) as cause_concept_id
,sum(cause_source_value) as cause_source_value
,sum(cause_source_concept_id) as cause_source_concept_id
 into #death_score_step3_ac
from #death_score_step2_ac
group by uniq_no
--------------------------------------------------------------------------
--> 7. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1 Completeness
select
 'Completeness score: death' as name
,cast(1.0-((
  ((s2.score_person_id/m1.max_uniq_no)*0.2)+
  ((s2.score_death_date/m1.max_uniq_no)*0.2)+
  ((s2.score_death_datetime/m1.max_uniq_no)*0.1)+
  ((s2.score_death_type_concept_id/m1.max_uniq_no)*0.2)+
  ((s2.score_cause_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cause_source_value/m1.max_uniq_no)*0.1)+
  ((s2.score_cause_source_concept_id/m1.max_uniq_no)*0.1))) as float)
from
(select
 sum(person_id) as score_person_id
,sum(death_date) as score_death_date
,sum(death_datetime) as score_death_datetime
,sum(death_type_concept_id) as score_death_type_concept_id
,sum(cause_concept_id) as score_cause_concept_id
,sum(cause_source_value) as score_cause_source_value
,sum(cause_source_concept_id) as score_cause_source_concept_id
from #death_score_step3_c) as s2
cross join
(select count(person_id) as max_uniq_no from @cdmSchema.death) as m1
-- 2 conformance-relation
select
 'conformance-relation score: death' as name
,cast(1.0-((
  ((s2.score_person_id/m1.max_uniq_no)*0.2)+
  ((s2.score_death_date/m1.max_uniq_no)*0.1)+
  ((s2.score_death_datetime/m1.max_uniq_no)*0.1)+
  ((s2.score_death_type_concept_id/m1.max_uniq_no)*0.2)+
  ((s2.score_cause_concept_id/m1.max_uniq_no)*0.2)+
  ((s2.score_cause_source_value/m1.max_uniq_no)*0.1)+
  ((s2.score_cause_source_concept_id/m1.max_uniq_no)*0.1))) as float)
from
(select
 sum(person_id) as score_person_id
,sum(death_date) as score_death_date
,sum(death_datetime) as score_death_datetime
,sum(death_type_concept_id) as score_death_type_concept_id
,sum(cause_concept_id) as score_cause_concept_id
,sum(cause_source_value) as score_cause_source_value
,sum(cause_source_concept_id) as score_cause_source_concept_id
from #death_score_step3_cr) as s2
cross join
(select count(person_id) as max_uniq_no from @cdmSchema.death) as m1
-- 3 conformance-value
select
 'conformance-value score: death' as name
,cast(1.0-((
  ((s2.score_person_id/m1.max_uniq_no)*0.2)+
  ((s2.score_death_date/m1.max_uniq_no)*0.1)+
  ((s2.score_death_datetime/m1.max_uniq_no)*0.1)+
  ((s2.score_death_type_concept_id/m1.max_uniq_no)*0.2)+
  ((s2.score_cause_concept_id/m1.max_uniq_no)*0.2)+
  ((s2.score_cause_source_value/m1.max_uniq_no)*0.1)+
  ((s2.score_cause_source_concept_id/m1.max_uniq_no)*0.1))) as float)
from
(select
 sum(person_id) as score_person_id
,sum(death_date) as score_death_date
,sum(death_datetime) as score_death_datetime
,sum(death_type_concept_id) as score_death_type_concept_id
,sum(cause_concept_id) as score_cause_concept_id
,sum(cause_source_value) as score_cause_source_value
,sum(cause_source_concept_id) as score_cause_source_concept_id
from #death_score_step3_cv) as s2
cross join
(select count(person_id) as max_uniq_no from @cdmSchema.death) as m1
-- 4 uniqueness
select
 'Uniqueness score: death' as name
,cast(1.0-((
  ((s2.score_person_id/m1.max_uniq_no)*0.2)+
  ((s2.score_death_date/m1.max_uniq_no)*0.2)+
  ((s2.score_death_datetime/m1.max_uniq_no)*0.1)+
  ((s2.score_death_type_concept_id/m1.max_uniq_no)*0.2)+
  ((s2.score_cause_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cause_source_value/m1.max_uniq_no)*0.1)+
  ((s2.score_cause_source_concept_id/m1.max_uniq_no)*0.1))) as float)
from
(select
 sum(person_id) as score_person_id
,sum(death_date) as score_death_date
,sum(death_datetime) as score_death_datetime
,sum(death_type_concept_id) as score_death_type_concept_id
,sum(cause_concept_id) as score_cause_concept_id
,sum(cause_source_value) as score_cause_source_value
,sum(cause_source_concept_id) as score_cause_source_concept_id
from #death_score_step3_u) as s2
cross join
(select count(person_id) as max_uniq_no from @cdmSchema.death) as m1
-- 5 plausibility-plausibility
select
 'plausibility-plausibility score: death' as name
,cast(1.0-((
  ((s2.score_person_id/m1.max_uniq_no)*0.2)+
  ((s2.score_death_date/m1.max_uniq_no)*0.2)+
  ((s2.score_death_datetime/m1.max_uniq_no)*0.15)+
  ((s2.score_death_type_concept_id/m1.max_uniq_no)*0.2)+
  ((s2.score_cause_concept_id/m1.max_uniq_no)*0.15)+
  ((s2.score_cause_source_value/m1.max_uniq_no)*0.05)+
  ((s2.score_cause_source_concept_id/m1.max_uniq_no)*0.05))) as float)
from
(select
 sum(person_id) as score_person_id
,sum(death_date) as score_death_date
,sum(death_datetime) as score_death_datetime
,sum(death_type_concept_id) as score_death_type_concept_id
,sum(cause_concept_id) as score_cause_concept_id
,sum(cause_source_value) as score_cause_source_value
,sum(cause_source_concept_id) as score_cause_source_concept_id
from #death_score_step3_ap) as s2
cross join
(select count(person_id) as max_uniq_no from @cdmSchema.death) as m1
--6 Accuracy
select
 'Accuracy score: death' as name
,cast(1.0-((
  ((s2.score_person_id/m1.max_uniq_no)*0.15)+
  ((s2.score_death_date/m1.max_uniq_no)*0.15)+
  ((s2.score_death_datetime/m1.max_uniq_no)*0.15)+
  ((s2.score_death_type_concept_id/m1.max_uniq_no)*0.15)+
  ((s2.score_cause_concept_id/m1.max_uniq_no)*0.15)+
  ((s2.score_cause_source_value/m1.max_uniq_no)*0.15)+
  ((s2.score_cause_source_concept_id/m1.max_uniq_no)*0.1))) as float)
from
(select
 sum(person_id) as score_person_id
,sum(death_date) as score_death_date
,sum(death_datetime) as score_death_datetime
,sum(death_type_concept_id) as score_death_type_concept_id
,sum(cause_concept_id) as score_cause_concept_id
,sum(cause_source_value) as score_cause_source_value
,sum(cause_source_concept_id) as score_cause_source_concept_id
from #death_score_step3_ac) as s2
cross join
(select count(person_id) as max_uniq_no from @cdmSchema.death) as m1
--------------------------------------------------------------------------
--> 8. Lable DQ concept score
--------------------------------------------------------------------------
select
    *
into #score_death_fn_t
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
from #score_death_main) as m1
left join
(select
 stratum2
,err_no
 from #dt_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #dt_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #dt_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #dt_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #dt_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #dt_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 9. table score
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as person_id
,case
  when stratum2 = 'death_date' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as death_date
,case
  when stratum2 = 'death_datetime' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as death_datetime
,case
  when stratum2 = 'death_type_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as death_type_concept_id
,case
  when stratum2 = 'cause_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as cause_concept_id
,case
  when stratum2 = 'cause_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as cause_source_value
,case
  when stratum2 = 'cause_source_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as cause_source_concept_id
 into #death_score_step2_t
from #death_score_step1  as s1
left join #score_death_fn_t as p1
on s1.person_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 uniq_no
,sum(person_id) as person_id
,sum(death_date) as death_date
,sum(death_datetime) as death_datetime
,sum(death_type_concept_id) as death_type_concept_id
,sum(cause_concept_id) as cause_concept_id
,sum(cause_source_value) as cause_source_value
,sum(cause_source_concept_id) as cause_source_concept_id
 into #death_score_step3_t
from #death_score_step2_t
group by uniq_no
--------------------------------------------------------------------------
--> 7. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 'Table score: death' as name
,cast(1.0-((
  ((s2.score_person_id/m1.max_uniq_no)*0.2)+
  ((s2.score_death_date/m1.max_uniq_no)*0.2)+
  ((s2.score_death_datetime/m1.max_uniq_no)*0.1)+
  ((s2.score_death_type_concept_id/m1.max_uniq_no)*0.2)+
  ((s2.score_cause_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_cause_source_value/m1.max_uniq_no)*0.1)+
  ((s2.score_cause_source_concept_id/m1.max_uniq_no)*0.1))) as float)
from
(select
 sum(person_id) as score_person_id
,sum(death_date) as score_death_date
,sum(death_datetime) as score_death_datetime
,sum(death_type_concept_id) as score_death_type_concept_id
,sum(cause_concept_id) as score_cause_concept_id
,sum(cause_source_value) as score_cause_source_value
,sum(cause_source_concept_id) as score_cause_source_concept_id
from #death_score_step3_t) as s2
cross join
(select count(person_id) as max_uniq_no from @cdmSchema.death) as m1