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
 'C27' as check_id
,stratum1
,'provider' as stratum2
,'provider_id' as stratum3
,'provider_source_value' as stratum4
,'missing value check with source_value' as stratum5
,count_val
,null as num_val
,null as txt_val
from @resultSchema.dq_check_result
where check_id = 'C7' and stratum1= 33 and stratum3 = 9
union all
select
 'C27' as check_id
,33 as stratum1
,'provider' as stratum2
,'specialty_concept_id' as stratum3
,'specialty_source_value' as stratum4
,'missing value check with source_value' as stratum5
,count_val
,null as num_val
,null as txt_val
from @resultSchema.dq_check_result
where check_id = 'C7' and stratum1= 33 and stratum3 = 10
union all
select
 'C27' as check_id
,33 as stratum1
,'provider' as stratum2
,'gender_concept_id' as stratum3
,'gender_source_value' as stratum4
,'missing value check with source_value' as stratum5
,count_val
,null as num_val
,null as txt_val
from @resultSchema.dq_check_result
where check_id = 'C7' and stratum1= 33 and stratum3 = 12

