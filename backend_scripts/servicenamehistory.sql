--------------------------------------------------------
--  File created - Tuesday-December-05-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table SERVICENAMEHISTORY
--------------------------------------------------------

  CREATE TABLE "HANNENGUSER"."SERVICENAMEHISTORY" 
   (	"HISTORY_ID" NUMBER(*,0), 
	"SERVICE_ID" NUMBER(*,0), 
	"OLD_NAME" VARCHAR2(30 BYTE), 
	"NEW_NAME" VARCHAR2(30 BYTE), 
	"CHANGE_DATE" TIMESTAMP (6)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
