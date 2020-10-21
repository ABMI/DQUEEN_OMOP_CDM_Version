/*************************************************************************/
--  Assigment: conformance-value
--  Description: check the meta table name conformance
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name: validation with table definition describe
--  Language: MSSQL
--  Target data: cdm
-->
/*************************************************************************/
with rawdata as
    (select
       si1.*
      ,case
         when ic1.TABLE_NAME is null then 'N'
         when ic1.TABLE_NAME is not null then 'Y'
        else null
      end as valid_tb
    from
    (select
         distinct
           cast(stage_gb as varchar) as stage_gb
          ,tb_id
          ,cast(tbnm as varchar) as tbnm
         from @resultSchema.schema_info
          where stage_gb = 'CDM') as si1
      left join (select distinct TABLE_NAME from @cdm.INFORMATION_SCHEMA.COLUMNS) as ic1
      on cast(si1.tbnm as varchar) = ic1.TABLE_NAME)

  insert into @resultSchema.dq_check_result
      select
           'C1' as check_id
          ,tb_id as stratum1
          ,stage_gb as stratum2
          ,tbnm as stratum3
          ,null as stratum4
          ,null as stratum5
          ,null as count_val
          ,null as num_val
          ,valid_tb as txt_val
      from rawdata
