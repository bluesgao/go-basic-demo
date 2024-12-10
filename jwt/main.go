package main

import (
	"fmt"
	"github.com/golang-jwt/jwt/v5"
	"time"
)

var secretKey = []byte("my_secret_key") // 用于签名的密钥

// 自定义 Claims 类型
type CustomClaims struct {
	UserID    int `json:"user_id"`
	CompanyID int `json:"company_id"`
	jwt.RegisteredClaims
}

func main() {
	token, err := genJwt()
	if err != nil {
		fmt.Println("Error generating token:", err)
		return
	}
	fmt.Println("Generated Token:", token)

	_, err = validateJwt(token)
	if err != nil {
		fmt.Println("Error validating token:", err)
	}

}

func genJwt() (string, error) {
	// 自定义的 Claims
	claims := CustomClaims{
		UserID: 123, // 用户 ID
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(time.Hour)), // 1 小时后过期
			IssuedAt:  jwt.NewNumericDate(time.Now()),                // 签发时间
		},
	}
	// 创建一个 Token 对象
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	// 使用密钥签名 Token
	signedToken, err := token.SignedString(secretKey)
	if err != nil {
		fmt.Println("Error signing token:", err)
		return "", err
	}

	fmt.Println("Generated Token:", signedToken)
	return signedToken, nil
}

func validateJwt(token string) (bool, error) {

	// 验证和解析 Token
	parsedToken, err := jwt.ParseWithClaims(token, &CustomClaims{}, func(token *jwt.Token) (interface{}, error) {
		return secretKey, nil
	})

	if err != nil {
		fmt.Println("Error parsing token:", err)
		return false, err
	}

	if claims, ok := parsedToken.Claims.(*CustomClaims); ok && parsedToken.Valid {
		fmt.Println("Token is valid!")
		fmt.Println("UserID:", claims.UserID)
	} else {
		fmt.Println("Invalid token.")
	}
	return true, nil
}
