package main

import (
	"fmt"
	"github.com/zeromicro/go-zero/core/fx"
)

func main() {
	streamGroup()
}

func streamGroup() {
	items := []any{"apple", "banana", "avocado", "blueberry"}

	var groups [][]string
	fx.Just(items...).
		Group(func(item any) any {
			return item.(string)[0] // 按首字母分组
		}).ForEach(func(item any) {
		v := item.([]any)
		var group []string
		for _, each := range v {
			group = append(group, each.(string))
		}
		groups = append(groups, group)
	})
	fmt.Println(groups)
}
