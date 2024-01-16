--------------------------------------------------------
--  File created - Tuesday-December-05-2023   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View CUSTOMERHISTORYVIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HANNENGUSER"."CUSTOMERHISTORYVIEW" ("ID", "NAME", "EMAIL", "PHONE", "OLDADDRESS", "NEWADDRESS", "CHANGEDATE") AS 
  SELECT c.id, c.name, c.email, c.phone, h.OldAddress, h.NewAddress, h.ChangeDate
FROM Customers c
LEFT JOIN CustomerAddressHistory h ON c.id = h.CustomerID
ORDER BY h.ChangeDate DESC
;
--------------------------------------------------------
--  DDL for Trigger TRG_UPDATE_CUSTOMER_VIEW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HANNENGUSER"."TRG_UPDATE_CUSTOMER_VIEW" 
INSTEAD OF UPDATE ON HANNENGUSER.CustomerHistoryView
FOR EACH ROW
BEGIN
    UPDATE HANNENGUSER.Customers
    SET name = :NEW.NAME,
        email = :NEW.EMAIL,
        phone = :NEW.PHONE,
        address = :NEW.NEWADDRESS
    WHERE id = :OLD.ID;

    IF (:OLD.OLDADDRESS IS NOT NULL AND :NEW.NEWADDRESS IS NOT NULL AND :OLD.OLDADDRESS != :NEW.NEWADDRESS) 
    OR (:OLD.OLDADDRESS IS NULL AND :NEW.NEWADDRESS IS NOT NULL) 
    OR (:OLD.OLDADDRESS IS NOT NULL AND :NEW.NEWADDRESS IS NULL) THEN
        INSERT INTO HANNENGUSER.CustomerAddressHistory (HistoryID, CustomerID, OldAddress, NewAddress, ChangeDate)
        VALUES (HANNENGUSER.CUSTOMERADDRHIST_SEQ.NEXTVAL, :OLD.ID, :OLD.OLDADDRESS, :NEW.NEWADDRESS, SYSTIMESTAMP);
    END IF;
END;
/
ALTER TRIGGER "HANNENGUSER"."TRG_UPDATE_CUSTOMER_VIEW" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_INSERT_CUSTOMER_VIEW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HANNENGUSER"."TRG_INSERT_CUSTOMER_VIEW" 
INSTEAD OF INSERT ON HANNENGUSER.CustomerHistoryView
FOR EACH ROW
BEGIN
    -- ??Customers??ID???????????????
    INSERT INTO HANNENGUSER.Customers (id, name, email, phone, address)
    VALUES (:NEW.id, :NEW.name, :NEW.email, :NEW.phone, :NEW.NEWADDRESS);

    -- ???CustomerAddressHistory??????????HistoryID
    INSERT INTO HANNENGUSER.CustomerAddressHistory (HistoryID, CustomerID, OldAddress, NewAddress, ChangeDate)
    VALUES (HANNENGUSER.CUSTOMERADDRHIST_SEQ.NEXTVAL, :NEW.id, NULL, :NEW.NEWADDRESS, SYSTIMESTAMP);
END;
/
ALTER TRIGGER "HANNENGUSER"."TRG_INSERT_CUSTOMER_VIEW" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_DELETE_CUSTOMER_VIEW
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HANNENGUSER"."TRG_DELETE_CUSTOMER_VIEW" 
INSTEAD OF DELETE ON HANNENGUSER.CustomerHistoryView
FOR EACH ROW
BEGIN
    DELETE FROM HANNENGUSER.CustomerAddressHistory WHERE customerid = :OLD.ID;
    DELETE FROM HANNENGUSER.Customers WHERE id = :OLD.ID;
END;
/
ALTER TRIGGER "HANNENGUSER"."TRG_DELETE_CUSTOMER_VIEW" ENABLE;
