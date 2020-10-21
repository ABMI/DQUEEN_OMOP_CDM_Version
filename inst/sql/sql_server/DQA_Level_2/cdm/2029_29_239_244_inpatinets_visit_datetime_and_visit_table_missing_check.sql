/*************************************************************************/
--  Assigment: Completeness
--  Description: completeness check script for cdm Person
--  Author: Enzo Byun
--  Date:  02.01, 2020
--  Job name: Year & monthly birthdate count
--  Language: MSSQL
--  Target data: Meta
/*************************************************************************/
--
insert into @resultSchema.dq_check_result
select
 'C29' as check_id
,s1.tb_id as stratum1
,v1.stratum2
,v1.stratum3
,v1.stratum4
,case
  when stratum2 = 'visit_start_datetime' then 'missing data check: visit_start_datetime'
  when stratum2 = 'visit_end_datetime' then 'missing data check: visit_end_datetime'
  else null
  end as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 'visit_detail' as stratum2
,'visit_detail_start_datetime' as stratum3
,visit_detail_concept_id as stratum4
,count(*) as count_val
from @cdmSchema.visit_detail
where visit_detail_concept_id in (9203,9201)
and (visit_detail_start_datetime is null or visit_detail_start_datetime = '')
group by visit_detail_concept_id
union all
select
 'visit_detail' as stratum2
,'visit_end_datetime' as stratum3
,visit_detail_concept_id as stratum4
,count(*) as count_val
from @cdmSchema.visit_detail
where visit_detail_concept_id in (9203,9201)
and (visit_detail_end_datetime is null or visit_detail_end_datetime = '')
group by visit_detail_concept_id
union all
select
 'visit_occurrence' as stratum2
,'visit_start_datetime' as stratum3
,visit_concept_id as stratum4
,count(*) as count_val
from @cdmSchema.visit_occurrence
where visit_concept_id in (9203,9201)
and (visit_start_datetime is null or visit_start_datetime = '')
group by visit_concept_id
union all
select
 'visit_occurrence' as stratum2
,'visit_end_datetime' as stratum3
,visit_concept_id as stratum4
,count(*) as count_val
from @cdmSchema.visit_occurrence
where visit_concept_id in (9203,9201)
and (visit_end_datetime is null or visit_end_datetime = '')
group by visit_concept_id) as v1
inner join
(select tb_id, tbnm, colnm from @resultSchema.schema_info) as s1
on s1.tbnm= v1.stratum2 and s1.colnm = v1.stratum3
--
insert into @resultSchema.dq_check_result
select
 case
  when v1.stratum1 = 'visit_detail' and v1.stratum2 in ('visit_detail_start_datetime','visit_detail_end_datetime') then 'C239'
  when v1.stratum1 = 'visit_occurrence'and v1.stratum2 in ('visit_start_datetime','visit_end_datetime')  then 'C240'
  when v1.stratum1 = 'visit_detail' and v1.stratum2 in ('care_site_id','provider_id') then 'C241'
  when v1.stratum1 = 'visit_occurrence' and v1.stratum2 in ('care_site_id','provider_id') then 'C242'
  when v1.stratum1 = 'visit_detail' and v1.stratum2 in ('admitting_source_concept_id','discharge_to_concept_id')  then 'C243'
  when v1.stratum1 = 'visit_occurrence'and v1.stratum2 in ('admitting_source_concept_id','discharge_to_concept_id')  then 'C244'
  else null
 end as check_id
,v1.tb_id as stratum1
,v1.stratum1 as stratum2
,v1.stratum2 as stratum3
,null as stratum4
, case
  when v1.stratum1 = 'visit_detail' and v1.stratum2 in ('visit_detail_start_datetime','visit_detail_end_datetime') then 'Missing value check of the datetime at '+v1.stratum1+' table'
  when v1.stratum1 = 'visit_occurrence'and v1.stratum2 in ('visit_start_datetime','visit_end_datetime')  then 'Missing value check of the datetime at '+v1.stratum1+' table'
  when v1.stratum1 = 'visit_detail' and v1.stratum2 in ('care_site_id','provider_id') then v1.stratum2+' should be not null'
  when v1.stratum1 = 'visit_occurrence' and v1.stratum2 in ('care_site_id','provider_id') then v1.stratum2+' should be not null'
  when v1.stratum1 = 'visit_detail' and v1.stratum2 in ('admitting_source_concept_id','discharge_to_concept_id')  then 'Missing value check of the transfer concept_id at '+v1.stratum1+' table'
  when v1.stratum1 = 'visit_occurrence'and v1.stratum2 in ('admitting_source_concept_id','discharge_to_concept_id')  then 'Missing value check of the transfer concept_id  at '+v1.stratum1+' table'
  else null
 end as stratum5
,v1.count_val
,null as num_val
,null as txt_val
from
(select
 tb_id
,stratum1
,stratum2
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id = 'C14' and stratum1 = 'visit_detail'
group by tb_id,stratum1,stratum2
union all
select
 tb_id
,stratum1
,stratum2
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id = 'C14' and stratum1 = 'visit_occurrence'
group by tb_id,stratum1,stratum2 ) as v1
inner join
(select tb_id,tbnm,colnm from @resultSchema.schema_info
 where stage_gb= 'CDM' and (is_nullable= 'Yes' and check_gb= 'Y')) as s1
on s1.tb_id = v1.tb_id and s1.colnm = v1.stratum2





