-- 确认binlog是否开启
SHOW
VARIABLES LIKE 'log_bin';
-- 查看MySQL的binlog模式
show
global variables like "binlog_format%";

-- 检查复制状态(mysql8.0)
SHOW
REPLICA STATUS;

show
master status;

-- 检查正在运行的进程列表
SHOW
PROCESSLIST;

SHOW
REPLICAS;

-- 查看当前数据库的server_id
show
variables like "%server_id%";

show
variables like "%update%";

-- mysql8.0数据库添加用户和授权
create
user 'gva'@'%' identified by '123456';
grant all privileges on gva.* to
'gva'@'%' with grant option;
flush
privileges;


-- 创建数据库
CREATE
DATABASE app_db;

USE
app_db;

-- 创建 orders 表
CREATE TABLE `orders`
(
    `id`    INT            NOT NULL,
    `price` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (`id`)
);

-- 插入数据
INSERT INTO `orders` (`id`, `price`)
VALUES (1, 4.00);
INSERT INTO `orders` (`id`, `price`)
VALUES (2, 100.00);

-- 创建 shipments 表
CREATE TABLE `shipments`
(
    `id`   INT          NOT NULL,
    `city` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`)
);

-- 插入数据
INSERT INTO `shipments` (`id`, `city`)
VALUES (1, 'beijing');
INSERT INTO `shipments` (`id`, `city`)
VALUES (2, 'xian');

-- 创建 products 表
CREATE TABLE `products`
(
    `id`      INT          NOT NULL,
    `product` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`)
);

-- 插入数据
INSERT INTO `products` (`id`, `product`)
VALUES (1, 'Beer');
INSERT INTO `products` (`id`, `product`)
VALUES (2, 'Cap');
INSERT INTO `products` (`id`, `product`)
VALUES (3, 'Peanut');


INSERT INTO app_db.orders (id, price)
VALUES (3, 100.00);
INSERT INTO app_db.orders (id, price)
VALUES (4, 100.00);
INSERT INTO app_db.orders (id, price)
VALUES (5, 100.00);

INSERT INTO `shipments` (`id`, `city`)
VALUES (3, 'jinang');

INSERT INTO app_db.shipments (`id`, `city`)
VALUES (4, 'shanghai');

INSERT INTO app_db.shipments (`id`, `city`)
VALUES (5, 'shengzheng');


use
app_db;
drop table if exists `merchant`;
create table `merchant`
(
    `id`               bigint auto_increment,
    `merchant_id`       bigint      default 0  not null comment '商家ID',
    `merchant_name`     varchar(64) default '' not null comment '商家名称',
    `default_currency` varchar(32) default '' not null comment '默认币种',
    `support_currency` json        DEFAULT (json_array()) COMMENT '支持币种',
    `merchant_type`     tinyint     NOT NULL DEFAULT '0' COMMENT ' 商家类型 0自营 1加盟',
    `merchant_status`   tinyint     NOT NULL DEFAULT '0' COMMENT ' 0初始化 1启用 2异常 3停用',
    `merchant_avatar`  varchar(128) DEFAULT '' COMMENT '头像',
    `merchant_phone`   varchar(32)  DEFAULT '' COMMENT '手机号',
    `merchant_email`   varchar(64)  DEFAULT '' COMMENT '邮箱',
    `create_by`        varchar(64) DEFAULT NULL COMMENT '创建者',
    `update_by`        varchar(64) DEFAULT NULL COMMENT '更新者',
    `created_at`       datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`       datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`       datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
    unique `uniq_merchant_id` (`merchant_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = dynamic comment '商家基本信息表';

CREATE TABLE `merchant_sys_settings`
(
    `id`            bigint auto_increment,
    `merchant_id`    bigint       NOT NULL DEFAULT '0' COMMENT '商家id',
    `host`          varchar(128) NOT NULL DEFAULT '' COMMENT '访问域名',
    `port`          int          NOT NULL DEFAULT '80' COMMENT '端口',
    `user_type`     tinyint      NOT NULL DEFAULT '0' COMMENT '用户类型 类型 0会员 1代理 2商家',
    `platform_type` tinyint      NOT NULL DEFAULT '0' COMMENT '平台类型 类型 0-web 1-h5 2-app',
    `priority`      int          NOT NULL DEFAULT '0' COMMENT '优先级（0-100，优先级越大，使用几率越大）',
    `status`        tinyint      NOT NULL DEFAULT '0' COMMENT '状态 0停用 1启用',
    `create_by`     varchar(64)           DEFAULT NULL COMMENT '创建者',
    `update_by`     varchar(64)           DEFAULT NULL COMMENT '更新者',
    `created_at`    datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`    datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`    datetime(3) DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`),
    unique `uniq_merchant_host_port` (`merchant_id`,`host`,`port`)
) engine = InnoDB
  charset = utf8mb4
  row_format = dynamic comment '商家系统配置表';

create table `agent`
(
    `id`           bigint auto_increment,
    `merchant_id`   bigint      default 0  not null comment '商家ID',
    `agent_id`     bigint      default 0  not null comment '代理ID',
    `agent_name`   varchar(64) default '' not null comment '代理名称',
    `agent_type`   tinyint                NOT NULL DEFAULT '0' COMMENT ' 0商家默认代理 1商家直属代理 2商家下级代理',
    `agent_status` tinyint                NOT NULL DEFAULT '0' COMMENT ' 0初始化 1启用 2异常 3停用',
    `agent_avatar`  varchar(128) DEFAULT '' COMMENT '头像',
    `agent_phone`   varchar(32)  DEFAULT '' COMMENT '手机号',
    `agent_email`   varchar(64)  DEFAULT '' COMMENT '邮箱',
    `create_by`    varchar(64) DEFAULT NULL COMMENT '创建者',
    `update_by`    varchar(64) DEFAULT NULL COMMENT '更新者',
    `created_at`   datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`   datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`   datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
    unique `uniq_merchant_agent_id` (`merchant_id`,`agent_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = dynamic comment '代理基本信息表';

create table `member`
(
    `id`             bigint auto_increment,
    `tenant_id`     bigint       default 0  not null comment '租户ID',
    `member_id`      bigint       default 0  not null comment '会员ID',
    `member_name`    varchar(64)  default '' not null comment '会员名称',
    `member_gender`  tinyint      NOT NULL DEFAULT '0' COMMENT '会员性别 0-未知 1-男性 2-女性 ',
    `member_birthday`  datetime(3) DEFAULT NULL COMMENT '会员出生年月',
    `member_country`  varchar(32) DEFAULT NULL COMMENT '会员国籍',
    `member_region`  varchar(64) DEFAULT NULL COMMENT '会员地域',
    `member_address`  varchar(128) DEFAULT NULL COMMENT '会员地址',
    `member_type`    tinyint       NOT NULL DEFAULT '0' COMMENT '会员类型 1 正式 2 试用 ',
    `member_status`  tinyint       NOT NULL DEFAULT '0' COMMENT ' 0初始化 1启用 2异常 3停用',
    `member_avatar`  varchar(128) DEFAULT '' COMMENT '头像',
    `member_phone`   varchar(32)  DEFAULT '' COMMENT '手机号',
    `member_email`   varchar(64)  DEFAULT '' COMMENT '邮箱',
    `login_password` varchar(128) DEFAULT '' COMMENT '登录密码',
    `pay_password` varchar(128) DEFAULT '' COMMENT '支付密码',
    `create_by`      varchar(64)  DEFAULT NULL COMMENT '创建者',
    `update_by`      varchar(64)  DEFAULT NULL COMMENT '更新者',
    `created_at`     datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`     datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`     datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
    unique `uniq_tenant_member_id` (`tenant_id`,`member_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = dynamic comment '会员基本信息表';

create table `member_tag`
(
    `id`             bigint auto_increment,
    `tenant_id`     bigint       default 0  not null comment '租户ID',
    `tag_key`    varchar(32)  default '' not null comment '会员标签KEY',
    `tag_name`    varchar(64)  default '' not null comment '会员标签名称',
    `tag_remark`  varchar(128) DEFAULT NULL COMMENT '会员标签描述',
    `create_by`      varchar(64)  DEFAULT NULL COMMENT '创建者',
    `update_by`      varchar(64)  DEFAULT NULL COMMENT '更新者',
    `created_at`     datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`     datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`     datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
    unique `uniq_tenant_tag_key` (`tenant_id`,`tag_key`)
) engine = InnoDB
  charset = utf8mb4
  row_format = dynamic comment '会员标签表';

create table `member_group`
(
    `id`             bigint auto_increment,
    `tenant_id`     bigint       default 0  not null comment '租户ID',
    `group_key`    varchar(32)  default '' not null comment '会员组KEY',
    `group_name`    varchar(64)  default '' not null comment '会员组名称',
    `group_remark`  varchar(128) DEFAULT NULL COMMENT '会员组描述',
    `create_by`      varchar(64)  DEFAULT NULL COMMENT '创建者',
    `update_by`      varchar(64)  DEFAULT NULL COMMENT '更新者',
    `created_at`     datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`     datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`     datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
    unique `uniq_tenant_group_key` (`tenant_id`,`group_key`)
) engine = InnoDB
  charset = utf8mb4
  row_format = dynamic comment '会员分组表';

create table `member_tag_relation`
(
    `id`             bigint auto_increment,
    `tenant_id`     bigint       default 0  not null comment '租户ID',
    `member_id`      bigint       default 0  not null comment '会员ID',
    `tag_id`    bigint  default '' not null comment '会员标签ID',
    `tag_key`    varchar(32)  default '' not null comment '会员标签KEY',
    `tag_name`    varchar(64)  default '' not null comment '会员标签名称',
    `tag_remark`  varchar(128) DEFAULT NULL COMMENT '会员标签描述',
    `create_by`      varchar(64)  DEFAULT NULL COMMENT '创建者',
    `update_by`      varchar(64)  DEFAULT NULL COMMENT '更新者',
    `created_at`     datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`     datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`     datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
    unique `uniq_tenant_member_tag_id` (`tenant_id`,`member_id`,`tag_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = dynamic comment '会员与会员标签关系表';

create table `member_group_relation`
(
    `id`             bigint auto_increment,
    `tenant_id`     bigint       default 0  not null comment '租户ID',
    `member_id`      bigint       default 0  not null comment '会员ID',
    `group_id`    bigint  default '' not null comment '会员组ID',
    `group_key`    varchar(32)  default '' not null comment '会员组KEY',
    `group_name`    varchar(64)  default '' not null comment '会员组名称',
    `group_remark`  varchar(128) DEFAULT NULL COMMENT '会员组描述',
    `create_by`      varchar(64)  DEFAULT NULL COMMENT '创建者',
    `update_by`      varchar(64)  DEFAULT NULL COMMENT '更新者',
    `created_at`     datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`     datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`     datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
    unique `uniq_tenant_member_group_id` (`tenant_id`,`member_id`,`group_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = dynamic comment '会员与会员组关系表';


-- ----------------------------
-- 1、部门表
-- ----------------------------
create table sys_dept
(
    `id`          bigint auto_increment,
    `tenant_type` tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`   bigint           default 0 not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `dept_id`     bigint(20)      not null     comment '部门id',
    `parent_id`   bigint(20)      default 0                  comment '父部门id',
    `ancestors`   varchar(50)      default '' comment '祖级列表',
    `dept_name`   varchar(30)      default '' comment '部门名称',
    `order_num`   int(4)          default 0                  comment '显示顺序',
    `leader`      varchar(20)      default null comment '负责人',
    `phone`       varchar(11)      default null comment '联系电话',
    `email`       varchar(50)      default null comment '邮箱',
    `status`      char(1)          default '0' comment '部门状态（0正常 1停用）',
    `create_by`   varchar(64)      DEFAULT NULL COMMENT '创建者',
    `update_by`   varchar(64)      DEFAULT NULL COMMENT '更新者',
    `created_at`  datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`  datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`  datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
    unique `uniq_tenant_id_type_dept_id` (`tenant_id`,`tenant_type`,`dept_id`)
) engine=innodb auto_increment=200 comment = '部门表';

-- ----------------------------
-- 2、岗位表
-- ----------------------------
create table sys_post
(
    `id`          bigint auto_increment,
    `tenant_type` tinyint     NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`   bigint               default 0 not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `post_id`     bigint(20)      not null     comment '岗位ID',
    `post_code`   varchar(64) not null comment '岗位编码',
    `post_name`   varchar(50) not null comment '岗位名称',
    `post_sort`   int(4)          not null                   comment '显示顺序',
    `status`      char(1)     not null comment '状态（0正常 1停用）',
    `remark`      varchar(500)         default null comment '备注',
    `create_by`   varchar(64)          DEFAULT NULL COMMENT '创建者',
    `update_by`   varchar(64)          DEFAULT NULL COMMENT '更新者',
    `created_at`  datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`  datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`  datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
    unique `uniq_tenant_id_type_post_id` (`tenant_id`,`tenant_type`,`post_id`)
) engine=innodb comment = '岗位表';


-- ----------------------------
-- 2、用户表
-- ----------------------------
create table `sys_user`
(
    `id`               bigint auto_increment,
    `user_id`          bigint       default 0  not null comment '用户ID',
    `tenant_type`      tinyint                 NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`        bigint       default 0  not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `user_name`        varchar(64)  default '' not null comment '用户名称',
    `nick_name`        varchar(64)  default '' not null comment '用户昵称',
    `user_status`      tinyint                 NOT NULL DEFAULT '0' COMMENT ' 0初始化 1启用 2异常3停用',
    `user_avatar`      varchar(128) DEFAULT '' COMMENT '头像',
    `user_phone`       varchar(32)  DEFAULT '' COMMENT '手机号',
    `user_email`       varchar(64)  DEFAULT '' COMMENT '邮箱',
    `user_sex`         tinyint(2) NOT NULL DEFAULT 0 COMMENT '性别;0:保密,1:男,2:女',
    `user_birthday`    int(11) NOT NULL DEFAULT 0 COMMENT '生日',
    `dept_id`          bigint(20)  DEFAULT 0 COMMENT '部门id',
    `login_password`   varchar(128) DEFAULT '' COMMENT '登录密码',
    `process_password` varchar(128) DEFAULT '' COMMENT '操作密码',
    `create_by`        varchar(64)  DEFAULT NULL COMMENT '创建者',
    `update_by`        varchar(64)  DEFAULT NULL COMMENT '更新者',
    `created_at`       datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`       datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`       datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
    unique `uniq_tenant_id_type_user_id` (`user_id`,`tenant_type`,`tenant_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = dynamic comment '用户表';


-- ----------------------------
-- 用户与岗位关联表  用户1-N岗位
-- ----------------------------
create table sys_user_post
(
    `id`          bigint auto_increment,
    `tenant_type` tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`   bigint           default 0 not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `user_id`     bigint(20) not null comment '用户ID',
    `post_id`     bigint(20) not null comment '岗位ID',
    `create_by`   varchar(64)      DEFAULT NULL COMMENT '创建者',
    `update_by`   varchar(64)      DEFAULT NULL COMMENT '更新者',
    `created_at`  datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`  datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`  datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
    unique `uniq_post_user_id` (`user_id`,`post_id`)
) engine=innodb comment = '用户与岗位关联表';

-- ----------------------------
-- 角色表
-- ----------------------------
CREATE TABLE `sys_role`
(
    `id`          bigint  NOT NULL AUTO_INCREMENT,
    `tenant_type` tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`   bigint           default 0 not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `role_id`     bigint  NOT NULL COMMENT '角色ID',
    `role_name`   varchar(128)     DEFAULT NULL COMMENT '角色名称',
    `role_status` tinyint          DEFAULT NULL COMMENT '角色状态',
    `role_sort`   bigint           DEFAULT NULL COMMENT '角色序号',
    `role_remark` varchar(128)     DEFAULT NULL COMMENT '角色描述',
    `role_expire` datetime         DEFAULT NULL COMMENT '角色过期时间',
    `scope_type`  tinyint UNSIGNED NOT NULL DEFAULT 3 COMMENT '数据范围（1：全部 2：本部门 3：本部门及以下）',
    `create_by`   varchar(64)      DEFAULT NULL COMMENT '创建者',
    `update_by`   varchar(64)      DEFAULT NULL COMMENT '更新者',
    `created_at`  datetime         DEFAULT NULL COMMENT '创建时间',
    `updated_at`  datetime         DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`  datetime         DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '系统角色表';


-- ----------------------------
-- 系统资源表（菜单，按钮，API）
-- ----------------------------
CREATE TABLE `sys_resource`
(
    `id`                 bigint  NOT NULL AUTO_INCREMENT,
    `tenant_type`        tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`          bigint           default 0 not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `resource_id`        bigint  NOT NULL COMMENT '资源ID',
    `sys_module`         varchar(8)       DEFAULT NULL COMMENT '系统模块',
    `resource_type`      varchar(8)       DEFAULT NULL COMMENT '资源类型（MENU,BUTTON,API）',
    `parent_resource_id` smallint         DEFAULT NULL COMMENT '父资源ID',
    `name`               varchar(64)      DEFAULT NULL COMMENT '资源名称',
    `title`              varchar(64)      DEFAULT NULL COMMENT '资源标题',
    `icon`               varchar(128)     DEFAULT NULL COMMENT '资源图标',
    `path`               varchar(64)      DEFAULT NULL COMMENT '资源路径',
    `sort`               tinyint          DEFAULT NULL COMMENT '资源序号',
    `component`          varchar(128)     DEFAULT NULL COMMENT '资源组件',
    `status`             tinyint          DEFAULT NULL COMMENT '资源状态',
    `create_by`          varchar(64)      DEFAULT NULL COMMENT '创建者',
    `update_by`          varchar(64)      DEFAULT NULL COMMENT '更新者',
    `created_at`         datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`         datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`         datetime(3) DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 comment '系统资源表';

-- ----------------------------
-- 7、角色和系统资源关联表  角色1-N系统资源
-- ----------------------------
CREATE TABLE `sys_role_resource`
(
    `id`          bigint  NOT NULL AUTO_INCREMENT,
    `tenant_type` tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`   bigint           default 0 not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `role_id`     bigint  NOT NULL COMMENT '角色ID',
    `resource_id` bigint  NOT NULL COMMENT '资源ID',
    `create_by`   varchar(64)      DEFAULT NULL COMMENT '创建者',
    `update_by`   varchar(64)      DEFAULT NULL COMMENT '更新者',
    `created_at`  datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`  datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`  datetime(3) DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`),
    unique `uniq_role_resource_id` (`role_id`,`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '系统角色资源关联表';


-- ----------------------------
-- 8、角色和部门关联表  角色1-N部门
-- ----------------------------
create table sys_role_dept
(
    `id`          bigint  NOT NULL AUTO_INCREMENT,
    `tenant_type` tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`   bigint           default 0 not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `role_id`     bigint(20) not null comment '角色ID',
    `dept_id`     bigint(20) not null comment '部门ID',
    primary key (`id`)
) engine=innodb comment = '角色和部门关联表';


-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
create table sys_user_role
(
    `id`          bigint  NOT NULL AUTO_INCREMENT,
    `tenant_type` tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`   bigint           default 0 not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `user_id`     bigint(20) not null comment '用户ID',
    `role_id`     bigint(20) not null comment '角色ID',
    primary key (`id`)
) engine=innodb comment = '用户和角色关联表';


-- ----------------------------
-- 7、操作日志表
-- ----------------------------
CREATE TABLE `sys_operation_records`
(
    `id`             bigint  NOT NULL AUTO_INCREMENT,
    `tenant_type`    tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`      bigint           default 0 not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `user_id`        varchar(32)      default '' comment '操作用户ID',
    `sys_module`     varchar(8)       DEFAULT NULL COMMENT '系统模块',
    `biz_type`       varchar(8)       DEFAULT NULL COMMENT '业务类型',
    `ip`             varchar(32)      DEFAULT NULL COMMENT '请求ip',
    `method`         varchar(8)       DEFAULT NULL COMMENT '请求方法',
    `path`           varchar(128)     DEFAULT NULL COMMENT '请求路径',
    `status`         bigint           DEFAULT NULL COMMENT '请求状态',
    `latency`        bigint           DEFAULT NULL COMMENT '延迟',
    `operation_time` datetime(3) DEFAULT NULL COMMENT '操作时间',
    `error_message`  varchar(256)     DEFAULT NULL COMMENT '错误信息',
    `req_header`     text COMMENT '请求header',
    `req_body`       text COMMENT '请求Body',
    `resp_header`    text COMMENT '相应header',
    `resp_body`      text COMMENT '响应Body',
    `remark`         varchar(128)     DEFAULT NULL COMMENT '备注',
    `create_by`      varchar(64)      DEFAULT NULL COMMENT '创建者',
    `update_by`      varchar(64)      DEFAULT NULL COMMENT '更新者',
    `created_at`     datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`     datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`     datetime(3) DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 comment '系统操作记录表';

-- ----------------------------
-- 系统访问记录表
-- ----------------------------
create table sys_login_records
(
    `id`           bigint  NOT NULL AUTO_INCREMENT,
    `tenant_type`  tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`    bigint           default 0 not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `user_id`      varchar(64)      default '' comment '访问用户ID',
    `lip`          varchar(32)      default '' comment '登录IP地址',
    `location`     varchar(128)     default '' comment '登录地点',
    `browser`      varchar(64)      default '' comment '浏览器类型',
    `os`           varchar(64)      default '' comment '操作系统',
    `login_status` tinyint          default '0' comment '登录状态（0成功 1失败）',
    `login_time`   datetime comment '访问时间',
    `create_by`    varchar(64)      DEFAULT NULL COMMENT '创建者',
    `update_by`    varchar(64)      DEFAULT NULL COMMENT '更新者',
    `created_at`   datetime(3) DEFAULT NULL COMMENT '创建时间',
    `updated_at`   datetime(3) DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`   datetime(3) DEFAULT NULL COMMENT '删除时间',
    primary key (`id`),
) engine=innodb auto_increment=100 comment = '系统访问记录表';

-- ----------------------------
-- 通知公告表
-- ----------------------------
drop table if exists sys_notice;
create table sys_notice
(
    `id`             bigint                   NOT NULL AUTO_INCREMENT,
    `tenant_type`    tinyint                  NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
    `tenant_id`      bigint       default 0   not null comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
    `notice_id`      bigint                   not null comment '公告ID',
    `notice_title`   varchar(50)              not null comment '公告标题',
    `notice_type`    tinyint      default '0' not null comment '公告类型（1通知 2公告）',
    `notice_level`   tinyint      default '0' not null comment '公告等级（0默认，1提醒，2一般，3重要，4紧急）',
    `notice_content` longblob     default null comment '公告内容',
    `status`         tinyint      default '0' comment '公告状态（0正常 1关闭）',
    `remark`         varchar(128) DEFAULT NULL COMMENT '备注',
    `create_by`      varchar(64)  DEFAULT NULL COMMENT '创建者',
    `update_by`      varchar(64)  DEFAULT NULL COMMENT '更新者',
    `created_at`     datetime     DEFAULT NULL COMMENT '创建时间',
    `updated_at`     datetime     DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`     datetime     DEFAULT NULL COMMENT '删除时间',
    primary key (`id`)
) engine=innodb  DEFAULT CHARSET=utf8mb4 comment = '通知公告表';


CREATE TABLE `sys_casbin_rule`
(
    `id`    bigint NOT NULL AUTO_INCREMENT,
    `ptype` varchar(100) DEFAULT NULL,
    `v0`    varchar(100) DEFAULT NULL,
    `v1`    varchar(100) DEFAULT NULL,
    `v2`    varchar(100) DEFAULT NULL,
    `v3`    varchar(100) DEFAULT NULL,
    `v4`    varchar(100) DEFAULT NULL,
    `v5`    varchar(100) DEFAULT NULL,
    `v6`    varchar(25)  DEFAULT NULL,
    `v7`    varchar(25)  DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_sys_casbin_rule` (`ptype`,`v0`,`v1`,`v2`,`v3`,`v4`,`v5`,`v6`,`v7`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '系统用户权限规则表';


CREATE TABLE `account`
(
    `id`               bigint         NOT NULL AUTO_INCREMENT,
    `account_id`       bigint         NOT NULL COMMENT '账户ID',
    `account_name`     varchar(64) DEFAULT NULL COMMENT '账户名称',
    `owner_id`         bigint         NOT NULL COMMENT '账户所属者ID',
    `owner_type`       tinyint        NOT NULL COMMENT '账户所属者类型 0-平台 1-商家 2-代理 3-会员',
    `account_type`     int        NOT NULL COMMENT '账户类型 1-储蓄(不可透支) 2-信用(可透支) 3-归集( 31-支付渠道归集(收) 32-支付渠道归集(付))',
    `account_status`   tinyint        NOT NULL COMMENT '账户状态 0-初始化  1-激活 2-冻结 3-停用 4-注销',
    `account_currency` varchar(8)     NOT NULL COMMENT '账户币种',
    `account_balance`  DECIMAL(20, 8) NOT NULL COMMENT '账户余额（冻结金额+可用金额）',
    `freeze_amount`    DECIMAL(20, 8) NOT NULL COMMENT '冻结金额',
    `available_amount` DECIMAL(20, 8) NOT NULL COMMENT '可用金额',
    `create_by`        varchar(64) DEFAULT NULL COMMENT '创建者',
    `update_by`        varchar(64) DEFAULT NULL COMMENT '更新者',
    `created_at`       datetime    DEFAULT NULL COMMENT '创建时间',
    `updated_at`       datetime    DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`       datetime    DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '账户表';


CREATE TABLE `account_transaction`
(
    `id`                 bigint         NOT NULL AUTO_INCREMENT,
    `transaction_id`     varchar(64)             DEFAULT NULL COMMENT '交易号',
    `transaction_type`   tinyint        NOT NULL DEFAULT '0' COMMENT '交易类型 0-入金 ，1-出金，3-转账 4-冻结 5-解冻 6-退款 7-调账',
    `transaction_date`   datetime                DEFAULT NULL COMMENT '交易时间',
    `transaction_status` tinyint                 DEFAULT '0' COMMENT '交易状态 0-待处理，1-成功，2-失败，3-取消',
    `from_account_id`         bigint         NOT NULL COMMENT '交易账户ID',
    `to_account_id`         bigint         NOT NULL COMMENT '交易对手账户ID',
    `currency`           varchar(8)     NOT NULL COMMENT '交易币种',
    `amount`             DECIMAL(20, 8) NOT NULL COMMENT '交易金额',
    `remark`             varchar(64)    NOT NULL COMMENT '交易备注',
    `reference_order_id`       varchar(64)             DEFAULT NULL COMMENT '支付订单号',
    `reason`             varchar(128)            DEFAULT NULL COMMENT '原因',
    `create_by`          varchar(64)             DEFAULT NULL COMMENT '创建者',
    `update_by`          varchar(64)             DEFAULT NULL COMMENT '更新者',
    `created_at`         datetime                DEFAULT NULL COMMENT '创建时间',
    `updated_at`         datetime                DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`         datetime                DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`),
    unique `uniq_transaction_id_type` (`transaction_id`,`transaction_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '账户流水表';


CREATE TABLE `pay_channel`
(
    `id`                 bigint         NOT NULL AUTO_INCREMENT,
    `merchant_id`      bigint       default 0   not null comment '商户ID',
    `channel_id`       bigint         NOT NULL COMMENT '支付渠道ID',
    `channel_name`     varchar(64)    NOT NULL COMMENT '支付渠道名称',
    `channel_avatar`      varchar(128) DEFAULT '' COMMENT '支付渠道头像',
    `support_currency` json        DEFAULT (json_array()) COMMENT '支持币种',
    `support_pay_mode` json        DEFAULT (json_array()) COMMENT '支持支付模式(储蓄卡，信用卡，收款码，TRC32)',
    `channel_status` tinyint       DEFAULT '0' COMMENT '支付渠道状态 0-初始化，1-激活，2-暂停，3-停用',
    `channel_phone`       varchar(32)  DEFAULT '' COMMENT '支付渠道手机号',
    `channel_email`       varchar(64)  DEFAULT '' COMMENT '支付渠道邮箱',
    `remark`             varchar(128)    NOT NULL COMMENT '交易备注',
    `create_by`          varchar(64)             DEFAULT NULL COMMENT '创建者',
    `update_by`          varchar(64)             DEFAULT NULL COMMENT '更新者',
    `created_at`         datetime                DEFAULT NULL COMMENT '创建时间',
    `updated_at`         datetime                DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`         datetime                DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`),
    unique `uniq_merchant_channel_id` (`merchant_id`,`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '商户支付渠道表';


CREATE TABLE `pay_channel_params`
(
    `id`             bigint         NOT NULL AUTO_INCREMENT,
    `merchant_id`      bigint       default 0   not null comment '商户ID',
    `channel_id`       bigint         NOT NULL COMMENT '支付渠道ID',
    `mch_id`             varchar(64)    NOT NULL COMMENT '支付渠道mch_id',
    `app_id`             varchar(64)    NOT NULL COMMENT '支付渠道app_id',
    `app_secret_key`             varchar(128)    NOT NULL COMMENT '支付渠道app_secret',
    `api_public_key`             varchar(2048)    NOT NULL COMMENT '支付渠道api证书公钥',
    `api_private_key`             varchar(2048)    NOT NULL COMMENT '支付渠道api证书私钥',
    `base_pay_url`             varchar(128)    NOT NULL COMMENT '支付链接',
    `base_notify_url`    varchar(128)    NOT NULL COMMENT '支付回调链接(path参数中附带商户id和渠道id和订单id)',
    `remark`             varchar(128)    NOT NULL COMMENT '备注',
    `create_by`          varchar(64)             DEFAULT NULL COMMENT '创建者',
    `update_by`          varchar(64)             DEFAULT NULL COMMENT '更新者',
    `created_at`         datetime                DEFAULT NULL COMMENT '创建时间',
    `updated_at`         datetime                DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`         datetime                DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`),
    unique `uniq_merchant_channel_pay_mode_currency` (`merchant_id`,`channel_id`,`pay_mode`,`currency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '商户支付渠道参数表';



CREATE TABLE `pay_channel_limit`
(
    `id`             bigint         NOT NULL AUTO_INCREMENT,
    `merchant_id`      bigint       default 0   not null comment '商户ID',
    `channel_id`       bigint         NOT NULL COMMENT '支付渠道ID',
    `pay_mode`         varchar(8)     NOT NULL COMMENT '支付模式',
    `currency`         varchar(8)     NOT NULL COMMENT '币种',
    `cycle`     int    default 0   not null comment '限制周期（0-不限制，1-每天，2-每月，3-每年）',
    `deposit_amount`     decimal(20,8)  NOT NULL COMMENT '限制周期内的充值限额',
    `withdraw_amount`     decimal(20,8)  NOT NULL COMMENT '限制周期内的提款限额',
    `order_deposit_amount`     decimal(20,8)  NOT NULL COMMENT '单笔充值限额',
    `order_withdraw_amount`     decimal(20,8)  NOT NULL COMMENT '单笔提款限额',
    `remark`             varchar(128)    NOT NULL COMMENT '备注',
    `limit_status` tinyint       DEFAULT '0' COMMENT '支付限额状态 0-初始化，1-激活，2-暂停，3-停用',
    `create_by`          varchar(64)             DEFAULT NULL COMMENT '创建者',
    `update_by`          varchar(64)             DEFAULT NULL COMMENT '更新者',
    `created_at`         datetime                DEFAULT NULL COMMENT '创建时间',
    `updated_at`         datetime                DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`         datetime                DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`),
    unique `uniq_merchant_channel_pay_mode_currency` (`merchant_id`,`channel_id`,`pay_mode`,`currency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '商户支付渠道限额表';




CREATE TABLE `pay_order`
(
    `id`                 bigint         NOT NULL AUTO_INCREMENT,
    `order_id`     varchar(64)             DEFAULT NULL COMMENT '订单号',
    `order_type`   tinyint        NOT NULL DEFAULT '0' COMMENT '订单类型 0-充值，1-提款，2-退款',
    `order_date`   datetime                DEFAULT NULL COMMENT '订单时间',
    `order_status` tinyint                 DEFAULT '0' COMMENT '订单状态 0-待处理，1-成功，2-失败，3-手动取消，4-超时取消',
    `account_owner_id`         bigint         NOT NULL COMMENT '账户所属者ID',
    `account_id`       bigint         NOT NULL COMMENT '账户ID',
    `currency`           varchar(8)     NOT NULL COMMENT '交易币种',
    `amount`             DECIMAL(20, 8) NOT NULL COMMENT '交易金额',
    `remark`             varchar(64)    NOT NULL COMMENT '交易备注',
    `merchant_id`      bigint       default 0   not null comment '商户ID',
    `pay_channel_id`     bigint             DEFAULT NULL COMMENT '支付渠道ID',
    `reference_id`       varchar(64)             DEFAULT NULL COMMENT '参考交易号',
    `pay_url`            varchar(256)            DEFAULT NULL COMMENT '支付链接',
    `channel_result` varchar(256)            DEFAULT NULL COMMENT '创建支付链接支付渠道返回结果',
    `order_expired_at` datetime               DEFAULT NULL COMMENT '订单过期时间',
    `create_by`          varchar(64)             DEFAULT NULL COMMENT '创建者',
    `update_by`          varchar(64)             DEFAULT NULL COMMENT '更新者',
    `created_at`         datetime                DEFAULT NULL COMMENT '创建时间',
    `updated_at`         datetime                DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`         datetime                DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`),
    unique `uniq_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '支付订单表';

CREATE TABLE `pay_order_notify`
(
    `id`                 bigint         NOT NULL AUTO_INCREMENT,
    `merchant_id`      bigint       default 0   not null comment '商户ID',
    `pay_channel_id`     bigint             DEFAULT NULL COMMENT '支付渠道ID',
    `order_id`     varchar(64)             DEFAULT NULL COMMENT '订单号',
    `notify_date`   datetime                DEFAULT NULL COMMENT '回调时间',
    `notify_url`           varchar(128)     NOT NULL COMMENT '回调url',
    `notify_body`             varchar(1024) NOT NULL COMMENT '回调结果体',
    `notify_result` varchar(1024)            DEFAULT NULL COMMENT '回调结果',
    `remark`             varchar(64)    NOT NULL COMMENT '备注',
    `create_by`          varchar(64)             DEFAULT NULL COMMENT '创建者',
    `update_by`          varchar(64)             DEFAULT NULL COMMENT '更新者',
    `created_at`         datetime                DEFAULT NULL COMMENT '创建时间',
    `updated_at`         datetime                DEFAULT NULL COMMENT '最后更新时间',
    `deleted_at`         datetime                DEFAULT NULL COMMENT '删除时间',
    PRIMARY KEY (`id`),
    unique `uniq_merchant_channel_order_id` (`merchant_id`,`pay_channel_id`,`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '支付订单回调结果表';

