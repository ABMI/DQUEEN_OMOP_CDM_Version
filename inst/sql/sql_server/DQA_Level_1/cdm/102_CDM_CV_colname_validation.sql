/*************************************************************************/
--  Assigment: conformance-value
--  Description: check the column name conformance
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name: validation with DB definition describe
--  Language: MSSQL
--  Target data: cdm
-->
/*************************************************************************/
  with rawdata as
  (select
    si1.*
  , case
      when ic1.TABLE_NAME is null and ic1.COLUMN_NAME is null then 'N'
      else 'Y'
    end as valid_col
  from
      (select
         tb_id
        ,tbnm
        ,col_id
        ,colnm
       from @resultSchema.schema_info
        where stage_gb = 'cdm') as si1
    left join (select distinct TABLE_NAME, COLUMN_NAME from @cdm.INFORMATION_SCHEMA.COLUMNS) as ic1
    on cast(si1.tbnm as varchar) = ic1.TABLE_NAME and cast(si1.colnm as varchar) = ic1.COLUMN_NAME)

insert into @resultSchema.dq_check_result
  select
         'C2' as check_id
        ,tb_id as stratum1
        ,'cdm' as stratum2
        ,tbnm  as stratum3
        ,colnm as stratum4
        ,null as stratum5
        ,null as count_val
        ,null as num_val
        ,valid_col as txt_val
  from rawdata
