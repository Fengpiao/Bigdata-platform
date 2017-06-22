/*
Navicat MySQL Data Transfer

Source Server         : 192.168.130.115_3310
Source Server Version : 50711
Source Host           : 192.168.130.115:3310
Source Database       : pasdb

Target Server Type    : MYSQL
Target Server Version : 50711
File Encoding         : 65001

Date: 2017-01-19 10:42:20
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for alg
-- ----------------------------
DROP TABLE IF EXISTS `alg`;
CREATE TABLE `alg` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `alg_type_id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `download_url` varchar(500) DEFAULT NULL,
  `short_desc` text,
  `long_desc` text,
  `index_num` int(11) DEFAULT NULL,
  `pic_url` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2018 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of alg
-- ----------------------------
INSERT INTO `alg` VALUES ('2000', '1000', 'autoplait', null, 'autoplait算法使用隐马尔可夫模型（HMM)和最小描述长度原则（MDL)对多元时间序列进行切割。', 'autoplait算法使用隐马尔可夫模型（HMM)和最小描述长度原则（MDL)对多元时间序列进行切割。甚至在切割时还能发现某种内在相似性(比如运动数据，切割后的结果有胳膊与腿同时上抬的片段，也有抬胳膊而放下腿的片段，符合自然切分)。\r\ndata(\"windpower\", package = “TSTreeSplit”)\r\nret <- autoplait(windpower)', '1', '/autoplait.png');
INSERT INTO `alg` VALUES ('2001', '1000', 'TSTreeSplit', null, 'TSTreeSplit算法使用hog1d特征对时间序列进行符号化（若不同的时间点被符号化为同一个符号，即表示这些不同点的小邻域内形状是相似的）。', 'TSTreeSplit算法使用hog1d特征对时间序列进行符号化（若不同的时间点被符号化为同一个符号，即表示这些不同点的小邻域内形状是相似的）。再对符号序列根据子序列的相似性进行树形切割((递归进行，每个节点分割时，都选择最佳点，使左子节点内部相似性最大且右子节点内部相似性最大)。 控制参数，minLength，表示非叶子结点的最小长度，默认值是200。这个值越小，序列会被切分的越细致。所以建议对较长序列，改用较大的值。\r\ndata(\"windpower\")\r\nseries <- windpower$generator_spd\r\ntemp <- symbolizeTSindividually(series, c(),c(),c())\r\nrootnode<-splitTree(temp, minLength = 200)', '2', '/TStreeSplit.png');
INSERT INTO `alg` VALUES ('2002', '1000', 'MoenR', '', 'MoenR是发现时间序列的相似模式motif的moen算法的R语言实现。该算法的优点在于不固定Motif长度，而是只需要指定长度范围，算法自动找出此范围内不同长度的相似模式。', 'MoenR是发现时间序列的相似模式motif的moen算法的R语言实现。该算法的优点在于不固定Motif长度，而是只需要指定长度范围，算法自动找出此范围内不同长度的相似模式。控制参数，minlength, 需要指定的长度范围的最小值，maxlength, 需要指定的长度范围的最大值。长度区间为左开右闭，即包含minlength，不含maxlength。\r\ndata(test, package = \"TSMining\")\r\nts1 <- test$TS1\r\nret <- moen(ts1, minlength = 9, maxlength = 11)', '3', '/MoenR.png');
INSERT INTO `alg` VALUES ('2003', '1001', 'diss.COR()', 'https://cran.r-project.org/src/contrib/TSclust_1.2.3.tar.gz', '计算基于复杂度估计的修正的时间序列的欧几里得距离。', '计算基于复杂度估计的修正的时间序列的欧几里得距离。', '4', '/classify.png');
INSERT INTO `alg` VALUES ('2004', '1001', 'kmeans()', 'https://cran.r-project.org/', '在数据矩阵上运行K-means聚类分析。', '在数据矩阵上运行K-means聚类分析。', '5', '/classify.png');
INSERT INTO `alg` VALUES ('2005', '1001', 'hclust()', 'https://cran.r-project.org/', '在相异度数据集上的层次聚类分析。', '在相异度数据集上的层次聚类分析。', '6', '/classify.png');
INSERT INTO `alg` VALUES ('2006', '1001', 'diss.CID()', 'https://cran.r-project.org/src/contrib/TSclust_1.2.3.tar.gz', '计算基于复杂度估计的修正的时间序列的欧几里得距离。', '计算基于复杂度估计的修正的时间序列的欧几里得距离。', '7', '/classify.png');
INSERT INTO `alg` VALUES ('2007', '1002', 'lm() ', 'https://cran.r-project.org/', 'lm() 函数用于线性模型的拟合。它可以用于实施模型的回归以及单层的方差分析（尽管函数aov() 可以提供更方便的界面）。', 'lm() 函数用于线性模型的拟合。它可以用于实施模型的回归以及单层的方差分析（尽管函数aov() 可以提供更方便的界面）。', '8', '/clustering.png');
INSERT INTO `alg` VALUES ('2008', '1002', 'glm()', 'https://cran.r-project.org/', 'glm() 函数用于一般线性模型的拟合，特别当给定线性预测的符号描述以及误差分布的描述', 'glm() 函数用于一般线性模型的拟合，特别当给定线性预测的符号描述以及误差分布的描述', '9', '/clustering.png');
INSERT INTO `alg` VALUES ('2009', '1002', 'nnet()', 'https://cran.r-project.org/src/contrib/nnet_7.3-12.tar.gz', '拟合单隐藏层神经网络，可以附带跳层联结。', '拟合单隐藏层神经网络，可以附带跳层联结。', '10', '/clustering.png');
INSERT INTO `alg` VALUES ('2010', '1002', 'coxph()', 'https://cran.r-project.org/src/contrib/survival_2.39-5.tar.gz', '拟合 COX 比例风险回归模型。在使用Andersen和Gill的计数过程公式的情况下，时间依赖变量，时间依赖层，单体多事件以及其他拓展会被混合。', '拟合 COX 比例风险回归模型。在使用Andersen和Gill的计数过程公式的情况下，时间依赖变量，时间依赖层，单体多事件以及其他拓展会被混合。', '11', '/clustering.png');
INSERT INTO `alg` VALUES ('2011', '1003', 'princomp()', 'https://cran.r-project.org/', 'Princomp() 在给定的数值矩阵上进行主成分分析并且返回值作为一个类型的对象。', 'Princomp() 在给定的数值矩阵上进行主成分分析并且返回值作为一个类型的对象。', '12', '/discrimination.png');
INSERT INTO `alg` VALUES ('2012', '1003', 'randomForest()', 'https://cran.r-project.org/src/contrib/randomForest_4.6-12.tar.gz', 'andomForest() 运行Breiman的随机森林算法（基于Breiman和Cutler的源Fortran代码）来分类与回归。', 'randomForest() 运行Breiman的随机森林算法（基于Breiman和Cutler的源Fortran代码）来分类与回归。它可以被用于无人监管的模式来评估数据点的相似度。', '13', '/discrimination.png');
INSERT INTO `alg` VALUES ('2013', '1003', 'factanal()', 'https://cran.r-project.org/', '基于相关性矩阵或者数据矩阵运行最大似然因子分析。', '基于相关性矩阵或者数据矩阵运行最大似然因子分析。', '14', '/discrimination.png');
INSERT INTO `alg` VALUES ('2014', '1004', 'Apriori()', 'https://cran.r-project.org/src/contrib/arules_1.5-0.tar.gz', '利用Apriori算法发掘常见物品集，关联规则或者超边关联。Apriori算法利用逐级搜索常见物品集。Apriori算法的实施通常包含许多进阶算法。（例如，prefix树和物品分类）', '利用Apriori算法发掘常见物品集，关联规则或者超边关联。Apriori算法利用逐级搜索常见物品集。Apriori算法的实施通常包含许多进阶算法。（例如，prefix树和物品分类）', '15', '/linked.png');
INSERT INTO `alg` VALUES ('2015', '1005', 'ksvm () ', 'https://cran.r-project.org/src/contrib/kernlab_0.9-25.tar.gz', '支持向量机是一种杰出的分类，异常检测和回归工具。', '支持向量机是一种杰出的分类，异常检测和回归工具。ksvm () 支持著名的C-svc，nu-svc，one-class-svc，eps-svr，nu-svr公式以及简单的多种类分类公式和有界的SVM公式。\r\nksvm ()也支持经典概率概率输出以及回归的置信区间。', '16', '/regress.png');
INSERT INTO `alg` VALUES ('2016', '1006', 'lda()', 'https://cran.r-project.org/src/contrib/MASS_7.3-45.tar.gz', '线性判别分析', '线性判别分析', '17', '/related.png');
INSERT INTO `alg` VALUES ('2017', '1007', 'cor()', 'https://cran.r-project.org/', 'Var(),cov()和cor()计算x的方差以及x和y的协方差或者相关系数如果它们是向量的话。', 'Var(),cov()和cor()计算x的方差以及x和y的协方差或者相关系数如果它们是向量的话。如果x和y是矩阵，那么计算的就是x与y列之间的协方差或者相关系数。', '18', '/related.png');
