----------------------------------------------
--              Save.SQL                    --
----------------------------------------------

--> 1. save.Check level
insert into @resultSchema.dq_check_result
select
 'D1' as check_id
,'check_level' as stratum1
,null as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,null as count_val
,3 as num_val
,null as txt_val
from @resultSchema.dq_check_result;

-->2. save.DQ Score
insert into @resultSchema.dq_check_result
select
 'D2' as check_id
,'Data Quality score average' as stratum1
,c1.tb_id as stratum2
,c1.tbnm as stratum3
,stage_gb as stratum4
,null as stratum5
,null as count_val
,s1.avg_score as num_val
,null as txt_val
from
(select
 stage_gb
,tb_id
,avg(cast(round(score,1)*100 as int)) as avg_score
from @resultSchema.score_result
group by stage_gb, tb_id ) as s1
inner join
(select
	distinct
 tb_id
,tbnm
from @resultSchema.schema_info
where stage_gb= 'CDM') as c1
on s1.tb_id = c1.tb_id

--> 3. save.Data Status
insert into @resultSchema.dq_check_result
select
 'D3' as check_id
,'Data Status' as stratum1
,s1.stage_gb as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,null as count_val
,null as num_val
,case
    when c2.y_val is null then cast(0 as varchar)+'/'+cast(s1.tot_val as varchar)
    else cast(c2.y_val as varchar)+'/'+cast(s1.tot_val as varchar)
  end as txt_val
from
(select
 stage_gb, count(*) as tot_val
from
(select
distinct
 stage_gb, tbnm
from @resultSchema.schema_info)v
group by stage_gb) as s1
left join
(select
 stratum2, count(*) as y_val
from @resultSchema.dq_check_result
where check_id = 'C1' and txt_val = 'Y'
group by stratum2
union all
select
 stratum2, count(*) as y_val
from @resultSchema.dq_check_result
where check_id = 'M1' and txt_val = 'Y'
group by stratum2) as c2
on s1.stage_gb = c2.stratum2

--> 4. Save.Data population
insert into @resultSchema.dq_check_result 
select 
 check_id 
,stratum1 
,stratum2 
,stratum3 
,stratum4 
,stratum5 
,case 
   when count_val is null then 0 
   else count_val 
  end as count_val 
,num_Val 
,txt_val 
from 
(select 
 'D4' as check_id 
,'Data population' as stratum1 
,'CDM' as stratum2 
,null as stratum3 
,null as stratum4 
,null as stratum5 
,count(*) as count_val 
,null as num_val 
,null as txt_val 
from dscdm.dbo.person 
union all 
select 
 'D4' as check_id 
,'Data population' as stratum1 
,'META' as stratum2 
,null as stratum3 
,null as stratum4 
,null as stratum5 
,null as count_val 
,null as num_val 
,null as txt_val
/*select 
 'D4' as check_id 
,'Data population' as stratum1 
,'META' as stratum2 
,null as stratum3 
,null as stratum4 
,null as stratum5 
,count(*) as count_val 
,null as num_val 
,null as txt_val 
from .dev_person 
where include_yn = 'Y' */)v 

--> 5. Save.data period
insert into @resultSchema.dq_check_result
select
 'D5' as check_id
,'Data period' as stratum1
,@Stdt as stratum2
,@Endt as stratum3
,null as stratum4
,null as stratum5
,null as count_val
,null as num_val
,null as txt_val

-- 6. Save. Data volume
insert into @resultSchema.dq_check_result
select
 'D6' as check_id
,'Data volume' as stratum1
,s1.stage_gb as stratum2
,case
    when v1.unit is null then 'GB'
    else v1.unit
  end as stratum3
,null as stratum4
,null as stratum5
,null as count_val
,case
   when v1.tot_volume is null then 0
   else v1.tot_volume
 end as num_val
,null as txt_val
from
 (select
  'META' as stage_gb
 union all
  select
  'CDM' as stage_gb ) as s1
left join
(select
stage_gb
,round(((sum(cast(tb_size as float))/1024)/1024),2) as tot_volume
,'GB' as unit
from @resultSchema.schema_capacity
group by stage_gb) as v1
on s1.stage_gb= v1.stage_gb;

-->7. save. Data Quality Concept score
insert into @resultSchema.dq_check_result
select
 'D7' as check_id
,'Data Quality Concept score' as stratum1
,stage_gb  as stratum2
,sub_category as stratum3
,null as stratum4
,null as stratum5
,null as count_val
,round(average_err_rate,2) as num_val
,null as txt_val
from
(select
 stage_gb
,lower(sub_category) as sub_category
,avg(cast(score as float)*100) as average_err_rate
from
 (select
 stage_gb
,case
   when sub_category = 'conformance-relation' then 'relation'
   when sub_category = 'plausibility-atemporal' then 'atemporal'
   when sub_category = 'plausibility-uniquness' then 'uniqueness'
   when sub_category = 'conformance-value' then 'value'
   else sub_category
 end as sub_category
,score
  from @resultSchema.score_result
 where category not in ('Complex'))v
group by  stage_gb,sub_category)w

--> 8. save.meta dq score
insert into @resultSchema.dq_check_result
select
distinct
 'D8' as check_id
,case
   when sub_category = 'conformance-relation' then 'relation'
   when sub_category = 'plausibility-atemporal' then 'atemporal'
   when sub_category = 'plausibility-uniquness' then 'uniqueness'
   when sub_category = 'conformance-value' then 'value'
   else sub_category
 end as stratum1
,null as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,null as count_val
,null as num_val
,null as txt_val
  from @resultSchema.score_result
 where category not in ('Complex') ;

--> 9. Save.DQ error proportion
insert into @resultSchema.dq_check_result
select
 'D9' as check_id
,'DQ Error Proportion' as stratum1
,stage_gb  as stratum2
,sub_category as stratum3
,null as stratum4
,null as stratum5
,null as count_val
,round(average_err_rate,2) as num_val
,null as txt_val
from
(select
 stage_gb
,lower(sub_category) as sub_category
,avg(cast(err_rate as float)*100) as average_err_rate
from
 (select
 stage_gb
,case
   when sub_category = 'conformance-relation' then 'relation'
   when sub_category = 'plausibility-atemporal' then 'atemporal'
   when sub_category = 'plausibility-uniquness' then 'uniqueness'
   when sub_category = 'conformance-value' then 'value'
   else sub_category
 end as sub_category
,err_rate
  from @resultSchema.score_result
 where category not in ('Complex'))v
group by  stage_gb,sub_category)w

--> 10. save.Person Count
insert into @resultSchema.dq_check_result 
select
*
from
(select
 'D10' as check_id
,'gender population' as stratum1
,'CDM' as stratum2
,p1.gender_concept_id as stratum3
,c1.concept_name as stratum4
,case
   when p1.gender_concept_id = 8532 then 'F'
   when p1.gender_concept_id = 8507 then 'M'
  else null
 end as stratum5
,p1.count_val
,null as num_val
,null as txt_val
from
 (select
 gender_concept_id
 ,count(*) as count_val
from @cdmSchema.person
 group by gender_concept_id) as p1
inner join
(select concept_id, concept_name
		from @cdmSchema.concept) as c1
on p1.gender_concept_id = c1.concept_id
union all
(select
 'D10' as check_id
,'gender population' as stratum1
,'META' as stratum2
,null as stratum3
,null as stratum4
,'M' as stratum5
,null as count_val
,null as num_val
,null as txt_val
union all select
 'D10' as check_id
,'gender population' as stratum1
,'META' as stratum2
,null as stratum3
,null as stratum4
,'F' as stratum5
,null as count_val
,null as num_val
,null as txt_val))v

--11.  save.hist
insert into @resultSchema.dq_check_result
select
 'D11' as check_id
,d2.sub_category as stratum1
,d2.stratum1 as stratum2
,s1.tbnm as stratum3
,null as stratum4
,null as stratum5
,d2.count_val
,null as num_val
,null as txt_val
from
(select
 d1.sub_category
,r1.stratum1
,count(r1.check_id) as count_val
from
(select
 check_id
,sub_category
 from @resultSchema.dq_check
where check_id not in ('C1','C2','C3','C4','C5','C6','C8','C16','C190')) as d1
inner join
(select distinct
 check_id
,stratum1
 from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C8','C190','C167')
and check_id not like 'D%') as r1
on  d1.check_id = r1.check_id
group by d1.sub_category, r1.stratum1) as d2
inner join
(select distinct
 tb_id
,tbnm
from @resultSchema.schema_info
where stage_gb = 'CDM') as s1
on d2.stratum1 = s1.tb_id
order by d2.sub_category,s1.tbnm

--12. save.Table yearly row count
insert into @resultSchema.dq_check_result
select
 'D12' as check_id
,tbnm as stratum1
,date as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select substring(cast(condition_era_start_date as varchar),1,4) as date, 'condition_era' as tbnm from @cdmSchema.condition_era union all
select substring(cast(condition_start_date as varchar),1,4) as date, 'condition_occurrence' as tbnm from @cdmSchema.condition_occurrence union all
select substring(cast(death_date as varchar),1,4) as date, 'death' as tbnm from @cdmSchema.death union all
select substring(cast(device_exposure_start_date as varchar),1,4) as date, 'device_exposure' as tbnm from @cdmSchema.device_exposure union all
select substring(cast(dose_era_start_date as varchar),1,4) as date, 'dose_era' as tbnm from @cdmSchema.dose_era union all
select substring(cast(drug_era_start_date as varchar),1,4) as date, 'drug_era' as tbnm from @cdmSchema.drug_era union all
select substring(cast(drug_exposure_start_date as varchar),1,4) as date, 'drug_exposure' as tbnm from @cdmSchema.drug_exposure union all
select substring(cast(measurement_date as varchar),1,4) as date, 'measurement' as tbnm from @cdmSchema.measurement union all
select substring(cast(note_date as varchar),1,4) as date, 'note' as tbnm from @cdmSchema.note union all
select substring(cast(nlp_date as varchar),1,4) as date, 'note_nlp' as tbnm from @cdmSchema.note_nlp union all
select substring(cast(observation_date as varchar),1,4) as date, 'observation' as tbnm from @cdmSchema.observation union all
select substring(cast(observation_period_start_date as varchar),1,4) as date, 'observation_period' as tbnm from @cdmSchema.observation_period union all
select substring(cast(payer_plan_period_start_date as varchar),1,4) as date, 'payer_plan_period' as tbnm from @cdmSchema.payer_plan_period union all
select substring(cast(procedure_date as varchar),1,4) as date, 'procedure_occurrence' as tbnm from @cdmSchema.procedure_occurrence union all
select substring(cast(specimen_date as varchar),1,4) as date, 'specimen' as tbnm from @cdmSchema.specimen union all
select substring(cast(visit_detail_start_date as varchar),1,4) as date, 'visit_detail' as tbnm from @cdmSchema.visit_detail union all
select substring(cast(visit_start_date as varchar),1,4) as date, 'visit_occurrence' as tbnm from @cdmSchema.visit_occurrence)v
group by tbnm, date
order by tbnm, date;

--13. save.provider population
insert into @resultSchema.dq_check_result
select
'D13' as check_id
,'CDM' as stratum1
,'gender population' as stratum2
,'provider' as stratum3
,gender_concept_id as stratum4
,case when gender_concept_id = 8507 then 'M'
  else 'F' end as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 gender_concept_id
,count(*) as count_val
from @cdmSchema.provider
group by gender_concept_id)v

--14. save.DQ pie plot hist
insert into @resultSchema.dq_check_result
select
 'D14' as check_id
,d2.sub_category as stratum1
,d2.stratum1 as stratum2
,s1.tbnm as stratum3
,d2.DQ_TYPE as stratum4
,null as stratum5
,d2.count_val
,null as num_val
,null as txt_val
from
(select
 d1.sub_category
,d1.DQ_TYPE
,r1.stratum1
,count(r1.check_id) as count_val
from
(select
 check_id
,sub_category
,DQ_TYPE
 from @resultSchema.dq_check
where check_id not in ('C1','C2','C3','C4','C5','C6','C8','C190')) as d1
inner join
(select distinct
 check_id
,stratum1
 from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C8','C16','C190','C167')
and check_id not like 'D%') as r1
on  d1.check_id = r1.check_id
group by d1.sub_category, d1.DQ_TYPE,r1.stratum1) as d2
inner join
(select distinct
 tb_id
,tbnm
from @resultSchema.schema_info
where stage_gb = 'CDM') as s1
on d2.stratum1 = s1.tb_id
order by d2.sub_category,s1.tbnm

--> 15. save.dq basic info
insert into @resultSchema.dq_check_result
select
 'D15' as check_id
,s1.tbnm as stratum1
,s1.colnm as stratum2
,case
   when d5.txt_val is null then 'Y'
   else d5.txt_val
 end as stratum3 -- col_name_valid
,case
   when d6.txt_val is null then 'Y'
   else d6.txt_val
 end as stratum4 -- datatype_valid
,case
   when d7.txt_val is null then 'Y'
   else d7.txt_val
 end as stratum5 -- constrain_valid
,null as count_val
,null as num_val
,null as txt_val
from
(select distinct
 tb_id, tbnm , col_id, colnm
from @resultSchema.schema_info
where stage_gb= 'CDM') as s1
left join
    (select
 check_id,stratum1,stratum2,stratum3,stratum4,stratum5,txt_val
from @resultSchema.dq_check_result
where check_id = 'C1') as d5
on d5.stratum1 = s1.tb_id and d5.stratum3 = s1.colnm
left join
(select
 check_id,stratum1,stratum2,stratum3,stratum4,stratum5,txt_val
from @resultSchema.dq_check_result
where check_id = 'C3') as d6
on d6.stratum1 = s1.tb_id and d6.stratum4 = s1.colnm
left join
(select
 check_id,stratum1,stratum2,stratum3,stratum4,stratum5,txt_val
from @resultSchema.dq_check_result
where check_id = 'C4') as d7
on d7.stratum1 = s1.tb_id and d7.stratum4 = s1.colnm
-- 16. save.DQ basic information
insert into @resultSchema.dq_check_result
select
 'D16' as check_id
,d1.stratum2 as stratum1 -- table_name
,d1.stratum4 as stratum2 -- column_name
,d1.count_val as stratum3 -- col_count
,d2.count_val as stratum4 -- distinct_count
,d3.count_val as stratum5  -- missing_value_count
,d4.count_val as count_val -- special_char_count
,null as num_val
,null as txt_val
from
(select
 check_id,stratum1,stratum2,stratum3,stratum4,stratum5,count_val
from @resultSchema.dq_check_result
where check_id = 'C5') as d1
left join
(select
 check_id,stratum1,stratum2,stratum3,stratum4,stratum5,count_val
from @resultSchema.dq_check_result
where check_id = 'C6') as d2
on d2.stratum1 = d1.stratum1 and d2.stratum3 = d1.stratum3
left join
(select
 check_id,stratum1,stratum2,stratum3,stratum4,stratum5,count_val
from @resultSchema.dq_check_result
where check_id = 'C7') as d3
on d3.stratum1 = d1.stratum1 and d3.stratum3 = d1.stratum3
left join
(select
 check_id,stratum1,stratum2,stratum3,stratum4,stratum5,count_val
from @resultSchema.dq_check_result
where check_id = 'C8') as d4
on d4.stratum1 = d1.stratum1 and d4.stratum3 = d1.stratum3
--> 17. save.count year with visit
insert into @resultSchema.dq_check_result
select
 d1.check_id
,d1.stratum1
,d1.stratum2
,v1.visit_concept_id as stratum3
,null as strautm4
,null as stratum5
,sum(d1.count_val) as count_val
,null as num_val
,null as txt_val
from
(select
 'D17' as check_id
,tbnm as stratum1
,date as stratum2
,visit_occurrence_id as stratum3
,count(*) as count_val
from
(select substring(cast(condition_start_date as varchar),1,4) as date, 'condition_occurrence' as tbnm,visit_occurrence_id from @cdmSchema.condition_occurrence union all
select substring(cast(device_exposure_start_date as varchar),1,4) as date, 'device_exposure' as tbnm,visit_occurrence_id from @cdmSchema.device_exposure union all
select substring(cast(drug_exposure_start_date as varchar),1,4) as date, 'drug_exposure',visit_occurrence_id as tbnm from @cdmSchema.drug_exposure union all
select substring(cast(measurement_date as varchar),1,4) as date, 'measurement' as tbnm,visit_occurrence_id from @cdmSchema.measurement union all
select substring(cast(observation_date as varchar),1,4) as date, 'observation' as tbnm,visit_occurrence_id from @cdmSchema.observation union all
select substring(cast(note_date as varchar),1,4) as date, 'note' as tbnm,visit_occurrence_id from @cdmSchema.note union all
select substring(cast(procedure_date as varchar),1,4) as date, 'procedure_occurrence'as tbnm,visit_occurrence_id  from @cdmSchema.procedure_occurrence )v
group by tbnm, date,visit_occurrence_id) as d1
left join
(select
 visit_occurrence_id, visit_concept_id from @cdmSchema.visit_occurrence ) as v1
on v1.visit_occurrence_id = d1.stratum3
group by  d1.check_id,d1.stratum1,d1.stratum2,v1.visit_concept_id

--> 18. save.visit count by year
insert into @resultSchema.dq_check_result
 select
 'D18' as check_id
 ,tbnm as stratum1
,visit_concept_id as stratum2
,date as stratum3
,null as stratum4
 ,null as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
 from
 (select substring(cast(visit_start_date as varchar),1,4) as date
,'visit_occurrence'as tbnm,visit_occurrence_id,visit_concept_id from @cdmSchema.visit_occurrence)v
group by tbnm,visit_concept_id,date;

