--
with raw_data as
(select
 person_id
,month_of_birth
,case
  when month_of_birth > 12 or month_of_birth < 1 then 'Y'
  else 'N'
 end valid_month_of_birth
,day_of_birth
,case
  when day_of_birth > 31
         or day_of_birth < 1 then 'Y'
  else 'N'
 end valid_day_of_birth
from @cdmSchema.person)
insert into @resultSchema.score_log_cdm
select
 'C165' as check_id
,31 as tb_id
,'person' as stratum1
,'month_of_birth' as stratum2
,month_of_birth as stratum3
,null as stratum4
,null as stratum5
,person_id as err_no
from raw_data
where valid_month_of_birth = 'Y'
union all
select
 'C165' as check_id
,31 as tb_id
,'person' as stratum1
,'day_of_birth' as stratum2
,day_of_birth as stratum3
,null as stratum4
,null as stratum5
,person_id as err_no
from raw_data
where valid_day_of_birth = 'Y'
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'check the implausible numerical values in day and month of birth' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C165'
group by check_id, tb_id, stratum1, stratum2;