--------------------------------------------------------
--  File created - Tuesday-December-05-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View SERVICENAMEHISTORYVIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HANNENGUSER"."SERVICENAMEHISTORYVIEW" ("ID", "NAME", "OLD_NAME", "NEW_NAME", "CHANGE_DATE") AS 
  SELECT s.ID, s.NAME, h.OLD_NAME, h.NEW_NAME, h.CHANGE_DATE
FROM SERVICES s
LEFT JOIN SERVICENAMEHISTORY h ON s.ID = h.SERVICE_ID
ORDER BY h.CHANGE_DATE DESC
;
--------------------------------------------------------
--  DDL for Trigger TRG_UPDATE_SERVICENAME_VIEW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HANNENGUSER"."TRG_UPDATE_SERVICENAME_VIEW" 
INSTEAD OF UPDATE ON HANNENGUSER.SERVICENAMEHISTORYVIEW
FOR EACH ROW
BEGIN
    UPDATE HANNENGUSER.SERVICES
    SET NAME = :NEW.NAME
    WHERE ID = :OLD.ID;

    IF (:OLD.OLD_NAME IS NOT NULL AND :NEW.NEW_NAME IS NOT NULL AND :OLD.OLD_NAME != :NEW.NEW_NAME) 
    OR (:OLD.OLD_NAME IS NULL AND :NEW.NEW_NAME IS NOT NULL) 
    OR (:OLD.OLD_NAME IS NOT NULL AND :NEW.NEW_NAME IS NULL) THEN
        INSERT INTO HANNENGUSER.SERVICENAMEHISTORY (HISTORY_ID, SERVICE_ID, OLD_NAME, NEW_NAME, CHANGE_DATE)
        VALUES (HANNENGUSER.SERVICE_NAME_HIST_SEQ.NEXTVAL, :OLD.ID, :OLD.OLD_NAME, :NEW.NEW_NAME, SYSTIMESTAMP);
    END IF;
END;

/
ALTER TRIGGER "HANNENGUSER"."TRG_UPDATE_SERVICENAME_VIEW" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_INSERT_SERVICENAME_VIEW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HANNENGUSER"."TRG_INSERT_SERVICENAME_VIEW" 
INSTEAD OF INSERT ON HANNENGUSER.SERVICENAMEHISTORYVIEW
FOR EACH ROW
BEGIN
    INSERT INTO HANNENGUSER.SERVICES (ID, NAME)
    VALUES (:NEW.ID, :NEW.NAME);

    INSERT INTO HANNENGUSER.SERVICENAMEHISTORY (HISTORY_ID, SERVICE_ID, OLD_NAME, NEW_NAME, CHANGE_DATE)
    VALUES (HANNENGUSER.SERVICE_NAME_HIST_SEQ.NEXTVAL, :NEW.ID, NULL, :NEW.NAME, SYSTIMESTAMP);
END;

/
ALTER TRIGGER "HANNENGUSER"."TRG_INSERT_SERVICENAME_VIEW" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_DELETE_SERVICENAME_VIEW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HANNENGUSER"."TRG_DELETE_SERVICENAME_VIEW" 
INSTEAD OF DELETE ON HANNENGUSER.SERVICENAMEHISTORYVIEW
FOR EACH ROW
BEGIN
    DELETE FROM HANNENGUSER.SERVICENAMEHISTORY WHERE SERVICE_ID = :OLD.ID;
    DELETE FROM HANNENGUSER.SERVICES WHERE ID = :OLD.ID;
END;

/
ALTER TRIGGER "HANNENGUSER"."TRG_DELETE_SERVICENAME_VIEW" ENABLE;
