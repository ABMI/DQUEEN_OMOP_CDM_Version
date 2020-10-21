--heatmapRowPlot1 (META Main : Table yearly row count table)
select
 t1.stratum1 as TABLE_NAME
,t1.stratum2 as count_year
,t1.count_val
,v1.count_val as visit_count
from
(select
stratum1
,stratum2
,count_val
from @resultSchema.dq_check_result
where check_id = 'D12') as t1
left join
(select
stratum1
,stratum2
,count_val
from @resultSchema.dq_check_result
where check_id = 'D12'
and stratum1 = 'visit_occurrence') as v1
on v1.stratum2 = t1.stratum2
where t1.stratum2 is not null
and t1.count_val is not null
and v1.count_val is not null
order by t1.stratum1, t1.stratum2;

--heatmapRowPlot2 (CDM Main : Table yearly row count table)
select
 t1.stratum1 as TABLE_NAME
,t1.stratum2 as count_year
,t1.count_val
,v1.count_val as visit_count
from
(select
stratum1
,stratum2
,count_val
from @resultSchema.dq_check_result
where check_id = 'D12') as t1
left join
(select
stratum1
,stratum2
,count_val
from @resultSchema.dq_check_result
where check_id = 'D12'
and stratum1 = 'visit_occurrence') as v1
on v1.stratum2 = t1.stratum2
where t1.stratum2 is not null
and t1.count_val is not null
and v1.count_val is not null
order by t1.stratum1, t1.stratum2;