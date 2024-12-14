package main

import (
	"fmt"
	"github.com/deatil/go-encoding/encoding"
)

func main() {
	oldData := "useData"

	// Base64 编码
	base64Data := encoding.
		FromString(oldData).
		Base64Encode().
		ToString()
	fmt.Println("Base64 编码为：", base64Data)

	// Base64 解码
	base64DecodeData := encoding.
		FromString(base64Data).
		Base64Decode().
		ToString()
	fmt.Println("Base64 解码为：", base64DecodeData)

	base62EncodeData := encoding.FromString(oldData).Base62Encode().ToString()
	fmt.Println("Base62 编码为：", base62EncodeData)

}
