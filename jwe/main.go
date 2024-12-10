package main

import (
	"crypto/rand"
	"crypto/rsa"
	"fmt"
	"github.com/go-jose/go-jose/v4"
	"github.com/go-jose/go-jose/v4/jwt"
	"log"
	"time"
)

// 自定义 Claims 类型
type CustomClaims struct {
	UserID    int `json:"user_id"`
	CompanyID int `json:"company_id"`
	jwt.Claims
}

func main() {
	// 生成 RSA 密钥对
	privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		log.Fatalf("Failed to generate RSA key: %v", err)
	}
	publicKey := &privateKey.PublicKey

	// 签名密钥 32位
	signingKey := []byte("12345678901234567890123456789012")

	// --- 1. 创建并签名 JWT ---
	// 创建签名者
	signer, err := jose.NewSigner(jose.SigningKey{Algorithm: jose.HS256, Key: signingKey}, nil)
	if err != nil {
		log.Fatalf("Failed to create JWT signer: %v", err)
	}

	//// 创建 JWT Claims
	//claims := jwt.Claims{
	//	Subject:  "example-user",
	//	Issuer:   "example-issuer",
	//	Expiry:   jwt.NewNumericDate(time.Now().Add(1 * time.Hour)),
	//	IssuedAt: jwt.NewNumericDate(time.Now()),
	//}

	// 自定义的 Claims
	claims := CustomClaims{
		UserID:    123, // 用户 ID
		CompanyID: 1001,
		Claims: jwt.Claims{
			Subject:  "example-user",
			Issuer:   "example-issuer",
			Expiry:   jwt.NewNumericDate(time.Now().Add(1 * time.Hour)),
			IssuedAt: jwt.NewNumericDate(time.Now()),
		},
	}

	// 签名并生成 JWT
	jwtToken, err := jwt.Signed(signer).Claims(claims).Serialize()
	if err != nil {
		log.Fatalf("Failed to sign JWT: %v", err)
	}

	fmt.Printf("Signed JWT: %s\n", jwtToken)

	// --- 2. 使用 JWE 加密 JWT ---
	// 创建 JWE 加密器
	encrypter, err := jose.NewEncrypter(jose.A256GCM, jose.Recipient{
		Algorithm: jose.RSA_OAEP_256,
		Key:       publicKey,
	}, nil)
	if err != nil {
		log.Fatalf("Failed to create JWE encrypter: %v", err)
	}

	// 加密 JWT
	encryptedJWE, err := encrypter.Encrypt([]byte(jwtToken))
	if err != nil {
		log.Fatalf("Failed to encrypt JWT: %v", err)
	}

	// 序列化 JWE
	jweString, _ := encryptedJWE.CompactSerialize()
	fmt.Printf("Encrypted JWE: %s\n", jweString)

	// --- 3. 解密 JWE ---
	// 解析加密的 JWE
	parsedJWE, err := jose.ParseEncrypted(jweString, []jose.KeyAlgorithm{jose.RSA_OAEP_256}, []jose.ContentEncryption{jose.A256GCM})
	if err != nil {
		log.Fatalf("Failed to parse encrypted JWE: %v", err)
	}
	fmt.Printf("parsed JWT: %s\n", parsedJWE)

	// 解密 JWE
	decryptedJWT, err := parsedJWE.Decrypt(privateKey)
	if err != nil {
		log.Fatalf("Failed to decrypt JWE: %v", err)
	}

	fmt.Printf("Decrypted JWT: %s\n", decryptedJWT)

	// --- 4. 验证 JWT ---
	// 解析已解密的 JWT
	parsedJWT, err := jwt.ParseSigned(string(decryptedJWT), []jose.SignatureAlgorithm{jose.HS256})
	if err != nil {
		log.Fatalf("Failed to parse signed JWT: %v", err)
	}

	// 验证签名并提取 Claims
	var verifiedClaims jwt.Claims
	err = parsedJWT.Claims(signingKey, &verifiedClaims)
	if err != nil {
		log.Fatalf("Failed to verify JWT: %v", err)
	}

	fmt.Printf("Verified Claims: %+v\n", verifiedClaims)
}
