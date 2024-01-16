--------------------------------------------------------
--  File created - Tuesday-December-05-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View TECHNICIANHISTORYVIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HANNENGUSER"."TECHNICIANHISTORYVIEW" ("ID", "NAME", "EMAIL", "ADDRESS", "OLDPHONE", "NEWPHONE", "CHANGEDATE") AS 
  SELECT t.id, t.name, t.email, t.address, h.OldPhone, h.NewPhone, h.ChangeDate
FROM Technicians t
LEFT JOIN TechnicianPhoneHistory h ON t.id = h.TechnicianID
ORDER BY h.ChangeDate DESC
;
--------------------------------------------------------
--  DDL for Trigger TRG_INSERT_TECHNICIAN_VIEW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HANNENGUSER"."TRG_INSERT_TECHNICIAN_VIEW" 
INSTEAD OF INSERT ON HANNENGUSER.TechnicianHistoryView
FOR EACH ROW
BEGIN
    INSERT INTO HANNENGUSER.Technicians (id, name, email, address, phone)
    VALUES (:NEW.id, :NEW.name, :NEW.email, :NEW.address, :NEW.NEWPHONE);

    -- Assuming TECHTELHIST_SEQ is the sequence created for TechnicianPhoneHistory
    INSERT INTO HANNENGUSER.TechnicianPhoneHistory (HistoryID, TechnicianID, OldPhone, NewPhone, ChangeDate)
    VALUES (HANNENGUSER.TECHTELHIST_SEQ.NEXTVAL, :NEW.id, NULL, :NEW.NEWPHONE, SYSTIMESTAMP);
END;
/
ALTER TRIGGER "HANNENGUSER"."TRG_INSERT_TECHNICIAN_VIEW" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_DELETE_TECHNICIAN_VIEW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HANNENGUSER"."TRG_DELETE_TECHNICIAN_VIEW" 
INSTEAD OF DELETE ON HANNENGUSER.TechnicianHistoryView
FOR EACH ROW
BEGIN
    -- Assuming TECHTELHIST_SEQ is the sequence created for TechnicianPhoneHistory
       DELETE FROM HANNENGUSER.TechnicianPhoneHistory WHERE technicianid = :OLD.ID;
    DELETE FROM HANNENGUSER.Technicians WHERE id = :OLD.id;
END;
/
ALTER TRIGGER "HANNENGUSER"."TRG_DELETE_TECHNICIAN_VIEW" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_UPDATE_TECHNICIAN_VIEW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HANNENGUSER"."TRG_UPDATE_TECHNICIAN_VIEW" 
INSTEAD OF UPDATE ON HANNENGUSER.TechnicianHistoryView
FOR EACH ROW
BEGIN
    UPDATE HANNENGUSER.Technicians
    SET name = :NEW.name,
        email = :NEW.email,
        address = :NEW.address,
        phone = :NEW.NEWPHONE
    WHERE id = :OLD.id;

    IF (:OLD.OLDPHONE IS NOT NULL AND :NEW.NEWPHONE IS NOT NULL AND :OLD.OLDPHONE != :NEW.NEWPHONE) 
    OR (:OLD.OLDPHONE IS NULL AND :NEW.NEWPHONE IS NOT NULL) 
    OR (:OLD.OLDPHONE IS NOT NULL AND :NEW.NEWPHONE IS NULL) THEN
        INSERT INTO HANNENGUSER.TechnicianPhoneHistory (HistoryID, TechnicianID, OldPhone, NewPhone, ChangeDate)
        VALUES (HANNENGUSER.TECHTELHIST_SEQ.NEXTVAL, :OLD.id, :OLD.OLDPHONE, :NEW.NEWPHONE, SYSTIMESTAMP);
    END IF;
END;
/
ALTER TRIGGER "HANNENGUSER"."TRG_UPDATE_TECHNICIAN_VIEW" ENABLE;
