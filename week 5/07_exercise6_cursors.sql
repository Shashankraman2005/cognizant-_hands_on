-- ==========================================
-- Exercise 6: Cursors
-- ==========================================

SET SERVEROUTPUT ON;

-- ------------------------------------------
-- Scenario 1: GenerateMonthlyStatements using explicit cursor
-- Fetches all transactions for current month and prints customer statements
-- ------------------------------------------
DECLARE
    CURSOR c_monthly_stmt IS
        SELECT c.CustomerID,
               c.Name AS CustomerName,
               a.AccountID,
               t.TransactionID,
               t.TransactionDate,
               t.Amount,
               t.TransactionType
        FROM Customers c
        JOIN Accounts a ON c.CustomerID = a.CustomerID
        JOIN Transactions t ON a.AccountID = t.AccountID
        WHERE TRUNC(t.TransactionDate, 'MM') = TRUNC(SYSDATE, 'MM')
        ORDER BY c.CustomerID, t.TransactionDate;

    v_rec c_monthly_stmt%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- MONTHLY TRANSACTION STATEMENTS ---');
    OPEN c_monthly_stmt;
    LOOP
        FETCH c_monthly_stmt INTO v_rec;
        EXIT WHEN c_monthly_stmt%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Customer: ' || v_rec.CustomerName || ' (ID: ' || v_rec.CustomerID || 
                             ') | Account: ' || v_rec.AccountID || 
                             ' | Txn ID: ' || v_rec.TransactionID || 
                             ' | Type: ' || v_rec.TransactionType || 
                             ' | Amount: $' || v_rec.Amount || 
                             ' | Date: ' || TO_CHAR(v_rec.TransactionDate, 'YYYY-MM-DD'));
    END LOOP;
    CLOSE c_monthly_stmt;
END;
/

-- ------------------------------------------
-- Scenario 2: ApplyAnnualFee using explicit cursor
-- Deducts annual maintenance fee ($50) from all accounts
-- ------------------------------------------
DECLARE
    v_annual_fee CONSTANT NUMBER := 50;

    CURSOR c_accounts IS
        SELECT AccountID, Balance
        FROM Accounts
        FOR UPDATE OF Balance;

    v_acc_id  Accounts.AccountID%TYPE;
    v_balance Accounts.Balance%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- APPLYING ANNUAL MAINTENANCE FEE ---');
    OPEN c_accounts;
    LOOP
        FETCH c_accounts INTO v_acc_id, v_balance;
        EXIT WHEN c_accounts%NOTFOUND;

        UPDATE Accounts
        SET Balance = Balance - v_annual_fee,
            LastModified = SYSDATE
        WHERE CURRENT OF c_accounts;

        DBMS_OUTPUT.PUT_LINE('Deducted $' || v_annual_fee || ' fee from Account ID: ' || v_acc_id || ' | New Balance: $' || (v_balance - v_annual_fee));
    END LOOP;
    CLOSE c_accounts;
    COMMIT;
END;
/

-- ------------------------------------------
-- Scenario 3: UpdateLoanInterestRates using explicit cursor
-- Updates loan interest rates based on new policy (e.g., Loans > $10,000 get 0.5% rate increase, others get 0.25% increase)
-- ------------------------------------------
DECLARE
    CURSOR c_loans IS
        SELECT LoanID, LoanAmount, InterestRate
        FROM Loans
        FOR UPDATE OF InterestRate;

    v_loan_id   Loans.LoanID%TYPE;
    v_amount    Loans.LoanAmount%TYPE;
    v_rate      Loans.InterestRate%TYPE;
    v_new_rate  NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- UPDATING LOAN INTEREST RATES ---');
    OPEN c_loans;
    LOOP
        FETCH c_loans INTO v_loan_id, v_amount, v_rate;
        EXIT WHEN c_loans%NOTFOUND;

        -- Policy: Loans > $10,000 receive +0.5% rate adjustment, others receive +0.25%
        IF v_amount > 10000 THEN
            v_new_rate := v_rate + 0.5;
        ELSE
            v_new_rate := v_rate + 0.25;
        END IF;

        UPDATE Loans
        SET InterestRate = v_new_rate
        WHERE CURRENT OF c_loans;

        DBMS_OUTPUT.PUT_LINE('Loan ID: ' || v_loan_id || ' (Amount: $' || v_amount || ') | Old Rate: ' || v_rate || '% -> New Rate: ' || v_new_rate || '%');
    END LOOP;
    CLOSE c_loans;
    COMMIT;
END;
/
