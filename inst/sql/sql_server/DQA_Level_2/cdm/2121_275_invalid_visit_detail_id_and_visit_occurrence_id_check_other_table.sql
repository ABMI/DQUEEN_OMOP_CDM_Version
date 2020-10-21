Use @cdm;  --> meta db name
--
IF OBJECT_ID('tempdb..##invalidvist', 'U') IS NOT NULL
   DROP TABLE ##invalidvist
create table ##invalidvist(
       tbnm nvarchar(255)
      ,colnm nvarchar(255)
      ,err_no nvarchar(255) )
  --
declare
     @temp_cdmSchema varchar(max)
   , @temp_metaSchema varchar(max)
   , @tbnm varchar(max)
   , @tbnm1 varchar(max)
   , @colnm varchar(max)
   , @colnm1 varchar(max)
   , @colnm2 varchar(max)
   , @sql varchar(max)
   , @sql1 varchar(max)
   , @sql2 varchar(max)
   , @sql3 varchar(max)

set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result--> result db name으로 변경
                              where check_id = 'C1' and txt_val = 'Y'
                                and stratum1 in (12,13,14,15,16,18,19,20,24,26,27,28,29,30,31,32,36,37,38	)
                           for xml path('')),1,0,''))
       print(@tbnm)
set @temp_cdmSchema = ''+'@cdmSchema'+''
       print(@temp_cdmSchema)
set @temp_metaSchema = ''+'@metaSchema'+''
       print(@temp_metaSchema)
while charindex(',',@tbnm) <> 0

begin
      set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
        print(@tbnm1)
           set @colnm= (select stuff(( select c1.stratum4+',' from
                          (select stratum1, stratum3, stratum4 from @resultSchema.dq_check_result
                            where check_id = 'C2' and stratum2 = 'cdm' and txt_val= 'Y' and stratum3 = ''+@tbnm1+''
                                  and stratum4= 'visit_occurrence_id') as c1
                        for xml path('')),1,0,''))
       print(@colnm)

       set @colnm2= (select colnm from @resultSchema.schema_info
                                   where stage_gb ='cdm' and  sk_yn = 'Y' and tbnm = ''+@tbnm1+'')
       print(@colnm2)

       WHILE ChARINDEX(',', @colnm) <> 0
               BEGIN
               SET @colnm1 = SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1)
   if @colnm1 is not null
           begin
               set @sql= ' IF OBJECT_ID(''tempdb..##cnt'', ''U'') IS NOT NULL DROP TABLE ##cnt;'
                   print(@sql)
                   exec(@sql)

               set @sql1=' insert into ##invalidvist '+
                         ' select '+
                         ''''+@tbnm1+''''+' as tbnm '+
                         ', '+''''+@colnm1+''''+' as colnm '+
                         ', '+@colnm2+' as err_no '+
                         ' from '+@tbnm1+
                         ' where visit_occurrence_id in ( select visit_occurrence_id from '+@temp_cdmSchema+'visit_occurrence '+
                         ' where visit_occurrence_source_value in ( select uniq_no from '+@temp_metaSchema+'dev_visit '+
                         ' where include_yn = '+''''+'N'+''''+')'+')'
                   print(@sql1)
                   exec(@sql1)
             --
                  set @sql3=' insert into ##invalidvist '+
                         ' select '+
                         ''''+@tbnm1+''''+' as tbnm '+
                         ', '+''''+@colnm1+''''+' as colnm '+
                         ', '+@colnm2+' as err_no '+
                         ' from '+@tbnm1+
                         ' where visit_detail_id in ( select visit_detail_id from '+@temp_cdmSchema+'visit_detail '+
                         ' where visit_detail_source_value in ( select uniq_no from '+@temp_metaSchema+'dev_visit '+
                         ' where include_yn = '+''''+'N'+''''+')'+')'
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
insert into @resultSchema.score_log_CDM
select
 'C275' as check_id
,s1.tb_id
,c1.tbnm as stratum1
,c1.colnm as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,c1.err_no
from ##invalidvist as c1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info
  where stage_gb= 'CDM') as s1
on s1.tbnm = c1.tbnm
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'check the visit_occurrence_id & visit_detail_id records to be excluded' as stratum5
,count(*) as count_val
,null as num_val
,null as txt_val
from
@resultSchema.score_log_CDM
where check_id = 'C275'
group by check_id,tb_id,stratum1,stratum2

