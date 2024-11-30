package main

import (
	"fmt"
	"github.com/robfig/cron/v3"
)

func main() {
	job := cron.New()
	job.AddFunc("@every 1s", func() {
		fmt.Println("hello world")
	})

	job.Start()

	select {}
}
