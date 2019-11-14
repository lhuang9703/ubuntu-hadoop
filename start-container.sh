#! /bin/sh
#
# start-container.sh
# Copyright (C) 2019 lhuang <lhuang9703@gmail.com>
#
# Distributed under terms of the MIT license.
#

# the default node number is 3
N=${1:-3}


# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -v /Users/lhuang/ubuntu-hadoop/corpus:/usr/Downloads:ro \
                -p 50070:50070 \
                -p 8088:8088 \
                --name hadoop-master \
                --hostname hadoop-master \
                lhuang9703/ubuntu-hadoop:2.1 &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                lhuang9703/ubuntu-hadoop:2.1 &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash
