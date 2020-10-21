/*************************************************************************/
--  Assigment: conformance-value
--  Description:  Table constraints type conformance check
--  Author: Enzo Byun
--  Date: 11.Jan, 2020
--  Job name:  Table constraints type conformance check
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
    ,ic1.IS_NULLABLE as is_nullable
    ,case
        when cast(si1.is_nullable as varchar) = ic1.IS_NULLABLE then 'Y'
      else 'N'
      end as constraints_valid
  from
    (select
        tb_id, tbnm, col_id, colnm, is_nullable
      from @resultSchema.schema_info where stage_gb = 'CDM') as si1
    left join (select distinct TABLE_NAME, COLUMN_NAME, IS_NULLABLE from @cdm.INFORMATION_SCHEMA.COLUMNS) as ic1
       on cast(si1.tbnm as varchar) = ic1.TABLE_NAME and cast(si1.colnm as varchar) = ic1.COLUMN_NAME)

 insert into @resultSchema.dq_check_result
  select
         'C4' as check_id
        ,tb_id as stratum1
        ,'cdm' as stratum2
        ,tbnm as stratum3
        ,colnm as stratum4
        ,is_nullable  as stratum5
        ,null as count_val
        ,null as num_val
        ,constraints_valid as txt_val
    from rawdata ;