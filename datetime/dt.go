package main

import (
	"fmt"
	"time"
)

// 主函数
func main() {
	slime := time.Now().Format("2006-01-02")
	startTime, endTime := GetDateTime(slime)
	fmt.Println(startTime, endTime)
}

func GetDateTime(date string) (int64, int64) {
	//获取当前时区
	loc, _ := time.LoadLocation("Local")

	//日期当天0点时间戳(拼接字符串)
	startDate := date + "_00:00:00"
	startTime, _ := time.ParseInLocation("2006-01-02_15:04:05", startDate, loc)

	//日期当天23时59分时间戳
	endDate := date + "_23:59:59"
	end, _ := time.ParseInLocation("2006-01-02_15:04:05", endDate, loc)

	//返回当天0点和23点59分的时间戳
	return startTime.Unix(), end.Unix()
}
