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
 'C28' as check_id
,33 as stratum1
,'provider' as stratum2
,'year_of_birth' as stratum3
,year_of_birth as stratum4
,'year_of_birth yearly count' as stratum5
,count_val
,null as num_val
,'Y' as txt_val
from
(select
 year_of_birth
,count(*) as count_val
from @cdmSchema.provider
group by year_of_birth)v;

