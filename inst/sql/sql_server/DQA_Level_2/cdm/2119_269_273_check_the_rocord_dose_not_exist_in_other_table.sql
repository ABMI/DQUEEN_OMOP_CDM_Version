/*************************************************************************/
--  Assigment: Conformance- value
--  Description: this medical dept could not prescribe the procedure
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  this medical dept could not prescribe the drug
--  Language: MSSQL
--  Target data: cdm
-- /*************************************************************************/
Use @cdm;  --> meta db name
--
IF OBJECT_ID('tempdb..##existsidcheck', 'U') IS NOT NULL
   DROP TABLE ##existsidcheck
create table ##existsidcheck(
       tb_id nvarchar(255)
      ,tbnm nvarchar(255)
      ,colnm nvarchar(255)
      ,col1 nvarchar(255)
      ,err_no nvarchar(255) )
  --
declare
     @tbnm varchar(max)
   , @tbnm1 varchar(max)
   , @colnm varchar(max)
   , @colnm1 varchar(max)
   , @sql varchar(max)
   , @sql1 varchar(max)
   , @sql2 varchar(max)
   , @temp_resultSchema varchar(max)

set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result
                              where check_id = 'C1' and txt_val = 'Y'
                           for xml path('')),1,0,''))
       print(@tbnm)
set @temp_resultSchema = ''+'@resultSchema'+'' -- @resultSchema
while charindex(',',@tbnm) <> 0

begin
      set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
        print(@tbnm1)
           set @colnm= (select stuff(( select c1.stratum4+',' from
                          (select stratum1, stratum3, stratum4 from @resultSchema.dq_check_result
                            where check_id = 'C2' and stratum2 = 'cdm' and txt_val= 'Y'
                              and stratum4 in ('visit_occurrence_id','person_id','provider_id','location_id','care_site_id','visit_detail_id')
                              and stratum3 = ''+@tbnm1+'') as c1
                           for xml path('')),1,0,''))
       print(@colnm)

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
          if @colnm1 = 'person_id'
            begin
                 set @sql1='insert into ##existsidcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select distinct '+@colnm1+' as col1'+
                           ','+@colnm1+' col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'person'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
          if @colnm1 = 'visit_occurrence_id'
            begin
                 set @sql1='insert into ##existsidcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1 as col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select distinct '+@colnm1+' as col1'+
                           ','+@colnm1+' as col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'visit_occurrence'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
          if @colnm1 = 'visit_detail_id'
            begin
                 set @sql1='insert into ##existsidcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1 as col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select distinct '+@colnm1+' as col1'+
                           ','+@colnm1+' as col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'visit_detail'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
          if @colnm1 = 'provider_id'
            begin
                 set @sql1='insert into ##existsidcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select distinct '+@colnm1+' as col1'+
                           ','+@colnm1+' as col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'provider'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
          if @colnm1 = 'care_site_id'
            begin
                 set @sql1='insert into ##existsidcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select '+@colnm1+' as col1'+
                           ','+@colnm1+' as col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'care_site'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
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
end ;
-- seperation data
select
    distinct
    'person' as tbnm
    ,'person_id' as colnm
    ,cast(col1 as varchar) as col1
     into #person_list
from ##existsidcheck where colnm = 'person_id' ;
select
    distinct
     'care_site' as tbnm
    ,'care_site_id' as colnm
    ,col1 as col1 into #caresite_list
from ##existsidcheck where colnm = 'care_site_id' ;
select
    distinct
    'visit_occurrence' as tbnm
    ,'visit_occurrence_id' as colnm
    ,cast(col1 as varchar) as col1 into #visit_list
from ##existsidcheck where colnm = 'visit_occurrence_id' ;
select
    distinct
    'provider' as tbnm
    ,'provider_id' as colnm
    ,col1 as col1 into #provider_list
from ##existsidcheck where colnm = 'provider_id' ;
select
    distinct
    'visit_detail' as tbnm
    ,'visit_detail_id' as colnm
    ,col1 as col1 into #visitdetail_list from ##existsidcheck
where colnm = 'visit_detail_id' ;
--
insert into @resultSchema.score_log_CDM
select
  case
   when colnm = 'person_id' then 'C269'
   when colnm = 'provider_id' then 'C270'
   when colnm = 'care_site_id' then 'C271'
   when colnm = 'visit_detail_id' then 'C272'
   when colnm = 'visit_occurrence_id' then 'C273'
   else
  null end  as check_id
,s1.tb_id as tb_id
,e1.tbnm as stratum1
,e1.colnm as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,e1.err_no
from
(select distinct
 'person' as tbnm
,'person_id' as colnm
,cast(p2.person_id as varchar) as err_no
from @cdmSchema.person as p2
  where not exists
(select
distinct
  p1.col1 collate Korean_Wansung_CI_AS as col1
from  #person_list as p1
where p1.col1 = p2.person_id )
union all
select distinct
 'care_site' as tbnm
,'care_site_id' as colnm
,care_site_id as err_no
from @cdmSchema.care_site as s1
  where not exists
(select
distinct
  col1
from #caresite_list as c1
where c1.col1 = s1.care_site_id )
union all
select distinct
 'visit_occurrence' as tbnm
,'visit_occurrence_id' as colnm
,cast(visit_occurrence_id as varchar) as err_no
from @cdmSchema.visit_occurrence as v2
  where not exists
(select
distinct
  col1
from #visit_list as v1
where v1.col1 = v2.visit_occurrence_id )
union all
select distinct
 'provider' as tbnm
,'provider_id' as colnm
,cast(provider_id as varchar) as err_no
from @cdmSchema.provider as p2
  where not exists
(select
distinct
  col1
from #provider_list as p1
where p1.col1 = cast(p2.provider_id as varchar) collate Korean_Wansung_CI_AS )
union all
select distinct
 'visit_detail' as tbnm
,'visit_detail_id' as colnm
,visit_detail_id as err_no
from @cdmSchema.visit_detail as m1
  where not exists
(select
distinct
  col1
from #visitdetail_list as o1
where o1.col1 = m1.visit_detail_id )
  )as e1
inner join
    (select distinct tb_id, tbnm from @resultSchema.schema_info
      where stage_gb= 'CDM') as s1
    on e1.tbnm = s1.tbnm ;
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,case
   when check_id = 'C269' then 'Record dose not exist in other table: person_id'
   when check_id = 'C270' then 'Record dose not exist in other table: provider_id'
   when check_id = 'C271' then 'Record dose not exist in other table: care_site_id'
   when check_id = 'C272' then 'Record dose not exist in other table: visit_detail_id'
   when check_id = 'C273' then 'Record dose not exist in other table: visit_occurrence_id'
  else null
  end as stratum5
,count_val
,null as num_val
,null as txt_val
from
(select
 check_id
,tb_id
,stratum1
,stratum2
,count(*) as count_val
from @resultSchema.score_log_CDM
 where
check_id in ('C269','C270','C271','C272','C273')
group by check_id, tb_id, stratum1, stratum2 )v ;
