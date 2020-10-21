--lineChart1 (Summary : operation period)
select
 stratum5 as cnt_yy
,count_val
from
@resultSchema.dq_check_result
where check_id = 'C160'
and stratum5 is not null;

--lineChart2 (Summary : provider)
select
 stratum5 as cnt_yy
,count_val
from
@resultSchema.dq_check_result
where check_id = 'C159'
and stratum5 is not null;

--lineChart3 (CDM Death : distribution of Death date)
select
stratum4 as cnt_yy
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where check_id = 'C334';

--lineChart4 (CDM Death : age distribution of Death table)
select
 cast(stratum5 as int) as cnt_yy
,cast(count_val as int) as count_val
from @resultSchema.dq_check_result
where check_id = 'C335'
order by cnt_yy;

--lineChart5 (CDM ContionOccurence : Age distribution of condition occurrence table)
select
 cast(stratum4 as int) as cnt_yy
,count_val
from @resultSchema.dq_check_result
where check_id = 'C192'
and stratum4 is not null
order by cnt_yy;

--lineChart6 (CDM DrugExposure : Age distribution of Drug_exposure table)
select
 cast(stratum4 as int) as cnt_yy
,count_val
from @resultSchema.dq_check_result
where check_id = 'C282'
and stratum4 is not null
order by cnt_yy;

--lineChart7 (CDM DeviceExposure : Age distribution)
select
 cast(stratum4 as int) as cnt_yy
,count_val
from @resultSchema.dq_check_result
where check_id = 'C320'
and stratum4 is not null
order by cnt_yy;

--lineChart8 (CDM ProcesureOccurence : Age distribution)
select
 cast(stratum4 as int) as cnt_yy
,count_val
from @resultSchema.dq_check_result
where check_id = 'C309'
and stratum4 is not null
order by cnt_yy;

--lineChart9 (CDM Mesurement : Age distribution)
select
 cast(stratum4 as int) as cnt_yy
,count_val
from @resultSchema.dq_check_result
where check_id = 'C327'
and stratum4 is not null
order by cnt_yy;