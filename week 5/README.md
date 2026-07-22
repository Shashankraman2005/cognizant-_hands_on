# PL/SQL Exercises 1 - 7: Complete Solution Suite

This repository contains the complete, production-grade Oracle PL/SQL solution suite for Exercises 1 through 7 based on the financial banking domain schema.

---

## 📁 Project Structure

| File | Description |
| :--- | :--- |
| 📄 [`00_schema.sql`](file:///Users/shashankraman/Desktop/week%205/00_schema.sql) | DDL script for database tables (`Customers`, `Accounts`, `Transactions`, `Loans`, `Employees`, `AuditLog`, `ErrorLog`) |
| 📄 [`01_sample_data.sql`](file:///Users/shashankraman/Desktop/week%205/01_sample_data.sql) | DML script inserting sample records provided in the exercise prompt |
| 📄 [`02_exercise1_control_structures.sql`](file:///Users/shashankraman/Desktop/week%205/02_exercise1_control_structures.sql) | PL/SQL blocks with `IF-THEN`, `FOR` loops, and conditional updates |
| 📄 [`03_exercise2_error_handling.sql`](file:///Users/shashankraman/Desktop/week%205/03_exercise2_error_handling.sql) | Stored procedures with exception handling (`NO_DATA_FOUND`, `DUP_VAL_ON_INDEX`, custom exceptions, `ROLLBACK`, `ErrorLog`) |
| 📄 [`04_exercise3_stored_procedures.sql`](file:///Users/shashankraman/Desktop/week%205/04_exercise3_stored_procedures.sql) | Stored procedures for business operations (`ProcessMonthlyInterest`, `UpdateEmployeeBonus`, `TransferFunds`) |
| 📄 [`05_exercise4_functions.sql`](file:///Users/shashankraman/Desktop/week%205/05_exercise4_functions.sql) | PL/SQL Functions (`CalculateAge`, `CalculateMonthlyInstallment`, `HasSufficientBalance`) |
| 📄 [`06_exercise5_triggers.sql`](file:///Users/shashankraman/Desktop/week%205/06_exercise5_triggers.sql) | Database triggers (`BEFORE UPDATE`, `AFTER INSERT` for audit logging, `BEFORE INSERT` business rules) |
| 📄 [`07_exercise6_cursors.sql`](file:///Users/shashankraman/Desktop/week%205/07_exercise6_cursors.sql) | Explicit cursor processing (`GenerateMonthlyStatements`, `ApplyAnnualFee`, `UpdateLoanInterestRates`) |
| 📄 [`08_exercise7_packages.sql`](file:///Users/shashankraman/Desktop/week%205/08_exercise7_packages.sql) | Package Specs & Bodies (`CustomerManagement`, `EmployeeManagement`, `AccountOperations`) |
| 📄 [`09_test_all.sql`](file:///Users/shashankraman/Desktop/week%205/09_test_all.sql) | Test suite executing all procedures, functions, triggers, and packages |

---

## 🗄️ Database Schema Overview

```
                      +-------------------+
                      |     Customers     |
                      +-------------------+
                      | CustomerID (PK)   |
                      | Name              |
                      | DOB               |
                      | Balance           |
                      | LastModified      |
                      | IsVIP             |
                      +---------+---------+
                                |
             +------------------+------------------+
             | 1:N                                 | 1:N
   +---------v---------+                 +---------v---------+
   |     Accounts      |                 |       Loans       |
   +-------------------+                 +-------------------+
   | AccountID (PK)    |                 | LoanID (PK)       |
   | CustomerID (FK)   |                 | CustomerID (FK)   |
   | AccountType       |                 | LoanAmount        |
   | Balance           |                 | InterestRate      |
   | LastModified      |                 | StartDate         |
   +---------+---------+                 | EndDate           |
             |                           +-------------------+
             | 1:N
   +---------v---------+
   |   Transactions    |
   +-------------------+
   | TransactionID (PK)|
   | AccountID (FK)    |
   | TransactionDate   |
   | Amount            |
   | TransactionType   |
   +-------------------+
```

Auxiliary Tables:
- **`Employees`**: Tracks `EmployeeID`, `Name`, `Position`, `Salary`, `Department`, `HireDate`.
- **`AuditLog`**: Stores transaction audit logs generated automatically via `LogTransaction` trigger.
- **`ErrorLog`**: Stores execution exception records raised in procedures like `SafeTransferFunds` and `UpdateSalary`.

---

## 📘 Summary of Exercises & Solutions

### **Exercise 1: Control Structures**
- **Scenario 1**: Iterates through customers. If `Age > 60` (calculated using `MONTHS_BETWEEN`), applies a 1% interest rate discount to their loans.
- **Scenario 2**: Iterates through customers and sets `IsVIP = 'TRUE'` for balances exceeding $10,000.
- **Scenario 3**: Uses a cursor loop to fetch loans due within the next 30 days (`EndDate BETWEEN SYSDATE AND SYSDATE + 30`) and prints a reminder message via `DBMS_OUTPUT`.

### **Exercise 2: Error Handling**
- **Scenario 1 (`SafeTransferFunds`)**: Transfers funds between two accounts using `FOR UPDATE` row locking. Catches insufficient funds and invalid account exceptions, logs errors to `ErrorLog`, and issues a `ROLLBACK`.
- **Scenario 2 (`UpdateSalary`)**: Increases employee salary by a given percentage. Catches missing employee IDs via `SQL%NOTFOUND`, logging the error.
- **Scenario 3 (`AddNewCustomer`)**: Inserts new customer records. Handles `DUP_VAL_ON_INDEX` to log duplicate ID errors and prevent invalid insertion.

### **Exercise 3: Stored Procedures**
- **Scenario 1 (`ProcessMonthlyInterest`)**: Increases balance of all `Savings` accounts by 1% (`Balance * 1.01`).
- **Scenario 2 (`UpdateEmployeeBonus`)**: Adds a bonus percentage to employees' salary in a specified department.
- **Scenario 3 (`TransferFunds`)**: Transfers funds after validating that the source account has adequate balance.

### **Exercise 4: Functions**
- **Scenario 1 (`CalculateAge`)**: Returns age in years given a date of birth `p_dob`.
- **Scenario 2 (`CalculateMonthlyInstallment`)**: Calculates Equated Monthly Installment (EMI) using the financial formula:
  $$EMI = P \times r \times \frac{(1 + r)^n}{(1 + r)^n - 1}$$
- **Scenario 3 (`HasSufficientBalance`)**: Returns `TRUE` if account balance $\ge$ requested amount, otherwise `FALSE`.

### **Exercise 5: Triggers**
- **Scenario 1 (`UpdateCustomerLastModified`)**: `BEFORE UPDATE` trigger on `Customers` updating `:NEW.LastModified := SYSDATE`.
- **Scenario 2 (`LogTransaction`)**: `AFTER INSERT` trigger on `Transactions` logging transaction details into `AuditLog`.
- **Scenario 3 (`CheckTransactionRules`)**: `BEFORE INSERT` trigger verifying deposit amounts $> 0$ and withdrawal amounts $\le$ account balance.

### **Exercise 6: Cursors**
- **Scenario 1 (`GenerateMonthlyStatements`)**: Explicit cursor iterating over current month transactions to print customer statements.
- **Scenario 2 (`ApplyAnnualFee`)**: Explicit cursor with `FOR UPDATE OF Balance` deducting a $50 maintenance fee from all accounts.
- **Scenario 3 (`UpdateLoanInterestRates`)**: Explicit cursor with `WHERE CURRENT OF` updating loan interest rates according to loan amount thresholds.

### **Exercise 7: Packages**
- **`CustomerManagement`**: Encapsulates `AddCustomer`, `UpdateCustomerDetails`, and `GetCustomerBalance`.
- **`EmployeeManagement`**: Encapsulates `HireEmployee`, `UpdateEmployeeDetails`, and `CalculateAnnualSalary`.
- **`AccountOperations`**: Encapsulates `OpenAccount`, `CloseAccount`, and `GetTotalBalance`.

---

## 🚀 Execution Instructions

Run the scripts in order in **Oracle Live SQL**, **SQL*Plus**, or **SQL Developer**:

```sql
@00_schema.sql
@01_sample_data.sql
@02_exercise1_control_structures.sql
@03_exercise2_error_handling.sql
@04_exercise3_stored_procedures.sql
@05_exercise4_functions.sql
@06_exercise5_triggers.sql
@07_exercise6_cursors.sql
@08_exercise7_packages.sql
@09_test_all.sql
```
