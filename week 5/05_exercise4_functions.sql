-- ==========================================
-- Exercise 4: Functions
-- ==========================================

SET SERVEROUTPUT ON;

-- ------------------------------------------
-- Scenario 1: CalculateAge
-- ------------------------------------------
CREATE OR REPLACE FUNCTION CalculateAge (
    p_dob IN DATE
) RETURN NUMBER IS
    v_age NUMBER;
BEGIN
    IF p_dob IS NULL THEN
        RETURN NULL;
    END IF;

    v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, p_dob) / 12);
    RETURN v_age;
END CalculateAge;
/

-- ------------------------------------------
-- Scenario 2: CalculateMonthlyInstallment (EMI Formula)
-- ------------------------------------------
CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment (
    p_loan_amount    IN NUMBER,
    p_interest_rate  IN NUMBER, -- Annual interest rate percentage (e.g. 5 for 5%)
    p_duration_years IN NUMBER
) RETURN NUMBER IS
    v_monthly_rate NUMBER;
    v_total_months NUMBER;
    v_installment  NUMBER;
BEGIN
    IF p_loan_amount IS NULL OR p_loan_amount <= 0 THEN
        RETURN 0;
    END IF;
    IF p_duration_years IS NULL OR p_duration_years <= 0 THEN
        RETURN 0;
    END IF;

    v_total_months := p_duration_years * 12;
    
    -- Handle 0% interest rate case
    IF p_interest_rate = 0 OR p_interest_rate IS NULL THEN
        RETURN ROUND(p_loan_amount / v_total_months, 2);
    END IF;

    v_monthly_rate := (p_interest_rate / 100) / 12;
    
    -- EMI Formula: P * r * (1 + r)^n / ((1 + r)^n - 1)
    v_installment := p_loan_amount * v_monthly_rate * POWER(1 + v_monthly_rate, v_total_months) / 
                     (POWER(1 + v_monthly_rate, v_total_months) - 1);
                     
    RETURN ROUND(v_installment, 2);
END CalculateMonthlyInstallment;
/

-- ------------------------------------------
-- Scenario 3: HasSufficientBalance
-- ------------------------------------------
CREATE OR REPLACE FUNCTION HasSufficientBalance (
    p_acc_id IN NUMBER,
    p_amount IN NUMBER
) RETURN BOOLEAN IS
    v_balance NUMBER;
BEGIN
    SELECT Balance INTO v_balance
    FROM Accounts
    WHERE AccountID = p_acc_id;

    IF v_balance >= p_amount THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END HasSufficientBalance;
/
