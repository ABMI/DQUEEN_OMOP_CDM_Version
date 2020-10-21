with raw_data as (
select
 person_id
,year_of_birth
,month_of_birth
,day_of_birth
,birth_datetime
,valid_year_of_birth
,valid_month_of_birth
,valid_day_of_birth
from
(select
 person_id
,year_of_birth
,month_of_birth
,day_of_birth
,birth_datetime
,case
	when year_of_birth = datepart(year,birth_datetime) then 'N'
	else 'YYYY'
 end valid_year_of_birth
,case
	when month_of_birth = datepart(month,birth_datetime) then 'N'
	else 'MM'
 end as valid_month_of_birth
,case
		when day_of_birth = datepart(day,birth_datetime) then 'N'
		else 'DD'
 end as valid_day_of_birth
from
@cdmSchema.person)v
where valid_year_of_birth = 'YYYY' or valid_month_of_birth = 'MM' or valid_day_of_birth = 'DD')
--
insert into @resultSchema.score_log_CDM
select
 'C48' as check_id
,s1.tb_id
,p1.stratum1
,p1.stratum2
,p1.stratum3
,p1.stratum4
,p1.stratum5
,p1.err_no
from
(select
'person' as stratum1
,'year_of_birth' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,person_id as err_no
from raw_data
where valid_year_of_birth = 'YYYY'
union all
select
'person' as stratum1
,'month_of_birth' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,person_id as err_no
from raw_data
where valid_month_of_birth = 'MM'
union all
select
'person' as stratum1
,'dat_of_birth' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,person_id as err_no
from raw_data
where valid_day_of_birth = 'DD') as p1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info where stage_gb= 'CDM') as s1
on s1.tbnm = p1.stratum1
--
insert into @resultSchema.dq_check_result
select
 'C48' as check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'compare with DOB and datetime_of_birth' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
	where check_id = 'C48'
group by tb_id, stratum1,stratum2;