/*************************************************************************/
--  Assigment: Plausibility- Uniquness
--  Description: check the duplication super key
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  check the null status of column using by row count
--  Language: MSSQL
--  Target data: cdm
-->
/*************************************************************************/
use @cdm;--> meta db name
IF OBJECT_ID('tempdb..##count_result', 'U') IS NOT NULL
   DROP TABLE ##count_result
create table ##count_result(
       tbnm nvarchar(255),
       colnm nvarchar(255),
       col_cnt nvarchar(255)
   )
declare
     @tbnm varchar(max)
   , @tbnm1 varchar(max)
   , @colnm varchar(max)
   , @colnm1 varchar(max)
   , @datatype varchar(max)
   , @datatype1 varchar(max)
   , @sql varchar(max)
   , @sql1 varchar(max)
   , @tb_cnt varchar(max)

set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result
                                   where check_id = 2 and txt_val='Y'
                           for xml path('')),1,0,''))
       print(@tbnm)
while charindex(',',@tbnm) <> 0
begin
      set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
        print(@tbnm1)
           set @colnm= (select stuff(( select stratum4+',' from @resultSchema.dq_check_result
                                       where check_id = 4 and stratum2 = 'cdm' and txt_val= 'Y' and stratum3 = ''+@tbnm1+''
                                       for xml path('')),1,0,''))

        print(@colnm)
while ChARINDEX(',', @colnm) <> 0
   begin
           set @colnm1 = SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1)
           print(@colnm1)
           set @datatype= (select stuff(( select data_type+',' from @resultSchema.schema_info
                                       where stage_gb = 'cdm' and tbnm =''+@tbnm1+'' and colnm= ''+@colnm1+''
                                       for xml path('')),1,0,''))

           print(@datatype)
while ChARINDEX(',', @datatype) <> 0
   begin
           set @datatype1 = SUBSTRING( @datatype, 1, CHARINDEX(',', @datatype) - 1)
           print(@datatype1)
           set @sql= ' IF OBJECT_ID(''tempdb..##co_cnt'', ''U'') IS NOT NULL DROP TABLE ##co_cnt;'
           print(@sql)
           exec(@sql)
   if @datatype1 = 'varchar'
       begin
               set @sql= 'select cast(count(*) as bigint) as col_cnt into ##co_cnt from (select distinct  convert( varchar, '+@colnm1+' )as '+@colnm1+' from '+@tbnm1+ ')v'
                   print(@sql)
                   exec(@sql)
               set    @tb_cnt = (select * from ##co_cnt)
                   print(@tb_cnt)
       insert into ##count_result (tbnm,colnm,col_cnt)
       values(@tbnm1, @colnm1, @tb_cnt)
        end
    else --if @datatype1 = ' varchar'
      begin
               set @sql= 'select distinct count( '+@colnm1+') as col_cnt into ##co_cnt from '+@tbnm1+''
                   print(@sql)
                   exec(@sql)
               set    @tb_cnt = (select * from ##co_cnt)
                   print(@tb_cnt)
       insert into ##count_result (tbnm,colnm,col_cnt)
       values(@tbnm1, @colnm1, @tb_cnt)
        end
           PRINT( SUBSTRING( @datatype, 1, CHARINDEX(',', @datatype) - 1 ) )
           SET @datatype = SUBSTRING( @datatype, CHARINDEX(',', @datatype) + 1, LEN(@datatype) )
           end
           PRINT( SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1 ) )
       SET @colnm = SUBSTRING( @colnm, CHARINDEX(',', @colnm) + 1, LEN(@colnm) )
       end
   PRINT( SUBSTRING( @tbnm, 1, CHARINDEX(',', @tbnm) - 1 ) )
   SET @tbnm = SUBSTRING( @tbnm, CHARINDEX(',', @tbnm) + 1, LEN(@tbnm) )
    end

insert into @resultSchema.archive_data
	select
  distinct
     s1.tb_id
		,14 as id
		,c1.tbnm as stratum1
		,c1.colnm as stratum2
		,'distinct col count' as stratum3
    ,null as num_val
		,c1.col_cnt as count_val

	from ##count_result as c1
left join (select distinct tb_id, tbnm from @resultSchema.schema_info
						where stage_gb = 'cdm') as s1
	on s1.tbnm = c1.tbnm
--> data insert
insert into @resultSchema.dq_check_result
  select
  distinct
   a1.id as check_id
  ,a1.tb_id as stratum1
  ,'cdm' as stratum2
  ,a1.stratum1 as stratum3
  ,a1.stratum2 as stratum4
  ,null as stratum5
  ,a1.count_val as count_val
  ,null as num_val
  ,null as txt_val
  from
  @resultSchema.archive_data as a1
inner join (select distinct tbnm, colnm from @resultSchema.schema_info where stage_gb = 'cdm' and sk_yn = 'Y') as s1
  on s1.tbnm = a1.stratum1 and a1.stratum2 = s1.colnm
where a1.id = 14
