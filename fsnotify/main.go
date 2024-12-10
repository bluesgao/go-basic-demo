package main

import (
	"fmt"
	"log"

	"github.com/fsnotify/fsnotify"
)

func main() {
	// 创建文件监控器
	watcher, err := fsnotify.NewWatcher()
	if err != nil {
		log.Fatal(err)
	}
	defer watcher.Close()

	// 启动一个 goroutine 处理事件
	go func() {
		for {
			select {
			case event, ok := <-watcher.Events:
				if !ok {
					return
				}
				// 打印事件
				fmt.Printf("EVENT: %s\n", event)

				// 检查事件类型
				if event.Op&fsnotify.Create == fsnotify.Create {
					fmt.Printf("File Created: %s\n", event.Name)
				}
				if event.Op&fsnotify.Write == fsnotify.Write {
					fmt.Printf("File Modified: %s\n", event.Name)
				}
				if event.Op&fsnotify.Remove == fsnotify.Remove {
					fmt.Printf("File Deleted: %s\n", event.Name)
				}
				if event.Op&fsnotify.Rename == fsnotify.Rename {
					fmt.Printf("File Renamed: %s\n", event.Name)
				}
				if event.Op&fsnotify.Chmod == fsnotify.Chmod {
					fmt.Printf("File Permissions Changed: %s\n", event.Name)
				}

			case err, ok := <-watcher.Errors:
				if !ok {
					return
				}
				fmt.Printf("ERROR: %s\n", err)
			}
		}
	}()

	// 添加要监控的路径（文件或目录）
	err = watcher.Add("/Users/gocode/GolandProjects/study/go-basic-demo/fsnotify/")
	if err != nil {
		log.Fatal(err)
	}

	// 阻止主协程退出
	select {}
}
