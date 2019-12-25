# ubuntu-hadoop

```
├── Dockerfile
├── build-image.sh
├── config
│   ├── core-site.xml
│   ├── hadoop-env.sh
│   ├── hdfs-site.xml
│   ├── mapred-site.xml
│   ├── run-invertedindex.sh
│   ├── run-wordcount.sh
│   ├── slaves
│   ├── spark-env.sh
│   ├── ssh_config
│   ├── start-hadoop.sh
│   ├── start-spark.sh
│   └── yarn-site.xml
├── data
│   └── collection.tsv
├── pkg
│   ├── hadoop-3.2.1.tar.gz
│   └── spark-2.4.4-bin-hadoop2.7.tgz
├── src
│   ├── get_text.py
│   ├── inverted_index
│   │   ├── mapper.py
│   │   └── reducer.py
│   └── word_count
│       ├── mapper.py
│       └── reducer.py
└── start-container.sh
```

```
RUN apt-get update && apt-get install -y openssh-server openssh-client openjdk-8-jdk wget vim curl net-tools
```

```
RUN tar -xzvf hadoop-3.2.1.tar.gz && \
    mv hadoop-3.2.1 /usr/local/hadoop && \
    rm hadoop-3.2.1.tar.gz
```

```
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

```
COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    cp /tmp/slaves $SPARK_HOME/conf/ && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
```

```
sudo docker network create --driver=bridge hadoop
```

```
sudo docker run -itd \
                --net=hadoop \
                -v /Users/lhuang/ubuntu-hadoop/data:/usr/Downloads:ro \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                lhuang9703/ubuntu-hadoop:2.2
```

```
sudo docker run -itd \
                    --net=hadoop \
                    --name hadoop-slavei \
                    --hostname hadoop-slavei \
                    lhuang9703/ubuntu-hadoop:2.2
```

```
hadoop fs -mkdir -p input
```

```
hdfs dfs -put /usr/Downloads/* input
```

```
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-3.2.1.jar \
    -files ./mapper.py, ./reducer.py \
    -mapper ./mapper.py \
    -reducer ./reducer.py \
    -input input/small_data.txt \
    -output output
```
