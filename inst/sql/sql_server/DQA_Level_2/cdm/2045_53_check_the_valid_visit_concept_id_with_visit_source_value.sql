insert into @resultSchema.score_log_CDM
select
 'C53' as check_id
,s1.tb_id as tb_id
,stratum1
,stratum2
,stratum3
,stratum4
,null as stratum5
,err_no
from
(select
 'visit_detail' as stratum1
,'visit_detail_concept_id' as stratum2
,'visit_detail_source_value' as stratum3
,visit_detail_concept_id as stratum4
,visit_detail_id as err_no
,case
   when visit_detail_concept_id = '9202' and visit_detail_source_value in ('O','G','M') then 'N'
   when visit_detail_concept_id = '9203' and visit_detail_source_value = 'E' then 'N'
   when visit_detail_concept_id = '9201' and visit_detail_source_value in ('I','D') then 'N'
 else 'Y'
 end as err_gb
from @cdmSchema.visit_detail
union all
select
 'visit_occurrence' as stratum1
,'visit_concept_id' as stratum2
,'visit_source_value' as stratum3
,visit_concept_id as stratum4
,visit_occurrence_id as err_no
,case
   when visit_concept_id = '9202' and visit_source_value in ('O','G','M') then 'N'
   when visit_concept_id = '9203' and visit_source_value = 'E' then 'N'
   when visit_concept_id = '9201' and visit_source_value in ('I','D') then 'N'
   when visit_concept_id = '262' and visit_source_value = 'E/I'  then 'N'
 else 'Y'
 end as err_gb
from @cdmSchema.visit_occurrence)as v1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info where stage_gb= 'CDM') as s1
  on v1.stratum1 = s1.tbnm
where err_gb= 'Y';
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,stratum4  stratum4
,'valid check the visit_concept_id with visit_source_value' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C53'
group by  check_id,tb_id,stratum1,stratum2,stratum4

