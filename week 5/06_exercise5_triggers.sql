-- ==========================================
-- Exercise 5: Triggers
-- ==========================================

SET SERVEROUTPUT ON;

-- ------------------------------------------
-- Scenario 1: UpdateCustomerLastModified
-- Automatically update LastModified date on Customers record update
-- ------------------------------------------
CREATE OR REPLACE TRIGGER UpdateCustomerLastModified
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    :NEW.LastModified := SYSDATE;
END UpdateCustomerLastModified;
/

-- ------------------------------------------
-- Scenario 2: LogTransaction
-- Maintain an audit log for all transactions inserted
-- ------------------------------------------
CREATE OR REPLACE TRIGGER LogTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (
        TransactionID,
        AccountID,
        TransactionDate,
        Amount,
        TransactionType,
        LogDate
    ) VALUES (
        :NEW.TransactionID,
        :NEW.AccountID,
        :NEW.TransactionDate,
        :NEW.Amount,
        :NEW.TransactionType,
        SYSDATE
    );
END LogTransaction;
/

-- ------------------------------------------
-- Scenario 3: CheckTransactionRules
-- Enforce business rules: withdrawals <= balance, deposits > 0
-- ------------------------------------------
CREATE OR REPLACE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
DECLARE
    v_balance NUMBER;
BEGIN
    -- Rule 1: Deposits must be positive
    IF :NEW.TransactionType = 'Deposit' AND :NEW.Amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'Deposit amount must be positive.');
    END IF;

    -- Rule 2: Withdrawals must be positive and not exceed account balance
    IF :NEW.TransactionType = 'Withdrawal' THEN
        IF :NEW.Amount <= 0 THEN
            RAISE_APPLICATION_ERROR(-20009, 'Withdrawal amount must be positive.');
        END IF;

        SELECT Balance INTO v_balance
        FROM Accounts
        WHERE AccountID = :NEW.AccountID;

        IF :NEW.Amount > v_balance THEN
            RAISE_APPLICATION_ERROR(-20010, 'Withdrawal amount ($' || :NEW.Amount || ') exceeds current balance ($' || v_balance || ').');
        END IF;
    END IF;
END CheckTransactionRules;
/
