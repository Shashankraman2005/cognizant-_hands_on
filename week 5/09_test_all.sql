-- ==========================================
-- Test Script for All PL/SQL Exercises
-- ==========================================

SET SERVEROUTPUT ON SIZE UNLIMITED;

PROMPT ==========================================
PROMPT Testing Exercise 2: Error Handling
PROMPT ==========================================
-- Test 2.1: SafeTransferFunds (Valid & Error)
EXEC SafeTransferFunds(1, 2, 100);
EXEC SafeTransferFunds(1, 2, 999999); -- Should trigger insufficient funds exception

-- Test 2.2: UpdateSalary (Valid & Non-existent employee)
EXEC UpdateSalary(1, 10);
EXEC UpdateSalary(999, 10); -- Should trigger employee not found exception

-- Test 2.3: AddNewCustomer (Duplicate ID)
EXEC AddNewCustomer(10, 'Mark Taylor', TO_DATE('1992-10-10', 'YYYY-MM-DD'), 2000);
EXEC AddNewCustomer(10, 'Mark Taylor', TO_DATE('1992-10-10', 'YYYY-MM-DD'), 2000); -- Should trigger duplicate key exception


PROMPT ==========================================
PROMPT Testing Exercise 3: Stored Procedures
PROMPT ==========================================
EXEC ProcessMonthlyInterest;
EXEC UpdateEmployeeBonus('HR', 5);
EXEC TransferFunds(2, 1, 50);


PROMPT ==========================================
PROMPT Testing Exercise 4: Functions
PROMPT ==========================================
DECLARE
    v_age NUMBER;
    v_emi NUMBER;
    v_sufficient BOOLEAN;
BEGIN
    v_age := CalculateAge(TO_DATE('1985-05-15', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Calculated Age for 1985-05-15: ' || v_age || ' years');

    v_emi := CalculateMonthlyInstallment(100000, 7.5, 15);
    DBMS_OUTPUT.PUT_LINE('Monthly Installment (EMI) for $100k, 7.5%, 15yrs: $' || v_emi);

    v_sufficient := HasSufficientBalance(1, 500);
    IF v_sufficient THEN
        DBMS_OUTPUT.PUT_LINE('Account 1 has sufficient balance for $500');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Account 1 does NOT have sufficient balance for $500');
    END IF;
END;
/


PROMPT ==========================================
PROMPT Testing Exercise 5: Triggers
PROMPT ==========================================
-- Test 5.1 & 5.2: Update LastModified and Audit Log Trigger
UPDATE Customers SET Balance = Balance + 50 WHERE CustomerID = 1;
INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
VALUES (100, 1, SYSDATE, 500, 'Deposit');

SELECT * FROM AuditLog WHERE TransactionID = 100;


PROMPT ==========================================
PROMPT Testing Exercise 7: Packages
PROMPT ==========================================
-- CustomerManagement
EXEC CustomerManagement.AddCustomer(20, 'Sarah Connor', TO_DATE('1980-01-01', 'YYYY-MM-DD'), 5000);
EXEC CustomerManagement.UpdateCustomerDetails(20, 'Sarah Connor-Reese', 6000);
SELECT CustomerManagement.GetCustomerBalance(20) AS CustBalance FROM DUAL;

-- EmployeeManagement
EXEC EmployeeManagement.HireEmployee(3, 'Charlie Green', 'Analyst', 55000, 'Finance', SYSDATE);
EXEC EmployeeManagement.UpdateEmployeeDetails(3, 'Senior Analyst', 65000, 'Finance');
SELECT EmployeeManagement.CalculateAnnualSalary(3) AS AnnualSalary FROM DUAL;

-- AccountOperations
EXEC AccountOperations.OpenAccount(50, 20, 'Savings', 3000);
SELECT AccountOperations.GetTotalBalance(20) AS TotalCustomerBalance FROM DUAL;
EXEC AccountOperations.CloseAccount(50);

PROMPT ==========================================
PROMPT All Tests Completed Successfully
PROMPT ==========================================
