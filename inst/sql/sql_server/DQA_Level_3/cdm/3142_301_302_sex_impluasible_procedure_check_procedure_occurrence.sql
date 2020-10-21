-- Check_id = 301 (procedure for male)
insert into @resultSchema.score_log_CDM
select
 pr1.check_id
,pr1.tb_id
,pr1.stratum1
,pr1.stratum2
,pr1.stratum3
,p1.gender_concept_id as stratum4
,null as stratum5
,pr1.err_no
from
(select
 'C301' as check_id
,32 as tb_id
,'procedure_occurrence' as stratum1
,'procedure_occurrence_id' as stratum2
,procedure_occurrence_id as stratum3
,procedure_occurrence_id as err_no
,person_id
from @cdmSchema.procedure_occurrence
where
procedure_occurrence_id in
(2003947,2003966,2003983,2004031,2004063,2004070,2004090,2004164,2109825
,2109833,2109900,2109902,2109905,2109906,2109916,2109968,2109973,2109981
,2110004,2110011,2110026,2110039,2110044,2211769,2780478,2780523,4073700
,4083772,4096783,4234536,4310552,4321575,4330583)) as pr1
inner join
(select
 person_id
,gender_concept_id
,gender_source_value
from @cdmSchema.person
where gender_concept_id = 8532) as p1
on pr1.person_id = p1.person_id
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum2
,stratum3
,stratum4
,'check the implausible procedure at procedure_occurrence table' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C301'
group by  check_id,tb_id,stratum2,stratum3,stratum4;
--
insert into @resultSchema.score_log_CDM
select
 pr1.check_id
,pr1.tb_id
,pr1.stratum1
,pr1.stratum2
,pr1.stratum3
,p1.gender_concept_id as stratum4
,null as stratum5
,pr1.err_no
from
(select
 'C302' as check_id
,32 as tb_id
,'procedure_occurrence' as stratum1
,'procedure_occurrence_id' as stratum2
,procedure_occurrence_id as stratum3
,procedure_occurrence_id as err_no
,person_id
from @cdmSchema.procedure_occurrence
where
procedure_occurrence_id in
(2004263,2004329,2004342,2004443,2004627,2110078,2110116
,2110142,2110144,2110169,2110175,2110194,2110195,2110203
,2110227,2110230,2110307,2110315,2110316,2110317,2110326
,2211749,2211751,2211753,2211755,2211756,2211757,2211765
,2721063,2721064,4021531,4032622,4038747,4052532,4058792
,4138738,4141940,4146777,4161944,4181912,4238715,4243919
,4294805,4306780,2110222,2211747,2617204,4127886,4275113)) as pr1
inner join
(select
 person_id
,gender_concept_id
,gender_source_value
from @cdmSchema.person
where gender_concept_id = 8507) as p1
on pr1.person_id = p1.person_id
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum2
,stratum3
,stratum4
,'check the implausible procedure at procedure_occurrence table' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id = 'C302'
group by  check_id,tb_id,stratum2,stratum3,stratum4;
