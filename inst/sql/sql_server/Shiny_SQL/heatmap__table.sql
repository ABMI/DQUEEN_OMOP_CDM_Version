--heatmap__table1 (CDM ConditionOccurence : heatmap)
with raw_data as (
select
 c1.condition_concept_id
,c1.count_val as condition_count
,vc1.visit_concept_id
,vc1.count_val as visit_count
,c2.condition_type_concept_id
,c2.count_val as type_count
,(select count(*) as tot_count_val from @cdmSchema.condition_occurrence) as tot_count_val
from
(select
 condition_concept_id
,count(*) as count_val
from @cdmSchema.condition_occurrence
group by condition_concept_id) as c1
left join
(
select
 co1.condition_concept_id
,v1.visit_concept_id
,count(*) as count_val
from
(select
 condition_concept_id
,visit_occurrence_id
from @cdmSchema.condition_occurrence
where visit_occurrence_id is not null ) as co1
left join
(select visit_occurrence_id, visit_concept_id from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = co1.visit_occurrence_id
group by co1.condition_concept_id,v1.visit_concept_id) as vc1
on c1.condition_concept_id = vc1.condition_concept_id
left join
(select
 condition_concept_id
,condition_type_concept_id
,count(*) as count_val
from @cdmSchema.condition_occurrence
where condition_type_concept_id = '44786629'
group by condition_concept_id ,condition_type_concept_id ) as c2
on c1.condition_concept_id = c2.condition_concept_id)

select
 cd1.concept_id
,cc1.concept_name
,cd1.condition_count as concept_count
,cd1.Outpatient_Visit
,cd1.Inpatient_Visit
,cd1.Emergency_Room_Visit
,cd1.Emergency_Room_and_Inpatient_Visit
,cd1.final_diagnosis
,cd1.proportion_of_condition
,cd1.unit
from
    (select
 condition_concept_id as concept_id
,condition_count
,sum(Outpatient_Visit) as Outpatient_Visit
,sum(Inpatient_Visit) as Inpatient_Visit
,sum(Emergency_Room_Visit) as Emergency_Room_Visit
,sum(Emergency_Room_and_Inpatient_Visit) as Emergency_Room_and_Inpatient_Visit
,final_diagnosis
,proportion_of_condition
,unit
from
    (select
 condition_concept_id
,condition_count
,case visit_concept_id when 9202 then visit_count else 0 end as Outpatient_Visit
,case visit_concept_id when 9201 then visit_count else 0 end as Inpatient_Visit
,case visit_concept_id when 9203 then visit_count else 0 end as Emergency_Room_Visit
,case visit_concept_id when 262 then visit_count else 0 end as Emergency_Room_and_Inpatient_Visit
,case when type_count is null then 0 else type_count end as final_diagnosis
,1.0*(cast(condition_count as float)/cast(tot_count_val as float)) as proportion_of_condition
,'%' as unit
from raw_data)v
group by  condition_concept_id,condition_count,final_diagnosis,proportion_of_condition,unit) as cd1
inner join
(select concept_id, concept_name from @cdmSchema.concept
where concept_id NOT IN ('0')) as cc1
on cd1.concept_id = cc1.concept_id ;

--heatmap__table2 (CDM DrugExposure : heatmap)
with raw_data as (
select distinct
 c1.drug_concept_id
,c1.count_val as condition_count
,vc1.visit_concept_id
,vc1.count_val as visit_count
,c2.DRUG_TYPE_CONCEPT_ID
,c2.count_val as type_count
,(select count(*) as tot_count_val from @cdmSchema.drug_exposure) as tot_count_val
from
(select
 drug_concept_id
,count(*) as count_val
from @cdmSchema.drug_exposure
group by drug_concept_id) as c1
left join
(
select
 co1.drug_concept_id
,v1.visit_concept_id
,count(*) as count_val
from
(select
 drug_concept_id
,visit_occurrence_id
from @cdmSchema.drug_exposure
where visit_occurrence_id is not null ) as co1
left join
(select visit_occurrence_id, visit_concept_id from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = co1.visit_occurrence_id
group by co1.drug_concept_id,v1.visit_concept_id) as vc1
on c1.drug_concept_id = vc1.drug_concept_id
left join
(select distinct
 drug_concept_id
,drug_type_concept_id
,count(*) as count_val
from @cdmSchema.drug_exposure
where drug_type_concept_id = 38000177
group by drug_concept_id ,drug_type_concept_id ) as c2
on c1.drug_concept_id = c2.drug_concept_id )

select
 de1.concept_id
,cc1.concept_name
,de1.drug_count as concept_count
,de1.Outpatient_Visit
,de1.Inpatient_Visit
,de1.Emergency_Room_Visit
,de1.Emergency_Room_and_Inpatient_Visit
,de1.Prescription_written
,de1.proportion_of_drug_concept_id
,de1.unit
from
(select
 DRUG_CONCEPT_ID as concept_id
,drug_count
,sum(Outpatient_Visit) as Outpatient_Visit
,sum(Inpatient_Visit) as Inpatient_Visit
,sum(Emergency_Room_Visit) as Emergency_Room_Visit
,sum(Emergency_Room_and_Inpatient_Visit) as Emergency_Room_and_Inpatient_Visit
,Prescription_written
,proportion_of_drug_concept_id
,unit
from
(select
 DRUG_CONCEPT_ID
,condition_count as drug_count
,case visit_concept_id when 9202 then visit_count else 0 end as Outpatient_Visit
,case visit_concept_id when 9201 then visit_count else 0 end as Inpatient_Visit
,case visit_concept_id when 9203 then visit_count else 0 end as Emergency_Room_Visit
,case visit_concept_id when 262 then visit_count else 0 end as Emergency_Room_and_Inpatient_Visit
,case DRUG_TYPE_CONCEPT_ID when  38000177 then type_count else 0 end as Prescription_written
,1.0*(cast(condition_count as float)/cast(tot_count_val as float)) as proportion_of_drug_concept_id
,'%' as unit
from raw_data)v
group by  DRUG_CONCEPT_ID,drug_count,Prescription_written,proportion_of_drug_concept_id,unit) as de1
inner join
(select concept_id, concept_name from @cdmSchema.concept
where concept_id NOT IN ('0')) as cc1
on de1.concept_id = cc1.concept_id ;

--heatmap__table3 (CDM DeviceExposure : heatmap)
with raw_data as (
select
 c1.device_concept_id
,c1.count_val as condition_count
,vc1.visit_concept_id
,vc1.count_val as visit_count
,c2.count_val as type_count
,(select count(*) as tot_count_val from @cdmSchema.device_exposure) as tot_count_val
from
(select
 device_concept_id
,count(*) as count_val
from @cdmSchema.device_exposure
group by device_concept_id) as c1
left join
(
select
 co1.device_concept_id
,v1.visit_concept_id
,count(*) as count_val
from
(select
 device_concept_id
,visit_occurrence_id
from @cdmSchema.device_exposure
where visit_occurrence_id is not null ) as co1
inner join
(select visit_occurrence_id, visit_concept_id from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = co1.visit_occurrence_id
group by co1.device_concept_id,v1.visit_concept_id) as vc1
on c1.device_concept_id = vc1.device_concept_id
left join
(select
 device_concept_id
,count(*) as count_val
from @cdmSchema.device_exposure
where device_type_concept_id = 44818707
group by device_concept_id  ) as c2
on c1.device_concept_id = c2.device_concept_id )

select
 dx1.concept_id
,cc1.concept_name
,dx1.device_count as concept_count
,dx1.Outpatient_Visit
,dx1.Inpatient_Visit
,dx1.Emergency_Room_Visit
,dx1.Emergency_Room_and_Inpatient_Visit
,dx1.Prescription_written
,dx1.proportion_of_condition as proportion_of_device_concept
,dx1.unit
from
(select
 device_concept_id as concept_id
,device_count
,sum(Outpatient_Visit) as Outpatient_Visit
,sum(Inpatient_Visit) as Inpatient_Visit
,sum(Emergency_Room_Visit) as Emergency_Room_Visit
,sum(Emergency_Room_and_Inpatient_Visit) as Emergency_Room_and_Inpatient_Visit
,Prescription_written
,proportion_of_condition
,unit
from
(select
 device_concept_id
,condition_count as device_count
,case visit_concept_id when '9202' then visit_count else 0 end as Outpatient_Visit
,case visit_concept_id when '9201' then visit_count else 0 end as Inpatient_Visit
,case visit_concept_id when '9203' then visit_count else 0 end as Emergency_Room_Visit
,case visit_concept_id when '262' then visit_count else 0 end as Emergency_Room_and_Inpatient_Visit
,type_count as Prescription_written
,1.0*(cast(condition_count as float)/cast(tot_count_val as float)) as proportion_of_condition
,'%' as unit
from raw_data)v
group by  device_concept_id,device_count,Prescription_written,proportion_of_condition,unit) as dx1
inner join
(select concept_id, concept_name from @cdmSchema.concept
where concept_id NOT IN ('0')) as cc1
on dx1.concept_id = cc1.concept_id ;

--heatmap__table4 (CDM ProcedureOccurrence : heatmap)
with raw_data as (
select distinct
 c1.procedure_concept_id
,c1.count_val as condition_count
,vc1.visit_concept_id
,vc1.count_val as visit_count
,c2.procedure_type_concept_id
,c2.count_val as type_count
,(select count(*) as tot_count_val from  @cdmSchema.procedure_occurrence) as tot_count_val
from
(select
 procedure_concept_id
,count(*) as count_val
from  @cdmSchema.procedure_occurrence
group by procedure_concept_id) as c1
left join
(
select
 co1.procedure_concept_id
,v1.visit_concept_id
,count(*) as count_val
from
(select
 procedure_concept_id
,visit_occurrence_id
from  @cdmSchema.procedure_occurrence
where visit_occurrence_id is not null ) as co1
left join
(select visit_occurrence_id, visit_concept_id from  @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = co1.visit_occurrence_id
group by co1.procedure_concept_id,v1.visit_concept_id) as vc1
on c1.procedure_concept_id = vc1.procedure_concept_id
left join
(select distinct
 procedure_concept_id
,procedure_type_concept_id
,count(*) as count_val
from @cdmSchema.procedure_occurrence
where procedure_type_concept_id = 38000177
group by procedure_concept_id ,procedure_type_concept_id ) as c2
on c1.procedure_concept_id = c2.procedure_concept_id )
select
 po1.concept_id
,cc1.concept_name
,po1.drug_count as concept_count
,po1.Outpatient_Visit
,po1.Inpatient_Visit
,po1.Emergency_Room_Visit
,po1.Emergency_Room_and_Inpatient_Visit
,po1.Prescription_written
,po1.proportion_of_condition as proportion_of_device_concept
,po1.unit
from
(select
 procedure_concept_id as concept_id
,drug_count
,sum(Outpatient_Visit) as Outpatient_Visit
,sum(Inpatient_Visit) as Inpatient_Visit
,sum(Emergency_Room_Visit) as Emergency_Room_Visit
,sum(Emergency_Room_and_Inpatient_Visit) as Emergency_Room_and_Inpatient_Visit
,Prescription_written
,proportion_of_condition
,unit
from
(select
 procedure_concept_id
,condition_count as drug_count
,case visit_concept_id when 9202 then visit_count else 0 end as Outpatient_Visit
,case visit_concept_id when 9201 then visit_count else 0 end as Inpatient_Visit
,case visit_concept_id when 9203 then visit_count else 0 end as Emergency_Room_Visit
,case visit_concept_id when 262 then visit_count else 0 end as Emergency_Room_and_Inpatient_Visit
,case procedure_type_concept_id when  38000177 then type_count else 0 end as Prescription_written
,1.0*(cast(condition_count as float)/cast(tot_count_val as float)) as proportion_of_condition
,'%' as unit
from raw_data)v
group by  procedure_concept_id,drug_count,Prescription_written,proportion_of_condition,unit) as po1
inner join
(select concept_id, concept_name from @cdmSchema.concept
where concept_id NOT IN ('0')) as cc1
on po1.concept_id = cc1.concept_id ;