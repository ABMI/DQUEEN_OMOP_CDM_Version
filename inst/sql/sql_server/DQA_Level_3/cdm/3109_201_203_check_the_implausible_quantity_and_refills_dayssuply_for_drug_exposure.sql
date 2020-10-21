insert into @resultSchema.dq_check_result
select
 'C201' as check_id
,s1.tb_id as stratum1
,d1.tbnm as stratum2
,d1.colnm as stratum3
,null as stratum4
,'implausible days_supply' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
'Drug_exposure' as tbnm
,'days_supply' as colnm
,days_supply
,DRUG_EXPOSURE_ID
from @cdmSchema.DRUG_EXPOSURE
where days_supply > 214) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.tbnm
group by s1.tb_id,d1.tbnm,d1.colnm
--
insert into @resultSchema.dq_check_result
select
 'C202' as check_id
,s1.tb_id as stratum1
,d1.tbnm as stratum2
,d1.colnm as stratum3
,null as stratum4
,'Too high number of refils' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
'Drug_exposure' as tbnm
,'REFILLS' as colnm
,REFILLS
,DRUG_EXPOSURE_ID
from @cdmSchema.DRUG_EXPOSURE
where REFILLS > 10) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.tbnm
group by s1.tb_id,d1.tbnm,d1.colnm
--
insert into @resultSchema.dq_check_result
select
 'C203' as check_id
,s1.tb_id as stratum1
,d1.tbnm as stratum2
,d1.colnm as stratum3
,null as stratum4
,'implausible quantity for drug' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
'Drug_exposure' as tbnm
,'QUANTITY' as colnm
,QUANTITY
,DRUG_EXPOSURE_ID
from @cdmSchema.DRUG_EXPOSURE
where QUANTITY > 600) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.tbnm
group by s1.tb_id,d1.tbnm,d1.colnm
