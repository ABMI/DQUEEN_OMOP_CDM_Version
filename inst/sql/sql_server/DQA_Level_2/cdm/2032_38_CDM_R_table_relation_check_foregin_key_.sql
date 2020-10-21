/*************************************************************************/
--  Assigment: Completeness
--  Description: completeness check script for cdm Person
--  Author: Enzo Byun
--  Date:  02.01, 2020
--  Job name: Year & monthly birthdate count
--  Language: MSSQL
--  Target data: Meta
/*************************************************************************/

Use @cdm;  --> meta db name
--
IF OBJECT_ID('tempdb..##relationcheck', 'U') IS NOT NULL
IF OBJECT_ID('tempdb..##relationcheck', 'U') IS NOT NULL
   DROP TABLE ##relationcheck
create table ##relationcheck(
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
   , @colnm2 varchar(max)
   , @sql varchar(max)
   , @sql1 varchar(max)
   , @sql2 varchar(max)
   , @temp_resultSchema varchar(max)

set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result
                              where check_id = 'C1' and txt_val = 'Y'
                                and stratum1 in (2,12,13,14,15,16,18,19,20,23,24,26,27,28,29,30,31,32,33,36,37,38)
                           for xml path('')),1,0,''))
       print(@tbnm)
set @temp_resultSchema = ''+'@resultSchema'+''
while charindex(',',@tbnm) <> 0

begin
      set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
        print(@tbnm1)
           set @colnm= (select stuff(( select c1.stratum4+',' from
                          (select stratum1, stratum3, stratum4 from @resultSchema.dq_check_result
                            where check_id = 'C2' and stratum2 = 'cdm' and txt_val= 'Y'
                              and (stratum4 in ('person_id','care_site_id', 'location_id','provider_id','visit_occurrence_id','visit_detail_id')
                              or stratum4 like '%concept_id') and stratum4 not in ( 'operator_concept_id','value_as_concept_id'
                                  ,'unit_concept_id','qualifier_concept_id','modifier_concept_id')
                              and stratum3 = ''+@tbnm1+'') as c1
                           for xml path('')),1,0,''))
       print(@colnm)

       set @colnm2= (select colnm from @resultSchema.schema_info
                                   where stage_gb ='cdm' and  sk_yn = 'Y' and tbnm = ''+@tbnm1+'')
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
          if @colnm1 = 'person_id'
            begin
                 set @sql1='insert into ##relationcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select '+@colnm1+' as col1'+
                           ','+@colnm2+' col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'person'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '+
                           ' where not exists ( select person_id from person p2 where p1.col1 = p2.person_id )'
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
                 set @sql1='insert into ##relationcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1 as col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select '+@colnm1+' as col1'+
                           ','+@colnm2+' as col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'care_site'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '+
                           ' where not exists ( select care_site_id from care_site p2 where p1.col1 = p2.care_site_id )'
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
          if @colnm1 = 'location_id'
            begin
                 set @sql1='insert into ##relationcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select '+@colnm1+' as col1'+
                           ','+@colnm2+' as col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'location'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '+
                           ' where not exists ( select location_id from location p2 where p1.col1 = p2.location_id )'
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
                 set @sql1='insert into ##relationcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select '+@colnm1+' as col1'+
                           ','+@colnm2+' as col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'provider'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '+
                           ' where not exists ( select provider_id from provider p2 where p1.col1 = p2.provider_id )'
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
                 set @sql1='insert into ##relationcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select '+@colnm1+' as col1'+
                           ','+@colnm2+' as col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'visit_occurrence'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '+
                           ' where not exists ( select visit_occurrence_id from visit_occurrence p2 where p1.col1 = p2.visit_occurrence_id )'
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
                 set @sql1='insert into ##relationcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1 as col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select '+@colnm1+' as col1'+
                           ','+@colnm2+' as col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'visit_detail'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '+
                           ' where not exists ( select visit_detail_id from visit_detail p2 where p1.col1 = p2.visit_detail_id )'
                     print(@sql1)
                     exec(@sql1)
               end
           else
                begin
                  set @sql2 = 'next'
                  print(@sql2)
                end
--
          if @colnm1 like '%concept_id'
            begin
                 set @sql1='insert into ##relationcheck select s1.tb_id'+
                           ',p1.tbnm'+
                           ','+''''+@colnm1+''''+' as colnm '+
                           ',p1.col1 as col1'+
                           ',p1.col2 as err_no'+
                           ' from '+
                           '(select '+@colnm1+' as col1'+
                           ','+@colnm2+' as col2'+
                           ','+''''+@tbnm1+''''+' as tbnm'+
                           ' from '+@tbnm1+' ) as p1 '+
                           ' inner join '+
                           ' (select distinct tb_id, tbnm from '+@temp_resultSchema+'.schema_info'+
                           ' where tbnm not in ('+''''+'concept'+''''+')) as s1 '+
                           ' on p1.tbnm = s1.tbnm '+
                           ' where not exists ( select concept_id from concept p2 where p1.col1 = p2.concept_id )'
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
end
--
insert into @resultSchema.score_log_CDM
select
 case
   when colnm = 'person_id' then 'C32'
   when colnm = 'care_site_id' then 'C33'
   when colnm = 'location_id' then 'C34'
   when colnm = 'provider_id' then 'C35'
   when colnm = 'visit_occurrence_id' then 'C36'
   when colnm = 'visit_detail_id' then 'C37'
   when colnm like '%concept_id' then 'C38'
   else null
 end as check_id
,tb_id
,tbnm as stratum1
,colnm as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,err_no
from ##relationcheck
--
insert into @resultSchema.score_log_CDM
select
 'C38' as check_id
,18 as tb_id
,tbnm as stratum1
,colnm as stratum2
,null as stratum3
,null as stratum4
,null as stratum5
,err_no
from
(select
 'dose_era' as tbnm
,'unit_concept_id' as colnm
,unit_concept_id
,dose_era_id as err_no
from @cdmSchema.dose_era as d1
where
 not exists (select concept_id from @cdmSchema.concept c1 where d1.unit_concept_id = c1.concept_id))v
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as startum1
,stratum1 as stratum2
,stratum2 as stratum3
, null as stratum4
,case
   when check_id = 'C32' then 'data relation check (foregin key): person_id'
   when check_id = 'C33' then 'data relation check (foregin key): care_site_id'
   when check_id = 'C34' then 'data relation check (foregin key): location_id'
   when check_id = 'C35' then 'data relation check (foregin key): provider_id'
   when check_id = 'C36' then 'data relation check (foregin key): visit_occurrence_id'
   when check_id = 'C37' then 'data relation check (foregin key): visit_detail_id'
   when check_id = 'C38' then 'data relation check (foregin key): concept_id'
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
where check_id in ('C32','C33','C34','C35','C36','C37','C38')
group by  check_id,tb_id,stratum1,stratum2
)v
--

