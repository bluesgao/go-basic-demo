#### 案例1
curl -H "Content-type: application/json" -X POST -d '{"name":"q1mi","age":18,"email":"123.com","birthday":"2025-01-02"}' http://127.0.0.1:8999/signup

{"msg":"Key: 'SignUpParam.Email' Error:Field validation for 'Email' failed on the 'email' tag\nKey: 'SignUpParam.Password' Error:Field validation for 'Password' failed on the 'required' tag\nKey: 'SignUpParam.RePassword' Error:Field validation for 'RePassword' failed on the 'required' tag"}

{"msg":{"SignUpParam.Email":"Email必须是一个有效的邮箱","SignUpParam.Password":"Password为必填字段","SignUpParam.RePassword":"RePassword为必填字段"}}

#### 案例2 日期字符串验证
curl -H "Content-type: application/json" -X POST -d '{"name":"q1mi","age":18,"email":"gg@126.com","password":"gg@126.com","re_password":"gg@126.com","birthday":"2035-01-02"}' http://127.0.0.1:8999/signup

curl -H "Content-type: application/json" -X POST -d '{"name":"q1mi","age":18,"email":"gg@126.com","password":"gg@126.com","re_password":"gg@126.com","birthday":"2035-13-02"}' http://127.0.0.1:8999/signup
{"msg":{"SignUpParam.Birthday":"Birthday的格式必须是2006-01-02"}}

#### 案例3 密码验证
curl -H "Content-type: application/json" -X POST -d '{"name":"q1mi","age":18,"email":"gg@126.com","password":"gg@126.com","re_password"
:"gg@126.c","birthday":"2035-01-22"}' http://127.0.0.1:8999/signup
{"msg":{"SignUpParam.RePassword":"RePassword必须等于Password"}}%     

