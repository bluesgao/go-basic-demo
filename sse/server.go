package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

// SSEHandler handles SSE connections
func SSEHandler(w http.ResponseWriter, r *http.Request) {
	// 设置响应头
	w.Header().Set("Content-Type", "text/event-stream")
	w.Header().Set("Cache-Control", "no-cache")
	w.Header().Set("Connection", "keep-alive")

	// 获取用户标识（可以通过 URL 参数）
	userID := r.URL.Query().Get("userId")
	if userID == "" {
		userID = "anonymous"
	}

	// 持续发送事件
	for i := 0; i < 1000; i++ {
		// 构建事件数据
		message := fmt.Sprintf("Hello, User %s! Message #%d", userID, i+1)
		_, err := fmt.Fprintf(w, "data: %s\n\n", message)
		if err != nil {
			log.Printf("Error sending message: %v", err)
			break
		}

		// 推送数据后刷新缓冲区
		flusher, ok := w.(http.Flusher)
		if ok {
			flusher.Flush()
		}

		// 模拟间隔 1 秒发送一次数据
		time.Sleep(1 * time.Second)
	}
}

func main() {
	// 路由绑定
	http.HandleFunc("/sse", SSEHandler)

	// 启动服务器
	fmt.Println("Server started at http://localhost:28080")
	log.Fatal(http.ListenAndServe(":28080", nil))
}
