package main

import (
	"fmt"
	"image/png"
	"log"
	"os"
	"time"

	"github.com/pquerna/otp/totp"
)

func main() {
	// 生成 TOTP 密钥
	key, err := totp.Generate(totp.GenerateOpts{
		Issuer:      "MyApp",
		AccountName: "user@example.com",
	})
	if err != nil {
		log.Fatalf("failed to generate key: %v", err)
	}

	fmt.Println("Secret URL: ", key.URL())
	fmt.Println("Secret Key: ", key.Secret())

	img, err := key.Image(240, 240)
	if err != nil {
		log.Fatalf("failed to write QR code: %v", err)
	}

	// 保存二维码到文件
	file, err := os.Create("qrcode.png")
	if err != nil {
		log.Fatalf("failed to create file: %v", err)
	}
	defer file.Close()
	// 将图像保存为 PNG 文件
	err = png.Encode(file, img)
	if err != nil {
		panic(err)
	}

	log.Println("QR code written to qrcode.png")

	// 模拟生成一个一次性密码
	now := time.Now()
	passcode, err := totp.GenerateCode(key.Secret(), now)
	if err != nil {
		panic(err)
	}
	fmt.Println("Passcode: ", passcode)
	// 验证一次性密码
	valid := totp.Validate(passcode, key.Secret())
	if valid {
		fmt.Println("Valid passcode!")
	} else {
		fmt.Println("Invalid passcode!")
	}

}
