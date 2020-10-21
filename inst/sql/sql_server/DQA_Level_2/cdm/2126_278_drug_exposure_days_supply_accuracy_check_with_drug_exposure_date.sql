--
insert into @resultSchema.score_log_CDM
select
 'C278' as check_id
,20 as tb_id
,'drug_exposure_id' as stratum1
,'days_supply' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,DRUG_EXPOSURE_ID as err_no
from
(select
 DRUG_EXPOSURE_ID
,diff_day
,DAYS_SUPPLY
,case
   when cast(DAYS_SUPPLY as int) = cast(diff_day as int) then 'N'
   else 'Y'
 end as err_gb
from
(select
 drug_exposure_id
,datediff(day,drug_exposure_start_date,drug_exposure_end_date)+1 as diff_day
,days_supply
from @cdmSchema.DRUG_EXPOSURE)v)w
where err_gb= 'Y'
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum2
,'drug_exposure_start_date' as stratum3
,'drug_exposure_end_date' as stratum4
,'check the Accuracy of days_supply' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C278'
group by check_id, tb_id, stratum2