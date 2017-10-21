package main

import "time"

type MessageThread struct {
	Message Message
	Thread Thread
}

type Message struct {
	Creator string
	ThreadId uint32
	MessageId uint32
	Time time.Time
	Content string
}

type Thread struct {
	Creator string
	TopicTitle string
	Id uint32
	Title string
	Description string
	DateCreated time.Time
}

type Topic struct {
	ManagingTeamId uint32
	Title string
	Description string
}

type User struct {
	UserName string
	PhoneNumber string
	DateJoined time.Time
}

type Employee struct {
	User User
	TeamId uint32
	Id uint32
	Name string
	Address string
	Salary uint32
	Schedule string
	Speciality *string
}

type Team struct {
	Employees []*Employee
	TeamId int64
	MgrId int64
	MgrStartDate time.Time
}