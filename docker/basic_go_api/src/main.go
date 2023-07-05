package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"net"
)

var hitCount int = 0
var badRequestHitCount int = 0

func main() {
	fmt.Println("App Starting...")
	http.HandleFunc("/", rootEndpoint)
	http.HandleFunc("/status", statusEndPoint)
	http.HandleFunc("/get-ip", getIPEndPoint)
	http.HandleFunc("/health", healthyEndPoint)
	http.HandleFunc("/hit", hitEndPoint)
	http.HandleFunc("/reset-hit-count", resetHitCountEndPoint)
	http.HandleFunc("/bad", badRequestEndPoint)
	http.HandleFunc("/bad-request-after-5-hits", badRequestAfter5Hits)
	http.HandleFunc("/reset-bad-request-count", resetBadRequestCountEndPoint)
	
	log.Fatal(http.ListenAndServe(":3000", nil))
}

func rootEndpoint(w http.ResponseWriter, r *http.Request) {
	hostName, _ := os.Hostname()
	output := fmt.Sprintf("%s", hostName)
	outputLog := fmt.Sprintf("Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, fmt.Sprintf("%s\n", output))
}

func statusEndPoint(w http.ResponseWriter, r *http.Request) {
	output := "ok"
	outputLog := fmt.Sprintf("Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, fmt.Sprintf("%s\n", output))
}

func getIPEndPoint(w http.ResponseWriter, r *http.Request) {
	host, _ := os.Hostname()
	addrs, _ := net.LookupIP(host)
	for _, addr := range addrs {
		if ipv4 := addr.To4(); ipv4 != nil {
			ipv4String := fmt.Sprintf("%s", ipv4)
			outputLog := fmt.Sprintf("Got hit from: %s Output: %s", r.URL.Path[1:], ipv4String)
			fmt.Println(outputLog)
			fmt.Fprintf(w, fmt.Sprintf("%s\n", ipv4String))
			return
		}   
	}
}

func healthyEndPoint(w http.ResponseWriter, r *http.Request) {
	output := "healthy"
	outputLog := fmt.Sprintf("Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, fmt.Sprintf("%s\n", output))
}

func hitEndPoint(w http.ResponseWriter, r *http.Request) {
	hitCount += 1
	output := fmt.Sprintf("%d", hitCount)
	outputLog := fmt.Sprintf("Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, output)
}

func resetHitCountEndPoint(w http.ResponseWriter, r *http.Request) {
	hitCount = 0
	output := fmt.Sprintf("%d", hitCount)
	outputLog := fmt.Sprintf("Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, output)
}

func badRequestEndPoint(w http.ResponseWriter, r *http.Request) {
	output := "bad"
	outputLog := fmt.Sprintf("Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
    w.WriteHeader(http.StatusInternalServerError)
	fmt.Fprintf(w, fmt.Sprintf("%s\n", output))
}

func badRequestAfter5Hits(w http.ResponseWriter, r *http.Request) {
	badRequestHitCount += 1
	output := fmt.Sprintf("%d", badRequestHitCount)
	outputLog := fmt.Sprintf("Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	if(badRequestHitCount > 5){
		w.WriteHeader(http.StatusInternalServerError)
	}
	fmt.Fprintf(w, output)
}

func resetBadRequestCountEndPoint(w http.ResponseWriter, r *http.Request) {
	badRequestHitCount = 0
	output := fmt.Sprintf("%d", hitCount)
	outputLog := fmt.Sprintf("Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, output)
}