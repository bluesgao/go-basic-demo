package main

import (
	"fmt"
	"github.com/goccy/go-json"
)

type User struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

func main() {
	user := User{ID: 1, Name: "John"}

	// 序列化
	data, err := json.Marshal(user)
	if err != nil {
		panic(err)
	}
	fmt.Println("Serialized JSON:", string(data))

	// 反序列化
	var newUser User
	err = json.Unmarshal(data, &newUser)
	if err != nil {
		panic(err)
	}
	fmt.Printf("Deserialized struct: %+v\n", newUser)
}
