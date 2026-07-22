-- ==========================================
-- Exercise 3: Stored Procedures
-- ==========================================

SET SERVEROUTPUT ON;

-- ------------------------------------------
-- Scenario 1: ProcessMonthlyInterest for Savings accounts (1% interest)
-- ------------------------------------------
CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
BEGIN
    UPDATE Accounts
    SET Balance = Balance * 1.01,
        LastModified = SYSDATE
    WHERE AccountType = 'Savings';

    DBMS_OUTPUT.PUT_LINE('Processed 1% monthly interest for ' || SQL%ROWCOUNT || ' Savings accounts.');
    COMMIT;
END ProcessMonthlyInterest;
/

-- ------------------------------------------
-- Scenario 2: UpdateEmployeeBonus for a given department
-- ------------------------------------------
CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
    p_department IN VARCHAR2,
    p_bonus_pct  IN NUMBER
) IS
BEGIN
    UPDATE Employees
    SET Salary = Salary * (1 + p_bonus_pct / 100)
    WHERE Department = p_department;

    DBMS_OUTPUT.PUT_LINE('Updated salary with ' || p_bonus_pct || '% bonus for ' || SQL%ROWCOUNT || ' employees in department: ' || p_department);
    COMMIT;
END UpdateEmployeeBonus;
/

-- ------------------------------------------
-- Scenario 3: TransferFunds checking sufficient balance
-- ------------------------------------------
CREATE OR REPLACE PROCEDURE TransferFunds (
    p_from_acc IN NUMBER,
    p_to_acc   IN NUMBER,
    p_amount   IN NUMBER
) IS
    v_balance NUMBER;
BEGIN
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Transfer amount must be greater than zero.');
    END IF;

    -- Check source balance
    SELECT Balance INTO v_balance
    FROM Accounts
    WHERE AccountID = p_from_acc
    FOR UPDATE;

    IF v_balance < p_amount THEN
        RAISE_APPLICATION_ERROR(-20006, 'Insufficient funds in source Account ID ' || p_from_acc || '. Current Balance: ' || v_balance);
    END IF;

    -- Deduct from sender
    UPDATE Accounts
    SET Balance = Balance - p_amount,
        LastModified = SYSDATE
    WHERE AccountID = p_from_acc;

    -- Add to receiver
    UPDATE Accounts
    SET Balance = Balance + p_amount,
        LastModified = SYSDATE
    WHERE AccountID = p_to_acc;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Successfully transferred $' || p_amount || ' from Account ' || p_from_acc || ' to Account ' || p_to_acc);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20007, 'One of the specified accounts does not exist.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END TransferFunds;
/
