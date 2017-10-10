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
)

const (
	DB_USER     = "university"
	DB_PASSWORD = "dicks"
	DB_NAME     = "main"
)

var db *sql.DB = nil

func ServeLogin(w http.ResponseWriter, r *http.Request) {
	var err error

	r.ParseForm()
	if(r.Method=="GET"){
		dat,err :=ioutil.ReadFile("res/html/static/login.html")
		checkError(err)
		fmt.Fprint(w,string(dat))
	} else if(r.Method=="POST") {
		username := r.FormValue("username")
		password := []byte(r.FormValue("password"))
		row := db.QueryRow("SELECT hashed_password,cookie FROM users WHERE username=$1", username)
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
		hashed_password, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
		checkError(err)

		usernameUsed:=false
		err = db.QueryRow("SELECT EXISTS(SELECT username FROM users WHERE username=$1);",
			username).Scan(&usernameUsed)
		checkError(err)

		if(usernameUsed){
			fmt.Fprint(w,"username already used")
			return
		}

		cookie := ""
		isPresent :=true
		//FIXME: might
		for {
			cookie = RandStringRunes(30)
			fmt.Println(cookie)
			err := db.QueryRow("SELECT EXISTS(SELECT cookie FROM users WHERE cookie=$1);",
				cookie).Scan(&isPresent)
			checkError(err)
			if !isPresent {
				break
			}
		}


		db.QueryRow("INSERT INTO users VALUES($1,$2,$3);", username,string(hashed_password),cookie)
		http.Redirect(w, r, "/form/", 303)
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
	http.HandleFunc("/form/",ServeStaticPage("res/html/static/form.html"))
	http.HandleFunc("/thankyou/",ServeThanks)
	http.HandleFunc("/test/",ServeTest)
	http.HandleFunc("/signup/",ServeSignUp)
	http.HandleFunc("/",ServeLogin)
	err = http.ListenAndServe(":9090", nil) // set listen port
	checkError(err)
}

