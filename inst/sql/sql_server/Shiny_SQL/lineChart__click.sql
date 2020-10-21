--linechart__click1 (CDM Mesurement : DQ error message box)
select
 s1.stratum3 as concept_id
,c1.concept_name as concept_name
,s1.stratum4 as yyymm
,s1.count_val as count
,s1.min
,s1.max 
,s1.median
,s1.p_25
,s1.p_75
from
(select
 stratum3
,stratum4
,count_val
,min
,max
,median
,p_25
,p_75
from @resultSchema.dq_result_statics
where check_id = 'C330') as s1
inner join
(select concept_id, concept_name from @cdmSchema.concept) as c1
on c1.concept_id = s1.stratum3
order by s1.stratum3, s1.stratum4 ;