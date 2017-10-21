package main

import (
	"net/http"
	"fmt"
	)

func SetThread(thread Thread){
	_,err :=db.Query(
		"INSERT INTO" +
			" thread(creator,topic_title,title,description,date_created)"+
			" VALUES ($1,$2,$3,$4,$5)",
		thread.Creator,
		thread.TopicTitle,
		thread.Title,
		thread.Description,
		thread.DateCreated)
	checkError(err)
}

func SetMessage(message Message){
	_,err :=db.Query(
		"INSERT INTO" +
			" message(creator,thread_id,time,content)"+
			" VALUES ($1,$2,$3,$4)",
		message.Creator,
		message.ThreadId,
		message.Time,
		message.Content)
	checkError(err)
}

func GetMessageThread() []MessageThread {
	var result []MessageThread

	rows,err := db.Query("SELECT thread_id, title, content " +
		"FROM messages_and_threads")
	checkError(err)

	for rows.Next() {
		var mt MessageThread
		rows.Scan(&mt.Thread.Id,&mt.Thread.Title,&mt.Message.Content)

		result =  append(result, mt)
	}

	return result
}

func GetEmployeeNameSpecialitySchedule() []Employee{
	var result []Employee
	rows,err := db.Query("SELECT user_name, speciality, schedule FROM specialists_info")
	checkError(err)

	for rows.Next() {
		var emp Employee

		err = rows.Scan(&emp.User.UserName,
			&emp.Speciality,
			&emp.Schedule,
		)

		result = append(result,emp)
	}

	return result
}

func GetMessageFromThread(thread Thread) []Message {
	rows,err := db.Query(
		"SELECT " +
			"creator," +
			" thread_id," +
			" message_id," +
			" time,"+
			" content"+
			" FROM message"+
			" WHERE thread_id=$1",thread.Id)
			fmt.Println(thread.Id)
	checkError(err)

	var result []Message

	for rows.Next() {
		var message Message
		rows.Scan(
			&message.Creator,
			&message.ThreadId,
			&message.MessageId,
			&message.Time,
			&message.Content,
		)
		result = append(result,message)
	}
	fmt.Println(result)
	return result
}

func GetThreadFromId(id uint32) *Thread {
	rows,err := db.Query(
		"SELECT " +
			"Creator," +
			" topic_title," +
			" title," +
			" description," +
			" date_created"+
			" FROM thread"+
			" WHERE thread_id=$1",id)
	checkError(err)

	if rows.Next() {
		var thread Thread

		rows.Scan(&thread.Creator,
			&thread.TopicTitle,
			&thread.Title,
			&thread.Description,
			&thread.DateCreated)
		thread.Id=id

		return &thread
	} else {
		return nil
	}
}

func GetThreadFromTopicName(topic string) []Thread {
	rows,err := db.Query(
		"SELECT " +
			"Creator," +
			" topic_title," +
			" title," +
			" description," +
			" date_created"+
			" FROM thread"+
			" WHERE topic_title=$1",topic)
	checkError(err)
	var result []Thread

	for rows.Next(){
		var thread Thread

		rows.Scan(&thread.Creator,
			&thread.TopicTitle,
			&thread.Title,
			&thread.Description,
			&thread.DateCreated)

		result = append(result,thread)
	}
	return result
}

func GetThreadNameAndIdFromTopicName(topic string) []Thread {
	rows,err := db.Query(
		"SELECT " +
			" title," +
			" thread_id"+
			" FROM thread"+
			" WHERE topic_title=$1",topic)
	checkError(err)
	var result []Thread

	for rows.Next(){
		var thread Thread

		rows.Scan(&thread.Title,&thread.Id)

		fmt.Println("title:"+thread.Title)

		result = append(result,thread)
	}
	return result
}

func TopicExists(topicName string) bool {
	rows,err := db.Query("SELECT" +
		" EXISTS(" +
			"SELECT * FROM topic WHERE title=$1);",topicName)
	checkError(err)
	rows.Next()
	var result bool
	rows.Scan(&result)
	return result
}

func GetTopicFromTitle(title string) *Topic {
	rows,err := db.Query(
		"SELECT" +
		" managing_team_id," +
		" title," +
		" description" +
		" FROM topic"+
		" WHERE title=$1",title)
	checkError(err)
	if rows.Next() {
		var result *Topic
		result = &Topic{}
		rows.Scan(&result.ManagingTeamId,&result.Title,&result.Description)
		return result
	} else {
		return nil
	}
}

func GetTopicsTitleList() []string {
	rows,err := db.Query("SELECT title FROM topic")
	checkError(err)

	var result []string

	for rows.Next() {
		var title string

		rows.Scan(&title)
		result = append(result,title)
	}
	return result;
}

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

func GetUserList() []User{
	rows,err := db.Query("SELECT user_name, date_joined, phone_nr FROM users")
	checkError(err)

	var result []User

	for rows.Next() {
		var user User
		rows.Scan(&user.UserName,&user.DateJoined,&user.PhoneNumber)

		result = append(result,user)
	}

	return result
}

func GetUserFromRequest(r *http.Request) *User{
	cookie,err :=r.Cookie("session")
	if err != nil {
		return nil
	}
	//checkError(err)
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
