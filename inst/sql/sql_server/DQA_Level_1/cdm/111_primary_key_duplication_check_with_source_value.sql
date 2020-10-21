/*************************************************************************/
--  Assigment: Plausibility - Atemporal
--  Description: this medical dept could not prescribe the procedure
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  this medical dept could not prescribe the drug
--  Language: MSSQL
--  Target data: cdm
--  Except note data (temp....)
-- /*************************************************************************/
insert into @resultSchema.score_log_CDM
select
 case
    when v1.tbnm = 'person' then 'C11'
    when v1.tbnm = 'provider' then 'C12'
    when v1.tbnm = 'care_site' then 'C13'
    else null
  end as check_id
,si1.tb_id
,si1.tbnm as stratum1
,v1.colnm as stratum2
,v1.colnm2 as stratum3
,null as stratum4
,null as stratum5
,v1.err_no
from
(
select
 'person' as tbnm
,'person_id' as colnm
,'person_source_value' as colnm2
,row_number()over(partition by person_source_value,person_id order by person_source_value) as seq
,person_id as err_no
from @cdmSchema.person
union all
select
 'provider' as tbnm
,'provider_id' as colnm
,'provider_source_value' as colnm2
,row_number()over(partition by provider_source_value,provider_id order by provider_source_value) as seq
,provider_id as err_no
from @cdmSchema.provider
union all
select
 'care_site' as tbnm
,'care_site_id' as colnm
,'care_site_source_value' as colnm2
,row_number()over(partition by care_site_source_value,care_site_id order by care_site_source_value) as seq
,care_site_id as err_no
from @cdmSchema.care_site )as v1
join
(select distinct tb_id, tbnm from @resultSchema.schema_info
  where stage_gb = 'CDM') as si1
on si1.tbnm = v1.tbnm
where v1.seq > 1;
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'primary key duplication check with source_value' as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id
,stratum1
,stratum2
,count(*) as count_val
from @resultSchema.score_log_CDM
  where check_id = 'C11'
group by  check_id,tb_id,stratum1,stratum2)v