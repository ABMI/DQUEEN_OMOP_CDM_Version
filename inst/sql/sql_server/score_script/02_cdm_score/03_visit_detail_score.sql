IF OBJECT_ID('tempdb..#score_visit_detail_main','U') is not null drop table #score_visit_detail_main 
IF OBJECT_ID('tempdb..#vd_Completeness_gb','U') is not null drop table #vd_Completeness_gb 
IF OBJECT_ID('tempdb..#vd_Conformance_value_gb','U') is not null drop table #vd_Conformance_value_gb 
IF OBJECT_ID('tempdb..#vd_Conformance_relation_gb','U') is not null drop table #vd_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#vd_Uniqueness_gb','U') is not null drop table #vd_Uniqueness_gb 
IF OBJECT_ID('tempdb..#vd_Plausibility_atemporal_gb','U') is not null drop table #vd_Plausibility_atemporal_gb 
IF OBJECT_ID('tempdb..#vd_Accuracy_gb','U') is not null drop table #vd_Accuracy_gb 
IF OBJECT_ID('tempdb..#score_visit_detail_fn','U') is not null drop table #score_visit_detail_fn 
IF OBJECT_ID('tempdb..#visit_detail_score_step1','U') is not null drop table #visit_detail_score_step1 
IF OBJECT_ID('tempdb..#visit_detail_score_step2','U') is not null drop table #visit_detail_score_step2 
IF OBJECT_ID('tempdb..#visit_detail_score_step3','U') is not null drop table #visit_detail_score_step3 

-- Table score calculation (Drug)
--> 1. order by the table error uniq_number
--> DQ concept of uniq stratum2 null
--------------------------------------------------------------------------
select
distinct
 tb_id
,stratum2
,err_no as uniq_no
into #score_visit_detail_main
from @resultSchema.score_log_CDM
where tb_id = 37;
--------------------------------------------------------------------------
--> 2. Table error info
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
into #vd_Completeness_gb
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
where sm1.tb_id =37)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #vd_Conformance_value_gb
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
where sm1.tb_id =37)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #vd_Conformance_relation_gb
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
where sm1.tb_id =37)v
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
into #vd_Uniqueness_gb
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
where sm1.tb_id =37)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #vd_Plausibility_atemporal_gb
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
where sm1.tb_id =37)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #vd_Accuracy_gb
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
where sm1.tb_id =37)v
--------------------------------------------------------------------------
--> 3. Lable DQ concept score
--------------------------------------------------------------------------
select
    *
into #score_visit_detail_fn
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
from #score_visit_detail_main) as m1
left join
(select
 stratum2
,err_no
 from #vd_Completeness_gb) as cp1
on m1.stratum2 = cp1.stratum2
  and m1.uniq_no = cp1.err_no
left join
(select
 stratum2
,err_no
 from #vd_Conformance_value_gb) as cv1
on m1.stratum2 = cv1.stratum2
  and m1.uniq_no = cv1.err_no
left join
(select
 stratum2
,err_no
 from #vd_Conformance_relation_gb) as cr1
on m1.stratum2 = cr1.stratum2
  and m1.uniq_no = cr1.err_no
left join
(select
 stratum2
,err_no
 from #vd_Plausibility_atemporal_gb) as pa1
on m1.stratum2 = pa1.stratum2
  and m1.uniq_no = pa1.err_no
left join
(select
 stratum2
,err_no
 from #vd_Uniqueness_gb) as u1
on m1.uniq_no = u1.err_no
left join
(select
 stratum2
,err_no
 from #vd_Accuracy_gb) as a1
on m1.stratum2 = a1.stratum2
  and m1.uniq_no = a1.err_no)v ;
--------------------------------------------------------------------------
--> 4. table uniq_no 
--------------------------------------------------------------------------
select
visit_detail_id
into #visit_detail_score_step1
from  @cdmSchema.visit_detail;
--------------------------------------------------------------------------
--> 5. table score
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 s1.visit_detail_id as uniq_no
,case
  when stratum2 = 'visit_detail_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_id
,case
  when stratum2 = 'person_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as person_id
,case
  when stratum2 = 'visit_detail_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_concept_id
,case
  when stratum2 = 'visit_detail_start_date' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_start_date
,case
  when stratum2 = 'visit_detail_start_datetime' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_start_datetime
,case
  when stratum2 = 'visit_detail_end_date' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_end_date
,case
  when stratum2 = 'visit_detail_end_datetime' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_end_datetime
,case
  when stratum2 = 'visit_detail_type_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_type_concept_id
,case
  when stratum2 = 'provider_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as provider_id
,case
  when stratum2 = 'care_site_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as care_site_id
,case
  when stratum2 = 'admitting_source_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as admitting_source_concept_id
,case
  when stratum2 = 'discharge_to_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as discharge_to_concept_id
,case
  when stratum2 = 'preceding_visit_detail_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as preceding_visit_detail_id
,case
  when stratum2 = 'visit_detail_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_source_value
,case
  when stratum2 = 'visit_detail_source_concept_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_source_concept_id
,case
  when stratum2 = 'admitting_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as admitting_source_value
,case
  when stratum2 = 'discharge_to_source_value' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as discharge_to_source_value
,case
  when stratum2 = 'visit_detail_parent_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_detail_parent_id
,case
  when stratum2 = 'visit_occurrence_id' then (completeness_gb+conformance_relation_gb+conformance_value_gb+Uniqueness_gb+plausibility_atemporal_gb)
  else 0
 end as visit_occurrence_id
 into #visit_detail_score_step2
from #visit_detail_score_step1  as s1
left join #score_visit_detail_fn as p1
on s1.visit_detail_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 uniq_no
,sum(visit_detail_id) as visit_detail_id
,sum(person_id) as person_id
,sum(visit_detail_concept_id) as visit_detail_concept_id
,sum(visit_detail_start_date) as visit_detail_start_date
,sum(visit_detail_start_datetime) as visit_detail_start_datetime
,sum(visit_detail_end_date) as visit_detail_end_date
,sum(visit_detail_end_datetime) as visit_detail_end_datetime
,sum(visit_detail_type_concept_id) as visit_detail_type_concept_id
,sum(provider_id) as provider_id
,sum(care_site_id) as care_site_id
,sum(admitting_source_concept_id) as admitting_source_concept_id
,sum(discharge_to_concept_id) as discharge_to_concept_id
,sum(preceding_visit_detail_id) as preceding_visit_detail_id
,sum(visit_detail_source_value) as visit_detail_source_value
,sum(visit_detail_source_concept_id) as visit_detail_source_concept_id
,sum(admitting_source_value) as admitting_source_value
,sum(discharge_to_source_value) as discharge_to_source_value
,sum(visit_detail_parent_id) as visit_detail_parent_id
,sum(visit_occurrence_id) as visit_occurrence_id
 into #visit_detail_score_step3
from #visit_detail_score_step2
group by uniq_no
--------------------------------------------------------------------------
--> 7. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
select
 'visit_detail_score' as name
,cast(((
  1.0-((s2.score_person_id/m1.max_uniq_no)*3.0)+
  1.0-((s2.score_visit_detail_concept_id/m1.max_uniq_no)*3.0)+
  1.0-((s2.score_visit_detail_start_date/m1.max_uniq_no)*3.0)+
  1.0-((s2.score_visit_detail_start_datetime/m1.max_uniq_no)*2.0)+
  1.0-((s2.score_visit_detail_end_date/m1.max_uniq_no)*3.0)+
  1.0-((s2.score_visit_detail_end_datetime/m1.max_uniq_no)*2.0)+
  1.0-((s2.score_visit_detail_type_concept_id/m1.max_uniq_no)*3.0)+
  1.0-((s2.score_provider_id/m1.max_uniq_no)*2.0)+
  1.0-((s2.score_care_site_id/m1.max_uniq_no)*2.0)+
  1.0-((s2.score_admitting_source_concept_id/max_uniq_no)*1.0)+
  1.0-((s2.score_discharge_to_concept_id/m1.max_uniq_no)*2.0)+
  1.0-((s2.score_preceding_visit_detail_id/m1.max_uniq_no)*2.0)+
  1.0-((s2.score_visit_detail_source_value/m1.max_uniq_no)*1.0)+
  1.0-((s2.score_visit_detail_source_concept_id/m1.max_uniq_no)*1.0)+
  1.0-((s2.score_admitting_source_value/m1.max_uniq_no)*1.0)+
  1.0-((s2.score_discharge_to_source_value/m1.max_uniq_no)*1.0)+
  1.0-((s2.score_visit_detail_parent_id/m1.max_uniq_no)*2.0)+
  1.0-((s2.score_visit_occurrence_id/m1.max_uniq_no)*3.0))/19) as float)
from
(select
 sum(visit_detail_id) as score_visit_detail_id
,sum(person_id) as score_person_id
,sum(visit_detail_concept_id) as score_visit_detail_concept_id
,sum(visit_detail_start_date) as score_visit_detail_start_date
,sum(visit_detail_start_datetime) as score_visit_detail_start_datetime
,sum(visit_detail_end_date) as score_visit_detail_end_date
,sum(visit_detail_end_datetime) as score_visit_detail_end_datetime
,sum(visit_detail_type_concept_id) as score_visit_detail_type_concept_id
,sum(provider_id) as score_provider_id
,sum(care_site_id) as score_care_site_id
,sum(admitting_source_concept_id) as score_admitting_source_concept_id
,sum(discharge_to_concept_id) as score_discharge_to_concept_id
,sum(preceding_visit_detail_id) as score_preceding_visit_detail_id
,sum(visit_detail_source_value) as score_visit_detail_source_value
,sum(visit_detail_source_concept_id) as score_visit_detail_source_concept_id
,sum(admitting_source_value) as score_admitting_source_value
,sum(discharge_to_source_value) as score_discharge_to_source_value
,sum(visit_detail_parent_id) as score_visit_detail_parent_id
,sum(visit_occurrence_id) as score_visit_occurrence_id
from #visit_detail_score_step3) as s2
cross join
(select count(visit_detail_id) as max_uniq_no from @cdmSchema.visit_detail) as m1
--------------------------------------------------------------------------
-->  select * from @resultSchema.schema_info where tbnm = 'condition_occurrence'
--------------------------------------------------------------------------

select
*
,(cast(count_val as float)/cast(measurement_count as float))
from
(select
sub_category
,stratum1
,stratum2
,count(*) as count_val
,(select count(*) from @cdmSchema.condition_occurrence) as measurement_count
from
(select
 dc1.sub_category
,sm1.tb_id
,sm1.stratum1
,sm1.stratum2
,sm1.err_no
from @resultSchema.score_log_CDM as sm1
inner join
(select distinct
 check_id
,sub_category
from @resultSchema.dq_check) as dc1
on dc1.check_id = sm1.check_id
where sm1.tb_id = 15 )v
group by
sub_category
,stratum1
,stratum2)w
