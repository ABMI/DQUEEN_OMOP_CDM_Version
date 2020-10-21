--
insert into @resultSchema.score_log_CDM
select
case
	when err_gb = 'Y1' then 'C153'
	when err_gb = 'Y2' then 'C154'
	else null
end as check_id
,s1.tb_id
,v1.stratum1
,v1.stratum2
,v1.stratum3
,v1.stratum4
,v1.stratum5
,v1.err_no
from
(select
 'visit_detail' as stratum1
,'visit_detail_start_date' as stratum2
,'visit_detail_end_date' as stratum3
,visit_detail_concept_id as stratum4
,diff_date as stratum5
,visit_detail_id as err_no
,case
	when visit_detail_concept_id = 9202 and diff_date > 0 then 'Y1'
	when diff_date < 0 then 'Y2'
	else null
 end as err_gb
from
(select
 person_id
,visit_detail_concept_id
,visit_detail_start_date
,visit_detail_end_date
,datediff(day,visit_detail_start_date,visit_detail_end_date) as diff_date
,visit_detail_id
from @cdmSchema.visit_detail)v) as v1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as s1
on s1.tbnm = v1.stratum1
where v1.err_gb is not null ;
--
insert into @resultSchema.score_log_cdm
select
*
from
(select
 'C153-1' as check_id
,tb_id
,stratum1
,'visit_detail_end_date' as stratum2
,stratum3
,stratum4
,stratum5
,err_no
from @resultSchema.score_log_CDM
where check_id = 'C153'
union all
select
 'C154-1' as check_id
,tb_id
,stratum1
,'visit_detail_end_date' as stratum2
,stratum3
,stratum4
,stratum5
,err_no
from @resultSchema.score_log_CDM
where check_id = 'C154')v
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum2
,stratum3
,stratum4
,case
	 when check_id = 'C153' then 'this visit type should be not staty length over 1 days'
	 when check_id = 'C154' then 'visit staty length should be negative'
	 else null
 end as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
@resultSchema.score_log_CDM
where check_id in ('C153','C154')
group by check_id, tb_id, stratum2, stratum3, stratum4;
--
--> warniing
--
insert into @resultSchema.dq_check_result
select
 'C155' as check_id
,stratum1
,stratum2
,stratum3
,stratum4
,'visit staty is too long ( > 180)' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
@resultSchema.dq_check_result
where check_id = 'C148'
and cast(stratum5 as int) > 180
group by stratum1,stratum2,stratum3,stratum4;
--