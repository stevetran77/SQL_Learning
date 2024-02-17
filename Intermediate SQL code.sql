-- CREATE NEW TABLES 
Create Table EmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
);

Create Table EmployeeSalary 
(EmployeeID int, 
JobTitle varchar(50), 
Salary int
);

-- INSERT NEW DATA 
Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')

Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000)

-- INSERT A NULL DATA

Insert into EmployeeDemographics VALUES
(1011, 'Ryan', 'Howard', 26, 'Male'),
(NULL, 'Holly','Flax', NULL, 'Male'),
(1013, 'Darryl', 'Philbin', NULL, 'Male') ; 

Insert into EmployeeSalary VALUES
(1010, NULL, 47000),
(NULL, 'Salesman', 43000);

-- INNER JOIN 
SELECT *
FROM employeedemographics gra
INNER JOIN employeesalary sala
	ON gra.EmployeeID = sala.EmployeeID;
    
-- FULL OUTER JOIN
SELECT *
FROM employeedemographics gra
FULL OUTER JOIN employeesalary sala ON gra.EmployeeID = sala.EmployeeID;

-- LEFT OUTER JOIN
SELECT *
FROM employeedemographics gra
LEFT OUTER JOIN employeesalary sala ON gra.EmployeeID = sala.EmployeeID;

-- RIGHT JOIN
SELECT *
FROM employeedemographics gra
RIGHT OUTER JOIN employeesalary sala ON gra.EmployeeID = sala.EmployeeID;