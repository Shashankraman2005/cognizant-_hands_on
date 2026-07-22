-- ==========================================
-- Exercise 7: Packages
-- ==========================================

SET SERVEROUTPUT ON;

-- ------------------------------------------
-- Scenario 1: CustomerManagement Package
-- ------------------------------------------
CREATE OR REPLACE PACKAGE CustomerManagement AS
    PROCEDURE AddCustomer(
        p_cust_id IN NUMBER,
        p_name    IN VARCHAR2,
        p_dob     IN DATE,
        p_balance IN NUMBER
    );

    PROCEDURE UpdateCustomerDetails(
        p_cust_id IN NUMBER,
        p_name    IN VARCHAR2,
        p_balance IN NUMBER
    );

    FUNCTION GetCustomerBalance(
        p_cust_id IN NUMBER
    ) RETURN NUMBER;
END CustomerManagement;
/

CREATE OR REPLACE PACKAGE BODY CustomerManagement AS
    PROCEDURE AddCustomer(
        p_cust_id IN NUMBER,
        p_name    IN VARCHAR2,
        p_dob     IN DATE,
        p_balance IN NUMBER
    ) IS
    BEGIN
        INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
        VALUES (p_cust_id, p_name, p_dob, p_balance, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('CustomerManagement: Added customer ID ' || p_cust_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('CustomerManagement ERROR: Customer ID ' || p_cust_id || ' already exists.');
    END AddCustomer;

    PROCEDURE UpdateCustomerDetails(
        p_cust_id IN NUMBER,
        p_name    IN VARCHAR2,
        p_balance IN NUMBER
    ) IS
    BEGIN
        UPDATE Customers
        SET Name = NVL(p_name, Name),
            Balance = NVL(p_balance, Balance),
            LastModified = SYSDATE
        WHERE CustomerID = p_cust_id;

        IF SQL%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('CustomerManagement ERROR: Customer ID ' || p_cust_id || ' not found.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('CustomerManagement: Updated customer ID ' || p_cust_id);
        END IF;
    END UpdateCustomerDetails;

    FUNCTION GetCustomerBalance(
        p_cust_id IN NUMBER
    ) RETURN NUMBER IS
        v_balance NUMBER;
    BEGIN
        SELECT Balance INTO v_balance
        FROM Customers
        WHERE CustomerID = p_cust_id;

        RETURN v_balance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END GetCustomerBalance;
END CustomerManagement;
/

-- ------------------------------------------
-- Scenario 2: EmployeeManagement Package
-- ------------------------------------------
CREATE OR REPLACE PACKAGE EmployeeManagement AS
    PROCEDURE HireEmployee(
        p_emp_id    IN NUMBER,
        p_name      IN VARCHAR2,
        p_position  IN VARCHAR2,
        p_salary    IN NUMBER,
        p_dept      IN VARCHAR2,
        p_hire_date IN DATE
    );

    PROCEDURE UpdateEmployeeDetails(
        p_emp_id   IN NUMBER,
        p_position IN VARCHAR2,
        p_salary   IN NUMBER,
        p_dept     IN VARCHAR2
    );

    FUNCTION CalculateAnnualSalary(
        p_emp_id IN NUMBER
    ) RETURN NUMBER;
END EmployeeManagement;
/

CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS
    PROCEDURE HireEmployee(
        p_emp_id    IN NUMBER,
        p_name      IN VARCHAR2,
        p_position  IN VARCHAR2,
        p_salary    IN NUMBER,
        p_dept      IN VARCHAR2,
        p_hire_date IN DATE
    ) IS
    BEGIN
        INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
        VALUES (p_emp_id, p_name, p_position, p_salary, p_dept, p_hire_date);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('EmployeeManagement: Hired employee ID ' || p_emp_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement ERROR: Employee ID ' || p_emp_id || ' already exists.');
    END HireEmployee;

    PROCEDURE UpdateEmployeeDetails(
        p_emp_id   IN NUMBER,
        p_position IN VARCHAR2,
        p_salary   IN NUMBER,
        p_dept     IN VARCHAR2
    ) IS
    BEGIN
        UPDATE Employees
        SET Position = NVL(p_position, Position),
            Salary = NVL(p_salary, Salary),
            Department = NVL(p_dept, Department)
        WHERE EmployeeID = p_emp_id;

        IF SQL%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement ERROR: Employee ID ' || p_emp_id || ' not found.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('EmployeeManagement: Updated employee ID ' || p_emp_id);
        END IF;
    END UpdateEmployeeDetails;

    FUNCTION CalculateAnnualSalary(
        p_emp_id IN NUMBER
    ) RETURN NUMBER IS
        v_monthly_salary NUMBER;
    BEGIN
        SELECT Salary INTO v_monthly_salary
        FROM Employees
        WHERE EmployeeID = p_emp_id;

        RETURN v_monthly_salary * 12;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END CalculateAnnualSalary;
END EmployeeManagement;
/

-- ------------------------------------------
-- Scenario 3: AccountOperations Package
-- ------------------------------------------
CREATE OR REPLACE PACKAGE AccountOperations AS
    PROCEDURE OpenAccount(
        p_acc_id   IN NUMBER,
        p_cust_id  IN NUMBER,
        p_acc_type IN VARCHAR2,
        p_balance  IN NUMBER
    );

    PROCEDURE CloseAccount(
        p_acc_id IN NUMBER
    );

    FUNCTION GetTotalBalance(
        p_cust_id IN NUMBER
    ) RETURN NUMBER;
END AccountOperations;
/

CREATE OR REPLACE PACKAGE BODY AccountOperations AS
    PROCEDURE OpenAccount(
        p_acc_id   IN NUMBER,
        p_cust_id  IN NUMBER,
        p_acc_type IN VARCHAR2,
        p_balance  IN NUMBER
    ) IS
    BEGIN
        INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
        VALUES (p_acc_id, p_cust_id, p_acc_type, p_balance, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('AccountOperations: Opened account ID ' || p_acc_id || ' for customer ID ' || p_cust_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('AccountOperations ERROR: Account ID ' || p_acc_id || ' already exists.');
    END OpenAccount;

    PROCEDURE CloseAccount(
        p_acc_id IN NUMBER
    ) IS
    BEGIN
        DELETE FROM Accounts WHERE AccountID = p_acc_id;
        IF SQL%NOTFOUND THEN
            DBMS_OUTPUT.PUT_LINE('AccountOperations ERROR: Account ID ' || p_acc_id || ' not found.');
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('AccountOperations: Closed account ID ' || p_acc_id);
        END IF;
    END CloseAccount;

    FUNCTION GetTotalBalance(
        p_cust_id IN NUMBER
    ) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT NVL(SUM(Balance), 0) INTO v_total
        FROM Accounts
        WHERE CustomerID = p_cust_id;

        RETURN v_total;
    END GetTotalBalance;
END AccountOperations;
/
