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
	config.Producer.Return.Successes = false
	config.Producer.RequiredAcks = sarama.WaitForAll

	// 创建异步生产者
	producer, err := sarama.NewAsyncProducer(brokers, config)
	if err != nil {
		log.Fatalf("Failed to create async producer: %v", err)
	}
	defer producer.Close()

	// 异步发送消息
	go func() {
		for {
			select {
			case success := <-producer.Successes():
				log.Printf("Message sent successfully to partition %d\n", success.Partition)
			case err := <-producer.Errors():
				log.Printf("Failed to send message: %v\n", err)
			}
		}
	}()

	for i := 0; i < 10; i++ {
		message := &sarama.ProducerMessage{
			Topic: "example-topic",
			Value: sarama.StringEncoder("Message " + string(rune(i))),
		}
		producer.Input() <- message
	}

	// 阻止程序退出
	select {}
}
