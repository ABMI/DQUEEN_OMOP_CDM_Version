insert into @resultSchema.score_log_CDM
select
 case
   when stratum1 = 'device_exposure' then 'C283'
   when stratum1 =  'drug_exposure' then 'C284'
   when stratum1 =  'procedure_occurrence' then 'C285'
   when stratum1 =  'specimen' then 'C286'
   else null
 end as check_id
,tb_id
,stratum1
,stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 16 as tb_id
,'device_exposure' as stratum1
,'quantity' as stratum2
,device_exposure_id as err_no
,quantity
from @cdmSchema.device_exposure
union all
select
 20 as tb_id
,'drug_exposure' as stratum1
,'quantity' as stratum2
, drug_exposure_id as err_no
,quantity
from @cdmSchema.drug_exposure
union all
select
 32 as tb_id
,'procedure_occurrence' as stratum1
,'quantity' as stratum2
, procedure_occurrence_id as err_no
,quantity
from @cdmSchema.procedure_occurrence
union all
select
  36 as tb_id
,'specimen' as stratum1
,'quantity' as stratum2
,specimen_id as err_no
,quantity
from @cdmSchema.specimen)v
where quantity < 1
--
insert into @resultSchema.dq_check_result
select
 check_id
,stratum1
,stratum2
,stratum3
,null as stratum4
,'quantity should be negative' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
from @resultSchema.score_log_CDM
where check_id in ('C283','C284','C285','C286'))v
group by  check_id,stratum1,stratum2,stratum3