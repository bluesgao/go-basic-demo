package main

import (
	"fmt"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/plugin/soft_delete"
)

type User struct {
	ID   int64 `gorm:"primaryKey;default:auto_random()"`
	Name string
	Age  int64
	gorm.Model
	IsDel soft_delete.DeletedAt `gorm:"softDelete:flag"`
}

func main() {

	db, err := gorm.Open(mysql.Open("admin:cash123456@tcp(localhost:3306)/cash_sys?charset=utf8mb4&parseTime=true"),
		&gorm.Config{
			//SkipDefaultTransaction: true,
			//PrepareStmt: true, // 开启改配置
		})

	if err != nil {
		panic("failed to connect database")
	}

	//// 自动迁移，生成表结构
	//err = db.AutoMigrate(&User{})
	//if err != nil {
	//	log.Fatalf("Failed to migrate tables: %v", err)
	//}
	//log.Println("Tables created successfully!")
	//
	//var users []User
	//for i := 0; i < 100; i++ {
	//	u := User{
	//		//ID:   int64(i),
	//		Name: fmt.Sprintf("name%d", i),
	//		Age:  int64(i),
	//	}
	//	users = append(users, u)
	//}
	//
	//db = db.Create(&users)
	//fmt.Println("插入了", db.RowsAffected, "条数据")

	db = db.Where("id = ?", 1).Delete(&User{})
	fmt.Println("删除了", db.RowsAffected, "条数据")

}
