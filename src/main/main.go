package main

import (
	"fmt"
	"net/http"
	"strings"
	"log"
	"io/ioutil"

	"database/sql"
	_ "github.com/lib/pq"
	"html/template"
)

const (
	DB_USER     = "university"
	DB_PASSWORD = "dicks"
	DB_NAME     = "main"
)

var db *sql.DB = nil
var err error

func ServeForm(w http.ResponseWriter, r *http.Request) {
	dat,_:=ioutil.ReadFile("res/html/static/form.html")
	fmt.Fprint(w,string(dat))
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
	tmpl, _ := template.ParseFiles("res/html/dynamic/test.html")
	// Error checking elided
	a :=[3]string{
		"1",
		"2",
		"ciao",
	}
	err = tmpl.Execute(w,a)
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
	dbinfo := fmt.Sprintf("user=%s password=%s dbname=%s sslmode=disable",
		DB_USER, DB_PASSWORD, DB_NAME)
	db, err = sql.Open("postgres", dbinfo)
	defer db.Close()
	checkError(err)

	fmt.Println("# Inserting values")

	var lastInsertId string
	//err = db.QueryRow("INSERT INTO test VALUES($1,$2) returning name;", "from go4", 2).Scan(&lastInsertId)
	checkError(err)
	fmt.Println("last inserted id =", lastInsertId)



	http.HandleFunc("/source/",
		NoDirFunction(http.StripPrefix("/source/",
			http.FileServer(http.Dir("./res/html/source/")))))
	http.HandleFunc("/form/",ServeForm)
	http.HandleFunc("/thankyou/",ServeThanks)
	http.HandleFunc("/test/",ServeTest)
	err = http.ListenAndServe(":9090", nil) // set listen port
	checkError(err)
}

func checkError(err error) {
	if err != nil {
		log.Fatal("error: ", err)
	}
}

