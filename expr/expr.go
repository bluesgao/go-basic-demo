package main

import "fmt"
import "github.com/expr-lang/expr"

func rule01() {
	program, err := expr.Compile(`2 + 2`)
	if err != nil {
		panic(err)
	}

	output, err := expr.Run(program, nil)
	if err != nil {
		panic(err)
	}

	fmt.Print(output) // 4
}

func rule02() {
	env := map[string]interface{}{
		"age": 30,
		"vip": true,
	}

	program, err := expr.Compile("age > 18 && vip")
	if err != nil {
		panic(err)
	}

	output, err := expr.Run(program, env)
	if err != nil {
		panic(err)
	}

	fmt.Print(output) // 4
}

func main() {
	rule01()
	rule02()
}
