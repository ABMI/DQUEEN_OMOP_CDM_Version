--> Atemporal
insert into @resultSchema.score_log_CDM
select
 'C267' as check_id
,20 as tb_id
,'drug_exposure' as stratum1
,'provider_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,drug_exposure_id as err_no
from
(select
 d1.DRUG_EXPOSURE_ID
,d1.provider_id
from
(select
 drug_exposure_id
,provider_id
from @cdmSchema.DRUG_EXPOSURE) as d1
left join
(select
 provider_id
,specialty_concept_id
from @cdmSchema.provider
where specialty_concept_id in (4010577,4010474)) as p1
on p1.provider_id = d1.provider_id
where d1.provider_id is null)v
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'check the other supplier at durg_exposrue table' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C267'
group by check_id,tb_id,stratum1,stratum2 ;
