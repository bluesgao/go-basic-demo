package main

import (
	"fmt"
	"github.com/huandu/go-sqlbuilder"
	"github.com/shopspring/decimal"
	"github.com/zeromicro/go-zero/core/logx"
	"gorm.io/datatypes"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

//TIP To run your code, right-click the code and select <b>Run</b>. Alternatively, click
// the <icon src="AllIcons.Actions.Execute"/> icon in the gutter and select the <b>Run</b> menu item from here.

type AgentPromotionDividendTrans struct {
	CompanyId        int64           `gorm:"column:company_id;not null;comment:公司id" json:"company_id"`
	AgentId          int64           `gorm:"column:agent_id;not null;comment:代理id" json:"agent_id"`
	OrderId          string          `gorm:"column:order_id;not null;comment:业务订单id" json:"order_id"`
	OrderAmount      decimal.Decimal `gorm:"column:order_amount;type:decimal(20,6);comment:订单金额" json:"order_amount"`
	OrderTime        int64           `gorm:"column:order_time;not null;comment:订单时间" json:"order_time"`
	CurrencyId       int32           `gorm:"column:currency_id;not null;comment:币种id" json:"currency_id"`
	Currency         string          `gorm:"column:currency;not null;comment:币种" json:"currency"`
	DividendMode     int32           `gorm:"column:dividend_mode;not null;default:0;comment:代理分红模式" json:"dividend_mode"`
	DividendPercent  int32           `gorm:"column:dividend_percent;not null;default:0;comment:代理分红比例" json:"dividend_percent"`
	DividendAmount   decimal.Decimal `gorm:"column:dividend_amount;type:decimal(20,6);comment:分摊金额" json:"dividend_amount"`
	CreateTime       int64           `gorm:"column:create_time;autoCreateTime;not null;comment:创建时间" json:"create_time"`
	PromotionId      int64           `gorm:"column:promotion_id;not null;comment:活动id" json:"promotion_id"`
	PromotionTitle   string          `gorm:"column:promotion_title;not null;comment:活动描述" json:"promotion_title"`
	PromotionInfo    datatypes.JSON  `gorm:"column:promotion_info;not null;comment:活动信息" json:"promotion_info"`
	DepositOrderInfo datatypes.JSON  `gorm:"column:deposit_order_info;not null;comment:入账信息" json:"deposit_order_info"`
	ProportionalInfo datatypes.JSON  `gorm:"column:proportional_info;not null;comment:分成信息" json:"proportional_info"`
}

func InitDB() *gorm.DB {
	db, err := gorm.Open(mysql.Open("admin:tRyf6U58C1EI@tcp(n5eisvl0q.cloud-app.celerdata.com:9030)/cash_sys?charset=utf8mb4&parseTime=true"),
		&gorm.Config{
			//SkipDefaultTransaction: true,
			//PrepareStmt:            true, // 开启改配置
		})
	//db.PrepareStmt = false

	if err != nil {
		panic("failed to connect database")
	}
	return db
}

func main() {

	db := InitDB()

	trans := []AgentPromotionDividendTrans{
		AgentPromotionDividendTrans{
			CompanyId:        1,
			AgentId:          1,
			OrderId:          "1",
			OrderAmount:      decimal.Decimal{},
			OrderTime:        0,
			CurrencyId:       0,
			Currency:         "",
			DividendMode:     0,
			DividendPercent:  0,
			DividendAmount:   decimal.Decimal{},
			CreateTime:       0,
			PromotionId:      0,
			PromotionTitle:   "",
			PromotionInfo:    nil,
			DepositOrderInfo: nil,
			ProportionalInfo: nil,
		},
		AgentPromotionDividendTrans{
			CompanyId:        1,
			AgentId:          1,
			OrderId:          "2",
			OrderAmount:      decimal.Decimal{},
			OrderTime:        0,
			CurrencyId:       0,
			Currency:         "",
			DividendMode:     0,
			DividendPercent:  0,
			DividendAmount:   decimal.Decimal{},
			CreateTime:       0,
			PromotionId:      0,
			PromotionTitle:   "",
			PromotionInfo:    nil,
			DepositOrderInfo: nil,
			ProportionalInfo: nil,
		},
	}
	sql, values := buildPromotionDividendTransInsertSql(trans)
	fmt.Printf("buildInsertSql sql(%+v), values(%+v)", sql, values)

	//buildSql()
	if err := db.Exec(sql, values).Error; err != nil {
		logx.Errorf("agentPromotionDividendTransOpr Create sql(%+v),values(%+v),err(%+v)", sql, values, err)
	}
}

func buildPromotionDividendTransInsertSql(trans []AgentPromotionDividendTrans) (sql string, args []interface{}) {
	// 构建SQL语句
	ib := sqlbuilder.NewInsertBuilder()
	ib.InsertInto("agent_promotion_dividend_trans")
	ib.Cols("company_id", "agent_id", "order_id",
		"order_amount", "order_time",
		"currency_id", "currency", "dividend_mode",
		"dividend_percent", "dividend_amount", "create_time", "promotion_id",
		"promotion_title", "promotion_info", "deposit_order_info", "proportional_info")

	for _, tran := range trans {
		ib.Values(tran.CompanyId, tran.AgentId, tran.OrderId,
			tran.OrderAmount, tran.OrderTime,
			tran.CurrencyId, tran.Currency, tran.DividendMode,
			tran.DividendPercent, tran.DividendAmount, tran.CreateTime, tran.PromotionId,
			tran.PromotionTitle, tran.PromotionInfo, tran.DepositOrderInfo, tran.ProportionalInfo)
	}
	return ib.Build()
}

func buildSql() {
	ib := sqlbuilder.NewInsertBuilder()
	ib.InsertInto("demo.user")
	ib.Cols("id", "name", "status", "created_at", "updated_at")
	ib.Values(1, "Huan Du", 1, sqlbuilder.Raw("UNIX_TIMESTAMP(NOW())"))
	ib.Values(2, "Charmy Liu", 1, 1234567890)

	sql, args := ib.Build()
	fmt.Println(sql)
	fmt.Println(args)
}
