use @cdm;  --> meta db name
--
IF OBJECT_ID('tempdb..##outperiod', 'U') IS NOT NULL
   DROP TABLE ##outperiod
IF OBJECT_ID('tempdb..##lengthrslt', 'U') IS NOT NULL
   DROP TABLE ##lengthrslt
IF OBJECT_ID('tempdb..##invalidrslt', 'U') IS NOT NULL
   DROP TABLE ##invalidrslt
create table ##outperiod(
       tb_id nvarchar(255)
      ,tbnm nvarchar(255)
      ,colnm nvarchar(255)
      ,concept_id nvarchar(255)
      ,err_no nvarchar(255) )
--
create table ##lengthrslt(
       tb_id nvarchar(255)
      ,tbnm nvarchar(255)
      ,colnm nvarchar(255)
      ,concept_id nvarchar(255)
      ,err_no nvarchar(255) )

create table ##invalidrslt(
       tb_id nvarchar(255)
      ,tbnm nvarchar(255)
      ,colnm nvarchar(255)
      ,concept_id nvarchar(255)
      ,err_no nvarchar(255) )
  --
declare
     @tbnm varchar(max)
   , @tbnm1 varchar(max)
   , @colnm varchar(max)
   , @colnm1 varchar(max)
   , @colnm2 varchar(max)
   , @date varchar(max)
   , @sql varchar(max)
   , @sql1 varchar(max)
   , @sql2 varchar(max)
   , @sql3 varchar(max)
   , @tempSchema varchar(max)

set @tbnm= (select stuff(( select stratum3+',' from @resultSchema.dq_check_result
                              where check_id = 'C1' and stratum1 in (2,12,13,14,15,16,18,19,20,21,23,24,26,27,28,29,30,31,32,33,36,37,38)
                                and txt_val = 'Y'
                           for xml path('')),1,0,''))
       print(@tbnm)
set @tempSchema = ''+'@resultSchema'+''
set @date = ''+@etl_endt+''
while charindex(',',@tbnm) <> 0

begin
      set @tbnm1=substring(@tbnm, 1, charindex(',',@tbnm) -1)
        print(@tbnm1)
           set @colnm= (select stuff(( select c1.stratum4+',' from
                          (select stratum1, stratum3, stratum4 from @resultSchema.dq_check_result
                            where check_id = 'C2' and stratum4 like '%concept_id'
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

--
        if @colnm1 is not null
           begin
               set @sql= ' IF OBJECT_ID(''tempdb..##cnt'', ''U'') IS NOT NULL DROP TABLE ##cnt;'
                   print(@sql)
                   exec(@sql)
            begin
                 set @sql1='insert into ##outperiod select '+
                            's1.tb_id '+
                            ',v1.tbnm '+
                            ',v1.colnm '+
                            ',v1.concept_id '+
                            ',v1.err_no '+
                            ' from '+
                            '(select
                            '+''''+@tbnm1+''''+' as tbnm '+
                            ','+''''+@colnm1+''''+' as colnm '+
                            ','+@colnm1+' as concept_id '+
                            ','+@colnm2+' as err_no '+
                            ' from  '+@tbnm1+
                            ' where '+@colnm1+' in ( select concept_id from concept'+
                            ' where VALID_END_DATE < '+''''+@date+''''+
                            ' and '+@colnm1+' is not null ))  as v1'+
                            ' inner join (select distinct '+
                                        'tb_id, tbnm from '+@tempSchema+'.schema_info) as s1
                             on s1.tbnm = v1.tbnm'

                     print(@sql1)
                     exec(@sql1)
              end
 --
            begin
                 set @sql3='insert into ##lengthrslt select '+
                            's1.tb_id '+
                            ',v1.tbnm '+
                            ',v1.colnm '+
                            ',v1.concept_id '+
                            ',v1.err_no '+
                            ' from '+
                            '(select
                            '+''''+@tbnm1+''''+' as tbnm '+
                            ','+''''+@colnm1+''''+' as colnm '+
                            ','+@colnm1+' as concept_id '+
                            ','+@colnm2+' as err_no '+
                            ' from  '+@tbnm1+
                            ' where (len(cast('+@colnm1+' as varchar)) < 1 or '+
                            ' len(cast('+@colnm1+' as varchar)) > 9)'+
                            ' and '+@colnm1+' is not null)  as v1'+
                            ' inner join (select distinct '+
                                        'tb_id, tbnm from '+@tempSchema+'.schema_info) as s1
                             on s1.tbnm = v1.tbnm'

                     print(@sql3)
                     exec(@sql3)
              end
 --
            begin
                 set @sql3='insert into ##invalidrslt select '+
                            's1.tb_id '+
                            ',v1.tbnm '+
                            ',v1.colnm '+
                            ',v1.concept_id '+
                            ',v1.err_no '+
                            ' from '+
                            '(select
                            '+''''+@tbnm1+''''+' as tbnm '+
                            ','+''''+@colnm1+''''+' as colnm '+
                            ','+@colnm1+' as concept_id '+
                            ','+@colnm2+' as err_no '+
                            ' from  '+@tbnm1+
                            ' where '+@colnm1+' in ( select concept_id from concept'+
                            ' where invalid_reason in ('+''''+'D'+''''+','+''''+'U'+''''+'))'+
                            ' and '+@colnm1+' is not null ) as v1'+
                            ' inner join (select distinct '+
                                        'tb_id, tbnm from '+@tempSchema+'.schema_info) as s1
                             on s1.tbnm = v1.tbnm'

                     print(@sql3)
                     exec(@sql3)
              end
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
 'C43' as check_id
,c2.tb_id
,c1.*
from
(select
 tbnm as stratum1
,colnm as stratum2
,concept_id as stratum3
,null as stratum4
,null as stratum5
,err_no
from ##outperiod) as c1
inner join
(select distinct tb_id, tbnm from @resultSchema.schema_info) as c2
on c1.stratum1 = c2.tbnm
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'concept_id valid date check' as stratum5
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
from  @resultSchema.score_log_CDM
  where check_id='C43'
group by check_id,tb_id,stratum1,stratum2)v
--
insert into @resultSchema.score_log_CDM
select
 'C44' as check_id
,tb_id
,tbnm as stratum1
,colnm as stratum2
,concept_id as stratum3
,null as stratum4
,null as stratum5
,err_no
from ##lengthrslt
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'concept_id length check(min length: 1, max length: 9)' as stratum5
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
from  @resultSchema.score_log_CDM
  where check_id='C44'
group by check_id,tb_id,stratum1,stratum2)v
--
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'concept_id valid date check' as stratum5
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
from  @resultSchema.score_log_CDM
  where check_id='C43'
group by check_id,tb_id,stratum1,stratum2)v
--
insert into @resultSchema.score_log_CDM
select
 'C45' as check_id
,tb_id
,tbnm as stratum1
,colnm as stratum2
,concept_id as stratum3
,null as stratum4
,null as stratum5
,err_no
from ##invalidrslt
--
insert into @resultSchema.dq_check_result
select
 check_id
,tb_id as stratum1
,stratum1 as stratum2
,stratum2 as stratum3
,null as stratum4
,'invalid concept_id check' as stratum5
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
from  @resultSchema.score_log_CDM
  where check_id='C45'
group by check_id,tb_id,stratum1,stratum2)v
--