-- AP
insert into @resultSchema.dq_check_result
select
 'C281' as check_id
,tb_id as stratum1
,tbnm as stratum2
,table_record as stratum3
,null as strautm4
,'This table rocord count lower than person record count' as stratum5
,table_record as count_val
,null as num_val
,null as txt_val
from
(select
c1.tb_id
,c1.tbnm
,c1.total_rows as table_record
,p1.total_rows as person_record
,case
    when c1.total_rows > p1.total_rows then 'N'
    else 'Y'
  end as err_gb
from
(select
 tb_id
,tbnm
,total_rows
,stage_gb
from @resultSchema.schema_capacity
where stage_gb= 'CDM'
and tb_id in (10,12,13,14,16,18,19,20,21,24,26,27,28
,29,30,31,32,33,36,37,38)
) as c1
inner join
(select
 tb_id
,tbnm
,total_rows
,stage_gb
from @resultSchema.schema_capacity
where stage_gb= 'CDM' and tbnm = 'person') as p1
on p1.stage_gb = c1.stage_gb)v
where err_gb= 'Y'