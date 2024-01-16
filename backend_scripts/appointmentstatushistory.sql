--------------------------------------------------------
--  File created - Tuesday-December-05-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table APPOINTMENTSTATUSHISTORY
--------------------------------------------------------

  CREATE TABLE "HANNENGUSER"."APPOINTMENTSTATUSHISTORY" 
   (	"HISTORYID" NUMBER(*,0), 
	"APPOINTMENTID" NUMBER(*,0), 
	"OLDSTATUS" VARCHAR2(30 BYTE), 
	"NEWSTATUS" VARCHAR2(30 BYTE), 
	"CHANGEDATE" TIMESTAMP (6)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  DDL for Index SYS_C007722
--------------------------------------------------------

  CREATE UNIQUE INDEX "HANNENGUSER"."SYS_C007722" ON "HANNENGUSER"."APPOINTMENTSTATUSHISTORY" ("HISTORYID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "USERS" ;
--------------------------------------------------------
--  Constraints for Table APPOINTMENTSTATUSHISTORY
--------------------------------------------------------

  ALTER TABLE "HANNENGUSER"."APPOINTMENTSTATUSHISTORY" ADD PRIMARY KEY ("HISTORYID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table APPOINTMENTSTATUSHISTORY
--------------------------------------------------------

  ALTER TABLE "HANNENGUSER"."APPOINTMENTSTATUSHISTORY" ADD FOREIGN KEY ("APPOINTMENTID")
	  REFERENCES "HANNENGUSER"."APPOINTMENTS" ("ID") ENABLE;
