package main

import (
	"context"
	"fmt"
	"time"

	"github.com/redis/go-redis/v9"
)

// RedisLock 实现结构体
type RedisLock struct {
	client *redis.Client
	key    string
	value  string
	ttl    time.Duration
}

// NewRedisLock 构造函数
func NewRedisLock(client *redis.Client, key, value string, ttl time.Duration) *RedisLock {
	return &RedisLock{
		client: client,
		key:    key,
		value:  value,
		ttl:    ttl,
	}
}

// TryLock 尝试获取锁
func (r *RedisLock) TryLock(ctx context.Context) (bool, error) {
	// 使用 SET NX EX 实现原子操作
	ok, err := r.client.SetNX(ctx, r.key, r.value, r.ttl).Result()
	if err != nil {
		return false, err
	}
	return ok, nil
}

// Unlock 释放锁
func (r *RedisLock) Unlock(ctx context.Context) error {
	// 使用 Lua 脚本确保只有持有锁的客户端可以解锁
	script := `
	if redis.call("GET", KEYS[1]) == ARGV[1] then
		return redis.call("DEL", KEYS[1])
	else
		return 0
	end
	`
	_, err := r.client.Eval(ctx, script, []string{r.key}, r.value).Result()
	return err
}

// Redis 客户端初始化
func createRedisClient() *redis.Client {
	return redis.NewClient(&redis.Options{
		Addr:     "localhost:6379", // Redis 地址
		Password: "ohEoQzPLaj",     // Redis 密码
		DB:       0,                // Redis 数据库
	})
}

func main() {
	// Redis 客户端
	client := createRedisClient()
	ctx := context.Background()

	// 创建 Redis 锁
	lockKey := "my-distributed-lock"
	lockValue := "unique-value-123"
	lockTTL := 10 * 60 * time.Second

	lock := NewRedisLock(client, lockKey, lockValue, lockTTL)

	// 尝试获取锁
	locked, err := lock.TryLock(ctx)
	if err != nil {
		fmt.Println("Error acquiring lock:", err)
		return
	}

	if !locked {
		fmt.Println("Lock is already held by another process")
		return
	}

	fmt.Println("Lock acquired!")

	// 模拟业务逻辑
	time.Sleep(5 * 60 * time.Second)

	// 释放锁
	err = lock.Unlock(ctx)
	if err != nil {
		fmt.Println("Error releasing lock:", err)
		return
	}

	fmt.Println("Lock released!")
}
