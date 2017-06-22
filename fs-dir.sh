!/bin/bash

export HADOOP_USER_NAME=hdfs

# for history server
hadoop fs -mkdir /tmp
hadoop fs -chmod 777 /tmp
hadoop fs -mkdir /var
hadoop fs -chmod 777 /var

# for ddm
hadoop fs -mkdir -p /user/hive/warehouse
hadoop fs -chown -R impala /user/hive
hadoop fs -chgrp -R impala /user/hive

hadoop fs -mkdir -p /user/history
hadoop fs -chown -R mapred /user/history
hadoop fs -chgrp -R mapred /user/history
hadoop fs -chmod -R 775 /user/history

hadoop fs -mkdir -p /bigdata/dataplatform/processing/csvdata
hadoop fs -mkdir -p /bigdata/dataplatform/processing/rawdata
hadoop fs -mkdir -p /bigdata/dataplatform/batch/data
hadoop fs -chmod -R 777 /bigdata/dataplatform

# for k2db
hdfs dfs -mkdir -p /bigdata/dataplatform/_k2db_sys_v1_1/

# for pas
hadoop fs -mkdir -p /pas/output
hadoop fs -chmod 1777 /pas/output
hadoop fs -chmod 1777 /tmp
hadoop fs -chmod 1777 /user
hadoop fs -chmod 1777 /user/hive
hadoop fs -chmod 1777 /user/hive/warehouse
hadoop fs -chmod 1777 /user/history
hadoop fs -mkdir -p /user/history/done_intermediate/hive
hadoop fs -chmod 1777 /user/history/done_intermediate
hadoop fs -chmod 1777 /user/history/done_intermediate/hive