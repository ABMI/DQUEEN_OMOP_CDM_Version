insert into @resultSchema.score_log_CDM
select
 'C189'
,13 as tb_id
,'condition_occurrence' as stratum1
,'provider_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,condition_occurrence_id as err_no
from
(select
 condition_occurrence_id
,provider_id
from @cdmSchema.condition_occurrence
where provider_id is null)v
union all
select
 'C189'
,16 as tb_id
,'device_exposure' as stratum1
,'provider_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,device_exposure_id as err_no
from
(select
 device_exposure_id
,provider_id
from @cdmSchema.device_exposure
where provider_id is null)v
union all
select
 'C189'
,20 as tb_id
,'drug_exposure' as stratum1
,'provider_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,drug_exposure_id as err_no
from
(select
 drug_exposure_id
,provider_id
from @cdmSchema.drug_exposure
where provider_id is null)v
union all
select
 'C189'
,24 as tb_id
,'measurement' as stratum1
,'provider_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,measurement_id as err_no
from
(select
 measurement_id
,provider_id
from @cdmSchema.measurement
where provider_id is null)v
union all
select
 'C189'
,26 as tb_id
,'note' as stratum1
,'provider_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,note_id as err_no
from
(select
 note_id
,provider_id
from @cdmSchema.note
where provider_id is null)v
union all
select
 'C189'
,28 as tb_id
,'observation' as stratum1
,'provider_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,observation_id as err_no
from
(select
 observation_id
,provider_id
from @cdmSchema.observation
where provider_id is null)v
union all
select
 'C189'
,32 as tb_id
,'procedure_occurrence' as stratum1
,'provider_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,procedure_occurrence_id as err_no
from
(select
 procedure_occurrence_id
,provider_id
from @cdmSchema.procedure_occurrence
where provider_id is null)v
union all
select
 'C189'
,37 as tb_id
,'visit_detail' as stratum1
,'provider_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,visit_detail_id as err_no
from
(select
 visit_detail_id
,provider_id
from @cdmSchema.visit_detail
where provider_id is null)v
union all
select
 'C189'
,38 as tb_id
,'visit_occurrence' as stratum1
,'provider_id' as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,visit_occurrence_id as err_no
from
(select
 visit_occurrence_id
,provider_id
from @cdmSchema.visit_occurrence
where provider_id is null)v
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'Provider_id should not be null or missing' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C189'
group by check_id,tb_id,stratum1,stratum2