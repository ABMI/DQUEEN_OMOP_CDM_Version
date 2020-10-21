insert into @resultSchema.score_log_CDM
select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,null as stratum4
,null as stratum5
,err_no 
from
(select
 'C183' as check_id 
,s1.tb_id
,c1.*
from
(select
 'condition_occurrence' as stratum1
,'condition_start_datetime' as stratum2
,'condition_start_date' as stratum3
,condition_start_date as stratum4
,condition_start_datetime as stratum5
,condition_occurrence_id as err_no
from @cdmSchema.condition_occurrence)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C184' as check_id
,s1.tb_id
,c1.*
from
(select
 'condition_occurrence' as stratum1
 ,'condition_end_datetime' as stratum2
 ,'condition_end_date' as stratum3
 ,condition_end_date as stratum4
 ,condition_end_datetime as stratum5
,condition_occurrence_id as err_no
from @cdmSchema.condition_occurrence)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C185' as check_id
,s1.tb_id
,c1.*
from
(select
 'Death' as stratum1
 ,'death_datetime' as stratum2
 ,'death_date' as stratum3
 ,death_date as stratum4
 ,death_datetime as stratum5
,person_id as err_no
from @cdmSchema.death)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C183' as check_id
,s1.tb_id
,c1.*
from
(select
  'device_exposure' as stratum1
 ,'device_exposure_start_datetime' as stratum2
 ,'device_exposure_start_date' as stratum3
 ,device_exposure_start_date as stratum4
 ,device_exposure_start_datetime as stratum5
,device_exposure_id as err_no
from @cdmSchema.device_exposure)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C184' as check_id
,s1.tb_id
,c1.*
from
(select
  'device_exposure' as stratum1
 ,'device_exposure_end_datetime' as stratum2
 ,'device_exposure_end_date' as stratum3
 ,device_exposure_end_date as stratum4
 ,device_exposure_end_datetime as stratum5
,device_exposure_id as err_no
from @cdmSchema.device_exposure)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C183' as check_id
,s1.tb_id
,c1.*
from
(select
  'drug_exposure' as stratum1
 ,'drug_exposure_start_datetime' as stratum2
 ,'drug_exposure_start_date' as stratum3
 ,drug_exposure_start_date as stratum4
 ,drug_exposure_start_datetime as stratum5
,drug_exposure_id as err_no
from @cdmSchema.drug_exposure)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C184' as check_id
,s1.tb_id
,c1.*
from
(select
  'drug_exposure' as stratum1
 ,'drug_exposure_end_datetime' as stratum2
 ,'drug_exposure_end_date' as stratum3
 ,drug_exposure_end_date as stratum4
 ,drug_exposure_end_datetime as stratum5
,drug_exposure_id as err_no
from @cdmSchema.drug_exposure)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C185' as check_id
,s1.tb_id
,c1.*
from
(select
  'measurement' as stratum1
 ,'measurement_datetime' as stratum2
 ,'measurement_date' as stratum3
 ,measurement_date as stratum4
 ,measurement_datetime as stratum5
,measurement_id as err_no
from @cdmSchema.measurement)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C185' as check_id
,s1.tb_id
,c1.*
from
(select
  'note' as stratum1
 ,'note_datetime' as stratum2
 ,'note_date' as stratum3
 ,note_date as stratum4
 ,note_datetime as stratum5
,note_id as err_no
from @cdmSchema.note)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C185' as check_id
,s1.tb_id
,c1.*
from
(select
  'observation' as stratum1
 ,'observation_datetime' as stratum2
 ,'observation_date' as stratum3
 ,observation_date as stratum4
 ,observation_datetime as stratum5
,observation_id as err_no
from @cdmSchema.observation)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C185' as check_id
,s1.tb_id
,c1.*
from
(select
  'procedure_occurrence' as stratum1
 ,'procedure_datetime' as stratum2
 ,'procedure_date' as stratum3
 ,procedure_date as stratum4
 ,procedure_datetime as stratum5
,procedure_occurrence_id as err_no
from @cdmSchema.procedure_occurrence)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C185' as check_id
,s1.tb_id
,c1.*
from
(select
 'specimen' as stratum1
,'specimen_datetime' as stratum2
,'specimen_date' as stratum3
,specimen_date as stratum4
,specimen_datetime as stratum5
,specimen_id as err_no
from @cdmSchema.specimen)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C183' as check_id
,s1.tb_id
,c1.*
from
(select
 'visit_detail' as stratum1
,'visit_detail_start_datetime' as stratum2
,'visit_detail_start_date' as stratum3
,visit_detail_start_date as stratum4
,visit_detail_start_datetime as stratum5
,visit_detail_id as err_no
from @cdmSchema.visit_detail)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C184' as check_id
,s1.tb_id
,c1.*
from
(select
 'visit_detail' as stratum1
,'visit_detail_end_datetime' as stratum2
,'visit_detail_end_date' as stratum3
,visit_detail_end_date as stratum4
,visit_detail_end_datetime as stratum5
,visit_detail_id as err_no
from @cdmSchema.visit_detail)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C183' as check_id
,s1.tb_id
,c1.*
from
(select
 'visit_occurrence' as stratum1
,'visit_detail_start_datetime' as stratum2
,'visit_detail_start_date' as stratum3
,visit_start_date as stratum4
,visit_start_datetime as stratum5
,visit_occurrence_id as err_no
from @cdmSchema.visit_occurrence)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11)
union all
select
 'C184' as check_id
,s1.tb_id
,c1.*
from
(select
 'visit_occurrence' as stratum1
,'visit_detail_end_datetime' as stratum2
,'visit_detail_end_date' as stratum3
,visit_end_date as stratum4
,visit_end_datetime as stratum5
,visit_occurrence_id as err_no
from @cdmSchema.visit_occurrence)as c1
inner join
(select distinct tb_id, tbnm  from @resultSchema.schema_info
 where stage_gb ='CDM') as s1
on c1.stratum1 = s1.tbnm
where substring(convert(varchar,c1.stratum4,121),0,11) <> substring(convert(varchar,c1.stratum5,121),0,11))v
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,stratum3 as stratum4
,case
	when check_id = 'C183' then 'check the diffrent date (start_date <> start_datetime)'
	when check_id = 'C184' then 'check the diffrent date (end_date <> end_datetime)'
	when check_id = 'C185' then 'check the diffrent date (date <> datetime)'
	else null
 end as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,count(*) as count_val
from @resultSchema.score_log_CDM
where check_id in ('C183','C184','C185')
group by check_id,tb_id,stratum1,stratum2,stratum3)v
