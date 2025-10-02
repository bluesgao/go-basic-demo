package main

import (
	"encoding/json"
	"log"
	"math/rand"
	"time"

	"github.com/hibiken/asynq"
)

// Task payload for any email related tasks.
type EmailTaskPayload struct {
	// ID for the email recipient.
	UserID int
}

// client.go
func main() {
	// 创建asynq 客户端
	client := asynq.NewClient(asynq.RedisClientOpt{Addr: "localhost:6379", Password: "Dev123456", DB: 0})

	// Create a task with typename and payload.
	// 随机整数
	payload, err := json.Marshal(EmailTaskPayload{UserID: rand.Intn(10000)})
	if err != nil {
		log.Fatal(err)
	}

	// 创建task
	t1 := asynq.NewTask("email:welcome", payload)

	t2 := asynq.NewTask("email:reminder", payload)

	// 投递 立即task 到任务队列中
	info, err := client.Enqueue(
		t1,
		asynq.Queue("email_welcome_queue"),
		asynq.MaxRetry(5),
		asynq.Timeout(60*time.Second),
		asynq.Unique(15*time.Minute),
	)
	if err != nil {
		log.Fatal(err)
	}
	log.Printf(" [*] Successfully enqueued task: %+v", info)

	// 投递 延迟task 到任务队列中
	info, err = client.Enqueue(t2,
		asynq.Queue("email_reminder_queue"),
		asynq.MaxRetry(5),
		asynq.Timeout(60*time.Second),
		asynq.Unique(15*time.Minute),
		asynq.ProcessIn(5*time.Minute))
	if err != nil {
		log.Fatal(err)
	}
	log.Printf(" [*] Successfully enqueued task: %+v", info)
}
