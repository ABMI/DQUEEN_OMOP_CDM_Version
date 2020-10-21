--
insert into @resultSchema.score_log_CDM
select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,err_no
from
(select
 'C313' as check_id
,16 as tb_id
,'device_exposure' as stratum1
,'device_exposure_start_date' as stratum2
,visit_concept_id as stratum3
,diff_date as stratum4
,null as stratum5
,device_exposure_id as err_no
,case
	when device_exposure_start_date >= visit_start_date or device_exposure_start_date <= visit_end_date then 'N'
	else 'Y'
 end as err_gb
from
(select
 d1.device_exposure_id
,v1.visit_concept_id
,d1.device_exposure_start_date
,d1.device_exposure_end_date
,v1.visit_start_date
,v1.visit_end_date
,d1.diff_date
from
(select
 device_exposure_id
,device_exposure_start_date
,device_exposure_end_date
,visit_occurrence_id
,datediff(day,device_exposure_start_date,device_exposure_end_date)+1 as diff_date
from @cdmSchema.device_exposure) as d1
inner join
(select
 visit_occurrence_id
,visit_concept_id
,visit_start_date
,visit_end_date
from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = d1.visit_occurrence_id)v)w
where err_gb= 'Y'
--
insert into @resultSchema.score_log_CDM
select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,err_no
from
(select
 'C313' as check_id
,16 as tb_id
,'device_exposure' as stratum1
,'device_exposure_end_date' as stratum2
,visit_concept_id as stratum3
,diff_date as stratum4
,null as stratum5
,device_exposure_id as err_no
,case
	when device_exposure_end_date >= visit_start_date or device_exposure_end_date <= visit_end_date then 'N'
	else 'Y'
 end as err_gb
from
(select
 d1.device_exposure_id
,v1.visit_concept_id
,d1.device_exposure_start_date
,d1.device_exposure_end_date
,v1.visit_start_date
,v1.visit_end_date
,d1.diff_date
from
(select
 device_exposure_id
,device_exposure_start_date
,device_exposure_end_date
,visit_occurrence_id
,datediff(day,device_exposure_start_date,device_exposure_end_date)+1 as diff_date
from @cdmSchema.device_exposure) as d1
inner join
(select
 visit_occurrence_id
,visit_concept_id
,visit_start_date
,visit_end_date
from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = d1.visit_occurrence_id)v)w
where err_gb= 'Y'
--
insert into @resultSchema.score_log_CDM
select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,err_no
from
(select
 'C314' as check_id
,32 as tb_id
,'procedure_occurrence' as stratum1
,'procedure_date' as stratum2
,visit_concept_id as stratum3
,null as stratum4
,null as stratum5
,procedure_occurrence_id as err_no
,case
	when procedure_date >= visit_start_date or procedure_date <= visit_end_date then 'N'
	else 'Y'
 end as err_gb
from
(select
 d1.procedure_occurrence_id
,v1.visit_concept_id
,d1.procedure_date
,v1.visit_start_date
,v1.visit_end_date
from
(select
 procedure_occurrence_id
,procedure_date
,procedure_datetime
,visit_occurrence_id
from @cdmSchema.procedure_occurrence) as d1
inner join
(select
 visit_occurrence_id
,visit_concept_id
,visit_start_date
,visit_end_date
from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = d1.visit_occurrence_id)v)w
where err_gb= 'Y'
--
insert into @resultSchema.score_log_CDM
select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,err_no
from
(select
 'C314' as check_id
,32 as tb_id
,'procedure_occurrence' as stratum1
,'procedure_datetime' as stratum2
,visit_concept_id as stratum3
,null as stratum4
,null as stratum5
,procedure_occurrence_id as err_no
,case
	when procedure_datetime >= visit_start_date or procedure_datetime <= visit_end_date then 'N'
	else 'Y'
 end as err_gb
from
(select
 d1.procedure_occurrence_id
,v1.visit_concept_id
,d1.procedure_datetime
,v1.visit_start_date
,v1.visit_end_date
from
(select
 procedure_occurrence_id
,procedure_date
,procedure_datetime
,visit_occurrence_id
from @cdmSchema.procedure_occurrence) as d1
inner join
(select
 visit_occurrence_id
,visit_concept_id
,visit_start_date
,visit_end_date
from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = d1.visit_occurrence_id)v)w
where err_gb= 'Y'
--
insert into @resultSchema.score_log_CDM
select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,err_no
from
(select
 'C315' as check_id
,28 as tb_id
,'observation' as stratum1
,'observation_date' as stratum2
,visit_concept_id as stratum3
,null as stratum4
,null as stratum5
,observation_id as err_no
,case
	when observation_date >= visit_start_date or observation_date <= visit_end_date then 'N'
	else 'Y'
 end as err_gb
from
(select
 d1.observation_id
,d1.observation_date
,v1.visit_concept_id
,v1.visit_start_date
,v1.visit_end_date
from
(select
 observation_id
,observation_date
,observation_datetime
,visit_occurrence_id
from @cdmSchema.observation) as d1
inner join
(select
 visit_occurrence_id
,visit_concept_id
,visit_start_date
,visit_end_date
from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = d1.visit_occurrence_id)v)w
where err_gb= 'Y'
--
insert into @resultSchema.score_log_CDM
select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,err_no
from
(select
 'C315' as check_id
,28 as tb_id
,'observation' as stratum1
,'observation_datetime' as stratum2
,visit_concept_id as stratum3
,null as stratum4
,null as stratum5
,observation_id as err_no
,case
	when observation_datetime >= visit_start_date or observation_datetime <= visit_end_date then 'N'
	else 'Y'
 end as err_gb
from
(select
 d1.observation_id
,d1.observation_datetime
,v1.visit_concept_id
,v1.visit_start_date
,v1.visit_end_date
from
(select
 observation_id
,observation_date
,observation_datetime
,visit_occurrence_id
from @cdmSchema.observation) as d1
inner join
(select
 visit_occurrence_id
,visit_concept_id
,visit_start_date
,visit_end_date
from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = d1.visit_occurrence_id)v)w
where err_gb= 'Y'
--
insert into @resultSchema.score_log_CDM
select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,err_no
from
(select
 'C316' as check_id
,26 as tb_id
,'note' as stratum1
,'note_date' as stratum2
,visit_concept_id as stratum3
,null as stratum4
,null as stratum5
,note_id as err_no
,case
	when note_date >= visit_start_date or note_date <= visit_end_date then 'N'
	else 'Y'
 end as err_gb
from
(select
 d1.note_id
,d1.note_date
,v1.visit_concept_id
,v1.visit_start_date
,v1.visit_end_date
from
(select
 note_id
,note_date
,note_datetime
,visit_occurrence_id
from @cdmSchema.note) as d1
inner join
(select
 visit_occurrence_id
,visit_concept_id
,visit_start_date
,visit_end_date
from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = d1.visit_occurrence_id)v)w
where err_gb= 'Y'
--
insert into @resultSchema.score_log_CDM
select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,err_no
from
(select
 'C316' as check_id
,26 as tb_id
,'note' as stratum1
,'note_datetime' as stratum2
,visit_concept_id as stratum3
,null as stratum4
,null as stratum5
,note_id as err_no
,case
	when cast(note_datetime as date) >= visit_start_date or cast(note_datetime as date) <= visit_end_date then 'N'
	else 'Y'
 end as err_gb
from
(select
 d1.note_id
,d1.note_datetime
,v1.visit_concept_id
,v1.visit_start_date
,v1.visit_end_date
from
(select
 note_id
,note_date
,note_datetime
,visit_occurrence_id
from @cdmSchema.note) as d1
inner join
(select
 visit_occurrence_id
,visit_concept_id
,visit_start_date
,visit_end_date
from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = d1.visit_occurrence_id)v)w
where err_gb= 'Y'
--
insert into @resultSchema.dq_check_result
select
 c1.check_id
,c1.stratum1
,c1.stratum2
,c1.stratum3
,c2.concept_name as stratum4
,case
	when c1.check_id = 'C313' then 'device_exposure_start_date and device_exposure_end_date should be between visit_start_date and visit_end_date'
  when c1.check_id = 'C314' then 'procedure_occurrence_date should be between visit_start_date and visit_end_date'
  when c1.check_id = 'C315' then 'observation_date should be between visit_start_date and visit_end_date'
  when c1.check_id = 'C316' then 'note_date should be between visit_start_date and visit_end_date'
	else null
	end as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,count(*) as count_val
from @resultSchema.score_log_CDM
	where check_id in ('C313','C314','C315','C316')
group by check_id, tb_id, stratum1, stratum2) as c1
inner join
(select concept_id, concept_name from @cdmSchema.concept) as c2
on c1.stratum2 = c2.concept_id
--
