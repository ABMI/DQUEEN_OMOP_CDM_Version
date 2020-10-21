/*************************************************************************/
--  Assigment: conformance-value
--  Description: check the data type conformance
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name: validation with DB definition describe
--  Language: MSSQL
--  Target data: cdm
-->
/*************************************************************************/
  with rawdata as
  (select
       si1.tb_id
      ,si1.tbnm
      ,si1.col_id
      ,si1.colnm
      ,ic1.DATA_TYPE
      ,case
          when ic1.DATA_TYPE = cast(si1.data_type as varchar) or ic1.DATA_TYPE = cast(si1.data_type2 as varchar)  then 'Y'
          when cast(si1.data_type as varchar) = 'datetime' and ic1.DATA_TYPE like '%datetime%' then 'Y'
          when cast(si1.data_type as varchar) = 'char' and ic1.DATA_TYPE like '%char%' then 'Y'
          when cast(si1.data_type as varchar) = 'int' and ic1.DATA_TYPE = 'bigint' then 'Y'
          when cast(si1.data_type as varchar) = 'float' and ic1.DATA_TYPE in ('numeric', 'demical') then 'Y'
          else 'N'
        end as valid_datatype
  from
    (select
        tb_id, tbnm, col_id, colnm, data_type, data_type2
      from @resultSchema.schema_info where stage_gb = 'cdm') as si1
    left join (select distinct TABLE_NAME, COLUMN_NAME, DATA_TYPE from @cdm.INFORMATION_SCHEMA.COLUMNS) as ic1
       on cast(si1.tbnm as varchar) = ic1.TABLE_NAME and cast(si1.colnm as varchar) = ic1.COLUMN_NAME)

 insert into @resultSchema.dq_check_result
  select
         'C3' as check_id
        ,tb_id as stratum1
        ,'cdm' as stratum2
        ,tbnm  as stratum3
        ,colnm as stratum4
        ,DATA_TYPE as stratum5
        ,null as count_val
        ,null as num_val
        ,valid_datatype as txt_val
  from rawdata ;
