package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"bytes"

	"gopkg.in/confluentinc/confluent-kafka-go.v1/kafka"
)

func getNextBlock(fileReader *bufio.Reader) ([]byte, bool) {
	block := []byte{}
	buff := bytes.NewBuffer(block)
	fmt.Println(len(block))
	numOfLines := 0
	eof := false
	for ;numOfLines<10000; numOfLines++ {
		line, err := fileReader.ReadBytes('\n')
		if err == nil && err != io.EOF {
			fmt.Printf("Adding line to Buffer %v\n", string(line[:10]))
			buff.WriteString(string(line))
		} else if err != nil && err == io.EOF {
			fmt.Println("End of File Reached")
			buff.WriteString(string(line))
			eof = true
		}
	}
	fmt.Println(len(buff.Bytes()))
	return buff.Bytes(), eof
}

func sendToKafka(prod *kafka.Producer, line []byte) {
	topic := "file-transfer"
	prod.Produce(&kafka.Message{
		TopicPartition: kafka.TopicPartition{Topic: &topic, Partition: kafka.PartitionAny},
		Value:          line,
	}, nil)
	fmt.Printf("Sent %v Bytes\n", len(line))
	prod.Flush(10)
}

func main() {
	// fmt.Println("Running")
	file, err := os.Open("data.tsv")
	p, kafErr := kafka.NewProducer(&kafka.ConfigMap{"bootstrap.servers": "localhost:9092"})
	if err != nil {
		fmt.Println("File doesn't exist in the given directory")
	}
	if kafErr != nil {
		panic(err)
	}
	fileReader := bufio.NewReader(file)
	defer p.Close()
	defer file.Close()
	for {
		line, eof := getNextBlock(fileReader)
		if !eof {
			// fmt.Println(string(line))
			sendToKafka(p, line)
		} else {
			sendToKafka(p, line)
			break
		}
	}
}
