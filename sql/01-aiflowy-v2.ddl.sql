SET NAMES utf8mb4;
SET
FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_bot
-- ----------------------------
DROP TABLE IF EXISTS `tb_bot`;
CREATE TABLE `tb_bot`
(
    `id`            bigint UNSIGNED NOT NULL COMMENT '主键ID',
    `alias`         varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '别名',
    `dept_id`       bigint UNSIGNED NOT NULL COMMENT '部门ID',
    `tenant_id`     bigint UNSIGNED NOT NULL COMMENT '租户ID',
    `category_id`   bigint UNSIGNED NULL DEFAULT NULL COMMENT '分类ID',
    `title`         varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标题',
    `description`   varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
    `icon`          varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标',
    `model_id`      bigint UNSIGNED NULL DEFAULT NULL COMMENT '模型 ID',
    `model_options` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '模型配置',
    `status`        int NULL DEFAULT 0 COMMENT '数据状态',
    `options`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '选项',
    `created`       datetime NULL DEFAULT NULL COMMENT '创建时间',
    `created_by`    bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建者ID',
    `modified`      datetime NULL DEFAULT NULL COMMENT '修改时间',
    `modified_by`   bigint UNSIGNED NULL DEFAULT NULL COMMENT '修改者ID',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `tb_ai_bot_alias_uindex`(`alias`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'bot表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_bot_category
-- ----------------------------
DROP TABLE IF EXISTS `tb_bot_category`;
CREATE TABLE `tb_bot_category`
(
    `id`            bigint UNSIGNED NOT NULL COMMENT '主键',
    `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
    `sort_no`       int NULL DEFAULT 0 COMMENT '排序',
    `status`        int                                                          NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`       datetime                                                     NOT NULL COMMENT '创建时间',
    `created_by`    bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`      datetime                                                     NOT NULL COMMENT '修改时间',
    `modified_by`   bigint UNSIGNED NOT NULL COMMENT '修改者',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'bot分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_bot_conversation
-- ----------------------------
DROP TABLE IF EXISTS `tb_bot_conversation`;
CREATE TABLE `tb_bot_conversation`
(
    `id`          bigint UNSIGNED NOT NULL COMMENT '会话id',
    `title`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '会话标题',
    `bot_id`      bigint UNSIGNED NULL DEFAULT NULL COMMENT 'botid',
    `account_id`  bigint UNSIGNED NULL DEFAULT NULL COMMENT '账户 id',
    `created`     datetime NULL DEFAULT NULL COMMENT '创建时间',
    `created_by`  bigint UNSIGNED NULL DEFAULT NULL,
    `modified`    datetime NULL DEFAULT NULL,
    `modified_by` bigint UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'bot对话' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_bot_document_collection
-- ----------------------------
DROP TABLE IF EXISTS `tb_bot_document_collection`;
CREATE TABLE `tb_bot_document_collection`
(
    `id`                     bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `bot_id`                 bigint UNSIGNED NULL DEFAULT NULL,
    `document_collection_id` bigint UNSIGNED NULL DEFAULT NULL,
    `options`                text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'bot绑定的知识库' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_bot_message
-- ----------------------------
DROP TABLE IF EXISTS `tb_bot_message`;
CREATE TABLE `tb_bot_message`
(
    `id`              bigint UNSIGNED NOT NULL COMMENT 'ID',
    `bot_id`          bigint UNSIGNED NULL DEFAULT NULL COMMENT 'botId',
    `account_id`      bigint UNSIGNED NULL DEFAULT NULL COMMENT '关联的账户ID',
    `conversation_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '会话ID',
    `role`            varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '角色[user|assistant]',
    `content`         longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '内容',
    `image`           varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片',
    `options`         text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '选项',
    `created`         datetime NULL DEFAULT NULL COMMENT '创建时间',
    `modified`        datetime NULL DEFAULT NULL COMMENT '更新时间',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX             `bot_id`(`bot_id`) USING BTREE,
    INDEX             `account_id`(`account_id`) USING BTREE,
    INDEX             `session_id`(`conversation_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'bot消息记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_bot_model
-- ----------------------------
DROP TABLE IF EXISTS `tb_bot_model`;
CREATE TABLE `tb_bot_model`
(
    `id`       bigint UNSIGNED NOT NULL,
    `bot_id`   bigint UNSIGNED NULL DEFAULT NULL,
    `model_id` bigint UNSIGNED NULL DEFAULT NULL,
    `options`  text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'bot绑定的大模型' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_bot_plugin
-- ----------------------------
DROP TABLE IF EXISTS `tb_bot_plugin`;
CREATE TABLE `tb_bot_plugin`
(
    `id`             bigint UNSIGNED NOT NULL,
    `bot_id`         bigint UNSIGNED NULL DEFAULT NULL,
    `plugin_item_id` bigint UNSIGNED NULL DEFAULT NULL,
    `options`        text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'bot绑定的插件' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_bot_recently_used
-- ----------------------------
DROP TABLE IF EXISTS `tb_bot_recently_used`;
CREATE TABLE `tb_bot_recently_used`
(
    `id`         bigint(0) UNSIGNED NOT NULL COMMENT '主键',
    `bot_id`     bigint(0) UNSIGNED NOT NULL COMMENT 'botId',
    `created`    datetime(0) NOT NULL COMMENT '创建时间',
    `created_by` bigint(0) UNSIGNED NOT NULL COMMENT '创建者',
    `sort_no`    int(0) NULL DEFAULT 0 COMMENT '排序',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '最近使用' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_bot_workflow
-- ----------------------------
DROP TABLE IF EXISTS `tb_bot_workflow`;
CREATE TABLE `tb_bot_workflow`
(
    `id`          bigint UNSIGNED NOT NULL,
    `bot_id`      bigint UNSIGNED NULL DEFAULT NULL,
    `workflow_id` bigint UNSIGNED NULL DEFAULT NULL,
    `options`     text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'bot绑定的工作流' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_datacenter_table
-- ----------------------------
DROP TABLE IF EXISTS `tb_datacenter_table`;
CREATE TABLE `tb_datacenter_table`
(
    `id`           bigint UNSIGNED NOT NULL COMMENT '主键',
    `dept_id`      bigint UNSIGNED NOT NULL COMMENT '部门ID',
    `tenant_id`    bigint UNSIGNED NOT NULL COMMENT '租户ID',
    `table_name`   varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '数据表名',
    `table_desc`   varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '数据表描述',
    `actual_table` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物理表名',
    `status`       int                                                          NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`      datetime                                                     NOT NULL COMMENT '创建时间',
    `created_by`   bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`     datetime                                                     NOT NULL COMMENT '修改时间',
    `modified_by`  bigint UNSIGNED NOT NULL COMMENT '修改者',
    `options`      text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '扩展项',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '数据中枢表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_datacenter_table_field
-- ----------------------------
DROP TABLE IF EXISTS `tb_datacenter_table_field`;
CREATE TABLE `tb_datacenter_table_field`
(
    `id`          bigint UNSIGNED NOT NULL COMMENT '主键',
    `table_id`    bigint UNSIGNED NOT NULL COMMENT '数据表ID',
    `field_name`  varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字段名称',
    `field_desc`  varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字段描述',
    `field_type`  int                                                          NOT NULL COMMENT '字段类型',
    `required`    int                                                          NOT NULL DEFAULT 0 COMMENT '是否必填',
    `options`     text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '扩展项',
    `created`     datetime                                                     NOT NULL COMMENT '创建时间',
    `created_by`  bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`    datetime                                                     NOT NULL COMMENT '修改时间',
    `modified_by` bigint UNSIGNED NOT NULL COMMENT '修改者',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '数据中枢字段表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_document
-- ----------------------------
DROP TABLE IF EXISTS `tb_document`;
CREATE TABLE `tb_document`
(
    `id`            bigint UNSIGNED NOT NULL,
    `collection_id` bigint UNSIGNED NOT NULL COMMENT '知识库ID',
    `document_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文档类型 pdf/word/aieditor 等',
    `document_path` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文档路径',
    `title`         varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标题',
    `content`       longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '内容',
    `content_type`  varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '内容类型',
    `slug`          varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'URL 别名',
    `order_no`      int NULL DEFAULT NULL COMMENT '排序序号',
    `options`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '其他配置项',
    `created`       datetime NULL DEFAULT NULL COMMENT '创建时间',
    `created_by`    bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建人ID',
    `modified`      datetime NULL DEFAULT NULL COMMENT '最后的修改时间',
    `modified_by`   bigint UNSIGNED NULL DEFAULT NULL COMMENT '最后的修改人的ID',
    PRIMARY KEY (`id`) USING BTREE,
    INDEX           `knowledge_id`(`collection_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文档' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_document_chunk
-- ----------------------------
DROP TABLE IF EXISTS `tb_document_chunk`;
CREATE TABLE `tb_document_chunk`
(
    `id`                     bigint UNSIGNED NOT NULL,
    `document_id`            bigint UNSIGNED NOT NULL COMMENT '文档ID',
    `document_collection_id` bigint UNSIGNED NULL DEFAULT NULL COMMENT '知识库ID',
    `content`                text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '分块内容',
    `sorting`                int NULL DEFAULT NULL COMMENT '分割顺序',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文档分块表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_document_collection
-- ----------------------------
DROP TABLE IF EXISTS `tb_document_collection`;
CREATE TABLE `tb_document_collection`
(
    `id`                        bigint(0) UNSIGNED NOT NULL COMMENT 'Id',
    `alias`                     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '别名',
    `dept_id`                   bigint(0) UNSIGNED NOT NULL COMMENT '部门ID',
    `tenant_id`                 bigint(0) UNSIGNED NOT NULL COMMENT '租户ID',
    `icon`                      varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'ICON',
    `title`                     varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标题',
    `description`               varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
    `slug`                      varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'URL 别名',
    `vector_store_enable`       tinyint(1) NULL DEFAULT NULL COMMENT '是否启用向量存储',
    `vector_store_type`         varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '向量数据库类型',
    `vector_store_collection`   varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '向量数据库集合',
    `vector_store_config`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '向量数据库配置',
    `vector_embed_model_id`     bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT 'Embedding 模型ID',
    `dimension_of_vector_model` int(0) NULL DEFAULT NULL COMMENT '向量模型维度',
    `created`                   datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `created_by`                bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT '创建用户ID',
    `modified`                  datetime(0) NULL DEFAULT NULL COMMENT '最后一次修改时间',
    `modified_by`               bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT '最后一次修改用户ID',
    `options`                   text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '其他配置',
    `rerank_model_id`           bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT '重排模型id',
    `search_engine_enable`      tinyint(1) NULL DEFAULT NULL COMMENT '是否启用搜索引擎',
    `english_name`              varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '英文名称',
    `category_id`               bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT '分类ID',
    `vector_database_id`        bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT '向量数据库id',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `tb_ai_knowledge_alias_uindex`(`alias`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '知识库' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_document_collection_category
-- ----------------------------
DROP TABLE IF EXISTS `tb_document_collection_category`;
CREATE TABLE `tb_document_collection_category`
(
    `id`            bigint(0) UNSIGNED NOT NULL COMMENT '主键',
    `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
    `sort_no`       int(0) NULL DEFAULT 0 COMMENT '排序',
    `status`        int(0) NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`       datetime(0) NOT NULL COMMENT '创建时间',
    `created_by`    bigint(0) UNSIGNED NOT NULL COMMENT '创建者',
    `modified`      datetime(0) NOT NULL COMMENT '修改时间',
    `modified_by`   bigint(0) UNSIGNED NOT NULL COMMENT '修改者',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_document_history
-- ----------------------------
DROP TABLE IF EXISTS `tb_document_history`;
CREATE TABLE `tb_document_history`
(
    `id`                bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `document_id`       bigint NULL DEFAULT NULL COMMENT '修改的文档ID',
    `old_title`         varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '旧标题',
    `new_title`         varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '新标题',
    `old_content`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '旧内容',
    `new_content`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '新内容',
    `old_document_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '旧的文档类型',
    `new_document_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '新的额文档类型',
    `created`           datetime NULL DEFAULT NULL COMMENT '创建时间',
    `created_by`        bigint NULL DEFAULT NULL COMMENT '创建人ID',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文档历史记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_model
-- ----------------------------
DROP TABLE IF EXISTS `tb_model`;
CREATE TABLE `tb_model`
(
    `id`                     bigint(0) UNSIGNED NOT NULL COMMENT 'ID',
    `dept_id`                bigint(0) UNSIGNED NOT NULL COMMENT '部门ID',
    `tenant_id`              bigint(0) UNSIGNED NOT NULL COMMENT '租户ID',
    `provider_id`            bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT '供应商id',
    `title`                  varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标题或名称',
    `icon`                   varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'ICON',
    `description`            varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
    `endpoint`               varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '大模型请求地址',
    `request_path`           varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求路径',
    `model_name`             varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '大模型名称',
    `api_key`                varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '大模型 API KEY',
    `extra_config`           text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '大模型其他属性配置',
    `options`                text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '其他配置内容',
    `group_name`             varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分组名称',
    `model_type`             varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模型类型: chatModel/embeddingModel/rerankModel/orc..',
    `with_used`              tinyint(1) NULL DEFAULT NULL COMMENT '是否使用',
    `support_thinking`       tinyint(1) NULL DEFAULT NULL COMMENT '是否支持推理',
    `support_tool`           tinyint(1) NULL DEFAULT NULL COMMENT '是否支持工具',
    `support_image`          tinyint(1) NULL DEFAULT NULL COMMENT '是否支持图片',
    `support_image_b64_only` tinyint(1) NULL DEFAULT NULL COMMENT '仅支持 base64 的图片类型',
    `support_video`          tinyint(1) NULL DEFAULT NULL COMMENT '是否支持视频',
    `support_audio`          tinyint(1) NULL DEFAULT NULL COMMENT '是否支持音频',
    `support_free`           tinyint(1) NULL DEFAULT NULL COMMENT '是否免费',
    `support_tool_message`   tinyint(1) NULL DEFAULT NULL COMMENT '是否支持tool消息',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '大模型管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_model_provider
-- ----------------------------
DROP TABLE IF EXISTS `tb_model_provider`;
CREATE TABLE `tb_model_provider`
(
    `id`            bigint UNSIGNED NOT NULL COMMENT 'id',
    `provider_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '供应商名称',
    `provider_type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '不同的 client 实现，默认为 openai',
    `icon`          varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标',
    `api_key`       varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'apiKey',
    `endpoint`      varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'endPoint',
    `chat_path`     varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '对话地址',
    `embed_path`    varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '向量地址',
    `rerank_path`   varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '重排路径',
    `created`       datetime                                                      NOT NULL COMMENT '创建时间',
    `created_by`    bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`      datetime                                                      NOT NULL COMMENT '修改时间',
    `modified_by`   bigint UNSIGNED NOT NULL COMMENT '修改者',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '大模型供应商，比如 Aliyun/Gitee/火山引擎 等' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_plugin
-- ----------------------------
DROP TABLE IF EXISTS `tb_plugin`;
CREATE TABLE `tb_plugin`
(
    `id`          bigint UNSIGNED NOT NULL COMMENT '插件id',
    `alias`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '别名',
    `name`        varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名称',
    `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
    `type`        int NULL DEFAULT NULL COMMENT '类型',
    `base_url`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '基础URL',
    `auth_type`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '认证方式  【apiKey/none】',
    `created`     datetime NULL DEFAULT NULL COMMENT '创建时间',
    `icon`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标地址',
    `position`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '认证参数位置 【headers, query】',
    `headers`     varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求头',
    `token_key`   varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'token键',
    `token_value` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'token值',
    `dept_id`     bigint NULL DEFAULT NULL COMMENT '部门id',
    `tenant_id`   bigint NULL DEFAULT NULL COMMENT '租户id',
    `created_by`  bigint NULL DEFAULT NULL COMMENT '创建人',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `tb_ai_plugin_alias_uindex`(`alias`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '插件表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_plugin_category
-- ----------------------------
DROP TABLE IF EXISTS `tb_plugin_category`;
CREATE TABLE `tb_plugin_category`
(
    `id`         bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `created_at` datetime NULL DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '插件分类' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_plugin_category_mapping
-- ----------------------------
DROP TABLE IF EXISTS `tb_plugin_category_mapping`;
CREATE TABLE `tb_plugin_category_mapping`
(
    `category_id` bigint UNSIGNED NOT NULL,
    `plugin_id`   bigint UNSIGNED NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '插件分类关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_plugin_item
-- ----------------------------
DROP TABLE IF EXISTS `tb_plugin_item`;
CREATE TABLE `tb_plugin_item`
(
    `id`             bigint UNSIGNED NOT NULL COMMENT '插件工具id',
    `plugin_id`      bigint UNSIGNED NOT NULL COMMENT '插件id',
    `name`           varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '名称',
    `description`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
    `base_path`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '基础路径',
    `created`        datetime NULL DEFAULT NULL COMMENT '创建时间',
    `status`         int NULL DEFAULT 0 COMMENT '是否启用',
    `input_data`     text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '输入参数',
    `output_data`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '输出参数',
    `request_method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '请求方式【Post, Get, Put, Delete】',
    `service_status` int NULL DEFAULT NULL COMMENT '服务状态[0 下线 1 上线]',
    `debug_status`   int NULL DEFAULT NULL COMMENT '调试状态【0失败 1成功】',
    `english_name`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '英文名称',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '插件工具表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `tb_qrtz_blob_triggers`;
CREATE TABLE `tb_qrtz_blob_triggers`
(
    `SCHED_NAME`    varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_NAME`  varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `BLOB_DATA`     blob NULL,
    PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
    INDEX           `SCHED_NAME`(`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
    CONSTRAINT `TB_QRTZ_BLOB_TRIGGERS_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `tb_qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `tb_qrtz_calendars`;
CREATE TABLE `tb_qrtz_calendars`
(
    `SCHED_NAME`    varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `CALENDAR_NAME` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `CALENDAR`      blob                                                          NOT NULL,
    PRIMARY KEY (`SCHED_NAME`, `CALENDAR_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `tb_qrtz_cron_triggers`;
CREATE TABLE `tb_qrtz_cron_triggers`
(
    `SCHED_NAME`      varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_NAME`    varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_GROUP`   varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `CRON_EXPRESSION` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TIME_ZONE_ID`    varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
    CONSTRAINT `TB_QRTZ_CRON_TRIGGERS_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `tb_qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `tb_qrtz_fired_triggers`;
CREATE TABLE `tb_qrtz_fired_triggers`
(
    `SCHED_NAME`        varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `ENTRY_ID`          varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL,
    `TRIGGER_NAME`      varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_GROUP`     varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `INSTANCE_NAME`     varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `FIRED_TIME`        bigint                                                        NOT NULL,
    `SCHED_TIME`        bigint                                                        NOT NULL,
    `PRIORITY`          int                                                           NOT NULL,
    `STATE`             varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL,
    `JOB_NAME`          varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `JOB_GROUP`         varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `IS_NONCONCURRENT`  varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    PRIMARY KEY (`SCHED_NAME`, `ENTRY_ID`) USING BTREE,
    INDEX               `IDX_QRTZ_FT_TRIG_INST_NAME`(`SCHED_NAME`, `INSTANCE_NAME`) USING BTREE,
    INDEX               `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY`(`SCHED_NAME`, `INSTANCE_NAME`, `REQUESTS_RECOVERY`) USING BTREE,
    INDEX               `IDX_QRTZ_FT_J_G`(`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE,
    INDEX               `IDX_QRTZ_FT_JG`(`SCHED_NAME`, `JOB_GROUP`) USING BTREE,
    INDEX               `IDX_QRTZ_FT_T_G`(`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
    INDEX               `IDX_QRTZ_FT_TG`(`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `tb_qrtz_job_details`;
CREATE TABLE `tb_qrtz_job_details`
(
    `SCHED_NAME`        varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `JOB_NAME`          varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `JOB_GROUP`         varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `DESCRIPTION`       varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `JOB_CLASS_NAME`    varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `IS_DURABLE`        varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci   NOT NULL,
    `IS_NONCONCURRENT`  varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci   NOT NULL,
    `IS_UPDATE_DATA`    varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci   NOT NULL,
    `REQUESTS_RECOVERY` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci   NOT NULL,
    `JOB_DATA`          blob NULL,
    PRIMARY KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE,
    INDEX               `IDX_QRTZ_J_REQ_RECOVERY`(`SCHED_NAME`, `REQUESTS_RECOVERY`) USING BTREE,
    INDEX               `IDX_QRTZ_J_GRP`(`SCHED_NAME`, `JOB_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `tb_qrtz_locks`;
CREATE TABLE `tb_qrtz_locks`
(
    `SCHED_NAME` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `LOCK_NAME`  varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL,
    PRIMARY KEY (`SCHED_NAME`, `LOCK_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `tb_qrtz_paused_trigger_grps`;
CREATE TABLE `tb_qrtz_paused_trigger_grps`
(
    `SCHED_NAME`    varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    PRIMARY KEY (`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `tb_qrtz_scheduler_state`;
CREATE TABLE `tb_qrtz_scheduler_state`
(
    `SCHED_NAME`        varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `INSTANCE_NAME`     varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `LAST_CHECKIN_TIME` bigint                                                        NOT NULL,
    `CHECKIN_INTERVAL`  bigint                                                        NOT NULL,
    PRIMARY KEY (`SCHED_NAME`, `INSTANCE_NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `tb_qrtz_simple_triggers`;
CREATE TABLE `tb_qrtz_simple_triggers`
(
    `SCHED_NAME`      varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_NAME`    varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_GROUP`   varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `REPEAT_COUNT`    bigint                                                        NOT NULL,
    `REPEAT_INTERVAL` bigint                                                        NOT NULL,
    `TIMES_TRIGGERED` bigint                                                        NOT NULL,
    PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
    CONSTRAINT `TB_QRTZ_SIMPLE_TRIGGERS_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `tb_qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `tb_qrtz_simprop_triggers`;
CREATE TABLE `tb_qrtz_simprop_triggers`
(
    `SCHED_NAME`    varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_NAME`  varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_GROUP` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `STR_PROP_1`    varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `STR_PROP_2`    varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `STR_PROP_3`    varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `INT_PROP_1`    int NULL DEFAULT NULL,
    `INT_PROP_2`    int NULL DEFAULT NULL,
    `LONG_PROP_1`   bigint NULL DEFAULT NULL,
    `LONG_PROP_2`   bigint NULL DEFAULT NULL,
    `DEC_PROP_1`    decimal(13, 4) NULL DEFAULT NULL,
    `DEC_PROP_2`    decimal(13, 4) NULL DEFAULT NULL,
    `BOOL_PROP_1`   varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `BOOL_PROP_2`   varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
    CONSTRAINT `TB_QRTZ_SIMPROP_TRIGGERS_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `tb_qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `tb_qrtz_triggers`;
CREATE TABLE `tb_qrtz_triggers`
(
    `SCHED_NAME`     varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_NAME`   varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `TRIGGER_GROUP`  varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `JOB_NAME`       varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `JOB_GROUP`      varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `DESCRIPTION`    varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `NEXT_FIRE_TIME` bigint NULL DEFAULT NULL,
    `PREV_FIRE_TIME` bigint NULL DEFAULT NULL,
    `PRIORITY`       int NULL DEFAULT NULL,
    `TRIGGER_STATE`  varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL,
    `TRIGGER_TYPE`   varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci   NOT NULL,
    `START_TIME`     bigint                                                        NOT NULL,
    `END_TIME`       bigint NULL DEFAULT NULL,
    `CALENDAR_NAME`  varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
    `MISFIRE_INSTR`  smallint NULL DEFAULT NULL,
    `JOB_DATA`       blob NULL,
    PRIMARY KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) USING BTREE,
    INDEX            `IDX_QRTZ_T_J`(`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) USING BTREE,
    INDEX            `IDX_QRTZ_T_JG`(`SCHED_NAME`, `JOB_GROUP`) USING BTREE,
    INDEX            `IDX_QRTZ_T_C`(`SCHED_NAME`, `CALENDAR_NAME`) USING BTREE,
    INDEX            `IDX_QRTZ_T_G`(`SCHED_NAME`, `TRIGGER_GROUP`) USING BTREE,
    INDEX            `IDX_QRTZ_T_STATE`(`SCHED_NAME`, `TRIGGER_STATE`) USING BTREE,
    INDEX            `IDX_QRTZ_T_N_STATE`(`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`, `TRIGGER_STATE`) USING BTREE,
    INDEX            `IDX_QRTZ_T_N_G_STATE`(`SCHED_NAME`, `TRIGGER_GROUP`, `TRIGGER_STATE`) USING BTREE,
    INDEX            `IDX_QRTZ_T_NEXT_FIRE_TIME`(`SCHED_NAME`, `NEXT_FIRE_TIME`) USING BTREE,
    INDEX            `IDX_QRTZ_T_NFT_ST`(`SCHED_NAME`, `TRIGGER_STATE`, `NEXT_FIRE_TIME`) USING BTREE,
    INDEX            `IDX_QRTZ_T_NFT_MISFIRE`(`SCHED_NAME`, `MISFIRE_INSTR`, `NEXT_FIRE_TIME`) USING BTREE,
    INDEX            `IDX_QRTZ_T_NFT_ST_MISFIRE`(`SCHED_NAME`, `MISFIRE_INSTR`, `NEXT_FIRE_TIME`, `TRIGGER_STATE`) USING BTREE,
    INDEX            `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP`(`SCHED_NAME`, `MISFIRE_INSTR`, `NEXT_FIRE_TIME`, `TRIGGER_GROUP`, `TRIGGER_STATE`) USING BTREE,
    CONSTRAINT `TB_QRTZ_TRIGGERS_IBFK_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `tb_qrtz_job_details` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_resource
-- ----------------------------
DROP TABLE IF EXISTS `tb_resource`;
CREATE TABLE `tb_resource`
(
    `id`            bigint UNSIGNED NOT NULL COMMENT '主键',
    `dept_id`       bigint UNSIGNED NOT NULL COMMENT '部门ID',
    `tenant_id`     bigint UNSIGNED NOT NULL COMMENT '租户ID',
    `resource_type` int                                                           NOT NULL COMMENT '素材类型',
    `resource_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '素材名称',
    `suffix`        varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL COMMENT '后缀',
    `resource_url`  varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '素材地址',
    `origin`        int                                                           NOT NULL DEFAULT 0 COMMENT '素材来源',
    `status`        int                                                           NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`       datetime                                                      NOT NULL COMMENT '创建时间',
    `created_by`    bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`      datetime                                                      NOT NULL COMMENT '修改时间',
    `modified_by`   bigint UNSIGNED NOT NULL COMMENT '修改者',
    `options`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '扩展项',
    `file_size`     bigint UNSIGNED NULL DEFAULT NULL COMMENT '文件大小',
    `category_id`   bigint UNSIGNED NULL DEFAULT NULL COMMENT '分类ID',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '素材库' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_resource_category
-- ----------------------------
DROP TABLE IF EXISTS `tb_resource_category`;
CREATE TABLE `tb_resource_category`
(
    `id`            bigint UNSIGNED NOT NULL COMMENT '主键',
    `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
    `sort_no`       int NULL DEFAULT 0 COMMENT '排序',
    `created`       datetime                                                     NOT NULL COMMENT '创建时间',
    `created_by`    bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`      datetime                                                     NOT NULL COMMENT '修改时间',
    `modified_by`   bigint UNSIGNED NOT NULL COMMENT '修改者',
    `status`        int                                                          NOT NULL DEFAULT 0 COMMENT '数据状态',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '素材分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_sys_account
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_account`;
CREATE TABLE `tb_sys_account`
(
    `id`           bigint UNSIGNED NOT NULL COMMENT '主键',
    `dept_id`      bigint UNSIGNED NOT NULL COMMENT '部门ID',
    `tenant_id`    bigint UNSIGNED NOT NULL COMMENT '租户ID',
    `login_name`   varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL COMMENT '登录账号',
    `password`     varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
    `account_type` tinyint                                                       NOT NULL DEFAULT 0 COMMENT '账户类型',
    `nickname`     varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '昵称',
    `mobile`       varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机电话',
    `email`        varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '邮件',
    `avatar`       varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '账户头像',
    `status`       int                                                           NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`      datetime                                                      NOT NULL COMMENT '创建时间',
    `created_by`   bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`     datetime                                                      NOT NULL COMMENT '修改时间',
    `modified_by`  bigint UNSIGNED NOT NULL COMMENT '修改者',
    `remark`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uni_login_name`(`login_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_account_position
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_account_position`;
CREATE TABLE `tb_sys_account_position`
(
    `id`          bigint UNSIGNED NOT NULL COMMENT '主键',
    `account_id`  bigint UNSIGNED NOT NULL COMMENT '用户ID',
    `position_id` bigint UNSIGNED NOT NULL COMMENT '职位ID',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户-职位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_account_role
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_account_role`;
CREATE TABLE `tb_sys_account_role`
(
    `id`         bigint UNSIGNED NOT NULL COMMENT '主键',
    `account_id` bigint UNSIGNED NOT NULL COMMENT '用户ID',
    `role_id`    bigint UNSIGNED NOT NULL COMMENT '角色ID',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户-角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_api_key
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_api_key`;
CREATE TABLE `tb_sys_api_key`
(
    `id`         bigint UNSIGNED NOT NULL COMMENT 'id',
    `api_key`    varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'apiKey',
    `created`    datetime NULL DEFAULT NULL COMMENT '创建时间',
    `status`     int NOT NULL DEFAULT 0 COMMENT '数据状态',
    `dept_id`    bigint UNSIGNED NULL DEFAULT NULL COMMENT '部门id',
    `tenant_id`  bigint UNSIGNED NULL DEFAULT NULL COMMENT '租户id',
    `expired_at` datetime NULL DEFAULT NULL COMMENT '失效时间',
    `created_by` bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建人',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'apikey表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_api_key_resource
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_api_key_resource`;
CREATE TABLE `tb_sys_api_key_resource`
(
    `id`                bigint UNSIGNED NOT NULL COMMENT 'id',
    `request_interface` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '请求接口',
    `title`             varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标题',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE KEY `uni_api` (`request_interface`)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '请求接口表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_sys_api_key_resource_mapping
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_api_key_resource_mapping`;
CREATE TABLE `tb_sys_api_key_resource_mapping`
(
    `id`                  bigint UNSIGNED NOT NULL COMMENT 'id',
    `api_key_id`          bigint UNSIGNED NOT NULL COMMENT 'api_key_id',
    `api_key_resource_id` bigint UNSIGNED NOT NULL COMMENT '请求接口资源访问id',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'apikey-请求接口表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_dept`;
CREATE TABLE `tb_sys_dept`
(
    `id`          bigint UNSIGNED NOT NULL COMMENT '主键',
    `tenant_id`   bigint UNSIGNED NOT NULL COMMENT '租户ID',
    `parent_id`   bigint UNSIGNED NOT NULL COMMENT '父级ID',
    `ancestors`   varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '父级部门ID集合',
    `dept_name`   varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '部门名称',
    `dept_code`   varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门编码',
    `sort_no`     int NULL DEFAULT 0 COMMENT '排序',
    `status`      int                                                           NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`     datetime                                                      NOT NULL COMMENT '创建时间',
    `created_by`  bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`    datetime                                                      NOT NULL COMMENT '修改时间',
    `modified_by` bigint UNSIGNED NOT NULL COMMENT '修改者',
    `remark`      varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_dict`;
CREATE TABLE `tb_sys_dict`
(
    `id`          bigint UNSIGNED NOT NULL COMMENT '主键',
    `name`        varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '数据字典名称',
    `code`        varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '字典编码',
    `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字典描述或备注',
    `dict_type`   tinyint NULL DEFAULT NULL COMMENT '字典类型 1 自定义字典、2 数据表字典、 3 枚举类字典、 4 系统字典（自定义 DictLoader）',
    `sort_no`     int NULL DEFAULT NULL COMMENT '排序编号',
    `status`      int                                                          NOT NULL DEFAULT 0 COMMENT '数据状态',
    `options`     text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '扩展字典  存放 json',
    `created`     datetime NULL DEFAULT NULL COMMENT '创建时间',
    `modified`    datetime NULL DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `key`(`code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统字典表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_dict_item
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_dict_item`;
CREATE TABLE `tb_sys_dict_item`
(
    `id`          bigint UNSIGNED NOT NULL COMMENT '主键',
    `dict_id`     bigint UNSIGNED NOT NULL COMMENT '归属哪个字典',
    `text`        varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '名称或内容',
    `value`       varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '值',
    `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
    `sort_no`     int                                                          NOT NULL DEFAULT 0 COMMENT '排序',
    `css_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'css样式内容',
    `css_class`   varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'css样式类名',
    `remark`      varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
    `status`      int                                                          NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`     datetime NULL DEFAULT NULL COMMENT '创建时间',
    `modified`    datetime NULL DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '数据字典内容' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_job
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_job`;
CREATE TABLE `tb_sys_job`
(
    `id`               bigint UNSIGNED NOT NULL COMMENT '主键',
    `dept_id`          bigint UNSIGNED NOT NULL COMMENT '部门ID',
    `tenant_id`        bigint UNSIGNED NOT NULL COMMENT '租户ID',
    `job_name`         varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
    `job_type`         int                                                           NOT NULL COMMENT '任务类型',
    `job_params`       text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '任务参数',
    `cron_expression`  varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL COMMENT 'cron表达式',
    `allow_concurrent` int                                                           NOT NULL DEFAULT 0 COMMENT '是否并发执行',
    `misfire_policy`   int                                                           NOT NULL DEFAULT 3 COMMENT '错过策略',
    `options`          text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '其他配置',
    `status`           int                                                           NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`          datetime                                                      NOT NULL COMMENT '创建时间',
    `created_by`       bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`         datetime                                                      NOT NULL COMMENT '修改时间',
    `modified_by`      bigint UNSIGNED NOT NULL COMMENT '修改者',
    `remark`           varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_job_log`;
CREATE TABLE `tb_sys_job_log`
(
    `id`         bigint UNSIGNED NOT NULL COMMENT '主键',
    `job_id`     bigint UNSIGNED NOT NULL COMMENT '任务ID',
    `job_name`   varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '任务名称',
    `job_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '任务参数',
    `job_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '执行结果',
    `error_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
    `status`     int                                                           NOT NULL DEFAULT 0 COMMENT '数据状态',
    `start_time` datetime                                                      NOT NULL COMMENT '开始时间',
    `end_time`   datetime                                                      NOT NULL COMMENT '结束时间',
    `created`    datetime                                                      NOT NULL COMMENT '创建时间',
    `remark`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统任务日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_log
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_log`;
CREATE TABLE `tb_sys_log`
(
    `id`            bigint UNSIGNED NOT NULL COMMENT 'ID',
    `account_id`    bigint UNSIGNED NULL DEFAULT NULL COMMENT '操作人',
    `action_name`   varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作名称',
    `action_type`   varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作的类型',
    `action_class`  varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作涉及的类',
    `action_method` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作涉及的方法',
    `action_url`    varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作涉及的 URL 地址',
    `action_ip`     varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作涉及的用户 IP 地址',
    `action_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '操作请求参数',
    `action_body`   text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '操作请求body',
    `status`        int NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`       datetime NULL DEFAULT NULL COMMENT '操作时间',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_menu`;
CREATE TABLE `tb_sys_menu`
(
    `id`             bigint UNSIGNED NOT NULL COMMENT '主键',
    `parent_id`      bigint UNSIGNED NOT NULL COMMENT '父菜单id',
    `menu_type`      int                                                           NOT NULL COMMENT '菜单类型',
    `menu_title`     varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单标题',
    `menu_url`       varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单url',
    `component`      varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '组件路径',
    `menu_icon`      varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '图标/图片地址',
    `is_show`        int                                                           NOT NULL DEFAULT 1 COMMENT '是否显示',
    `permission_tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '权限标识',
    `sort_no`        int NULL DEFAULT 0 COMMENT '排序',
    `status`         int                                                           NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`        datetime                                                      NOT NULL COMMENT '创建时间',
    `created_by`     bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`       datetime                                                      NOT NULL COMMENT '修改时间',
    `modified_by`    bigint UNSIGNED NOT NULL COMMENT '修改者',
    `remark`         varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_option
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_option`;
CREATE TABLE `tb_sys_option`
(
    `tenant_id` bigint UNSIGNED NOT NULL COMMENT '租户ID',
    `key`       varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置KEY',
    `value`     text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置内容',
    INDEX       `uni_key`(`tenant_id`, `key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统配置信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_position
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_position`;
CREATE TABLE `tb_sys_position`
(
    `id`            bigint UNSIGNED NOT NULL COMMENT '主键',
    `tenant_id`     bigint UNSIGNED NOT NULL COMMENT '租户ID',
    `dept_id`       bigint UNSIGNED NOT NULL COMMENT '部门ID',
    `position_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
    `position_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '岗位编码',
    `sort_no`       int NULL DEFAULT 0 COMMENT '排序',
    `status`        int                                                          NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`       datetime                                                     NOT NULL COMMENT '创建时间',
    `created_by`    bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`      datetime                                                     NOT NULL COMMENT '修改时间',
    `modified_by`   bigint UNSIGNED NOT NULL COMMENT '修改者',
    `remark`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '职位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_role
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_role`;
CREATE TABLE `tb_sys_role`
(
    `id`                  bigint UNSIGNED NOT NULL COMMENT '主键',
    `tenant_id`           bigint UNSIGNED NOT NULL COMMENT '租户ID',
    `role_name`           varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
    `role_key`            varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色标识',
    `status`              int                                                          NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created`             datetime                                                     NOT NULL COMMENT '创建时间',
    `created_by`          bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`            datetime                                                     NOT NULL COMMENT '修改时间',
    `modified_by`         bigint UNSIGNED NOT NULL COMMENT '修改者',
    `remark`              varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
    `data_scope`          int NULL DEFAULT 1 COMMENT '数据权限(EnumDataScope)',
    `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
    `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uni_tenant_role`(`tenant_id`, `role_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统角色' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_role_dept`;
CREATE TABLE `tb_sys_role_dept`
(
    `id`      bigint UNSIGNED NOT NULL COMMENT '主键',
    `role_id` bigint UNSIGNED NOT NULL COMMENT '角色ID',
    `dept_id` bigint UNSIGNED NOT NULL COMMENT '部门ID',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色-部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_role_menu`;
CREATE TABLE `tb_sys_role_menu`
(
    `id`      bigint UNSIGNED NOT NULL COMMENT '主键',
    `role_id` bigint UNSIGNED NOT NULL COMMENT '角色ID',
    `menu_id` bigint UNSIGNED NOT NULL COMMENT '菜单ID',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色-菜单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_workflow
-- ----------------------------
DROP TABLE IF EXISTS `tb_workflow`;
CREATE TABLE `tb_workflow`
(
    `id`           bigint UNSIGNED NOT NULL COMMENT 'ID 主键',
    `alias`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '别名',
    `dept_id`      bigint UNSIGNED NOT NULL COMMENT '部门ID',
    `tenant_id`    bigint UNSIGNED NOT NULL COMMENT '租户ID',
    `title`        varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
    `description`  varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
    `icon`         varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'ICON',
    `content`      text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '工作流设计的 JSON 内容',
    `created`      datetime NULL DEFAULT NULL COMMENT '创建时间',
    `created_by`   bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建人',
    `modified`     datetime NULL DEFAULT NULL COMMENT '最后修改时间',
    `modified_by`  bigint UNSIGNED NULL DEFAULT NULL COMMENT '最后修改的人',
    `english_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '英文名称',
    `status`       int                                                           NOT NULL DEFAULT 0 COMMENT '数据状态',
    `category_id`  bigint UNSIGNED NULL DEFAULT NULL COMMENT '分类ID',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `tb_ai_workflow_alias_uindex`(`alias`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工作流' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_workflow_category
-- ----------------------------
DROP TABLE IF EXISTS `tb_workflow_category`;
CREATE TABLE `tb_workflow_category`
(
    `id`            bigint UNSIGNED NOT NULL COMMENT '主键',
    `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
    `sort_no`       int NULL DEFAULT 0 COMMENT '排序',
    `created`       datetime                                                     NOT NULL COMMENT '创建时间',
    `created_by`    bigint UNSIGNED NOT NULL COMMENT '创建者',
    `modified`      datetime                                                     NOT NULL COMMENT '修改时间',
    `modified_by`   bigint UNSIGNED NOT NULL COMMENT '修改者',
    `status`        int                                                          NOT NULL DEFAULT 0 COMMENT '数据状态',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工作流分类' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_workflow_exec_result
-- ----------------------------
DROP TABLE IF EXISTS `tb_workflow_exec_result`;
CREATE TABLE `tb_workflow_exec_result`
(
    `id`            bigint UNSIGNED NOT NULL COMMENT '主键',
    `exec_key`      varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行标识',
    `workflow_id`   bigint UNSIGNED NOT NULL COMMENT '工作流ID',
    `title`         varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标题',
    `description`   varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
    `input`         text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '输入',
    `output`        text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '输出',
    `workflow_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '工作流执行时的配置',
    `start_time`    datetime(3) NOT NULL COMMENT '开始时间',
    `end_time`      datetime(3) NULL DEFAULT NULL COMMENT '结束时间',
    `tokens`        bigint UNSIGNED NULL DEFAULT NULL COMMENT '消耗总token',
    `status`        int                                                           NOT NULL DEFAULT 0 COMMENT '数据状态',
    `created_key`   varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行人标识[有可能是用户|外部|定时任务等情况]',
    `created_by`    varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '执行人',
    `error_info`    text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uni_exec_key`(`exec_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工作流执行记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_workflow_exec_step
-- ----------------------------
DROP TABLE IF EXISTS `tb_workflow_exec_step`;
CREATE TABLE `tb_workflow_exec_step`
(
    `id`         bigint UNSIGNED NOT NULL COMMENT '主键',
    `record_id`  bigint UNSIGNED NOT NULL COMMENT '执行记录ID',
    `exec_key`   varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '执行标识',
    `node_id`    varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '节点ID',
    `node_name`  varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL COMMENT '节点名称',
    `input`      longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '输入',
    `output`     longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '输出',
    `node_data`  text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '节点信息',
    `start_time` datetime(3) NOT NULL COMMENT '开始时间',
    `end_time`   datetime(3) NULL DEFAULT NULL COMMENT '结束时间',
    `tokens`     bigint UNSIGNED NULL DEFAULT NULL COMMENT '消耗总token',
    `status`     int                                                           NOT NULL DEFAULT 0 COMMENT '数据状态',
    `error_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE INDEX `uni_exec`(`exec_key`) USING BTREE,
    INDEX        `idx_record_id`(`record_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '执行记录步骤' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for tb_sys_user_feedback
-- ----------------------------
DROP TABLE IF EXISTS `tb_sys_user_feedback`;
CREATE TABLE `tb_sys_user_feedback`
(
    `id`               bigint(0) UNSIGNED NOT NULL COMMENT '主键id',
    `feedback_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '问题摘要',
    `feedback_type`    int(0) NOT NULL COMMENT '问题类型（1-功能故障 2-优化建议 3-账号问题 4-其他）',
    `contact_info`     varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系方式【手机号/邮箱】',
    `attachment_url`   text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '附件url',
    `status`           int(0) NULL DEFAULT NULL COMMENT '反馈处理状态（0-未查看 1-已查看 2-已处理）',
    `handler_id`       bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT '处理人id',
    `handle_time`      datetime(0) NULL DEFAULT NULL COMMENT '处理时间',
    `dept_id`          bigint(0) UNSIGNED NOT NULL COMMENT '部门ID',
    `tenant_id`        bigint(0) UNSIGNED NOT NULL COMMENT '租户ID',
    `created`          datetime(0) NOT NULL COMMENT '创建时间',
    `created_by`       bigint(0) UNSIGNED NOT NULL COMMENT '创建人',
    `modified`         datetime(0) NULL DEFAULT NULL COMMENT '最后修改时间',
    `modified_by`      bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT '最后修改的人',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_mcp
-- ----------------------------
DROP TABLE IF EXISTS `tb_mcp`;
CREATE TABLE `tb_mcp`
(
    `id`          bigint(0) UNSIGNED NOT NULL COMMENT 'id',
    `title`       varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
    `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
    `config_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '完整MCP配置JSON',
    `dept_id`     bigint(0) UNSIGNED NOT NULL COMMENT '部门ID',
    `tenant_id`   bigint(0) UNSIGNED NOT NULL COMMENT '租户ID',
    `created`     datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
    `created_by`  bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT '创建者ID',
    `modified`    datetime(0) NULL DEFAULT NULL COMMENT '修改时间',
    `modified_by` bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT '修改者ID',
    `status`      tinyint(1) NULL DEFAULT 0 COMMENT '是否启用',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'mcp表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_bot_mcp
-- ----------------------------
DROP TABLE IF EXISTS `tb_bot_mcp`;
CREATE TABLE `tb_bot_mcp`
(
    `id`                   bigint(0) UNSIGNED NOT NULL COMMENT 'id',
    `bot_id`               bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT 'botId',
    `mcp_id`               bigint(0) UNSIGNED NULL DEFAULT NULL COMMENT 'mcpId',
    `mcp_tool_name`        varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'mcp工具名称',
    `mcp_tool_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT 'mcp工具描述',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for tb_vector_database
-- ----------------------------
DROP TABLE IF EXISTS `tb_vector_database`;
CREATE TABLE `tb_vector_database`
(
    `id`             bigint UNSIGNED NOT NULL COMMENT '主键ID',
    `dept_id`        bigint UNSIGNED NOT NULL COMMENT '部门ID',
    `tenant_id`      bigint UNSIGNED NOT NULL COMMENT '租户ID',
    `title`          varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '名称',
    `type`           varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '向量数据库类型',
    `config_options` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '向量数据库配置',
    `options`        text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '选项',
    `created`        datetime NULL DEFAULT NULL COMMENT '创建时间',
    `created_by`     bigint UNSIGNED NULL DEFAULT NULL COMMENT '创建者ID',
    `modified`       datetime NULL DEFAULT NULL COMMENT '修改时间',
    `modified_by`    bigint UNSIGNED NULL DEFAULT NULL COMMENT '修改者ID',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '向量数据库表' ROW_FORMAT = Dynamic;

-- since v2.1.2
CREATE TABLE `tb_wiki`
(
    `id`               bigint unsigned NOT NULL COMMENT '主键ID',
    `parent_id`        bigint unsigned NOT NULL COMMENT '父ID',
    `category_id`      bigint unsigned DEFAULT NULL COMMENT '分类ID',
    `type`             int    NOT NULL COMMENT '类型1目录2正文',
    `file_url`         varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '原文件地址',
    `title`            varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标题',
    `description`      varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '描述',
    `content`          longtext COMMENT '内容',
    `recognition_mode` int                                                           DEFAULT NULL COMMENT '识别方式1普通识别2OCR识别',
    `ocr_model_id`     bigint unsigned DEFAULT NULL COMMENT 'ocr模型id',
    `task_id`          varchar(100)                                                  DEFAULT NULL COMMENT '任务ID',
    `task_status`      int                                                           DEFAULT '0' COMMENT '任务状态0无任务1进行中2任务完成3任务失败',
    `fail_reason`      varchar(255)                                                  DEFAULT NULL COMMENT '任务失败原因',
    `dept_id`          bigint unsigned NOT NULL COMMENT '部门ID',
    `tenant_id`        bigint unsigned NOT NULL COMMENT '租户ID',
    `status`           int                                                           DEFAULT '0' COMMENT '数据状态',
    `options`          text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '选项',
    `created`          datetime                                                      DEFAULT NULL COMMENT '创建时间',
    `created_by`       bigint unsigned DEFAULT NULL COMMENT '创建者ID',
    `modified`         datetime                                                      DEFAULT NULL COMMENT '修改时间',
    `modified_by`      bigint unsigned DEFAULT NULL COMMENT '修改者ID',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='wiki';

CREATE TABLE `tb_wiki_category`
(
    `id`            bigint unsigned NOT NULL COMMENT '主键',
    `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
    `sort_no`       int                                                                   DEFAULT '0' COMMENT '排序',
    `status`        int                                                          NOT NULL DEFAULT '0' COMMENT '数据状态',
    `created`       datetime                                                     NOT NULL COMMENT '创建时间',
    `created_by`    bigint unsigned NOT NULL COMMENT '创建者',
    `modified`      datetime                                                     NOT NULL COMMENT '修改时间',
    `modified_by`   bigint unsigned NOT NULL COMMENT '修改者',
    `dept_id`       bigint unsigned NOT NULL COMMENT '部门ID',
    `tenant_id`     bigint unsigned NOT NULL COMMENT '租户ID',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='wiki分类';

CREATE TABLE `tb_bot_wiki`
(
    `id`      bigint unsigned NOT NULL,
    `bot_id`  bigint unsigned DEFAULT NULL,
    `wiki_id` bigint unsigned DEFAULT NULL,
    `options` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='bot绑定的wiki';


SET
FOREIGN_KEY_CHECKS = 1;
