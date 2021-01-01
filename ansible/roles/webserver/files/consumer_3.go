package main

import (
	"strings"
	"fmt"
	"gopkg.in/confluentinc/confluent-kafka-go.v1/kafka"
	"time"
	"encoding/json"
	"log"
	"net/http"
	"github.com/gorilla/mux"
)

type artist struct {
	Number string `json:"nCount"`
	Name string `json:"name"`
	Birth string `json:"birth"`
	Death string `json:"death"`
	Profession []string `json:"profession"`
	Titles []string `json:"titles"`
}

var artists []artist

// Retrieves messages from kafka
func getFromKafka(cons *kafka.Consumer) (string, bool) {
	read := false
	for !read {
		fmt.Println("Reading From Kafka....")
		tm, tmErr := time.ParseDuration("5s")
		fmt.Printf("%v, %v\n", tmErr, 31)
		line, err := cons.ReadMessage(tm)
		fmt.Printf("%v, %T, %v, %T, %v\n", line, line, err, err, 33)
		if err == nil {
			read = true
			return string(line.Value), true
		} else {
			fmt.Printf("%v, %v\n", err, 38)
		}
	}
	return "", false
}

// Adds artists to the list
func addArtists(block string) {
	lines := strings.Split(block, "\n")
	for i := 0; i<len(lines); i++ {
		attr := strings.Split(lines[i], "\t")
		// fmt.Println(len(attr))
		if attr[0] == "nconst" {
			continue
		} else if len(attr) == 6 {
			artists = append(artists, artist{
				Number: attr[0],
				Name: attr[1],
				Birth: attr[2],
				Death: attr[3],
				Profession: strings.Split(attr[4], ","),
				Titles: strings.Split(attr[5], ",")})
		}
	}
}

// Search Functions
func searchArtistByName(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	var queriedArtists []artist
	// fmt.Println(params)
	for _,art := range artists {
		if(strings.Contains(art.Name, params["name"])) {
			queriedArtists = append(queriedArtists, art)
		}
	}
	fmt.Printf("%v, %v\n", len(queriedArtists), 76)
	json.NewEncoder(w).Encode(queriedArtists)
}

func searchArtistByBirthYear(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	var queriedArtists []artist
	// fmt.Println(params)
	for _,art := range artists {
		if(strings.Contains(art.Birth, params["birth"])) {
			queriedArtists = append(queriedArtists, art)
		}
	}
	fmt.Printf("%v, %v", len(queriedArtists), 90)
	json.NewEncoder(w).Encode(queriedArtists)
}

func searchArtistByDeathYear(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	var queriedArtists []artist
	// fmt.Println(params)
	for _,art := range artists {
		if(strings.Contains(art.Death, params["death"])) {
			queriedArtists = append(queriedArtists, art)
		}
	}
	fmt.Printf("%v, %v", len(queriedArtists), 104)
	json.NewEncoder(w).Encode(queriedArtists)
}

func searchArtistByProfession(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	params := mux.Vars(r)
	var queriedArtists []artist
	// fmt.Println(params)
	for _,art := range artists {
		for i := range art.Profession {
			if(strings.Contains(art.Profession[i], params["profession"])) {
				queriedArtists = append(queriedArtists, art)
			}
		}
	}
	fmt.Printf("%v, %v", len(queriedArtists), 120)
	json.NewEncoder(w).Encode(queriedArtists)
}

func main() {
	// Consumer Init
	c, kafErr := kafka.NewConsumer(&kafka.ConfigMap{
		"bootstrap.servers": "127.0.1.1 10.11.2.152:9092",
		"auto.offset.reset": "earliest",
		"group.id":          "myGroup_3",
	})
	if kafErr != nil {
		fmt.Println("Consumer wasn't initialized")
	}
	c.SubscribeTopics([]string{"file-transfer"}, nil)
	for {
		line, success := getFromKafka(c)
		if success {
			addArtists(line)
		} else {
			break
		}
		fmt.Println(len(artists), artists[0], 142)
	}
	c.Close()
	// Route Handles and Endpoints
	muxer := mux.NewRouter()
	muxer.HandleFunc("/search/ByName/{name}", searchArtistByName)
	muxer.HandleFunc("/search/ByBirth/{birth}", searchArtistByBirthYear)
	muxer.HandleFunc("/search/ByDeath/{death}", searchArtistByDeathYear)
	muxer.HandleFunc("/search/ByProfession/{profession}", searchArtistByProfession)
	// Start Server
	log.Fatal(http.ListenAndServe(":8180", muxer))
}
