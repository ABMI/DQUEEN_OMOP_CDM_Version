insert into @resultSchema.score_log_CDM
select
 'C288' as check_id
,tb_id
,stratum1
,stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 20 as tb_id
,'drug_exposure' as stratum1
,'days_supply' as stratum2
, drug_exposure_id as err_no
,days_supply
from @cdmSchema.drug_exposure
where days_supply = 0)v
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'Days_supply should be not zero' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C288'
group by check_id,tb_id,stratum1,stratum2