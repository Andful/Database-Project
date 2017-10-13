package main

import "net/http"

func GetTeamList() []Team {
	rows,err := db.Query("SELECT team_id, mgr_id,mgr_start_date FROM team")
	checkError(err)

	var result []Team;

	for rows.Next() {
		var team Team
		rows.Scan(&team.TeamId,&team.MgrId,&team.MgrStartDate)

		result = append(result,team)
	}
	return result
}
func GetTeamFromId(id uint32) *Team {
	rows,err := db.Query("SELECT team_id, mgr_id,mgr_start_date FROM team WHERE team_id=$1", id)
	checkError(err)

	if rows.Next() {
		var result *Team
		result = &Team{}
		rows.Scan(&result.TeamId,&result.MgrId,&result.MgrStartDate)
		rows,err = db.Query("SELECT user_name,team_id,employee_id,name,address,salary,schedule " +
			"FROM employee " +
				"WHERE team_id=$1", id)
		checkError(err)
		for rows.Next(){
			var emp Employee
			var name string
			rows.Scan(&name,&emp.TeamId,&emp.Id,&emp.Name,&emp.Address,&emp.Salary,&emp.Schedule)
			emp.User=*GetUserFromName(name)
			result.Employees=append(result.Employees,&emp)
		}
		return result
	} else {
		return nil
	}

}

func GetEmployeeFromUser(user *User) *Employee {
	if(user==nil){
		return nil
	}

	var result Employee
	result.User=*user
	rows,err := db.Query("SELECT team_id, Employee_ID, name, address, salary, schedule  " +
		"FROM employee" +
		" WHERE user_name=$1", result.User.UserName)
	checkError(err)

	if rows.Next() {
		rows.Scan(&result.TeamId,&result.Id,&result.Name,&result.Address,&result.Salary,&result.Schedule)
		return &result
	} else {
		return nil
	}
}

func GetEmployeeFromName(userName string) *Employee{
	user:=GetUserFromName(userName)
	if user==nil{
		return nil
	}
	return GetEmployeeFromUser(user)
}

func GetUserFromRequest(r *http.Request) *User{
	cookie,err :=r.Cookie("session")
	checkError(err)
	return GetUserFromSession(cookie.Value)
}

func GetUserFromName(userName string) *User{
	rows,err := db.Query("SELECT user_name, date_joined, phone_nr FROM users WHERE user_name=$1", userName)
	checkError(err)
	if rows.Next() {
		var result User
		rows.Scan(&result.UserName,&result.DateJoined,&result.PhoneNumber)
		return &result
	} else {
		return nil
	}
}

func GetUserFromSession(session string) *User{
	if len(session)!=30 {
		return nil
	} else {
		rows,err := db.Query("SELECT user_name, date_joined, phone_nr FROM users WHERE cookie=$1", session)
		checkError(err)
		if rows.Next() {
			var result User
			rows.Scan(&result.UserName,&result.DateJoined,&result.PhoneNumber)
			return &result
		} else {
			return nil
		}
	}
}
