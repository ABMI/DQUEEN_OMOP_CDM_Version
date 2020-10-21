/*************************************************************************/
--  Assigment: Completeness
--  Description: completeness check script for cdm Person
--  Author: Enzo Byun
--  Date:  02.01, 2020
--  Job name: Year & monthly birthdate count
--  Language: MSSQL
--  Target data: Meta
/*************************************************************************/

Use @cdm;
--
IF OBJECT_ID('tempdb..##unmappedconcept', 'U') IS NOT NULL
   DROP TABLE ##unmappedconcept
create table ##unmappedconcept(
       tbnm nvarchar(255)
      ,colnm nvarchar(255)
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

set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result
                              where check_id = 'C1' and txt_val = 'Y'
                                and stratum1 in (12,13,14,15,16,18,19,2,20,21,24,26,27,28,29,30,31,32,33,36,37,38)
                           for xml path('')),1,0,''))
       print(@tbnm)
while charindex(',',@tbnm) <> 0

begin
      set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
        print(@tbnm1)
           set @colnm= (select stuff(( select c1.stratum4+',' from
                          (select stratum1, stratum3, stratum4 from @resultSchema.dq_check_result
                            where check_id = 'C2' and stratum2 = 'cdm' and txt_val= 'Y' and stratum3 = ''+@tbnm1+''
                            and stratum4 not in ('value_as_concept_id','qualifier_concept_id','unit_concept_id','operator_concept_id')) as c1
                          inner join (select tb_id, tbnm, col_id, colnm from @resultSchema.schema_info where colnm like '%concept_id') as s1
                             on c1.stratum1 = s1.tb_id and c1.stratum4 = s1.colnm
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

               set @sql1='insert into ##unmappedconcept select * from (select '+''''+@tbnm1+''''+' as tbnm , '+''''+@colnm1+''''+' as colnm ,'+@colnm2+' as err_no from '+@tbnm1 +
                         ' where cast('+@colnm1+' as varchar) is null or '+@colnm1+' in (0,4481904,'+''''+''''+'))v'
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
 case
   when right(colnm,17) = 'source_concept_id' then 'C20'
   when right(colnm,15) = 'type_concept_id' then 'C21'
   when right(colnm,15) = 'unit_concept_id' then 'C22'
  else 'C23'
  end  as check_id
,s1.tb_id
,c1.tbnm as stratum1
,c1.colnm as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
tbnm
,colnm
,err_no
from ##unmappedconcept) as c1
inner join
(select
   distinct
  tb_id, tbnm
 from @resultSchema.schema_info) as s1
on c1.tbnm = s1.tbnm
--
insert into @resultSchema.dq_check_result
select
		 check_id
		,tb_id as startum1
		,stratum1 as stratum2
		,stratum2 as stratum3
		, null as stratum4
		,case
       when check_id = 'C20' then 'unmapped source_concept_id check'
       when check_id = 'C21' then 'unmapped type_concept_id check'
       when check_id = 'C22' then 'unmapped unit_concept_id check'
       when check_id = 'C23' then 'unmapped concept_id check'
     else null
     end as stratum5
		,count_val
		,null as num_val
		,null as txt_val
from
(
select
 check_id
,tb_id
,stratum1
,stratum2
,count(*) as count_val
from
	@resultSchema.score_log_CDM
where check_id in ('C20','C21','C22','C23')
group by  check_id,tb_id,stratum1,stratum2
)v
--




