/*************************************************************************/
--  Assigment: Conformance- value
--  Description: this medical dept could not prescribe the procedure
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  this medical dept could not prescribe the drug
--  Language: MSSQL
--  Target data: cdm
-- /*************************************************************************/
insert into @resultSchema.dq_check_result
select
 'C18' as check_id
,31 as stratum1
,'person' as stratum2
,'person_id' as stratum3
,'observation_period' as stratum4
,'one patients should be have 1 more observation period' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 p1.person_id
,op1.count_val
from
(select
 person_id
from @cdmSchema.person) as p1
left join
(select
   person_id
  ,count(*) as count_val
from  @cdmSchema.observation_period
group by person_id) as op1
on p1.person_id = op1.person_id)v
where count_val is null
--