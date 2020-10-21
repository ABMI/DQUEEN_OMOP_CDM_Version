--
IF OBJECT_ID('tempdb..##pastdatacheck', 'U') IS NOT NULL
   DROP TABLE ##pastdatacheck
create table ##pastdatacheck(
       tb_id nvarchar(255)
      ,stratum1 nvarchar(255)
      ,stratum2 nvarchar(255)
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
   , @ETL_stdt1 varchar(max)

set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result
                              where check_id = 'C1' and txt_val = 'Y' and
                              stratum1 in (12,13,14,15,16,18,19,20,24,26,27,28,29,30,32,36,37,38)
                           for xml path('')),1,0,''))
       print(@tbnm)
set @rsltdbname = ''+'@resultSchema'+''
set @targetdbname = ''+'@cdmSchema'+''
set @ETL_stdt1 = ''+@etl_stdt+''
--
while charindex(',',@tbnm) <> 0
begin
  set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
  print(@tbnm1)
  set @colnm= (select stuff(( select c1.stratum4+',' from
                (select stratum1, stratum3, stratum4 from @resultSchema.dq_check_result
                 where check_id = 'C3' and stratum1 in (12,13,14,15,16,18,19,20,24,26,27,28,29,30,32,36,37,38)
                 and stratum5 like '%date%' and stratum3 = ''+@tbnm1+'' ) as c1 --> and txt_val= 'Y'
                        for xml path('')),1,0,''))
   print(@colnm)
WHILE ChARINDEX(',', @colnm) <> 0
BEGIN
 SET @colnm1 = SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1)
 print(@colnm1)
 set @colnm2= (select colnm from @resultSchema.schema_info
               where stage_gb ='cdm' and  sk_yn = 'Y' and tbnm = ''+@tbnm1+'')
   print(@colnm2)
if @colnm1 is not null
           begin
             set @sql= ' IF OBJECT_ID(''tempdb..##cnt'', ''U'') IS NOT NULL DROP TABLE ##cnt;'
                   print(@sql)
                   exec(@sql)
             set @sql1= ' insert into ##pastdatacheck(
 '+
                        'select'+
                        '  s1.tb_id '+
                        ' ,d1.stratum1 '+
                        ' ,d1.stratum2 '+
                        ' ,d1.err_no '+
                        ' from '+
                        '(select '+
                        ''''+@tbnm1+''''+' as stratum1 '+
                        ', '+''''+@colnm1+''''+' as stratum2 '+
                        ', '+@colnm1+' as stratum3 '+
                        ', '+@colnm2+' as err_no '+
                        ' from '+@targetdbname+@tbnm1+
                        ' where '+@colnm1+' < '+''''+@ETL_stdt1+''''+' ) as d1 '+
                        ' inner join '+
                        ' (select distinct tb_id, tbnm from '+@rsltdbname+'schema_info) as s1 '+
                        ' on d1.stratum1 = s1.tbnm '
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
insert into @resultSchema.score_log_meta
select
 case
   when stratum2 in ('condition_era_start_date','condition_era_end_date') then 'C110'
   when stratum2 in ('condition_start_date','condition_start_datetime','condition_end_date','condition_end_datetime') then 'C111'
   when stratum2 in ('death_date','death_datetime') then 'C112'
   when stratum2 in ('device_exposure_start_date','device_exposure_start_datetime','device_exposure_end_date','device_exposure_end_datetime') then 'C113'
   when stratum2 in ('dose_era_start_date','dose_era_end_date') then 'C114'
   when stratum2 in ('drug_exposure_start_date','drug_exposure_start_datetime','drug_exposure_end_date','drug_exposure_end_datetime') then 'C115'
   when stratum2 in ('measurement_date','measurement_datetime') then 'C116'
   when stratum2 in ('note_date','note_datetime') then 'C117'
   when stratum2 in ('nlp_date','nlp_datetime') then 'C118'
   when stratum2 in ('observation_date','observation_datetime') then 'C119'
   when stratum2 in ('observation_period_start_date','observation_period_end_date') then 'C120'
   when stratum2 in ('payer_plan_period_start_date','payer_plan_period_end_date') then 'C121'
   when stratum2 in ('procedure_date','procedure_datetime') then 'C122'
   when stratum2 in ('specimen_date','specimen_datetime') then 'C123'
   when stratum1 = 'visit_detail' and
        stratum2 in ('visit_detail_start_date','visit_detail_start_datetime','visit_detail_end_date','visit_detail_end_datetime') then 'C124'
   when stratum1 = 'visit_occurrence' and
        stratum2 in ('visit_start_date','visit_start_datetime','visit_end_date','visit_end_datetime') then 'C125'
  end as check_id
,tb_id
,stratum1 --> tbnm
,stratum2 --> colnm
,null as stratum3
,null as stratum4
,null as stratum5
,err_no
from ##pastdatacheck
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,case
  when check_id = 'C110' then 'check the future data at '+stratum1
  when check_id = 'C111' then 'check the future data at '+stratum1
  when check_id = 'C112' then 'check the future data at '+stratum1
  when check_id = 'C113' then 'check the future data at '+stratum1
  when check_id = 'C114' then 'check the future data at '+stratum1
  when check_id = 'C115' then 'check the future data at '+stratum1
  when check_id = 'C116' then 'check the future data at '+stratum1
  when check_id = 'C117' then 'check the future data at '+stratum1
  when check_id = 'C118' then 'check the future data at '+stratum1
  when check_id = 'C119' then 'check the future data at '+stratum1
  when check_id = 'C120' then 'check the future data at '+stratum1
  when check_id = 'C121' then 'check the future data at '+stratum1
  when check_id = 'C122' then 'check the future data at '+stratum1
  when check_id = 'C123' then 'check the future data at '+stratum1
  when check_id = 'C124' then 'check the future data at '+stratum1
  when check_id = 'C125' then 'check the future data at '+stratum1
  else null
  end as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_cdm
where
check_id in ('C110','C111','C112','C113','C114','C115','C116','C117','C118','C119','C120','C121','C122','C123','C124','C125')
group by check_id,tb_id,stratum1,stratum2;
