package main

import (
	"fmt"
	"github.com/go-jose/go-jose/v4"
	"github.com/go-jose/go-jose/v4/jwt"
	"time"
)

func main() {
	jweDemo()
}

func jweDemo() {
	// 加密密钥
	key := []byte("12345678901234567890123456789012")

	// 待加密的数据
	payload := []byte(`{"data": "Hello, World!"}`)

	// 创建一个加密器，使用 AES GCM 加密算法
	encrypter, err := jose.NewEncrypter(jose.A256GCM, jose.Recipient{Algorithm: jose.DIRECT, Key: key},
		(&jose.EncrypterOptions{}).WithType("JWT"))
	if err != nil {
		panic(err)
	}

	// 加密数据
	jwe, err := encrypter.Encrypt(payload)
	if err != nil {
		panic(err)
	}

	// 获取加密后的 JWT 字符串
	jwtStr, err := jwe.CompactSerialize()
	if err != nil {
		panic(err)
	}

	fmt.Println("Encrypted JWE:", jwtStr)

	// 解析加密的 JWT
	decryptedJWE, err := jose.ParseEncrypted(jwtStr, []jose.KeyAlgorithm{jose.DIRECT}, []jose.ContentEncryption{jose.A256GCM})
	if err != nil {
		panic(err)
	}

	// 解密数据
	decryptedPayload, err := decryptedJWE.Decrypt(key)
	if err != nil {
		panic(err)
	}

	fmt.Println("Decrypted payload:", string(decryptedPayload))
}

func jwtDemo() {
	secretKey := []byte("12345678901234567890123456789012")
	// 创建一个签名器，使用 HMAC SHA-256 算法
	signer, err := jose.NewSigner(jose.SigningKey{Algorithm: jose.HS256, Key: secretKey},
		(&jose.SignerOptions{}).WithType("JWT"))
	if err != nil {
		panic(err)
	}

	// 创建一个 JWT 声明
	claims := jwt.Claims{
		Subject:   "user-123",
		Issuer:    "example.com",
		Expiry:    jwt.NewNumericDate(time.Now().Add(time.Hour)),
		NotBefore: jwt.NewNumericDate(time.Now()),
		IssuedAt:  jwt.NewNumericDate(time.Now()),
	}

	// 生成 JWT
	jwtStr, err := jwt.Signed(signer).Claims(claims).Serialize()
	if err != nil {
		panic(err)
	}

	fmt.Println("Generated JWT:", jwtStr)
}
