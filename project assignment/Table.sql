DROP TABLE IF EXISTS Team CASCADE;
DROP TABLE IF EXISTS Users CASCADE;
DROP TABLE IF EXISTS Customer CASCADE;
DROP TABLE IF EXISTS Employee CASCADE;
DROP TABLE IF EXISTS Moderator CASCADE;
DROP TABLE IF EXISTS Specialist CASCADE;
DROP TABLE IF EXISTS Manager CASCADE;
DROP TABLE IF EXISTS Topic CASCADE;
DROP TABLE IF EXISTS Thread CASCADE;
DROP TABLE IF EXISTS Message CASCADE;
DROP TABLE IF EXISTS Is_Moderated_By CASCADE;

CREATE TABLE Team(
Team_ID BIGSERIAL PRIMARY KEY,
Mgr_ID BIGSERIAL,
Mgr_Start_Date DATE);

ALTER TABLE Team ALTER COLUMN Mgr_ID DROP NOT NULL;

CREATE TABLE Users(
User_Name TEXT PRIMARY KEY,
Date_Joined DATE,
Password TEXT,
Phone_Nr CHAR(10) CHECK (LENGTH(Phone_Nr)=10 AND Phone_Nr ~ '^[0-9\+]+$'),
Cookie CHAR(30) UNIQUE);

CREATE TABLE Employee(
User_Name TEXT REFERENCES Users,
Team_ID BIGSERIAL REFERENCES Team,
Employee_ID BIGSERIAL PRIMARY KEY CHECK (Employee_ID>=0),
Name TEXT,
Address TEXT /*TODO: check legal address*/,
Salary BIGINT CHECK (Salary>=0),
Schedule TEXT);

CREATE TABLE Customer(User_Name TEXT REFERENCES Users);


CREATE TABLE Moderator(Employee_ID BIGINT PRIMARY KEY REFERENCES Employee);

CREATE TABLE Specialist(
Employee_ID BIGINT REFERENCES Employee,
Speciality TEXT);

CREATE TABLE Manager(Employee_ID BIGINT REFERENCES Employee);

CREATE TABLE Topic(
Managing_Team_ID BIGSERIAL REFERENCES Team,
Title TEXT PRIMARY KEY,
Description TEXT);

CREATE TABLE Thread(
Thread_ID BIGSERIAL PRIMARY KEY,
Creator TEXT REFERENCES Users,
Topic_Title TEXT REFERENCES Topic,
Title TEXT,
Description TEXT,
Date_Created DATE);

CREATE TABLE Message(
Creator TEXT REFERENCES Users,
Thread_ID BIGSERIAL REFERENCES Thread,
Message_ID BIGSERIAL PRIMARY KEY,
/*Type TEXT,*/ /*WHY??*/
Time DATE,
Content TEXT);

CREATE TABLE Is_Moderated_By(
Thread_ID BIGSERIAL REFERENCES Thread,
Employee_ID BIGSERIAL REFERENCES Employee);
