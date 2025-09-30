-- 确认binlog是否开启
SHOW
VARIABLES LIKE 'log_bin';
-- 查看MySQL的binlog模式
show
GLOBAL variables LIKE "binlog_format%";

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
variables LIKE "%server_id%";

show
variables LIKE "%update%";

-- mysql8.0数据库添加用户和授权
CREATE
USER 'gva'@'%' identified BY '123456';
GRANT ALL PRIVILEGES ON gva.* TO
'gva'@'%' WITH GRANT OPTION;
flush
PRIVILEGES;


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
DROP TABLE if EXISTS `merchant`;
CREATE TABLE `merchant`
(
  `id`               bigint auto_increment,
  `merchant_id`      bigint       DEFAULT 0  NOT NULL comment '商家ID',
  `merchant_name`    varchar(64)  DEFAULT '' NOT NULL comment '商家名称',
  `default_currency` varchar(32)  DEFAULT '' NOT NULL comment '默认币种',
  `support_currency` json         DEFAULT (json_array()) COMMENT '支持币种',
  `merchant_type`    tinyint                 NOT NULL DEFAULT '0' COMMENT ' 商家类型 0自营 1加盟',
  `merchant_status`  tinyint                 NOT NULL DEFAULT '0' COMMENT ' 0初始化 1启用 2异常 3停用',
  `merchant_avatar`  varchar(128) DEFAULT '' COMMENT '头像',
  `merchant_phone`   varchar(32)  DEFAULT '' COMMENT '手机号',
  `merchant_email`   varchar(64)  DEFAULT '' COMMENT '邮箱',
  `create_by`        varchar(64)  DEFAULT NULL COMMENT '创建者',
  `update_by`        varchar(64)  DEFAULT NULL COMMENT '更新者',
  `created_at`       datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`       datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`       datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_merchant_id` (`merchant_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '商家基本信息表';

CREATE TABLE `merchant_sys_settings`
(
  `id`            bigint auto_increment,
  `merchant_id`   bigint       NOT NULL DEFAULT '0' COMMENT '商家id',
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
  UNIQUE `uniq_merchant_host_port` (`merchant_id`,`host`,`port`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '商家系统配置表';

CREATE TABLE `agent`
(
  `id`           bigint auto_increment,
  `merchant_id`  bigint       DEFAULT 0  NOT NULL comment '商家ID',
  `agent_id`     bigint       DEFAULT 0  NOT NULL comment '代理ID',
  `agent_name`   varchar(64)  DEFAULT '' NOT NULL comment '代理名称',
  `agent_type`   tinyint                 NOT NULL DEFAULT '0' COMMENT ' 0商家默认代理 1商家直属代理 2商家下级代理',
  `agent_status` tinyint                 NOT NULL DEFAULT '0' COMMENT ' 0初始化 1启用 2异常 3停用',
  `agent_avatar` varchar(128) DEFAULT '' COMMENT '头像',
  `agent_phone`  varchar(32)  DEFAULT '' COMMENT '手机号',
  `agent_email`  varchar(64)  DEFAULT '' COMMENT '邮箱',
  `create_by`    varchar(64)  DEFAULT NULL COMMENT '创建者',
  `update_by`    varchar(64)  DEFAULT NULL COMMENT '更新者',
  `created_at`   datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`   datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`   datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_merchant_agent_id` (`merchant_id`,`agent_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '代理基本信息表';

CREATE TABLE `member`
(
  `id`              bigint auto_increment,
  `tenant_id`       bigint           DEFAULT 0 NOT NULL comment '租户ID',
  `member_id`       bigint           DEFAULT 0 NOT NULL comment '会员ID',
  `member_name`     varchar(64)      DEFAULT '' NOT NULL comment '会员名称',
  `member_gender`   tinyint NOT NULL DEFAULT '0' COMMENT '会员性别 0-未知 1-男性 2-女性 ',
  `member_birthday` datetime(3) DEFAULT NULL COMMENT '会员出生年月',
  `member_country`  varchar(32)      DEFAULT NULL COMMENT '会员国籍',
  `member_region`   varchar(64)      DEFAULT NULL COMMENT '会员地域',
  `member_address`  varchar(128)     DEFAULT NULL COMMENT '会员地址',
  `member_type`     tinyint NOT NULL DEFAULT '0' COMMENT '会员类型 1 正式 2 试用 ',
  `member_status`   tinyint NOT NULL DEFAULT '0' COMMENT ' 0初始化 1启用 2异常 3停用',
  `member_avatar`   varchar(128)     DEFAULT '' COMMENT '头像',
  `member_phone`    varchar(32)      DEFAULT '' COMMENT '手机号',
  `member_email`    varchar(64)      DEFAULT '' COMMENT '邮箱',
  `login_password`  varchar(128)     DEFAULT '' COMMENT '登录密码',
  `pay_password`    varchar(128)     DEFAULT '' COMMENT '支付密码',
  `create_by`       varchar(64)      DEFAULT NULL COMMENT '创建者',
  `update_by`       varchar(64)      DEFAULT NULL COMMENT '更新者',
  `created_at`      datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`      datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`      datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_member_id` (`tenant_id`,`member_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '会员基本信息表';

CREATE TABLE `member_level`
(
  `id`           bigint auto_increment,
  `tenant_id`    bigint       DEFAULT 0 NOT NULL comment '租户ID',
  `level`        int          DEFAULT 0 NOT NULL comment '会员等级',
  `level_avatar` varchar(128) DEFAULT '' COMMENT '等级图标',
  `point`        int          DEFAULT 0 NOT NULL comment '达到等级的分数',
  `remark`       varchar(128) DEFAULT NULL COMMENT '描述',
  `create_by`    varchar(64)  DEFAULT NULL COMMENT '创建者',
  `update_by`    varchar(64)  DEFAULT NULL COMMENT '更新者',
  `created_at`   datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`   datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`   datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_level_id` (`tenant_id`,`level`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '会员等级表';


CREATE TABLE `member_tag`
(
  `id`         bigint auto_increment,
  `tenant_id`  bigint       DEFAULT 0  NOT NULL comment '租户ID',
  `tag_key`    varchar(32)  DEFAULT '' NOT NULL comment '会员标签KEY',
  `tag_name`   varchar(64)  DEFAULT '' NOT NULL comment '会员标签名称',
  `tag_remark` varchar(128) DEFAULT NULL COMMENT '会员标签描述',
  `create_by`  varchar(64)  DEFAULT NULL COMMENT '创建者',
  `update_by`  varchar(64)  DEFAULT NULL COMMENT '更新者',
  `created_at` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at` datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_tag_key` (`tenant_id`,`tag_key`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '会员标签表';

CREATE TABLE `member_group`
(
  `id`           bigint auto_increment,
  `tenant_id`    bigint       DEFAULT 0  NOT NULL comment '租户ID',
  `group_key`    varchar(32)  DEFAULT '' NOT NULL comment '会员组KEY',
  `group_name`   varchar(64)  DEFAULT '' NOT NULL comment '会员组名称',
  `group_remark` varchar(128) DEFAULT NULL COMMENT '会员组描述',
  `create_by`    varchar(64)  DEFAULT NULL COMMENT '创建者',
  `update_by`    varchar(64)  DEFAULT NULL COMMENT '更新者',
  `created_at`   datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`   datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`   datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_group_key` (`tenant_id`,`group_key`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '会员分组表';


CREATE TABLE `member_point`
(
  `id`         bigint auto_increment,
  `tenant_id`  bigint      DEFAULT 0 NOT NULL comment '租户ID',
  `member_id`  bigint      DEFAULT 0 NOT NULL comment '会员ID',
  `point`      int         DEFAULT 0 NOT NULL comment '会员积分',
  `create_by`  varchar(64) DEFAULT NULL COMMENT '创建者',
  `update_by`  varchar(64) DEFAULT NULL COMMENT '更新者',
  `created_at` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at` datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_member_id` (`tenant_id`,`member_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '会员积分表';

CREATE TABLE `member_point_record`
(
  `id`           bigint auto_increment,
  `tenant_id`    bigint       DEFAULT 0 NOT NULL comment '租户ID',
  `member_id`    bigint       DEFAULT 0 NOT NULL comment '会员ID',
  `biz_type`     int          DEFAULT 0 NOT NULL comment '业务类型',
  `biz_id`       bigint       DEFAULT 0 NOT NULL comment '业务ID',
  `reward_point` int          DEFAULT 0 NOT NULL comment '奖励积分',
  `remark`       varchar(128) DEFAULT NULL COMMENT '描述',
  `create_by`    varchar(64)  DEFAULT NULL COMMENT '创建者',
  `update_by`    varchar(64)  DEFAULT NULL COMMENT '更新者',
  `created_at`   datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`   datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`   datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_member_id` (`tenant_id`,`member_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '会员积分变更记录表';

CREATE TABLE `member_level_relation`
(
  `id`         bigint auto_increment,
  `tenant_id`  bigint      DEFAULT 0  NOT NULL comment '租户ID',
  `member_id`  bigint      DEFAULT 0  NOT NULL comment '会员ID',
  `level_id`   bigint      DEFAULT '' NOT NULL comment '会员等级ID',
  `create_by`  varchar(64) DEFAULT NULL COMMENT '创建者',
  `update_by`  varchar(64) DEFAULT NULL COMMENT '更新者',
  `created_at` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at` datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_member_tag_id` (`tenant_id`,`member_id`,`tag_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '会员与会员等级关系表';

CREATE TABLE `member_tag_relation`
(
  `id`         bigint auto_increment,
  `tenant_id`  bigint       DEFAULT 0  NOT NULL comment '租户ID',
  `member_id`  bigint       DEFAULT 0  NOT NULL comment '会员ID',
  `tag_id`     bigint       DEFAULT '' NOT NULL comment '会员标签ID',
  `tag_key`    varchar(32)  DEFAULT '' NOT NULL comment '会员标签KEY',
  `tag_name`   varchar(64)  DEFAULT '' NOT NULL comment '会员标签名称',
  `tag_remark` varchar(128) DEFAULT NULL COMMENT '会员标签描述',
  `create_by`  varchar(64)  DEFAULT NULL COMMENT '创建者',
  `update_by`  varchar(64)  DEFAULT NULL COMMENT '更新者',
  `created_at` datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at` datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_member_tag_id` (`tenant_id`,`member_id`,`tag_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '会员与会员标签关系表';

CREATE TABLE `member_group_relation`
(
  `id`           bigint auto_increment,
  `tenant_id`    bigint       DEFAULT 0  NOT NULL comment '租户ID',
  `member_id`    bigint       DEFAULT 0  NOT NULL comment '会员ID',
  `group_id`     bigint       DEFAULT '' NOT NULL comment '会员组ID',
  `group_key`    varchar(32)  DEFAULT '' NOT NULL comment '会员组KEY',
  `group_name`   varchar(64)  DEFAULT '' NOT NULL comment '会员组名称',
  `group_remark` varchar(128) DEFAULT NULL COMMENT '会员组描述',
  `create_by`    varchar(64)  DEFAULT NULL COMMENT '创建者',
  `update_by`    varchar(64)  DEFAULT NULL COMMENT '更新者',
  `created_at`   datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`   datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`   datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_member_group_id` (`tenant_id`,`member_id`,`group_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '会员与会员组关系表';


-- ----------------------------
-- 1、部门表
-- ----------------------------
CREATE TABLE sys_dept
(
  `id`          bigint auto_increment,
  `tenant_type` tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
  `tenant_id`   bigint           DEFAULT 0 NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
  `dept_id`     bigint(20)      NOT NULL     comment '部门id',
  `parent_id`   bigint(20)      DEFAULT 0                  comment '父部门id',
  `ancestors`   varchar(50)      DEFAULT '' comment '祖级列表',
  `dept_name`   varchar(30)      DEFAULT '' comment '部门名称',
  `order_num`   int(4)          DEFAULT 0                  comment '显示顺序',
  `leader`      varchar(20)      DEFAULT NULL comment '负责人',
  `phone`       varchar(11)      DEFAULT NULL comment '联系电话',
  `email`       varchar(50)      DEFAULT NULL comment '邮箱',
  `status`      char(1)          DEFAULT '0' comment '部门状态（0正常 1停用）',
  `create_by`   varchar(64)      DEFAULT NULL COMMENT '创建者',
  `update_by`   varchar(64)      DEFAULT NULL COMMENT '更新者',
  `created_at`  datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`  datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`  datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_id_type_dept_id` (`tenant_id`,`tenant_type`,`dept_id`)
) engine=innodb auto_increment=200 comment = '部门表';

-- ----------------------------
-- 2、岗位表
-- ----------------------------
CREATE TABLE sys_post
(
  `id`          bigint auto_increment,
  `tenant_type` tinyint     NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
  `tenant_id`   bigint               DEFAULT 0 NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
  `post_id`     bigint(20)      NOT NULL     comment '岗位ID',
  `post_code`   varchar(64) NOT NULL comment '岗位编码',
  `post_name`   varchar(50) NOT NULL comment '岗位名称',
  `post_sort`   int(4)          NOT NULL                   comment '显示顺序',
  `status`      char(1)     NOT NULL comment '状态（0正常 1停用）',
  `remark`      varchar(500)         DEFAULT NULL comment '备注',
  `create_by`   varchar(64)          DEFAULT NULL COMMENT '创建者',
  `update_by`   varchar(64)          DEFAULT NULL COMMENT '更新者',
  `created_at`  datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`  datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`  datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_id_type_post_id` (`tenant_id`,`tenant_type`,`post_id`)
) engine=innodb comment = '岗位表';


-- ----------------------------
-- 2、用户表
-- ----------------------------
CREATE TABLE `sys_user`
(
  `id`               bigint auto_increment,
  `user_id`          bigint       DEFAULT 0  NOT NULL comment '用户ID',
  `tenant_type`      tinyint                 NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
  `tenant_id`        bigint       DEFAULT 0  NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
  `user_name`        varchar(64)  DEFAULT '' NOT NULL comment '用户名称',
  `nick_name`        varchar(64)  DEFAULT '' NOT NULL comment '用户昵称',
  `user_status`      int                     NOT NULL DEFAULT '0' COMMENT ' 0初始化 1启用 2异常3停用',
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
  PRIMARY KEY (`id`),
  UNIQUE `uniq_tenant_id_type_user_id` (`user_id`,`tenant_type`,`tenant_id`)
) engine = InnoDB
  charset = utf8mb4
  row_format = DYNAMIC comment '用户表';


-- ----------------------------
-- 用户与岗位关联表  用户1-N岗位
-- ----------------------------
CREATE TABLE sys_user_post
(
  `id`          bigint auto_increment,
  `tenant_type` tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
  `tenant_id`   bigint           DEFAULT 0 NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
  `user_id`     bigint(20) NOT NULL comment '用户ID',
  `post_id`     bigint(20) NOT NULL comment '岗位ID',
  `create_by`   varchar(64)      DEFAULT NULL COMMENT '创建者',
  `update_by`   varchar(64)      DEFAULT NULL COMMENT '更新者',
  `created_at`  datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`  datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`  datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_post_user_id` (`user_id`,`post_id`)
) engine=innodb comment = '用户与岗位关联表';

-- ----------------------------
-- 角色表
-- ----------------------------
CREATE TABLE `sys_role`
(
  `id`          bigint  NOT NULL AUTO_INCREMENT,
  `tenant_type` tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
  `tenant_id`   bigint           DEFAULT 0 NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
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
  `tenant_id`          bigint           DEFAULT 0 NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
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
  `tenant_id`   bigint           DEFAULT 0 NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
  `role_id`     bigint  NOT NULL COMMENT '角色ID',
  `resource_id` bigint  NOT NULL COMMENT '资源ID',
  `create_by`   varchar(64)      DEFAULT NULL COMMENT '创建者',
  `update_by`   varchar(64)      DEFAULT NULL COMMENT '更新者',
  `created_at`  datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`  datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`  datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_role_resource_id` (`role_id`,`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '系统角色资源关联表';


-- ----------------------------
-- 8、角色和部门关联表  角色1-N部门
-- ----------------------------
CREATE TABLE sys_role_dept
(
  `id`          bigint  NOT NULL AUTO_INCREMENT,
  `tenant_type` tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
  `tenant_id`   bigint           DEFAULT 0 NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
  `role_id`     bigint(20) NOT NULL comment '角色ID',
  `dept_id`     bigint(20) NOT NULL comment '部门ID',
  PRIMARY KEY (`id`)
) engine=innodb comment = '角色和部门关联表';


-- ----------------------------
-- 6、用户和角色关联表  用户N-1角色
-- ----------------------------
CREATE TABLE sys_user_role
(
  `id`          bigint  NOT NULL AUTO_INCREMENT,
  `tenant_type` tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
  `tenant_id`   bigint           DEFAULT 0 NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
  `user_id`     bigint(20) NOT NULL comment '用户ID',
  `role_id`     bigint(20) NOT NULL comment '角色ID',
  PRIMARY KEY (`id`)
) engine=innodb comment = '用户和角色关联表';


-- ----------------------------
-- 7、操作日志表
-- ----------------------------
CREATE TABLE `sys_operation_records`
(
  `id`             bigint  NOT NULL AUTO_INCREMENT,
  `tenant_type`    tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
  `tenant_id`      bigint           DEFAULT 0 NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
  `user_id`        varchar(32)      DEFAULT '' comment '操作用户ID',
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
CREATE TABLE sys_login_records
(
  `id`           bigint  NOT NULL AUTO_INCREMENT,
  `tenant_type`  tinyint NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
  `tenant_id`    bigint           DEFAULT 0 NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
  `user_id`      varchar(64)      DEFAULT '' comment '访问用户ID',
  `lip`          varchar(32)      DEFAULT '' comment '登录IP地址',
  `location`     varchar(128)     DEFAULT '' comment '登录地点',
  `browser`      varchar(64)      DEFAULT '' comment '浏览器类型',
  `os`           varchar(64)      DEFAULT '' comment '操作系统',
  `login_status` tinyint          DEFAULT '0' comment '登录状态（0成功 1失败）',
  `login_time`   datetime comment '访问时间',
  `create_by`    varchar(64)      DEFAULT NULL COMMENT '创建者',
  `update_by`    varchar(64)      DEFAULT NULL COMMENT '更新者',
  `created_at`   datetime(3) DEFAULT NULL COMMENT '创建时间',
  `updated_at`   datetime(3) DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`   datetime(3) DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
) engine=innodb auto_increment=100 comment = '系统访问记录表';

-- ----------------------------
-- 通知公告表
-- ----------------------------
DROP TABLE if EXISTS sys_notice;
CREATE TABLE sys_notice
(
  `id`             bigint                   NOT NULL AUTO_INCREMENT,
  `tenant_type`    tinyint                  NOT NULL DEFAULT '0' COMMENT '租户类型 1-平台  2-商家 3-代理 ',
  `tenant_id`      bigint       DEFAULT 0   NOT NULL comment '租户ID （类型1-0，租户类型1-merchantId，租户类型3-agentId）',
  `notice_id`      bigint                   NOT NULL comment '公告ID',
  `notice_title`   varchar(50)              NOT NULL comment '公告标题',
  `notice_type`    tinyint      DEFAULT '0' NOT NULL comment '公告类型（1通知 2公告）',
  `notice_level`   tinyint      DEFAULT '0' NOT NULL comment '公告等级（0默认，1提醒，2一般，3重要，4紧急）',
  `notice_content` longblob     DEFAULT NULL comment '公告内容',
  `status`         tinyint      DEFAULT '0' comment '公告状态（0正常 1关闭）',
  `remark`         varchar(128) DEFAULT NULL COMMENT '备注',
  `create_by`      varchar(64)  DEFAULT NULL COMMENT '创建者',
  `update_by`      varchar(64)  DEFAULT NULL COMMENT '更新者',
  `created_at`     datetime     DEFAULT NULL COMMENT '创建时间',
  `updated_at`     datetime     DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`     datetime     DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`)
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
  `account_type`     int            NOT NULL COMMENT '账户类型 1-储蓄(不可透支) 2-信用(可透支) 3-归集( 31-支付渠道归集(收) 32-支付渠道归集(付))',
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
  `from_account_id`    bigint         NOT NULL COMMENT '交易账户ID',
  `to_account_id`      bigint         NOT NULL COMMENT '交易对手账户ID',
  `currency`           varchar(8)     NOT NULL COMMENT '交易币种',
  `amount`             DECIMAL(20, 8) NOT NULL COMMENT '交易金额',
  `remark`             varchar(64)    NOT NULL COMMENT '交易备注',
  `reference_order_id` varchar(64)             DEFAULT NULL COMMENT '支付订单号',
  `reason`             varchar(128)            DEFAULT NULL COMMENT '原因',
  `create_by`          varchar(64)             DEFAULT NULL COMMENT '创建者',
  `update_by`          varchar(64)             DEFAULT NULL COMMENT '更新者',
  `created_at`         datetime                DEFAULT NULL COMMENT '创建时间',
  `updated_at`         datetime                DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`         datetime                DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_transaction_id_type` (`transaction_id`,`transaction_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '账户流水表';


CREATE TABLE `pay_channel`
(
  `id`               bigint                 NOT NULL AUTO_INCREMENT,
  `merchant_id`      bigint       DEFAULT 0 NOT NULL comment '商户ID',
  `channel_id`       bigint                 NOT NULL COMMENT '支付渠道ID',
  `channel_name`     varchar(64)            NOT NULL COMMENT '支付渠道名称',
  `channel_avatar`   varchar(128) DEFAULT '' COMMENT '支付渠道头像',
  `support_currency` json         DEFAULT (json_array()) COMMENT '支持币种',
  `support_pay_mode` json         DEFAULT (json_array()) COMMENT '支持支付模式(储蓄卡，信用卡，收款码，TRC32)',
  `channel_status`   tinyint      DEFAULT '0' COMMENT '支付渠道状态 0-初始化，1-激活，2-暂停，3-停用',
  `channel_phone`    varchar(32)  DEFAULT '' COMMENT '支付渠道手机号',
  `channel_email`    varchar(64)  DEFAULT '' COMMENT '支付渠道邮箱',
  `remark`           varchar(128)           NOT NULL COMMENT '交易备注',
  `create_by`        varchar(64)  DEFAULT NULL COMMENT '创建者',
  `update_by`        varchar(64)  DEFAULT NULL COMMENT '更新者',
  `created_at`       datetime     DEFAULT NULL COMMENT '创建时间',
  `updated_at`       datetime     DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`       datetime     DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_merchant_channel_id` (`merchant_id`,`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '商户支付渠道表';


CREATE TABLE `pay_channel_params`
(
  `id`              bigint                NOT NULL AUTO_INCREMENT,
  `merchant_id`     bigint      DEFAULT 0 NOT NULL comment '商户ID',
  `channel_id`      bigint                NOT NULL COMMENT '支付渠道ID',
  `mch_id`          varchar(64)           NOT NULL COMMENT '支付渠道mch_id',
  `app_id`          varchar(64)           NOT NULL COMMENT '支付渠道app_id',
  `app_secret_key`  varchar(128)          NOT NULL COMMENT '支付渠道app_secret',
  `api_public_key`  varchar(2048)         NOT NULL COMMENT '支付渠道api证书公钥',
  `api_private_key` varchar(2048)         NOT NULL COMMENT '支付渠道api证书私钥',
  `base_pay_url`    varchar(128)          NOT NULL COMMENT '支付链接',
  `base_notify_url` varchar(128)          NOT NULL COMMENT '支付回调链接(path参数中附带商户id和渠道id和订单id)',
  `remark`          varchar(128)          NOT NULL COMMENT '备注',
  `create_by`       varchar(64) DEFAULT NULL COMMENT '创建者',
  `update_by`       varchar(64) DEFAULT NULL COMMENT '更新者',
  `created_at`      datetime    DEFAULT NULL COMMENT '创建时间',
  `updated_at`      datetime    DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`      datetime    DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_merchant_channel_pay_mode_currency` (`merchant_id`,`channel_id`,`pay_mode`,`currency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '商户支付渠道参数表';



CREATE TABLE `pay_channel_limit`
(
  `id`                    bigint                NOT NULL AUTO_INCREMENT,
  `merchant_id`           bigint      DEFAULT 0 NOT NULL comment '商户ID',
  `channel_id`            bigint                NOT NULL COMMENT '支付渠道ID',
  `pay_mode`              varchar(8)            NOT NULL COMMENT '支付模式',
  `currency`              varchar(8)            NOT NULL COMMENT '币种',
  `cycle`                 int         DEFAULT 0 NOT NULL comment '限制周期（0-不限制，1-每天，2-每月，3-每年）',
  `deposit_amount`        decimal(20, 8)        NOT NULL COMMENT '限制周期内的充值限额',
  `withdraw_amount`       decimal(20, 8)        NOT NULL COMMENT '限制周期内的提款限额',
  `order_deposit_amount`  decimal(20, 8)        NOT NULL COMMENT '单笔充值限额',
  `order_withdraw_amount` decimal(20, 8)        NOT NULL COMMENT '单笔提款限额',
  `remark`                varchar(128)          NOT NULL COMMENT '备注',
  `limit_status`          tinyint     DEFAULT '0' COMMENT '支付限额状态 0-初始化，1-激活，2-暂停，3-停用',
  `create_by`             varchar(64) DEFAULT NULL COMMENT '创建者',
  `update_by`             varchar(64) DEFAULT NULL COMMENT '更新者',
  `created_at`            datetime    DEFAULT NULL COMMENT '创建时间',
  `updated_at`            datetime    DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`            datetime    DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_merchant_channel_pay_mode_currency` (`merchant_id`,`channel_id`,`pay_mode`,`currency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '商户支付渠道限额表';



CREATE TABLE `pay_order`
(
  `id`               bigint         NOT NULL AUTO_INCREMENT,
  `order_id`         varchar(64)             DEFAULT NULL COMMENT '订单号',
  `order_type`       tinyint        NOT NULL DEFAULT '0' COMMENT '订单类型 0-充值，1-提款，2-退款',
  `order_date`       datetime                DEFAULT NULL COMMENT '订单时间',
  `order_status`     tinyint                 DEFAULT '0' COMMENT '订单状态 0-待处理，1-成功，2-失败，3-手动取消，4-超时取消',
  `account_owner_id` bigint         NOT NULL COMMENT '账户所属者ID',
  `account_id`       bigint         NOT NULL COMMENT '账户ID',
  `currency`         varchar(8)     NOT NULL COMMENT '交易币种',
  `amount`           DECIMAL(20, 8) NOT NULL COMMENT '交易金额',
  `remark`           varchar(64)    NOT NULL COMMENT '交易备注',
  `merchant_id`      bigint                  DEFAULT 0 NOT NULL comment '商户ID',
  `pay_channel_id`   bigint                  DEFAULT NULL COMMENT '支付渠道ID',
  `reference_id`     varchar(64)             DEFAULT NULL COMMENT '参考交易号',
  `pay_url`          varchar(256)            DEFAULT NULL COMMENT '支付链接',
  `channel_result`   varchar(256)            DEFAULT NULL COMMENT '创建支付链接支付渠道返回结果',
  `order_expired_at` datetime                DEFAULT NULL COMMENT '订单过期时间',
  `create_by`        varchar(64)             DEFAULT NULL COMMENT '创建者',
  `update_by`        varchar(64)             DEFAULT NULL COMMENT '更新者',
  `created_at`       datetime                DEFAULT NULL COMMENT '创建时间',
  `updated_at`       datetime                DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`       datetime                DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '支付订单表';

CREATE TABLE `pay_order_notify`
(
  `id`             bigint                  NOT NULL AUTO_INCREMENT,
  `merchant_id`    bigint        DEFAULT 0 NOT NULL comment '商户ID',
  `pay_channel_id` bigint        DEFAULT NULL COMMENT '支付渠道ID',
  `order_id`       varchar(64)   DEFAULT NULL COMMENT '订单号',
  `notify_date`    datetime      DEFAULT NULL COMMENT '回调时间',
  `notify_url`     varchar(128)            NOT NULL COMMENT '回调url',
  `notify_body`    varchar(1024)           NOT NULL COMMENT '回调结果体',
  `notify_result`  varchar(1024) DEFAULT NULL COMMENT '回调结果',
  `remark`         varchar(64)             NOT NULL COMMENT '备注',
  `create_by`      varchar(64)   DEFAULT NULL COMMENT '创建者',
  `update_by`      varchar(64)   DEFAULT NULL COMMENT '更新者',
  `created_at`     datetime      DEFAULT NULL COMMENT '创建时间',
  `updated_at`     datetime      DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`     datetime      DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_merchant_channel_order_id` (`merchant_id`,`pay_channel_id`,`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '支付订单回调结果表';

-- 分类目前支持 2 级分类，即 parent_id 为 0 的是一级分类，否则是二级分类。------------------
CREATE TABLE `game_category`
(
  `id`        bigint       NOT NULL AUTO_INCREMENT COMMENT '分类编号',
  `parent_id` bigint       NOT NULL COMMENT '父分类编号',
  `name`      varchar(64)  NOT NULL COMMENT '分类名称',
  `code`      varchar(64)  NOT NULL COMMENT '分类代码',
  `pic_url`   varchar(255) NOT NULL COMMENT '分类图',
  `sort`      int DEFAULT '0' COMMENT '分类排序',
  `status`    tinyint      NOT NULL COMMENT '开启状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COMMENT='游戏分类表';

CREATE TABLE `game_supplier`
(
  `id`              bigint                 NOT NULL AUTO_INCREMENT,
  `supplier_id`     bigint       DEFAULT 0 NOT NULL comment '供应商ID',
  `supplier_name`   varchar(64)            NOT NULL COMMENT '供应商名称',
  `supplier_avatar` varchar(128) DEFAULT '' COMMENT '供应商头像',
  `supplier_status` int          DEFAULT '0' COMMENT '供应商状态 0-初始化，1-激活，2-暂停，3-停用',
  `contact_name`    varchar(32)  DEFAULT '' COMMENT '联系人手机号',
  `contact_email`   varchar(32)  DEFAULT '' COMMENT '联系人手机号',
  `contact_phone`   varchar(64)  DEFAULT '' COMMENT '联系人邮箱',
  `remark`          varchar(128)           NOT NULL COMMENT '备注',
  `create_by`       varchar(64)  DEFAULT NULL COMMENT '创建者',
  `update_by`       varchar(64)  DEFAULT NULL COMMENT '更新者',
  `created_at`      datetime     DEFAULT NULL COMMENT '创建时间',
  `updated_at`      datetime     DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at`      datetime     DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE `uniq_supplier_id` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 comment '游戏供应商表';

CREATE TABLE `game`
(
  `id`               bigint                 NOT NULL AUTO_INCREMENT COMMENT '主键',
  `game_id`          bigint       DEFAULT 0 NOT NULL comment '游戏ID',
  `supplier_id`      bigint       DEFAULT 0 NOT NULL comment '供应商ID',
  `game_name`        varchar(64)  DEFAULT NULL COMMENT '游戏名称',
  `source_type`      int          DEFAULT 0 COMMENT '来源类型（0-自营 1-第三方）',
  `game_code`        varchar(64)  DEFAULT NULL COMMENT '游戏编码',
  `game_avatar`      varchar(128) DEFAULT '' COMMENT '头像',
  `game_url`         varchar(256) DEFAULT '' COMMENT '游戏地址',
  `support_region`   json         DEFAULT (json_array()) COMMENT '支持地域',
  `support_currency` json         DEFAULT (json_array()) COMMENT '支持币种',
  `properties`       json         DEFAULT NULL COMMENT '属性数组，JSON 格式 [{propertyId: , valueId: }, {propertyId: , valueId: }]',
  `game_status`      tinyint      DEFAULT NULL COMMENT '状态',
  `remark`           varchar(256) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4  COMMENT='游戏表';


CREATE TABLE `game_property`
(
  `id`     bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `name`   varchar(64)  DEFAULT NULL COMMENT '名称',
  `status` tinyint      DEFAULT NULL COMMENT '状态',
  `remark` varchar(128) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  KEY      `idx_name` (`name`(32)) USING BTREE COMMENT '名称索引'
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4  COMMENT='游戏属性项表';

CREATE TABLE `game_property_value`
(
  `id`          bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `property_id` bigint       DEFAULT NULL COMMENT '属性项的编号',
  `name`        varchar(128) DEFAULT NULL COMMENT '名称',
  `status`      tinyint      DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='游戏属性值表';

CREATE TABLE `game_play`
(
  `id`                   bigint         NOT NULL AUTO_INCREMENT COMMENT '编号',
  `game_id`              bigint                  DEFAULT NULL COMMENT '编号',
  `play_name`            varchar(64)             DEFAULT NULL COMMENT '玩法名称',
  `play_code`            varchar(32)             DEFAULT NULL COMMENT '玩法code',
  `play_guide`           varchar(512)            DEFAULT NULL COMMENT '玩法说明',
  `per_order_max_amount` decimal(20, 8) NOT NULL DEFAULT '0.000000' COMMENT '单笔最大金额',
  `per_order_min_amount` decimal(20, 8) NOT NULL DEFAULT '0.000000' COMMENT '单笔最低金额',
  `per_term_max_amount`  decimal(20, 8) NOT NULL DEFAULT '0.000000' COMMENT '单期最大金额',
  `per_term_min_amount`  decimal(20, 8) NOT NULL DEFAULT '0.000000' COMMENT '单期最低金额',
  `sort`                 int                     DEFAULT '0' COMMENT '排序',
  `status`               tinyint                 DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='游戏玩法表';

CREATE TABLE `game_odds`
(
  `id`        bigint         NOT NULL AUTO_INCREMENT COMMENT '编号',
  `game_id`   bigint      DEFAULT NULL COMMENT '游戏ID',
  `play_id`   bigint      DEFAULT NULL COMMENT '玩法ID',
  `odds_code` varchar(64) DEFAULT NULL COMMENT '编码',
  `odds`      decimal(20, 8) NOT NULL COMMENT '赔率',
  `status`    tinyint     DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='游戏赔率表';

CREATE TABLE `game_term`
(
  `id`          bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `game_id`     bigint      DEFAULT NULL COMMENT '游戏ID',
  `game_term`   varchar(64) DEFAULT NULL COMMENT '游戏期数',
  `start_time`  datetime    DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `end_time`    datetime    DEFAULT CURRENT_TIMESTAMP COMMENT '结束时间',
  `draw_time`   datetime    DEFAULT CURRENT_TIMESTAMP COMMENT '开奖时间',
  `result_time` datetime    DEFAULT CURRENT_TIMESTAMP COMMENT '生成结果时间',
  `term_result` json        DEFAULT NULL COMMENT '游戏结果',
  `term_status` int         DEFAULT 0 COMMENT '状态 0-初始化 1准备就绪 2已结束 3-已开奖',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='游戏期数表';



CREATE TABLE `order`
(
  `id`               bigint         NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id`         varchar(32)    NOT NULL COMMENT '订单流水号',
  `source_type`      int            NOT NULL COMMENT '订单来源类型(0-web,1-h5,2-app,3-third)',
  `member_id`        bigint         NOT NULL COMMENT '用户编号',
  `member_ip`        varchar(30)    NOT NULL DEFAULT '' COMMENT '用户IP',
  `member_region`    varchar(64)    NOT NULL DEFAULT '' COMMENT '用户区域',
  `merchant_id`      bigint         NOT NULL COMMENT '商户ID',
  `agent_id`         bigint         NOT NULL COMMENT '代理ID',
  `status`           int            NOT NULL DEFAULT 0 COMMENT '订单状态',
  `remark`           varchar(128) NULL DEFAULT NULL COMMENT '备注',
  `finish_time`      datetime NULL DEFAULT NULL COMMENT '订单完成时间',
  `currency`         varchar(32)    NOT NULL DEFAULT '' COMMENT '币种',
  `amount`           decimal(20, 8) NOT NULL DEFAULT '0.00000000' COMMENT '交易金额',
  `coupon_id`        bigint NULL DEFAULT NULL COMMENT '优惠劵编号',
  `coupon_amount`    decimal(20, 8) NOT NULL DEFAULT '0.00000000' COMMENT '优惠券金额',
  `cancel_time`      datetime NULL DEFAULT NULL COMMENT '取消时间',
  `cancel_reason`    varchar(64)    NOT NULL DEFAULT '' COMMENT '取消原因',
  `pay_order_id`     bigint NULL DEFAULT NULL COMMENT '支付订单编号',
  `pay_status`       int            NOT NULL DEFAULT 0 COMMENT '是否已支付：[0:未支付 1:已经支付]',
  `pay_time`         datetime NULL DEFAULT NULL COMMENT '支付时间',
  `pay_channel_code` varchar(16) NULL DEFAULT NULL COMMENT '支付渠道',
  `pay_amount`       decimal(20, 8) NOT NULL DEFAULT '0.00000000' COMMENT '实际支付金额',
  `refund_status`    tinyint        NOT NULL DEFAULT 0 COMMENT '退款状态',
  `refund_time`      datetime NULL DEFAULT NULL COMMENT '退款时间',
  `refund_reason`    varchar(64)    NOT NULL DEFAULT '' COMMENT '退款原因',
  `refund_amount`    decimal(20, 8) NOT NULL DEFAULT '0.00000000' COMMENT '退款金额',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB  CHARACTER SET = utf8mb4 COMMENT = '交易订单表';

CREATE TABLE `order_item`
(
  `id`                 bigint         NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id`           varchar(32)    NOT NULL COMMENT '订单流水号',
  `game_category_id`   int            NOT NULL COMMENT '分类ID',
  `game_category_name` varchar(64)    NOT NULL COMMENT '分类名称',
  `game_category_code` varchar(64)    NOT NULL COMMENT '分类代码',
  `game_id`            int            NOT NULL COMMENT '游戏ID',
  `game_name`          varchar(64)    NOT NULL COMMENT '游戏名称',
  `game_code`          varchar(64)    NOT NULL COMMENT '游戏代码',
  `game_play_id`       int            NOT NULL COMMENT '玩法ID',
  `game_play_name`     varchar(64)    NOT NULL COMMENT '玩法名称',
  `game_play_code`     varchar(64)    NOT NULL COMMENT '玩法代码',
  `game_odds_id`       int            NOT NULL COMMENT '赔率ID',
  `game_odds_code`     varchar(64)    NOT NULL COMMENT '赔率代码',
  `game_odds`          decimal(20, 8) NOT NULL COMMENT '赔率',
  `game_term_id`       int            NOT NULL COMMENT '期数ID',
  `game_term`          varchar(64)    NOT NULL COMMENT '期数'
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB  CHARACTER SET = utf8mb4 COMMENT = '订单明细表';


CREATE TABLE `order_settlement`
(
  `id`                bigint         NOT NULL AUTO_INCREMENT COMMENT '主键',
  `order_id`          varchar(32)    NOT NULL COMMENT '订单号',
  `order_amount`      decimal(20, 8) NOT NULL DEFAULT '0.00000000' COMMENT '订单金额',
  `coupon_amount`     decimal(20, 8) NOT NULL DEFAULT '0.00000000' COMMENT '优惠券金额',
  `game_odds`         decimal(20, 8) NOT NULL COMMENT '赔率',
  `cashback_rate`     decimal(20, 8) NOT NULL COMMENT '返还比例',
  `draw_amount`       decimal(20, 8) NOT NULL DEFAULT '0.00000000' COMMENT '开奖金额(订单金额*赔率)开奖金额有输有赢',
  `settlement_amount` decimal(20, 8) NOT NULL DEFAULT '0.00000000' COMMENT '结算金额(开奖金额+返还金额)',
  `cashback_amount`   decimal(20, 8) NOT NULL DEFAULT '0.00000000' COMMENT '返还金额(订单金额*返还比例)',
  `settlement_time`   datetime NULL DEFAULT NULL COMMENT '结算时间',
  `settlement_status` int            NOT NULL DEFAULT 0 COMMENT '结算状态',

  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB  CHARACTER SET = utf8mb4 COMMENT = '订单结算表';



CREATE TABLE `coupon_template`
(
  `id`                  bigint         NOT NULL AUTO_INCREMENT COMMENT '主键',
  `merchant_id`         bigint         NOT NULL AUTO_INCREMENT COMMENT '商户ID',
  `template_id`         bigint         NOT NULL COMMENT '优惠劵模板ID',
  `coupon_name`         varchar(64)    NOT NULL COMMENT '优惠劵名称',
  `coupon_type`         int            NOT NULL COMMENT '优惠券类型：1-代金劵；2-折扣劵',
  `currency`            varchar(32)    NOT NULL DEFAULT '' COMMENT '币种(代金券)',
  `status`              int            NOT NULL COMMENT '优惠券状态',
  `biz_type`            int            NOT NULL COMMENT '业务类型(0充值手续费,1提款手续费,2充值膨胀,3新用户注册,4抽奖，5等级提升)',
  `get_type`            int            NOT NULL COMMENT '获取方式(0-主动领取，1-平台赠送)',
  `total_count`         int            NOT NULL COMMENT '可发放数量, -1 - 则表示不限制',
  `get_limit_count`     int            NOT NULL COMMENT '每人限领个数, -1 - 则表示不限制',
  `start_time`          datetime                DEFAULT NULL COMMENT '优惠券开始领取时间',
  `end_time`            datetime                DEFAULT NULL COMMENT '优惠券结束领取时间',
  `usage_min_amount`    decimal(20, 8) NOT NULL COMMENT '使用金额限制(满多少可用)',
  `validity_type`       int            NOT NULL COMMENT '有效期类型(0-固定时间区间，1-领取日期+有效周期)',
  `validity_period`     int            NOT NULL COMMENT '有效周期类型(1-当天，3-3天，7-7天，30-30天)',
  `fixed_start_time`    datetime                DEFAULT NULL COMMENT '固定日期-有效开始时间',
  `fixed_end_time`      datetime                DEFAULT NULL COMMENT '固定日期-有效结束时间',
  `discount_percent`    decimal(20, 8)          DEFAULT NULL COMMENT '折扣百分比',
  `discount_amount`     decimal(20, 8)          DEFAULT NULL COMMENT '优惠金额',
  `discount_max_amount` decimal(20, 8)          DEFAULT NULL COMMENT '折扣上限(仅折扣券有效)',
  `member_group_scope`  json                    DEFAULT NULL COMMENT '会员组范围',
  `game_category_scope` json                    DEFAULT NULL COMMENT '游戏分类范围',
  `game_scope`          json                    DEFAULT NULL COMMENT '游戏范围',
  `get_count`           int            NOT NULL DEFAULT '0' COMMENT '已领取数量',
  `used_count`          int            NOT NULL DEFAULT '0' COMMENT '已使用数量',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4  COMMENT='优惠劵模板表';

CREATE TABLE `coupon`
(
  `id`                  bigint         NOT NULL AUTO_INCREMENT COMMENT '模板ID',
  `merchant_id`         bigint         NOT NULL AUTO_INCREMENT COMMENT '商户ID',
  `agent_id`            bigint         NOT NULL COMMENT '代理ID',
  `member_id`           bigint         NOT NULL AUTO_INCREMENT COMMENT '会员ID',
  `template_id`         bigint         NOT NULL COMMENT '优惠劵模板ID',
  `coupon_id`           bigint         NOT NULL COMMENT '优惠劵ID',
  `coupon_name`         varchar(64)    NOT NULL COMMENT '优惠劵名称',
  `coupon_type`         int            NOT NULL COMMENT '优惠券类型：1-代金劵；2-折扣劵(仅限手续费)',
  `currency`            varchar(32)    NOT NULL DEFAULT '' COMMENT '币种(代金券)',
  `status`              int            NOT NULL COMMENT '优惠券状态(1-未使用；2-已使用；3-已失效)',
  `biz_type`            int            NOT NULL COMMENT '业务类型(0充值手续费,1提款手续费,2充值膨胀,3新用户注册,4抽奖)',
  `get_type`            int            NOT NULL COMMENT '获取方式(0-主动领取，1-平台赠送)',
  `usage_min_amount`    decimal(20, 8) NOT NULL COMMENT '使用金额限制(满多少可用)',
  `validity_type`       int            NOT NULL COMMENT '有效期类型(0-固定时间区间，1-领取日期+有效周期)',
  `validity_period`     int            NOT NULL COMMENT '有效周期类型(1-当天，3-3天，7-7天，30-30天)',
  `fixed_start_time`    datetime                DEFAULT NULL COMMENT '固定日期-有效开始时间',
  `fixed_end_time`      datetime                DEFAULT NULL COMMENT '固定日期-有效结束时间',
  `discount_percent`    decimal(20, 8)          DEFAULT NULL COMMENT '折扣百分比',
  `discount_amount`     decimal(20, 8)          DEFAULT NULL COMMENT '优惠金额',
  `discount_max_amount` decimal(20, 8)          DEFAULT NULL COMMENT '折扣上限(仅折扣券有效)',
  `member_group_scope`  json                    DEFAULT NULL COMMENT '会员组范围',
  `game_category_scope` json                    DEFAULT NULL COMMENT '游戏分类范围',
  `game_scope`          json                    DEFAULT NULL COMMENT '游戏范围',
  `used_time`           datetime                DEFAULT NULL COMMENT '使用时间',
  `used_game_id`        bigint                  DEFAULT 0 COMMENT '使用游戏',
  `used_game_order_id`  bigint                  DEFAULT 0 COMMENT '使用游戏订单号',
  `used_pay_order_id`   bigint                  DEFAULT 0 COMMENT '使用支付订单号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4  COMMENT='会员优惠劵表';


CREATE TABLE `activity`
(
  `id`              bigint      NOT NULL AUTO_INCREMENT COMMENT '主键',
  `merchant_id`     bigint      NOT NULL AUTO_INCREMENT COMMENT '商户ID',
  `activity_id`     bigint      NOT NULL '活动编号',
  `activity_name`   varchar(64) NOT NULL DEFAULT '' COMMENT '活动标题',
  `activity_type`   int         NOT NULL '活动类型',
  `start_time`      datetime    NOT NULL COMMENT '开始时间',
  `end_time`        datetime    NOT NULL COMMENT '结束时间',
  `remark`          varchar(256)         DEFAULT '' COMMENT '备注',
  `activity_status` int         NOT NULL DEFAULT '-1' COMMENT '活动状态'
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  CHARSET=utf8mb4 COMMENT='活动表';

CREATE TABLE `activity_scope`
(
  `id`                  bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `merchant_id`         bigint NOT NULL AUTO_INCREMENT COMMENT '商户ID',
  `activity_id`         bigint NOT NULL '活动编号',
  `agent_scope`         json DEFAULT NULL COMMENT '代理范围',
  `member_group_scope`  json DEFAULT NULL COMMENT '会员组范围',
  `game_category_scope` json DEFAULT NULL COMMENT '游戏分类范围',
  `game_scope`          json DEFAULT NULL COMMENT '游戏范围'
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  CHARSET=utf8mb4 COMMENT='活动业务范围表';

CREATE TABLE `activity_condition`
(
  `id`             bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `merchant_id`    bigint NOT NULL AUTO_INCREMENT COMMENT '商户ID',
  `activity_id`    bigint NOT NULL '活动编号',
  `condition_type` int    NOT NULL DEFAULT 0 COMMENT '条件类型(1单次，2范围)',
  `biz_type`       int    NOT NULL DEFAULT 0 COMMENT '业务类型(1充值金额,2,充值笔数, 3订单金额,4订单笔数,5注册时间,6会员等级,7交易时间)',
  `start_time`     datetime        DEFAULT NULL COMMENT '开始开始时间',
  `end_time`       datetime        DEFAULT NULL COMMENT '结束结束时间',
  `rules`          json            DEFAULT '' COMMENT '规则'
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  CHARSET=utf8mb4 COMMENT='活动会员参与条件表';

CREATE TABLE `activity_award`
(
  `id`                 bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `merchant_id`        bigint NOT NULL AUTO_INCREMENT COMMENT '商户ID',
  `activity_id`        bigint NOT NULL '活动编号',
  `award_type`         int    NOT NULL DEFAULT 0 COMMENT '奖励类型(1优惠券，2积分)',
  `coupon_template_id` bigint NOT NULL '优惠券模板ID',
  `point`              int    NOT NULL DEFAULT 0 COMMENT '积分'
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  CHARSET=utf8mb4 COMMENT='活动奖励表';

CREATE TABLE `activity_award_record`
(
  `id`                 bigint   NOT NULL AUTO_INCREMENT COMMENT '主键',
  `merchant_id`        bigint   NOT NULL AUTO_INCREMENT COMMENT '商户ID',
  `activity_id`        bigint   NOT NULL '活动编号',
  `agent_id`           bigint   NOT NULL COMMENT '代理ID',
  `member_id`          bigint   NOT NULL COMMENT '会员ID',
  `award_type`         int      NOT NULL DEFAULT 0 COMMENT '奖励类型(1优惠券，2积分)',
  `coupon_template_id` bigint   NOT NULL '优惠券模板ID',
  `point`              int      NOT NULL DEFAULT 0 COMMENT '积分',
  `coupon_id`          bigint   NOT NULL '优惠券ID',
  `point_record_id`    bigint   NOT NULL '会员积分变更ID',
  `award_time`         datetime NOT NULL COMMENT '奖励时间',
  `activity_detail`    json              DEFAULT '' COMMENT '活动详情'
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  CHARSET=utf8mb4 COMMENT='活动奖励记录表';

