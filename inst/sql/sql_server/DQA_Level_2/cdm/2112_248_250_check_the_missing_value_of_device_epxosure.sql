--
insert into @resultSchema.dq_check_result
select
 'C248' as check_id
,d1.tb_id as stratum1
,d1.stratum1 as stratum2
,d1.stratum2 as stratum3
,null as stratum4
,'check the missing value of device_exposure date and datetime' as stratum5
,d1.count_val
,null as num_val
,null as txt_val
from
(select
 tb_id
,stratum1
,stratum2
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id = 'C14' and stratum1 = 'device_exposure'
and stratum2 in ('device_exposure_start_datetime'
,'device_exposure_end_date'
,'device_exposure_end_datetime')
group by tb_id,stratum1,stratum2) as d1
inner join
(select tb_id, tbnm, colnm from @resultSchema.schema_info
where stage_gb= 'CDM' and tb_id = 16 and (check_gb = 'Y' and is_nullable = 'Yes')) as s1
on s1.tb_id = d1.tb_id and s1.colnm = d1.stratum2 ;
--
insert into @resultSchema.dq_check_result
select
 'C249' as check_id
,d1.tb_id as stratum1
,d1.stratum1 as stratum2
,d1.stratum2 as stratum3
,null as stratum4
,'check the missing value of related device_exposure element ' as stratum5
,d1.count_val
,null as num_val
,null as txt_val
from
(select
 tb_id
,stratum1
,stratum2
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id = 'C14' and stratum1 = 'device_exposure'
and stratum2 = 'quantity'
group by tb_id,stratum1,stratum2) as d1
inner join
(select tb_id, tbnm, colnm from @resultSchema.schema_info
where stage_gb= 'CDM' and tb_id = 16 and (check_gb = 'Y' and is_nullable = 'Yes')) as s1
on s1.tb_id = d1.tb_id and s1.colnm = d1.stratum2 ;
--
insert into @resultSchema.dq_check_result
select
 'C250' as check_id
,d1.tb_id as stratum1
,d1.stratum1 as stratum2
,d1.stratum2 as stratum3
,null as stratum4
,'check the missing value of provider and visit at device_exposure' as stratum5
,d1.count_val
,null as num_val
,null as txt_val
from
(select
 tb_id
,stratum1
,stratum2
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id = 'C14' and stratum1 = 'device_exposure'
and stratum2 in ('provider_id','visit_occurrence_id','visit_detail_id')
group by tb_id,stratum1,stratum2) as d1
inner join
(select tb_id, tbnm, colnm from @resultSchema.schema_info
where stage_gb= 'CDM' and tb_id = 16 and (check_gb = 'Y' and is_nullable = 'Yes')) as s1
on s1.tb_id = d1.tb_id and s1.colnm = d1.stratum2 ;
--
