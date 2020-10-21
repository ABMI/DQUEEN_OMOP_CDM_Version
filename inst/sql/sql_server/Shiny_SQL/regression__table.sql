--regression__table1 (CDM Measurement : regression table (male))
select
 ds1.stratum2 as concept_id
,c1.concept_name
,ds1.stratum4 as age_group
,ds1.count_val
,ds1.min
,ds1.max
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

--regression__table2 (CDM Measurement : regression table (female))
select
 ds1.stratum2 as concept_id
,c1.concept_name
,ds1.stratum4 as age_group
,ds1.count_val
,ds1.min
,ds1.max
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