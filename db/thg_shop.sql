-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- 主机： 127.0.0.1
-- 生成日期： 2020-12-08 09:54:14
-- 服务器版本： 10.4.6-MariaDB
-- PHP 版本： 7.3.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `thg_shop`
--
CREATE DATABASE IF NOT EXISTS `thg_shop` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `thg_shop`;

-- --------------------------------------------------------

--
-- 表的结构 `admin_info`
--

CREATE TABLE `admin_info` (
  `admin_id` int(11) NOT NULL,
  `account` varchar(20) NOT NULL,
  `password` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `admin_info`
--

INSERT INTO `admin_info` (`admin_id`, `account`, `password`) VALUES
(1, 'admin', '123');

-- --------------------------------------------------------

--
-- 表的结构 `customer_addr`
--

CREATE TABLE `customer_addr` (
  `customer_addr_id` int(10) UNSIGNED NOT NULL COMMENT '自增主键ID',
  `customer_id` int(10) UNSIGNED NOT NULL COMMENT 'customer_login表的自增ID',
  `consignee` varchar(20) NOT NULL,
  `mobile_phone` varchar(15) NOT NULL,
  `province` varchar(20) NOT NULL COMMENT '地区表中省份的ID',
  `city` varchar(20) NOT NULL COMMENT '地区表中城市的ID',
  `district` varchar(20) NOT NULL COMMENT '地区表中的区ID',
  `address` varchar(200) NOT NULL COMMENT '具体的地址门牌号',
  `addr_code` varchar(30) NOT NULL COMMENT '地址code["pro","city","dis"]',
  `is_default` tinyint(4) NOT NULL COMMENT '是否默认',
  `another_name` varchar(30) DEFAULT NULL COMMENT '用户地址别名',
  `modified_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '最后修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户地址表';

--
-- 转存表中的数据 `customer_addr`
--

INSERT INTO `customer_addr` (`customer_addr_id`, `customer_id`, `consignee`, `mobile_phone`, `province`, `city`, `district`, `address`, `addr_code`, `is_default`, `another_name`, `modified_time`) VALUES
(92, 1, '张杰', '18323123123', '内蒙古自治区', '通辽市', '市辖区', '王企鹅无群', '[\"150000\",\"150500\",\"150501\"]', 0, NULL, '2020-10-20 08:53:51'),
(97, 1, '张三', '15323154646', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, NULL, '2020-11-11 13:41:36'),
(98, 26, '李四', '15365656565', '北京市', '市辖区', '东城区', '按时大大', '[\"110000\",\"110100\",\"110101\"]', 1, NULL, '2020-11-15 06:35:02');

-- --------------------------------------------------------

--
-- 表的结构 `customer_inf`
--

CREATE TABLE `customer_inf` (
  `customer_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `nick_name` varchar(50) NOT NULL DEFAULT '惠购达人' COMMENT '昵称',
  `mobile_phone` varchar(11) DEFAULT 'NULL' COMMENT '手机号',
  `password` varchar(50) NOT NULL COMMENT '密码',
  `avatar` varchar(100) DEFAULT 'http://127.0.0.1:3000/images/userAvatar/avatar.png' COMMENT '用户头像',
  `customer_name` varchar(20) DEFAULT NULL COMMENT '用户真实姓名',
  `id_card_type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '证件类型：1 身份证，2 军官证，3 护照',
  `id_card_no` varchar(20) DEFAULT NULL COMMENT '证件号码',
  `customer_email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `gender` int(4) DEFAULT 0 COMMENT '性别',
  `register_time` timestamp NULL DEFAULT current_timestamp() COMMENT '注册时间',
  `birthday` date DEFAULT NULL COMMENT '会员生日',
  `pay_psd` varchar(6) DEFAULT NULL COMMENT '支付密码',
  `user_money` bigint(20) NOT NULL DEFAULT 0 COMMENT '用户余额',
  `modified_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '最后修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户信息表';

--
-- 转存表中的数据 `customer_inf`
--

INSERT INTO `customer_inf` (`customer_id`, `nick_name`, `mobile_phone`, `password`, `avatar`, `customer_name`, `id_card_type`, `id_card_no`, `customer_email`, `gender`, `register_time`, `birthday`, `pay_psd`, `user_money`, `modified_time`) VALUES
(1, 'testUser', '18368368322', '123', 'http://127.0.0.1:3000/images/userAvatar/userAvatar-1.png', '张青杰', 1, '330421200007050817', '11@qq.com', 1, '2020-10-08 08:55:12', '0000-00-00', NULL, 4585, '2020-11-16 03:59:13'),
(26, 'zhangjie', '15364564548', '123', 'http://127.0.0.1:3000/images/userAvatar/avatar.png', NULL, 1, NULL, '123@qq.com', 1, '2020-10-13 14:15:49', '2020-10-18', NULL, 200, '2020-11-15 06:36:59'),
(27, '惠购达人363', '18532356565', '123', 'http://127.0.0.1:3000/images/userAvatar/avatar.png', NULL, 1, NULL, NULL, 1, '2020-10-14 05:14:21', '2020-05-18', NULL, 0, '2020-10-16 07:49:14'),
(28, '惠购达人465628', '18365656565', '123', 'http://127.0.0.1:3000/images/userAvatar/avatar.png', NULL, 1, NULL, NULL, 0, '2020-10-15 05:44:11', NULL, NULL, 0, '2020-10-16 07:49:18'),
(64, '惠购达人232467', '18368368353', '123', 'http://127.0.0.1:3000/images/userAvatar/avatar.png', NULL, 1, NULL, NULL, 0, '2020-10-30 08:21:32', NULL, NULL, 0, '2020-11-05 07:57:12'),
(65, '惠购达人386205', '18368368325', '123', 'http://127.0.0.1:3000/images/userAvatar/avatar.png', NULL, 1, NULL, NULL, 0, '2020-11-15 06:50:10', NULL, NULL, 0, '2020-11-15 06:50:10');

-- --------------------------------------------------------

--
-- 表的结构 `help`
--

CREATE TABLE `help` (
  `help_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `help`
--

INSERT INTO `help` (`help_id`, `title`, `content`) VALUES
(1, '网页注册提示“手机号码已经注册账号”，怎么办？', '若该手机号码长期以来一直是您在使用，您可以直接使用该手机号作为账户名进行登录。如果您是新买的手机号码，建议您电脑登录淘宝网使用邮箱注册。'),
(2, '一直没有收到注册激活码怎么办？', '您可以重新尝试连接移动网络，或稍后再试。若仍旧无法接收到激活码，未激活的账户将在48小时后自动释放，释放后您可以使用该手机号码重新注册。'),
(3, '注册会员名的要求', '亲，会员名由5-25个字符组成(包括小写字母、数字、下划线、中文)，一个汉字为两个字符，且会员名不能全为数字，请按照要求设置您的会员名。'),
(4, '绑定、更换邮箱时，提示“此邮箱已注册”，怎么办？', '亲，提示 【此邮箱已注册】，是由于该邮箱已注册了网站账户，建议您更换新的邮箱后再次操作哦。'),
(5, '为什么登录时提示密码不匹配？', '可能是您输错了密码，比如字母的大小写，请确认。如果忘记密码，点击“忘记密码”找回；'),
(6, '验证时，需要我输入手机号，怎么办？', '亲，如果您遇到这种情况，您可以输入账号绑定手机号码或其他可以正常接收/发送短信的手机号进行验证哦~'),
(7, '能使用注册邮箱登录特惠购吗？', '可以。账户绑定的邮箱是可以作为登录名使用的'),
(8, '登录时，提示需要发短信，怎么办？', '亲，这是由于您的账号存在安全风险（登录环境异常，交易异常等），暂时对您的账号做了登录限制所导致的，请您根据提示编辑短信，发送后请不要关闭页面，要等待页面跳转哦~'),
(9, '为什么我换了个手机订单全没了？', '亲，如更换手机找不到购买订单，建议您确认当时购买的账户和现在登录的是否一致'),
(10, '绑定手机号有什么用？', '绑定手机主要用于您进行找回密码、修改信息时验证使用。一方面为您在购物上提供便利，同时也对您账户起到保护作用。'),
(11, '怎样设置一个更安全的密码？', '亲，如果您的密码使用时间较久，或者是和其他网站、您的邮箱的密码相同或很类似，会导致账户有一定的安全风险的哦~\r\n强烈建议您设置一个全新从未使用过的密码来使用，保证账户的安全。\r\n虽然旧的密码使用起来比较顺手，但是它很有可能已经泄露在外，在近期或未来比较长的一段时间里，都有可能被他人利用，对您的账户安全造成威胁；'),
(12, '账号长期不登录会被注销吗？', '亲，目前没有专门对长期未登录的会员名进行收回。\r\n但是，会保留对连续六个月未登录平台，且不存在未到期的有效业务的账户,进行账号回收的权利。\r\n若登录提示“该账户名不存在”，建议您重新注册账户使用哦~');

-- --------------------------------------------------------

--
-- 表的结构 `order_detail`
--

CREATE TABLE `order_detail` (
  `order_detail_id` int(10) UNSIGNED NOT NULL COMMENT '订单详情表ID',
  `order_id` int(10) UNSIGNED NOT NULL COMMENT '订单表ID',
  `product_id` int(10) UNSIGNED NOT NULL COMMENT '订单商品ID',
  `product_name` varchar(50) NOT NULL COMMENT '商品名称',
  `product_pic` varchar(100) NOT NULL COMMENT '商品图片',
  `product_cnt` int(11) NOT NULL DEFAULT 1 COMMENT '购买商品数量',
  `product_price` int(50) UNSIGNED NOT NULL COMMENT '购买商品单价',
  `product_version` varchar(100) NOT NULL COMMENT '商品规格',
  `modified_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '最后修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单详情表';

--
-- 转存表中的数据 `order_detail`
--

INSERT INTO `order_detail` (`order_detail_id`, `order_id`, `product_id`, `product_name`, `product_pic`, `product_cnt`, `product_price`, `product_version`, `modified_time`) VALUES
(98, 106, 9, '香影蕾丝连衣裙女2020秋冬装新款气质淑女半高领收腰显瘦内搭裙子', 'http://127.0.0.1:3000/images/goods/goods9/home_img.jpg', 1, 499, 'M', '2020-10-25 07:06:42'),
(99, 107, 4, ' 【至高立省200元】红米note8 4800万四摄拍照游戏学生智能手机redmi全面屏pro小米官', 'http://127.0.0.1:3000/images/goods/goods4/home_img.jpg', 1, 899, '4+64GB', '2020-10-25 12:29:06'),
(100, 108, 4, ' 【至高立省200元】红米note8 4800万四摄拍照游戏学生智能手机redmi全面屏pro小米官', 'http://127.0.0.1:3000/images/goods/goods4/home_img.jpg', 1, 899, '4+64GB', '2020-10-25 12:30:24'),
(101, 109, 3, '小米10至尊黄牛版5g手机120X变焦骁龙865小米官方旗舰店小米手机小米105g官网小米手机', 'http://127.0.0.1:3000/images/goods/goods3/home_img.jpg', 1, 5299, '8+128GB', '2020-10-26 07:26:58'),
(102, 110, 2, 'Redmi K30 至尊黄牛版 120Hz弹出屏游戏智能5g手机小米官方旗舰店官网redmi红米k3', 'http://127.0.0.1:3000/images/goods/goods2/home_img.jpg', 3, 2499, '8+512GB', '2020-10-26 09:04:42'),
(103, 111, 2, 'Redmi K30 至尊黄牛版 120Hz弹出屏游戏智能5g手机小米官方旗舰店官网redmi红米k3', 'http://127.0.0.1:3000/images/goods/goods2/home_img.jpg', 3, 1999, '6+128GB', '2020-10-26 09:05:26'),
(104, 112, 2, 'Redmi K30 至尊黄牛版 120Hz弹出屏游戏智能5g手机小米官方旗舰店官网redmi红米k3', 'http://127.0.0.1:3000/images/goods/goods2/home_img.jpg', 1, 1999, '6+128GB', '2020-10-30 03:25:10'),
(105, 113, 5, '【抢券低至2799元起】红米k30pro 骁龙865索尼6400万四摄智能游戏学生5g手机redmi', 'http://127.0.0.1:3000/images/goods/goods5/home_img.jpg', 1, 2799, '8+128GB', '2020-11-09 09:17:10'),
(106, 114, 3, '小米10至尊黄牛版5g手机120X变焦骁龙865小米官方旗舰店小米手机小米105g官网小米手机', 'http://127.0.0.1:3000/images/goods/goods3/home_img.jpg', 1, 5299, '8+128GB', '2020-11-11 11:34:31'),
(107, 115, 3, '小米10至尊黄牛版5g手机120X变焦骁龙865小米官方旗舰店小米手机小米105g官网小米手机', 'http://127.0.0.1:3000/images/goods/goods3/home_img.jpg', 1, 5999, '12+256GB', '2020-11-11 13:29:37'),
(108, 116, 11, '南极人休闲裤运动裤子夏季潮流直筒男生百搭宽松九分束脚工装裤男', 'http://127.0.0.1:3000/images/goods/goods11/home_img.jpg', 1, 79, 'M', '2020-11-13 09:33:54'),
(109, 117, 2, 'Redmi K30 至尊黄牛版 120Hz弹出屏游戏智能5g手机小米官方旗舰店官网redmi红米k3', 'http://127.0.0.1:3000/images/goods/goods2/home_img.jpg', 1, 1999, '6+128GB', '2020-11-13 09:34:19'),
(110, 118, 11, '南极人休闲裤运动裤子夏季潮流直筒男生百搭宽松九分束脚工装裤男', 'http://127.0.0.1:3000/images/goods/goods11/home_img.jpg', 1, 79, 'M', '2020-11-14 09:01:55'),
(111, 119, 12, '【新品上市 预定立减100】OPPO K7x 双模5G手机 30W VOOC闪充 90Hz电竞屏 大', 'http://127.0.0.1:3000/images/goods/goods12/home_img.jpg', 1, 1499, '6+128GB', '2020-11-14 09:02:16'),
(112, 120, 4, ' 【至高立省200元】红米note8 4800万四摄拍照游戏学生智能手机redmi全面屏pro小米官', 'http://127.0.0.1:3000/images/goods/goods4/home_img.jpg', 1, 899, '4+64GB', '2020-11-15 06:13:34'),
(113, 121, 12, '【新品上市 预定立减100】OPPO K7x 双模5G手机 30W VOOC闪充 90Hz电竞屏 大', 'http://127.0.0.1:3000/images/goods/goods12/home_img.jpg', 1, 1499, '6+128GB', '2020-11-15 06:35:12'),
(114, 122, 6, '2020年新款女装早春秋季收腰显瘦修身气质女神范流行蕾丝连衣裙子', 'http://127.0.0.1:3000/images/goods/goods6/home_img.jpg', 1, 129, 'S', '2020-11-15 06:50:49'),
(115, 123, 3, '小米10至尊黄牛版5g手机120X变焦骁龙865小米官方旗舰店小米手机小米105g官网小米手机', 'http://127.0.0.1:3000/images/goods/goods3/home_img.jpg', 1, 5299, '8+128GB', '2020-11-15 06:54:23'),
(116, 124, 11, '南极人休闲裤运动裤子夏季潮流直筒男生百搭宽松九分束脚工装裤男', 'http://127.0.0.1:3000/images/goods/goods11/home_img.jpg', 1, 79, 'L', '2020-11-15 08:39:17');

-- --------------------------------------------------------

--
-- 表的结构 `order_master`
--

CREATE TABLE `order_master` (
  `order_id` int(10) UNSIGNED NOT NULL COMMENT '订单ID',
  `order_sn` varchar(60) NOT NULL COMMENT '订单编号 yyyymmddnnnnnnnn',
  `customer_id` int(10) UNSIGNED NOT NULL COMMENT '下单人ID',
  `shipping_user` varchar(10) NOT NULL COMMENT '收货人姓名',
  `mobile_phone` varchar(11) NOT NULL COMMENT '手机号',
  `province` varchar(20) NOT NULL COMMENT '省',
  `city` varchar(20) NOT NULL COMMENT '市',
  `district` varchar(20) NOT NULL COMMENT '区',
  `address` varchar(100) NOT NULL COMMENT '地址',
  `addr_code` varchar(50) NOT NULL COMMENT '地址code["pre","city","dic"]',
  `payment_method` tinyint(4) NOT NULL DEFAULT 1 COMMENT '支付方式：1余额，2网银，3支付宝，4微信',
  `order_money` decimal(8,2) NOT NULL COMMENT '订单金额',
  `payment_money` decimal(8,2) DEFAULT 0.00 COMMENT '支付金额',
  `shipping_comp_name` varchar(10) DEFAULT NULL COMMENT '快递公司名称',
  `shipping_sn` varchar(50) DEFAULT NULL COMMENT '快递单号',
  `create_time` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '下单时间',
  `shipping_time` datetime DEFAULT NULL COMMENT '发货时间',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `receive_time` datetime DEFAULT NULL COMMENT '收货时间',
  `order_status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '订单状态0::待付款;1:待发货;2:待收货;3:待评价;4:完成',
  `modified_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '最后修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='订单主表';

--
-- 转存表中的数据 `order_master`
--

INSERT INTO `order_master` (`order_id`, `order_sn`, `customer_id`, `shipping_user`, `mobile_phone`, `province`, `city`, `district`, `address`, `addr_code`, `payment_method`, `order_money`, `payment_money`, `shipping_comp_name`, `shipping_sn`, `create_time`, `shipping_time`, `pay_time`, `receive_time`, `order_status`, `modified_time`) VALUES
(106, '2020102511603609602107', 1, '老大', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '499.00', '499.00', '圆通快递', 'yt1603609604817', '2020-10-25 07:06:42', '2020-10-25 15:07:17', '2020-10-25 15:06:44', '2020-10-25 20:27:35', 4, '2020-10-25 15:47:17'),
(107, '2020102511603628946777', 1, '老大', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '899.00', '899.00', '圆通快递', 'yt1603628949389', '2020-10-25 12:29:06', '2020-10-25 20:29:16', '2020-10-25 20:29:09', '2020-10-25 20:29:42', 4, '2020-10-25 15:48:56'),
(108, '2020102511603629024245', 1, '老大', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '899.00', '899.00', '圆通快递', 'yt1603629026694', '2020-10-25 12:30:24', '2020-10-25 20:30:40', '2020-10-25 20:30:26', '2020-10-25 20:31:24', 4, '2020-10-26 05:50:46'),
(109, '2020102611603697218675', 1, '老大', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '5299.00', '5299.00', '百世快递', 'bs1603697221009', '2020-10-26 07:26:58', '2020-10-26 15:27:06', '2020-10-26 15:27:01', '2020-10-26 15:27:07', 4, '2020-10-26 09:05:55'),
(110, '2020102611603703082730', 1, '是是是', '18368368322', '天津市', '市辖区', '和平区', '打法', '[\"120000\",\"120100\",\"120101\"]', 1, '7497.00', '7497.00', '顺丰快递', 'sh1603703087757', '2020-10-26 09:04:42', '2020-10-26 17:05:45', '2020-10-26 17:04:47', '2020-10-26 17:05:49', 4, '2020-10-26 09:06:05'),
(111, '2020102611603703126095', 1, '老大', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '5997.00', '5997.00', '韵达快递', 'yd1603703128476', '2020-10-26 09:05:26', '2020-10-27 13:26:33', '2020-10-26 17:05:28', '2020-10-27 13:26:37', 3, '2020-10-27 05:26:37'),
(112, '2020103011604028310004', 1, '老大', '18368368323', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '1999.00', '1999.00', '圆通快递', 'yt1604028313524', '2020-10-30 03:25:10', '2020-11-08 18:57:22', '2020-10-30 11:25:13', '2020-11-11 19:30:15', 3, '2020-11-11 11:30:15'),
(113, '202011911604913430705', 1, '老大', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '2799.00', '2799.00', '百世快递', 'bs1604913433622', '2020-11-09 09:17:10', '2020-11-09 17:17:36', '2020-11-09 17:17:13', '2020-11-11 19:29:46', 3, '2020-11-11 11:29:46'),
(114, '2020111111605094471270', 1, '老大', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '5299.00', '5299.00', '百世快递', 'bs1605094473831', '2020-11-11 11:34:31', '2020-11-11 19:34:43', '2020-11-11 19:34:33', '2020-11-11 19:34:59', 4, '2020-11-11 12:36:48'),
(115, '2020111111605101377805', 1, '老大', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '5999.00', '5999.00', '中通快递', 'zt1605101380396', '2020-11-11 13:29:37', '2020-11-11 21:30:31', '2020-11-11 21:29:40', '2020-11-11 21:30:41', 3, '2020-11-11 13:30:41'),
(116, '2020111311605260034091', 1, '张三', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '78.90', '78.90', '韵达快递', 'yd1605260036914', '2020-11-13 09:33:54', '2020-11-13 17:41:05', '2020-11-13 17:33:56', '2020-11-13 17:41:59', 3, '2020-11-13 09:41:59'),
(117, '2020111311605260059019', 1, '张三', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '1999.00', '1999.00', '百世快递', 'bs1605260061994', '2020-11-13 09:34:19', '2020-11-13 17:40:39', '2020-11-13 17:34:21', '2020-11-13 17:42:34', 4, '2020-11-13 15:25:33'),
(118, '2020111411605344515266', 1, '张三', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '78.90', '0.00', NULL, NULL, '2020-11-14 09:01:55', NULL, NULL, NULL, 0, '2020-11-14 09:01:55'),
(119, '2020111411605344536651', 1, '张三', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '1499.00', '0.00', NULL, NULL, '2020-11-14 09:02:16', NULL, NULL, NULL, 0, '2020-11-14 09:02:16'),
(120, '2020111511605420814233', 1, '张三', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '899.00', '899.00', '顺丰快递', 'sh1605420819209', '2020-11-15 06:13:34', '2020-11-15 21:03:19', '2020-11-15 14:13:39', '2020-11-15 21:03:24', 3, '2020-11-15 13:03:24'),
(121, '20201115261605422111916', 26, '李四', '15364564548', '北京市', '市辖区', '东城区', '按时大大', '[\"110000\",\"110100\",\"110101\"]', 1, '1499.00', '0.00', NULL, NULL, '2020-11-15 06:35:11', NULL, NULL, NULL, 0, '2020-11-15 06:35:11'),
(122, '2020111511605423049658', 1, '张三', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '129.00', '129.00', '顺丰快递', 'sh1605423053689', '2020-11-15 06:50:49', '2020-11-15 20:47:34', '2020-11-15 14:50:53', '2020-11-15 21:03:13', 3, '2020-11-15 13:03:13'),
(123, '2020111511605423261217', 1, '张三', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '5299.00', '5299.00', '中通快递', 'zt1605423268710', '2020-11-15 06:54:21', '2020-11-15 14:54:52', '2020-11-15 14:54:28', '2020-11-15 14:55:00', 4, '2020-11-15 06:55:13'),
(124, '2020111511605429557563', 1, '张三', '18368368322', '浙江省', '温州市', '瓯海区', '浙江工贸职业技术学院', '[\"330000\",\"330300\",\"330304\"]', 1, '78.90', '78.90', '百世快递', 'bs1605429565886', '2020-11-15 08:39:17', '2020-11-15 20:43:29', '2020-11-15 16:39:25', '2020-11-15 20:46:59', 3, '2020-11-15 12:46:59');

-- --------------------------------------------------------

--
-- 表的结构 `product_category`
--

CREATE TABLE `product_category` (
  `category_id` smallint(5) UNSIGNED NOT NULL COMMENT '分类ID',
  `category_name` varchar(50) NOT NULL COMMENT '分类名称',
  `parent_id` smallint(5) UNSIGNED NOT NULL DEFAULT 16 COMMENT '父分类ID',
  `category_level` tinyint(4) NOT NULL DEFAULT 2 COMMENT '分类层级',
  `modified_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '最后修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品分类表';

--
-- 转存表中的数据 `product_category`
--

INSERT INTO `product_category` (`category_id`, `category_name`, `parent_id`, `category_level`, `modified_time`) VALUES
(1, '手机数码', 0, 0, '2020-10-23 09:08:48'),
(2, '手机', 1, 1, '2020-10-23 12:09:18'),
(3, 'OPPO', 2, 2, '2020-11-09 07:47:32'),
(4, '小米', 2, 2, '2020-10-23 12:09:18'),
(5, '华为', 2, 2, '2020-10-23 12:09:18'),
(6, '三星', 2, 2, '2020-10-23 12:09:18'),
(7, 'VIVO', 2, 2, '2020-10-23 12:09:18'),
(8, '笔记本', 1, 1, '2020-10-23 12:09:18'),
(9, '联想', 8, 2, '2020-10-23 12:09:18'),
(10, '戴尔', 8, 2, '2020-10-23 12:09:18'),
(11, '华硕', 8, 2, '2020-10-23 12:09:18'),
(12, '神州', 8, 2, '2020-10-23 12:09:18'),
(13, 'Thinkpad', 8, 2, '2020-10-23 12:09:18'),
(14, '相机', 1, 1, '2020-10-23 12:09:18'),
(15, '单反', 14, 2, '2020-10-23 12:09:18'),
(16, '自拍神器', 14, 2, '2020-10-23 12:09:18'),
(17, '佳能', 14, 2, '2020-10-23 12:09:18'),
(18, '尼康', 14, 2, '2020-10-23 12:09:18'),
(19, '镜头', 14, 2, '2020-10-23 12:09:18'),
(20, '女装男装', 0, 0, '2020-10-23 14:35:31'),
(21, '潮流女装', 20, 1, '2020-10-23 14:35:31'),
(22, '连衣裙', 21, 2, '2020-10-23 14:35:31'),
(23, '裤子', 21, 2, '2020-10-23 14:35:31'),
(24, '冬季外套', 21, 2, '2020-10-23 14:35:31'),
(25, '半身裙', 21, 2, '2020-10-23 14:35:31'),
(26, '风衣', 21, 2, '2020-10-23 14:35:31'),
(27, '时尚男装', 20, 1, '2020-10-23 14:35:31'),
(28, '休闲裤', 27, 2, '2020-10-25 08:46:50'),
(29, 'T恤', 27, 2, '2020-10-23 14:35:31'),
(30, '卫衣', 27, 2, '2020-10-25 08:47:42'),
(31, '牛仔裤', 27, 2, '2020-10-23 14:35:31'),
(32, '秋外套', 20, 1, '2020-10-23 14:35:31'),
(33, '夹克', 32, 2, '2020-10-23 14:35:31'),
(34, '西装', 32, 2, '2020-10-23 14:35:31'),
(35, '薄羽绒', 32, 2, '2020-10-23 14:35:31'),
(36, '短外套', 32, 2, '2020-10-23 14:35:31'),
(37, '家用电器', 0, 0, '2020-10-23 14:43:03'),
(38, '生活电器', 37, 1, '2020-10-23 14:43:03'),
(39, '热水器', 38, 2, '2020-10-23 14:43:03'),
(40, '取暖器', 38, 2, '2020-10-23 14:43:03'),
(41, '吸尘器', 38, 2, '2020-10-23 14:43:03'),
(42, '电扇', 38, 2, '2020-10-23 14:43:03'),
(43, '大家电', 37, 1, '2020-10-23 14:43:03'),
(44, '电视机', 43, 2, '2020-10-23 14:43:03'),
(45, '洗衣机', 43, 2, '2020-10-23 14:43:03'),
(46, '空调', 43, 2, '2020-10-23 14:43:03'),
(47, '冰箱', 43, 2, '2020-10-23 14:43:03'),
(48, '个护电器', 37, 1, '2020-10-23 14:43:03'),
(49, '电吹风', 48, 2, '2020-10-23 14:43:03'),
(50, '理发器', 48, 2, '2020-10-23 14:43:03'),
(51, '体重秤', 48, 2, '2020-10-23 14:43:03'),
(52, '剃须刀', 48, 2, '2020-10-24 14:42:40'),
(53, '鞋类箱包', 0, 0, '2020-11-02 08:59:28'),
(54, '男鞋', 53, 1, '2020-10-23 15:21:00'),
(55, '商务皮鞋', 54, 2, '2020-10-23 15:21:00'),
(56, '休闲皮鞋', 54, 2, '2020-10-23 15:21:00'),
(57, '运动鞋', 54, 2, '2020-10-24 14:41:32'),
(58, '女鞋', 53, 1, '2020-10-23 15:21:00'),
(59, '帆布鞋', 58, 2, '2020-10-23 15:21:00'),
(60, '高帮', 58, 2, '2020-10-23 15:21:00'),
(61, '低帮', 58, 2, '2020-10-23 15:21:00'),
(62, '韩版', 58, 2, '2020-10-23 15:21:00'),
(63, '旅行箱', 53, 1, '2020-10-23 15:21:00'),
(64, '拉杆箱', 63, 2, '2020-10-23 15:21:00'),
(65, '密码箱', 63, 2, '2020-10-23 15:21:00'),
(66, '万向轮', 63, 2, '2020-10-23 15:21:00'),
(67, '拉杆包', 63, 2, '2020-10-23 15:21:00'),
(68, '家居家纺', 0, 0, '2020-10-23 15:39:17'),
(69, '客厅家具', 68, 1, '2020-10-23 15:39:17'),
(70, '皮艺沙发', 69, 2, '2020-10-23 15:39:17'),
(71, '沙发床', 69, 2, '2020-10-23 15:39:17'),
(72, '实木沙发', 69, 2, '2020-10-23 15:39:17'),
(73, '电视柜', 69, 2, '2020-10-23 15:39:17'),
(74, '餐厅家具', 68, 1, '2020-10-23 15:39:17'),
(75, '餐桌', 74, 2, '2020-10-23 15:39:17'),
(76, '折叠餐桌', 74, 2, '2020-10-23 15:39:17'),
(77, '欧式餐桌', 74, 2, '2020-10-23 15:39:17'),
(78, '餐椅', 74, 2, '2020-10-23 15:39:17'),
(79, '居家布艺', 68, 1, '2020-10-23 15:39:17'),
(80, '定制窗帘', 79, 2, '2020-10-23 15:39:17'),
(81, '地毯', 79, 2, '2020-10-23 15:39:17'),
(82, '沙发垫', 79, 2, '2020-10-23 15:39:17'),
(83, '地垫', 79, 2, '2020-10-23 15:39:17'),
(84, '运动户外', 0, 0, '2020-11-02 08:59:44'),
(85, '球类运动', 84, 1, '2020-11-02 09:00:01'),
(86, '羽毛球拍', 85, 2, '2020-10-23 15:45:13'),
(87, '羽毛球', 85, 2, '2020-10-23 15:45:13'),
(88, '篮球', 85, 2, '2020-10-23 15:45:13'),
(89, '足球', 85, 2, '2020-10-23 15:45:13'),
(90, '骑行装备', 84, 1, '2020-10-23 15:45:13'),
(91, '山地车', 90, 2, '2020-10-23 15:45:13'),
(92, '公路车', 90, 2, '2020-10-23 15:45:13'),
(93, '骑行服', 90, 2, '2020-10-23 15:45:13'),
(94, '头盔', 90, 2, '2020-10-23 15:45:13'),
(95, '护具', 90, 2, '2020-10-23 15:45:13'),
(96, '垂钓用品', 84, 1, '2020-10-23 15:45:13'),
(97, '鱼饵', 96, 2, '2020-10-23 15:45:13'),
(98, '鱼钩', 96, 2, '2020-10-23 15:45:13'),
(99, '套装', 96, 2, '2020-10-23 15:45:13'),
(100, '钓鱼工具', 96, 2, '2020-10-23 15:45:13'),
(101, '台钓竿', 96, 2, '2020-10-23 15:45:13'),
(113, 'iphone', 2, 2, '2020-11-15 06:52:21');

-- --------------------------------------------------------

--
-- 表的结构 `product_comment`
--

CREATE TABLE `product_comment` (
  `comment_id` int(10) UNSIGNED NOT NULL COMMENT '评论ID',
  `product_id` int(10) UNSIGNED NOT NULL COMMENT '商品ID',
  `order_id` int(20) UNSIGNED NOT NULL COMMENT '订单ID',
  `customer_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `content` varchar(300) NOT NULL COMMENT '评论内容',
  `star` int(5) NOT NULL COMMENT '星级',
  `audit_status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '审核状态：0未审核，1已审核',
  `audit_time` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '评论时间',
  `modified_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '最后修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品评论表';

--
-- 转存表中的数据 `product_comment`
--

INSERT INTO `product_comment` (`comment_id`, `product_id`, `order_id`, `customer_id`, `content`, `star`, `audit_status`, `audit_time`, `modified_time`) VALUES
(17, 4, 108, 1, '56445', 4, 1, '2020-10-26 05:50:45', '2020-11-14 08:28:52'),
(18, 3, 109, 1, '55555', 5, 1, '2020-10-26 09:05:55', '2020-11-14 08:28:53'),
(19, 2, 110, 1, '666', 5, 1, '2020-10-26 09:06:05', '2020-11-14 08:28:53'),
(20, 3, 114, 1, '手机很好，很满意', 5, 1, '2020-11-11 12:36:48', '2020-11-11 12:36:48'),
(21, 2, 117, 1, '顾哥哥', 5, 1, '2020-11-13 15:25:33', '2020-11-13 15:25:33'),
(22, 3, 123, 1, 'hao', 5, 1, '2020-11-15 06:55:13', '2020-11-15 06:55:13');

-- --------------------------------------------------------

--
-- 表的结构 `product_info`
--

CREATE TABLE `product_info` (
  `product_id` int(10) UNSIGNED NOT NULL COMMENT '商品ID',
  `product_name` varchar(255) NOT NULL COMMENT '商品名称',
  `supplier_id` int(10) NOT NULL COMMENT '供应商id',
  `one_category_id` smallint(5) UNSIGNED NOT NULL COMMENT '一级分类ID',
  `two_category_id` smallint(5) UNSIGNED NOT NULL COMMENT '二级分类ID',
  `three_category_id` smallint(5) UNSIGNED NOT NULL COMMENT '三级分类ID',
  `price` int(30) NOT NULL COMMENT '商品价格',
  `main_img` varchar(200) DEFAULT NULL COMMENT '商品主图',
  `publish_status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '上下架状态：0下架1上架',
  `audit_status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '审核状态：0未审核，1已审核',
  `descript` text NOT NULL COMMENT '商品描述',
  `indate` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '商品录入时间',
  `modified_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '最后修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品信息表';

--
-- 转存表中的数据 `product_info`
--

INSERT INTO `product_info` (`product_id`, `product_name`, `supplier_id`, `one_category_id`, `two_category_id`, `three_category_id`, `price`, `main_img`, `publish_status`, `audit_status`, `descript`, `indate`, `modified_time`) VALUES
(2, 'Redmi K30 至尊纪念版 120Hz弹出屏游戏智能5g手机小米官方旗', 1, 1, 2, 4, 1999, 'http://127.0.0.1:3000/images/goods/goods2/home_img.jpg', 1, 1, '啥打法as地方as', '2020-10-16 08:01:10', '2020-11-18 11:59:57'),
(3, '小米10至尊纪念版5g手机120HZ屏幕120X变焦骁龙865小米官方旗舰店小米手机小', 1, 1, 2, 4, 5299, 'http://127.0.0.1:3000/images/goods/goods3/home_img.jpg', 1, 1, '啥打法as地方as', '2020-10-17 05:19:19', '2020-11-18 11:59:42'),
(4, '红米note8 4800万高清四摄智能拍照游戏学生手机redmi红米pro小米官', 1, 1, 2, 4, 899, 'http://127.0.0.1:3000/images/goods/goods4/home_img.jpg', 1, 1, '', '2020-10-22 13:08:50', '2020-11-18 12:00:03'),
(5, '红米k30 5g双模手机pro索尼6400万拍照学生游戏全面屏老年人智能机小米', 1, 1, 2, 4, 3099, 'http://127.0.0.1:3000/images/goods/goods5/home_img.jpg', 1, 1, '啥打法as地方as', '2020-10-25 05:54:52', '2020-11-18 12:00:43'),
(6, '2020年新款女装早春秋季收腰显瘦修身气质女神范流行蕾丝连衣裙子', 2, 20, 32, 35, 129, 'http://127.0.0.1:3000/images/goods/goods6/home_img.jpg', 1, 1, '啥打法as地方as', '2020-10-25 06:16:58', '2020-11-25 11:07:02'),
(7, '连衣裙', 2, 20, 32, 35, 659, 'http://127.0.0.1:3000/images/goods/goods7/home_img.jpg', 1, 1, '啥打法as地方as', '2020-10-25 06:50:23', '2020-11-18 12:20:12'),
(8, '连衣裙', 2, 20, 21, 22, 826, 'http://127.0.0.1:3000/images/goods/goods8/home_img.jpg', 1, 1, '啥打法as地方as', '2020-10-25 06:55:53', '2020-11-18 12:20:05'),
(9, '香影蕾丝连衣裙女2020秋冬装新款气质淑女半高领收腰显瘦内搭裙子', 2, 20, 21, 22, 499, 'http://127.0.0.1:3000/images/goods/goods9/home_img.jpg', 1, 1, '啥打法as地方as', '2020-10-25 06:55:56', '2020-11-25 11:06:28'),
(10, 'l连衣裙', 2, 20, 21, 22, 349, 'http://127.0.0.1:3000/images/goods/goods10/home_img.jpg', 1, 1, '啥打法as地方as', '2020-10-25 07:09:03', '2020-11-18 12:19:49'),
(11, '南极人休闲裤运动裤子夏季潮流直筒男生百搭宽松九分束脚工装裤男', 3, 20, 27, 28, 79, 'http://127.0.0.1:3000/images/goods/goods11/home_img.jpg', 1, 1, '啥打法as地方as', '2020-10-25 08:28:18', '2020-11-25 11:06:40'),
(12, 'OPPO K7 oppok7手机5g新品款上市oppo手机正品全新机oppo手机', 1, 1, 2, 4, 1499, 'http://127.0.0.1:3000/images/goods/goods12/home_img.jpg', 1, 1, '啥打法as地方as', '2020-11-09 07:51:40', '2020-11-18 12:17:11'),
(61, 'test', 1, 20, 27, 29, 1231, 'http://127.0.0.1:3000/images/goods/goods61/home_img-1605701795932.jpg', 1, 1, 'asd ', '2020-11-18 12:16:35', '2020-11-18 12:17:07');

-- --------------------------------------------------------

--
-- 表的结构 `product_pic_info`
--

CREATE TABLE `product_pic_info` (
  `product_pic_id` int(10) UNSIGNED NOT NULL COMMENT '商品图片ID',
  `product_id` int(10) UNSIGNED NOT NULL COMMENT '商品ID',
  `pic_url` varchar(200) NOT NULL COMMENT '图片URL',
  `is_master` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否主图：0.非主图1.主图',
  `modified_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '最后修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='商品图片信息表';

--
-- 转存表中的数据 `product_pic_info`
--

INSERT INTO `product_pic_info` (`product_pic_id`, `product_id`, `pic_url`, `is_master`, `modified_time`) VALUES
(1, 2, 'http://127.0.0.1:3000/images/goods/goods2/banner/banner1.jpg', 0, '2020-10-25 05:27:49'),
(2, 2, 'http://127.0.0.1:3000/images/goods/goods2/banner/banner2.jpg', 0, '2020-10-25 05:27:54'),
(3, 2, 'http://127.0.0.1:3000/images/goods/goods2/banner/banner3.jpg', 0, '2020-10-25 05:27:57'),
(4, 2, 'http://127.0.0.1:3000/images/goods/goods2/main/img1.png', 1, '2020-10-25 05:28:13'),
(5, 2, 'http://127.0.0.1:3000/images/goods/goods2/main/img2.png', 1, '2020-10-25 05:28:11'),
(6, 2, 'http://127.0.0.1:3000/images/goods/goods2/main/img3.png', 1, '2020-10-25 05:28:08'),
(7, 2, 'http://127.0.0.1:3000/images/goods/goods2/main/img4.png', 1, '2020-10-25 05:28:20'),
(8, 2, 'http://127.0.0.1:3000/images/goods/goods2/main/img5.png', 1, '2020-10-25 05:28:24'),
(9, 2, 'http://127.0.0.1:3000/images/goods/goods2/main/img6.png', 1, '2020-10-25 05:28:32'),
(10, 3, 'http://127.0.0.1:3000/images/goods/goods3/banner/banner1.jpg', 0, '2020-10-25 05:28:37'),
(11, 3, 'http://127.0.0.1:3000/images/goods/goods3/banner/banner2.jpg', 0, '2020-10-25 05:28:39'),
(12, 3, 'http://127.0.0.1:3000/images/goods/goods3/banner/banner3.jpg', 0, '2020-10-25 05:28:42'),
(13, 3, 'http://127.0.0.1:3000/images/goods/goods3/main/img1.jpg', 1, '2020-10-25 05:28:45'),
(14, 3, 'http://127.0.0.1:3000/images/goods/goods3/main/img2.jpg', 1, '2020-10-25 05:28:49'),
(15, 3, 'http://127.0.0.1:3000/images/goods/goods3/main/img3.jpg', 1, '2020-10-25 05:28:54'),
(16, 3, 'http://127.0.0.1:3000/images/goods/goods3/main/img4.jpg', 1, '2020-10-25 05:28:59'),
(17, 3, 'http://127.0.0.1:3000/images/goods/goods3/main/img5.jpg', 1, '2020-10-25 05:29:03'),
(18, 4, 'http://127.0.0.1:3000/images/goods/goods4/banner/banner1.jpg', 0, '2020-10-25 05:29:08'),
(19, 4, 'http://127.0.0.1:3000/images/goods/goods4/banner/banner2.jpg', 0, '2020-10-25 05:29:10'),
(20, 4, 'http://127.0.0.1:3000/images/goods/goods4/banner/banner3.jpg', 0, '2020-10-25 05:29:12'),
(21, 4, 'http://127.0.0.1:3000/images/goods/goods4/main/img1.jpg', 1, '2020-10-25 05:29:21'),
(22, 4, 'http://127.0.0.1:3000/images/goods/goods4/main/img2.jpg', 1, '2020-10-25 05:29:53'),
(23, 4, 'http://127.0.0.1:3000/images/goods/goods4/main/img3.gif', 1, '2020-10-25 05:29:32'),
(24, 4, 'http://127.0.0.1:3000/images/goods/goods4/main/img4.gif', 1, '2020-10-25 05:29:31'),
(25, 5, 'http://127.0.0.1:3000/images/goods/goods5/banner/banner1.jpg', 0, '2020-10-25 05:58:41'),
(26, 5, 'http://127.0.0.1:3000/images/goods/goods5/banner/banner2.jpg', 0, '2020-10-25 06:00:14'),
(27, 5, 'http://127.0.0.1:3000/images/goods/goods5/banner/banner3.jpg', 0, '2020-10-25 06:00:19'),
(28, 5, 'http://127.0.0.1:3000/images/goods/goods5/main/img1.png', 1, '2020-10-25 06:02:49'),
(29, 5, 'http://127.0.0.1:3000/images/goods/goods5/main/img2.jpg', 1, '2020-10-25 06:03:04'),
(30, 5, 'http://127.0.0.1:3000/images/goods/goods5/main/img3.jpg', 1, '2020-10-25 06:03:14'),
(31, 5, 'http://127.0.0.1:3000/images/goods/goods5/main/img4.jpg', 1, '2020-10-25 06:03:19'),
(32, 5, 'http://127.0.0.1:3000/images/goods/goods5/main/img5.jpg', 1, '2020-10-25 06:03:30'),
(33, 6, 'http://127.0.0.1:3000/images/goods/goods6/banner/banner1.jpg', 0, '2020-10-25 06:21:02'),
(34, 6, 'http://127.0.0.1:3000/images/goods/goods6/banner/banner2.jpg', 0, '2020-10-25 06:21:11'),
(35, 6, 'http://127.0.0.1:3000/images/goods/goods6/banner/banner3.jpg', 0, '2020-10-25 06:21:19'),
(36, 6, 'http://127.0.0.1:3000/images/goods/goods6/main/img1.jpg', 1, '2020-10-25 06:22:04'),
(37, 6, 'http://127.0.0.1:3000/images/goods/goods6/main/img2.jpg', 1, '2020-10-25 06:22:43'),
(38, 6, 'http://127.0.0.1:3000/images/goods/goods6/main/img3.jpg', 1, '2020-10-25 06:22:38'),
(39, 6, 'http://127.0.0.1:3000/images/goods/goods6/main/img4.jpg', 1, '2020-10-25 06:22:35'),
(40, 6, 'http://127.0.0.1:3000/images/goods/goods6/main/img5.jpg', 1, '2020-10-25 06:22:32'),
(42, 7, 'http://127.0.0.1:3000/images/goods/goods7/banner/banner1.jpg', 0, '2020-10-25 06:53:40'),
(43, 7, 'http://127.0.0.1:3000/images/goods/goods7/banner/banner2.jpg', 0, '2020-10-25 06:53:40'),
(44, 7, 'http://127.0.0.1:3000/images/goods/goods7/banner/banner3.jpg', 0, '2020-10-25 06:53:40'),
(45, 7, 'http://127.0.0.1:3000/images/goods/goods7/main/img1.jpg', 1, '2020-10-25 06:53:40'),
(46, 7, 'http://127.0.0.1:3000/images/goods/goods7/main/img2.jpg', 1, '2020-10-25 06:53:40'),
(47, 7, 'http://127.0.0.1:3000/images/goods/goods7/main/img3.jpg', 1, '2020-10-25 06:53:40'),
(48, 7, 'http://127.0.0.1:3000/images/goods/goods7/main/img4.jpg', 1, '2020-10-25 06:53:40'),
(49, 7, 'http://127.0.0.1:3000/images/goods/goods7/main/img5.jpg', 1, '2020-10-25 06:54:36'),
(50, 8, 'http://127.0.0.1:3000/images/goods/goods8/banner/banner1.jpg', 0, '2020-10-25 06:58:39'),
(51, 8, 'http://127.0.0.1:3000/images/goods/goods8/banner/banner2.jpg', 0, '2020-10-25 06:58:39'),
(52, 8, 'http://127.0.0.1:3000/images/goods/goods8/banner/banner3.jpg', 0, '2020-10-25 06:58:39'),
(53, 8, 'http://127.0.0.1:3000/images/goods/goods8/main/img1.jpg', 1, '2020-10-25 06:58:39'),
(54, 8, 'http://127.0.0.1:3000/images/goods/goods8/main/img2.jpg', 1, '2020-10-25 06:58:39'),
(55, 8, 'http://127.0.0.1:3000/images/goods/goods8/main/img3.jpg', 1, '2020-10-25 06:58:39'),
(56, 8, 'http://127.0.0.1:3000/images/goods/goods8/main/img4.jpg', 1, '2020-10-25 06:58:39'),
(57, 9, 'http://127.0.0.1:3000/images/goods/goods9/banner/banner1.jpg', 0, '2020-10-25 07:05:49'),
(58, 9, 'http://127.0.0.1:3000/images/goods/goods9/banner/banner2.jpg', 0, '2020-10-25 07:05:49'),
(59, 9, 'http://127.0.0.1:3000/images/goods/goods9/banner/banner3.jpg', 0, '2020-10-25 07:05:49'),
(60, 9, 'http://127.0.0.1:3000/images/goods/goods9/main/img1.jpg', 1, '2020-10-25 07:05:49'),
(61, 9, 'http://127.0.0.1:3000/images/goods/goods9/main/img2.jpg', 1, '2020-10-25 07:05:49'),
(62, 9, 'http://127.0.0.1:3000/images/goods/goods9/main/img3.jpg', 1, '2020-10-25 07:05:49'),
(63, 9, 'http://127.0.0.1:3000/images/goods/goods9/main/img4.jpg', 1, '2020-10-25 07:05:49'),
(64, 10, 'http://127.0.0.1:3000/images/goods/goods10/banner/banner1.jpg', 0, '2020-10-25 08:33:12'),
(65, 10, 'http://127.0.0.1:3000/images/goods/goods10/banner/banner2.jpg', 0, '2020-10-25 08:33:12'),
(66, 10, 'http://127.0.0.1:3000/images/goods/goods10/banner/banner3.jpg', 0, '2020-10-25 08:33:12'),
(67, 10, 'http://127.0.0.1:3000/images/goods/goods10/main/img1.jpg', 1, '2020-10-25 08:33:12'),
(68, 10, 'http://127.0.0.1:3000/images/goods/goods10/main/img2.jpg', 1, '2020-10-25 08:33:12'),
(69, 10, 'http://127.0.0.1:3000/images/goods/goods10/main/img3.jpg', 1, '2020-10-25 08:33:12'),
(70, 10, 'http://127.0.0.1:3000/images/goods/goods10/main/img4.jpg', 1, '2020-10-25 08:33:12'),
(71, 11, 'http://127.0.0.1:3000/images/goods/goods11/banner/banner1.jpg', 0, '2020-10-25 08:45:37'),
(72, 11, 'http://127.0.0.1:3000/images/goods/goods11/banner/banner2.jpg', 0, '2020-10-25 08:45:37'),
(73, 11, 'http://127.0.0.1:3000/images/goods/goods11/banner/banner3.jpg', 0, '2020-10-25 08:45:37'),
(74, 11, 'http://127.0.0.1:3000/images/goods/goods11/main/img1.jpg', 1, '2020-10-25 08:45:37'),
(75, 11, 'http://127.0.0.1:3000/images/goods/goods11/main/img2.jpg', 1, '2020-10-25 08:45:37'),
(76, 11, 'http://127.0.0.1:3000/images/goods/goods11/main/img3.jpg', 1, '2020-10-25 08:45:37'),
(77, 11, 'http://127.0.0.1:3000/images/goods/goods11/main/img4.jpg', 1, '2020-10-25 08:45:37'),
(167, 12, 'http://127.0.0.1:3000/images/goods/goods12/banner/banner1.jpg', 0, '2020-11-18 12:12:26'),
(168, 12, 'http://127.0.0.1:3000/images/goods/goods12/banner/banner2.jpg', 0, '2020-11-18 12:12:26'),
(169, 12, 'http://127.0.0.1:3000/images/goods/goods12/banner/banner3.jpg', 0, '2020-11-18 12:12:26'),
(170, 12, 'http://127.0.0.1:3000/images/goods/goods12/main/img1.jpg', 1, '2020-11-18 12:12:26'),
(171, 12, 'http://127.0.0.1:3000/images/goods/goods12/main/img2.jpg', 1, '2020-11-18 12:12:26'),
(172, 12, 'http://127.0.0.1:3000/images/goods/goods12/main/img3.jpg', 1, '2020-11-18 12:12:26'),
(173, 12, 'http://127.0.0.1:3000/images/goods/goods12/main/img4.jpg', 1, '2020-11-18 12:12:26'),
(174, 12, 'http://127.0.0.1:3000/images/goods/goods12/main/img5.jpg', 1, '2020-11-18 12:12:26'),
(182, 61, 'http://127.0.0.1:3000/images/goods/goods61/banner/goodsImg-1605701806638.jpg', 0, '2020-11-18 12:16:46'),
(183, 61, 'http://127.0.0.1:3000/images/goods/goods61/banner/goodsImg-1605701806638.jpg', 0, '2020-11-18 12:16:46'),
(184, 61, 'http://127.0.0.1:3000/images/goods/goods61/banner/goodsImg-1605701806639.jpg', 0, '2020-11-18 12:16:46'),
(185, 61, 'http://127.0.0.1:3000/images/goods/goods61/main/goodsImg-1605701814469.jpg', 1, '2020-11-18 12:16:54'),
(186, 61, 'http://127.0.0.1:3000/images/goods/goods61/main/goodsImg-1605701814470.jpg', 1, '2020-11-18 12:16:54'),
(187, 61, 'http://127.0.0.1:3000/images/goods/goods61/main/goodsImg-1605701814471.jpg', 1, '2020-11-18 12:16:54'),
(188, 61, 'http://127.0.0.1:3000/images/goods/goods61/main/goodsImg-1605701814474.jpg', 1, '2020-11-18 12:16:54');

-- --------------------------------------------------------

--
-- 表的结构 `product_sku`
--

CREATE TABLE `product_sku` (
  `sku_id` int(11) NOT NULL COMMENT '商品skuid',
  `product_id` int(100) UNSIGNED NOT NULL COMMENT '商品表的商品id',
  `sku_version` varchar(50) NOT NULL COMMENT '商品版本',
  `sku_price` float NOT NULL COMMENT '商品价格',
  `sku_num` int(255) NOT NULL DEFAULT 100 COMMENT '商品库存'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `product_sku`
--

INSERT INTO `product_sku` (`sku_id`, `product_id`, `sku_version`, `sku_price`, `sku_num`) VALUES
(1000000065, 2, '6+128GB', 1999, 100),
(1000000066, 2, '8+128GB', 2199, 100),
(1000000067, 2, '8+512GB', 2499, 100),
(1000000068, 3, '8+128GB', 5299, 100),
(1000000069, 3, '8+256GB', 5599, 100),
(1000000070, 3, '12+256GB', 5999, 100),
(1000000074, 4, '4+64GB', 899, 100),
(1000000075, 4, '6+64GB', 999, 100),
(1000000076, 4, '6+128GB', 1299, 100),
(1000000079, 5, '8+128GB', 2799, 100),
(1000000080, 5, '8+256GB', 3099, 100),
(1000000084, 12, '6+128GB', 1599, 100),
(1000000085, 12, '8+128GB', 1999, 100),
(1000000086, 11, 'M', 78.9, 100),
(1000000087, 11, 'L', 78.9, 100),
(1000000088, 11, 'XL', 78.9, 100),
(1000000089, 11, 'XXL', 78.9, 100),
(1000000109, 10, 'S', 349, 100),
(1000000110, 10, 'M', 349, 100),
(1000000111, 10, 'L', 349, 100),
(1000000112, 9, 'S', 499, 100),
(1000000113, 9, 'M', 499, 100),
(1000000114, 9, 'L', 499, 100),
(1000000115, 8, '155', 826, 100),
(1000000116, 8, '160', 826, 100),
(1000000117, 8, '165', 826, 100),
(1000000118, 8, '170', 826, 100),
(1000000119, 7, 'S', 659, 100),
(1000000120, 7, 'M', 659, 100),
(1000000121, 6, 'S', 129, 100),
(1000000122, 6, 'M', 129, 100),
(1000000123, 6, 'L', 129, 100),
(1000000129, 61, 'm', 123, 100);

-- --------------------------------------------------------

--
-- 表的结构 `shipping_info`
--

CREATE TABLE `shipping_info` (
  `ship_id` tinyint(3) UNSIGNED NOT NULL COMMENT '主键ID',
  `ship_name` varchar(20) NOT NULL COMMENT '物流公司名称',
  `sn_start` varchar(6) NOT NULL,
  `ship_contact` varchar(20) NOT NULL COMMENT '物流公司联系人',
  `telephone` varchar(20) NOT NULL COMMENT '物流公司联系电话',
  `price` decimal(8,2) NOT NULL DEFAULT 0.00 COMMENT '配送价格',
  `modified_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '最后修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='物流公司信息表';

--
-- 转存表中的数据 `shipping_info`
--

INSERT INTO `shipping_info` (`ship_id`, `ship_name`, `sn_start`, `ship_contact`, `telephone`, `price`, `modified_time`) VALUES
(1, '顺丰快递', 'sh', '张三', '15964235468', '8.00', '2020-10-21 14:06:06'),
(2, '圆通快递', 'yt', '李四', '15324534575', '8.00', '2020-10-21 14:06:09'),
(3, '中通快递', 'zt', '王五', '15307869545', '8.00', '2020-10-21 14:06:12'),
(4, '韵达快递', 'yd', '赵六', '18398764885', '8.00', '2020-10-21 14:06:15'),
(5, '百世快递', 'bs', '拉斯', '15457483865', '8.00', '2020-10-21 14:06:18');

-- --------------------------------------------------------

--
-- 表的结构 `shop_cart`
--

CREATE TABLE `shop_cart` (
  `cart_id` int(10) UNSIGNED NOT NULL COMMENT '购物车ID',
  `customer_id` int(10) UNSIGNED NOT NULL COMMENT '用户ID',
  `product_id` int(10) UNSIGNED NOT NULL COMMENT '商品ID',
  `sku_id` int(20) UNSIGNED NOT NULL COMMENT '商品sku_id',
  `amount` int(11) NOT NULL COMMENT '加入购物车商品数量'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='购物车表';

--
-- 转存表中的数据 `shop_cart`
--

INSERT INTO `shop_cart` (`cart_id`, `customer_id`, `product_id`, `sku_id`, `amount`) VALUES
(31, 1, 3, 1000000068, 2),
(33, 1, 11, 1000000086, 1);

-- --------------------------------------------------------

--
-- 表的结构 `supplier_info`
--

CREATE TABLE `supplier_info` (
  `supplier_id` int(10) NOT NULL COMMENT '供应商ID',
  `supplier_name` char(50) NOT NULL COMMENT '供应商名称',
  `supplier_type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '供应商类型：1.自营，2.平台',
  `desc_score` varchar(255) DEFAULT '4.5' COMMENT '供应商描述分数',
  `serve_score` varchar(255) DEFAULT '4.5' COMMENT '供应商服务分数',
  `logi_score` varchar(255) DEFAULT '4.5' COMMENT '供应商物流分数',
  `supplier_status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：0禁止，1启用',
  `modified_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT '最后修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='供应商信息表';

--
-- 转存表中的数据 `supplier_info`
--

INSERT INTO `supplier_info` (`supplier_id`, `supplier_name`, `supplier_type`, `desc_score`, `serve_score`, `logi_score`, `supplier_status`, `modified_time`) VALUES
(1, '小米官方旗舰店', 1, '4.8', '4.8', '4.9', 1, '2020-10-25 06:14:33'),
(2, '亿梦诗旗舰店', 1, '4.9', '4..9', '4.9', 1, '2020-10-25 06:14:29'),
(3, '南极人男装旗舰店', 1, '4.7', '4.7', '4.7', 1, '2020-10-25 08:26:05'),
(4, 'OPPO官方旗舰店', 1, '4.5', '4.5', '4.5', 1, '2020-11-09 07:59:49'),
(5, '飞利浦智能锁旗舰店', 1, '4.5', '4.5', '4.5', 1, '2020-11-11 13:50:38'),
(6, 'ass', 1, '4.5', '4.5', '4.5', 1, '2020-11-17 06:42:45'),
(8, '是是是', 1, '4.5', '4.5', '4.5', 1, '2020-11-17 06:50:10'),
(9, '杀手', 1, '4.5', '4.5', '4.5', 1, '2020-11-17 06:50:42'),
(10, 'q', 1, '4.5', '4.5', '4.5', 1, '2020-11-17 07:40:47'),
(11, '上的', 1, '4.5', '4.5', '4.5', 1, '2020-11-18 07:42:41'),
(12, '三生三世', 1, '4.5', '4.5', '4.5', 1, '2020-11-18 11:24:02');

--
-- 转储表的索引
--

--
-- 表的索引 `admin_info`
--
ALTER TABLE `admin_info`
  ADD PRIMARY KEY (`admin_id`);

--
-- 表的索引 `customer_addr`
--
ALTER TABLE `customer_addr`
  ADD PRIMARY KEY (`customer_addr_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- 表的索引 `customer_inf`
--
ALTER TABLE `customer_inf`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `mobile_phone` (`mobile_phone`);

--
-- 表的索引 `help`
--
ALTER TABLE `help`
  ADD PRIMARY KEY (`help_id`);

--
-- 表的索引 `order_detail`
--
ALTER TABLE `order_detail`
  ADD PRIMARY KEY (`order_detail_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- 表的索引 `order_master`
--
ALTER TABLE `order_master`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- 表的索引 `product_category`
--
ALTER TABLE `product_category`
  ADD PRIMARY KEY (`category_id`);

--
-- 表的索引 `product_comment`
--
ALTER TABLE `product_comment`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `product` (`product_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- 表的索引 `product_info`
--
ALTER TABLE `product_info`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- 表的索引 `product_pic_info`
--
ALTER TABLE `product_pic_info`
  ADD PRIMARY KEY (`product_pic_id`),
  ADD KEY `product_id` (`product_id`);

--
-- 表的索引 `product_sku`
--
ALTER TABLE `product_sku`
  ADD PRIMARY KEY (`sku_id`),
  ADD KEY `product_id` (`product_id`);

--
-- 表的索引 `shipping_info`
--
ALTER TABLE `shipping_info`
  ADD PRIMARY KEY (`ship_id`);

--
-- 表的索引 `shop_cart`
--
ALTER TABLE `shop_cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `product_id` (`product_id`);

--
-- 表的索引 `supplier_info`
--
ALTER TABLE `supplier_info`
  ADD PRIMARY KEY (`supplier_id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `admin_info`
--
ALTER TABLE `admin_info`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用表AUTO_INCREMENT `customer_addr`
--
ALTER TABLE `customer_addr`
  MODIFY `customer_addr_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键ID', AUTO_INCREMENT=99;

--
-- 使用表AUTO_INCREMENT `customer_inf`
--
ALTER TABLE `customer_inf`
  MODIFY `customer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID', AUTO_INCREMENT=66;

--
-- 使用表AUTO_INCREMENT `help`
--
ALTER TABLE `help`
  MODIFY `help_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- 使用表AUTO_INCREMENT `order_detail`
--
ALTER TABLE `order_detail`
  MODIFY `order_detail_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单详情表ID', AUTO_INCREMENT=117;

--
-- 使用表AUTO_INCREMENT `order_master`
--
ALTER TABLE `order_master`
  MODIFY `order_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID', AUTO_INCREMENT=125;

--
-- 使用表AUTO_INCREMENT `product_category`
--
ALTER TABLE `product_category`
  MODIFY `category_id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '分类ID', AUTO_INCREMENT=114;

--
-- 使用表AUTO_INCREMENT `product_comment`
--
ALTER TABLE `product_comment`
  MODIFY `comment_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '评论ID', AUTO_INCREMENT=23;

--
-- 使用表AUTO_INCREMENT `product_info`
--
ALTER TABLE `product_info`
  MODIFY `product_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '商品ID', AUTO_INCREMENT=63;

--
-- 使用表AUTO_INCREMENT `product_pic_info`
--
ALTER TABLE `product_pic_info`
  MODIFY `product_pic_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '商品图片ID', AUTO_INCREMENT=210;

--
-- 使用表AUTO_INCREMENT `product_sku`
--
ALTER TABLE `product_sku`
  MODIFY `sku_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '商品skuid', AUTO_INCREMENT=1000000130;

--
-- 使用表AUTO_INCREMENT `shipping_info`
--
ALTER TABLE `shipping_info`
  MODIFY `ship_id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID', AUTO_INCREMENT=6;

--
-- 使用表AUTO_INCREMENT `shop_cart`
--
ALTER TABLE `shop_cart`
  MODIFY `cart_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '购物车ID', AUTO_INCREMENT=35;

--
-- 使用表AUTO_INCREMENT `supplier_info`
--
ALTER TABLE `supplier_info`
  MODIFY `supplier_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '供应商ID', AUTO_INCREMENT=13;

--
-- 限制导出的表
--

--
-- 限制表 `customer_addr`
--
ALTER TABLE `customer_addr`
  ADD CONSTRAINT `customer_addr_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer_inf` (`customer_id`);

--
-- 限制表 `order_detail`
--
ALTER TABLE `order_detail`
  ADD CONSTRAINT `order_detail_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order_master` (`order_id`),
  ADD CONSTRAINT `order_detail_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product_info` (`product_id`);

--
-- 限制表 `order_master`
--
ALTER TABLE `order_master`
  ADD CONSTRAINT `order_master_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer_inf` (`customer_id`);

--
-- 限制表 `product_comment`
--
ALTER TABLE `product_comment`
  ADD CONSTRAINT `product` FOREIGN KEY (`product_id`) REFERENCES `product_info` (`product_id`),
  ADD CONSTRAINT `product_comment_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order_master` (`order_id`),
  ADD CONSTRAINT `product_comment_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customer_inf` (`customer_id`);

--
-- 限制表 `product_info`
--
ALTER TABLE `product_info`
  ADD CONSTRAINT `product_info_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplier_info` (`supplier_id`);

--
-- 限制表 `product_pic_info`
--
ALTER TABLE `product_pic_info`
  ADD CONSTRAINT `product_pic_info_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product_info` (`product_id`);

--
-- 限制表 `product_sku`
--
ALTER TABLE `product_sku`
  ADD CONSTRAINT `product_sku_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product_info` (`product_id`);

--
-- 限制表 `shop_cart`
--
ALTER TABLE `shop_cart`
  ADD CONSTRAINT `shop_cart_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer_inf` (`customer_id`),
  ADD CONSTRAINT `shop_cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product_info` (`product_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
