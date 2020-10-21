--heatmapRowPlot1 (META Main : Table yearly row count by visit type)
select
 d3.TABLE_NAME
,c1.CONCEPT_NAME as col
,d3.count_year
,d3.count_val
from
(select
d1.stratum1 as TABLE_NAME
,d1.stratum3 as col
,d1.stratum2 as count_year
,d1.count_val
,d2.count_val as visit_count
from
(select
stratum1
,stratum2
,stratum3
,count_val
from @resultSchema.dq_check_result
where check_id = 'D17') as d1
left join
(select
stratum1
,stratum2
,stratum3
,count_val
from @resultSchema.dq_check_result
where check_id = 'D18') as d2
on d1.stratum2 = d2.stratum2 and d1.stratum3 = d2.stratum3) as d3
left join
(select
concept_id, concept_name from @cdmSchema.concept) as c1
on d3.col = c1.concept_id
where c1.concept_name is not null
order by TABLE_NAME,col,count_year;

--heatmapRowPlot2 (CDM Main : Table yearly row count by visit type)
select
 d3.TABLE_NAME
,c1.CONCEPT_NAME as col
,d3.count_year
,d3.count_val
from
(select
d1.stratum1 as TABLE_NAME
,d1.stratum3 as col
,d1.stratum2 as count_year
,d1.count_val
,d2.count_val as visit_count
from
(select
stratum1
,stratum2
,stratum3
,count_val
from @resultSchema.dq_check_result
where check_id = 'D17') as d1
left join
(select
stratum1
,stratum2
,stratum3
,count_val
from @resultSchema.dq_check_result
where check_id = 'D18') as d2
on d1.stratum2 = d2.stratum2 and d1.stratum3 = d2.stratum3) as d3
left join
(select
concept_id, concept_name from @cdmSchema.concept) as c1
on d3.col = c1.concept_id
where c1.concept_name is not null
order by TABLE_NAME,col,count_year;