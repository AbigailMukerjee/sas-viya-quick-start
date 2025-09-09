PROC SURVEYSELECT DATA=public.claims_amar_q2
                 OUT=public.ClaimsScore_1_Q1 (promote=yes)
                 METHOD=SRS
                 N=2000
                 SEED=12345;
RUN;

proc sql;
    create table HI_CLAIMS_FRAUD_2 as select * from public.claims_2_q2 where 
    Customer_ID not in (select Customer_ID from public.ClaimsScore_1_Q1);
quit;

PROC SURVEYSELECT DATA=HI_CLAIMS_FRAUD_2
                 OUT=public.ClaimsScore_2_Q2 (promote=yes)
                 METHOD=SRS
                 N=2000
                 SEED=12345;
RUN;

proc sql;
    create table HI_CLAIMS_FRAUD_3 as select * from HI_CLAIMS_FRAUD_2 where 
    Customer_ID not in (select Customer_ID from public.ClaimsScore_2_Q2);
quit;

PROC SURVEYSELECT DATA=HI_CLAIMS_FRAUD_3
                 OUT=public.ClaimsScore_3_Q3 (promote=yes)
                 METHOD=SRS
                 N=2000
                 SEED=12345;
RUN;

proc sql;
    create table HI_CLAIMS_FRAUD_4 as select * from HI_CLAIMS_FRAUD_3 where 
    Customer_ID not in (select Customer_ID from public.ClaimsScore_3_Q3);
quit;


PROC SURVEYSELECT DATA=HI_CLAIMS_FRAUD_4
                 OUT=public.ClaimsScore_4_Q4 (promote=yes)
                 METHOD=SRS
                 N=2000
                 SEED=12345;
RUN;

proc freq data=public.ClaimsScore_1_Q1;
    table target;
run;

proc freq data=public.ClaimsScore_2_Q2;
    table target;
run;


proc freq data=public.ClaimsScore_3_Q3;
    table target;
run;

proc freq data=public.ClaimsScore_4_Q4;
    table target;
run;

proc sql;
    create table HI_CLAIMS_FRAUD_5 as select * from HI_CLAIMS_FRAUD_4 where 
    Customer_ID not in (select Customer_ID from public.ClaimsScore_4_Q4);
quit;
