--
insert into @resultSchema.dq_check_result
select
 'C258' as check_id
,d1.tb_id as stratum1
,d1.stratum1 as stratum2
,d1.stratum2 as stratum3
,null as stratum4
,'check the missing value of procedure_datetime' as stratum5
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
where check_id = 'C14' and stratum1 = 'procedure_occurrence'
and stratum2 = 'procedure_datetime'
group by tb_id,stratum1,stratum2) as d1
inner join
(select tb_id, tbnm, colnm from @resultSchema.schema_info
where stage_gb= 'CDM' and tb_id = 32 and (check_gb = 'Y' and is_nullable = 'Yes')) as s1
on s1.tb_id = d1.tb_id and s1.colnm = d1.stratum2 ;
--
insert into @resultSchema.dq_check_result
select
 'C259' as check_id
,d1.tb_id as stratum1
,d1.stratum1 as stratum2
,d1.stratum2 as stratum3
,null as stratum4
,'check the missing value of procedure element' as stratum5
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
where check_id = 'C14' and stratum1 = 'procedure_occurrence'
and stratum2 in ('modifier_concept_id','quantity')
group by tb_id,stratum1,stratum2) as d1
inner join
(select tb_id, tbnm, colnm from @resultSchema.schema_info
where stage_gb= 'CDM' and tb_id = 32 and (check_gb = 'Y' and is_nullable = 'Yes')) as s1
on s1.tb_id = d1.tb_id and s1.colnm = d1.stratum2 ;
--
insert into @resultSchema.dq_check_result
select
 'C260' as check_id
,d1.tb_id as stratum1
,d1.stratum1 as stratum2
,d1.stratum2 as stratum3
,null as stratum4
,'check the missing value of provider and visit' as stratum5
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
where check_id = 'C14' and stratum1 = 'procedure_occurrence'
and stratum2 in ('provider_id','visit_occurrence_id','visit_detail_id')
group by tb_id,stratum1,stratum2) as d1
inner join
(select tb_id, tbnm, colnm from @resultSchema.schema_info
where stage_gb= 'CDM' and tb_id = 32 and (check_gb = 'Y' and is_nullable = 'Yes')) as s1
on s1.tb_id = d1.tb_id and s1.colnm = d1.stratum2 ;

