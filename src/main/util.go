package main

import (
	"log"
	"io/ioutil"
	"net/http"
	"fmt"
	"math/rand"
	"strings"
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

func GetPostfix(prefix string,line string) string {
	lineWithNoFront:=line[len(prefix):]
	end:=strings.Index(lineWithNoFront,"/")
	if end==-1 {
		end=len(lineWithNoFront)
	}
	return lineWithNoFront[:end]
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
