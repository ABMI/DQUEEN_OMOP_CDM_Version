--
insert into @resultSchema.dq_check_result
select
 'C261' as check_id
,d1.tb_id as stratum1
,d1.stratum1 as stratum2
,d1.stratum2 as stratum3
,null as stratum4
,'check the missing value of specimen_datetime' as stratum5
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
where check_id = 'C14' and stratum1 = 'specimen'
and stratum2 = 'specimen_datetime'
group by tb_id,stratum1,stratum2) as d1
inner join
(select tb_id, tbnm, colnm from @resultSchema.schema_info
where stage_gb= 'CDM' and tb_id = 36 and (check_gb = 'Y' and is_nullable = 'Yes')) as s1
on s1.tb_id = d1.tb_id and s1.colnm = d1.stratum2 ;
--
insert into @resultSchema.dq_check_result
select
 'C262' as check_id
,d1.tb_id as stratum1
,d1.stratum1 as stratum2
,d1.stratum2 as stratum3
,null as stratum4
,'check the missing value of specimen element' as stratum5
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
where check_id = 'C14' and stratum1 = 'specimen'
and stratum2 in ('quantity','unit_concept_id','anatomic_site_concept_id','disease_status_concept_id')
group by tb_id,stratum1,stratum2) as d1
inner join
(select tb_id, tbnm, colnm from @resultSchema.schema_info
where stage_gb= 'CDM' and tb_id = 36 and (check_gb = 'Y' and is_nullable = 'Yes')) as s1
on s1.tb_id = d1.tb_id and s1.colnm = d1.stratum2
