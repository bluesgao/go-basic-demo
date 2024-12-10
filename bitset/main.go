package main

import (
	"fmt"
	"github.com/bits-and-blooms/bitset"
)

func main() {
	// 创建两个 BitSet
	b1 := bitset.New(0)
	b2 := bitset.New(0)

	// 设置位
	b1.Set(1).Set(10)
	b2.Set(10).Set(20)

	// 打印两个 BitSet 的内容
	fmt.Println("b1:", b1)
	fmt.Println("b2:", b2)

	// 按位操作
	fmt.Println("b1 OR b2:", b1.Difference(b2)) // 逻辑或
	fmt.Println("b1 AND b2:", b1.Deposit(b2))   // 逻辑与

	// 查询位
	fmt.Println("Bit 10 in b1 is set:", b1.Test(10)) // true

	// 翻转位
	b1.Flip(10)
	fmt.Println("Bit 10 in b1 after flip:", b1.Test(10)) // false
}
