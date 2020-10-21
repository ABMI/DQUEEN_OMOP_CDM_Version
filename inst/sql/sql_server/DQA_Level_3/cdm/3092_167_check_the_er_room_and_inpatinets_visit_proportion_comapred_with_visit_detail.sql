insert into @resultSchema.dq_check_result
select
 'C167' as check_id
,'37,38' as stratum1
,tbnm as stratum2
,'visit_occurrence' as stratum3
,ei_count as stratum4
,'check the Emergency Room and Inpatient Visit proportion compared with visit detail' as stratum5
,count_val
,ei_count-count_val as num_val
,err_gb as txt_val
from
(select
 *
,case
	 when count_val = ei_count then 'same'
	 when count_val < ei_count then 'visit_detail smaller than visit_occurrence'
	 when count_val > ei_count then 'visit_detail greater than visit_occurrence'
	 else null
 end as err_gb
from
(select
 'visit_detail' as tbnm
,'262' as visit_concept_id
,'E/I' as visit_source_value
,count(*) as count_val
from
(select
 er1.visit_detail_id
,er1.person_id
,vp1.preceding_visit_detail_id
from
(select distinct
 visit_detail_id
,person_id
,visit_detail_end_date
from @cdmSchema.visit_detail
where visit_detail_concept_id='9203') as er1
inner join
(select distinct
 visit_detail_id
,person_id
,visit_detail_start_date
,preceding_visit_detail_id
from @cdmSchema.visit_detail
where visit_detail_concept_id='9201') as vp1
on vp1.preceding_visit_detail_id = er1.visit_detail_id
		and er1.visit_detail_end_date = vp1.visit_detail_start_date
where vp1.preceding_visit_detail_id is not null)v)w
cross join (select count(*) as ei_count from @cdmSchema.visit_occurrence
					 		where visit_concept_id  = 262) as ei)z
