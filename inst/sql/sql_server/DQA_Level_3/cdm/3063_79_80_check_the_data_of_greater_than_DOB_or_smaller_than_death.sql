--
use @cdm;  --> meta db name
--
IF OBJECT_ID('tempdb..##compare', 'U') IS NOT NULL
DROP TABLE ##compare
--
create table ##compare(
       check_id nvarchar(255)
      ,tb_id nvarchar(255)
      ,stratum1 nvarchar(255)
      ,stratum2 nvarchar(255)
      ,stratum3 nvarchar(255)
      ,stratum4 nvarchar(255)
      ,stratum5 nvarchar(255)
      ,err_no   nvarchar(255))
  --
declare
     @tbnm varchar(max)
   , @tbnm_v varchar(max)
   , @tbnm1 varchar(max)
   , @tbnm2 varchar(max)
   , @colnm varchar(max)
   , @colnm1 varchar(max)
   , @colnm2 varchar(max)
   , @sql varchar(max)
   , @sql1 varchar(max)
   , @sql2 varchar(max)
   , @temp_resultSchema varchar(max)
   , @targetSchema1 varchar(max)

set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result--> result db name으로 변경
            where check_id = 'C1' and txt_val = 'Y' and stratum3 in ('condition_era','condition_occurrence','cost','device_exposure'
            ,'dose_era','drug_era','drug_exposure','measurement','note','observation','observation_period'
            ,'payer_plan_period','procedure_occurrence','specimen','visit_detail','visit_occurrence')
            for xml path('')),1,0,''))
       print(@tbnm)
set @tbnm_v= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result--> result db name으로 변경
            where check_id = 'C1' and txt_val = 'Y'and stratum3 in ('person','death')
            for xml path('')),1,0,''))
       print(@tbnm_v)
set @temp_resultSchema = ''+'@resultSchema'+''
set @targetSchema1 = ''+'@cdmSchema'+''

while charindex(',',@tbnm) <> 0
begin
   set @tbnm2=substring(@tbnm_v, 1, charindex(',',@tbnm_v) -1)
    print(@tbnm2)

      set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
        print(@tbnm1)

           set @colnm= (select stuff(( select c1.stratum4+',' from
                          (select stratum1, stratum3, stratum4 from @resultSchema.dq_check_result
                            where check_id = 'C3' and stratum2 = 'cdm' and txt_val= 'Y'
                             and stratum3 in ('condition_era','condition_occurrence','cost','device_exposure'
                              ,'dose_era','drug_era','drug_exposure','measurement','note','observation','observation_period'
                              ,'payer_plan_period','procedure_occurrence','specimen','visit_detail','visit_occurrence')
                              and stratum5 like '%date%'
                              and stratum3 = ''+@tbnm1+'') as c1
                           for xml path('')),1,0,''))
       print(@colnm)

       set @colnm2= (select colnm from @resultSchema.schema_info
                                   where stage_gb ='CDM' and  sk_yn = 'Y' and tbnm = ''+@tbnm1+'')
       print(@colnm2)

       WHILE ChARINDEX(',', @colnm) <> 0
           BEGIN
             SET @colnm1 = SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1)
--
        if @colnm1 is not null
           begin
               set @sql= ' IF OBJECT_ID(''tempdb..##cnt'', ''U'') IS NOT NULL DROP TABLE ##cnt;'
                   print(@sql)
                   exec(@sql)

--
          if @tbnm2 = 'person'
            begin
                 set @sql1='insert into ##compare '+
                           ' select '+
                           ''''+'C79'+''''+' as check_id '+
                           ' ,s1.tb_id '+
                           '  ,d1.* '+
                           '  from '+
                           '  (select '+
                           ''''+@tbnm1+''''+' as stratum1 '+
                           ','+''''+'birth_datetime'+''''+' as stratum2'+
                           ','+''''+@colnm1+''''+' as stratum3 '+
                           ','+''''+'birth_datetime > '+@colnm1+''''+' as stratum4 '+
                           ',null as stratum5 '+
                           ',v1.'+@colnm2+' as err_no '+
                           ' from '+
                           ' (select '+
                             @colnm2+
                           ' ,person_id '+
                           ' ,'+@colnm1+
                           '  from '+@targetSchema1+@tbnm1+') as v1'+
                           ' inner join '+
                           ' (select '+
                           '  person_id '+
                           ' ,birth_datetime '+
                           '  from '+@targetSchema1+@tbnm2+' )as p1 '+
                           ' on p1.person_id = v1.person_id '+
                           ' where p1.birth_datetime > v1.'+@colnm1+') as d1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1 '+
                           '  on d1.stratum1 = s1.tbnm'
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
          if @tbnm2 = 'death'
            begin
                 set @sql1='insert into ##compare '+
                           ' select '+
                           ''''+'C80'+''''+' as check_id '+
                           ' ,s1.tb_id '+
                           '  ,d1.* '+
                           '  from '+
                           '  (select '+
                           ''''+@tbnm1+''''+' as stratum1 '+
                           ', '+''''+'death_datetime'+''''+' as stratum2' +
                           ','+''''+@colnm1+''''+' as stratum3 '+
                           ','+''''+'death_datetime < '+@colnm1+''''+' as stratum4 '+
                           ',null as stratum5 '+
                           ',v1.'+@colnm2+' as err_no '+
                           ' from '+
                           ' (select '+
                             @colnm2+
                           ' ,person_id '+
                           ' ,'+@colnm1+
                           '  from '+@targetSchema1+@tbnm1+') as v1'+
                           ' inner join '+
                           ' (select '+
                           '  person_id '+
                           ' ,death_datetime '+
                           '  from '+@targetSchema1+@tbnm2+' )as p1 '+
                           ' on p1.person_id = v1.person_id '+
                           ' where p1.death_datetime < v1.'+@colnm1+') as d1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1 '+
                           '  on d1.stratum1 = s1.tbnm'
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
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
end;
--
insert into @resultSchema.score_log_CDM
select
 check_id
,tb_id
,stratum1
,stratum3 as stratum2
,stratum2 as stratum3
,stratum4
,stratum5
,err_no
from ##compare;
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum2 as stratum2
,stratum3 as stratum3
,null as stratum4
,case
  when stratum2 = 'birth_datetime' then 'birth date greater than '+stratum3+'('+stratum4+')'
  when stratum2 = 'death_datetime' then 'death date smaller than  '+stratum3+'('+stratum4+')'
  else null
 end as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_cdm
where check_id in ('C79','C80')
group by check_id, tb_id, stratum2, stratum3, stratum4
--
