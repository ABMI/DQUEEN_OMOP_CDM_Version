select
top @randParameter
*
into @targetCdmSchema.person
from @originCdmSchema.person
order by newid();
--
select
*
into @targetCdmSchema.care_site
from @originCdmSchema.care_site;
--
select
*
into @targetCdmSchema.provider
from @originCdmSchema.provider;
--
select
*
into @targetCdmSchema.death
from @originCdmSchema.death
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.location
from @originCdmSchema.location;
--
select
*
into @targetCdmSchema.drug_exposure
from @originCdmSchema.drug_exposure
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.device_exposure
from @originCdmSchema.device_exposure
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.procedure_occurrence
from @originCdmSchema.procedure_occurrence
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.condition_occurrence
from @originCdmSchema.condition_occurrence
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.note
from @originCdmSchema.note
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.observation
from @originCdmSchema.observation
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.condition_era
from @originCdmSchema.condition_era
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.dose_era
from @originCdmSchema.dose_era
where person_id in (select person_id from @targetCdmSchema.person);
--
CREATE TABLE @targetCdmSchema.cost
(
  cost_id					          INTEGER	    NOT NULL ,
  cost_event_id             INTEGER     NOT NULL ,
  cost_domain_id            VARCHAR(20) NOT NULL ,
  cost_type_concept_id      INTEGER     NOT NULL ,
  currency_concept_id			  INTEGER			NULL ,
  total_charge						  FLOAT			  NULL ,
  total_cost						    FLOAT			  NULL ,
  total_paid						    FLOAT			  NULL ,
  paid_by_payer					    FLOAT			  NULL ,
  paid_by_patient						FLOAT			  NULL ,
  paid_patient_copay				FLOAT			  NULL ,
  paid_patient_coinsurance  FLOAT			  NULL ,
  paid_patient_deductible		FLOAT			  NULL ,
  paid_by_primary						FLOAT			  NULL ,
  paid_ingredient_cost			FLOAT			  NULL ,
  paid_dispensing_fee				FLOAT			  NULL ,
  payer_plan_period_id			INTEGER			NULL ,
  amount_allowed		        FLOAT			  NULL ,
  revenue_code_concept_id		INTEGER			NULL ,
  revenue_code_source_value  VARCHAR(50) NULL,
  drg_concept_id			      INTEGER		  NULL,
  drg_source_value			    VARCHAR(3)	NULL
)

--
select
*
into @targetCdmSchema.concept
from @originCdmSchema.concept;
--
select
*
into @targetCdmSchema.payer_plan_period
from @originCdmSchema.payer_plan_period
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.observation_period
from @originCdmSchema.observation_period
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.specimen
from @originCdmSchema.specimen
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.visit_detail
from @originCdmSchema.visit_detail
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.visit_occurrence
from @originCdmSchema.visit_occurrence
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.measurement
from @originCdmSchema.measurement
where person_id in (select person_id from @targetCdmSchema.person);
--
select
*
into @targetCdmSchema.drug_era
from @originCdmSchema.drug_era
where person_id in (select person_id from @targetCdmSchema.person);
--
CREATE TABLE @targetCdmSchema.note_nlp
(
  note_nlp_id					        INTEGER			  NOT NULL ,
  note_id						          INTEGER			  NOT NULL ,
  section_concept_id			    INTEGER			  NULL ,
  snippet						          VARCHAR(250)	NULL ,
  "offset"					          VARCHAR(250)	NULL ,
  lexical_variant				      VARCHAR(250)	NOT NULL ,
  note_nlp_concept_id			    INTEGER			  NULL ,
  note_nlp_source_concept_id  INTEGER			  NULL ,
  nlp_system					        VARCHAR(250)	NULL ,
  nlp_date						        DATE			    NOT NULL ,
  nlp_datetime					      DATETIME2		  NULL ,
  term_exists					        VARCHAR(1)		NULL ,
  term_temporal					      VARCHAR(50)		NULL ,
  term_modifiers				      VARCHAR(2000)	NULL
)
;
--
select
*
into @targetCdmSchema.drug_strength
from @originCdmSchema.drug_strength;