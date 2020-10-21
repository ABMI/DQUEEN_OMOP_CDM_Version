/*************************************************************************/
--  Assigment: result_db ddl
--  Description: schema capacity data ddl
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  schema capacity data ddl
--  Language: MSSQL
--  Target data: cdm
-- /*************************************************************************/
--
use @cdm ;
--
insert into @resultSchema.schema_capacity
select
 si1.stage_gb as stage_gb
,si1.tb_id as tb_id
,sm1.TABLE_CATALOG as db_nm
,sm1.TABLE_SCHEMA as schema_nm
,si1.tbnm as tbnm
,sm1.TABLE_TYPE as tb_type
,sm1.rows as total_rows
,sm1.table_size as tb_size
,unit as unit
from
(select distinct stage_gb, tb_id, tbnm from @resultSchema.schema_info
  where stage_gb= 'CDM') as si1
left join
(select distinct
          it1.TABLE_CATALOG
         ,it1.TABLE_SCHEMA
         ,it1.TABLE_NAME
         ,it1.TABLE_TYPE
         ,rc1.rows
         ,ts1.table_size
         ,ts1.UNIT
   from INFORMATION_SCHEMA.TABLES as it1
       inner join (SELECT o.name
                        , i.rows
                       FROM sysindexes i
                         INNER JOIN
                         sysobjects o
                         ON i.id = o.id
                       WHERE i.indid < 2
                       AND  o.xtype = 'U'
                       ) as rc1
            on rc1.name = it1.TABLE_NAME
       left join (
                    SELECT
                           table_name = convert(varchar(30), min(o.name))
                          ,table_size = convert(int, ltrim(str(sum(cast(reserved as bigint)) * 8192 / 1024., 15, 0)))
                          ,UNIT = 'KB'
                     FROM sysindexes i
                  INNER JOIN sysobjects o  ON (o.id = i.id)
                    WHERE i.indid IN (0, 1, 255)  AND  o.xtype = 'U'
                       GROUP BY i.id
                  ) as ts1
             on it1.TABLE_NAME = ts1.table_name) as sm1
  on si1.tbnm = sm1.TABLE_NAME

