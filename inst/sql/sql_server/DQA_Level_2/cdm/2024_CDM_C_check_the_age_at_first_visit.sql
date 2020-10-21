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
 'C24' as check_id
,31 as stratum1
,'person.year_of_birth' as stratum2
,'min(visit_occurrence,visit_start_date)' as stratum3
,age as stratum4
,'Age at first visit' as stratum5
,count(*) as count_val
,null as num_val
,'Y' as txt_val
from
(select
 p1.person_id
,p1.year_of_birth
,v1.min_dt
,(cast(v1.min_dt as int) - cast(p1.year_of_birth as int)) as age
from
(select
 person_id
,year_of_birth
 from @cdmSchema.person
 ) as p1
inner join
(select
  person_id,
  substring(cast(min(visit_start_date) as varchar),1,4) as min_dt
from @cdmSchema.visit_occurrence
group by person_id) as v1
on p1.person_id = v1.person_id)v
group by age
order by age ;


