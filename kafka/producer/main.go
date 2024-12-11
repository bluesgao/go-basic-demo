package main

import (
	"log"

	"github.com/IBM/sarama"
)

func main() {
	// Kafka broker 地址
	brokers := []string{"localhost:9092"}

	// 配置 Sarama
	config := sarama.NewConfig()
	config.Producer.Return.Successes = true
	config.Producer.RequiredAcks = sarama.WaitForAll
	config.Producer.Retry.Max = 5

	// 创建生产者
	producer, err := sarama.NewSyncProducer(brokers, config)
	if err != nil {
		log.Fatalf("Failed to create producer: %v", err)
	}
	defer producer.Close()

	// 要发送的消息
	message := &sarama.ProducerMessage{
		Topic: "example-topic",
		Value: sarama.StringEncoder("Hello, Kafka!"),
	}

	// 发送消息（单条）
	partition, offset, err := producer.SendMessage(message)
	if err != nil {
		log.Fatalf("Failed to send message: %v", err)
	}

	// 发送消息（多条）
	err = producer.SendMessages([]*sarama.ProducerMessage{message})
	if err != nil {
		log.Fatalf("Failed to send messages: %v", err)

	}

	log.Printf("Message sent to partition %d with offset %d\n", partition, offset)
}
