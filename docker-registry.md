** 部署私有Docker Registry  

1.主节点上编辑/etc/default/docker文件，末尾添加上  

    DOCKER_OPTS="$DOCKER_OPTS --insecure-registry 166.111.7.245:5000"

保存后重启docker。    

    $ sudo service docker restart  

2.主节点上后台启动registry容器  

    $ docker run -d -p 5000:5000 166.111.7.245:5000/registry  

3. 主节点上给镜像打上tag 并且推送到到 insecure registry上去  

    $ docker push 166.111.7.245:5000/mysql:5.7.11  

查看私有仓库的镜像  
curl http://166.111.7.245:5000/v2/mysql/tags/list 返回 {"name":"mysql","tags":["5.7.11"]}  
这时候镜像成功push到私有仓库上去了。  

4.其他节点上同样要编辑 /etc/default/docker 文件，末尾添加上  

    DOCKER_OPTS="--insecure-registry 166.111.7.245:5000"  

保存后重启docker  

    $ sudo service docker restart  

5.其他主机上pull mysql  

    $ sudo docker pull 166.111.7.245:5000/mysql:5.7.11  
