with raw_data as (
select
 c1.condition_occurrence_id
,c1.person_id
,v1.visit_occurrence_id
,v1.visit_concept_id
,case
   when condition_start_datetime is null
   or condition_start_datetime = '' then  'Y'
   else 'N'
 end as condition_start_datetime_gb
,case
   when condition_end_datetime is null
   or condition_end_datetime = '' then  'Y'
   else 'N'
 end as condition_end_datetime_gb
,case
   when condition_end_date is null
   or condition_end_date = '' then  'Y'
   else 'N'
 end as condition_end_date_gb
from
(select
 condition_occurrence_id
,person_id
,condition_start_datetime
,condition_end_datetime
,condition_end_date
,condition_concept_id
,visit_occurrence_id
from @cdmSchema.condition_occurrence) as c1
left join
(select
 person_id
,visit_occurrence_id
,visit_concept_id
from @cdmSchema.visit_occurrence) as v1
on c1.person_id = v1.person_id
   and c1.visit_occurrence_id = v1.visit_occurrence_id)
--
insert into @resultSchema.score_log_CDM
select
 'C186' as check_id
,13 as tb_id
,'condition_occurrence' as stratum1
,'condition_end_date' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,condition_occurrence_id as err_no
from raw_data as r1
where condition_end_date_gb = 'Y'
union all
select distinct
 'C187' as check_id
,13 as tb_id
,'condition_occurrence' as stratum1
,'condition_start_datetime' as stratum2
,visit_concept_id as stratum3
,null as stratum4
,null as stratum5
,condition_occurrence_id as err_no
from raw_data
where condition_start_datetime_gb = 'Y'
and visit_concept_id in (9201,9203,262)
union all
select distinct
 'C187' as check_id
,13 as tb_id
,'condition_occurrence' as stratum1
,'condition_start_datetime' as stratum2
,visit_concept_id as stratum3
,null as stratum4
,null as stratum5
,condition_occurrence_id as err_no
from raw_data
where condition_start_datetime_gb = 'Y'
and visit_concept_id in (9201,9203,262)
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,stratum3 as stratum4
,'condition_end_date should not be null' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C186'
group by check_id,tb_id,stratum1,stratum2,stratum3
union all
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,stratum3 as stratum4
,case
   when stratum2 = 'condition_start_datetime' then 'condition_start_datetime should not be null'
   when stratum2 = 'condition_end_datetime' then 'condition_end_datetime should not be null'
   else null
 end as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C187'
group by check_id,tb_id,stratum1,stratum2,stratum3
