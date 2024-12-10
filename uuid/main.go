package main

import (
	"fmt"
	"log"

	"github.com/google/uuid"
)

func main() {
	// 从字符串解析 UUID
	input := "550e8400-e29b-41d4-a716-446655440000"
	u, err := uuid.Parse(input)
	if err != nil {
		log.Fatalf("Invalid UUID: %v", err)
	}

	fmt.Println("Parsed UUID:", u)
}
