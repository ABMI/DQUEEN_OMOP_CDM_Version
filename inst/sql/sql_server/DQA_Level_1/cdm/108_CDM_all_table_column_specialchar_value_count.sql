/*************************************************************************/
--  Assigment: conformance -value
--  Description: Special charater check
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  special_char check
--  Language: MSSQL
--  Target data: cdm
-->
/*************************************************************************/
Use @cdm  --> meta db name
IF OBJECT_ID('tempdb..##countrslt', 'U') IS NOT NULL
   DROP TABLE ##countrslt
create table ##countrslt(
       tbnm nvarchar(255),
        colnm nvarchar(255),
       col_cnt nvarchar(255)
                            )
declare
     @tbnm varchar(max)
   , @tbnm1 varchar(max)
   , @colnm varchar(max)
   , @colnm1 varchar(max)
   , @sql varchar(max)
   , @sql1 varchar(max)
   , @tb_cnt varchar(max)
set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result
                                   where check_id = 'C1' and txt_val = 'Y'
                           for xml path('')),1,0,''))
       print(@tbnm)
while charindex(',',@tbnm) <> 0

begin
      set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
        print(@tbnm1)
       set @colnm= (select stuff(( select stratum4+',' from @resultSchema.dq_check_result
                                   where check_id = 'C2' and  txt_val = 'Y' and stratum3 = ''+@tbnm1+''
                               for xml path('')),1,0,''))
       print(@colnm)
       WHILE ChARINDEX(',', @colnm) <> 0
               BEGIN
               SET @colnm1 = SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1)
   if @colnm1 is not null
           begin
               set @sql= ' IF OBJECT_ID(''tempdb..##cnt'', ''U'') IS NOT NULL DROP TABLE ##cnt;'
                   print(@sql)
                   exec(@sql)
               set @sql1= 'select count( convert(varchar,'+@colnm1+'))  as col_cnt into ##cnt from ' + @tbnm1+''+
						              ' where  convert(varchar, '+@colnm1+') like ''%[^0-9a-zA-Z .]%'' '
                   print(@sql1)
                   exec(@sql1)
               set    @tb_cnt = (select * from ##cnt)
                   print(@tb_cnt)
                               print(@tb_cnt)
               end
       else
           begin
               set @tb_cnt = null
                   print(@tb_cnt)
               end
   insert into ##countrslt (tbnm,colnm,col_cnt)
       values(@tbnm1, @colnm1, @tb_cnt)
           PRINT( SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1 ) )
       SET @colnm = SUBSTRING( @colnm, CHARINDEX(',', @colnm) + 1, LEN(@colnm) )
       end
   PRINT( SUBSTRING( @tbnm, 1, CHARINDEX(',', @tbnm) - 1 ) )
   SET @tbnm = SUBSTRING( @tbnm, CHARINDEX(',', @tbnm) + 1, LEN(@tbnm) )
end
--
insert into @resultSchema.dq_check_result
	select
		 'C8' as check_id
		,s1.tb_id as stratum1
		,c1.tbnm as stratum2
		,s1.col_id as stratum3
		,c1.colnm as stratum4
		,'col count for special char value' as stratum5
		,c1.col_cnt as count_val
    ,null as num_val
    ,null as txt_val
	from ##countrslt as c1
  inner join @resultSchema.schema_info as s1
    on s1.tbnm = c1.tbnm and s1.colnm = c1.colnm ;