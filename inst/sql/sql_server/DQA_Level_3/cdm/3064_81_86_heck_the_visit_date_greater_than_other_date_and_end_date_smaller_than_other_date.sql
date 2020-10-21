IF OBJECT_ID('tempdb..##validationrslt', 'U') IS NOT NULL
   DROP TABLE ##validationrslt
-- create temp table
create table ##validationrslt(
       check_id nvarchar(255)
      ,tb_id nvarchar(255)
      ,stratum1 nvarchar(255)
      ,stratum2 nvarchar(255)
      ,stratum3 nvarchar(255)
      ,stratum4 nvarchar(255)
      ,stratum5 nvarchar(255)
      ,err_no   nvarchar(255))
-- Declare pl variable
declare
     @tbnm varchar(max)
   , @tbnm_v varchar(max)
   , @tbnm1 varchar(max)
   , @tbnm2 varchar(max)
   , @colnm varchar(max)
   , @colnm1 varchar(max)
   , @colnm2 varchar(max)
   , @colnm2_1 varchar(max)
   , @colnm3 varchar(max)
   , @colnm4 varchar(max)
   , @sql1 varchar(max)
   , @sql2 varchar(max)
   , @temp_resultSchema varchar(max)
   , @targetSchema1 varchar(max)

--> validation table list
set @tbnm_v= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result
            where check_id = 'C1' and txt_val = 'Y'and stratum3 in ('visit_occurrence','observation_period')
            for xml path('')),1,0,''))
print(@tbnm_v)
-- Schema information
set @temp_resultSchema = ''+'@resultSchema'+''
set @targetSchema1 = ''+'@cdmSchema'+''
--
while charindex(',',@tbnm_v) <> 0
begin
set @tbnm2=substring(@tbnm_v, 1, charindex(',',@tbnm_v) -1)
print(@tbnm2)
--
set @colnm3=(select stuff(( select colnm+',' from
            (select colnm from @resultSchema.schema_info
            where colnm in ('visit_start_date','visit_start_datetime','visit_end_date','visit_end_datetime','observation_period_start_date','observation_period_end_date')
            and tbnm = ''+@tbnm2+'') as c1
            for xml path('')),1,0,''))
print(@colnm3)
--
WHILE ChARINDEX(',', @colnm3) <> 0
BEGIN
SET @colnm4 = SUBSTRING( @colnm3, 1, CHARINDEX(',', @colnm3) - 1)
print(@colnm4)
-- validation col name
--> target table list
set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result
            where check_id = 'C1' and txt_val = 'Y'
            and stratum3 in ('condition_era','condition_occurrence','device_exposure','dose_era','drug_era','drug_exposure','measurement'
            ,'note','observation','payer_plan_period','procedure_occurrence','specimen') --note_nlp
            for xml path('')),1,0,''))
print(@tbnm)

  --
while charindex(',',@tbnm) <> 0
-- validation table name slice
begin
-- target table name slice
set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
print(@tbnm1)
-- colname of target table
set @colnm= (select stuff(( select c1.stratum4+',' from
             (select stratum1, stratum3, stratum4 from @resultSchema.dq_check_result
              where check_id = 'C3' and stratum2 = 'cdm' and txt_val= 'Y'
              and stratum3 in ('condition_era','condition_occurrence','device_exposure','dose_era','drug_era','drug_exposure','measurement'
              ,'note','observation','payer_plan_period','procedure_occurrence','specimen')
              and stratum5 like '%date%'
              and stratum3 = ''+@tbnm1+'') as c1
              for xml path('')),1,0,''))
print(@colnm)
--
set @colnm2= (select stuff(( select colnm+',' from
            (select colnm from @resultSchema.schema_info
                                   where stage_gb ='cdm' and  sk_yn = 'Y' and tbnm = ''+@tbnm1+'') as c1
            for xml path('')),1,0,''))
print(@colnm2)
-- check start
WHILE ChARINDEX(',', @colnm) <> 0
-- target col name slice
BEGIN
SET @colnm1 = SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1)
print(@colnm1)
-- Pk
SET @colnm2_1 = SUBSTRING( @colnm2, 1, CHARINDEX(',', @colnm2) - 1)
print(@colnm2_1)
-- check the visit_date > @colnm1
if (@tbnm2 = 'visit_occurrence' and @colnm4= 'visit_start_date') and @tbnm1 in ('condition_occurrence','device_exposure','drug_exposure','measurement','note','observation','procedure_occurrence')
            begin
                 set @sql1='insert into ##validationrslt'+
                           ' select '+
                           ''''+'C81'+''''+' as check_id '+
                           ' ,s1.tb_id '+
                           ' ,dv1.* '+
                           ' from '+
                           ' (select '+
                           ''''+@tbnm1+''''+' as stratum1 '+
                           ','+''''+@colnm1+''''+' as stratum2 '+
                           ', '+''''+'visit_start_date > '+@colnm1+''''+' as stratum3 '+
                           ' ,d1.visit_occurrence_id as stratum4 '+
                           ' ,'+''''+'visit_start_date'+''''+' as stratum5 '+
                           ' ,d1.'+@colnm2_1+' as err_no '+
                           ' from '+
                           ' (select '+
                             +@colnm2_1+
                           ' ,'+@colnm1+
                           ' ,visit_occurrence_id '+
                           ' from '+@targetSchema1+@tbnm1+') as d1 '+
                           ' inner join '+
                           ' (select '+
                             'visit_occurrence_id'+
                           ' ,'+@colnm4+
                           ' from '+@targetSchema1+@tbnm2+' ) as v1 '+
                           ' on d1.visit_occurrence_id = v1.visit_occurrence_id'+
                           ' where v1.'+@colnm4+' > d1.'+@colnm1+' ) as dv1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1 '+
                           ' on s1.tbnm = dv1.stratum1 '
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
-- check the visit_time > @colnm1
if (@tbnm2 = 'visit_occurrence' and @colnm4= 'visit_start_date') and @tbnm1 in ('condition_occurrence','device_exposure','drug_exposure','measurement','note','observation','procedure_occurrence')
            begin
                 set @sql1='insert into ##validationrslt'+
                           ' select '+
                           ''''+'C82'+''''+' as check_id '+
                           ' ,s1.tb_id '+
                           ' ,dv1.* '+
                           ' from '+
                           ' (select '+
                           ''''+@tbnm1+''''+' as stratum1 '+
                           ','+''''+@colnm1+''''+' as stratum2 '+
                           ', '+''''+'visit_start_date > '+@colnm1+''''+' as stratum3 '+
                           ' ,d1.visit_occurrence_id as stratum4 '+
                           ' ,'+''''+'visit_start_date'+''''+' as stratum5 '+
                           ' ,d1.'+@colnm2_1+' as err_no '+
                           ' from '+
                           ' (select '+
                             +@colnm2_1+
                           ' ,'+@colnm1+
                           ' ,visit_occurrence_id '+
                           ' from '+@targetSchema1+@tbnm1+') as d1 '+
                           ' inner join '+
                           ' (select '+
                             'visit_occurrence_id'+
                           ' ,'+@colnm4+
                           ' from '+@targetSchema1+@tbnm2+' ) as v1 '+
                           ' on d1.visit_occurrence_id = v1.visit_occurrence_id'+
                           ' where v1.'+@colnm4+' > d1.'+@colnm1+' ) as dv1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1 '+
                           ' on s1.tbnm = dv1.stratum1 '
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
-- check the dsch_date < @colnm1
if (@tbnm2 = 'visit_occurrence' and @colnm4= 'visit_end_date') and @tbnm1 in ('condition_occurrence','device_exposure','drug_exposure','measurement','note','observation','procedure_occurrence')
            begin
                set @sql1='insert into ##validationrslt'+
                           ' select '+
                           ''''+'C83'+''''+' as check_id '+
                           ' ,s1.tb_id '+
                           ' ,dv1.* '+
                           ' from '+
                           ' (select '+
                           ''''+@tbnm1+''''+' as stratum1 '+
                           ','+''''+@colnm1+''''+' as stratum2 '+
                           ', '+''''+'visit_end_date < '+@colnm1+''''+' as stratum3 '+
                           ' ,d1.visit_occurrence_id as stratum4 '+
                           ' ,'+''''+'visit_end_date'+''''+' as stratum5 '+
                           ' ,d1.'+@colnm2_1+' as err_no '+
                           ' from '+
                           ' (select '+
                             +@colnm2_1+
                           ' ,'+@colnm1+
                           ' ,visit_occurrence_id '+
                           ' from '+@targetSchema1+@tbnm1+') as d1 '+
                           ' inner join '+
                           ' (select '+
                             'visit_occurrence_id'+
                           ' ,'+@colnm4+
                           ' from '+@targetSchema1+@tbnm2+' ) as v1 '+
                           ' on d1.visit_occurrence_id = v1.visit_occurrence_id'+
                           ' where v1.'+@colnm4+' < d1.'+@colnm1+' ) as dv1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1 '+
                           ' on s1.tbnm = dv1.stratum1 '
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
-- check the dsch_time < @colnm1
if (@tbnm2= 'visit_occurrence' and @colnm4= 'visit_end_datetime') and @tbnm1 in ('condition_occurrence','device_exposure','drug_exposure','measurement','note','observation','procedure_occurrence')
            begin
                set @sql1='insert into ##validationrslt'+
                           ' select '+
                           ''''+'C84'+''''+' as check_id '+
                           ' ,s1.tb_id '+
                           ' ,dv1.* '+
                           ' from '+
                           ' (select '+
                           ''''+@tbnm1+''''+' as stratum1 '+
                           ','+''''+@colnm1+''''+' as stratum2 '+
                           ', '+''''+'visit_end_datetime < '+@colnm1+''''+' as stratum3 '+
                           ' ,d1.visit_occurrence_id as stratum4 '+
                           ' ,'+''''+'visit_end_datetime'+''''+' as stratum5 '+
                           ' ,d1.'+@colnm2_1+' as err_no '+
                           ' from '+
                           ' (select '+
                             +@colnm2_1+
                           ' ,'+@colnm1+
                           ' ,visit_occurrence_id '+
                           ' from '+@targetSchema1+@tbnm1+') as d1 '+
                           ' inner join '+
                           ' (select '+
                             'visit_occurrence_id'+
                           ' ,'+@colnm4+
                           ' from '+@targetSchema1+@tbnm2+' ) as v1 '+
                           ' on d1.visit_occurrence_id = v1.visit_occurrence_id'+
                           ' where v1.'+@colnm4+' < d1.'+@colnm1+' ) as dv1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1 '+
                           ' on s1.tbnm = dv1.stratum1 '
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
-- check the min_dt > @colnm1
if @tbnm2 = 'observation_period' and @colnm4= 'observation_period_end_date'
            begin
                 set @sql1='insert into ##validationrslt'+
                           ' select '+
                           ''''+'C86'+''''+' as check_id '+
                           ' ,s1.tb_id '+
                           ' ,dv1.* '+
                           ' from '+
                           ' (select '+
                           ''''+@tbnm1+''''+' as stratum1 '+
                           ','+''''+@colnm1+''''+' as stratum2 '+
                           ', '+''''+'observation_period_end_date < '+@colnm1+''''+' as stratum3 '+
                           ' ,null as stratum4 '+
                           ' ,'+''''+'observation_period_end_date'+''''+' as stratum5 '+
                           ' ,d1.'+@colnm2_1+' as err_no '+
                           ' from '+
                           ' (select '+
                             @colnm2_1+
                           ' ,'+@colnm1+
                           ' ,person_id'+
                           ' from '+@targetSchema1+@tbnm1+') as d1 '+
                           ' inner join '+
                           ' (select distinct '+
                             'person_id'+
                           ' ,'+@colnm4+
                           ' from '+@targetSchema1+@tbnm2+' ) as v1 '+
                           ' on d1.person_id = v1.person_id'+
                           ' where v1.'+@colnm4+' < d1.'+@colnm1+' ) as dv1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1 '+
                           ' on s1.tbnm = dv1.stratum1 '
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
-- check the max_dt < @colnm1
if @tbnm2 = 'observation_period' and @colnm4= 'observation_period_start_date'
            begin
                 set @sql1='insert into ##validationrslt'+
                           ' select '+
                           ''''+'C85'+''''+' as check_id '+
                           ' ,s1.tb_id '+
                           ' ,dv1.* '+
                           ' from '+
                           ' (select '+
                           ''''+@tbnm1+''''+' as stratum1 '+
                           ','+''''+@colnm1+''''+' as stratum2 '+
                           ', '+''''+'observation_period_start_date > '+@colnm1+''''+' as stratum3 '+
                           ' ,null as stratum4 '+
                           ' ,'+''''+'min_dt'+''''+' as stratum5 '+
                           ' ,d1.'+@colnm2_1+' as err_no '+
                           ' from '+
                           ' (select '+
                             @colnm2_1+
                           ' ,'+@colnm1+
                           ' ,person_id'+
                           ' from '+@targetSchema1+@tbnm1+') as d1 '+
                           ' inner join '+
                           ' (select distinct '+
                             'person_id'+
                           ' ,'+@colnm4+
                           ' from '+@targetSchema1+@tbnm2+' ) as v1 '+
                           ' on d1.person_id = v1.person_id'+
                           ' where v1.'+@colnm4+' > d1.'+@colnm1+' ) as dv1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1 '+
                           ' on s1.tbnm = dv1.stratum1 '
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end

          PRINT( SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1 ) )
       SET @colnm = SUBSTRING( @colnm, CHARINDEX(',', @colnm) + 1, LEN(@colnm) )
       end
   SET @tbnm = SUBSTRING( @tbnm, CHARINDEX(',', @tbnm) + 1, LEN(@tbnm) )
  end
SET @colnm3 = SUBSTRING( @colnm3, CHARINDEX(',', @colnm3) + 1, LEN(@colnm3) )
     end
 SET @tbnm_v = SUBSTRING( @tbnm_v, CHARINDEX(',', @tbnm_v) + 1, LEN(@tbnm_v) )
end
--
insert into @resultSchema.score_log_CDM
select
 *
from ##validationrslt
--
insert into @resultSchema.dq_check_result
select
 check_id
,stratum1
,stratum2
,stratum3
,stratum4
,case
   when check_id in ('C81','C83','C85') then stratum2+' greater than '+stratum3+'('+stratum4+')'
   when check_id in ('C82','C84','C86') then stratum2+' smaller than '+stratum3+'('+stratum4+')'
   else null
 end as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id as stratum1
,stratum5 as stratum2
,stratum2 as stratum3
,stratum3 as stratum4
,count(*) as count_val
from @resultSchema.score_log_CDM
where
check_id in ('C81','C82','C83','C84','C85','C86')
group by check_id, tb_id, stratum5,stratum2, stratum3)v
