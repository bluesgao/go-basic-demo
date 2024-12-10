package main

import (
	"fmt"
	"github.com/mitchellh/mapstructure"
)

type User struct {
	ID   int
	Name string
	Age  int
}

func main() {
	// 示例 map
	data := map[string]interface{}{
		"ID":   1,
		"Name": "Alice",
		"Age":  25,
	}

	// 转换到 struct
	var user User
	err := mapstructure.Decode(data, &user)
	if err != nil {
		panic(err)
	}

	fmt.Printf("Struct: %+v\n", user)
}
