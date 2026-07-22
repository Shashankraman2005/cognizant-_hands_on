-- ==========================================
-- Database Schema Definition for Banking System
-- ==========================================

-- Cleanup existing tables if re-running script
DROP TABLE AuditLog CASCADE CONSTRAINTS;
DROP TABLE ErrorLog CASCADE CONSTRAINTS;
DROP TABLE Loans CASCADE CONSTRAINTS;
DROP TABLE Transactions CASCADE CONSTRAINTS;
DROP TABLE Accounts CASCADE CONSTRAINTS;
DROP TABLE Customers CASCADE CONSTRAINTS;
DROP TABLE Employees CASCADE CONSTRAINTS;

-- 1. Customers Table
CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    DOB DATE NOT NULL,
    Balance NUMBER DEFAULT 0,
    LastModified DATE DEFAULT SYSDATE,
    IsVIP VARCHAR2(5) DEFAULT 'FALSE' CHECK (IsVIP IN ('TRUE', 'FALSE'))
);

-- 2. Accounts Table
CREATE TABLE Accounts (
    AccountID NUMBER PRIMARY KEY,
    CustomerID NUMBER NOT NULL,
    AccountType VARCHAR2(20) NOT NULL CHECK (AccountType IN ('Savings', 'Checking')),
    Balance NUMBER DEFAULT 0,
    LastModified DATE DEFAULT SYSDATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- 3. Transactions Table
CREATE TABLE Transactions (
    TransactionID NUMBER PRIMARY KEY,
    AccountID NUMBER NOT NULL,
    TransactionDate DATE DEFAULT SYSDATE,
    Amount NUMBER NOT NULL,
    TransactionType VARCHAR2(10) NOT NULL CHECK (TransactionType IN ('Deposit', 'Withdrawal')),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID) ON DELETE CASCADE
);

-- 4. Loans Table
CREATE TABLE Loans (
    LoanID NUMBER PRIMARY KEY,
    CustomerID NUMBER NOT NULL,
    LoanAmount NUMBER NOT NULL,
    InterestRate NUMBER NOT NULL, -- Annual interest rate percentage (e.g., 5 for 5%)
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);

-- 5. Employees Table
CREATE TABLE Employees (
    EmployeeID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Position VARCHAR2(50) NOT NULL,
    Salary NUMBER NOT NULL,
    Department VARCHAR2(50) NOT NULL,
    HireDate DATE NOT NULL
);

-- 6. AuditLog Table (for Trigger auditing in Exercise 5)
CREATE TABLE AuditLog (
    AuditID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TransactionID NUMBER,
    AccountID NUMBER,
    TransactionDate DATE,
    Amount NUMBER,
    TransactionType VARCHAR2(10),
    LogDate DATE DEFAULT SYSDATE
);

-- 7. ErrorLog Table (for Error Handling in Exercise 2)
CREATE TABLE ErrorLog (
    ErrorID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ProcedureName VARCHAR2(100),
    ErrorCode NUMBER,
    ErrorMessage VARCHAR2(4000),
    LogDate DATE DEFAULT SYSDATE
);
