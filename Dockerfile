FROM ubuntu:16.04

MAINTAINER lhuang9703

WORKDIR /root

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted && \
        deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted && \
        deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial universe && \
        deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates universe && \
        deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial multiverse && \
        deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates multiverse && \
        deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse && \
        deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted && \
        deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security universe deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security multiverse" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y openssh-server openssh-client openjdk-8-jdk wget vim curl net-tools scala

RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/core/stable2/hadoop-3.2.1.tar.gz && \
    tar -xzvf hadoop-3.2.1.tar.gz && \
    mv hadoop-3.2.1 /usr/local/hadoop && \
    rm hadoop-3.2.1.tar.gz && \
    wget https://mirrors.cnnic.cn/apache/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz && \
    tar -zxvf spark-2.4.4-bin-hadoop2.7.tgz -C /usr/local/ && \
    mv /usr/local/spark-2.4.4-bin-hadoop2.7 /usr/local/spark-2.4.4

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop 
ENV SPARK_HOME=/usr/local/spark-2.4.4
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:$SPARK_HOME/bin

RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    cp /tmp/slaves $SPARK_HOME/conf/ && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/start-spark.sh ~/start-spark.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/start-spark.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x $SPARK_HOME/sbin/start-all.sh

ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"

RUN /usr/local/hadoop/bin/hdfs namenode -format

EXPOSE 22

CMD [ "sh", "-c", "service ssh start; bash"]
