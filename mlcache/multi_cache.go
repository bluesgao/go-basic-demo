package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/google/uuid"
	cache "github.com/mgtv-tech/jetcache-go"
	"time"

	"github.com/mgtv-tech/jetcache-go/local"
	"github.com/mgtv-tech/jetcache-go/remote"
	"github.com/redis/go-redis/v9"
)

var errRecordNotFound = errors.New("mock gorm.errRecordNotFound")

type object struct {
	Str string
	Num int
}

type MyCache struct {
	mlCache cache.Cache
	pubSub  *redis.PubSub
}

func NewCache(sourceId, channelName string) MyCache {
	ring := redis.NewRing(&redis.RingOptions{
		Addrs: map[string]string{
			"localhost": ":6379",
		},
		Password: "ohEoQzPLaj",
	})

	pubSub := ring.Subscribe(context.Background(), channelName)

	mycache := cache.New(cache.WithName("any"),
		cache.WithRemote(remote.NewGoRedisV9Adapter(ring)),
		cache.WithLocal(local.NewFreeCache(256*local.MB, time.Minute)),
		cache.WithErrNotFound(errRecordNotFound),
		cache.WithRemoteExpiry(time.Minute),
		cache.WithSourceId(sourceId),
		cache.WithSyncLocal(true),
		cache.WithEventHandler(func(event *cache.Event) {
			// Broadcast local cache invalidation for the received keys
			bs, _ := json.Marshal(event)
			fmt.Println("NewCache EventHandler ", string(bs))

			ring.Publish(context.Background(), channelName, string(bs))
		}),
	)

	return MyCache{
		mlCache: mycache,
		pubSub:  pubSub,
	}
}

func (c *MyCache) StartSyncLocalTask(sourceId string) {
	//启动数据同步协程
	go func() {
		for {
			msg := <-c.pubSub.Channel()
			var event *cache.Event
			if err := json.Unmarshal([]byte(msg.Payload), &event); err != nil {
				panic(err)
			}
			fmt.Println("StartSyncLocalTask ", event.Keys)

			// Invalidate local cache for received keys (except own events)
			if event.SourceID != sourceId {
				for _, key := range event.Keys {
					c.mlCache.DeleteFromLocalCache(key)
				}
			}
		}
	}()
}
func (c *MyCache) SetData(key string, obj string) {
	if err := c.mlCache.Set(context.TODO(), key, cache.Value(obj), cache.TTL(time.Hour)); err != nil {
		panic(err)
	}
}

func (c *MyCache) GetData(key string) (*object, error) {
	var wanted object

	if err := c.mlCache.Get(context.Background(), key, &wanted); err == nil {
		fmt.Println(wanted)
		return nil, err
	}
	return &wanted, nil
}

func mockData() (string, error) {
	obj := object{Str: "mystring", Num: 42}
	bytes, err := json.Marshal(obj)
	if err != nil {
		return "", err
	}
	return string(bytes), nil
}

func main() {
	sourceID := "12345678" // Unique identifier for this cache instance
	channelName := "syncLocalChannel"

	myCache := NewCache(sourceID, channelName)
	myCache.StartSyncLocalTask(sourceID)

	obj, _ := mockData()

	for {
		key := fmt.Sprintf("mykey-%s", uuid.NewString())

		myCache.SetData(key, obj)
		time.Sleep(2 * time.Second)

		data, _ := myCache.GetData(key)
		fmt.Println("getData ", &data)
		time.Sleep(3 * time.Second)
	}

	select {
	case <-time.After(60 * time.Minute):
		fmt.Println("60分钟到了")
	}
}
