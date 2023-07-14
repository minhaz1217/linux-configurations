package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

var hitCount int = 0
var badRequestHitCount int = 0
var delayId int = 0

func main() {
	fmt.Println("App Starting...")
	http.HandleFunc("/status", statusEndPoint)
	http.HandleFunc("/get-ip", getIPEndPoint)
	http.HandleFunc("/health", healthyEndPoint)
	http.HandleFunc("/hit", hitEndPoint)
	http.HandleFunc("/reset-hit-count", resetHitCountEndPoint)
	http.HandleFunc("/bad", badRequestEndPoint)
	http.HandleFunc("/bad-request-after-5-hits", badRequestAfter5Hits)
	http.HandleFunc("/reset-bad-request-count", resetBadRequestCountEndPoint)
	http.HandleFunc("/delay/", delayEndPoint)
	http.HandleFunc("/", rootEndpoint)

	log.Fatal(http.ListenAndServe(":3000", nil))
}

func getHostName() string {
	hostName, _ := os.Hostname()
	return hostName
}

func rootEndpoint(w http.ResponseWriter, r *http.Request) {
	hostName := getHostName()
	output := fmt.Sprintf("%s", hostName)
	outputLog := fmt.Sprintf("rootEndpoint Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, fmt.Sprintf("%s\n", output))
}

func statusEndPoint(w http.ResponseWriter, r *http.Request) {
	output := "ok"
	outputLog := fmt.Sprintf("statusEndPoint Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, fmt.Sprintf("%s\n", output))
}

func getIPEndPoint(w http.ResponseWriter, r *http.Request) {
	host := getHostName()
	addrs, _ := net.LookupIP(host)
	for _, addr := range addrs {
		if ipv4 := addr.To4(); ipv4 != nil {
			ipv4String := fmt.Sprintf("%s", ipv4)
			outputLog := fmt.Sprintf("getIPEndPoint Got hit from: %s Output: %s", r.URL.Path[1:], ipv4String)
			fmt.Println(outputLog)
			fmt.Fprintf(w, fmt.Sprintf("%s\n", ipv4String))
			return
		}
	}
}

func healthyEndPoint(w http.ResponseWriter, r *http.Request) {
	output := "healthy"
	outputLog := fmt.Sprintf("healthyEndPoint Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, fmt.Sprintf("%s\n", output))
}

func hitEndPoint(w http.ResponseWriter, r *http.Request) {
	hitCount += 1
	output := fmt.Sprintf("%d", hitCount)
	outputLog := fmt.Sprintf("hitEndPoint Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, output)
}

func resetHitCountEndPoint(w http.ResponseWriter, r *http.Request) {
	hitCount = 0
	output := fmt.Sprintf("%d", hitCount)
	outputLog := fmt.Sprintf("resetHitCountEndPoint Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, output)
}

func badRequestEndPoint(w http.ResponseWriter, r *http.Request) {
	output := "bad"
	outputLog := fmt.Sprintf("badRequestEndPoint Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	w.WriteHeader(http.StatusInternalServerError)
	fmt.Fprintf(w, fmt.Sprintf("%s\n", output))
}

func badRequestAfter5Hits(w http.ResponseWriter, r *http.Request) {
	badRequestHitCount += 1
	output := fmt.Sprintf("%d", badRequestHitCount)
	outputLog := fmt.Sprintf("badRequestAfter5Hits Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	if badRequestHitCount > 5 {
		w.WriteHeader(http.StatusInternalServerError)
	}
	fmt.Fprintf(w, output)
}

func resetBadRequestCountEndPoint(w http.ResponseWriter, r *http.Request) {
	badRequestHitCount = 0
	output := fmt.Sprintf("%d", hitCount)
	outputLog := fmt.Sprintf("resetBadRequestCountEndPoint Got hit from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	fmt.Fprintf(w, output)
}

func delayEndPoint(w http.ResponseWriter, r *http.Request) {

	delayString := strings.TrimPrefix(r.URL.Path, "/delay/")
	delay, err := strconv.Atoi(delayString)
	output := fmt.Sprintf("%s", delayString)
	outputLog := fmt.Sprintf("delay Got hit asdf from: %s Output: %s", r.URL.Path[1:], output)
	fmt.Println(outputLog)
	if err != nil {
		fmt.Fprintf(w, fmt.Sprintf("%s\n", "ERROR"))
		return
	}
	delayId += 1
	hostName := getHostName()
	fmt.Println("Starting delay:", delay, "Host:", hostName, "DelayID:", delayId)
	time.Sleep(time.Duration(delay) * time.Millisecond)
	fmt.Println("Stopping delay:", delay, "Host:", hostName, "DelayID:", delayId)
	fmt.Fprintf(w, fmt.Sprintf("Finished delay: %d Host: %s DelayID: %d\n", delay, hostName, delayId))
}
