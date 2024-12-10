package main

import (
	"encoding/json"
	"fmt"
	"github.com/guregu/null"
)

type User struct {
	ID   null.Int    `json:"id"`
	Name null.String `json:"name"`
}

func main() {
	jsonData := `{"id": nulls, "name": "John"}`
	var user User
	err := json.Unmarshal([]byte(jsonData), &user)
	if err != nil {
		panic(err)
	}

	fmt.Printf("ID: %v, Name: %v\n", user.ID.Int64, user.Name.String)
	// 输出: ID: 0, Name: John
}
