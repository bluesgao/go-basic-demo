package main

import (
	"fmt"
	"github.com/IBM/sarama"
	"log"
	"strconv"
)

func main() {
	borkers := []string{"localhost:9092"}
	topic := "example_topic"
	// 基础配置
	config := sarama.NewConfig()
	config.Producer.Return.Successes = true
	//创建生产者
	producer, err := sarama.NewSyncProducer(borkers, config)
	if err != nil {
		log.Fatalf("Failed to start Sarama producer: %s", err)
	}
	defer producer.Close()

	//mock分区消息
	partitionNum := 4
	for i := 0; i < 10; i++ {
		key := fmt.Sprintf("key-%d", i%partitionNum)
		msg := &sarama.ProducerMessage{
			Topic: topic,
			Key:   sarama.StringEncoder(key),
			Value: sarama.StringEncoder("hello world" + strconv.Itoa(i)),
		}
		partition, offset, err := producer.SendMessage(msg)
		if err != nil {
			log.Printf("Failed to send message: %s", err)
		} else {
			log.Printf("Message sent to partition %d at offset %d\n", partition, offset)
		}
	}

}
