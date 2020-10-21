--countBarPlot1 (CDM Contion Occurence : Monthly trend of Condition occurrence)
select
 'condition_occurrence' as table_nm
,stratum3 as visit_year
,cast(count_val as int) as count_val
,p_25
,p_75
,median
from @resultSchema.dq_result_statics
where check_id = 'C193'
and stratum3 is not null
order by visit_year;

--countBarPlot2 (CDM Drug Exposure : Monthly trend of Drug_exposure)
select
 'drug_exposure' as table_nm
,stratum4 as visit_year
,cast(count_val as int) as count_val
,p_25
,p_75
,median
from @resultSchema.dq_result_statics
where check_id = 'C280'
 and stratum4 is not null
order by visit_year;

--countBarPlot3 (CDM Device Exposure : Monthly trend)
select
'drug_exposure' as table_nm
,stratum4 as visit_year
,cast(count_val as int) as count_val
,p_25
,p_75
,median
from @resultSchema.dq_result_statics
where check_id = 'C317'
and stratum4 is not null
order by visit_year;

--countBarPlot4 (CDM Procesure Occurence : Monthly trend)
select
 'procedure_occurrence' as table_nm
,stratum4 as visit_year
,cast(count_val as int) as count_val
,p_25
,p_75
,median
from @resultSchema.dq_result_statics
where check_id = 'C303'
 and stratum4 is not null
order by visit_year;

--countBarPlot5 (CDM Mesurement : Monthly trend)
select
 'measurement' as table_nm
,stratum3 as visit_year
,cast(count_val as int) as count_val
,p_25
,p_75
,median
from @resultSchema.dq_result_statics
where check_id = 'C325'
 and stratum3 is not null
order by visit_year;