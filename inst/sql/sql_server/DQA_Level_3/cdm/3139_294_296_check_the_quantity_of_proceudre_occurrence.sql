--
insert into @resultSchema.dq_check_result
select
 'C294' as check_id
,32 as stratum1
,'procedure_occurrence' as stratum2
,'quantity' as stratum3
,null as stratum4
,'check the implausible quantity (quantity > 600)' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @cdmSchema.procedure_occurrence
where quantity > 600;
--
insert into @resultSchema.score_log_CDM
select
 'C295' as check_id
,32 as tb_id
,'procedure_occurrence' as stratum1
,'quantity' as stratum2
,quantity as stratum3
,null as stratum4
,null as stratum5
,procedure_occurrence_id as err_no
from
 @cdmSchema.procedure_occurrence
where quantity < 0;
--
insert into @resultSchema.dq_check_result
select
 'C295' as check_id
,32 as stratum1
,'procedure_occurrence' as stratum2
,'quantity' as stratum3
,null as stratum4
,'check the negative quantity (quantity < 0)' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C295'
--
insert into @resultSchema.score_log_CDM
select
 'C296' as check_id
,32 as tb_id
,'procedure_occurrence' as stratum1
,'quantity' as stratum2
,quantity as stratum3
,null as stratum4
,null as stratum5
,procedure_occurrence_id as err_no
from
 @cdmSchema.procedure_occurrence
where quantity = 0;
--
insert into @resultSchema.dq_check_result
select
 'C296' as check_id
,32 as stratum1
,'procedure_occurrence' as stratum2
,'quantity' as stratum3
,null as stratum4
,'check the zero quantity (quantity = 0)' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C296';