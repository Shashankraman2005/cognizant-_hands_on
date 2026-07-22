-- ==========================================
-- Exercise 2: Error Handling
-- ==========================================

SET SERVEROUTPUT ON;

-- ------------------------------------------
-- Scenario 1: SafeTransferFunds with exception handling and transaction rollback
-- ------------------------------------------
CREATE OR REPLACE PROCEDURE SafeTransferFunds (
    p_from_account_id IN NUMBER,
    p_to_account_id   IN NUMBER,
    p_amount          IN NUMBER
) IS
    v_from_balance NUMBER;
    e_insufficient_funds EXCEPTION;
    e_invalid_account EXCEPTION;
    v_from_count NUMBER;
    v_to_count NUMBER;
BEGIN
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Transfer amount must be positive.');
    END IF;

    -- Validate accounts exist
    SELECT COUNT(*) INTO v_from_count FROM Accounts WHERE AccountID = p_from_account_id;
    SELECT COUNT(*) INTO v_to_count FROM Accounts WHERE AccountID = p_to_account_id;

    IF v_from_count = 0 OR v_to_count = 0 THEN
        RAISE e_invalid_account;
    END IF;

    -- Get sender balance (Lock row for update)
    SELECT Balance INTO v_from_balance
    FROM Accounts
    WHERE AccountID = p_from_account_id
    FOR UPDATE;

    IF v_from_balance < p_amount THEN
        RAISE e_insufficient_funds;
    END IF;

    -- Perform Transfer
    UPDATE Accounts
    SET Balance = Balance - p_amount,
        LastModified = SYSDATE
    WHERE AccountID = p_from_account_id;

    UPDATE Accounts
    SET Balance = Balance + p_amount,
        LastModified = SYSDATE
    WHERE AccountID = p_to_account_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transfer of $' || p_amount || ' from Account ' || p_from_account_id || ' to Account ' || p_to_account_id || ' successful.');

EXCEPTION
    WHEN e_insufficient_funds THEN
        ROLLBACK;
        INSERT INTO ErrorLog (ProcedureName, ErrorCode, ErrorMessage)
        VALUES ('SafeTransferFunds', -20002, 'Insufficient funds in source Account ID: ' || p_from_account_id);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('ERROR: Insufficient funds in Account ID ' || p_from_account_id);
        
    WHEN e_invalid_account THEN
        ROLLBACK;
        INSERT INTO ErrorLog (ProcedureName, ErrorCode, ErrorMessage)
        VALUES ('SafeTransferFunds', -20003, 'One or both Account IDs (' || p_from_account_id || ', ' || p_to_account_id || ') do not exist.');
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('ERROR: Invalid account ID specified.');
        
    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO ErrorLog (ProcedureName, ErrorCode, ErrorMessage)
        VALUES ('SafeTransferFunds', SQLCODE, SQLERRM);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('ERROR: Transfer failed. ' || SQLERRM);
END SafeTransferFunds;
/

-- ------------------------------------------
-- Scenario 2: UpdateSalary with exception handling for non-existent employee
-- ------------------------------------------
CREATE OR REPLACE PROCEDURE UpdateSalary (
    p_emp_id     IN NUMBER,
    p_percentage IN NUMBER
) IS
    e_emp_not_found EXCEPTION;
BEGIN
    UPDATE Employees
    SET Salary = Salary * (1 + p_percentage / 100)
    WHERE EmployeeID = p_emp_id;

    IF SQL%NOTFOUND THEN
        RAISE e_emp_not_found;
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Salary updated successfully for Employee ID: ' || p_emp_id);

EXCEPTION
    WHEN e_emp_not_found THEN
        ROLLBACK;
        INSERT INTO ErrorLog (ProcedureName, ErrorCode, ErrorMessage)
        VALUES ('UpdateSalary', -20004, 'Employee ID ' || p_emp_id || ' does not exist.');
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('ERROR: Employee ID ' || p_emp_id || ' not found.');
        
    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO ErrorLog (ProcedureName, ErrorCode, ErrorMessage)
        VALUES ('UpdateSalary', SQLCODE, SQLERRM);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('ERROR: UpdateSalary failed. ' || SQLERRM);
END UpdateSalary;
/

-- ------------------------------------------
-- Scenario 3: AddNewCustomer with exception handling for duplicate ID
-- ------------------------------------------
CREATE OR REPLACE PROCEDURE AddNewCustomer (
    p_cust_id IN NUMBER,
    p_name    IN VARCHAR2,
    p_dob     IN DATE,
    p_balance IN NUMBER
) IS
BEGIN
    INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
    VALUES (p_cust_id, p_name, p_dob, p_balance, SYSDATE);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Customer ' || p_name || ' (ID: ' || p_cust_id || ') added successfully.');

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        INSERT INTO ErrorLog (ProcedureName, ErrorCode, ErrorMessage)
        VALUES ('AddNewCustomer', SQLCODE, 'Customer with ID ' || p_cust_id || ' already exists.');
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('ERROR: Customer ID ' || p_cust_id || ' already exists. Insertion prevented.');
        
    WHEN OTHERS THEN
        ROLLBACK;
        INSERT INTO ErrorLog (ProcedureName, ErrorCode, ErrorMessage)
        VALUES ('AddNewCustomer', SQLCODE, SQLERRM);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('ERROR: AddNewCustomer failed. ' || SQLERRM);
END AddNewCustomer;
/
