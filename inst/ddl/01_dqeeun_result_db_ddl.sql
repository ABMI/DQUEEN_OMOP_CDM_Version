/*************************************************************************/
--  Assigment: Reulst DB DDL
--  Description: Create DQUEEN's result DB script
--  Author: Enzo Byun
--  Date: 18.02 ,2020
--  Job name:  Create DQUEEN's result DB script
--  Language: MSSQL
--  Target data: cdm
-- /*************************************************************************/
IF OBJECT_ID('@resultSchema.schema_info', 'U') IS NOT NULL 
DROP TABLE @resultSchema.schema_info; 
create table @resultSchema.schema_info(
 stage_gb	varchar(50)
,tb_id	int
,tbnm	varchar(100)
,col_id	int
,colnm	varchar(100)
,sk_yn	varchar(50)
,ck_yn	varchar(50)
,fk_yn	varchar(50)
,is_nullable	varchar(50)
,data_type	varchar(50)
,data_type2	varchar(50)
,character_maximum_length	varchar(50)
,numeric_precision	varchar(50)
,datetime_precision	varchar(50)
,check_gb varchar(10)
)
--
IF OBJECT_ID('@resultSchema.schema_capacity', 'U') IS NOT NULL 
DROP TABLE @resultSchema.schema_capacity; 
create table @resultSchema.schema_capacity(
 stage_gb	varchar(50)
,tb_id	int
,db_nm	varchar(255)
,schema_nm	varchar(255)
,tbnm	varchar(255)
,tb_type	varchar(255)
,total_rows	int
,tb_size	int
,unit	varchar(50)
)
IF OBJECT_ID('@resultSchema.rule_info', 'U') IS NOT NULL 
DROP TABLE @resultSchema.rule_info; 
create table @resultSchema.rule_info(
 rule_id	varchar(50)
,check_id	varchar(50)
,tb_id	int
,rule_desc	varchar(500)
,category	varchar(255)
,sub_category	varchar(255)
,stage_gb	varchar(50)
)
--
IF OBJECT_ID('@resultSchema.dq_check', 'U') IS NOT NULL 
DROP TABLE @resultSchema.dq_check; 
create table @resultSchema.dq_check(
 stage_gb	varchar(50)
,check_id	varchar(50)
,sub_category	varchar(255)
,check_desc	varchar(500)
,stratum1	varchar(255)
,stratum2	varchar(255)
,stratum3	varchar(255)
,stratum4	varchar(255)
,stratum5	varchar(255)
,stratum6	varchar(255)
,DQ_TYPE	varchar(20) )
--
IF OBJECT_ID('@resultSchema.dq_result_statics', 'U') IS NOT NULL 
DROP TABLE @resultSchema.dq_result_statics; 
create table @resultSchema.dq_result_statics (
 check_id	varchar(50)
,stratum1	varchar(255)
,stratum2	varchar(255)
,stratum3	varchar(255)
,stratum4	varchar(255)
,stratum5 varchar(255)
,count_val	varchar(255)
,ohter_val	varchar(200)
,min	varchar(100)
,max	varchar(100)
,avg	varchar(100)
,stdev	varchar(100)
,median	varchar(100)
,p_10	varchar(100)
,p_25	varchar(100)
,p_75	varchar(100)
,p_90	varchar(100) )
--
IF OBJECT_ID('@resultSchema.dq_result_derived', 'U') IS NOT NULL 
DROP TABLE @resultSchema.dq_result_derived; 
create table @resultSchema.dq_result_derived(
 check_id	varchar(50)
,	stratum1	varchar(255)
,	stratum2	varchar(255)
,	stratum3	varchar(255)
,	stratum4	varchar(255)
,	stratum5	varchar(255)
,	count_val	varchar(100)
,	statics_val	varchar(100)
,	val_typ	varchar(50)
,	measure_typ	varchar(50) )
--
IF OBJECT_ID('@resultSchema.dq_summary', 'U') IS NOT NULL 
DROP TABLE @resultSchema.dq_summary; 
create table @resultSchema.dq_summary(
 rule_id	varchar(50)
,check_id	varchar(50)
,tb_id	varchar(50)
,sub_category	varchar(100)
,dq_msg	varchar(500)
,count_Val	varchar(100) )
--
IF OBJECT_ID('@resultSchema.score_result', 'U') IS NOT NULL 
DROP TABLE @resultSchema.score_result; 
create table @resultSchema.score_result (
stage_gb [varchar](100) NULL
,tb_id	int
,category	varchar(100)
,sub_category	varchar(100)
,err_rate	varchar(100)
,score	varchar(100) )
--
IF OBJECT_ID('@resultSchema.archive_data', 'U') IS NOT NULL 
DROP TABLE @resultSchema.archive_data; 
create table @resultSchema.archive_data(
 tb_id	int
,id	varchar(50)
,stratum1	varchar(255)
,stratum2	varchar(255)
,stratum3	varchar(255)
,num_val	varchar(255)
,count_val	varchar(255))
--
IF OBJECT_ID('@resultSchema.dq_check_result', 'U') IS NOT NULL 
DROP TABLE @resultSchema.dq_check_result; 
create table @resultSchema.dq_check_result(
 check_id	varchar(50)
,stratum1	varchar(255)
,stratum2	varchar(255)
,stratum3	varchar(255)
,stratum4	varchar(255)
,stratum5	varchar(255)
,count_val	varchar(100)
,num_val	varchar(100)
,txt_val	varchar(100) )
--
IF OBJECT_ID('@resultSchema.score_log_meta', 'U') IS NOT NULL 
DROP TABLE @resultSchema.score_log_meta; 
create table @resultSchema.score_log_meta(
 check_id	varchar(50)
,tb_id	int
,stratum1	varchar(255)
,stratum2	varchar(255)
,stratum3	varchar(255)
,stratum4 varchar(255)
,stratum5 varchar(255)
,err_no	varchar(255) )
--
IF OBJECT_ID('@resultSchema.score_log_CDM', 'U') IS NOT NULL 
DROP TABLE @resultSchema.score_log_CDM; 
create table @resultSchema.score_log_CDM(
 check_id	varchar(50)
,tb_id	int
,stratum1	varchar(255)
,stratum2	varchar(255)
,stratum3	varchar(255)
,stratum4 varchar(255)
,stratum5 varchar(255)
,err_no	varchar(255) ) ;

