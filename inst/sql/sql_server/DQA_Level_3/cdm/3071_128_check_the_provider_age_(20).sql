--> 2017:: ETL end date
insert into @resultSchema.score_log_cdm
select
 'C128' as check_id
,s1.tb_id as tb_id
,p1.stratum1
,p1.stratum2
,p1.stratum3
,p1.stratum4
,p1.stratum5
,p1.err_no
from
(select
 'provider' as stratum1
,'year_of_birth' as stratum2
,year_of_birth as stratum3
,diff_year as stratum4
,null as stratum5
,provider_id as err_no
from
(select
 provider_id
,year_of_birth
,2017-cast(year_of_birth as int) as diff_year
from @cdmSchema.provider)v
where diff_year < 20 ) as p1
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
,'check the implausible age of provider ( < 18)'
,count(*) as count_val
,null as num_val
,null as txt_val
from
@resultSchema.score_log_cdm
where check_id = 'C128'
group by check_id,tb_id,stratum1,stratum2 ;

