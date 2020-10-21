use @cdm;  --> meta db name
--
IF OBJECT_ID('tempdb..##datatype', 'U') IS NOT NULL
DROP TABLE ##datatype

create table ##datatype(
       tb_id nvarchar(255)
      ,tbnm nvarchar(255)
      ,colnm nvarchar(255)
      ,data_type nvarchar(255)
      ,err_no nvarchar(255) )
  --
declare
     @tbnm varchar(max)
   , @tbnm1 varchar(max)
   , @colnm varchar(max)
   , @colnm1 varchar(max)
   , @colnm2 varchar(max)
   , @colnm3 varchar(max)
   , @colnm4 varchar(max)
   , @sql varchar(max)
   , @sql1 varchar(max)
   , @sql2 varchar(max)
   , @temp_resultSchema varchar(max)

set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result
                              where check_id = 'C1' and stratum1 in (2,7,12,13,14,15,16,18,19,20,21,23,24,26,27,28,29,30,31,32,33,36,37,38)
                                and txt_val = 'Y'
                           for xml path('')),1,0,''))
       print(@tbnm)
set @temp_resultSchema = ''+'@resultSchema'+''
while charindex(',',@tbnm) <> 0

begin
      set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
        print(@tbnm1)
           set @colnm= (select stuff(( select c1.stratum4+',' from
                          (select stratum1, stratum3, stratum4 from @resultSchema.dq_check_result
                            where check_id = 'C3'
                            and txt_val= 'Y'
                              and stratum3 = ''+@tbnm1+'') as c1
                           for xml path('')),1,0,''))
       print(@colnm)

       set @colnm2= (select colnm from @resultSchema.schema_info
                                   where stage_gb ='CDM' and  sk_yn = 'Y' and tbnm = ''+@tbnm1+'')
       print(@colnm2)

       WHILE ChARINDEX(',', @colnm) <> 0
           BEGIN
             SET @colnm1 = SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1)
             print(@colnm1)
             SET @colnm3 = (select stratum5 from @resultSchema.dq_check_result
                            where check_id = 'C3' and stratum3 =''+@tbnm1+'' and stratum4 = ''+@colnm1+'')
             print(@colnm3)
             SET @colnm4 = (select character_maximum_length from @resultSchema.schema_info
                            where stage_gb = 'CDM' and tbnm =''+@tbnm1+'' and colnm = ''+@colnm1+'')
             print(@colnm4)

--
        if @colnm1 is not null
           begin
               set @sql= ' IF OBJECT_ID(''tempdb..##cnt'', ''U'') IS NOT NULL DROP TABLE ##cnt;'
                   print(@sql)
                   exec(@sql)
--
          if @colnm3 in ('bigint','int','smallint','tinyint','numeric')
            begin
                 set @sql1='insert into ##datatype select '+
                            's1.tb_id '+
                            ',v1.tbnm '+
                            ',v1.colnm '+
                            ',v1.data_type '+
                            ',v1.err_no '+
                            ' from '+
                            '(select
                            '+''''+@tbnm1+''''+' as tbnm '+
                            ','+''''+@colnm1+''''+' as colnm '+
                            ','+''''+@colnm3+''''+' as data_type'+
                            ','+@colnm2+' as err_no '+
                            ' from  '+@tbnm1+
                            ' where isnumeric(cast('+@colnm1+' as varchar)) = 0'+
                            'and '+@colnm1+' is not null )  as v1'+
                            ' inner join (select distinct '+
                                        'tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1
                             on s1.tbnm = v1.tbnm'

                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
           if @colnm3 in('datetime')
            begin
                 set @sql1='insert into ##datatype select '+
                            's1.tb_id '+
                            ',v1.tbnm '+
                            ',v1.colnm '+
                            ',v1.data_type '+
                            ',v1.err_no '+
                            ' from '+
                            '(select
                            '+''''+@tbnm1+''''+' as tbnm '+
                            ','+''''+@colnm1+''''+' as colnm '+
                            ','+''''+@colnm3+''''+' as data_type'+
                            ','+'case '+
                            ' when isdate('+@colnm1+') = 1 then '+''''+'N'+''''+
                            ' else '+''''+'Y'+''''+
                            ' end as err_gb '+
                            ','+@colnm2+' as err_no '+
                            ' from  '+@tbnm1+
                            ' where '+@colnm1+' is not null )  as v1'+
                            ' inner join (select distinct '+
                                        'tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1
                             on s1.tbnm = v1.tbnm'+
                            ' where  v1.err_gb = '+''''+'Y'+''''

                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
           if @colnm3 in('date')
            begin
                 set @sql1='insert into ##datatype select '+
                            's1.tb_id '+
                            ',v1.tbnm '+
                            ',v1.colnm '+
                            ',v1.data_type '+
                            ',v1.err_no '+
                            ' from '+
                            '(select
                            '+''''+@tbnm1+''''+' as tbnm '+
                            ','+''''+@colnm1+''''+' as colnm '+
                            ','+''''+@colnm3+''''+' as data_type'+
                            ','+'case '+
                            ' when len(cast('+@colnm1+' as varchar)) = 10 then '+''''+'N'+''''+
                            ' when isnumeric(replace('+@colnm1+','+''''+'-'+''''+','+''''+''''+')) = 1 then '+''''+'N'+''''+
                            ' else '+''''+'Y'+''''+
                            ' end as err_gb '+
                            ','+@colnm2+' as err_no '+
                            ' from  '+@tbnm1+
                            ' where '+@colnm1+' is not null )  as v1'+
                            ' inner join (select distinct '+
                                        'tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1
                             on s1.tbnm = v1.tbnm'+
                            ' where  v1.err_gb = '+''''+'Y'+''''

                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
           if @colnm3 = 'datetime2'
            begin
                 set @sql1='insert into ##datatype select '+
                            's1.tb_id '+
                            ',v1.tbnm '+
                            ',v1.colnm '+
                            ',v1.data_type '+
                            ',v1.err_no '+
                            ' from '+
                            '(select
                            '+''''+@tbnm1+''''+' as tbnm '+
                            ','+''''+@colnm1+''''+' as colnm '+
                            ','+''''+@colnm3+''''+' as data_type'+
                            ','+'case '+
                            ' when len('+@colnm1+') > 20 and len('+@colnm1+') <28 then '+''''+'N'+''''+
                            ' when isnumeric(replace(substring(cast('+@colnm1+' as varchar),1,10),'+''''+'-'+''''+','+''''+''''+')) = 1 then '+''''+'N'+''''+
                            ' when isnumeric(replace(replace(substring(cast('+@colnm1+' as varchar),12,15),'+''''+':'+''''+','+''''+''''+'),'+''''+'.'+''''+','+''''+''''+')) = 1 then '+''''+'N'+''''+
                            ' when (len('+@colnm1+') = 18 or len('+@colnm1+') < 19) then'+''''+'N'+''''+
                            ' when isnumeric(replace(replace(replace(replace(cast('+@colnm1+' as varchar),'+''''+':'+''''+', '+''''+''''+'),'+''''+'AM'+''''+','+''''+''''+'),'+
                            ''''+ 'PM'+''''+', '+''''+''''+'),'+''''+''''+','+''''+''''+'))= 1 then '+''''+'N'+''''+
                            ' when substring(cast('+@colnm1+' as varchar),17,2) in ('+''''+'AM'+''''+','+''''+'PM'+''''+' ) then '+''''+'N'+''''+
                            ' when substring(cast('+@colnm1+' as varchar), 1, 2) > 13 then '+''''+'Y'+''''+
                            '  when substring(cast('+@colnm1+' as varchar), 4, 2) > 31 then '+''''+'Y'+''''+
                            ' else '+''''+'Y'+''''+
                            ' end as err_gb '+
                            ','+@colnm2+' as err_no '+
                            ' from  '+@tbnm1+
                            ' where '+@colnm1+' is not null )  as v1'+
                            ' inner join (select distinct '+
                                        'tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1
                             on s1.tbnm = v1.tbnm'+
                            ' where  v1.err_gb = '+''''+'Y'+''''

                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
           if @colnm3 in ('float','demical')
            begin
                 set @sql1='insert into ##datatype select '+
                            's1.tb_id '+
                            ',v1.tbnm '+
                            ',v1.colnm '+
                            ',v1.data_type '+
                            ',v1.err_no '+
                            ' from '+
                            '(select
                            '+''''+@tbnm1+''''+' as tbnm '+
                            ','+''''+@colnm1+''''+' as colnm '+
                            ','+''''+@colnm3+''''+' as data_type'+
                            ',case '+
                            ' when charindex('+''+''''+'.'+''''+', cast( '+@colnm1+' as varchar)) > 0 then '+''''+'N'+''''+
                            ' when isnumeric(replace(cast('+@colnm1+' as varchar),'+''''+'.'+''''+','+''''+''''+')) = 1 then '+''''+'N'+''''+
                            ' else '+''''+'Y'+''''+
                            ' end as err_gb'+
                            ','+@colnm2+' as err_no '+
                            ' from  '+@tbnm1+
                            ' where '+@colnm1+' is not null)as v1'+
                            ' inner join (select distinct '+
                                        'tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1
                              on s1.tbnm = v1.tbnm'+
                            ' where v1.err_gb  = '+''''+'Y'+''''

                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
          if @colnm3 = 'varchar'
            begin
                 set @sql1='insert into ##datatype select '+
                            's1.tb_id '+
                            ',v1.tbnm '+
                            ',v1.colnm '+
                            ',v1.data_type '+
                            ',v1.err_no '+
                            ' from '+
                            '(select
                            '+''''+@tbnm1+''''+' as tbnm '+
                            ','+''''+@colnm1+''''+' as colnm '+
                            ','+''''+@colnm3+''''+' as data_type'+
                            ','+@colnm2+' as err_no '+
                            ' from  '+@tbnm1+
                            ' where len(cast('+@colnm1+' as varchar)) >= ('+@colnm4+'+1)' +
                            'and '+@colnm1+' is not null)as v1'+
                            ' inner join (select distinct '+
                                        'tb_id, tbnm from '+@temp_resultSchema+'.schema_info) as s1
                             on s1.tbnm = v1.tbnm'

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
end
--
insert into @resultSchema.score_log_CDM
select
  case
    when data_type in ('bigint','int','smallint','tinyint','numeric') then 'C39'
    when data_type in ('date','datetime','datetime2') then 'C40'
    when data_type in ('float','demical') then 'C41'
    when data_type = 'varchar' then 'C42'
  else null
  end as check_id
,tb_id as tb_id
,tbnm as stratum1
,colnm as stratum2
,data_type as stratum3
,null as stratum4
,null as stratum5
,err_no
from ##datatype
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,stratum3 as stratum4
,case
  when check_id = 'C39' then 'violation for data type format: Related Int'
  when check_id = 'C40' then 'violation for data type format: Related Date or Datetime'
  when check_id = 'C41' then 'violation for data type format: Related float'
  when check_id = 'C42' then 'violation for data type format: Related length of varchar '
  else null
 end as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from @resultSchema.score_log_CDM
where check_id in ('C39','C40','C41','C42')
group by check_id, tb_id, stratum1,stratum2, stratum3
