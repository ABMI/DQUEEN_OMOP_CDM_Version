--
insert into @resultSchema.dq_check_result
select
'C149' as check_id
,31 as startum1
,'person' as stratum2
,'person_id' as stratum3
,'provider.provider_id' as stratum4
,'ratio of providers to total person' as stratum5
,null as count_val
,CAST(1.0*p2.tu/p1.tp AS FLOAT)  as num_val
,null as txt_val
from
	(select count(distinct person_id) as tp from @cdmSchema.person) as p1
cross join (select count(distinct provider_id) as tu from @cdmSchema.provider) as p2