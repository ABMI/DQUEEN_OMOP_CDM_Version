IF OBJECT_ID('tempdb..##agecheck', 'U') IS NOT NULL
   DROP TABLE ##agecheck
create table ##agecheck(
       tb_id nvarchar(255)
      ,stratum1 nvarchar(255)
      ,stratum2 nvarchar(255)
      ,stratum3 nvarchar(255)
      ,err_no nvarchar(255) )
  --
declare
     @tbnm varchar(max)
   , @tbnm1 varchar(max)
   , @colnm varchar(max)
   , @colnm1 varchar(max)
   , @colnm2 varchar(max)
   , @sql varchar(max)
   , @sql1 varchar(max)
   , @sql2 varchar(max)
   , @rsltdbname varchar(max)
   , @targetdbname varchar(max)

set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result
                              where check_id = 'C1' and txt_val = 'Y' and stratum1 in (12,13,14,15,16,18,19,20,24,26,28,29,30,32,36,37,38)
                           for xml path('')),1,0,''))
       print(@tbnm)
set @rsltdbname = ''+'@resultSchema'+''
set @targetdbname = ''+'@cdmSchema'+''

--
while charindex(',',@tbnm) <> 0
begin
  set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
  print(@tbnm1)
  set @colnm= (select stuff(( select c1.stratum4+',' from
                          (select stratum1, stratum3, stratum4 from @resultSchema.dq_check_result
                            where check_id = 'C3'and stratum5 like '%date%'and stratum1 in (12,13,14,15,16,18,19,20,24,26,28,29,30,32,36,37,38)
															 and stratum3 = ''+@tbnm1+'' ) as c1 --> and txt_val= 'Y'
                        for xml path('')),1,0,''))
   print(@colnm)
WHILE ChARINDEX(',', @colnm) <> 0
BEGIN
 SET @colnm1 = SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1)
 print(@colnm1)
 set @colnm2= (select colnm from @resultSchema.schema_info
               where stage_gb ='CDM' and  sk_yn = 'Y' and tbnm = ''+@tbnm1+'')
   print(@colnm2)
if @colnm1 is not null
           begin
             set @sql= ' IF OBJECT_ID(''tempdb..##cnt'', ''U'') IS NOT NULL DROP TABLE ##cnt;'
                   print(@sql)
                   exec(@sql)
             set @sql1= ' insert into ##agecheck '+
                        ' select '+
                        '  s1.tb_id '+
                        ' ,d1.stratum1 '+
                        ' ,d1.stratum2 '+
                        ' ,d1.stratum3 '+
                        ' ,d1.err_no '+
                        ' from '+
                        ' (select '+
                        ''''+@tbnm1+''''+' as stratum1 '+
                        ' , '+''''+@colnm1+''''+' as stratum2 '+
                        ' , (datediff(day, p1.birth_datetime,v1.'+@colnm1+')/365) as stratum3 '+
                        ' ,v1.err_no '+
                        ' from '+
                        ' (select '+
                         @colnm2+' as err_no '+
                        ' , person_id '+
                        ' ,'+@colnm1+
                        ' from '+@targetdbname+@tbnm1+' ) as v1'+
                        ' left join '+
                        ' (select '+
                        '  person_id '+
                        ' ,birth_datetime '+
                        ' from '+@targetdbname+'person) as p1 '+
                        ' on p1.person_id = v1.person_id  '+
                        ' where (datediff(day, p1.birth_datetime,v1.'+@colnm1+')/365)>149) as d1 '+
                        ' inner join '+
                        ' (select distinct tb_id, tbnm from '+@rsltdbname+'.schema_info) as s1 '+
                        ' on s1.tbnm = d1.stratum1 '
--

                   print(@sql1)
                   exec(@sql1)
               end
       else
           begin
               set @sql2 = 'end'
                   print(@sql2)
               end

            PRINT( SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1 ) )
       SET @colnm = SUBSTRING( @colnm, CHARINDEX(',', @colnm) + 1, LEN(@colnm) )
  end
  SET @tbnm = SUBSTRING( @tbnm, CHARINDEX(',', @tbnm) + 1, LEN(@tbnm) )
end
--
insert into @resultSchema.score_log_cdm
select
case
   when stratum2 in ('condition_era_start_date','condition_era_end_date') then 'C168'
   when stratum2 in ('condition_start_date','condition_start_datetime','condition_end_date','condition_end_datetime') then 'C169'
   when stratum2 in ('death_date','death_datetime') then 'C170'
   when stratum2 in ('device_exposure_start_date','device_exposure_start_datetime','device_exposure_end_date','device_exposure_end_datetime') then 'C171'
   when stratum2 in ('dose_era_start_date','dose_era_end_date') then 'C172'
   when stratum2 in ('drug_exposure_start_date','drug_exposure_start_datetime','drug_exposure_end_date','drug_exposure_end_datetime') then 'C173'
   when stratum2 in ('measurement_date','measurement_datetime') then 'C174'
   when stratum2 in ('note_date','note_datetime') then 'C175'
   when stratum2 in ('observation_date','observation_datetime') then 'C176'
   when stratum2 in ('observation_period_start_date','observation_period_end_date') then 'C177'
   when stratum2 in ('payer_plan_period_start_date','payer_plan_period_end_date') then 'C178'
   when stratum2 in ('procedure_date','procedure_datetime') then 'C179'
   when stratum2 in ('specimen_date','specimen_datetime') then 'C180'
--   when stratum2 in ('visit_detail_start_date','visit_detail_start_datetime','visit_detail_end_date','visit_detail_end_datetime') then 'C124'
   when stratum1 = 'visit_detail' and
        stratum2 in ('visit_detail_start_date','visit_detail_start_datetime','visit_detail_end_date','visit_detail_end_datetime') then 'C181'
   when stratum1 = 'visit_occurrence' and
        stratum2 in ('visit_start_date','visit_start_datetime','visit_end_date','visit_end_datetime') then 'C182'
 else null
end as check_id
,tb_id
,stratum1
,stratum2
,stratum3
,'age' as stratum4
,null as stratum5
,err_no
from ##agecheck;
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum2 as stratum2
,'age' as stratum3
,null as stratum4
,'check the data that occurred before birth date'
,count(*) as count_val
,null as num_val
,null as txt_val
from
(select
*
from @resultSchema.score_log_cdm
where check_id in ('C168','C169','C170','C171','C172','C173','C174','C175','C176','C177','C178','C179','C180','C181','C182'))v
group by  check_id,tb_id,stratum2
--