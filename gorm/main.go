package main

import (
	"fmt"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"strings"
)

type User struct {
	ID   int64 `gorm:"primaryKey;default:auto_random()"`
	Name string
	Age  int64
}

func main() {

	db, err := gorm.Open(mysql.Open("admin:tRyf6U58C1EI@tcp(n5eisvl0q.cloud-app.celerdata.com:9030)/cash_sys?charset=utf8mb4&parseTime=true"),
		&gorm.Config{
			//SkipDefaultTransaction: true,
			//PrepareStmt: true, // 开启改配置
		})
	//db.PrepareStmt = false

	if err != nil {
		panic("failed to connect database")
	}

	//dbs := db.Session(&gorm.Session{PrepareStmt: true})
	//baseSql := "INSERT INTO tests (`id`, `name`, `age`) VALUES "
	var values []string
	for i := 0; i < 100; i++ {
		u := User{
			ID:   int64(i),
			Name: fmt.Sprintf("name%d", i),
			Age:  int64(i),
		}
		//db.Create(u)
		//  插入Exec
		value := fmt.Sprintf("(%d, '%s',%d)", u.ID, u.Name, u.Age)
		values = append(values, value)
	}
	sql := fmt.Sprintf("INSERT INTO tests (`id`, `name`, `age`) VALUES %s", strings.Join(values, ","))

	db = db.Exec(sql)
	fmt.Println("插入了", db.RowsAffected, "条数据")
	//
	//
	////   查询 执行用Scan 和Find 一样
	//var users []User
	//db = db.Raw("select `id`,`name`,`age` from tests").Scan(&users)
	////db=db.Raw("select uid,user_name,age from Users").Find(&users)
	//fmt.Println("Users", users)
	//
	////  插入Exec
	//db = db.Exec("INSERT INTO tests (`id`, `name`, `age`) VALUES (1, 'aaa',1)")
	//fmt.Println("插入了", db.RowsAffected, "条数据")
	//
	////  更新和删除Exec
	//db = db.Exec("update tests set `name`='def' where `id`=?", 1)
	//fmt.Println("更新了", db.RowsAffected, "条数据")
	//db = db.Exec("delete from tests where id=?", 2)
	//fmt.Println("更新了", db.RowsAffected, "条数据")

}
