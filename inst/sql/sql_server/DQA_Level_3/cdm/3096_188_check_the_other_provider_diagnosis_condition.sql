insert into @resultSchema.score_log_CDM
select
 'C188'
,13 as tb_id
,'condition_occurrence' as stratum1
,'provider_id' as stratum2
,specialty_concept_id as stratum3
,null as stratum4
,null as stratum5
,condition_occurrence_id as err_no
from
(select
 c1.condition_occurrence_id
,c1.provider_id
,p1.specialty_concept_id
,case
   when p1.specialty_concept_id = 4010577 then 'N'
   else 'Y'
 end as err_gb
from
(select
 condition_occurrence_id
,provider_id
from @cdmSchema.condition_occurrence
where provider_id is not null) as c1
left join
(select
 provider_id
,specialty_concept_id from @cdmSchema.provider) as p1
on p1.provider_id = c1.provider_id)v
where err_gb = 'Y'
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,stratum3 as stratum4
,'check the Diagnosis of excluding Doctor' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C188'
group by check_id,tb_id,stratum1,stratum2,stratum3