package main

import (
	"context"
	"log"

	"github.com/IBM/sarama"
)

type ConsumerGroupHandler struct{}

func (ConsumerGroupHandler) Setup(_ sarama.ConsumerGroupSession) error   { return nil }
func (ConsumerGroupHandler) Cleanup(_ sarama.ConsumerGroupSession) error { return nil }
func (ConsumerGroupHandler) ConsumeClaim(session sarama.ConsumerGroupSession, claim sarama.ConsumerGroupClaim) error {
	for msg := range claim.Messages() {
		log.Printf("Consumed message: %s\n", string(msg.Value))
		session.MarkMessage(msg, "")
	}
	return nil
}

func main() {
	// Kafka broker 地址
	brokers := []string{"localhost:9092"}
	topic := "example-topic"
	group := "example-group"

	// 配置 Sarama
	config := sarama.NewConfig()
	config.Consumer.Offsets.Initial = sarama.OffsetNewest

	// 创建消费者组
	consumerGroup, err := sarama.NewConsumerGroup(brokers, group, config)
	if err != nil {
		log.Fatalf("Failed to create consumer group: %v", err)
	}
	defer consumerGroup.Close()

	// 消费者组处理器
	handler := ConsumerGroupHandler{}

	// 开始消费
	for {
		if err := consumerGroup.Consume(context.Background(), []string{topic}, handler); err != nil {
			log.Fatalf("Error consuming messages: %v", err)
		}
	}
}
