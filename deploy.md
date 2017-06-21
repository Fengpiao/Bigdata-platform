## 1.preparation
##### 免密验证  
确保是root用户或者有sudo权限的免密码验证用户，给用户赋权并且免密码操作：  
在 /etc/sudoers文件中加上一行  

	cst ALL=(ALL:ALL) NOPASSWD:ALL   

##### 修改主机名  

	$ sudo sysctl kernel.hostname=cdh1  
    
修改hostname，注释127.0.1.1那一行并且添加所有节点ip和hostname的映射关系  

	$ sudo vi /etc/hosts  

修改好host后，重启网络生效  

	$ sudo /etc/init.d/networking restart  

##### 时间同步  
主节点上操作：  

	$ sudo  apt-get update && sudo apt-get install -y ntp  
	
向文件中添加下列配置行使LAN中其它主机能够访问该服务，其中的CIDR地址根据物理主机的网络情况更改  

	$ sudo vi /etc/ntp.conf  

	#上层ntp服务  
	server 166.111.7.245 prefer  
	#如果在/etc/ntp.conf中定义的server都不可用时，让NTP server和自身保持同步将使用local 时间作为ntp服务提供给ntp客户端  
	server 127.127.1.0  
	fudge 127.127.1.0 stratum 10  
	#允许这个网段的对时请求  
	restrict 166.111.7.0 mask 255.255.255.0 nomodify notrap  
	
重启服务  

	# sudo service ntp restart  

验证  

	# ntpq -p  

其他节点上：  

	$ sudo apt-get update && sudo apt-get install -y ntp
	$ sudo vi /etc/ntp.conf
	server 166.111.7.245  

重启服务  

	# sudo service ntp restart  

验证  

	# ntpq -p

可以看到offset 特别小，这个过程需要一段时间可以待会儿再回来验证。

##### 关闭SWAP  
为了避免swap带来的性能损耗，要求将部署KMX的各节点swap功能关闭，打开主机的/etc/fstab，注释掉swap挂载点相关的行：  

重启主机，或者执行如下命令使配置生效：  

	$ sudo swapoff -a  

##### 设置swap空间  

	$ sudo vim /etc/sysctl.conf  

末尾加上  

	vm.swappiness=10  

执行下面命令生效  

	$ sudo sysctl -p  

其它节点上执行相同操作。  

##### SSH免密匙登陆  

	$ ssh-keygen -t rsa  

一路回车直至结束, 默认情况下会在~/.ssh文件夹下生成两个文件,id_rsa和id_rsa.pub, 将id_rsa.pub输出到authorized_keys文件中  

	$ cd ~/.ssh  
	$ cat id_rsa.pub >>authorized_key_1  

所有的机器上均执行上述操作生成authorized_key_* 文件后，将所有机器上的authorized_key_* 文件拷贝到第一台机器的~/.ssh文件夹下。  

	cst@s2:~/src/spark$ scp authorized_key_2 cst@166.111.7.244:~/.ssh/authorized_key_2  
	cst@s3:~/src/spark$ scp authorized_key_3 cst@166.111.7.244:~/.ssh/authorized_key_3  

在pc1上将所有的authorized_keys合并为一个  

	cat authorized_keys_*  >>authorized_keys  

将authorized_keys发送到每台机器  

	cst@s1:~/.ssh$ scp authorized_keys cst@166.111.7.245:~/.ssh/authorized_keys  
	cst@s1:~/.ssh$ scp authorized_keys cst@166.111.7.246:~/.ssh/authorized_keys  

将authorized_keys文件的权限改为600，每台机子上操作：  

	$ chmod 600 authorized_keys  

在任何一台机器上使用ssh 免密码登陆，则说明配置成功  

## 2.Installing  
##### 安装java  
从oracle官网上下载linux 64bit的JDK8，解压后设置环境变量，在/etc/profile文件末尾添加  

	$ sudo vim /etc/profile  
	# setting java  
	export JAVA_HOME=/usr/java/jdk1.8  
	export PATH=$JAVA_HOME/bin:$PATH  

wq 保存退出。   

	# source /etc/profile  
 
编辑/etc/environment 设置全局变量

	$ sudo vim /etc/environment

修改内容如下：

	$ source /etc/environment

##### 离线安装Docker
解压安装包，所有节点上执行以下指令完成安装  

	$ sudo tar zxvf docker-offline-package-1.2.1-release.tar.gz  
	$ cd docker-offline-package  
	$ sudo ./install.sh all  

复制文件到另外两台机子上，并执行相同操作。

##### 离线安装etcd
为了能够搭建docker集群，我们需要借助etcd创建docker overlay网络。  

	$ tar xzvf etcd-v2.3.1-linux-amd64.tar.gz  
	$ cd etcd-v2.3.1-linux-amd64  

修改etcd.conf,修改ip  

	server1=http://166.111.7.245  
	server2=http://166.111.7.246  
	server3=http://166.111.7.247  
	server4=http://166.111.7.248  
	server5=http://166.111.7.250  
	
tip:etcd集群至少配三个，且为奇数。  
拷贝文件到其他节点上  

	$ scp -r /home/cst/src/etcd-v2.3.1-linux-amd64/ cst@166.111.7.246:/home/cst/src

在每个server上执行相对应的命令：  

	$ sudo./start.sh server[]  


或者

	./etcd  --name server2 
		--listen-client-urls http://166.111.7.246:2379 
		--advertise-client-urls http://166.111.7.246:2379 
		--listen-peer-urls http://166.111.7.246:2380 
		--initial-advertise-peer-urls http://166.111.7.246:2380 
		--initial-cluster-token etcd-cluster-1 
		--initial-cluster 'server1=http://166.111.7.246:2380,server2=http://166.111.7.246:2380,server3=http://166.111.7.247:2380,server4=
		http://166.111.7.248:2380,server5=http://166.111.7.250:2380' 
		--initial-cluster-state new 
		--enable-pprof

验证:
在上面每个节点上都启动etcd之后，在任意一个节点上执行  

	./etcdctl --endpoints http://166.111.7.246:2379 cluster-health  

能看到：

到此只是完成了etcd服务端的安装，还需要对每个KMX节点做如下设置：  

$ sudo vim /etc/default/docker  

添加下面内容：  

	DOCKER_OPTS="$DOCKER_OPTS -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock"  
	DOCKER_OPTS="$DOCKER_OPTS --cluster-store=etcd://166.111.7.245:2379,166.111.7.246:2379,166.111.7.247:2379 --cluster-advertise=eth0:4243"  

重启docker   

	$ sudo service docker restart  

确认生效  

	$ sudo docker info 

打开浏览器访问 http://166.111.7.245:2379/v2/keys/docker/nodes，应看到所有docker工作机都被注册。访问etcd集群的其它节点（更换上面地址中的ip，其它地址不变），应该能看到相同的内容。

安装KMX
导入开-compose镜像包
$ sudo docker load < k2-compose-0_4_0.tar
类似这样导完其他的镜像包，导完执行$ sudo docker images 总共应该可以看到44个镜像。

生产配置文件
KMX提供了命令行工具，启动方式如下：
$ sudo docker run -it --rm -v $(pwd):/k2-compose-files kmx.k2data.com.cn:5000/k2data/k2-compose:1.2.1 config

Kafka
执行下列操作：
k2-compose up -d kafka1   #根据k2-compose文件中实际的kafka服务个数启动

验证：
在任意一台工作机上执行下列操作进入验证环境：
$ sudo docker run -it --rm --net=prodyct_default --entrypoint bash kmx.k2data.com.cn:5000/k2data/kafka:1.2.1-0.8.2.2
进入容器后
# cd /opt/apache/kafka_2.10-0.8.2.2
# bin/kafka-topics.sh --zookeeper 166.111.7.246 --list
# bin/kafka-topics.sh --zookeeper 166.111.7.246 --create --partitions=1 --topic k2_test --replication-factor=1
成功返回 Created topic "k2_test".
# bin/kafka-topics.sh --zookeeper 166.111.7.246 --describe                                                    
Topic:k2_test	PartitionCount:1	ReplicationFactor:1	Configs:
	Topic: k2_test	Partition: 0	Leader: 1	Replicas: 1	Isr: 1
root@97db2625e590:/opt/apache/kafka_2.10-0.8.2.2# bin/kafka-topics.sh --zookeeper 166.111.7.246 --list
k2_test
# bin/kafka-console-producer.sh --broker-list 166.111.7.246:9092 --topic k2_test
[2017-04-06 13:57:27,138] WARN Property topic is not valid (kafka.utils.VerifiableProperties)
test1
test2 
# bin/kafka-topics.sh --zookeeper 166.111.7.246 --topic k2_test --from-beginning
# bin/kafka-topics.sh --zookeeper 166.111.7.246 --delete --topic k2_test
Topic k2_test is marked for deletion.
Note: This will have no impact if delete.topic.enable is not set to true.
# bin/kafka-topics.sh --zookeeper 166.111.7.246 --list

STORM
执行下列操作：
k2-compose up -d storm-ui
k2-compose up -d storm-nimbus # k2-compose up -d --ignore-deps storm-nimbus
k2-compose up -d storm-supervisor1  #根据k2-compose文件中包含的实际storm-supervisor数目启动

页面验证
在浏览器中打开http://<node1_ip>:8080，有几个super 就能看到几个



ActiveMQ
k2-compose up -d activemq
验证：
在浏览器中打开http://<node2_ip>:8161，用户名密码都是admin


ElasticSearch
k2-compose up -d elasticsearch
访问 http://stream1-ip:9200地址，看到如下信息表示正确安装：


Logstash
k2-compose up -d logstash-batch1  #根据k2-compose文件确定实际的数量

DDM
k2-compose up -d ddm-audit-db
k2-compose bash ddm-audit-db #进入audit-db容器
mysql -uroot -ppassw0rd -e "show databases;"
正常情况可以看到如下信息：


启动flag-db
启动flag-db前先 rm -rf /kmx/flag-db，不然会导致数据库初始化时stats相关数据库无法创建
k2-compose up -d ddm-flag-db
k2-compose bash ddm-flag-db #进入flag-db容器
mysql -uroot -ppassw0rd -e "show databases;"   #查看数据库


初始化ddm环境
执行下列操作，确保每步操作返回码都是exit with code 0：
k2-compose -f config.yml up ddm-conf #向zookeeper中写入配置信息
k2-compose -f config.yml up ddm-reset1  #清空audit-db和storm拓扑
k2-compose -f config.yml up ddm-reset2  #清空kafka中的topic数据
k2-compose -f config.yml up ddm-avro-hdfs-topo  #提交基础拓扑：auditTopology, DataLoadScheduleTopology, HdfsTopology和HdfsTopology_anormaly
k2-compose -f config.yml up ddm-raw-avro-topo  #提交协议转化拓扑（json格式）：AdapterTopology
k2-compose -f config.yml up ddm-raw-avro-topo-binary  #提交协议转化拓扑（二进制格式）：BinaryAdapterTopology

访问地址http://<node1_ip>:8080/index.html，在topology summary中看到如下7个拓扑，确保每个拓扑的Num workers不等于0：

其中一个为0但点进去后没有发现error,第一个点进去发现了error"java.lang.RuntimeException: java.lang.RuntimeException: java.lang.RuntimeException: org.apache.zookeeper.KeeperException$ConnectionLossException: KeeperErrorCode = ConnectionLoss for /brokers/topics/d",
查看日志文件 http://166.111.7.246:8000/log?file=AdapterTopology-13-1491491766-worker-6700.log
没有error信息并且“Session establishment complete on server 166.111.7.246/166.111.7.246:2181, sessionid = 0x15b43e66b550029, negotiated timeout = 40000”可以不用管
重点check：
SchedulerTopology的Spout log，查看方法是：
在Storm ui首页http://<node1_ip>:8080/index.html点击SchedulerTopology名字，跳转页面后在Spouts区域点击“scheduler-spout”名字，进入spout界面；在Executors区域点击Port端口，修改跳转地址中的域名，比如http://storm-supervisor2:8000/log?file=SchedulerTopology-29-1490003819-worker-6705.log中的storm-supervisor2替换为实际部署storm-supervisor2的主机ip（此处是node4的ip）
点击Download full log，下载完整日志，正常情况下日志中不应该包含错误栈或者Error信息。
HdfsTopology的Spout log，查看方法与上述DataLoadScheduleTopology类似，不过这里的Spout名称为"hdfs-kafka-spout"，同样需要确保spout日志中不能包含错误栈或者Errors信息。

安装ddm-message-handler
k2-compose up -d ddm-message-handler
验证：
访问地址http://<node2_ip>:8161/admin/queues.jsp，确保Queues中有两个队列，并且每个队列的Number of Consumers不为0：


ddm-audit-rest
k2-compose up -d ddm-audit-rest
验证：
访问http://<as1_ip>:8087/storm/topologies，有如下数据就是成功。
"code":0,"message":"success"


ddm-batch-rest
k2-compose up -d ddm-batch-rest
验证：
访问http://<as1_ip>:8124/batch-rest/workflows，有如下数据就是成功。
"code":0,"message":"success"

batchload
k2-compose up -d batchload

ddm-batch-task
k2-compose up -d ddm-batch-task

K2DB
k2-compose up -d k2db-server1 k2db-server2 k2db-server3 k2db-server4  #根据k2-compose文件中包含的实际k2db-server个数启动
k2-compose up -d k2db-haproxy
k2-compose up -d k2db-rest
验证：
访问地址http://<node2_ip>:8089/data-service/v3/health，返回如下结果：


SDM
k2-compose up -d sdm-db
k2-compose -f config.yml up sdm-api-reset   #正常情况执行结果exited with code 0
k2-compose up -d sdm-api
验证：
访问http://<node2_ip>:8081/data-service/v2/field-groups，返回如下结果：


TUB
k2-compose up -d tub-db
k2-compose up -d tub-server
验证：
访问http://<as1_ip>:21691/tub/v1/health，返回如下结果：


1.2.1版本不用安装CAS，但是需要k2-compose.yaml文件中
pas和pas-ui中的配置
USE_CAS: 'true'
改为USE_CAS: 'false'

DDS
DDS提供通过REST接口向KMX写入实时数据的服务。
k2-compose up -d  dds-api
验证：
访问地址http://<node2_ip>:8082/data-service/v2/channels/health，返回如下结果：


PAS
执行下列操作：
k2-compose up -d pas-db
k2-compose -f config.yml up pas-db-init #初始化数据库,会重新建表清空所有数据
k2-compose up -d rserve1
k2-compose up -d rserve2
...                                     #rserve个数和datanode个数一样
k2-compose up -d pas
k2-compose up -d pas-ui

准备模型库数据:
执行步骤:
1.文件上传到pas-db宿主机 /kmx/pas/tmp 目录下



2.进入pas-db镜像 :docker exec -it [docker name] bash
3.mysql -uroot -ppassw0rd
   mysql>use pasdb;
   mysql>set names utf8;
   mysql>source /kmx/pas/tmp/alg_type.sql
   mysql>source /kmx/pas/tmp/alg.sql
验证：
访问地址http://<node2_ip>:8085/pas/services/health，返回如下结果：

2. k2-compose bash pas
进入容器后
sh /usr/local/kmx/pas/sbin/runDemo.sh
如果成功，则pas可用。

Console
k2-compose up -d console
验证:
访问http://<as1_ip>:5002

Merge
通过merge合并load产生的小文件
k2-compose up -d k2db-merge
验证
k2-compose bash k2db-merge

在k2db-merge容器中
crontab -l
会得到如下结果：
0 12 1-31 1-12 0-6 /opt/k2data/startMerge.sh
*/10 * * * * /opt/k2data/startRollback.sh

动态时序数据的聚合服务
# 天粒度的聚合 参加DDM部分的ddm-batch-task部署，ddm-batch-task包含了对实时数据和批量数据的天粒度聚合
k2-compose up -d stats-task-week  # 周粒度的聚合
k2-compose up -d stats-task-month # 月粒度的聚合
k2-compose up -d stats-task-year  # 年粒度的聚合

验证：
k2-compose  logs -f stats-rotation-day # 查看天粒度的数据轮转服务启动日志
k2-compose logs -f stats-task-week #查看周粒度的聚合服务启动日志
k2-compose logs -f stats-task-month #查看月粒度的聚合服务启动日志
k2-compose logs -f stats-task-year #查看年粒度的聚合服务启动日志

动态时序数据轮转服务
k2-compose up -d stats-rotation-day   # 天粒度的数据轮转
k2-compose up -d stats-rotation-week  # 周粒度的数据轮转
k2-compose up -d stats-rotation-month # 月粒度的数据轮转
k2-compose up -d stats-rotation-year  # 年粒度的数据轮转
(注意：该服务可按需选择启动或不启动。说明：如果不启动此轮转服务，可通过在查询语句中不指定aggregationOptions且设置 timeRange.start、timeRange.end为自然年起始值来实现对历史全量数据的统计查询)

验证：
k2-compose  logs -f stats-rotation-day # 查看天粒度的数据轮转服务启动日志
k2-compose logs -f stats-task-week #查看周粒度的聚合服务启动日志
k2-compose logs -f stats-task-month #查看月粒度的聚合服务启动日志
k2-compose logs -f stats-task-year #查看年粒度的聚合服务启动日志

上述验证执行完每一步操作后应该出现类似这样的返回结果：
