--> 2017:: ETL end date
insert into @resultSchema.score_log_cdm
select
 'C129' as check_id
,s1.tb_id as tb_id
,p1.stratum1
,p1.stratum2
,p1.stratum3
,p1.stratum4
,p1.stratum5
,p1.err_no
from
(select
 stratum3 as stratum1
,stratum4 as stratum2
,stratum2 as stratum3
,null as stratum4
,null as stratum5
,stratum1 as err_no
from
(select
 provider_id as stratum1
,year_of_birth as stratum2
,'provider' as stratum3
,'year_of_birth' as stratum4
from @cdmSchema.provider
where year_of_birth < 1850
union all
select
 person_id as stratum1
,year_of_birth as stratum2
,'person' as stratum3
,'year_of_birth' as stratum4
from @cdmSchema.person
where year_of_birth < 1850)v
 ) as p1
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
,null as stratum4
,'check the too past year_of_birth of provider ( < 1850)'
,count(*) as count_val
,null as num_val
,null as txt_val
from
@resultSchema.score_log_cdm
where check_id = 'C129'
group by check_id,tb_id,stratum1,stratum2;
