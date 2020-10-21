--
insert into @resultSchema.score_log_cdm
select
 c1.check_id
,s1.tb_id
,c1.stratum1
,c1.stratum2
,c1.stratum3
,c1.stratum4
,c1.stratum5
,c1.err_no
from
(select
 'C87' as check_id
,'condition_era' as stratum1
,'condition_era_start_date' as stratum2
,'condition_era_start_date > condition_era_end_date' as stratum3
,null as stratum4
,null as stratum5
,condition_era_id as err_no
from
(select
 condition_era_id
,condition_era_start_date
,condition_era_end_date
from
@cdmSchema.condition_era
where condition_era_start_date > condition_era_end_date)v) as c1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = c1.stratum1;
--
with condition_rawdata as(
select
 'condition_occurrence' as stratum1
,condition_occurrence_id
,case
    when condition_start_date > condition_start_datetime then 'condition_start_date > condition_start_datetime'
    when condition_start_date > condition_end_date then 'condition_start_date > condition_end_date'
    when condition_start_date > condition_end_datetime then 'condition_start_date > condition_end_datetime'
    else null
end as condition_start_date_check
,case
 -- when condition_start_datetime > condition_end_date then 'condition_start_datetime > condition_end_date'
    when condition_start_datetime > condition_end_datetime then 'condition_start_datetime > condition_end_datetime'
    else null
end as condition_start_datetime_check
,case
    when condition_end_date > condition_end_datetime then 'condition_end_date > condition_end_datetime'
    else null
end as condition_end_date_check
from
(select
 condition_occurrence_id
,condition_start_date
,condition_start_datetime
,condition_end_date
,condition_end_datetime
from	@cdmSchema.condition_occurrence)v)
--
insert into @resultSchema.score_log_cdm
select
 case
    when c1.stratum2 = 'condition_start_date' then 'C87'
    when c1.stratum2 = 'condition_start_datetime' then 'C88'
    when c1.stratum2 = 'condition_end_date' then 'C89'
    else null
 end as check_id
,s1.tb_id
,c1.stratum1
,c1.stratum2
,c1.stratum3
,null as stratum4
,null as stratum5
,c1.err_no
from
 (select
 stratum1
,'condition_start_date' as stratum2
,condition_occurrence_id as err_no
,condition_start_date_check as stratum3
from condition_rawdata
where condition_start_date_check is not null
union all
select
 stratum1
,'condition_start_datetime' as stratum2
,condition_occurrence_id as err_no
,condition_start_datetime_check as stratum3
from condition_rawdata
where condition_start_datetime_check is not null
union all
select
 stratum1
,'condition_end_date' as stratum2
,condition_occurrence_id as err_no
,condition_end_date_check as stratum3
from condition_rawdata
where condition_end_date_check is not null) as c1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = c1.stratum1;
--
insert into @resultSchema.score_log_cdm
select
 'C87' as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum4
,err_no
from
(select
 'death' as stratum1
,'death_date' as stratum2
,'death_date > death_datetime' as stratum3
,person_id as err_no
from @cdmSchema.death
where death_date > death_datetime) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
with devce_rawdata as (
select
 'device_exposure' as stratum1
,err_no
,case
    when device_exposure_start_date > device_exposure_start_datetime then 'device_exposure_start_date > device_exposure_start_datetime'
    when device_exposure_start_date > device_exposure_end_date then 'device_exposure_start_date > device_exposure_end_date'
    when device_exposure_start_date > device_exposure_end_datetime then 'device_exposure_start_date > device_exposure_end_datetime'
    else null
end as device_exposure_start_date_check
,case
  --  when device_exposure_start_datetime > device_exposure_end_date then 'device_exposure_start_datetime > device_exposure_end_date'
    when device_exposure_start_datetime > device_exposure_end_datetime then 'device_exposure_start_datetime > device_exposure_end_datetime'
    else null
end as device_exposure_start_datetime_check
,case
    when device_exposure_end_date > device_exposure_end_datetime then 'device_exposure_end_date > device_exposure_end_datetime'
    else null
end as device_exposure_end_date_check
from
(select
 device_exposure_id as err_no
,device_exposure_start_date
,device_exposure_start_datetime
,device_exposure_end_date
,device_exposure_end_datetime
from @cdmSchema.device_exposure)v)
--
insert into @resultSchema.score_log_cdm
select
case
  when d1.stratum2 = 'device_exposure_start_date' then 'C87'
  when d1.stratum2 = 'device_exposure_start_datetime' then 'C88'
  when d1.stratum2 = 'device_exposure_end_date' then 'C89'
  else null
 end as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,d1.err_no
from
(select
 stratum1
,'device_exposure_start_date' as stratum2
,device_exposure_start_date_check as stratum3
,err_no
from devce_rawdata
where device_exposure_start_date_check is not null
union all
select
 stratum1
,'device_exposure_start_datetime' as stratum2
,device_exposure_start_datetime_check as stratum3
,err_no
from devce_rawdata
where device_exposure_start_datetime_check is not null
union all
select
 stratum1
,'device_exposure_end_date' as stratum2
,device_exposure_end_date_check as stratum3
,err_no
from devce_rawdata
where device_exposure_end_date_check is not null) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;

--
insert into @resultSchema.score_log_cdm
select
 'C87' as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'dose_era' as stratum1
,'dose_era_start_date' as stratum2
,'dose_era_start_date > dose_era_end_date' as stratum3
,dose_era_id as err_no
from @cdmSchema.dose_era
where dose_era_start_date > dose_era_end_date) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
insert into @resultSchema.score_log_cdm
select
 'C87' as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'dose_era' as stratum1
,'drug_era_start_date' as stratum2
,'drug_era_start_date > drug_era_end_date' as stratum3
,drug_era_id as err_no
from @cdmSchema.drug_era
where drug_era_start_date > drug_era_end_date) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;

--
with drug_rawdata as (
select
 'drug_exposure' as stratum1
,err_no
,case
    when drug_exposure_start_date > drug_exposure_start_datetime then 'drug_exposure_start_date > drug_exposure_start_datetime'
    when drug_exposure_start_date > drug_exposure_end_date then 'drug_exposure_start_date > drug_exposure_end_date'
    when drug_exposure_start_date > drug_exposure_end_datetime then 'drug_exposure_start_date > drug_exposure_end_datetime'
    else null
end as drug_exposure_start_date_check
,case
--    when drug_exposure_start_datetime > drug_exposure_end_date then 'drug_exposure_start_datetime > drug_exposure_end_date'
    when drug_exposure_start_datetime > drug_exposure_end_datetime then 'drug_exposure_start_datetime > drug_exposure_end_datetime'
    else null
end as drug_exposure_start_datetime_check
,case
    when drug_exposure_end_date > drug_exposure_end_datetime then 'drug_exposure_end_date > drug_exposure_end_datetime'
    else null
end as drug_exposure_end_date_check
from
(select
 drug_exposure_id as err_no
,drug_exposure_start_date
,drug_exposure_start_datetime
,drug_exposure_end_date
,drug_exposure_end_datetime
from @cdmSchema.drug_exposure)v)
--
insert into @resultSchema.score_log_cdm
select
case
  when d1.stratum2 = 'drug_exposure_start_date' then 'C87'
  when d1.stratum2 = 'drug_exposure_start_datetime' then 'C88'
  when d1.stratum2 = 'drug_exposure_end_date' then 'C89'
  else null
 end as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,d1.err_no
from
(select
 stratum1
,'drug_exposure_start_date' as stratum2
,drug_exposure_start_date_check as stratum3
,err_no
from drug_rawdata
where drug_exposure_start_date_check is not null
union all
select
 stratum1
,'drug_exposure_start_datetime' as stratum2
,drug_exposure_start_datetime_check as stratum3
,err_no
from drug_rawdata
where drug_exposure_start_datetime_check is not null
union all
select
 stratum1
,'drug_exposure_end_date' as stratum2
,drug_exposure_end_date_check as stratum3
,err_no
from drug_rawdata
where drug_exposure_end_date_check is not null) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
insert into @resultSchema.score_log_cdm
select
 'C87' as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'measurement' as stratum1
,'measurement_date' as stratum2
,'measurement_date > measurement_datetime' as stratum3
,measurement_id as err_no
from @cdmSchema.measurement
where measurement_date > measurement_datetime) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
insert into @resultSchema.score_log_cdm
select
 'C87' as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'note' as stratum1
,'note_date' as stratum2
,'note_date > note_datetime' as stratum3
,note_id as err_no
from @cdmSchema.note
where note_date > note_datetime) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
insert into @resultSchema.score_log_cdm
select
 'C87' as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'note_nlp' as stratum1
,'nlp_date' as stratum2
,'nlp_date > nlp_datetime' as stratum3
,note_id as err_no
from @cdmSchema.note_nlp
where nlp_date > nlp_datetime) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
insert into @resultSchema.score_log_cdm
select
 'C87' as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'observation' as stratum1
,'nlp_date' as stratum2
,'observation_date > observation_datetime' as stratum3
,observation_id as err_no
from @cdmSchema.observation
where observation_date > observation_datetime) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
insert into @resultSchema.score_log_cdm
select
 'C87' as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'observation' as stratum1
,'observation_period_start_date' as stratum2
,'observation_period_start_date > observation_period_end_date' as stratum3
,observation_period_id as err_no
from @cdmSchema.observation_period
where observation_period_start_date > observation_period_end_date) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
insert into @resultSchema.score_log_cdm
select
 'C87' as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'payer_plan_period' as stratum1
,'payer_plan_period_start_date' as stratum2
,'payer_plan_period_start_date > payer_plan_period_end_date' as stratum3
,payer_plan_period_id as err_no
from @cdmSchema.payer_plan_period
where payer_plan_period_start_date > payer_plan_period_end_date) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
insert into @resultSchema.score_log_cdm
select
 'C87' as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'procedure_occurrence' as stratum1
,'procedure_date' as stratum2
,'procedure_date > procedure_datetime' as stratum3
,procedure_occurrence_id as err_no
from @cdmSchema.procedure_occurrence
where procedure_date > procedure_datetime) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
insert into @resultSchema.score_log_cdm
select
 'C87' as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'specimen' as stratum1
,'specimen_date' as stratum2
,'specimen_date > specimen_datetime' as stratum3
,specimen_id as err_no
from @cdmSchema.specimen
where specimen_date > specimen_datetime) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
with visit_detail_rawdata as (
select
 'visit_detail' as stratum1
,err_no
,case
    when visit_detail_start_date > visit_detail_start_datetime then 'visit_detail_start_date > visit_detail_start_datetime'
    when visit_detail_start_date > visit_detail_end_date then 'visit_detail_start_date > visit_detail_end_date'
    when visit_detail_start_date > visit_detail_end_datetime then 'visit_detail_start_date > visit_detail_end_datetime'
    else null
end as visit_detail_start_date_check
,case
--    when visit_start_datetime > visit_end_date then 'visit_detail_start_datetime > visit_detail_end_date'
    when visit_detail_start_datetime > visit_detail_end_datetime then 'visit_detail_start_datetime > visit_detail_end_datetime'
    else null
end as visit_detail_start_datetime_check
,case
    when visit_detail_end_date > visit_detail_end_datetime then 'visit_detail_end_date > visit_detail_end_datetime'
    else null
end as visit_detail_end_date_check
from
(select
 visit_detail_id as err_no
,visit_detail_start_date
,visit_detail_start_datetime
,visit_detail_end_date
,visit_detail_end_datetime
from @cdmSchema.visit_detail)v)
--
insert into @resultSchema.score_log_cdm
select
case
  when d1.stratum2 = 'visit_detail_start_date' then 'C87'
  when d1.stratum2 = 'visit_detail_start_datetime' then 'C88'
  when d1.stratum2 = 'visit_detail_end_date' then 'C89'
  else null
 end as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,d1.err_no
from
(select
 stratum1
,'visit_detail_start_date' as stratum2
,visit_detail_start_date_check as stratum3
,err_no
from visit_detail_rawdata
where visit_detail_start_date_check is not null
union all
select
 stratum1
,'visit_detail_start_datetime' as stratum2
,visit_detail_start_datetime_check as stratum3
,err_no
from visit_detail_rawdata
where visit_detail_start_datetime_check is not null
union all
select
 stratum1
,'visit_detail_end_date' as stratum2
,visit_detail_end_date_check as stratum3
,err_no
from visit_detail_rawdata
where visit_detail_end_date_check is not null) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
with visit_rawdata as (
select
 'visit_occurrence' as stratum1
,err_no
,case
    when visit_start_date > visit_start_datetime then 'visit_start_date > visit_start_datetime'
    when visit_start_date > visit_end_date then 'visit_start_date > visit_end_date'
    when visit_start_date > visit_end_datetime then 'visit_start_date > visit_end_datetime'
    else null
end as visit_start_date_check
,case
--    when visit_start_datetime > visit_end_date then 'visit_start_datetime > visit_end_date'
    when visit_start_datetime > visit_end_datetime then 'visit_start_datetime > visit_end_date'
    else null
end as visit_start_datetime_check
,case
    when visit_end_date > visit_end_datetime then 'visit_end_date > visit_end_datetime'
    else null
end as visit_end_date_check
from
(select
 visit_occurrence_id as err_no
,visit_start_date
,visit_start_datetime
,visit_end_date
,visit_end_datetime
from @cdmSchema.visit_occurrence)v)
--
insert into @resultSchema.score_log_cdm
select
case
  when d1.stratum2 = 'visit_start_date' then 'C87'
  when d1.stratum2 = 'visit_start_datetime' then 'C88'
  when d1.stratum2 = 'visit_end_date' then 'C89'
  else null
 end as check_id
,s1.tb_id
,d1.stratum1
,d1.stratum2
,d1.stratum3
,null as stratum4
,null as stratum5
,d1.err_no
from
(select
 stratum1
,'visit_detail_start_date' as stratum2
,visit_start_date_check as stratum3
,err_no
from visit_rawdata
where visit_start_date_check is not null
union all
select
 stratum1
,'visit_start_datetime' as stratum2
,visit_start_datetime_check as stratum3
,err_no
from visit_rawdata
where visit_start_datetime_check is not null
union all
select
 stratum1
,'visit_end_date' as stratum2
,visit_end_date_check as stratum3
,err_no
from visit_rawdata
where visit_end_date_check is not null) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = d1.stratum1;
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,stratum3 as stratum4
,stratum2+' greater than other date ('+stratum3+')' as stratum5
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
from @resultSchema.score_log_cdm
where check_id in ('C87','C88','C89')
group by check_id,tb_id,stratum1,stratum2,stratum3)v