--
insert into @resultSchema.dq_check_result
select
 case
   when m1.tb_id = 2 then 'C204'
   when m1.tb_id = 12 then 'C205'
   when m1.tb_id = 13 then 'C206'
   when m1.tb_id = 14 then 'C207'
   when m1.tb_id = 15 then 'C208'
   when m1.tb_id = 16 then 'C209'
   when m1.tb_id = 18 then 'C210'
   when m1.tb_id = 19 then 'C211'
   when m1.tb_id = 20 then 'C212'
   when m1.tb_id = 24 then 'C213'
   when m1.tb_id = 26 then 'C214'
   when m1.tb_id = 28 then 'C215'
   when m1.tb_id = 29 then 'C216'
   when m1.tb_id = 30 then 'C217'
   when m1.tb_id = 31 then 'C218'
   when m1.tb_id = 32 then 'C219'
   when m1.tb_id = 33 then 'C220'
   when m1.tb_id = 36 then 'C221'
   when m1.tb_id = 37 then 'C222'
   when m1.tb_id = 38 then 'C223'
  else null
 end as check_id
,m1.tb_id as stratum1
,s1.tbnm as stratum2
,m1.stratum2 as stratum3
,null as stratum4
,'check the missing value of Required filed' as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 tb_id
,stratum2
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id = 'C14'
group by tb_id, stratum2
)as m1
inner join
(select
 tb_id
,tbnm
,colnm
from @resultSchema.schema_info
where is_nullable = 'No' and stage_gb = 'CDM') as s1
on s1.tb_id = m1.tb_id
and s1.colnm = m1.stratum2;