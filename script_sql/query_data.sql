-- 2. 
SELECT 
	e.ID as ID ,
    e.Name AS EmployeeName,
    d.Name AS Department,
    r.RoleName AS JobPosition
FROM 
    Employee e
JOIN 
    Employee_Department ed ON e.ID = ed.EmployeeID
JOIN 
    Department d ON ed.DepartmentID = d.ID
JOIN 
    Employee_Role er ON e.ID = er.EmployeeID
JOIN 
    Role r ON er.RoleID = r.ID
WHERE 
    ed.EndDate IS NULL -- To get only the current department of each employee
    AND er.StartDate = (
        SELECT MAX(StartDate)
        FROM Employee_Role
        WHERE EmployeeID = e.ID
    ); -- To get only the current job position of each employee

-- 3.
SELECT 
	Top 1 -- To get only the department with the most employees
    d.Name AS DepartmentName,
    COUNT(e.ID) AS EmployeeCount
FROM 
    Department d
JOIN 
    Employee_Department ed ON d.ID = ed.DepartmentID
JOIN 
    Employee e ON ed.EmployeeID = e.ID
WHERE 
    ed.EndDate IS NULL -- To get only current department assignments
GROUP BY 
    d.Name
ORDER BY 
    EmployeeCount DESC

-- 4.
SELECT 
    e.ID AS EmployeeID,
    e.Name AS EmployeeName,
    COUNT(DISTINCT ed.DepartmentID) AS DepartmentCount
FROM 
    Employee e
JOIN 
    Employee_Department ed ON e.ID = ed.EmployeeID
GROUP BY 
    e.ID, e.Name
HAVING 
    COUNT(DISTINCT ed.DepartmentID) = (
        SELECT 
            MAX(DepartmentCount)
        FROM (
            SELECT 
                COUNT(DISTINCT ed.DepartmentID) AS DepartmentCount
            FROM 
                Employee e
            JOIN 
                Employee_Department ed ON e.ID = ed.EmployeeID
            GROUP BY 
                e.ID
        ) AS DepartmentCounts
    );

-- 5
SELECT DISTINCT 
    e.ID AS EmployeeID,
    e.Name AS EmployeeName
FROM 
    Employee e
JOIN 
    Employee_Department ed ON e.ID = ed.EmployeeID
JOIN 
    Employee johndoe ON johndoe.Name = 'John Doe' -- Assuming 'John Doe' is the exact name
JOIN 
    Employee_Department johnDept ON johndoe.ID = johnDept.EmployeeID
WHERE 
    ed.DepartmentID = johnDept.DepartmentID
    AND e.ID <> johndoe.ID; -- Exclude John Doe from the result

-- 6
SELECT
    d.Name AS DepartmentName,
    AVG(e.Salary) AS AverageSalary
FROM
    Department d
JOIN
    Employee_Department ed ON d.ID = ed.DepartmentID
JOIN
    Employee e ON ed.EmployeeID = e.ID
GROUP BY
    d.Name;

-- 7
WITH JohnDoeDepartments AS (
    SELECT DISTINCT ED.DepartmentID
    FROM Employee E
    JOIN Employee_Department ED ON E.ID = ED.EmployeeID
    WHERE E.Name = 'John Doe'
)

SELECT DISTINCT E2.*, ED1.DepartmentID 
FROM Employee E1
JOIN Employee_Department ED1 ON E1.ID = ED1.EmployeeID
JOIN Employee E2 ON ED1.DepartmentID = E2.ID
JOIN Employee_Department ED2 ON E2.ID = ED2.EmployeeID
WHERE E1.Name = 'John Doe'
AND ED2.DepartmentID IN (SELECT DepartmentID FROM JohnDoeDepartments);



-- 8 
WITH SubordinateCount AS (
    SELECT
        ManagerID,
        COUNT(*) AS SubordinateCount
    FROM
        Employee
    WHERE
        ManagerID IS NOT NULL
    GROUP BY
        ManagerID
)

SELECT
    E.ID AS ManagerID,
    E.Name AS ManagerName,
    SC.SubordinateCount
FROM
    SubordinateCount SC
JOIN
    Employee E ON SC.ManagerID = E.ID
WHERE
    SC.SubordinateCount = (
        SELECT
            MAX(SubordinateCount)
        FROM
            SubordinateCount
    );
   
-- 9 
WITH EmployeeRolesRanked AS (
    SELECT
        ER.EmployeeID,
        R.RoleName,
        ER.StartDate,
        ROW_NUMBER() OVER (PARTITION BY ER.EmployeeID ORDER BY ER.StartDate DESC) AS RoleRank
    FROM
        Employee_Role ER
    JOIN
        Role R ON ER.RoleID = R.ID
)

SELECT
    E.ID AS EmployeeID,
    E.Name AS EmployeeName,
    PrevRole.RoleName AS PreviousRole,
    CurrRole.RoleName AS CurrentRole
FROM
    Employee E
JOIN
    EmployeeRolesRanked CurrRole ON E.ID = CurrRole.EmployeeID AND CurrRole.RoleRank = 1
LEFT JOIN
    EmployeeRolesRanked PrevRole ON E.ID = PrevRole.EmployeeID AND PrevRole.RoleRank = 2
WHERE
    CurrRole.StartDate = (SELECT MAX(StartDate) FROM Employee_Role WHERE EmployeeID = E.ID);


-- 10
WITH DuplicateCTE AS (
    SELECT
        EmployeeID,
        DepartmentID,
        StartDate,
        EndDate,
        ROW_NUMBER() OVER (PARTITION BY EmployeeID, DepartmentID ORDER BY StartDate) AS RowNum
    FROM
        Employee_Department
)

DELETE FROM DuplicateCTE
WHERE RowNum > 1;

-- 11
-- Create a new user
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';

CREATE USER 'hongson'@'localhost' IDENTIFIED BY 'Password@123';

-- Grant read-only permissions
GRANT SELECT ON *.* TO 'hongson'@'localhost';

-- Optionally, you can restrict access to specific databases
-- GRANT SELECT ON `your_database`.* TO 'username'@'localhost';

SELECT user, host, Select_priv, Insert_priv, Update_priv, Delete_priv, Create_priv, Drop_priv FROM mysql.user where user = 'hongson';
