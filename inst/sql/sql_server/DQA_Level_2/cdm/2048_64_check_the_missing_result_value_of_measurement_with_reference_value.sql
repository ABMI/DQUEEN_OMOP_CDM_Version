--
insert into @resultSchema.score_log_meta
select
 check_id
,tb_id
,stratum1
,stratum2
,stratum3
,stratum4
,stratum5
,err_no
from
(select
 d1.check_id
,d1.tb_id
,m1.tbnm as stratum1
,case
   when m1.value_as_number is null or m1.value_as_number = '' then 'value_as_concept_id'
   when cast(m1.value_as_concept_id as varchar) is null or cast(m1.value_as_concept_id as varchar) = '' then 'value_as_number'
   else null
 end as stratum2
,m1.MEASUREMENT_concept_id as stratum3
,d1.stratum3 as stratum4
,d1.stratum4 as stratum5
,m1.MEASUREMENT_id as err_no
,case
  when m1.value_as_concept_id is not null  and (d1.stratum3 = 'Numeric' and d1.stratum4 is null) then 'YN'
  when m1.value_as_number is not null and (d1.stratum3 = 'TEXT' and d1.stratum4 is null) then 'YT'
  when (m1.value_as_number is null and m1.value_as_concept_id is null) and (d1.stratum3 = 'Category' and d1.stratum4 is null)
  then 'YC'
  when (m1.value_as_number is null and m1.value_as_concept_id is null)
  and (d1.stratum3 in('TEXT','Category','Numeric') and d1.stratum4 is not null) then 'YA'
  else 'N'
 end as err_gb
from
(select
 'measurement' as tbnm
,measurement_concept_id
,value_as_number
,value_as_concept_id
,measurement_id
from @cdmSchema.measurement) as m1
left join
(select
 check_id
,24 as tb_id
,stratum1
,stratum3
,stratum4
from @resultSchema.dq_check where check_id = 'C64'
and stratum1 not in (0) ) as d1
on d1.stratum1 = m1.measurement_concept_id )v
where err_gb in('YN','YT','YC','YA')

--
insert into @resultSchema.dq_check_result
select
 check_id
,stratum1
,stratum2
,stratum3
,stratum4
,case
   when stratum4 = 'YN' then  'This measurement data type of result value should be nuemric but value_as_number is missing'
   when stratum4 = 'YT' then  'This measurement data type of result value should be TEXT but value_as_concept_id is missing'
   when stratum4 in ('YC','YA') then  'This measurement data type of result value should be all data type but value_as_number or value_as_concept_id is missing'
   else null
 end as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id as stratum1
,stratum2 as stratum2
,stratum3 as stratum3
,stratum4 as stratum4
, count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_meta
where check_id = 'C64'
group by check_id, tb_id, stratum2, stratum3, stratum4)v