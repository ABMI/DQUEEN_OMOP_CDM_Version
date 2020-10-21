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

IF OBJECT_ID('tempdb..#p_Completeness_gb','U') is not null drop table #p_Completeness_gb 
IF OBJECT_ID('tempdb..#p_Conformance_value_gb','U') is not null drop table #p_Conformance_value_gb 
IF OBJECT_ID('tempdb..#p_Conformance_relation_gb','U') is not null drop table #p_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#D_Uniqueness_gb','U') is not null drop table #D_Uniqueness_gb 
IF OBJECT_ID('tempdb..#p_Uniqueness_gb','U') is not null drop table #p_Uniqueness_gb 
IF OBJECT_ID('tempdb..#p_Plausibility_atemporal_gb','U') is not null drop table #p_Plausibility_atemporal_gb 
IF OBJECT_ID('tempdb..#p_Accuracy_gb','U') is not null drop table #p_Accuracy_gb 
IF OBJECT_ID('tempdb..#score_person_fn_C','U') is not null drop table #score_person_fn_C 
IF OBJECT_ID('tempdb..#score_person_fn_cv','U') is not null drop table #score_person_fn_cv 
IF OBJECT_ID('tempdb..#score_person_fn_cr','U') is not null drop table #score_person_fn_cr 
IF OBJECT_ID('tempdb..#score_person_fn_ap','U') is not null drop table #score_person_fn_ap 
IF OBJECT_ID('tempdb..#score_person_fn_u','U') is not null drop table #score_person_fn_u 
IF OBJECT_ID('tempdb..#score_person_fn_a','U') is not null drop table #score_person_fn_a 
IF OBJECT_ID('tempdb..#person_score_step1','U') is not null drop table #person_score_step1 
IF OBJECT_ID('tempdb..#person_score_step2_c','U') is not null drop table #person_score_step2_c 
IF OBJECT_ID('tempdb..#score_person_fn_c','U') is not null drop table #score_person_fn_c 
IF OBJECT_ID('tempdb..#person_score_step2_cr','U') is not null drop table #person_score_step2_cr 
IF OBJECT_ID('tempdb..#person_score_step2_cv','U') is not null drop table #person_score_step2_cv 
IF OBJECT_ID('tempdb..#person_score_step2_u','U') is not null drop table #person_score_step2_u 
IF OBJECT_ID('tempdb..#person_score_step2_ap','U') is not null drop table #person_score_step2_ap 
IF OBJECT_ID('tempdb..#person_score_step2_ac','U') is not null drop table #person_score_step2_ac 
IF OBJECT_ID('tempdb..#person_score_step3_c','U') is not null drop table #person_score_step3_c 
IF OBJECT_ID('tempdb..#person_score_step3_cr','U') is not null drop table #person_score_step3_cr 
IF OBJECT_ID('tempdb..#person_score_step3_cv','U') is not null drop table #person_score_step3_cv 
IF OBJECT_ID('tempdb..#person_score_step3_ap','U') is not null drop table #person_score_step3_ap 
IF OBJECT_ID('tempdb..#person_score_step3_u','U') is not null drop table #person_score_step3_u 
IF OBJECT_ID('tempdb..#person_score_step3_ac','U') is not null drop table #person_score_step3_ac 

--> 1. Completeness
select
distinct
 sub_category
,stratum2
,err_no
 into #p_Completeness_gb
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
where sm1.tb_id =31)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #p_Conformance_value_gb
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
where sm1.tb_id =31)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #p_Conformance_relation_gb
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
where sm1.tb_id =31)v
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
into #p_Uniqueness_gb
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
where sm1.tb_id =31)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #p_Plausibility_atemporal_gb
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
where sm1.tb_id =31)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #p_Accuracy_gb
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
where sm1.tb_id =31)v
--------------------------------------------------------------------------
--> 3. Lable DQ concept score
--------------------------------------------------------------------------
-- 1
select
    *
 into  #score_person_fn_C
from
(select
 stratum2
,err_no as uniq_no
,1 completeness_gb
 from #p_Completeness_gb)v

--2
select
    *
into  #score_person_fn_cv
from
(select
 stratum2
,err_no as uniq_no
, 1 as conformance_value_gb
 from #p_Conformance_value_gb)v ;
-- 3
select
    *
into  #score_person_fn_cr
from
(select
 stratum2
,err_no as uniq_no
,1 as conformance_relation_gb
 from #p_Conformance_relation_gb)v ;
-- 4
select
    *
into  #score_person_fn_ap
from
(select
 stratum2
,err_no as uniq_no
, 1 as plausibility_atemporal_gb
 from #p_Plausibility_atemporal_gb)v ;
-- 5
select
    *
into  #score_person_fn_u
from
(select
 stratum2
,err_no as uniq_no
,1 as Uniqueness_gb
 from #p_Uniqueness_gb)v ;
-- 6
select
    *
into  #score_person_fn_a
from
(
select
 stratum2
,err_no as uniq_no
,1 as Accuracy_gb
 from #p_Accuracy_gb)v ;
--------------------------------------------------------------------------
--> 4. table uniq_no
--------------------------------------------------------------------------
select
person_id
into #person_score_step1
from  @cdmSchema.person;
--------------------------------------------------------------------------
--> 5. table score
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1. Completeness
-- 1. Completeness
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id'  then completeness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'gender_concept_id' then completeness_gb
  else 0
 end as gender_concept_id
,case
  when stratum2 = 'year_of_birth'  then completeness_gb
  else 0
 end as year_of_birth
,case
  when stratum2 = 'month_of_birth' then completeness_gb
  else 0
 end as month_of_birth
,case
  when stratum2 = 'day_of_birth' then completeness_gb
  else 0
 end as day_of_birth
,case
  when stratum2 = 'birth_datetime' then completeness_gb
  else 0
 end as birth_datetime
,case
  when stratum2 = 'race_concept_id' then completeness_gb
  else 0
 end as race_concept_id
,case
  when stratum2 = 'ethnicity_concept_id'  then completeness_gb
  else 0
 end as ethnicity_concept_id
,case
  when stratum2 = 'location_id' then completeness_gb
  else 0
 end as location_id
,case
  when stratum2 = 'provider_id' then completeness_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'care_site_id' then completeness_gb
  else 0
 end as care_site_id
,case
  when stratum2 = 'person_source_value' then completeness_gb
  else 0
 end as person_source_value
,case
  when stratum2 = 'gender_source_value' then completeness_gb
  else 0
 end as gender_source_value
,case
  when stratum2 = 'gender_source_concept_id' then completeness_gb
  else 0
 end as gender_source_concept_id
,case
  when stratum2 = 'race_source_value' then completeness_gb
  else 0
 end as race_source_value
,case
  when stratum2 = 'race_source_concept_id' then completeness_gb
  else 0
 end as race_source_concept_id
,case
  when stratum2 = 'ethnicity_source_value' then completeness_gb
  else 0
 end as ethnicity_source_value
,case
  when stratum2 = 'ethnicity_source_concept_id' then completeness_gb
  else 0
 end as ethnicity_source_concept_id
 into #person_score_step2_c
from #person_score_step1  as s1
left outer join #score_person_fn_c as p1
on s1.person_id = p1.uniq_no
-- 2. Conformance-relation
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id'  then conformance_relation_gb
  else 0
 end as person_id
,case
  when stratum2 = 'gender_concept_id' then conformance_relation_gb
  else 0
 end as gender_concept_id
,case
  when stratum2 = 'race_concept_id' then conformance_relation_gb
  else 0
 end as race_concept_id
,case
  when stratum2 = 'ethnicity_concept_id'  then conformance_relation_gb
  else 0
 end as ethnicity_concept_id
,case
  when stratum2 = 'location_id' then conformance_relation_gb
  else 0
 end as location_id
,case
  when stratum2 = 'provider_id' then conformance_relation_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'care_site_id' then conformance_relation_gb
  else 0
 end as care_site_id
,case
  when stratum2 = 'gender_source_value' then conformance_relation_gb
  else 0
 end as gender_source_value
,case
  when stratum2 = 'gender_source_concept_id' then conformance_relation_gb
  else 0
 end as gender_source_concept_id
,case
  when stratum2 = 'race_source_concept_id' then conformance_relation_gb
  else 0
 end as race_source_concept_id
,case
  when stratum2 = 'ethnicity_source_concept_id' then conformance_relation_gb
  else 0
 end as ethnicity_source_concept_id
 into #person_score_step2_cr
from #person_score_step1  as s1
left outer join #score_person_fn_cr as p1
on s1.person_id = p1.uniq_no
-- 3. Conformance-value
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id'  then conformance_value_gb
  else 0
 end as person_id
,case
  when stratum2 = 'gender_concept_id' then conformance_value_gb
  else 0
 end as gender_concept_id
,case
  when stratum2 = 'year_of_birth'  then conformance_value_gb
  else 0
 end as year_of_birth
,case
  when stratum2 = 'month_of_birth' then conformance_value_gb
 end as month_of_birth
,case
  when stratum2 = 'day_of_birth' then conformance_value_gb
  else 0
 end as day_of_birth
,case
  when stratum2 = 'birth_datetime' then conformance_value_gb
  else 0
 end as birth_datetime
,case
  when stratum2 = 'race_concept_id' then conformance_value_gb
  else 0
 end as race_concept_id
,case
  when stratum2 = 'ethnicity_concept_id'  then conformance_value_gb
  else 0
 end as ethnicity_concept_id
,case
  when stratum2 = 'location_id' then conformance_value_gb
  else 0
 end as location_id
,case
  when stratum2 = 'provider_id' then conformance_value_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'care_site_id' then conformance_value_gb
  else 0
 end as care_site_id
,case
  when stratum2 = 'person_source_value' then conformance_value_gb
  else 0
 end as person_source_value
,case
  when stratum2 = 'gender_source_value' then conformance_value_gb
  else 0
 end as gender_source_value
,case
  when stratum2 = 'gender_source_concept_id' then conformance_value_gb
  else 0
 end as gender_source_concept_id
,case
  when stratum2 = 'race_source_value' then conformance_value_gb
  else 0
 end as race_source_value
,case
  when stratum2 = 'race_source_concept_id' then conformance_value_gb
  else 0
 end as race_source_concept_id
,case
  when stratum2 = 'ethnicity_source_value' then conformance_value_gb
  else 0
 end as ethnicity_source_value
,case
  when stratum2 = 'ethnicity_source_concept_id' then conformance_value_gb
  else 0
 end as ethnicity_source_concept_id
 into #person_score_step2_cv
from #person_score_step1  as s1
left outer join #score_person_fn_cv as p1
on s1.person_id = p1.uniq_no
-- 4. uniqueness
select
 s1.person_id as uniq_no
,case
  when s1.person_id = p1.uniq_no  then Uniqueness_gb
  else 0
 end as person_id
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as gender_concept_id
,case
  when s1.person_id = p1.uniq_no  then Uniqueness_gb
  else 0
 end as year_of_birth
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as month_of_birth
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as day_of_birth
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as birth_datetime
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as race_concept_id
,case
  when s1.person_id = p1.uniq_no  then Uniqueness_gb
  else 0
 end as ethnicity_concept_id
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as location_id
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as provider_id
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as care_site_id
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as person_source_value
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as gender_source_value
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as gender_source_concept_id
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as race_source_value
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as race_source_concept_id
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as ethnicity_source_value
,case
  when s1.person_id = p1.uniq_no then Uniqueness_gb
  else 0
 end as ethnicity_source_concept_id
 into #person_score_step2_u
from #person_score_step1  as s1
left outer join #score_person_fn_u as p1
on s1.person_id = p1.uniq_no
-- 5. Atemporal
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id'  then plausibility_atemporal_gb
  else 0
 end as person_id
,case
  when stratum2 = 'gender_concept_id' then plausibility_atemporal_gb
  else 0
 end as gender_concept_id
,case
  when stratum2 = 'year_of_birth'  then plausibility_atemporal_gb
  else 0
 end as year_of_birth
,case
  when stratum2 = 'month_of_birth' then plausibility_atemporal_gb
  else 0
 end as month_of_birth
,case
  when stratum2 = 'day_of_birth' then plausibility_atemporal_gb
  else 0
 end as day_of_birth
,case
  when stratum2 = 'birth_datetime' then plausibility_atemporal_gb
  else 0
 end as birth_datetime
,case
  when stratum2 = 'race_concept_id' then plausibility_atemporal_gb
  else 0
 end as race_concept_id
,case
  when stratum2 = 'ethnicity_concept_id'  then plausibility_atemporal_gb
  else 0
 end as ethnicity_concept_id
,case
  when stratum2 = 'location_id' then plausibility_atemporal_gb
  else 0
 end as location_id
,case
  when stratum2 = 'provider_id' then plausibility_atemporal_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'care_site_id' then plausibility_atemporal_gb
  else 0
 end as care_site_id
,case
  when stratum2 = 'person_source_value' then plausibility_atemporal_gb
  else 0
 end as person_source_value
,case
  when stratum2 = 'gender_source_value' then plausibility_atemporal_gb
  else 0
 end as gender_source_value
,case
  when stratum2 = 'gender_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as gender_source_concept_id
,case
  when stratum2 = 'race_source_value' then plausibility_atemporal_gb
  else 0
 end as race_source_value
,case
  when stratum2 = 'race_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as race_source_concept_id
,case
  when stratum2 = 'ethnicity_source_value' then plausibility_atemporal_gb
  else 0
 end as ethnicity_source_value
,case
  when stratum2 = 'ethnicity_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as ethnicity_source_concept_id
 into #person_score_step2_ap
from #person_score_step1  as s1
left outer join #score_person_fn_ap as p1
on s1.person_id = p1.uniq_no

-- 6. Accuracy
select
 s1.person_id as uniq_no
,case
  when stratum2 = 'person_id'  then Accuracy_gb
  else 0
 end as person_id
,case
  when stratum2 = 'gender_concept_id' then Accuracy_gb
  else 0
 end as gender_concept_id
,case
  when stratum2 = 'year_of_birth'  then Accuracy_gb
  else 0
 end as year_of_birth
,case
  when stratum2 = 'month_of_birth' then Accuracy_gb
  else 0
 end as month_of_birth
,case
  when stratum2 = 'day_of_birth' then Accuracy_gb
  else 0
 end as day_of_birth
,case
  when stratum2 = 'birth_datetime' then Accuracy_gb
  else 0
 end as birth_datetime
,case
  when stratum2 = 'race_concept_id' then Accuracy_gb
  else 0
 end as race_concept_id
,case
  when stratum2 = 'ethnicity_concept_id'  then Accuracy_gb
  else 0
 end as ethnicity_concept_id
,case
  when stratum2 = 'location_id' then Accuracy_gb
  else 0
 end as location_id
,case
  when stratum2 = 'provider_id' then Accuracy_gb
  else 0
 end as provider_id
,case
  when stratum2 = 'care_site_id' then Accuracy_gb
  else 0
 end as care_site_id
,case
  when stratum2 = 'person_source_value' then Accuracy_gb
  else 0
 end as person_source_value
,case
  when stratum2 = 'gender_source_value' then Accuracy_gb
  else 0
 end as gender_source_value
,case
  when stratum2 = 'gender_source_concept_id' then Accuracy_gb
  else 0
 end as gender_source_concept_id
,case
  when stratum2 = 'race_source_value' then Accuracy_gb
  else 0
 end as race_source_value
,case
  when stratum2 = 'race_source_concept_id' then Accuracy_gb
  else 0
 end as race_source_concept_id
,case
  when stratum2 = 'ethnicity_source_value' then Accuracy_gb
  else 0
 end as ethnicity_source_value
,case
  when stratum2 = 'ethnicity_source_concept_id' then Accuracy_gb
  else 0
 end as ethnicity_source_concept_id
 into #person_score_step2_ac
from #person_score_step1  as s1
left outer join #score_person_fn_a as p1
on s1.person_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1
select
 sum(person_id) as person_id
,sum(gender_concept_id) as gender_concept_id
,sum(year_of_birth) as year_of_birth
,sum(month_of_birth) as month_of_birth
,sum(day_of_birth) as day_of_birth
,sum(birth_datetime) as birth_datetime
,sum(race_concept_id) as race_concept_id
,sum(ethnicity_concept_id) as ethnicity_concept_id
,sum(location_id) as location_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(person_source_value) as person_source_value
,sum(gender_source_value) as gender_source_value
,sum(gender_source_concept_id) as gender_source_concept_id
,sum(race_source_value) as race_source_value
,sum(race_source_concept_id) as race_source_concept_id
,sum(ethnicity_source_value) as ethnicity_source_value
,sum(ethnicity_source_concept_id) as ethnicity_source_concept_id
 into #person_score_step3_c
from #person_score_step2_c
group by uniq_no
-- 2
select
 sum(person_id) as person_id
,sum(gender_concept_id) as gender_concept_id
,sum(race_concept_id) as race_concept_id
,sum(ethnicity_concept_id) as ethnicity_concept_id
,sum(location_id) as location_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(gender_source_concept_id) as gender_source_concept_id
,sum(race_source_concept_id) as race_source_concept_id
,sum(ethnicity_source_concept_id) as ethnicity_source_concept_id
 into #person_score_step3_cr
from #person_score_step2_cr
group by uniq_no
-- 3
select
 sum(person_id) as person_id
,sum(gender_concept_id) as gender_concept_id
,sum(year_of_birth) as year_of_birth
,sum(month_of_birth) as month_of_birth
,sum(day_of_birth) as day_of_birth
,sum(birth_datetime) as birth_datetime
,sum(race_concept_id) as race_concept_id
,sum(ethnicity_concept_id) as ethnicity_concept_id
,sum(location_id) as location_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(person_source_value) as person_source_value
,sum(gender_source_value) as gender_source_value
,sum(gender_source_concept_id) as gender_source_concept_id
,sum(race_source_value) as race_source_value
,sum(race_source_concept_id) as race_source_concept_id
,sum(ethnicity_source_value) as ethnicity_source_value
,sum(ethnicity_source_concept_id) as ethnicity_source_concept_id
 into #person_score_step3_cv
from #person_score_step2_cv
group by uniq_no
-- 4
select
 sum(person_id) as person_id
,sum(gender_concept_id) as gender_concept_id
,sum(year_of_birth) as year_of_birth
,sum(month_of_birth) as month_of_birth
,sum(day_of_birth) as day_of_birth
,sum(birth_datetime) as birth_datetime
,sum(race_concept_id) as race_concept_id
,sum(ethnicity_concept_id) as ethnicity_concept_id
,sum(location_id) as location_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(person_source_value) as person_source_value
,sum(gender_source_value) as gender_source_value
,sum(gender_source_concept_id) as gender_source_concept_id
,sum(race_source_value) as race_source_value
,sum(race_source_concept_id) as race_source_concept_id
,sum(ethnicity_source_value) as ethnicity_source_value
,sum(ethnicity_source_concept_id) as ethnicity_source_concept_id
 into #person_score_step3_ap
from #person_score_step2_ap
group by uniq_no
-- 5
select
 sum(person_id) as person_id
,sum(gender_concept_id) as gender_concept_id
,sum(year_of_birth) as year_of_birth
,sum(month_of_birth) as month_of_birth
,sum(day_of_birth) as day_of_birth
,sum(birth_datetime) as birth_datetime
,sum(race_concept_id) as race_concept_id
,sum(ethnicity_concept_id) as ethnicity_concept_id
,sum(location_id) as location_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(person_source_value) as person_source_value
,sum(gender_source_value) as gender_source_value
,sum(gender_source_concept_id) as gender_source_concept_id
,sum(race_source_value) as race_source_value
,sum(race_source_concept_id) as race_source_concept_id
,sum(ethnicity_source_value) as ethnicity_source_value
,sum(ethnicity_source_concept_id) as ethnicity_source_concept_id
 into #person_score_step3_u
from #person_score_step2_u
group by uniq_no

-- 6
select
 sum(person_id) as person_id
,sum(gender_concept_id) as gender_concept_id
,sum(year_of_birth) as year_of_birth
,sum(month_of_birth) as month_of_birth
,sum(day_of_birth) as day_of_birth
,sum(birth_datetime) as birth_datetime
,sum(race_concept_id) as race_concept_id
,sum(ethnicity_concept_id) as ethnicity_concept_id
,sum(location_id) as location_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(person_source_value) as person_source_value
,sum(gender_source_value) as gender_source_value
,sum(gender_source_concept_id) as gender_source_concept_id
,sum(race_source_value) as race_source_value
,sum(race_source_concept_id) as race_source_concept_id
,sum(ethnicity_source_value) as ethnicity_source_value
,sum(ethnicity_source_concept_id) as ethnicity_source_concept_id
 into #person_score_step3_ac
from #person_score_step2_ac
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
,31 as tb_id
,'Completeness' as cateogy
,'Completeness' as sub_cateogry
,(((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_gender_concept_id/m1.max_uniq_no))+
  ((s2.score_year_of_birth/m1.max_uniq_no))+
  ((s2.score_month_of_birth/m1.max_uniq_no))+
  ((s2.score_day_of_birth/m1.max_uniq_no))+
  ((s2.score_birth_datetime/m1.max_uniq_no))+
  ((s2.score_race_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no))+
  ((s2.score_location_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_person_source_value/m1.max_uniq_no))+
  ((s2.score_gender_source_value/m1.max_uniq_no))+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no))+
  ((s2.score_race_source_value/m1.max_uniq_no))+
  ((s2.score_race_source_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_source_value/m1.max_uniq_no))+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)))/18 as err_rate
,cast(1.0-(((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_gender_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_year_of_birth/m1.max_uniq_no)*0.1)+
  ((s2.score_month_of_birth/m1.max_uniq_no)*0.07)+
  ((s2.score_day_of_birth/m1.max_uniq_no)*0.07)+
  ((s2.score_birth_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_race_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_location_id/m1.max_uniq_no)*0.05)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.05)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.05)+
  ((s2.score_person_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_gender_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_race_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_race_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_ethnicity_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)*0.03)) as float) as score
from
(select
 cast(sum(person_id) as float) as score_person_id
,cast(sum(gender_concept_id) as float) as score_gender_concept_id
,cast(sum(year_of_birth) as float) as score_year_of_birth
,cast(sum(month_of_birth) as float) as score_month_of_birth
,cast(sum(day_of_birth) as float) as score_day_of_birth
,cast(sum(birth_datetime) as float) as score_birth_datetime
,cast(sum(race_concept_id) as float) as score_race_concept_id
,cast(sum(ethnicity_concept_id) as float) as score_ethnicity_concept_id
,cast(sum(location_id) as float) as score_location_id
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(care_site_id) as float) as score_care_site_id
,cast(sum(person_source_value) as float) as score_person_source_value
,cast(sum(gender_source_value) as float) as score_gender_source_value
,cast(sum(gender_source_concept_id) as float) as score_gender_source_concept_id
,cast(sum(race_source_value) as float) as score_race_source_value
,cast(sum(race_source_concept_id) as float) as score_race_source_concept_id
,cast(sum(ethnicity_source_value) as float) as score_ethnicity_source_value
,cast(sum(ethnicity_source_concept_id) as float) as score_ethnicity_source_concept_id
from #person_score_step3_c) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.person) as m1
-- 2. value conformance
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,31 as tb_id
,'conformance' as cateogy
,'value' as sub_cateogry
,(((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_gender_concept_id/m1.max_uniq_no))+
  ((s2.score_year_of_birth/m1.max_uniq_no))+
  ((s2.score_month_of_birth/m1.max_uniq_no))+
  ((s2.score_day_of_birth/m1.max_uniq_no))+
  ((s2.score_birth_datetime/m1.max_uniq_no))+
  ((s2.score_race_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no))+
  ((s2.score_location_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_person_source_value/m1.max_uniq_no))+
  ((s2.score_gender_source_value/m1.max_uniq_no))+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no))+
  ((s2.score_race_source_value/m1.max_uniq_no))+
  ((s2.score_race_source_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_source_value/m1.max_uniq_no))+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)))/18 as err_rate
,cast(1.0-(((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_gender_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_year_of_birth/m1.max_uniq_no)*0.1)+
  ((s2.score_month_of_birth/m1.max_uniq_no)*0.07)+
  ((s2.score_day_of_birth/m1.max_uniq_no)*0.07)+
  ((s2.score_birth_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_race_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_location_id/m1.max_uniq_no)*0.05)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.05)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.05)+
  ((s2.score_person_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_gender_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_race_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_race_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_ethnicity_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)*0.03)) as float) as score
from
(select
 cast(sum(person_id) as float) as score_person_id
,cast(sum(gender_concept_id) as float) as score_gender_concept_id
,cast(sum(year_of_birth) as float) as score_year_of_birth
,cast(sum(month_of_birth) as float) as score_month_of_birth
,cast(sum(day_of_birth) as float) as score_day_of_birth
,cast(sum(birth_datetime) as float) as score_birth_datetime
,cast(sum(race_concept_id) as float) as score_race_concept_id
,cast(sum(ethnicity_concept_id) as float) as score_ethnicity_concept_id
,cast(sum(location_id) as float) as score_location_id
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(care_site_id) as float) as score_care_site_id
,cast(sum(person_source_value) as float) as score_person_source_value
,cast(sum(gender_source_value) as float) as score_gender_source_value
,cast(sum(gender_source_concept_id) as float) as score_gender_source_concept_id
,cast(sum(race_source_value) as float) as score_race_source_value
,cast(sum(race_source_concept_id) as float) as score_race_source_concept_id
,cast(sum(ethnicity_source_value) as float) as score_ethnicity_source_value
,cast(sum(ethnicity_source_concept_id) as float) as score_ethnicity_source_concept_id
from #person_score_step3_cv) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.person) as m1
-- 3. relation
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,31 as tb_id
,'conformance' as cateogy
,'relation' as sub_cateogry
,(((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_gender_concept_id/m1.max_uniq_no))+
  ((s2.score_race_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no))+
  ((s2.score_location_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no))+
  ((s2.score_race_source_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)))/10 as err_rate
,cast(1.0-(((s2.score_person_id/m1.max_uniq_no)*0.13)+
  ((s2.score_gender_concept_id/m1.max_uniq_no)*0.13)+
  ((s2.score_race_concept_id/m1.max_uniq_no)*0.13)+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no)*0.13)+
  ((s2.score_location_id/m1.max_uniq_no)*0.13)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.13)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.13)+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_race_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)*0.03)) as float) as score
from
(select
 cast(sum(person_id) as float) as score_person_id
,cast(sum(gender_concept_id) as float) as score_gender_concept_id
,cast(sum(race_concept_id) as float) as score_race_concept_id
,cast(sum(ethnicity_concept_id) as float) as score_ethnicity_concept_id
,cast(sum(location_id) as float) as score_location_id
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(care_site_id) as float) as score_care_site_id
,cast(sum(gender_source_concept_id) as float) as score_gender_source_concept_id
,cast(sum(race_source_concept_id) as float) as score_race_source_concept_id
,cast(sum(ethnicity_source_concept_id) as float) as score_ethnicity_source_concept_id
from #person_score_step3_cr) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.person) as m1
-- 4. uniqueness
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,31 as tb_id
,'plausiblity' as cateogy
,'uniqueness' as sub_cateogry
,(((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_gender_concept_id/m1.max_uniq_no))+
  ((s2.score_year_of_birth/m1.max_uniq_no))+
  ((s2.score_month_of_birth/m1.max_uniq_no))+
  ((s2.score_day_of_birth/m1.max_uniq_no))+
  ((s2.score_birth_datetime/m1.max_uniq_no))+
  ((s2.score_race_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no))+
  ((s2.score_location_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_person_source_value/m1.max_uniq_no))+
  ((s2.score_gender_source_value/m1.max_uniq_no))+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no))+
  ((s2.score_race_source_value/m1.max_uniq_no))+
  ((s2.score_race_source_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_source_value/m1.max_uniq_no))+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)))/18 as err_rate
,cast(1.0-(((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_gender_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_year_of_birth/m1.max_uniq_no)*0.1)+
  ((s2.score_month_of_birth/m1.max_uniq_no)*0.07)+
  ((s2.score_day_of_birth/m1.max_uniq_no)*0.07)+
  ((s2.score_birth_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_race_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_location_id/m1.max_uniq_no)*0.05)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.05)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.05)+
  ((s2.score_person_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_gender_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_race_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_race_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_ethnicity_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)*0.03)) as float) as score
from
(select
 cast(sum(person_id) as float) as score_person_id
,cast(sum(gender_concept_id) as float) as score_gender_concept_id
,cast(sum(year_of_birth) as float) as score_year_of_birth
,cast(sum(month_of_birth) as float) as score_month_of_birth
,cast(sum(day_of_birth) as float) as score_day_of_birth
,cast(sum(birth_datetime) as float) as score_birth_datetime
,cast(sum(race_concept_id) as float) as score_race_concept_id
,cast(sum(ethnicity_concept_id) as float) as score_ethnicity_concept_id
,cast(sum(location_id) as float) as score_location_id
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(care_site_id) as float) as score_care_site_id
,cast(sum(person_source_value) as float) as score_person_source_value
,cast(sum(gender_source_value) as float) as score_gender_source_value
,cast(sum(gender_source_concept_id) as float) as score_gender_source_concept_id
,cast(sum(race_source_value) as float) as score_race_source_value
,cast(sum(race_source_concept_id) as float) as score_race_source_concept_id
,cast(sum(ethnicity_source_value) as float) as score_ethnicity_source_value
,cast(sum(ethnicity_source_concept_id) as float) as score_ethnicity_source_concept_id
from #person_score_step3_u) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.person) as m1
-- 5 atemporal
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,31 as tb_id
,'plausiblity' as cateogy
,'atemporal' as sub_cateogry
,(((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_gender_concept_id/m1.max_uniq_no))+
  ((s2.score_year_of_birth/m1.max_uniq_no))+
  ((s2.score_month_of_birth/m1.max_uniq_no))+
  ((s2.score_day_of_birth/m1.max_uniq_no))+
  ((s2.score_birth_datetime/m1.max_uniq_no))+
  ((s2.score_race_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no))+
  ((s2.score_location_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_person_source_value/m1.max_uniq_no))+
  ((s2.score_gender_source_value/m1.max_uniq_no))+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no))+
  ((s2.score_race_source_value/m1.max_uniq_no))+
  ((s2.score_race_source_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_source_value/m1.max_uniq_no))+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)))/18 as err_rate
,cast(1.0-(((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_gender_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_year_of_birth/m1.max_uniq_no)*0.1)+
  ((s2.score_month_of_birth/m1.max_uniq_no)*0.07)+
  ((s2.score_day_of_birth/m1.max_uniq_no)*0.07)+
  ((s2.score_birth_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_race_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_location_id/m1.max_uniq_no)*0.05)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.05)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.05)+
  ((s2.score_person_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_gender_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_race_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_race_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_ethnicity_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)*0.03)) as float) as score
from
(select
 cast(sum(person_id) as float) as score_person_id
,cast(sum(gender_concept_id) as float) as score_gender_concept_id
,cast(sum(year_of_birth) as float) as score_year_of_birth
,cast(sum(month_of_birth) as float) as score_month_of_birth
,cast(sum(day_of_birth) as float) as score_day_of_birth
,cast(sum(birth_datetime) as float) as score_birth_datetime
,cast(sum(race_concept_id) as float) as score_race_concept_id
,cast(sum(ethnicity_concept_id) as float) as score_ethnicity_concept_id
,cast(sum(location_id) as float) as score_location_id
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(care_site_id) as float) as score_care_site_id
,cast(sum(person_source_value) as float) as score_person_source_value
,cast(sum(gender_source_value) as float) as score_gender_source_value
,cast(sum(gender_source_concept_id) as float) as score_gender_source_concept_id
,cast(sum(race_source_value) as float) as score_race_source_value
,cast(sum(race_source_concept_id) as float) as score_race_source_concept_id
,cast(sum(ethnicity_source_value) as float) as score_ethnicity_source_value
,cast(sum(ethnicity_source_concept_id) as float) as score_ethnicity_source_concept_id
from #person_score_step3_ap) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.person) as m1
-- 6 accuracy
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,31 as tb_id
,'accuracy' as cateogy
,'accuracy' as sub_cateogry
,(((s2.score_person_id/m1.max_uniq_no))+
  ((s2.score_gender_concept_id/m1.max_uniq_no))+
  ((s2.score_year_of_birth/m1.max_uniq_no))+
  ((s2.score_month_of_birth/m1.max_uniq_no))+
  ((s2.score_day_of_birth/m1.max_uniq_no))+
  ((s2.score_birth_datetime/m1.max_uniq_no))+
  ((s2.score_race_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no))+
  ((s2.score_location_id/m1.max_uniq_no))+
  ((s2.score_provider_id/m1.max_uniq_no))+
  ((s2.score_care_site_id/m1.max_uniq_no))+
  ((s2.score_person_source_value/m1.max_uniq_no))+
  ((s2.score_gender_source_value/m1.max_uniq_no))+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no))+
  ((s2.score_race_source_value/m1.max_uniq_no))+
  ((s2.score_race_source_concept_id/m1.max_uniq_no))+
  ((s2.score_ethnicity_source_value/m1.max_uniq_no))+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)))/18 as err_rate
,cast(1.0-(((s2.score_person_id/m1.max_uniq_no)*0.1)+
  ((s2.score_gender_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_year_of_birth/m1.max_uniq_no)*0.1)+
  ((s2.score_month_of_birth/m1.max_uniq_no)*0.07)+
  ((s2.score_day_of_birth/m1.max_uniq_no)*0.07)+
  ((s2.score_birth_datetime/m1.max_uniq_no)*0.07)+
  ((s2.score_race_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_ethnicity_concept_id/m1.max_uniq_no)*0.1)+
  ((s2.score_location_id/m1.max_uniq_no)*0.05)+
  ((s2.score_provider_id/m1.max_uniq_no)*0.05)+
  ((s2.score_care_site_id/m1.max_uniq_no)*0.05)+
  ((s2.score_person_source_value/m1.max_uniq_no)*0.02)+
  ((s2.score_gender_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_gender_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_race_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_race_source_concept_id/m1.max_uniq_no)*0.03)+
  ((s2.score_ethnicity_source_value/m1.max_uniq_no)*0.01)+
  ((s2.score_ethnicity_source_concept_id/m1.max_uniq_no)*0.03)) as float) as score
from
(select
 cast(sum(person_id) as float) as score_person_id
,cast(sum(gender_concept_id) as float) as score_gender_concept_id
,cast(sum(year_of_birth) as float) as score_year_of_birth
,cast(sum(month_of_birth) as float) as score_month_of_birth
,cast(sum(day_of_birth) as float) as score_day_of_birth
,cast(sum(birth_datetime) as float) as score_birth_datetime
,cast(sum(race_concept_id) as float) as score_race_concept_id
,cast(sum(ethnicity_concept_id) as float) as score_ethnicity_concept_id
,cast(sum(location_id) as float) as score_location_id
,cast(sum(provider_id) as float) as score_provider_id
,cast(sum(care_site_id) as float) as score_care_site_id
,cast(sum(person_source_value) as float) as score_person_source_value
,cast(sum(gender_source_value) as float) as score_gender_source_value
,cast(sum(gender_source_concept_id) as float) as score_gender_source_concept_id
,cast(sum(race_source_value) as float) as score_race_source_value
,cast(sum(race_source_concept_id) as float) as score_race_source_concept_id
,cast(sum(ethnicity_source_value) as float) as score_ethnicity_source_value
,cast(sum(ethnicity_source_concept_id) as float) as score_ethnicity_source_concept_id
from #person_score_step3_ac) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.person) as m1

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
where tb_id = 31)v
group by tb_id
