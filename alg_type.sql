/*
Navicat MySQL Data Transfer

Source Server         : 192.168.130.115_3310
Source Server Version : 50711
Source Host           : 192.168.130.115:3310
Source Database       : pasdb

Target Server Type    : MYSQL
Target Server Version : 50711
File Encoding         : 65001

Date: 2017-01-19 10:42:11
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for alg_type
-- ----------------------------
DROP TABLE IF EXISTS `alg_type`;
CREATE TABLE `alg_type` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `index_num` int(11) DEFAULT NULL,
  `pic_url` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1008 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of alg_type
-- ----------------------------
INSERT INTO `alg_type` VALUES ('1000', '自定义模型', null, '0', null);
INSERT INTO `alg_type` VALUES ('1001', '聚类模型', '聚类分析是一种把物体分类的任务。它分类的准则是将一些更为相似的（根据某些给定的标准）物体分为一组。它是探索性数据挖掘的主要任务，同时也是统计数据分析中一种常见的技术。聚类分析可用于许多领域，包括：机器学习，模式识别，图像分析，信息检索，生物信息学，数据压缩，计算机图像。一个常见的聚类模型R package 是 Tsclust。 Tsclust 是一个功能强大的时间序列聚类分析软件包。整个包内含有约30个函数，收录了各种标准下的各种不同的聚类方法。其聚类方法主要有：无模型的方法，基于模型的方法，基于复杂度的方法，基于预测的方法。', '1', '/classify.png');
INSERT INTO `alg_type` VALUES ('1002', '回归模型', '在统计建模中，回归分析是一种估计变量之间关系的统计过程。当我们关注于一个不独立的变量和一个或多个独立变量之间的关系的时候，回归分析包含许多针对建模与分析这些变量的技术。更为详细的说，当其余独立变量保持不变的时候，回归分析可以帮助我们理解不独立的变量的值是如何变化的当任意一个独立变量的值发生改变。', '2', '/clustering.png');
INSERT INTO `alg_type` VALUES ('1003', '降维模型', '在机器学习与统计学中，降维是一个降低考虑的随机变量数量的过程。实现这个目标是靠获得一个主要变量的集合。降维可分为特征选择和特征去除两种方式。', '3', '/discrimination.png');
INSERT INTO `alg_type` VALUES ('1004', '关联分析模型', '关联规则学习是一种发现大数据集中变量之间的有趣关系的方法。它是意欲依靠一些我们感兴趣的测量标准去确认数据中的强的规律。', '4', '/linked.png');
INSERT INTO `alg_type` VALUES ('1005', '分类模型', '在机器学习和统计学中，分类是一种基于一个包含观测值（或者实例）的训练集的种类成员是已知的情况下，鉴别一个新的观察量属于哪一个种类集（子总体）的问题。', '5', '/regress.png');
INSERT INTO `alg_type` VALUES ('1006', '判别分析模型', '判别方程分析是一种依靠一个或多个连续或二进制独立变量（又叫预测变量）去预测一个分类的依赖变量（又叫分组变量）的统计分析。这种叉状分类分析的原理在1936年被Ronald Fisher爵士所发展。', '6', '/related.png');
INSERT INTO `alg_type` VALUES ('1007', '相关分析模型', '相关性是任意一种广泛种类的统计关系包含依赖性，尽管在一般的应用中，它多指两个变量之间线性关系的程度。', '7', '/related.png');
