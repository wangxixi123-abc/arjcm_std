/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50724
 Source Host           : localhost:3306
 Source Schema         : arjccm_wc20190806

 Target Server Type    : MySQL
 Target Server Version : 50724
 File Encoding         : 65001

 Date: 09/02/2020 05:59:44
*/

-- 新增表   by maoxb  2020-02-09  start-----------------------------------------------------------------------------------------------------------------------

-- ----------------------------
-- Table structure for ccm_relief_notify
-- ----------------------------
DROP TABLE IF EXISTS `ccm_relief_notify`;
CREATE TABLE `ccm_relief_notify`  (
  `id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '主键id',
  `task_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '任务ID',
  `receive_user_id` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '接收备勤任务人员',
  `type` char(10) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '通知类型',
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '标题',
  `content` varchar(2000) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '内容',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '任务状态',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '创建者',
  `create_date` datetime(0) NOT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT '更新者',
  `update_date` datetime(0) NOT NULL COMMENT '更新时间',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '备注信息',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '0' COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '备勤任务通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ccm_relief_task
-- ----------------------------
DROP TABLE IF EXISTS `ccm_relief_task`;
CREATE TABLE `ccm_relief_task`  (
  `id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 唯一主键ID ',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 创建者 ',
  `create_date` datetime(0) NOT NULL COMMENT ' 创建时间 ',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 更新者 ',
  `update_date` datetime(0) NOT NULL COMMENT ' 更新时间 ',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 备注信息 ',
  `del_flag` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 删除标记 ',
  `task_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `relief_level` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '备勤等级',
  `relief_type` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '备勤类别',
  `start_time` datetime(0) NULL DEFAULT NULL COMMENT '集结时间',
  `mass_address` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '集结地点',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '备勤时间',
  `relief_dept` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备勤参与部门',
  `relief_number` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '每个单位人数',
  `review_status` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核状态',
  `road_line` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备勤路线',
  `area_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备勤辖区',
  `relief_dept_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备勤参与部门名称',
  `auditing_status` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '审核状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '备勤任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ccm_relief_unit
-- ----------------------------
DROP TABLE IF EXISTS `ccm_relief_unit`;
CREATE TABLE `ccm_relief_unit`  (
  `id` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT ' 唯一主键ID（自增） ',
  `user_id` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 备勤人员 ',
  `missions_id` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '备勤任务',
  `patrol_vehicles` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备勤车辆',
  `more1` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 冗余字段1 ',
  `more2` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 冗余字段2 ',
  `departure_time` datetime(0) NULL DEFAULT NULL COMMENT ' 接受时间 ',
  `status` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务状态 ',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 创建者 ',
  `create_date` datetime(0) NOT NULL COMMENT ' 发生时间 ',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 更新者 ',
  `update_date` datetime(0) NOT NULL COMMENT ' 更新时间 ',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 描述信息 ',
  `del_flag` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 删除标记 ',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ccm_alarm_log_update_date`(`update_date`) USING BTREE,
  INDEX `ccm_alarm_log_del_flag`(`del_flag`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci COMMENT = '备勤单位 ' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------
-- Table structure for ccm_patrol_missions
-- ----------------------------
DROP TABLE IF EXISTS `ccm_patrol_missions`;
CREATE TABLE `ccm_patrol_missions`  (
  `id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 唯一主键ID（自增） ',
  `patrol_content` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 巡逻任务 ',
  `patrol_time` datetime(0) NULL DEFAULT NULL COMMENT ' 巡逻时间 ',
  `office_id` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 参与单位 ',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '任务结束时间',
  `number` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 每个单位人数 ',
  `patrol_routes` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 巡逻路线 ',
  `area_id` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 巡逻辖区 ',
  `status` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 状态 ',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 创建者 ',
  `create_date` datetime(0) NOT NULL COMMENT ' 发生时间 ',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 更新者 ',
  `update_date` datetime(0) NOT NULL COMMENT ' 更新时间 ',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 描述信息 ',
  `del_flag` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 删除标记 ',
  `auditing_status` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '审核状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ccm_alarm_log_update_date`(`update_date`) USING BTREE,
  INDEX `ccm_alarm_log_del_flag`(`del_flag`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci COMMENT = '巡逻任务 ' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ccm_patrol_security
-- ----------------------------
DROP TABLE IF EXISTS `ccm_patrol_security`;
CREATE TABLE `ccm_patrol_security`  (
  `id` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 唯一主键ID（自增） ',
  `user_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 巡逻民警 ',
  `security_time` datetime(0) NULL DEFAULT NULL COMMENT ' 警卫时间 ',
  `end_time` datetime(0) NULL DEFAULT NULL COMMENT '结束时间',
  `office_id` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 参与单位 ',
  `title` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务标题',
  `number_units` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 单位人数 ',
  `guard_line` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 警卫线路 ',
  `collection_time` datetime(0) NULL DEFAULT NULL COMMENT ' 集合时间 ',
  `collection_place` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 集合地点 ',
  `status` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 状态 ',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 创建者 ',
  `create_date` datetime(0) NOT NULL COMMENT ' 发生时间 ',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 更新者 ',
  `update_date` datetime(0) NOT NULL COMMENT ' 更新时间 ',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 描述信息 ',
  `del_flag` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 删除标记 ',
  `auditing_status` varchar(5) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '审核状态',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ccm_alarm_log_update_date`(`update_date`) USING BTREE,
  INDEX `ccm_alarm_log_del_flag`(`del_flag`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '警卫管理 ' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for ccm_patrol_unit
-- ----------------------------
DROP TABLE IF EXISTS `ccm_patrol_unit`;
CREATE TABLE `ccm_patrol_unit`  (
  `id` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT ' 唯一主键ID（自增） ',
  `user_id` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 巡逻民警 ',
  `missions_id` varchar(128) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL COMMENT '巡逻任务',
  `patrol_vehicles` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '巡逻车辆',
  `vehicle_equipment` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 车载设备 ',
  `individual_equipment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 单兵装备 ',
  `departure_time` datetime(0) NULL DEFAULT NULL COMMENT ' 时间 ',
  `status` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 状态 ',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 创建者 ',
  `create_date` datetime(0) NOT NULL COMMENT ' 发生时间 ',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 更新者 ',
  `update_date` datetime(0) NOT NULL COMMENT ' 更新时间 ',
  `remarks` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT ' 描述信息 ',
  `del_flag` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT ' 删除标记 ',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `ccm_alarm_log_update_date`(`update_date`) USING BTREE,
  INDEX `ccm_alarm_log_del_flag`(`del_flag`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci COMMENT = '巡逻单位 ' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;

-- 新增表   by maoxb  2020-02-09  end -----------------------------------------------------------------------------------------------------------------------

-- 新增菜单  by maoxb   2020-02-07 start -----------------------------------------------------------------------------------------------------------------------
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('87c6bcb15e4045809e8c1e152b38011a', '29ddedacbae94e89ab07e9ebe8e558c8', '0,1,ef61dbc7960f4272b360de7ad7d59a07,aa8bc4b271cf4b0ea85406e8d654f909,29ddedacbae94e89ab07e9ebe8e558c8,', '编辑', 60, '', '', '', '0', 'relief:ccmReliefTask:edit', '1', '2020-02-07 18:09:10', '1', '2020-02-07 18:09:10', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('1f81b090f6f142139933c09be2717cc3', '29ddedacbae94e89ab07e9ebe8e558c8', '0,1,ef61dbc7960f4272b360de7ad7d59a07,aa8bc4b271cf4b0ea85406e8d654f909,29ddedacbae94e89ab07e9ebe8e558c8,', '显示', 30, '', '', '', '0', 'relief:ccmReliefTask:view', '1', '2020-02-07 18:08:30', '1', '2020-02-07 18:08:30', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('770581b5892c4cb8b714bccd6cd14019', '5977b1806ddf41c3baea18e7482dd724', '0,1,ef61dbc7960f4272b360de7ad7d59a07,1cff269b7cb248659118a3bdded9c0fe,5977b1806ddf41c3baea18e7482dd724,', '编辑', 60, '', '', '', '0', 'guard:ccmGuardUnit:edit', '1', '2020-02-07 18:06:53', '1', '2020-02-07 18:06:53', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('bdb5897d7bb64dd598396a0b4e46be3a', '5977b1806ddf41c3baea18e7482dd724', '0,1,ef61dbc7960f4272b360de7ad7d59a07,1cff269b7cb248659118a3bdded9c0fe,5977b1806ddf41c3baea18e7482dd724,', '显示', 30, '', '', '', '0', 'guard:ccmGuardUnit:view', '1', '2020-02-07 18:06:04', '1', '2020-02-07 18:06:04', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('8babf69ea7ee4b00a9aa850ab3d1c740', '932fe8c88a0142a594216f522f08f43f', '0,1,ef61dbc7960f4272b360de7ad7d59a07,1cff269b7cb248659118a3bdded9c0fe,932fe8c88a0142a594216f522f08f43f,', '编辑', 60, '', '', '', '0', 'security:ccmPatrolSecurity:edit', '1', '2020-02-07 18:05:06', '1', '2020-02-07 18:05:06', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('4512bff0d0b3469f823e7770f55b4bae', '932fe8c88a0142a594216f522f08f43f', '0,1,ef61dbc7960f4272b360de7ad7d59a07,1cff269b7cb248659118a3bdded9c0fe,932fe8c88a0142a594216f522f08f43f,', '显示', 30, '', '', '', '0', 'security:ccmPatrolSecurity:view', '1', '2020-02-07 18:04:33', '1', '2020-02-07 18:04:33', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('e5b28b4f8e1045049728b43a61d3de57', 'f3616a64107e44849f650495c127c078', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,f3616a64107e44849f650495c127c078,', '编辑', 60, '', '', '', '0', 'patrol:ccmPatrolRespoint:edit', '1', '2020-02-07 18:00:10', '1', '2020-02-07 18:03:12', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('9f9afad15d774bedb731f56205cc8c36', 'f3616a64107e44849f650495c127c078', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,f3616a64107e44849f650495c127c078,', '显示', 30, '', '', '', '0', 'patrol:ccmPatrolRespoint:view', '1', '2020-02-07 17:59:41', '1', '2020-02-07 18:02:45', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('60931632b5d3454a94f13677100db566', '61914bdbdef741b09f14bd206e8547d5', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,61914bdbdef741b09f14bd206e8547d5,', '编辑', 60, '', '', '', '0', 'patrol:ccmPatrolResult:edit', '1', '2020-02-07 17:59:10', '1', '2020-02-07 18:02:21', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('62ac297ac0c74275a313515e95280ece', '61914bdbdef741b09f14bd206e8547d5', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,61914bdbdef741b09f14bd206e8547d5,', '显示', 30, '', '', '', '0', 'patrol:ccmPatrolResult:view', '1', '2020-02-07 17:58:38', '1', '2020-02-07 18:01:57', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('414eed95bbb642f4be899934db62b3f6', '27860563c33c416191fdee296e23e93a', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,27860563c33c416191fdee296e23e93a,', '编辑', 60, '', '', '', '0', 'patrol:ccmPatrolPlan:edit', '1', '2020-02-07 17:57:41', '1', '2020-02-07 18:01:27', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('38620a634ad04fd895401170c289d48e', '27860563c33c416191fdee296e23e93a', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,27860563c33c416191fdee296e23e93a,', '显示', 30, '', '', '', '0', 'patrol:ccmPatrolPlan:view', '1', '2020-02-07 17:57:07', '1', '2020-02-07 18:01:00', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('812aa017c27647bb951f43a20b70fdd4', 'ee0acbec561e434da8371831f719ded3', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,ee0acbec561e434da8371831f719ded3,', '编辑', 60, '', '', '', '0', 'patrol:ccmPatrolUnit:edit', '1', '2020-02-07 17:34:39', '1', '2020-02-07 17:34:39', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('9a5e53f6485d4433ac10d06fe9c94e93', 'ee0acbec561e434da8371831f719ded3', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,ee0acbec561e434da8371831f719ded3,', '显示', 30, '', '', '', '0', 'patrol:ccmPatrolUnit:view', '1', '2020-02-07 17:34:06', '1', '2020-02-07 17:34:06', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('ddddad553ca2413cbed43ecb9e58fcc6', 'ff2ca21b83174ff88d1d51459c5970bb', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,ff2ca21b83174ff88d1d51459c5970bb,', '编辑', 60, '', '', '', '0', 'patrol:ccmPatrolMissions:edit', '1', '2020-02-07 17:33:27', '1', '2020-02-07 17:33:27', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('95902cb5af434cd18c17c4cf0f72959e', 'ff2ca21b83174ff88d1d51459c5970bb', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,ff2ca21b83174ff88d1d51459c5970bb,', '显示', 30, '', '', '', '0', 'patrol:ccmPatrolMissions:view', '1', '2020-02-07 17:32:24', '1', '2020-02-07 17:32:24', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('06dff2cae7b540b3a5ecabeec950296f', 'aa8bc4b271cf4b0ea85406e8d654f909', '0,1,ef61dbc7960f4272b360de7ad7d59a07,aa8bc4b271cf4b0ea85406e8d654f909,', '备勤单位', 60, '/relief/ccmReliefTask/arrangement', '', '', '1', '', '1', '2020-02-07 17:28:09', '1', '2020-02-07 17:28:09', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('29ddedacbae94e89ab07e9ebe8e558c8', 'aa8bc4b271cf4b0ea85406e8d654f909', '0,1,ef61dbc7960f4272b360de7ad7d59a07,aa8bc4b271cf4b0ea85406e8d654f909,', '备勤任务', 30, '/relief/ccmReliefTask', '', '', '1', '', '1', '2020-02-07 17:26:42', '1', '2020-02-07 17:26:42', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('cee99b69711b453cb1c012b592936264', 'e1ea142288174ff9be2ae602d07af1f9', '0,1,ef61dbc7960f4272b360de7ad7d59a07,e1ea142288174ff9be2ae602d07af1f9,', '警情管理', 30, '/alarm/bphAlarmInfo/index', '', '', '1', '', '1', '2020-02-07 17:24:50', '1', '2020-02-07 17:24:50', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('5977b1806ddf41c3baea18e7482dd724', '1cff269b7cb248659118a3bdded9c0fe', '0,1,ef61dbc7960f4272b360de7ad7d59a07,1cff269b7cb248659118a3bdded9c0fe,', '警卫单位', 60, '/guard/ccmGuardUnit/securityList/', '', '', '1', '', '1', '2020-02-07 17:23:50', '1', '2020-02-07 17:23:50', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('932fe8c88a0142a594216f522f08f43f', '1cff269b7cb248659118a3bdded9c0fe', '0,1,ef61dbc7960f4272b360de7ad7d59a07,1cff269b7cb248659118a3bdded9c0fe,', '警卫管理', 30, '/security/ccmPatrolSecurity/', '', '', '1', '', '1', '2020-02-07 17:22:00', '1', '2020-02-07 17:22:00', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('f3616a64107e44849f650495c127c078', 'c4b65a69d07b4907b379fcda304d71b2', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,', '巡逻点位结果', 180, '/patrol/ccmPatrolRespoint', '', '', '0', '', '1', '2020-02-07 17:19:15', '1', '2020-02-07 17:19:15', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('61914bdbdef741b09f14bd206e8547d5', 'c4b65a69d07b4907b379fcda304d71b2', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,', '巡逻结果', 150, '/patrol/ccmPatrolResult', '', '', '0', '', '1', '2020-02-07 17:18:32', '1', '2020-02-07 17:18:32', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('27860563c33c416191fdee296e23e93a', 'c4b65a69d07b4907b379fcda304d71b2', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,', '巡逻计划', 120, '/patrol/ccmPatrolPlan', '', '', '0', '', '1', '2020-02-07 17:17:52', '1', '2020-02-07 17:17:52', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('ee0acbec561e434da8371831f719ded3', 'c4b65a69d07b4907b379fcda304d71b2', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,', '巡逻单位', 90, '/patrol/ccmPatrolMissions/arrangement', '', '', '1', '', '1', '2020-02-07 17:16:56', '1', '2020-02-07 17:16:56', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('ff2ca21b83174ff88d1d51459c5970bb', 'c4b65a69d07b4907b379fcda304d71b2', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,', '巡逻任务', 60, '/patrol/ccmPatrolMissions/summaryGraph', '', '', '1', '', '1', '2020-02-07 17:15:08', '1', '2020-02-07 17:15:08', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('1478dbf040b84903b55e79de608cda3b', 'c4b65a69d07b4907b379fcda304d71b2', '0,1,ef61dbc7960f4272b360de7ad7d59a07,c4b65a69d07b4907b379fcda304d71b2,', '巡逻报告', 30, '/patrol/patrolReport/', '', '', '1', '', '1', '2020-02-07 17:12:46', '1', '2020-02-07 17:12:46', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('aa8bc4b271cf4b0ea85406e8d654f909', 'ef61dbc7960f4272b360de7ad7d59a07', '0,1,ef61dbc7960f4272b360de7ad7d59a07,', '备勤任务管理', 480, '', '', 'step-forward', '1', '', '1', '2020-02-07 17:09:53', '1', '2020-02-07 17:09:53', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('e1ea142288174ff9be2ae602d07af1f9', 'ef61dbc7960f4272b360de7ad7d59a07', '0,1,ef61dbc7960f4272b360de7ad7d59a07,', '警情信息查询', 450, '', '', 'camera', '1', '', '1', '2020-02-07 17:08:50', '1', '2020-02-07 17:08:50', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('1cff269b7cb248659118a3bdded9c0fe', 'ef61dbc7960f4272b360de7ad7d59a07', '0,1,ef61dbc7960f4272b360de7ad7d59a07,', '警卫任务管理', 420, '', '', 'forward', '1', '', '1', '2020-02-07 17:07:54', '1', '2020-02-07 17:07:54', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('c4b65a69d07b4907b379fcda304d71b2', 'ef61dbc7960f4272b360de7ad7d59a07', '0,1,ef61dbc7960f4272b360de7ad7d59a07,', '巡逻管理', 390, '', '', 'richanggongzuo1', '1', '', '1', '2020-02-07 17:06:12', '1', '2020-02-07 17:06:12', '', '0');
INSERT INTO `sys_menu`(`id`, `parent_id`, `parent_ids`, `name`, `sort`, `href`, `target`, `icon`, `is_show`, `permission`, `create_by`, `create_date`, `update_by`, `update_date`, `remarks`, `del_flag`) VALUES ('ea38f2936cae4276848bd888a7322aab', '3119b31a022645a78d4ebbe9b767b5f9', '0,1,ef61dbc7960f4272b360de7ad7d59a07,3119b31a022645a78d4ebbe9b767b5f9,', '警情通知', 70, '/alarmnotify/bphAlarmNotify/', '', '', '1', 'alarmnotify:bphAlarmNotify:view,alarmnotify:bphAlarmNotify:edit', '1', '2019-12-05 14:02:50', '1', '2019-12-05 14:02:50', '', '0');

-- 新增菜单  by maoxb   2020-02-07 end -----------------------------------------------------------------------------------------------------------------------