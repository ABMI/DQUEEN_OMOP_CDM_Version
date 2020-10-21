--bar__vertial1 (META Person : Year of birth distribution)
select
 stratum1
,sum(cast(count_val as int)) as count_val
from
(select
  substring(stratum5,1,4) as stratum1
  ,count_val
  from @resultSchema.dq_check_result
  where check_id = 'C158')v
where stratum1 is not null
group by stratum1;

--bar__vertial2 (CDM Person : Year of birth distribution)
select
 stratum1
,sum(cast(count_val as int)) as count_val
from
(select
  substring(stratum5,1,4) as stratum1
  ,count_val
  from @resultSchema.dq_check_result
  where check_id = 'C158')v
where stratum1 is not null
group by stratum1;