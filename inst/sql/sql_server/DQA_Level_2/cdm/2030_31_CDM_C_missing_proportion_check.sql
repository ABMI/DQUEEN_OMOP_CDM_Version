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
 'C30' as check_id
,c1.stratum1
,c1.stratum2
,c1.stratum3
,null as stratum4
,'check the missing value of condition date and datetime' as stratum5
,c1.count_val
,null as num_val
,null as txt_val
from
(select
 tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id = 'C14' and stratum1 = 'condition_occurrence'
and stratum2 in ('condition_start_datetime','condition_end_date','condition_end_datetime')
group by tb_id, stratum1, stratum2) as c1
inner join
 (select tb_id, tbnm, colnm from @resultSchema.schema_info
  where stage_gb= 'CDM' and tbnm = 'condition_occurrence' and(check_gb= 'Y' and is_nullable = 'Yes')) as s1
on c1.stratum1 = s1.tb_id and c1.stratum3 = s1.colnm ;
--
insert into @resultSchema.dq_check_result
select
 'C31' as check_id
,c1.stratum1
,c1.stratum2
,c1.stratum3
,null as stratum4
,'check the missing value of condition_occurrence' as stratum5
,c1.count_val
,null as num_val
,null as txt_val
from
(select
 tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id = 'C14' and stratum1 = 'condition_occurrence'
and stratum2 in ('stop_reason','provider_id','visit_occurrence_id','visit_detail_id')
group by tb_id, stratum1, stratum2) as c1
inner join
 (select tb_id, tbnm, colnm from @resultSchema.schema_info
  where stage_gb= 'CDM' and tbnm = 'condition_occurrence' and(check_gb= 'Y' and is_nullable = 'Yes')) as s1
on c1.stratum1 = s1.tb_id and c1.stratum3 = s1.colnm ;

