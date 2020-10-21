-- Accuracy
with drug_rawdata as (
select
drug_exposure_id
,sum(cnt) as cnt
from
(select
 cd1.DRUG_EXPOSURE_ID
,cd1.quantity
,cd1.days_supply
,md1.cnt
,md1.day
from
(select
 d1.person_id
,p1.person_source_value
,d1.drug_exposure_start_date
,d1.drug_source_value
,d1.quantity
,d1.DAYS_SUPPLY
,d1.DRUG_EXPOSURE_ID
from
(select
 drug_exposure_id
,person_id
,drug_exposure_start_date
,drug_source_value
,quantity
,DAYS_SUPPLY
  from @cdmSchema.DRUG_EXPOSURE) as d1
inner join
(select person_id, person_source_value from @cdmSchema.person) as p1
on p1.person_id = d1.person_id) as cd1
--
left join
(select distinct
 patno
,ord_cd
,meddate
,orddate
,cnt
,day from @metaSchema.dev_drug
where cancel_yn = 'N') as md1
on cd1.person_source_value = md1.patno
and (cd1.DRUG_EXPOSURE_START_DATE = md1.meddate or cd1.DRUG_EXPOSURE_START_DATE = md1.orddate)
and cd1.DRUG_SOURCE_VALUE = md1.ord_cd collate Korean_Wansung_CI_AS)v
group by DRUG_EXPOSURE_ID)
--
insert into @resultSchema.score_log_CDM
select
 'C277' as check_id
,20 as tb_id
,'drug_exposure' as stratum1
,'quantity' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,DRUG_EXPOSURE_ID as err_no
from
    (select
 d1.DRUG_EXPOSURE_ID
,d1.DAYS_SUPPLY
,d1.QUANTITY
,r1.cnt
,case
    when (r1.cnt*d1.DAYS_SUPPLY) = d1.QUANTITY then 'N'
    else 'Y'
 end as err_gb
from @cdmSchema.drug_exposure as d1
inner join
(select
 drug_exposure_id
,cnt
from drug_rawdata)as r1
on r1.DRUG_EXPOSURE_ID = d1.DRUG_EXPOSURE_ID)v
where err_gb = 'Y'
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum2 as stratum2
,'dev_drug.cnt' as stratum3
,'drug_exposure.days_supply' as stratum4
,'data accuracy check with meta data' as stratum5
,count(*) as count_val
,null as num_val 
,null as txt_val 
from @resultSchema.score_log_CDM
where check_id = 'C277'
group by check_id, tb_id, stratum2;