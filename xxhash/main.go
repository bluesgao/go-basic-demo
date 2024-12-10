package main

import (
	"fmt"
	"github.com/cespare/xxhash/v2"
)

func main() {
	// 要计算哈希的数据
	data := []byte("hello, world")

	// 计算 XXH64 哈希值
	hash := xxhash.Sum64(data)

	fmt.Printf("Hash: %x\n", hash) // 输出为 16 进制字符串
}
