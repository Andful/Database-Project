package main

import (
	"fmt"
	"net/http"
	"strings"
	"io/ioutil"

	"database/sql"
	_ "github.com/lib/pq"
	"golang.org/x/crypto/bcrypt"
	"html/template"
	"time"
	"math/rand"
	"strconv"
)

const (
	DB_USER     = "university"
	DB_PASSWORD = "dicks"
	DB_NAME     = "main"
)

var db *sql.DB = nil
func ServeUsers(w http.ResponseWriter,r *http.Request) {
	r.ParseForm()
	postfix := GetPostfix("/user/",r.URL.Path)
	var users struct{
		Current *User
		Selected *User
		Employee *Employee
		}
	users.Current=GetUserFromRequest(r)
	users.Selected=GetUserFromName(postfix)
	users.Employee=GetEmployeeFromUser(users.Selected)
	fmt.Println(users)

	if users.Selected!=nil {
		templ,err:=template.ParseFiles(
			"res/html/dynamic/show_user.html",
			"res/html/components/include_css.html",
			"res/html/components/include_js.html",
			"res/html/components/navbar.html",
			"res/html/components/meta.html",
				)
		err = templ.Execute(w,users)
		checkError(err)
	} else {
		http.NotFound(w,r)
	}
}
func ServeTeamList(w http.ResponseWriter, r *http.Request){
	var teamsCurrent struct{
		Teams []Team
		Current *User
	}
	teamsCurrent.Teams = GetTeamList()
	teamsCurrent.Current = GetUserFromRequest(r)
	templ,err:=template.ParseFiles(
		"res/html/dynamic/show_team_list.html",
		"res/html/components/include_css.html",
		"res/html/components/include_js.html",
		"res/html/components/navbar.html",
		"res/html/components/meta.html",
	)
	checkError(err)
	err = templ.Execute(w,teamsCurrent)
	checkError(err)
}

func ServeTeam(w http.ResponseWriter, r *http.Request) {
	var err error

	r.ParseForm()
	postfix := GetPostfix("/team/",r.URL.Path)
	if(postfix==""){
		ServeTeamList(w,r);
		return;
	}
	var teamUser struct {
		Team *Team
		User *User
	}
	teamUser.User=GetUserFromRequest(r)
	id,err:=strconv.ParseUint(postfix,10,32)
	checkError(err)
	teamUser.Team=GetTeamFromId(uint32(id))

	if teamUser.Team!=nil {
		templ,err:=template.ParseFiles(
			"res/html/dynamic/show_team.html",
			"res/html/components/include_css.html",
			"res/html/components/include_js.html",
			"res/html/components/navbar.html",
			"res/html/components/meta.html",
		)
		err = templ.Execute(w,teamUser)
		checkError(err)
	} else {
		http.NotFound(w,r)
	}
}

func ServeLogout(w http.ResponseWriter, r *http.Request) {
	expiration := time.Now().Add(365 * 24 * time.Hour)
	newCookie := http.Cookie{
		Name: "session",
		Value:"",
		Path:"/",
		Expires:expiration,
	}
	w.Header().Add("Set-Cookie",newCookie.String())
	http.Redirect(w, r, "/login/", 303)
}

func ServeLogin(w http.ResponseWriter, r *http.Request) {
	var err error

	r.ParseForm()
	if(r.Method=="GET"){
		cookie,err:=r.Cookie("session")
		fmt.Println(cookie)
		dat,err :=ioutil.ReadFile("res/html/static/login.html")
		checkError(err)
		fmt.Fprint(w,string(dat))
	} else if(r.Method=="POST") {
		username := r.FormValue("username")
		password := []byte(r.FormValue("password"))
		row := db.QueryRow("SELECT password,cookie FROM users WHERE user_name=$1", username)
		var str_hashed_password1 string
		var cookie string
		err = row.Scan(&str_hashed_password1, &cookie)

		checkError(err)

		if err == sql.ErrNoRows {
			fmt.Fprint(w, "no username"+username)
		} else {
			hashed_password1 := []byte(str_hashed_password1)
			err = bcrypt.CompareHashAndPassword(hashed_password1, password)
			if err != nil {
				fmt.Fprint(w, "wrong password")
			} else {
				http.Redirect(w, r, "/form/", 303)
			}
		}
	}
}

func ServeSignUp(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	if(r.Method=="GET") {
		dat,err :=ioutil.ReadFile("res/html/static/signup.html")
		checkError(err)
		fmt.Fprint(w,string(dat))
	} else if(r.Method=="POST") {
		username := r.FormValue("username")
		password := r.FormValue("password")
		phone_number :=r.FormValue("phone number")
		date := time.Now().Local()
		hashed_password, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
		checkError(err)

		for {
			cookie := RandStringRunes(30)
			_, err = db.Query("INSERT INTO users VALUES($1,$2,$3,$4,$5);", username, date.Format("01/02/2006"), string(hashed_password), string(phone_number), cookie)
			if err != nil {
				if strings.Contains(err.Error(),"\"users_pkey\"") {
					fmt.Fprint(w,"username already used")
					break;
				} else if strings.Contains(err.Error(),"\"users_phone_nr_key\""){
					fmt.Fprint(w,"number already used")
					break;
				} else if strings.Contains(err.Error(),"\"users_cookie_key\"") {
					continue;
				} else if strings.Contains(err.Error(),"\"users_phone_nr_check\"") {
					fmt.Fprint(w,"insert valid phone number")
				}
			} else{
				expiration := time.Now().Add(365 * 24 * time.Hour)
				newCookie := http.Cookie{
					Name: "session",
					Value:cookie,
					Path:"/",
					Expires:expiration,
					}
				w.Header().Add("Set-Cookie",newCookie.String())
				http.Redirect(w, r, "/form/", 303)
				break;
			}
			checkError(err)

		}
	}

}

func ServeThanks(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()

	fmt.Println(r.Form)
	fmt.Println(r.FormValue("name"))
	fmt.Println(r.FormValue("family name"))

	dat,_:=ioutil.ReadFile("res/html/static/thanks.html")
	fmt.Fprint(w,string(dat))
}

func ServeTest(w http.ResponseWriter, r *http.Request) {
	var err error

	tmpl, err := template.ParseFiles("res/html/dynamic/test.html")
	// Error checking elided
	a :=[3]string{
		"1",
		"2",
		"ciao",
	}
	err = tmpl.Execute(w,a)

	checkError(err)
}

func NoDirFunction(h http.Handler) func(http.ResponseWriter,*http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		if strings.HasSuffix(r.URL.Path, "/") {
			http.NotFound(w, r)
			return
		}
		h.ServeHTTP(w, r)
	}
}

func main() {
	var err error
	rand.Seed(time.Now().UnixNano())
	dbinfo := fmt.Sprintf("user=%s password=%s dbname=%s sslmode=disable",
		DB_USER, DB_PASSWORD, DB_NAME)
	db, err = sql.Open("postgres", dbinfo)
	defer db.Close()
	checkError(err)



	http.HandleFunc("/source/",
		NoDirFunction(http.StripPrefix("/source/",
			http.FileServer(http.Dir("./res/html/source/")))))
	http.HandleFunc("/user/",ServeUsers)
	http.HandleFunc("/team/",ServeTeam)
	http.HandleFunc("/form/",ServeStaticPage("res/html/static/form.html"))
	http.HandleFunc("/thankyou/",ServeThanks)
	http.HandleFunc("/test/",ServeTest)
	http.HandleFunc("/signup/",ServeSignUp)
	http.HandleFunc("/login/",ServeLogin)
	http.HandleFunc("/logout/",ServeLogout)
	err = http.ListenAndServe(":9090", nil) // set listen port
	checkError(err)
}

