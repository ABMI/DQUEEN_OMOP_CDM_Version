-- DQ score
select
*
from
(select
 (stage_gb+'Main'+sub_category+'Donut') as name
,value
from
(select
 d1.stage_gb
,'score' as sub_category
,case
  when d1.DQ_score is null then 0
  else d1.DQ_score
 end as value
from
(select
 stratum4 as stage_gb
,avg(cast(num_val as float)) as DQ_score
from @resultSchema.dq_check_result
where check_id = 'D2'
group by stratum4) as d1
union all
select
 s1.stage_gb
,s1.stratum1 as sub_category
,case
   when d1.num_val is null then cast(0 as float)
   else cast(d1.num_val as float)
 end as value
from
(select
 'CDM' as stage_gb
,stratum1
from @resultSchema.dq_check_result
where check_id = 'D8') as s1
left join
(select
 stratum1
,stratum2
,stratum3
,num_val
from @resultSchema.dq_check_result
where check_id = 'D7') as d1
on s1.stage_gb = d1.stratum2
  and s1.stratum1 = d1.stratum3)v
union all
select
 ('cdm'+(case when s2.tbnm = 'person' then 'Person'
        when s2.tbnm = 'visit_occurrence' then 'Visit'
        when s2.tbnm = 'Condition_occurrence' then 'Conditionoccurrence'
        when s2.tbnm = 'drug_exposure' then 'DrugExposure'
        when s2.tbnm = 'device_exposure' then 'DeviceExposure'
        when s2.tbnm = 'Procedure_occurrence' then 'ProcedureOccurrence'
        when s2.tbnm = 'measurement' then 'Measurement'
        when s2.tbnm = 'care_site' then 'CareSite'
        when s2.tbnm = 'death' then 'Death'
        when s2.tbnm = 'provider' then 'Prvider'
        else s2.tbnm end )+s1.sub_category+'Donut') as name
,(round(cast(s1.score as float),3)*100) as value
from
(select
distinct tb_id, tbnm from @resultSchema.schema_info
where stage_gb= 'CDM') as s2
left join
(select
 tb_id
,case
   when sub_category = 'conformance-relation' then 'relation'
   when sub_category = 'plausibility-atemporal' then 'atemporal'
   when sub_category = 'plausibility-uniquness' then 'uniqueness'
   when sub_category = 'conformance-value' then 'value'
   when sub_category = 'Table score' then 'score'
   else sub_category
 end as sub_category
,(case
    when cast(score as float) is null then 0
    else cast(score as float)
    end ) as score
from @resultSchema.score_result) as s1
on s1.tb_id = s2.tb_id)w
where name is not null ;