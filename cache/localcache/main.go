package main

import (
	"fmt"
	"log"
	"time"

	"github.com/allegro/bigcache/v3"
)

func main() {
	// 创建一个 BigCache 配置
	config := bigcache.Config{
		Shards:             1024,             // 分片数量，默认 1024
		LifeWindow:         10 * time.Minute, // 缓存的过期时间
		CleanWindow:        1 * time.Minute,  // 定期清理过期缓存的间隔
		MaxEntriesInWindow: 1000 * 10 * 60,   // 估计的每个分片中条目数量
		MaxEntrySize:       500,              // 每个条目的最大大小（字节）
		Verbose:            true,             // 是否输出调试信息
		HardMaxCacheSize:   0,                // 缓存的最大内存大小（MB），0 表示不限制
		OnRemove: func(key string, entry []byte) {
			fmt.Printf("Entry removed: key=%s\n", key)
		},
		OnRemoveWithReason: func(key string, entry []byte, reason bigcache.RemoveReason) {
			fmt.Printf("Entry removed: key=%s, reason=%v\n", key, reason)
		},
	}

	// 初始化 BigCache
	cache, err := bigcache.NewBigCache(config)
	if err != nil {
		log.Fatal(err)
	}

	// 添加数据到缓存
	err = cache.Set("myKey", []byte("myValue"))
	if err != nil {
		log.Fatal(err)
	}

	// 从缓存中获取数据
	entry, err := cache.Get("myKey")
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Cached value: %s\n", entry)

	// 删除缓存中的数据
	cache.Delete("myKey")
}
