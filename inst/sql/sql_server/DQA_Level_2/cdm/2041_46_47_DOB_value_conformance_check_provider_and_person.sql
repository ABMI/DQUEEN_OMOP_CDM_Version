/*************************************************************************/
--  Assigment: Conformance- value
--  Description: this medical dept could not prescribe the procedure
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  this medical dept could not prescribe the drug
--  Language: MSSQL
--  Target data: cdm
-- /*************************************************************************/
with raw_data as
(select
'provider' as tbnm
,'year_of_birth' as stratum1
,provider_id as err_no
,year_of_birth as year_of_birth
,case
  when len(year_of_birth) > 4 or len(year_of_birth) < 4  then 'Y'
  else 'N'
 end as len_of_year_err_gb
,case
  when isnumeric(year_of_birth) = 0  then 'Y'
  else 'N'
 end as value_set_check
from @cdmSchema.provider
union all
select
 'person' as tbnm
,'year_of_birth' as stratum1
,person_id as err_no
,year_of_birth as year_of_birth
,case
  when len(year_of_birth) > 4 or len(year_of_birth) < 4  then 'Y'
  else 'N'
 end as len_of_year_err_gb
,case
  when isnumeric(year_of_birth) = 0  then 'Y'
  else 'N'
 end as value_set_check
from @cdmSchema.person )
--
insert into @resultSchema.score_log_CDM
select
 'C46' as check_id
,s1.tb_id
,r1.tbnm as stratum1
,r1.stratum1 as stratum2
,case
    when r1.len_of_year_err_gb = 'Y' and r1.value_set_check = 'N' then 'length'
    when r1.len_of_year_err_gb = 'N' and r1.value_set_check = 'Y' then 'value'
    when r1.len_of_year_err_gb = 'Y' and r1.value_set_check = 'Y' then 'length&value'
 else null
  end as stratum3
,null as stratum4
,null as stratum5
,err_no
from raw_data as r1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
    on s1.tbnm = r1.tbnm
where r1.len_of_year_err_gb = 'Y' or r1.value_set_check = 'Y';
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,case
  when stratum3 = 'length' then 'value format check of the year (length)'
  when stratum3 = 'value' then 'value format check of the year (value)'
  when stratum3 = 'length&value' then 'value format check of the year (length&value)'
  else null
   end as stratum5
,count_val 
,null as num_val 
,null as txt_val 
from
(select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id = 'C46'
group by check_id, tb_id, stratum1, stratum2, stratum3)v ;
--
with rawdata as (
select
 'person' as tbnm
,'month_of_birth' as colnm
,person_id as err_no
,month_of_birth
,case
  when len(month_of_birth) > 2 or len(month_of_birth) < 1  then 'Y'
  else 'N'
 end as len_err_gb
,case
  when isnumeric(month_of_birth) = 0  then 'Y'
  else 'N'
 end as value_set_check
from @cdmSchema.person
union all
select
 'person' as tbnm
,'day_of_birth' as colnm
,person_id as err_no
,day_of_birth
,case
  when len(day_of_birth) > 2 or len(day_of_birth) < 1  then 'Y'
  else 'N'
 end as len_err_gb
,case
  when isnumeric(day_of_birth) = 0  then 'Y'
  else 'N'
 end as value_set_check
from @cdmSchema.person)
--
insert into @resultSchema.score_log_CDM
select
 'C46' as check_id
,s1.tb_id
,r1.tbnm as stratum1
,r1.colnm as stratum2
,case
    when r1.len_err_gb = 'Y' and r1.value_set_check = 'N' then 'length'
    when r1.len_err_gb = 'N' and r1.value_set_check = 'Y' then 'value'
    when r1.len_err_gb = 'Y' and r1.value_set_check = 'Y' then 'length&value'
 else null
  end as stratum3
,null as stratum4
,null as stratum5
,err_no
from rawdata as r1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
    on s1.tbnm = r1.tbnm
where r1.len_err_gb = 'Y' or r1.value_set_check = 'Y';
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,case
  when (stratum3 = 'length' and stratum2 = 'month_of_birth') then 'value format check of the month_of_birth (length)'
  when (stratum3 = 'value'and stratum2 = 'month_of_birth') then 'value format check of the month_of_birth (value)'
  when (stratum3 = 'length&value'and stratum2 = 'month_of_birth') then 'value format check of the month_of_birth (length&value)'
  when (stratum3 = 'length'and stratum2 = 'day_of_birth') then 'value format check of the day_of_birth (length)'
  when (stratum3 = 'value'and stratum2 = 'day_of_birth') then 'value format check of the day_of_birth (value)'
  when (stratum3 = 'length&value'and stratum2 = 'day_of_birth') then 'value format check of the day_of_birth (length&value)'
  else null
   end as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id = 'C46' and stratum1 = 'person' and stratum2 in ('month_of_birth','day_of_birth')
group by check_id, tb_id, stratum1, stratum2, stratum3)v
--
insert into @resultSchema.score_log_CDM
select
 'C47' as check_id
,s1.tb_id as tb_id
,p1.tbnm as stratum1
,p1.colnm as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'person' as tbnm
,'month_of_birth' as colnm
,person_id as err_no
from @cdmSchema.person
where month_of_birth > 12 or month_of_birth < 1
union all
select
 'person' as tbnm
,'day_of_birth' as colnm
,person_id as err_no
from @cdmSchema.person
where day_of_birth > 31 or day_of_birth < 1 ) as p1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = p1.tbnm
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,case
  when stratum2 = 'month_of_birth' then 'check the implausible data value: month greater than 12'
  when stratum2 = 'day_of_birth' then 'check the implausible data value: day greater than 31'
  else null
 end as stratum5
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
  where check_id = 'C47'
group by  check_id,tb_id,stratum1,stratum2)v