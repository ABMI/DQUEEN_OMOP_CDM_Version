
select
 *
from byun_dqueen_v2.dbo.dq_score_valid_fn;
-- Completeness
select
*
,round((cast((ERR_0/total_row) as float)* cast(Completeness as float)),4) as Completeness_err_rate_0
,round((cast((ERR_10/total_row) as float)* cast(Completeness as float)),4 ) as Completeness_err_rate_10
,round((cast((ERR_20/total_row) as float)* cast(Completeness as float)),4 ) as Completeness_err_rate_20
,round((cast((ERR_30/total_row) as float)* cast(Completeness as float)),4) as Completeness_err_rate_30
,round((cast((ERR_40/total_row) as float)* cast(Completeness as float)),4) as Completeness_err_rate_40
,round((cast((ERR_50/total_row) as float)* cast(Completeness as float)),4) as Completeness_err_rate_50
,round((cast((ERR_60/total_row) as float)* cast(Completeness as float)),4) as Completeness_err_rate_60
,round((cast((ERR_70/total_row) as float)* cast(Completeness as float)),4) as Completeness_err_rate_70
,round((cast((ERR_80/total_row) as float)* cast(Completeness as float)),4) as Completeness_err_rate_80
,round((cast((ERR_90/total_row) as float)* cast(Completeness as float)),4) as Completeness_err_rate_90
,round((cast((ERR_100/total_row) as float)* cast(Completeness as float)),4) as Completeness_err_rate_100
-- Conformance-relation
,round((cast((ERR_0/total_row) as float)* cast(Relation as float)),4) as Conformance_relation_err_rate_0
,round((cast((ERR_10/total_row) as float)* cast(Relation as float)),4) as Conformance_relation_err_rate_10
,round((cast((ERR_20/total_row) as float)* cast(Relation as float)),4) as Conformance_relation_err_rate_20
,round((cast((ERR_30/total_row) as float)* cast(Relation as float)),4) as Conformance_relation_err_rate_30
,round((cast((ERR_40/total_row) as float)* cast(Relation as float)),4) as Conformance_relation_err_rate_40
,round((cast((ERR_50/total_row) as float)* cast(Relation as float)),4) as Conformance_relation_err_rate_50
,round((cast((ERR_60/total_row) as float)* cast(Relation as float)),4) as Conformance_relation_err_rate_60
,round((cast((ERR_70/total_row) as float)* cast(Relation as float)),4) as Conformance_relation_err_rate_70
,round((cast((ERR_80/total_row) as float)* cast(Relation as float)),4) as Conformance_relation_err_rate_80
,round((cast((ERR_90/total_row) as float)* cast(Relation as float)),4) as Conformance_relation_err_rate_90
,round((cast((ERR_100/total_row) as float)* cast(Relation as float)),4) as Conformance_relation_err_rate_100
-- Conformance-value
,round((cast((ERR_0/total_row) as float)* cast(Value as float)),4) as Conformance_value_err_rate_0
,round((cast((ERR_10/total_row) as float)* cast(Value as float)),4) as Conformance_value_err_rate_10
,round((cast((ERR_20/total_row) as float)* cast(Value as float)),4) as Conformance_value_err_rate_20
,round((cast((ERR_30/total_row) as float)* cast(Value as float)),4) as Conformance_value_err_rate_30
,round((cast((ERR_40/total_row) as float)* cast(Value as float)),4) as Conformance_value_err_rate_40
,round((cast((ERR_50/total_row) as float)* cast(Value as float)),4) as Conformance_value_err_rate_50
,round((cast((ERR_60/total_row) as float)* cast(Value as float)),4) as Conformance_value_err_rate_60
,round((cast((ERR_70/total_row) as float)* cast(Value as float)),4) as Conformance_value_err_rate_70
,round((cast((ERR_80/total_row) as float)* cast(Value as float)),4) as Conformance_value_err_rate_80
,round((cast((ERR_90/total_row) as float)* cast(Value as float)),4) as Conformance_value_err_rate_90
,round((cast((ERR_100/total_row) as float)* cast(Value as float)),4) as Conformance_value_err_rate_100
-- Uniqueness
,round((cast((ERR_0/total_row) as float)* cast(Uniqueness as float)),4) as Uniqueness_err_rate_0
,round((cast((ERR_10/total_row) as float)* cast(Uniqueness as float)),4) as Uniqueness_err_rate_10
,round((cast((ERR_20/total_row) as float)* cast(Uniqueness as float)),4) as Uniqueness_err_rate_20
,round((cast((ERR_30/total_row) as float)* cast(Uniqueness as float)),4) as Uniqueness_err_rate_30
,round((cast((ERR_40/total_row) as float)* cast(Uniqueness as float)),4) as Uniqueness_err_rate_40
,round((cast((ERR_50/total_row) as float)* cast(Uniqueness as float)),4) as Uniqueness_err_rate_50
,round((cast((ERR_60/total_row) as float)* cast(Uniqueness as float)),4) as Uniqueness_err_rate_60
,round((cast((ERR_70/total_row) as float)* cast(Uniqueness as float)),4) as Uniqueness_err_rate_70
,round((cast((ERR_80/total_row) as float)* cast(Uniqueness as float)),4) as Uniqueness_err_rate_80
,round((cast((ERR_90/total_row) as float)* cast(Uniqueness as float)),4) as Uniqueness_err_rate_90
,round((cast((ERR_100/total_row) as float)* cast(Uniqueness as float)),4) as Uniqueness_err_rate_100
-- Atemporal
,round((cast((ERR_0/total_row) as float)* cast(Atemporal as float)),4) as Atemporal_err_rate_0
,round((cast((ERR_10/total_row) as float)* cast(Atemporal as float)),4) as Atemporal_err_rate_10
,round((cast((ERR_20/total_row) as float)* cast(Atemporal as float)),4) as Atemporal_err_rate_20
,round((cast((ERR_30/total_row) as float)* cast(Atemporal as float)),4) as Atemporal_err_rate_30
,round((cast((ERR_40/total_row) as float)* cast(Atemporal as float)),4) as Atemporal_err_rate_40
,round((cast((ERR_50/total_row) as float)* cast(Atemporal as float)),4) as Atemporal_err_rate_50
,round((cast((ERR_60/total_row) as float)* cast(Atemporal as float)),4) as Atemporal_err_rate_60
,round((cast((ERR_70/total_row) as float)* cast(Atemporal as float)),4) as Atemporal_err_rate_70
,round((cast((ERR_80/total_row) as float)* cast(Atemporal as float)),4) as Atemporal_err_rate_80
,round((cast((ERR_90/total_row) as float)* cast(Atemporal as float)),4) as Atemporal_err_rate_90
,round((cast((ERR_100/total_row) as float)* cast(Atemporal as float)),4) as Atemporal_err_rate_100
-- Accuracy
,round((cast((ERR_0/total_row) as float)* cast(Accuracy as float)),4) as Accuracy_err_rate_0
,round((cast((ERR_10/total_row) as float)* cast(Accuracy as float)),4) as Accuracy_err_rate_10
,round((cast((ERR_20/total_row) as float)* cast(Accuracy as float)),4) as Accuracy_err_rate_20
,round((cast((ERR_30/total_row) as float)* cast(Accuracy as float)),4) as Accuracy_err_rate_30
,round((cast((ERR_40/total_row) as float)* cast(Accuracy as float)),4) as Accuracy_err_rate_40
,round((cast((ERR_50/total_row) as float)* cast(Accuracy as float)),4) as Accuracy_err_rate_50
,round((cast((ERR_60/total_row) as float)* cast(Accuracy as float)),4) as Accuracy_err_rate_60
,round((cast((ERR_70/total_row) as float)* cast(Accuracy as float)),4) as Accuracy_err_rate_70
,round((cast((ERR_80/total_row) as float)* cast(Accuracy as float)),4) as Accuracy_err_rate_80
,round((cast((ERR_90/total_row) as float)* cast(Accuracy as float)),4) as Accuracy_err_rate_90
,round((cast((ERR_100/total_row) as float)* cast(Accuracy as float)),4) as Accuracy_err_rate_100
  into Byun_dqueen_v2.dbo.score_validation_step2
from byun_dqueen_V2.dbo.dq_score_valid_fn
where total_row not in (0)


--
select
 cast(stage_gb as varchar) as stage_gb
,tb_id
,round(1.0-sum(Completeness_err_rate_0),4) Completeness_err_rate_0
,round(1.0-sum(Completeness_err_rate_10),4) Completeness_err_rate_10
,round(1.0-sum(Completeness_err_rate_20),4) Completeness_err_rate_20
,round(1.0-sum(Completeness_err_rate_30),4) Completeness_err_rate_30
,round(1.0-sum(Completeness_err_rate_40),4) Completeness_err_rate_40
,round(1.0-sum(Completeness_err_rate_50),4) Completeness_err_rate_50
,round(1.0-sum(Completeness_err_rate_60),4) Completeness_err_rate_60
,round(1.0-sum(Completeness_err_rate_70),4) Completeness_err_rate_70
,round(1.0-sum(Completeness_err_rate_80),4) Completeness_err_rate_80
,round(1.0-sum(Completeness_err_rate_90),4) Completeness_err_rate_90
,round(1.0-sum(Completeness_err_rate_100),4) Completeness_err_rate_100
,round(1.0-sum(Conformance_relation_err_rate_0),4) Conformance_relation_err_rate_0
,round(1.0-sum(Conformance_relation_err_rate_10),4) Conformance_relation_err_rate_10
,round(1.0-sum(Conformance_relation_err_rate_20),4) Conformance_relation_err_rate_20
,round(1.0-sum(Conformance_relation_err_rate_30),4) Conformance_relation_err_rate_30
,round(1.0-sum(Conformance_relation_err_rate_40),4) Conformance_relation_err_rate_40
,round(1.0-sum(Conformance_relation_err_rate_50),4) Conformance_relation_err_rate_50
,round(1.0-sum(Conformance_relation_err_rate_60),4) Conformance_relation_err_rate_60
,round(1.0-sum(Conformance_relation_err_rate_70),4) Conformance_relation_err_rate_70
,round(1.0-sum(Conformance_relation_err_rate_80),4) Conformance_relation_err_rate_80
,round(1.0-sum(Conformance_relation_err_rate_90),4) Conformance_relation_err_rate_90
,round(1.0-sum(Conformance_relation_err_rate_100),4) Conformance_relation_err_rate_100
,round(1.0-sum(Conformance_value_err_rate_0),4) Conformance_value_err_rate_0
,round(1.0-sum(Conformance_value_err_rate_10),4) Conformance_value_err_rate_10
,round(1.0-sum(Conformance_value_err_rate_20),4) Conformance_value_err_rate_20
,round(1.0-sum(Conformance_value_err_rate_30),4) Conformance_value_err_rate_30
,round(1.0-sum(Conformance_value_err_rate_40),4) Conformance_value_err_rate_40
,round(1.0-sum(Conformance_value_err_rate_50),4) Conformance_value_err_rate_50
,round(1.0-sum(Conformance_value_err_rate_60),4) Conformance_value_err_rate_60
,round(1.0-sum(Conformance_value_err_rate_70),4) Conformance_value_err_rate_70
,round(1.0-sum(Conformance_value_err_rate_80),4) Conformance_value_err_rate_80
,round(1.0-sum(Conformance_value_err_rate_90),4) Conformance_value_err_rate_90
,round(1.0-sum(Conformance_value_err_rate_100),4) Conformance_value_err_rate_100
,round(1.0-sum(Uniqueness_err_rate_0),4) Uniqueness_err_rate_0
,round(1.0-sum(Uniqueness_err_rate_10),4) Uniqueness_err_rate_10
,round(1.0-sum(Uniqueness_err_rate_20),4) Uniqueness_err_rate_20
,round(1.0-sum(Uniqueness_err_rate_30),4) Uniqueness_err_rate_30
,round(1.0-sum(Uniqueness_err_rate_40),4) Uniqueness_err_rate_40
,round(1.0-sum(Uniqueness_err_rate_50),4) Uniqueness_err_rate_50
,round(1.0-sum(Uniqueness_err_rate_60),4) Uniqueness_err_rate_60
,round(1.0-sum(Uniqueness_err_rate_70),4) Uniqueness_err_rate_70
,round(1.0-sum(Uniqueness_err_rate_80),4) Uniqueness_err_rate_80
,round(1.0-sum(Uniqueness_err_rate_90),4) Uniqueness_err_rate_90
,round(1.0-sum(Uniqueness_err_rate_100),4) Uniqueness_err_rate_100
,round(1.0-sum(Atemporal_err_rate_0),4) Atemporal_err_rate_0
,round(1.0-sum(Atemporal_err_rate_10),4) Atemporal_err_rate_10
,round(1.0-sum(Atemporal_err_rate_20),4) Atemporal_err_rate_20
,round(1.0-sum(Atemporal_err_rate_30),4) Atemporal_err_rate_30
,round(1.0-sum(Atemporal_err_rate_40),4) Atemporal_err_rate_40
,round(1.0-sum(Atemporal_err_rate_50),4) Atemporal_err_rate_50
,round(1.0-sum(Atemporal_err_rate_60),4) Atemporal_err_rate_60
,round(1.0-sum(Atemporal_err_rate_70),4) Atemporal_err_rate_70
,round(1.0-sum(Atemporal_err_rate_80),4) Atemporal_err_rate_80
,round(1.0-sum(Atemporal_err_rate_90),4) Atemporal_err_rate_90
,round(1.0-sum(Atemporal_err_rate_100),4) Atemporal_err_rate_100
,round(1.0-sum(Accuracy_err_rate_0),4) Accuracy_err_rate_0
,round(1.0-sum(Accuracy_err_rate_10),4) Accuracy_err_rate_10
,round(1.0-sum(Accuracy_err_rate_20),4) Accuracy_err_rate_20
,round(1.0-sum(Accuracy_err_rate_30),4) Accuracy_err_rate_30
,round(1.0-sum(Accuracy_err_rate_40),4) Accuracy_err_rate_40
,round(1.0-sum(Accuracy_err_rate_50),4) Accuracy_err_rate_50
,round(1.0-sum(Accuracy_err_rate_60),4) Accuracy_err_rate_60
,round(1.0-sum(Accuracy_err_rate_70),4) Accuracy_err_rate_70
,round(1.0-sum(Accuracy_err_rate_80),4) Accuracy_err_rate_80
,round(1.0-sum(Accuracy_err_rate_90),4) Accuracy_err_rate_90
,round(1.0-sum(Accuracy_err_rate_100),4) as Accuracy_err_rate_100
from Byun_dqueen_v2.dbo.score_validation_step2
group by  cast(stage_gb as varchar),tb_id


select
 cast(stage_gb as varchar)
,tb_id
,sum(cast(Completeness as float)) as Completeness
,sum(cast(Relation as float)) as Relation
,sum(cast(Value as float)) as Value
,sum(cast(Uniqueness as float)) as uniqueness
,sum(cast(Atemporal as float)) as Atemporal
,sum(cast(Accuracy as float)) as Accuracy
from Byun_dqueen_v2.dbo.dq_score_valid
group by  cast(stage_gb as varchar)
,tb_id;

select
tb_id
,sum(cast(Completeness as float)) as Completeness
,sum(cast(Relation as float)) as Relation
,sum(cast(Value as float)) as Value
,sum(cast(Uniqueness as float)) as uniqueness
,sum(cast(Atemporal as float)) as Atemporal
,sum(cast(Accuracy as float)) as Accuracy
from Byun_dqueen_v2.dbo.dq_score_valid
  where cast(stage_gb as varchar) = 'CDM'
and tb_id =38
group by tb_id

select
*
from Byun_dqueen_v2.dbo.dq_score_valid
  where cast(stage_gb as varchar) = 'CDM'
and tb_id =38

select
[stage_gb ]
,tb_id
,round(sum(cast(Completeness as float)),4) as Completeness
,round(sum(cast(Relation as float)),4) as Relation
,round(sum(cast(Value as float)),4) as Value
,round(sum(cast(Uniqueness as float)),4) as uniqueness
,round(sum(cast(Atemporal as float)),4) as Atemporal
,round(sum(cast(Accuracy as float)),4) as Accurac
from Byun_dqueen_v2.dbo.dq_score_valid_fn
group by [stage_gb ],tb_id


select * from Byun_dqueen_v2.dbo.dq_score_valid