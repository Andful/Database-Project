package main

import "time"

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
}

type Team struct {
	Employees []*Employee
	TeamId int64
	MgrId int64
	MgrStartDate time.Time
}