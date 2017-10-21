DROP VIEW IF EXISTS Messages_and_Threads;
DROP VIEW IF EXISTS Specialists_Info;
DROP VIEW IF EXISTS person;

CREATE VIEW Messages_and_Threads AS
SELECT t.Thread_ID, m.Content
FROM MESSAGE m, THREAD t
WHERE m.Thread_ID = t.Thread_ID;

CREATE VIEW Specialists_Info AS
SELECT E.User_Name, S.Speciality, E.Schedule
FROM SPECIALIST AS S, EMPLOYEE AS E
WHERE S.Employee_ID = E.Employee_ID;

CREATE VIEW person AS 
SELECT users.user_name,
WHERE users.user_name=emplyee.user_name AND employee.employee_id= manager.employee_id AND employee.employee_id= moderator.employee_id
GROUP BY users.user_name
;


--DROP VIEW #Name
--TO see the name of the views : select table_name from INFORMATION_SCHEMA.views WHERE table_schema = ANY (current_schemas(false))
