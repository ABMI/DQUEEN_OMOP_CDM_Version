--visitCountPlot1 (META Visit : Visit count by year table)
select
stratum2 as table_nm
,stratum4 as visit_year
,count_val
,p_10
,p_25
,median
from @resultSchema.dq_result_statics
where check_id = 'C160'
order by visit_year;

--visitCountPlot2 (CDM Visit : Visit count by year table)
select
stratum2 as table_nm
,stratum4 as visit_year
,count_val
,p_10
,p_25
,median
from @resultSchema.dq_result_statics
where check_id = 'C160'
order by visit_year;
