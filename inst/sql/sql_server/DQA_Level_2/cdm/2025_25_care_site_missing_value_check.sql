/*************************************************************************/
--  Assigment: Completeness
--  Description: completeness check script for cdm Person
--  Author: Enzo Byun
--  Date:  02.01, 2020
--  Job name: Year & monthly birthdate count
--  Language: MSSQL
--  Target data: Meta
/*************************************************************************/
insert into @resultSchema.dq_check_result
select
 'C25' as check_id
,c1.tb_id as stratum1
,c1.stratum1 as stratum2
,c1.stratum2 as stratum3
,null as stratum4
,'check the missing value of '+stratum2+' at care_site' as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id
,stratum1
,stratum2
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id = 'C14' and stratum1= 'care_site'
group by check_id, tb_id, stratum1, stratum2) as c1
inner join
(select tb_id, tbnm, colnm,is_nullable,check_gb from @resultSchema.schema_info
where stage_gb= 'CDM'and tbnm = 'care_site' and (check_gb= 'Y' and is_nullable = 'Yes')) as s1
on s1.tb_id = c1.tb_id and s1.colnm = c1.stratum2


