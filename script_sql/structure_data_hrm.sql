-- Create database with name: HRM
create database hrm;

CREATE TABLE Employee (
    ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Nationality VARCHAR(100),
    DOB DATE,
    PhoneNumber VARCHAR(15),
    ManagerID INT,
    Salary INT,
    OnboardDate DATE,
    FOREIGN KEY (ManagerID) REFERENCES Employee(ID)
);

-- Inserting sample data into the Employee table
INSERT INTO Employee (ID, Name, Nationality, DOB, PhoneNumber, ManagerID, Salary, OnboardDate)
VALUES
    (1, 'John Sena', 'American', '1990-05-15', '555-1234', NULL, 60000, '2022-01-15'),
    (2, 'John Doe', 'Canadian', '1985-08-22', '555-5678', 1, 75000, '2022-02-01'),
    (3, 'Michael Johnson', 'British', '1992-11-10', '555-9876', 1, 55000, '2022-03-10'),
    (4, 'Emily Davis', 'Australian', '1988-04-05', '555-4321', NULL, 80000, '2022-04-20'),
    (5, 'Robert Lee', 'Chinese', '1995-07-18', '555-8765', 4, 70000, '2022-05-05'),
    (6, 'Sophia Chen', 'Chinese', '1993-12-30', '555-2345', 4, 60000, '2022-06-15'),
    (7, 'David Wang', 'Chinese', '1980-09-08', '555-6789', 4, 90000, '2022-07-01'),
    (8, 'Isabella Kim', 'Korean', '1991-02-25', '555-7890', 1, 85000, '2022-08-10'),
    (9, 'Ethan Patel', 'Indian', '1987-06-28', '555-3456', 1, 70000, '2022-09-20'),
    (10, 'Son Hong', 'Vietnamese', '1994-03-12', '555-9012', 1, 60000, '2022-10-05');
   
-- Create Role table
CREATE TABLE Role (
    ID INT PRIMARY KEY,
    RoleName VARCHAR(100) NOT NULL
);

-- Insert sample data into the Role table
INSERT INTO Role (ID, RoleName)
VALUES
    (1, 'Manager'),
    (2, 'Developer'),
    (3, 'Designer'),
    (4, 'Analyst'),
    (5, 'Administrator'),
    (6, 'Tester'),
    (7, 'Support'),
    (8, 'HR'),
    (9, 'Finance'),
    (10, 'Intern');

-- Create Department table
CREATE TABLE Department (
    ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

-- Insert sample data into the Department table
INSERT INTO Department (ID, Name)
VALUES
    (1, 'Sales'),
    (2, 'Marketing'),
    (3, 'Finance'),
    (4, 'Human Resources'),
    (5, 'Research and Development'),
    (6, 'Customer Service'),
    (7, 'Information Technology'),
    (8, 'Operations'),
    (9, 'Legal'),
    (10, 'Administration');


-- Create Employee_Role table
CREATE TABLE Employee_Role (
    EmployeeID INT,
    RoleID INT,
    StartDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(ID),
    FOREIGN KEY (RoleID) REFERENCES Role(ID)
);

-- Insert sample data into the Employee_Role table
INSERT INTO Employee_Role (EmployeeID, RoleID, StartDate)
VALUES
    (1, 1, '2022-01-01'),
    (2, 2, '2022-02-15'),
    (3, 2, '2022-03-01'),
    (4, 1, '2022-04-10'),
    (5, 8, '2022-05-15'),
    (6, 8, '2022-06-01'),
    (7, 5, '2022-07-10'),
    (8, 6, '2022-08-15'),
    (9, 6, '2022-09-01'),
    (7, 4, '2023-01-01'),
    (8, 8, '2022-11-01');

    

-- Create Employee_Department table
CREATE TABLE Employee_Department (
    EmployeeID INT,
    DepartmentID INT,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(ID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(ID)
);

-- Insert sample data into the Employee_Department table
INSERT INTO Employee_Department (EmployeeID, DepartmentID, StartDate, EndDate)
VALUES
    (1, 7, '2022-01-01', NULL),
    (10, 8, '2022-05-02', NULL),
    (2, 7, '2022-01-01', NULL),
    (3, 7, '2022-02-01', NULL),
    (4, 4, '2022-03-01', NULL),
    (5, 4, '2022-04-01', NULL),
    (6, 4, '2022-05-01', NULL),
    (7, 4, '2022-06-01', '2022-12-31'),
    (7, 7, '2023-01-01', NULL),
    (8, 7, '2022-07-01', '2022-10-31'),
    (8, 4, '2022-11-01', NULL),
    (9, 7, '2022-08-01', NULL);
