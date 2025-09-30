package main

import (
	"fmt"
	"strconv"
	"strings"
	"time"
)

func CalcDispatchTime(tz, offset string) (int64, error) {
	parts := strings.Split(offset, ":")
	if len(parts) != 3 {
		return 0, fmt.Errorf("invalid offset format, want HH:MM:SS")
	}
	h, _ := strconv.Atoi(parts[0])
	m, _ := strconv.Atoi(parts[1])
	s, _ := strconv.Atoi(parts[2])

	// 加载时区
	loc, err := time.LoadLocation(tz)
	if err != nil {
		return 0, err
	}

	// 当前本地时区时间
	now := time.Now().In(loc)

	// 取第二天日期
	tomorrow := now.AddDate(0, 0, 1)

	// 构造“第二天的 offset 时刻”
	target := time.Date(
		tomorrow.Year(), tomorrow.Month(), tomorrow.Day(),
		h, m, s, 0,
		loc,
	)

	return target.Unix(), nil
}

func main() {
	tz1 := "Asia/Shanghai" // 东八区
	tz2 := "Asia/Tokyo"    // 东九区
	target1, _ := CalcDispatchTime(tz1, "08:00:00")
	fmt.Println(target1) //1758758400
	target2, _ := CalcDispatchTime(tz2, "08:00:00")
	fmt.Println(target2) //1758754800

}
