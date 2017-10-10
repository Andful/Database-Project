package main

import (
	"log"
	"io/ioutil"
	"net/http"
	"fmt"
	"math/rand"
)
func ServeStaticPage(filename string) func (http.ResponseWriter,*http.Request) {
	return func (w http.ResponseWriter,r *http.Request){
		fmt.Println()
		fmt.Fprint(w,ReadFile(filename))
	}
}

func checkError(err error) {
	if err != nil {
		log.Fatal("error: ", err)
	}
}

func ReadFile(file string) string {
	dat,err :=ioutil.ReadFile(file)
	checkError(err)
	return string(dat)
}

var letterRunes = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")

func RandStringRunes(n int) string {
	b := make([]rune, n)
	for i := range b {
		b[i] = letterRunes[rand.Intn(len(letterRunes))]
	}
	return string(b)
}
