/*************************************************************************/
--  Assigment: Completeness
--  Description: completeness check script for cdm Person
--  Author: Enzo Byun
--  Date:  02.01, 2020
--  Job name: Year & monthly birthdate count
--  Language: MSSQL
--  Target data: Meta
/*************************************************************************/
-- Completeness
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'Missing proportion of year_of_birth' as stratum5
,count_val
,case
   when stratum1 = 'person' then (1.0*(count_val/(select total_rows from @resultSchema.schema_capacity where tbnm = 'person')))
   when stratum1 = 'provider' then (1.0*(count_val/(select total_rows from @resultSchema.schema_capacity where tbnm = 'provider')))
   else null
 end as num_val
,null as txt_val
from
(select
 'C15' as check_id
,tb_id
,stratum1
,stratum2
,count(*) as count_val
 from @resultSchema.score_log_CDM
where check_id='C14'
 and (stratum1 in ('person','Provider')
 and stratum2 = 'year_of_birth')
group by tb_id,stratum1,stratum2)v
--
insert into @resultSchema.dq_check_result
select
 'C16' as check_id
,p1.stratum1
,p1.stratum2
,p1.stratum3
,p1.stratum4
,p1.stratum5
,p1.count_val
,(1.0*(p1.count_val/s1.total_rows)) as num_val
,null as txt_val
from
(select
 'person' as stratum1
,'year_of_birth' as stratum2
,'month_of_birth' as stratum3
,'day_of_birth' as stratum4
,'check the Completeness proportion of Date of Birth' as stratum5
,count(*) as count_val
from @cdmSchema.person
where year_of_birth is null
or month_of_birth is null
or day_of_birth is null
) as p1
inner join
(select tb_id, tbnm, total_rows from @resultSchema.schema_capacity) as s1
on s1.tbnm = p1.stratum1
--