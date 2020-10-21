IF OBJECT_ID('tempdb..#D_Completeness_gb','U') is not null drop table #D_Completeness_gb 
IF OBJECT_ID('tempdb..#D_Conformance_value_gb','U') is not null drop table #D_Conformance_value_gb 
IF OBJECT_ID('tempdb..#D_Conformance_relation_gb','U') is not null drop table #D_Conformance_relation_gb 
IF OBJECT_ID('tempdb..#D_Uniqueness_gb','U') is not null drop table #D_Uniqueness_gb 
IF OBJECT_ID('tempdb..#D_Plausibility_atemporal_gb','U') is not null drop table #D_Plausibility_atemporal_gb 
IF OBJECT_ID('tempdb..#D_Accuracy_gb','U') is not null drop table #D_Accuracy_gb 
IF OBJECT_ID('tempdb..#score_drug_exposure_fn_c','U') is not null drop table #score_drug_exposure_fn_c 
IF OBJECT_ID('tempdb..#score_drug_exposure_fn_cv','U') is not null drop table #score_drug_exposure_fn_cv 
IF OBJECT_ID('tempdb..#score_drug_exposure_fn_cr','U') is not null drop table #score_drug_exposure_fn_cr 
IF OBJECT_ID('tempdb..#score_drug_exposure_fn_ap','U') is not null drop table #score_drug_exposure_fn_ap 
IF OBJECT_ID('tempdb..#score_drug_exposure_fn_U','U') is not null drop table #score_drug_exposure_fn_U 
IF OBJECT_ID('tempdb..#score_drug_exposure_fn_A','U') is not null drop table #score_drug_exposure_fn_A 
IF OBJECT_ID('tempdb..#drug_exposure_score_step1','U') is not null drop table #drug_exposure_score_step1 
IF OBJECT_ID('tempdb..#drug_exposure_score_step2_c','U') is not null drop table #drug_exposure_score_step2_c 
IF OBJECT_ID('tempdb..#drug_exposure_score_step2_cv','U') is not null drop table #drug_exposure_score_step2_cv 
IF OBJECT_ID('tempdb..#drug_exposure_score_step2_cr','U') is not null drop table #drug_exposure_score_step2_cr 
IF OBJECT_ID('tempdb..#drug_exposure_score_step2_u','U') is not null drop table #drug_exposure_score_step2_u 
IF OBJECT_ID('tempdb..#score_drug_exposure_fn_u','U') is not null drop table #score_drug_exposure_fn_u 
IF OBJECT_ID('tempdb..#drug_exposure_score_step2_ap','U') is not null drop table #drug_exposure_score_step2_ap 
IF OBJECT_ID('tempdb..#drug_exposure_score_step2_ac','U') is not null drop table #drug_exposure_score_step2_ac 
IF OBJECT_ID('tempdb..#score_drug_exposure_fn_a','U') is not null drop table #score_drug_exposure_fn_a 
IF OBJECT_ID('tempdb..#drug_exposure_score_step3_c','U') is not null drop table #drug_exposure_score_step3_c 
IF OBJECT_ID('tempdb..#drug_exposure_score_step3_cv','U') is not null drop table #drug_exposure_score_step3_cv 
IF OBJECT_ID('tempdb..#drug_exposure_score_step3_cr','U') is not null drop table #drug_exposure_score_step3_cr 
IF OBJECT_ID('tempdb..#drug_exposure_score_step3_u','U') is not null drop table #drug_exposure_score_step3_u 
IF OBJECT_ID('tempdb..#drug_exposure_score_step3_ap','U') is not null drop table #drug_exposure_score_step3_ap 
IF OBJECT_ID('tempdb..#drug_exposure_score_step3_ac','U') is not null drop table #drug_exposure_score_step3_ac 

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
 into #D_Completeness_gb
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
where sm1.tb_id =20)v
--------------------------------------------------------------------------
--> 2. Conformance-value
select
distinct
 sub_category
,stratum2
,err_no
into #D_Conformance_value_gb
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
where sm1.tb_id =20)v
--------------------------------------------------------------------------
--> 3. Conformance-relation
select
distinct
 sub_category
,stratum2
,err_no
into #D_Conformance_relation_gb
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
where sm1.tb_id =20)v
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
into #D_Uniqueness_gb
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
where sm1.tb_id =20)v
--------------------------------------------------------------------------
--> 5. Plausibility-Atemporal
select
distinct
 sub_category
,stratum2
,err_no
into #D_Plausibility_atemporal_gb
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
where sm1.tb_id =20)v
--------------------------------------------------------------------------
--> 6. Accuracy
select
distinct
 sub_category
,stratum2
,err_no
into #D_Accuracy_gb
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
where sm1.tb_id =20)v
--------------------------------------------------------------------------
--> 3. Lable DQ concept score
--------------------------------------------------------------------------
-- 1
select
    *
 into  #score_drug_exposure_fn_c
from
(select
 stratum2
,err_no as uniq_no
,1 completeness_gb
 from #D_Completeness_gb)v

--2
select
    *
into  #score_drug_exposure_fn_cv
from
(select
 stratum2
,err_no as uniq_no
, 1 as conformance_value_gb
 from #D_Conformance_value_gb)v ;
-- 3
select
    *
into  #score_drug_exposure_fn_cr
from
(select
 stratum2
,err_no as uniq_no
,1 as conformance_relation_gb
 from #D_Conformance_relation_gb)v ;
-- 4
select
    *
into  #score_drug_exposure_fn_ap
from
(select
 stratum2
,err_no as uniq_no
, 1 as plausibility_atemporal_gb
 from #D_Plausibility_atemporal_gb)v ;
-- 5
select
    *
into  #score_drug_exposure_fn_U
from
(select
 stratum2
,err_no as uniq_no
,1 as Uniqueness_gb
 from #D_Uniqueness_gb)v ;
-- 6
select
    *
into  #score_drug_exposure_fn_A
from
(
select
 stratum2
,err_no as uniq_no
,1 as Accuracy_gb
 from #D_Accuracy_gb)v ;
--------------------------------------------------------------------------
--> 4. table uniq_no 
--------------------------------------------------------------------------
select
drug_exposure_id
into #drug_exposure_score_step1
from  @cdmSchema.drug_exposure;
--------------------------------------------------------------------------
--> 5. table score
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1. Completeness
select
 s1.drug_exposure_id as uniq_no
,case
  when stratum2 = 'drug_exposure_id' then completeness_gb
  else 0
 end as drug_exposure_id
,case
  when stratum2 = 'person_id' then completeness_gb
  else 0
 end as person_id
,case
  when stratum2 = 'drug_concept_id' then completeness_gb
  else 0
 end as drug_concept_id
,case
  when stratum2 = 'drug_exposure_start_date' then completeness_gb
  else 0
 end as drug_exposure_start_date
,case
  when stratum2 = 'drug_exposure_start_datetime' then completeness_gb
  else 0
 end as drug_exposure_start_datetime
,case
  when stratum2 = 'drug_exposure_end_date' then completeness_gb
  else 0
 end as drug_exposure_end_date
,case
  when stratum2 = 'drug_exposure_end_datetime' then completeness_gb
  else 0
 end as drug_exposure_end_datetime
,case
  when stratum2 = 'verbatim_end_date' then completeness_gb
  else 0
 end as verbatim_end_date
,case
  when stratum2 = 'drug_type_concept_id' then completeness_gb
  else 0
 end as drug_type_concept_id
,case
  when stratum2 = 'stop_reason' then completeness_gb
  else 0
 end as stop_reason
,case
  when stratum2 = 'refills' then completeness_gb
  else 0
 end as refills
,case
  when stratum2 = 'quantity' then completeness_gb
  else 0
 end as quantity
,case
  when stratum2 = 'days_supply' then completeness_gb
  else 0
 end as days_supply
,case
  when stratum2 = 'sig' then completeness_gb
  else 0
 end as sig
,case
  when stratum2 = 'route_concept_id' then completeness_gb
  else 0
 end as route_concept_id
,case
  when stratum2 = 'lot_number' then completeness_gb
  else 0
 end as lot_number
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
  when stratum2 = 'drug_source_value' then completeness_gb
  else 0
 end as drug_source_value
,case
  when stratum2 = 'drug_source_concept_id' then completeness_gb
  else 0
 end as drug_source_concept_id
,case
  when stratum2 = 'route_source_value' then completeness_gb
  else 0
 end as route_source_value
,case
  when stratum2 = 'dose_unit_source_value' then completeness_gb
  else 0
 end as dose_unit_source_value
  into #drug_exposure_score_step2_c
from #drug_exposure_score_step1  as s1
left join
(select stratum2, uniq_no, completeness_gb from #score_drug_exposure_fn_c
where stratum2 is not null )as p1
on s1.drug_exposure_id  = p1.uniq_no
-- 2. Conformance-value
select
 s1.drug_exposure_id as uniq_no
,case
  when stratum2 = 'drug_exposure_id' then conformance_value_gb
  else 0
 end as drug_exposure_id
,case
  when stratum2 = 'person_id' then conformance_value_gb
  else 0
 end as person_id
,case
  when stratum2 = 'drug_concept_id' then conformance_value_gb
  else 0
 end as drug_concept_id
,case
  when stratum2 = 'drug_exposure_start_date' then conformance_value_gb
  else 0
 end as drug_exposure_start_date
,case
  when stratum2 = 'drug_exposure_start_datetime' then conformance_value_gb
  else 0
 end as drug_exposure_start_datetime
,case
  when stratum2 = 'drug_exposure_end_date' then conformance_value_gb
  else 0
 end as drug_exposure_end_date
,case
  when stratum2 = 'drug_exposure_end_datetime' then conformance_value_gb
  else 0
 end as drug_exposure_end_datetime
,case
  when stratum2 = 'verbatim_end_date' then conformance_value_gb
  else 0
 end as verbatim_end_date
,case
  when stratum2 = 'drug_type_concept_id' then conformance_value_gb
  else 0
 end as drug_type_concept_id
,case
  when stratum2 = 'stop_reason' then conformance_value_gb
  else 0
 end as stop_reason
,case
  when stratum2 = 'refills' then conformance_value_gb
  else 0
 end as refills
,case
  when stratum2 = 'quantity' then conformance_value_gb
  else 0
 end as quantity
,case
  when stratum2 = 'days_supply' then conformance_value_gb
  else 0
 end as days_supply
,case
  when stratum2 = 'sig' then conformance_value_gb
  else 0
 end as sig
,case
  when stratum2 = 'route_concept_id' then conformance_value_gb
  else 0
 end as route_concept_id
,case
  when stratum2 = 'lot_number' then conformance_value_gb
  else 0
 end as lot_number
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
  when stratum2 = 'drug_source_value' then conformance_value_gb
  else 0
 end as drug_source_value
,case
  when stratum2 = 'drug_source_concept_id' then conformance_value_gb
  else 0
 end as drug_source_concept_id
,case
  when stratum2 = 'route_source_value' then conformance_value_gb
  else 0
 end as route_source_value
,case
  when stratum2 = 'dose_unit_source_value' then conformance_value_gb
  else 0
 end as dose_unit_source_value
 into #drug_exposure_score_step2_cv
from #drug_exposure_score_step1  as s1
left join
(select stratum2,uniq_no,conformance_value_gb
 from #score_drug_exposure_fn_cv
where stratum2 is not null ) as p1
on s1.drug_exposure_id = p1.uniq_no
-- 3. Conformance-relation
select
 s1.drug_exposure_id as uniq_no
,case
  when stratum2 = 'person_id' then conformance_relation_gb
  else 0
 end as person_id
,case
  when stratum2 = 'drug_concept_id' then conformance_relation_gb
  else 0
 end as drug_concept_id
,case
  when stratum2 = 'drug_type_concept_id' then conformance_relation_gb
  else 0
 end as drug_type_concept_id
,case
  when stratum2 = 'route_concept_id' then conformance_relation_gb
  else 0
 end as route_concept_id
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
  when stratum2 = 'drug_source_concept_id' then conformance_relation_gb
  else 0
 end as drug_source_concept_id
 into #drug_exposure_score_step2_cr
from #drug_exposure_score_step1  as s1
left join
(select stratum2, uniq_no, conformance_relation_gb from #score_drug_exposure_fn_cr
 where stratum2 is not null ) as p1
on s1.drug_exposure_id = p1.uniq_no
-- 4. uniqueness
select
 s1.drug_exposure_id as uniq_no
,case
 when stratum2 = 'drug_exposure_id' then Uniqueness_gb
 when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as drug_exposure_id
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as person_id
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as drug_concept_id
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as drug_exposure_start_date
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as drug_exposure_start_datetime
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as drug_exposure_end_date
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as drug_exposure_end_datetime
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as verbatim_end_date
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as drug_type_concept_id
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as stop_reason
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as refills
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as quantity
,case
  when s1.drug_exposure_id = p1.uniq_no  then 1
  else 0
 end as days_supply
,case
  when s1.drug_exposure_id = p1.uniq_no  then 1
  else 0
 end as sig
,case
  when s1.drug_exposure_id = p1.uniq_no  then 1
  else 0
 end as route_concept_id
,case
  when s1.drug_exposure_id = p1.uniq_no  then 1
  else 0
 end as lot_number
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as provider_id
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as visit_occurrence_id
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as visit_detail_id
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as drug_source_value
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as drug_source_concept_id
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as route_source_value
,case
  when s1.drug_exposure_id = p1.uniq_no then 1
  else 0
 end as dose_unit_source_value
  into #drug_exposure_score_step2_u
from #drug_exposure_score_step1  as s1
left join (select stratum2, uniq_no, uniqueness_gb
from #score_drug_exposure_fn_u where uniqueness_gb= 1) as p1
on s1.drug_exposure_id = p1.uniq_no
-- 5. Atemporal
select
 s1.drug_exposure_id as uniq_no
,case
  when stratum2 = 'drug_exposure_id' then plausibility_atemporal_gb
  else 0
 end as drug_exposure_id
,case
  when stratum2 = 'person_id' then plausibility_atemporal_gb
  else 0
 end as person_id
,case
  when stratum2 = 'drug_concept_id' then plausibility_atemporal_gb
  else 0
 end as drug_concept_id
,case
  when stratum2 = 'drug_exposure_start_date' then plausibility_atemporal_gb
  else 0
 end as drug_exposure_start_date
,case
  when stratum2 = 'drug_exposure_start_datetime' then plausibility_atemporal_gb
  else 0
 end as drug_exposure_start_datetime
,case
  when stratum2 = 'drug_exposure_end_date' then plausibility_atemporal_gb
  else 0
 end as drug_exposure_end_date
,case
  when stratum2 = 'drug_exposure_end_datetime' then plausibility_atemporal_gb
  else 0
 end as drug_exposure_end_datetime
,case
  when stratum2 = 'verbatim_end_date' then plausibility_atemporal_gb
  else 0
 end as verbatim_end_date
,case
  when stratum2 = 'drug_type_concept_id' then plausibility_atemporal_gb
  else 0
 end as drug_type_concept_id
,case
  when stratum2 = 'stop_reason' then plausibility_atemporal_gb
  else 0
 end as stop_reason
,case
  when stratum2 = 'refills' then plausibility_atemporal_gb
  else 0
 end as refills
,case
  when stratum2 = 'quantity' then plausibility_atemporal_gb
  else 0
 end as quantity
,case
  when stratum2 = 'days_supply' then plausibility_atemporal_gb
  else 0
 end as days_supply
,case
  when stratum2 = 'sig' then plausibility_atemporal_gb
  else 0
 end as sig
,case
  when stratum2 = 'route_concept_id' then plausibility_atemporal_gb
  else 0
 end as route_concept_id
,case
  when stratum2 = 'lot_number' then plausibility_atemporal_gb
  else 0
 end as lot_number
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
  when stratum2 = 'drug_source_value' then plausibility_atemporal_gb
  else 0
 end as drug_source_value
,case
  when stratum2 = 'drug_source_concept_id' then plausibility_atemporal_gb
  else 0
 end as drug_source_concept_id
,case
  when stratum2 = 'route_source_value' then plausibility_atemporal_gb
  else 0
 end as route_source_value
,case
  when stratum2 = 'dose_unit_source_value' then plausibility_atemporal_gb
  else 0
 end as dose_unit_source_value
 into #drug_exposure_score_step2_ap
from #drug_exposure_score_step1  as s1
left join
(select stratum2, uniq_no, plausibility_atemporal_gb from #score_drug_exposure_fn_ap
 where stratum2 is not null )  as p1
on s1.drug_exposure_id = p1.uniq_no

-- 6. Accuracy
select
 s1.drug_exposure_id as uniq_no
,case
  when stratum2 = 'drug_exposure_id' then Accuracy_gb
  else 0
 end as drug_exposure_id
,case
  when stratum2 = 'person_id' then Accuracy_gb
  else 0
 end as person_id
,case
  when stratum2 = 'drug_concept_id' then Accuracy_gb
  else 0
 end as drug_concept_id
,case
  when stratum2 = 'drug_exposure_start_date' then Accuracy_gb
  else 0
 end as drug_exposure_start_date
,case
  when stratum2 = 'drug_exposure_start_datetime' then Accuracy_gb
  else 0
 end as drug_exposure_start_datetime
,case
  when stratum2 = 'drug_exposure_end_date' then Accuracy_gb
  else 0
 end as drug_exposure_end_date
,case
  when stratum2 = 'drug_exposure_end_datetime' then Accuracy_gb
  else 0
 end as drug_exposure_end_datetime
,case
  when stratum2 = 'verbatim_end_date' then Accuracy_gb
  else 0
 end as verbatim_end_date
,case
  when stratum2 = 'drug_type_concept_id' then Accuracy_gb
  else 0
 end as drug_type_concept_id
,case
  when stratum2 = 'stop_reason' then Accuracy_gb
  else 0
 end as stop_reason
,case
  when stratum2 = 'refills' then Accuracy_gb
  else 0
 end as refills
,case
  when stratum2 = 'quantity' then Accuracy_gb
  else 0
 end as quantity
,case
  when stratum2 = 'days_supply' then Accuracy_gb
  else 0
 end as days_supply
,case
  when stratum2 = 'sig' then Accuracy_gb
  else 0
 end as sig
,case
  when stratum2 = 'route_concept_id' then Accuracy_gb
  else 0
 end as route_concept_id
,case
  when stratum2 = 'lot_number' then Accuracy_gb
  else 0
 end as lot_number
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
  when stratum2 = 'drug_source_value' then Accuracy_gb
  else 0
 end as drug_source_value
,case
  when stratum2 = 'drug_source_concept_id' then Accuracy_gb
  else 0
 end as drug_source_concept_id
,case
  when stratum2 = 'route_source_value' then Accuracy_gb
  else 0
 end as route_source_value
,case
  when stratum2 = 'dose_unit_source_value' then Accuracy_gb
  else 0
 end as dose_unit_source_value
 into #drug_exposure_score_step2_ac
from #drug_exposure_score_step1  as s1
left join
(select stratum2, uniq_no, Accuracy_gb from #score_drug_exposure_fn_a
 where stratum2 is not null )as p1
on s1.drug_exposure_id = p1.uniq_no
--------------------------------------------------------------------------
--> 6. pre final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1. completeness
select
 sum(drug_exposure_id) as drug_exposure_id
,sum(person_id) as person_id
,sum(drug_concept_id) as drug_concept_id
,sum(drug_exposure_start_date) as drug_exposure_start_date
,sum(drug_exposure_start_datetime) as drug_exposure_start_datetime
,sum(drug_exposure_end_date) as drug_exposure_end_date
,sum(drug_exposure_end_datetime) as drug_exposure_end_datetime
,sum(verbatim_end_date) as verbatim_end_date
,sum(drug_type_concept_id) as drug_type_concept_id
,sum(stop_reason) as stop_reason
,sum(refills) as refills
,sum(quantity) as quantity
,sum(days_supply) as days_supply
,sum(sig) as sig
,sum(route_concept_id) as route_concept_id
,sum(lot_number) as lot_number
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(drug_source_value) as drug_source_value
,sum(drug_source_concept_id) as drug_source_concept_id
,sum(route_source_value) as route_source_value
,sum(dose_unit_source_value) as dose_unit_source_value
   into #drug_exposure_score_step3_c
from #drug_exposure_score_step2_c
-- 2. conformance-value
select
 sum(drug_exposure_id) as drug_exposure_id
,sum(person_id) as person_id
,sum(drug_concept_id) as drug_concept_id
,sum(drug_exposure_start_date) as drug_exposure_start_date
,sum(drug_exposure_start_datetime) as drug_exposure_start_datetime
,sum(drug_exposure_end_date) as drug_exposure_end_date
,sum(drug_exposure_end_datetime) as drug_exposure_end_datetime
,sum(verbatim_end_date) as verbatim_end_date
,sum(drug_type_concept_id) as drug_type_concept_id
,sum(stop_reason) as stop_reason
,sum(refills) as refills
,sum(quantity) as quantity
,sum(days_supply) as days_supply
,sum(sig) as sig
,sum(route_concept_id) as route_concept_id
,sum(lot_number) as lot_number
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(drug_source_value) as drug_source_value
,sum(drug_source_concept_id) as drug_source_concept_id
,sum(route_source_value) as route_source_value
,sum(dose_unit_source_value) as dose_unit_source_value
 into #drug_exposure_score_step3_cv
from #drug_exposure_score_step2_cv
-- 3. Conformance-relation
select
 sum(person_id) as person_id
,sum(drug_concept_id) as drug_concept_id
,sum(drug_type_concept_id) as drug_type_concept_id
,sum(route_concept_id) as route_concept_id
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(drug_source_concept_id) as drug_source_concept_id
into #drug_exposure_score_step3_cr
from #drug_exposure_score_step2_cr

-- 4. uniqueness
select
 sum(drug_exposure_id) as drug_exposure_id
,sum(person_id) as person_id
,sum(drug_concept_id) as drug_concept_id
,sum(drug_exposure_start_date) as drug_exposure_start_date
,sum(drug_exposure_start_datetime) as drug_exposure_start_datetime
,sum(drug_exposure_end_date) as drug_exposure_end_date
,sum(drug_exposure_end_datetime) as drug_exposure_end_datetime
,sum(verbatim_end_date) as verbatim_end_date
,sum(drug_type_concept_id) as drug_type_concept_id
,sum(stop_reason) as stop_reason
,sum(refills) as refills
,sum(quantity) as quantity
,sum(days_supply) as days_supply
,sum(sig) as sig
,sum(route_concept_id) as route_concept_id
,sum(lot_number) as lot_number
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(drug_source_value) as drug_source_value
,sum(drug_source_concept_id) as drug_source_concept_id
,sum(route_source_value) as route_source_value
,sum(dose_unit_source_value) as dose_unit_source_value
 into #drug_exposure_score_step3_u
from #drug_exposure_score_step2_u

-- 5. atemporal
select
 sum(drug_exposure_id) as drug_exposure_id
,sum(person_id) as person_id
,sum(drug_concept_id) as drug_concept_id
,sum(drug_exposure_start_date) as drug_exposure_start_date
,sum(drug_exposure_start_datetime) as drug_exposure_start_datetime
,sum(drug_exposure_end_date) as drug_exposure_end_date
,sum(drug_exposure_end_datetime) as drug_exposure_end_datetime
,sum(verbatim_end_date) as verbatim_end_date
,sum(drug_type_concept_id) as drug_type_concept_id
,sum(stop_reason) as stop_reason
,sum(refills) as refills
,sum(quantity) as quantity
,sum(days_supply) as days_supply
,sum(sig) as sig
,sum(route_concept_id) as route_concept_id
,sum(lot_number) as lot_number
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(drug_source_value) as drug_source_value
,sum(drug_source_concept_id) as drug_source_concept_id
,sum(route_source_value) as route_source_value
,sum(dose_unit_source_value) as dose_unit_source_value
 into #drug_exposure_score_step3_ap
from #drug_exposure_score_step2_ap

-- 6. accuracy
select
 sum(drug_exposure_id) as drug_exposure_id
,sum(person_id) as person_id
,sum(drug_concept_id) as drug_concept_id
,sum(drug_exposure_start_date) as drug_exposure_start_date
,sum(drug_exposure_start_datetime) as drug_exposure_start_datetime
,sum(drug_exposure_end_date) as drug_exposure_end_date
,sum(drug_exposure_end_datetime) as drug_exposure_end_datetime
,sum(verbatim_end_date) as verbatim_end_date
,sum(drug_type_concept_id) as drug_type_concept_id
,sum(stop_reason) as stop_reason
,sum(refills) as refills
,sum(quantity) as quantity
,sum(days_supply) as days_supply
,sum(sig) as sig
,sum(route_concept_id) as route_concept_id
,sum(lot_number) as lot_number
,sum(provider_id) as provider_id
,sum(visit_occurrence_id) as visit_occurrence_id
,sum(visit_detail_id) as visit_detail_id
,sum(drug_source_value) as drug_source_value
,sum(drug_source_concept_id) as drug_source_concept_id
,sum(route_source_value) as route_source_value
,sum(dose_unit_source_value) as dose_unit_source_value
 into #drug_exposure_score_step3_ac
from #drug_exposure_score_step2_ac
--------------------------------------------------------------------------
--> 7. Final Step
--> If required Yes field have a missing value then give a 1.0 weight
--> stratum2 is null and uniq_no is same also DQ concept uniqueness then give a 0.166 weight
--------------------------------------------------------------------------
-- 1. Completeness
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,20 as tb_id
,'Completeness' as cateogy
,'Completeness' as sub_cateogry
, (((s2.socre_drug_exposure_id/m1.max_uniq_no)+
  (s2.socre_person_id/m1.max_uniq_no)+
  (s2.socre_drug_concept_id/m1.max_uniq_no)+
  (s2.socre_drug_exposure_start_date/m1.max_uniq_no)+
  (s2.socre_drug_exposure_start_datetime/m1.max_uniq_no)+
  (s2.socre_drug_exposure_end_date/m1.max_uniq_no)+
  (s2.socre_drug_exposure_end_datetime/m1.max_uniq_no)+
  (s2.socre_verbatim_end_date/m1.max_uniq_no)+
  (s2.socre_drug_type_concept_id/m1.max_uniq_no)+
  (s2.socre_stop_reason/m1.max_uniq_no)+
  (s2.socre_refills/m1.max_uniq_no)+
  (s2.socre_quantity/m1.max_uniq_no)+
  (s2.socre_days_supply/m1.max_uniq_no)+
  (s2.socre_sig/m1.max_uniq_no)+
  (s2.socre_route_concept_id/m1.max_uniq_no)+
  (s2.socre_lot_number/m1.max_uniq_no)+
  (s2.socre_provider_id/m1.max_uniq_no)+
  (s2.socre_visit_occurrence_id/m1.max_uniq_no)+
  (s2.socre_visit_detail_id/m1.max_uniq_no)+
  (s2.socre_drug_source_value/m1.max_uniq_no)+
  (s2.socre_drug_source_concept_id/m1.max_uniq_no)+
  (s2.socre_route_source_value/m1.max_uniq_no)+
  (s2.socre_dose_unit_source_value/m1.max_uniq_no))/23) as err_rate
,cast(1.0-(
  ((s2.socre_drug_exposure_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_person_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_start_date/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_start_datetime/m1.max_uniq_no)*0.05)+
  ((s2.socre_drug_exposure_end_date/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_end_datetime/m1.max_uniq_no)*0.05)+
  ((s2.socre_verbatim_end_date/m1.max_uniq_no)*0.05)+
  ((s2.socre_drug_type_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_stop_reason/m1.max_uniq_no)*0.05)+
  ((s2.socre_refills/m1.max_uniq_no)*0.05)+
  ((s2.socre_quantity/m1.max_uniq_no)*0.05)+
  ((s2.socre_days_supply/m1.max_uniq_no)*0.05)+
  ((s2.socre_sig/m1.max_uniq_no)*0.01)+
  ((s2.socre_route_concept_id/m1.max_uniq_no)*0.05)+
  ((s2.socre_lot_number/m1.max_uniq_no)*0.02)+
  ((s2.socre_provider_id/m1.max_uniq_no)*0.01)+
  ((s2.socre_visit_occurrence_id/m1.max_uniq_no)*0.02)+
  ((s2.socre_visit_detail_id/m1.max_uniq_no)*0.02)+
  ((s2.socre_drug_source_value/m1.max_uniq_no)*0.01)+
  ((s2.socre_drug_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.socre_route_source_value/m1.max_uniq_no)*0.01)+
  ((s2.socre_dose_unit_source_value/m1.max_uniq_no)*0.01))as float) as score
from
(select
 cast(drug_exposure_id as float) as socre_drug_exposure_id
,cast(person_id as float) as socre_person_id
,cast(drug_concept_id as float) as socre_drug_concept_id
,cast(drug_exposure_start_date as float) as socre_drug_exposure_start_date
,cast(drug_exposure_start_datetime as float) as socre_drug_exposure_start_datetime
,cast(drug_exposure_end_date as float) as socre_drug_exposure_end_date
,cast(drug_exposure_end_datetime as float) as socre_drug_exposure_end_datetime
,cast(verbatim_end_date as float) as socre_verbatim_end_date
,cast(drug_type_concept_id as float) as socre_drug_type_concept_id
,cast(stop_reason as float) as socre_stop_reason
,cast(refills as float) as socre_refills
,cast(quantity as float) as socre_quantity
,cast(days_supply as float) as socre_days_supply
,cast(sig as float) as socre_sig
,cast(route_concept_id as float) as socre_route_concept_id
,cast(lot_number as float) as socre_lot_number
,cast(provider_id as float) as socre_provider_id
,cast(visit_occurrence_id as float) as socre_visit_occurrence_id
,cast(visit_detail_id as float) as socre_visit_detail_id
,cast(drug_source_value as float) as socre_drug_source_value
,cast(drug_source_concept_id as float)  as socre_drug_source_concept_id
,cast(route_source_value as float) as socre_route_source_value
,cast(dose_unit_source_value as float) as socre_dose_unit_source_value
from #drug_exposure_score_step3_c) as s2
cross join
(select cast(count(*) as float) as max_uniq_no from @cdmSchema.drug_exposure) as m1
-- 2. conformance-value
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,20 as tb_id
,'conformance' as cateogy
,'Conformance-value' as sub_cateogry
, (((s2.socre_drug_exposure_id/m1.max_uniq_no)+
  (s2.socre_person_id/m1.max_uniq_no)+
  (s2.socre_drug_concept_id/m1.max_uniq_no)+
  (s2.socre_drug_exposure_start_date/m1.max_uniq_no)+
  (s2.socre_drug_exposure_start_datetime/m1.max_uniq_no)+
  (s2.socre_drug_exposure_end_date/m1.max_uniq_no)+
  (s2.socre_drug_exposure_end_datetime/m1.max_uniq_no)+
  (s2.socre_verbatim_end_date/m1.max_uniq_no)+
  (s2.socre_drug_type_concept_id/m1.max_uniq_no)+
  (s2.socre_stop_reason/m1.max_uniq_no)+
  (s2.socre_refills/m1.max_uniq_no)+
  (s2.socre_quantity/m1.max_uniq_no)+
  (s2.socre_days_supply/m1.max_uniq_no)+
  (s2.socre_sig/m1.max_uniq_no)+
  (s2.socre_route_concept_id/m1.max_uniq_no)+
  (s2.socre_lot_number/m1.max_uniq_no)+
  (s2.socre_provider_id/m1.max_uniq_no)+
  (s2.socre_visit_occurrence_id/m1.max_uniq_no)+
  (s2.socre_visit_detail_id/m1.max_uniq_no)+
  (s2.socre_drug_source_value/m1.max_uniq_no)+
  (s2.socre_drug_source_concept_id/m1.max_uniq_no)+
  (s2.socre_route_source_value/m1.max_uniq_no)+
  (s2.socre_dose_unit_source_value/m1.max_uniq_no))/23) as err_rate
,cast(1.0-(
  ((s2.socre_drug_exposure_id/m1.max_uniq_no)*0.05)+
  ((s2.socre_person_id/m1.max_uniq_no)*0.05)+
  ((s2.socre_drug_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_start_date/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.socre_drug_exposure_end_date/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.socre_verbatim_end_date/m1.max_uniq_no)*0.01)+
  ((s2.socre_drug_type_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_stop_reason/m1.max_uniq_no)*0.01)+
  ((s2.socre_refills/m1.max_uniq_no)*0.08)+
  ((s2.socre_quantity/m1.max_uniq_no)*0.08)+
  ((s2.socre_days_supply/m1.max_uniq_no)*0.08)+
  ((s2.socre_sig/m1.max_uniq_no)*0.01)+
  ((s2.socre_route_concept_id/m1.max_uniq_no)*0.07)+
  ((s2.socre_lot_number/m1.max_uniq_no)*0.01)+
  ((s2.socre_provider_id/m1.max_uniq_no)*0.01)+
  ((s2.socre_visit_occurrence_id/m1.max_uniq_no)*0.02)+
  ((s2.socre_visit_detail_id/m1.max_uniq_no)*0.02)+
  ((s2.socre_drug_source_value/m1.max_uniq_no)*0.01)+
  ((s2.socre_drug_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.socre_route_source_value/m1.max_uniq_no)*0.01)+
  ((s2.socre_dose_unit_source_value/m1.max_uniq_no)*0.01))as float) as score
from
(select
 cast(drug_exposure_id as float) as socre_drug_exposure_id
,cast(person_id as float) as socre_person_id
,cast(drug_concept_id as float) as socre_drug_concept_id
,cast(drug_exposure_start_date as float) as socre_drug_exposure_start_date
,cast(drug_exposure_start_datetime as float) as socre_drug_exposure_start_datetime
,cast(drug_exposure_end_date as float) as socre_drug_exposure_end_date
,cast(drug_exposure_end_datetime as float) as socre_drug_exposure_end_datetime
,cast(verbatim_end_date as float) as socre_verbatim_end_date
,cast(drug_type_concept_id as float) as socre_drug_type_concept_id
,cast(stop_reason as float) as socre_stop_reason
,cast(refills as float) as socre_refills
,cast(quantity as float) as socre_quantity
,cast(days_supply as float) as socre_days_supply
,cast(sig as float) as socre_sig
,cast(route_concept_id as float) as socre_route_concept_id
,cast(lot_number as float) as socre_lot_number
,cast(provider_id as float) as socre_provider_id
,cast(visit_occurrence_id as float) as socre_visit_occurrence_id
,cast(visit_detail_id as float) as socre_visit_detail_id
,cast(drug_source_value as float) as socre_drug_source_value
,cast(drug_source_concept_id as float)  as socre_drug_source_concept_id
,cast(route_source_value as float) as socre_route_source_value
,cast(dose_unit_source_value as float) as socre_dose_unit_source_value
from #drug_exposure_score_step3_cv) as s2
cross join
(select count(DRUG_EXPOSURE_ID) as max_uniq_no from @cdmSchema.drug_exposure) as m1
-- 3. Conformance-relation
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,20 as tb_id
,'Conformance' as cateogy
,'Conformance-relation' as sub_cateogry
, (((s2.socre_person_id/m1.max_uniq_no)+
  (s2.socre_drug_concept_id/m1.max_uniq_no)+
  (s2.socre_drug_type_concept_id/m1.max_uniq_no)+
  (s2.socre_route_concept_id/m1.max_uniq_no)+
  (s2.socre_provider_id/m1.max_uniq_no)+
  (s2.socre_visit_occurrence_id/m1.max_uniq_no)+
  (s2.socre_visit_detail_id/m1.max_uniq_no)+
  (s2.socre_drug_source_concept_id/m1.max_uniq_no))/8) as err_rate
,cast(1.0-(
  ((s2.socre_person_id/m1.max_uniq_no)*0.125)+
  ((s2.socre_drug_concept_id/m1.max_uniq_no)*0.125)+
  ((s2.socre_drug_type_concept_id/m1.max_uniq_no)*0.125)+
  ((s2.socre_route_concept_id/m1.max_uniq_no)*0.125)+
  ((s2.socre_provider_id/m1.max_uniq_no)*0.125)+
  ((s2.socre_visit_occurrence_id/m1.max_uniq_no)*0.125)+
  ((s2.socre_visit_detail_id/m1.max_uniq_no)*0.125)+
  ((s2.socre_drug_source_concept_id/m1.max_uniq_no)*0.125))as float) as score
from
(select
 cast(person_id as float) as socre_person_id
,cast(drug_concept_id as float) as socre_drug_concept_id
,cast(drug_type_concept_id as float) as socre_drug_type_concept_id
,cast(route_concept_id as float) as socre_route_concept_id
,cast(provider_id as float) as socre_provider_id
,cast(visit_occurrence_id as float) as socre_visit_occurrence_id
,cast(visit_detail_id as float) as socre_visit_detail_id
,cast(drug_source_concept_id as float)  as socre_drug_source_concept_id
from #drug_exposure_score_step3_cr) as s2
cross join
(select count(DRUG_EXPOSURE_ID) as max_uniq_no from @cdmSchema.drug_exposure) as m1
-- 4. Uniqueness
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,20 as tb_id
,'plausibility' as cateogy
,'plausibility-Uniquness' as sub_cateogry
, (((s2.socre_drug_exposure_id/m1.max_uniq_no)+
  (s2.socre_person_id/m1.max_uniq_no)+
  (s2.socre_drug_concept_id/m1.max_uniq_no)+
  (s2.socre_drug_exposure_start_date/m1.max_uniq_no)+
  (s2.socre_drug_exposure_start_datetime/m1.max_uniq_no)+
  (s2.socre_drug_exposure_end_date/m1.max_uniq_no)+
  (s2.socre_drug_exposure_end_datetime/m1.max_uniq_no)+
  (s2.socre_verbatim_end_date/m1.max_uniq_no)+
  (s2.socre_drug_type_concept_id/m1.max_uniq_no)+
  (s2.socre_stop_reason/m1.max_uniq_no)+
  (s2.socre_refills/m1.max_uniq_no)+
  (s2.socre_quantity/m1.max_uniq_no)+
  (s2.socre_days_supply/m1.max_uniq_no)+
  (s2.socre_sig/m1.max_uniq_no)+
  (s2.socre_route_concept_id/m1.max_uniq_no)+
  (s2.socre_lot_number/m1.max_uniq_no)+
  (s2.socre_provider_id/m1.max_uniq_no)+
  (s2.socre_visit_occurrence_id/m1.max_uniq_no)+
  (s2.socre_visit_detail_id/m1.max_uniq_no)+
  (s2.socre_drug_source_value/m1.max_uniq_no)+
  (s2.socre_drug_source_concept_id/m1.max_uniq_no)+
  (s2.socre_route_source_value/m1.max_uniq_no)+
  (s2.socre_dose_unit_source_value/m1.max_uniq_no))/23) as err_rate
,cast(1.0-(
  ((s2.socre_drug_exposure_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_person_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_start_date/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.socre_drug_exposure_end_date/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.socre_verbatim_end_date/m1.max_uniq_no)*0.01)+
  ((s2.socre_drug_type_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_stop_reason/m1.max_uniq_no)*0.01)+
  ((s2.socre_refills/m1.max_uniq_no)*0.04)+
  ((s2.socre_quantity/m1.max_uniq_no)*0.07)+
  ((s2.socre_days_supply/m1.max_uniq_no)*0.07)+
  ((s2.socre_sig/m1.max_uniq_no)*0.01)+
  ((s2.socre_route_concept_id/m1.max_uniq_no)*0.07)+
  ((s2.socre_lot_number/m1.max_uniq_no)*0.01)+
  ((s2.socre_provider_id/m1.max_uniq_no)*0.01)+
  ((s2.socre_visit_occurrence_id/m1.max_uniq_no)*0.02)+
  ((s2.socre_visit_detail_id/m1.max_uniq_no)*0.02)+
  ((s2.socre_drug_source_value/m1.max_uniq_no)*0.01)+
  ((s2.socre_drug_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.socre_route_source_value/m1.max_uniq_no)*0.01)+
  ((s2.socre_dose_unit_source_value/m1.max_uniq_no)*0.01))as float) as score
from
(select
 cast(drug_exposure_id as float) as socre_drug_exposure_id
,cast(person_id as float) as socre_person_id
,cast(drug_concept_id as float) as socre_drug_concept_id
,cast(drug_exposure_start_date as float) as socre_drug_exposure_start_date
,cast(drug_exposure_start_datetime as float) as socre_drug_exposure_start_datetime
,cast(drug_exposure_end_date as float) as socre_drug_exposure_end_date
,cast(drug_exposure_end_datetime as float) as socre_drug_exposure_end_datetime
,cast(verbatim_end_date as float) as socre_verbatim_end_date
,cast(drug_type_concept_id as float) as socre_drug_type_concept_id
,cast(stop_reason as float) as socre_stop_reason
,cast(refills as float) as socre_refills
,cast(quantity as float) as socre_quantity
,cast(days_supply as float) as socre_days_supply
,cast(sig as float) as socre_sig
,cast(route_concept_id as float) as socre_route_concept_id
,cast(lot_number as float) as socre_lot_number
,cast(provider_id as float) as socre_provider_id
,cast(visit_occurrence_id as float) as socre_visit_occurrence_id
,cast(visit_detail_id as float) as socre_visit_detail_id
,cast(drug_source_value as float) as socre_drug_source_value
,cast(drug_source_concept_id as float)  as socre_drug_source_concept_id
,cast(route_source_value as float) as socre_route_source_value
,cast(dose_unit_source_value as float) as socre_dose_unit_source_value
from #drug_exposure_score_step3_u) as s2
cross join
(select count(*) as max_uniq_no from @cdmSchema.drug_exposure) as m1
-- 5. atemporal
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,20 as tb_id
,'Plausibility' as category
,'plausibility-Atemporal' as sub_category
, (((s2.socre_drug_exposure_id/m1.max_uniq_no)+
  (s2.socre_person_id/m1.max_uniq_no)+
  (s2.socre_drug_concept_id/m1.max_uniq_no)+
  (s2.socre_drug_exposure_start_date/m1.max_uniq_no)+
  (s2.socre_drug_exposure_start_datetime/m1.max_uniq_no)+
  (s2.socre_drug_exposure_end_date/m1.max_uniq_no)+
  (s2.socre_drug_exposure_end_datetime/m1.max_uniq_no)+
  (s2.socre_verbatim_end_date/m1.max_uniq_no)+
  (s2.socre_drug_type_concept_id/m1.max_uniq_no)+
  (s2.socre_stop_reason/m1.max_uniq_no)+
  (s2.socre_refills/m1.max_uniq_no)+
  (s2.socre_quantity/m1.max_uniq_no)+
  (s2.socre_days_supply/m1.max_uniq_no)+
  (s2.socre_sig/m1.max_uniq_no)+
  (s2.socre_route_concept_id/m1.max_uniq_no)+
  (s2.socre_lot_number/m1.max_uniq_no)+
  (s2.socre_provider_id/m1.max_uniq_no)+
  (s2.socre_visit_occurrence_id/m1.max_uniq_no)+
  (s2.socre_visit_detail_id/m1.max_uniq_no)+
  (s2.socre_drug_source_value/m1.max_uniq_no)+
  (s2.socre_drug_source_concept_id/m1.max_uniq_no)+
  (s2.socre_route_source_value/m1.max_uniq_no)+
  (s2.socre_dose_unit_source_value/m1.max_uniq_no))/23) as err_rate
,cast(1.0-(
  ((s2.socre_drug_exposure_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_person_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_start_date/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.socre_drug_exposure_end_date/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.socre_verbatim_end_date/m1.max_uniq_no)*0.01)+
  ((s2.socre_drug_type_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_stop_reason/m1.max_uniq_no)*0.01)+
  ((s2.socre_refills/m1.max_uniq_no)*0.04)+
  ((s2.socre_quantity/m1.max_uniq_no)*0.07)+
  ((s2.socre_days_supply/m1.max_uniq_no)*0.07)+
  ((s2.socre_sig/m1.max_uniq_no)*0.01)+
  ((s2.socre_route_concept_id/m1.max_uniq_no)*0.07)+
  ((s2.socre_lot_number/m1.max_uniq_no)*0.01)+
  ((s2.socre_provider_id/m1.max_uniq_no)*0.01)+
  ((s2.socre_visit_occurrence_id/m1.max_uniq_no)*0.02)+
  ((s2.socre_visit_detail_id/m1.max_uniq_no)*0.02)+
  ((s2.socre_drug_source_value/m1.max_uniq_no)*0.01)+
  ((s2.socre_drug_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.socre_route_source_value/m1.max_uniq_no)*0.01)+
  ((s2.socre_dose_unit_source_value/m1.max_uniq_no)*0.01))as float) as score
from
(select
 cast(drug_exposure_id as float) as socre_drug_exposure_id
,cast(person_id as float) as socre_person_id
,cast(drug_concept_id as float) as socre_drug_concept_id
,cast(drug_exposure_start_date as float) as socre_drug_exposure_start_date
,cast(drug_exposure_start_datetime as float) as socre_drug_exposure_start_datetime
,cast(drug_exposure_end_date as float) as socre_drug_exposure_end_date
,cast(drug_exposure_end_datetime as float) as socre_drug_exposure_end_datetime
,cast(verbatim_end_date as float) as socre_verbatim_end_date
,cast(drug_type_concept_id as float) as socre_drug_type_concept_id
,cast(stop_reason as float) as socre_stop_reason
,cast(refills as float) as socre_refills
,cast(quantity as float) as socre_quantity
,cast(days_supply as float) as socre_days_supply
,cast(sig as float) as socre_sig
,cast(route_concept_id as float) as socre_route_concept_id
,cast(lot_number as float) as socre_lot_number
,cast(provider_id as float) as socre_provider_id
,cast(visit_occurrence_id as float) as socre_visit_occurrence_id
,cast(visit_detail_id as float) as socre_visit_detail_id
,cast(drug_source_value as float) as socre_drug_source_value
,cast(drug_source_concept_id as float)  as socre_drug_source_concept_id
,cast(route_source_value as float) as socre_route_source_value
,cast(dose_unit_source_value as float) as socre_dose_unit_source_value
from #drug_exposure_score_step3_ap) as s2
cross join
(select count(DRUG_EXPOSURE_ID) as max_uniq_no from @cdmSchema.drug_exposure) as m1
-- 6. Accuracy
insert into @resultSchema.score_result
select
'CDM' as stage_gb
,20 as tb_id
,'Accuracy' as category
,'Accuracy' as sub_category
, (((s2.socre_drug_exposure_id/m1.max_uniq_no)+
  (s2.socre_person_id/m1.max_uniq_no)+
  (s2.socre_drug_concept_id/m1.max_uniq_no)+
  (s2.socre_drug_exposure_start_date/m1.max_uniq_no)+
  (s2.socre_drug_exposure_start_datetime/m1.max_uniq_no)+
  (s2.socre_drug_exposure_end_date/m1.max_uniq_no)+
  (s2.socre_drug_exposure_end_datetime/m1.max_uniq_no)+
  (s2.socre_verbatim_end_date/m1.max_uniq_no)+
  (s2.socre_drug_type_concept_id/m1.max_uniq_no)+
  (s2.socre_stop_reason/m1.max_uniq_no)+
  (s2.socre_refills/m1.max_uniq_no)+
  (s2.socre_quantity/m1.max_uniq_no)+
  (s2.socre_days_supply/m1.max_uniq_no)+
  (s2.socre_sig/m1.max_uniq_no)+
  (s2.socre_route_concept_id/m1.max_uniq_no)+
  (s2.socre_lot_number/m1.max_uniq_no)+
  (s2.socre_provider_id/m1.max_uniq_no)+
  (s2.socre_visit_occurrence_id/m1.max_uniq_no)+
  (s2.socre_visit_detail_id/m1.max_uniq_no)+
  (s2.socre_drug_source_value/m1.max_uniq_no)+
  (s2.socre_drug_source_concept_id/m1.max_uniq_no)+
  (s2.socre_route_source_value/m1.max_uniq_no)+
  (s2.socre_dose_unit_source_value/m1.max_uniq_no))/23) as err_rate
,cast(1.0-(
  ((s2.socre_drug_exposure_id/m1.max_uniq_no)*0.05)+
  ((s2.socre_person_id/m1.max_uniq_no)*0.05)+
  ((s2.socre_drug_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_start_date/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_start_datetime/m1.max_uniq_no)*0.07)+
  ((s2.socre_drug_exposure_end_date/m1.max_uniq_no)*0.08)+
  ((s2.socre_drug_exposure_end_datetime/m1.max_uniq_no)*0.07)+
  ((s2.socre_verbatim_end_date/m1.max_uniq_no)*0.01)+
  ((s2.socre_drug_type_concept_id/m1.max_uniq_no)*0.08)+
  ((s2.socre_stop_reason/m1.max_uniq_no)*0.01)+
  ((s2.socre_refills/m1.max_uniq_no)*0.01)+
  ((s2.socre_quantity/m1.max_uniq_no)*0.08)+
  ((s2.socre_days_supply/m1.max_uniq_no)*0.08)+
  ((s2.socre_sig/m1.max_uniq_no)*0.01)+
  ((s2.socre_route_concept_id/m1.max_uniq_no)*0.07)+
  ((s2.socre_lot_number/m1.max_uniq_no)*0.01)+
  ((s2.socre_provider_id/m1.max_uniq_no)*0.01)+
  ((s2.socre_visit_occurrence_id/m1.max_uniq_no)*0.02)+
  ((s2.socre_visit_detail_id/m1.max_uniq_no)*0.02)+
  ((s2.socre_drug_source_value/m1.max_uniq_no)*0.05)+
  ((s2.socre_drug_source_concept_id/m1.max_uniq_no)*0.01)+
  ((s2.socre_route_source_value/m1.max_uniq_no)*0.05)+
  ((s2.socre_dose_unit_source_value/m1.max_uniq_no)*0.01))as float) as score
from
(select
 cast(drug_exposure_id as float) as socre_drug_exposure_id
,cast(person_id as float) as socre_person_id
,cast(drug_concept_id as float) as socre_drug_concept_id
,cast(drug_exposure_start_date as float) as socre_drug_exposure_start_date
,cast(drug_exposure_start_datetime as float) as socre_drug_exposure_start_datetime
,cast(drug_exposure_end_date as float) as socre_drug_exposure_end_date
,cast(drug_exposure_end_datetime as float) as socre_drug_exposure_end_datetime
,cast(verbatim_end_date as float) as socre_verbatim_end_date
,cast(drug_type_concept_id as float) as socre_drug_type_concept_id
,cast(stop_reason as float) as socre_stop_reason
,cast(refills as float) as socre_refills
,cast(quantity as float) as socre_quantity
,cast(days_supply as float) as socre_days_supply
,cast(sig as float) as socre_sig
,cast(route_concept_id as float) as socre_route_concept_id
,cast(lot_number as float) as socre_lot_number
,cast(provider_id as float) as socre_provider_id
,cast(visit_occurrence_id as float) as socre_visit_occurrence_id
,cast(visit_detail_id as float) as socre_visit_detail_id
,cast(drug_source_value as float) as socre_drug_source_value
,cast(drug_source_concept_id as float)  as socre_drug_source_concept_id
,cast(route_source_value as float) as socre_route_source_value
,cast(dose_unit_source_value as float) as socre_dose_unit_source_value
from #drug_exposure_score_step3_ac) as s2
cross join
(select count(*) as max_uniq_no from @cdmSchema.drug_exposure) as m1
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
  when sub_category = 'Conformance-value' then cast(score as float) * 0.13
  when sub_category = 'Conformance-relation' then cast(score as float) * 0.15
  when sub_category = 'plausibility-Uniquness' then cast(score as float) * 0.16
  when sub_category = 'plausibility-Atemporal' then cast(score as float) * 0.19
  when sub_category = 'Accuracy' then cast(score as float) * 0.15
  else null
end as multiply_weight
from @resultSchema.score_result
where tb_id = 20)v
group by tb_id
