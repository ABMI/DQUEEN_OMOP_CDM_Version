--
insert into @resultSchema.dq_check_result
select
 'C204' as check_id
,s1.tb_id  as stratum1
,d1.*
from
(select
 d1.tbnm as stratum2
,d1.colnm as stratum3
,null as stratum4
,'Inpatinets should be have datetime' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 'DRUG_EXPOSURE' as tbnm
,'DRUG_EXPOSURE_START_DATETIME' as colnm
,DRUG_EXPOSURE_ID
,DRUG_EXPOSURE_START_DATETIME
,visit_occurrence_id
from @cdmSchema.DRUG_EXPOSURE) as d1
inner join
(select
  visit_occurrence_id
  ,visit_concept_id
from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = d1.visit_occurrence_id
group by d1.tbnm, d1.colnm) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on d1.stratum2 = s1.tbnm
--
insert into @resultSchema.dq_check_result
select
 'C204' as check_id
,s1.tb_id  as stratum1
,d1.*
from
(
select
 d1.tbnm as stratum2
,d1.colnm as stratum3
,null as stratum4
,'Inpatinets should be have datetime' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
 'DRUG_EXPOSURE' as tbnm
,'DRUG_EXPOSURE_END_DATETIME' as colnm
,DRUG_EXPOSURE_ID
,DRUG_EXPOSURE_END_DATETIME
,visit_occurrence_id
from @cdmSchema.DRUG_EXPOSURE) as d1
inner join
(select
  visit_occurrence_id
  ,visit_concept_id
from @cdmSchema.visit_occurrence) as v1
on v1.visit_occurrence_id = d1.visit_occurrence_id
group by d1.tbnm, d1.colnm) as d1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on d1.stratum2 = s1.tbnm