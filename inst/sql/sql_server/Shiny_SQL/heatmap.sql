--heatmap1 (META Main : heatmap)
select
 db_nm as TABLE_CATALOG
,schema_nm as TABLE_SCHEMA
,tbnm as TABLE_NAME
,tb_type as TABLE_TYPE
,total_rows as rows
,tb_size as table_size
,unit as UNIT
from @resultSchema.schema_capacity
where stage_gb = 'CDM'
and tb_id not in (1,2,3,4,5,6,7,8,9,10,11,17,21,22,25,34,35,39);

--heatmap2 (CDM Main : heatmap)
select
 db_nm as TABLE_CATALOG
,schema_nm as TABLE_SCHEMA
,tbnm as TABLE_NAME
,tb_type as TABLE_TYPE
,total_rows as rows
,tb_size as table_size
,unit as UNIT
from @resultSchema.schema_capacity
where stage_gb = 'CDM'
and tb_id not in (1,2,3,4,5,6,7,8,9,10,11,17,21,22,25,34,35,39);