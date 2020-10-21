/*************************************************************************/
--  Assigment: Completeness
--  Description: Missing data check inititial column
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  Missing data
--  Language: MSSQL
--  Target data: cdm
-->
/*************************************************************************/
Use @cdm
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
               set @sql= ' IF OBJECT_ID(''tempdb..##co_cnt'', ''U'') IS NOT NULL DROP TABLE ##co_cnt;'
                   print(@sql)
                   exec(@sql)
               set @sql1= 'select count('+@colnm1+') as col_cnt into ##co_cnt from (select case when convert(varchar,'+@colnm1+') is null or convert(varchar,'+@colnm1+') = '''' or convert(varchar,'+@colnm1+') = '' '' then ''Y'' else ''N'' end as '+@colnm1+' from '+@tbnm1+')v where '+@colnm1+'= ''Y'''
                   print(@sql1)
                   exec(@sql1)
               set    @tb_cnt = (select * from ##co_cnt)
                   print(@tb_cnt)
                               print(@tb_cnt)
               end
       else
           begin
               set @tb_cnt = null
                   print(@tb_cnt)
               end
   insert into ##count_result (tbnm,colnm,col_cnt)
       values(@tbnm1, @colnm1, @tb_cnt)
           PRINT( SUBSTRING( @colnm, 1, CHARINDEX(',', @colnm) - 1 ) )
       SET @colnm = SUBSTRING( @colnm, CHARINDEX(',', @colnm) + 1, LEN(@colnm) )
       end
   PRINT( SUBSTRING( @tbnm, 1, CHARINDEX(',', @tbnm) - 1 ) )
   SET @tbnm = SUBSTRING( @tbnm, CHARINDEX(',', @tbnm) + 1, LEN(@tbnm) )
end

insert into @resultSchema.dq_check_result
	select
		 'C7' as check_id
		,s1.tb_id as stratum1
    ,c1.tbnm as stratum2
    ,s1.col_id as stratum3
		,c1.colnm as stratum4
		,'missing count' as stratum5
 	 	,c1.col_cnt as count_val
    ,null as num_val
    ,null as txt_val
	from ##count_result as c1
inner join (select tb_id, col_id, tbnm, colnm from @resultSchema.schema_info where stage_gb = 'cdm') as s1
      on s1.tbnm = c1.tbnm and s1.colnm = c1.colnm
