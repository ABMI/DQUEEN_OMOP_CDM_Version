--
insert into @resultSchema.dq_check_result
select
 'C164' as check_id
,33 as stratum1
,'provider' as stratum2
,pv1.specialty_concept_id as stratum3
,pv2.tot_count_val as stratum4
,'provider proportion group by specialty' as stratum5
,pv1.pr_count_val as count_val
,cast((1.0*pv1.pr_count_val)/pv2.tot_count_val as float) as num_val
,null as txt_val
from
(select specialty_concept_id, count(*) as pr_count_val
  from @cdmSchema.provider group by specialty_concept_id) as pv1
cross join
(select count(*) as tot_count_val from @cdmSchema.provider) as pv2