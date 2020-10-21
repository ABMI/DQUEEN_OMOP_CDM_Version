--regression1 (CDM Measurement : regression male)
select
                 row_number() over(order by newid()) AS id
                ,m1.person_id
                ,m1.measurement_concept_id
                ,m1.measurement_date
                ,(datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) as age
                ,(case
                when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  10
                    then '0'
                    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  20
                    then '10'
                    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  30
                    then '20'
                    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  40
                    then '30'
                    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  50
                    then '40'
                    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  60
                    then '50'
                    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  70
                    then '60'
                    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  80
                    then '70'
                    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  90
                    then '80'
                    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  100
                    then '90'
                    else '100'
                    end ) as age_group
                ,m1.value_as_number

              from
                (select  person_id
                        ,measurement_id
                        ,measurement_concept_id
                        ,measurement_date
                        ,value_as_number
                    from @cdmSchema.Measurement
                  where  measurement_concept_id = @concept_id and value_as_number is not null 
				  		and ISNUMERIC(value_as_number) =1 ) as m1
              inner join
                (select
                      person_id
                     ,year_of_birth
                  from @cdmSchema.person
                  where gender_concept_id = 8507) as p1
                on p1.person_id = m1.person_id ;

--regression2 (CDM Measurement : regression female)
select
    row_number() over(order by newid()) AS id
,m1.person_id
,m1.measurement_concept_id
,m1.measurement_date
,(datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) as age
,(case
when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  10
    then '0'
    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  20
    then '10'
    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  30
    then '20'
    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  40
    then '30'
    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  50
    then '40'
    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  60
    then '50'
    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  70
    then '60'
    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  80
    then '70'
    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  90
    then '80'
    when  (datepart(year,m1.MEASUREMENT_date) - p1.year_of_birth) <  100
    then '90'
    else '100'
    end ) as age_group
,m1.value_as_number
from
(select  person_id
        ,measurement_id
        ,measurement_concept_id
        ,measurement_date
        ,value_as_number
    from @cdmSchema.Measurement
    where  measurement_concept_id = @concept_id and value_as_number is not null 
		and ISNUMERIC(value_as_number) =1 ) as m1
inner join
(select
        person_id
        ,year_of_birth
    from @cdmSchema.person
    where gender_concept_id = 8532) as p1
on p1.person_id = m1.person_id ;