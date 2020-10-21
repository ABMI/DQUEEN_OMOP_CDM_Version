/*************************************************************************/
--  Assigment: Plausibility - Atemporal
--  Description: check the negative age
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name: age at first observation period (negative age)
--  Language: MSSQL
--  Target data: dev_person
-->
/*************************************************************************/
--> negative age check
insert into @resultSchema.score_log_CDM
select
 'C90' as check_id
,s1.tb_id
,p1.tbnm as stratum1
,'Btdt' as stratum2
,'dev_period.op_stdt' as stratum3
,p1.diff_day as stratum4
,p1.age as stratum5
,p1.person_id as err_no
from
(select
 'person' as tbnm
,p1.person_id
,p1.birth_datetime
,op1.observation_period_start_date
,datediff(day,p1.birth_datetime,op1.observation_period_start_date) as diff_day
,(datediff(day,p1.birth_datetime,op1.observation_period_start_date)/365)+1 as age
from
(select
 person_id
,birth_datetime
from @cdmSchema.person) as p1
left join
(select person_id,observation_period_start_date from @cdmSchema.observation_period) as op1
on op1.person_id = p1.person_id )as p1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = p1.tbnm
where p1.age < 0
--
insert into @resultSchema.archive_data
select
 tb_id
,id
,stratum1
,stratum2
,stratum3
,num_val
,count(*) as count_val
from
(select
 1 as tb_id
,'C90' as id
,'dev_person.Btdt' as stratum1
,'dev_period.op_stdt' as stratum2
,'age at first observation period' as stratum3
,age as num_val
,null as count_val
from
(select
 p1.person_id
,p1.birth_datetime
,op1.observation_period_start_date
,datediff(day,p1.birth_datetime,op1.observation_period_start_date) as diff_day
,(datediff(day,p1.birth_datetime,op1.observation_period_start_date)/365)+1 as age
from
(select
 person_id
,birth_datetime
from @cdmSchema.person) as p1
left join
(select person_id, observation_period_start_date from @cdmSchema.observation_period) as op1
on op1.person_id = p1.person_id )v)w
group by tb_id,id,stratum1,stratum2,stratum3,num_val
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as startum1
,stratum2
,stratum3
,null as stratum4
,'age at first observation period (negative age)' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C90'
group by check_id, tb_id, stratum2, stratum3 ;
