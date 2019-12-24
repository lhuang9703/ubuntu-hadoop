# ubuntu-hadoop

>> ├── Dockerfile
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
