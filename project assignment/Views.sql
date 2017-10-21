DROP VIEW IF EXISTS Messages_and_Threads;
DROP VIEW IF EXISTS Specialists_Info;
DROP VIEW IF EXISTS person;

CREATE VIEW Messages_and_Threads AS
SELECT t.Thread_ID,t.Title , m.Content
FROM MESSAGE m, THREAD t
WHERE m.Thread_ID = t.Thread_ID
ORDER BY m.Time DESC;

CREATE VIEW Specialists_Info AS
SELECT E.User_Name, S.Speciality, E.Schedule
FROM SPECIALIST AS S LEFT OUTER JOIN EMPLOYEE AS E
ON S.Employee_ID = E.Employee_ID;


--DROP VIEW #Name
--TO see the name of the views : select table_name from INFORMATION_SCHEMA.views WHERE table_schema = ANY (current_schemas(false))
