-- ==========================================
-- Exercise 1: Control Structures
-- ==========================================

SET SERVEROUTPUT ON;

-- ------------------------------------------
-- Scenario 1: Apply 1% discount to loan interest rates for customers over 60 years old
-- ------------------------------------------
DECLARE
    v_age NUMBER;
BEGIN
    FOR c IN (SELECT CustomerID, DOB FROM Customers) LOOP
        -- Calculate age in years
        v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, c.DOB) / 12);
        
        IF v_age > 60 THEN
            UPDATE Loans
            SET InterestRate = InterestRate - 1
            WHERE CustomerID = c.CustomerID;
            
            DBMS_OUTPUT.PUT_LINE('Applied 1% discount to loans for Customer ID: ' || c.CustomerID || ' (Age: ' || v_age || ')');
        END IF;
    END LOOP;
    COMMIT;
END;
/

-- ------------------------------------------
-- Scenario 2: Promote customers to VIP status based on balance > $10,000
-- ------------------------------------------
BEGIN
    FOR c IN (SELECT CustomerID, Balance FROM Customers) LOOP
        IF c.Balance > 10000 THEN
            UPDATE Customers
            SET IsVIP = 'TRUE'
            WHERE CustomerID = c.CustomerID;
            
            DBMS_OUTPUT.PUT_LINE('Customer ID ' || c.CustomerID || ' promoted to VIP (Balance: $' || c.Balance || ')');
        ELSE
            UPDATE Customers
            SET IsVIP = 'FALSE'
            WHERE CustomerID = c.CustomerID;
        END IF;
    END LOOP;
    COMMIT;
END;
/

-- ------------------------------------------
-- Scenario 3: Send loan due reminders for loans due within the next 30 days
-- ------------------------------------------
DECLARE
    CURSOR c_due_loans IS
        SELECT c.CustomerID, c.Name, l.LoanID, l.LoanAmount, l.EndDate
        FROM Loans l
        JOIN Customers c ON l.CustomerID = c.CustomerID
        WHERE l.EndDate BETWEEN SYSDATE AND SYSDATE + 30;
BEGIN
    FOR rec IN c_due_loans LOOP
        DBMS_OUTPUT.PUT_LINE('REMINDER: Customer ' || rec.Name || ' (ID: ' || rec.CustomerID || 
                             ') - Loan ID ' || rec.LoanID || ' of $' || rec.LoanAmount || 
                             ' is due on ' || TO_CHAR(rec.EndDate, 'YYYY-MM-DD') || '.');
    END LOOP;
END;
/
