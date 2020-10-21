with rawdata as(
select
 p1.person_id
,case
   when d1.death_date is not null and p1.birth_datetime > d1.death_date then 'birth_datetime > death_date'
   else null
 end as btdt_death_dt_check
,case
   when p1.birth_datetime < '1850' then '< 1850'
   else null
 end as birth_dt_check
from
(select
 person_id
,birth_datetime
from @cdmSchema.person) as p1
left join
( select * from
(select
 row_number()over(partition by person_id, death_date order by person_id) as seq
,person_id
,death_date
from @cdmSchema.death)v
where seq = 1) as d1
on p1.person_id = d1.person_id)
--
insert into @resultSchema.score_log_cdm
select
 case
   when p1.stratum4 = 'birth_datetime > death_date' then 'C126'
   when p1.stratum4 = '< 1850' then 'C127'
   else null
 end as check_id
,s1.tb_id
,p1.stratum1
,p1.stratum2
,p1.stratum3
,p1.stratum4
,null as stratum5
,p1.err_no
from
(select
 'person' as stratum1
,'birth_datetime' as stratum2
,'death.death_date' as stratum3
,btdt_death_dt_check as stratum4
,person_id as err_no
from rawdata
where btdt_death_dt_check is not null
union all
select
 'person' as stratum1
,'birth_datetime' as stratum2
,'< 1850' as stratum3
, birth_dt_check as stratum4
,person_id as err_no
from rawdata
where birth_dt_check is not null) as p1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
  on s1.tbnm = p1.stratum1
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,stratum4 as stratum4
,case
   when check_id = 'C126' then 'birth date greater than death date'
   when check_id = 'C127' then 'birth date is too past ( < 1850)'
   else null
 end as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_meta
where check_id in ('C126','C127')
group by  check_id
,tb_id,stratum1,stratum2,stratum4;