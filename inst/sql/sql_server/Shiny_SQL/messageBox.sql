--messageBox1 (META Main : DQ Error table)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id;

--messageBox2 (META Person : DQ Error table)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id;

--messageBox3 (META Visit : DQ Error table)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id;

--messageBox4 (CDM Main : DQ Error table)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id;

--messageBox5 (CDM Person : DQ Error table)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'person'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox6 (CDM Visit : DQ Error table)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'visit_occurrence'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox7 (META Person : Table basic DQ information)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'visit_occurrence'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox8 (META Visit : Table basic DQ information)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'visit_occurrence'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox9 (CDM Person : Table basic DQ information)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'person') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'person') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;

--messageBox10 (CDM Visit : Table basic DQ information)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'visit_occurrence') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'visit_occurrence') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;

--messageBox11 (META Visit : Descriptive statistics)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'visit_occurrence') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'visit_occurrence') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;

--messageBox12 (META Visit : Descriptive statistics)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'visit_occurrence') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'visit_occurrence') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;

--messageBox13 (CDM Visit : Descriptive statistics)
select
 ds1.stratum2 as visit_concept_id
,c1.concept_name as visit_concept_name
,ds1.min as min_length
,ds1.max as max_length
,ds1.avg as average_length
,ds1.stdev as standard_deviation_length
,ds1.median as median_length
,ds1.p_10 as p_10_length
,ds1.p_25 as p_25_legnth
,ds1.p_75 as p_75_legnth
,ds1.p_90 as p_90_legnth
from
(select
distinct
stratum2
,min
,max
,avg
,stdev
,median
,p_10
,p_25
,p_75
,p_90
from @resultSchema.dq_result_statics
where check_id = 'C147') as ds1
inner join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = ds1.stratum2;

--messageBox14 (CDM Visit : Descriptive statistics)
select
 ds1.stratum2 as visit_concept_id
,c1.concept_name as visit_concept_name
,ds1.min as min_daily_visit_count
,ds1.max as max_daily_visit_count
,ds1.avg as average_daily_visit_count
,ds1.stdev as standard_deviation_daily_visit_count
,ds1.median as median_daily_visit_count
,ds1.p_10 as p_10_daily_visit_count
,ds1.p_25 as p_25_daily_visit_count
,ds1.p_75 as p_75_daily_visit_count
,ds1.p_90 as p_90_daily_visit_count
from
(select
distinct
stratum2
,min
,max
,avg
,stdev
,median
,p_10
,p_25
,p_75
,p_90
from @resultSchema.dq_result_statics
where check_id = 'C145') as ds1
inner join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = ds1.stratum2;

--messageBox15 (CDM Provider : Descriptive statistics)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'provider'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox16 (CDM Death : DQ error message box)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'death'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox17 (CDM CareSite : DQ error message box)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'care_site'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox18 (CDM ConditionOccurence : DQ error message box)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'condition_occurrence'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox19 (CDM DrugExposure : DQ error message box)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'drug_exposure'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox20 (CDM DeviceExposure : DQ error message box)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'device_exposure'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox21 (CDM ProcedureOccurence : DQ error message box)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'procedure_occurrence'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox22 (CDM Mesurement : DQ error message box)
select
 c1.tbnm as Table_name
,dq1.sub_category as DQ_Category
,dq1.check_id as check_id
,dq1.check_desc as check_description
,sum(cast(count_val as int)) as count_val
from
(select
distinct
c1.sub_category
,c1.check_id
,c1.stratum1
,c1.check_desc
,d1.count_val
from
(select
sub_category
,check_id
,stratum1
,check_desc
from @resultSchema.dq_check
where sub_category not in ('Plausibility-Temporal')) as c1
inner join
(select
check_id
,stratum1
,count_val
from @resultSchema.dq_check_result
where check_id not in ('C1','C2','C3','C4','C5','C6','C7','C24','C8','C190','C167')
and check_id not like 'D%' ) as d1
on c1.check_id = d1.check_id and c1.stratum1 = d1.stratum1
where d1.count_val is not null
and cast(d1.count_val as int) > 0) as dq1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb = 'CDM') as c1
on dq1.stratum1 = c1.tb_id
where c1.tbnm = 'measurement'
group by  dq1.sub_category,c1.tbnm,dq1.check_id,dq1.check_desc;

--messageBox23 (CDM Mesurement : DQ error message box)
select
 d1.stratum3 as measurement_concept_id
,c1.concept_name as measurement_concept_name
,d1.min as min_measurement_count
,d1.max as max_measurement_count
,d1.avg as average_measurement_count
,d1.stdev as standard_deviation_measurement_count
,d1.median as median_measurement_count
,d1.p_10 as p10_measurement_count
,d1.p_25 as p25_measurement_count
,d1.p_75 as p75_measurement_count
,d1.p_90 as p90_measurement_count
from
(select distinct
stratum2
,stratum3
,min
,max
,avg
,stdev
,median
,p_10
,p_25
,p_75
,p_90
from @resultSchema.dq_result_statics
where check_id = 'C330') as d1
inner join
(select
concept_id
,concept_name
from @cdmSchema.concept) as c1
on d1.stratum3 = c1.concept_id;

--messageBox24 (CDM ConditionOccurence : patinets diagnosis per one day (IQR))
select
 stratum3 as visit_concept_id
,case
when stratum3 is null then 'total'
else c1.concept_name
end as visit_concept_name
,min as min_of_daily_diagnosis_count
,max as max_of_daily_diagnosis_count
,avg as average_of_daily_diagnosis_count
,median as median_of_daily_diagnosis_count
,p_10  as p_10_of_daily_diagnosis_count
,p_25 as p_25_of_daily_diagnosis_count
,p_75 as p_75_of_daily_diagnosis_count
,p_90 as p_90_of_daily_diagnosis_count
from
(select
distinct
stratum2,null as stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C195'
union all
select
distinct
stratum2,stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C196') as d1
left join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = stratum3
order by visit_concept_name;

--messageBox25 (CDM ConditionOccurence : Disease period of once diagnosis (IQR))
select
 stratum3 as visit_concept_id
,case
when stratum3 is null then 'total'
else c1.concept_name
end as visit_concept_name
,min as min_of_condition_period
,max as max_of_condition_period
,avg as average_of_condition_period
,median as median_of_condition_period
,p_10  as p_10_of_condition_period
,p_25 as p_25_of_condition_period
,p_75 as p_75_of_condition_period
,p_90 as p_90_of_condition_period
from
(select
distinct
stratum2,null as stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C197'
union all
select
distinct
stratum2,stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C198') as d1
left join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = stratum3
order by visit_concept_name;

--messageBox26 (CDM DrugExposure : day length of drug exposure)
select
 stratum3 as visit_concept_id
,case
when stratum3 is null then 'total'
else c1.concept_name
end as visit_concept_name
,min as min_of_drug_exposre_length
,max as max_of_drug_exposre_length
,avg as average_of_drug_exposre_length
,median as median_of_drug_exposre_length
,p_10  as p_10_of_drug_exposre_length
,p_25 as p_25_of_drug_exposre_length
,p_75 as p_75_of_drug_exposre_length
,p_90 as p_90_of_drug_exposre_length
from
(select
distinct
stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C289') as d1
left join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = stratum3
order by concept_name;

--messageBox27 (CDM DrugExposure : drug prescription day check by drug concept_level  (IQR))
select
 stratum3 as visit_concept_id
,case
when stratum3 is null then 'total'
else c1.concept_name
end as visit_concept_name
,min as min_of_drug_exposre_quantity
,max as max_of_drug_exposre_quantity
,avg as average_of_drug_exposre_quantity
,median as median_of_drug_exposre_quantity
,p_10  as p_10_of_drug_exposre_quantity
,p_25 as p_25_of_drug_exposre_quantity
,p_75 as p_75_of_drug_exposre_quantity
,p_90 as p_90_of_drug_exposre_quantity
from
(select
distinct
stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C290') as d1
left join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = stratum3
order by concept_name;

--messageBox28 (CDM DeviceExposure : quantity check (IQR))
select
 stratum3 as device_exposure_concept_id
,case
when stratum3 is null then 'total'
else c1.concept_name
end as device_concept_name
,min as min_of_device_expousre_quantity
,max as max_of_device_expousre_quantity
,avg as average_of_device_expousre_quantity
,median as median_of_device_expousre_quantity
,p_10  as p_10_of_device_expousre_quantity
,p_25 as p_25_of_device_expousre_quantity
,p_75 as p_75_of_device_expousre_quantity
,p_90 as p_90_of_device_expousre_quantity
from
(select
distinct
stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C310') as d1
left join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = stratum3
order by concept_name;


--messageBox29 (CDM ProcedureOccurence : quantity check   (IQR))
select
 stratum3 as procedure_concept_id
,case
when stratum3 is null then 'total'
else c1.concept_name
end as procedure_concept_name
,min as min_of_procedure_occurrence_quantity
,max as max_of_procedure_occurrence_quantity
,avg as average_of_procedure_occurrence_quantity
,median as median_of_device_expousre_quantity
,p_10  as p_10_of_procedure_occurrence_quantity
,p_25 as p_25_of_procedure_occurrence_quantity
,p_75 as p_75_of_procedure_occurrence_quantity
,p_90 as p_90_of_procedure_occurrence_quantity
from
(select
distinct
stratum3,min,max,avg,median,p_10,p_25,p_75,p_90
from @resultSchema.dq_result_statics
where check_id = 'C293') as d1
left join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = stratum3
order by concept_name;

--messageBox30 (CDM Mesurement : IQR info)
select
*
from
(select
d1.stratum3
,c1.concept_name
,d1.min
,d1.max
,d1.avg
,d1.stdev
,d1.median
,d1.p_10
,d1.p_25
,d1.p_75
,d1.p_90
from
(select distinct
stratum3
,min
,max
,avg
,stdev
,median
,p_10
,p_25
,p_75
,p_90
from @resultSchema.dq_result_statics
where check_id = 'C323') as d1
inner join
(select
concept_id
,concept_name
from @cdmSchema.concept) as c1
on d1.stratum3 = c1.concept_id
where (stratum3 is not null and stratum3 not in (0)))v;

--messageBox31 (META Provider : Table basic DQ information)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'provider') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'provider') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;

--messageBox32 (META Death : Table basic DQ information)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'death') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'death') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;

--messageBox33 (META CareSite : Table basic DQ information)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'care_site') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'care_site') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;

--messageBox34 (META condition_occurrence : Table basic DQ information)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'condition_occurrence') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'provider') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;

--messageBox35 (META DrugExposure : Table basic DQ information)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'drug_exposure') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'drug_exposure') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;

--messageBox36 (META DeviceExposure : Table basic DQ information)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'device_exposure') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'device_exposure') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;
--messageBox37 (META ProcedureOccurence : Table basic DQ information)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'procedure_occurrence') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'procedure_occurrence') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;


--messageBox38 (META Measurement : Table basic DQ information)
select
d1.stratum1 as table_name
,d1.stratum2 as column_name
,d1.stratum3 as col_name_valid
,d1.stratum4 as datatype_valid
,d1.stratum5 as constrain_valid
,d2.stratum3 as col_count
,d2.stratum4 as distinct_count
,d2.stratum5 as missing_value_count
,d2.count_val as special_char_count
from
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
from @resultSchema.dq_check_result
where check_id = 'D15' and stratum1 = 'measurement') as d1
left join
(select
stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,count_val
from @resultSchema.dq_check_result
where check_id = 'D16'and stratum1 = 'measurement') as d2
on d1.stratum1 = d2.stratum1 and d2.stratum2 = d1.stratum2;

--messageBox39 (CDM Measurement : regression)
select
 ds1.stratum2 as concept_id
,c1.concept_name
,ds1.stratum4 as age_group
,ds1.count_val
,ds1.min
,ds1.avg
,ds1.stdev
,ds1.median
,ds1.p_25
,ds1.p_75
from
(select
 stratum2
,stratum3
,stratum4
,sum(cast(count_val as int)) as count_val
,min
,max
,avg
,stdev
,median
,p_25
,p_75
from @resultSchema.dq_result_statics
where check_id = 'C331' and stratum3 = 8507
group by stratum2,stratum3,stratum4,min,max,avg,stdev,median,p_25,p_75) as ds1
inner join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = ds1.stratum2;

--messageBox40 (CDM Measurement : regression)
select
 ds1.stratum2 as concept_id
,c1.concept_name
,ds1.stratum4 as age_group
,ds1.count_val
,ds1.min
,ds1.avg
,ds1.stdev
,ds1.median
,ds1.p_25
,ds1.p_75
from
(select
 stratum2
,stratum3
,stratum4
,sum(cast(count_val as int)) as count_val
,min
,max
,avg
,stdev
,median
,p_25
,p_75
from @resultSchema.dq_result_statics
where check_id = 'C331' and stratum3 = 8532
group by stratum2,stratum3,stratum4,min,max,avg,stdev,median,p_25,p_75) as ds1
inner join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = ds1.stratum2;
