# Command lines for the Project 3
# "Performance Benchmarking MongoDB, Hadoop & PySpark for COVID-19 Data Analytics"


# To get PC specs
inxi -CGD
docker version --format '{{.Client.Version}}'
docker info --format 'CPUs: {{.NCPU}} | Total RAM: {{.MemTotal}}'
free -h

# Starting Hadoop, PySpark and MongoDB
docker images
docker run -d \
  --name mongo-benchmark \
  -p 27017:27017 \
  -v mongo_data:/data/db \
  mongo:latest

docker run -d \
  --name pyspark-benchmark \
  -p 8888:8888 \
  -p 4040:4040 \
  -v "$PWD:/home/jovyan/work" \
  jupyter/pyspark-notebook:latest
  
docker exec -it hadoop bash
cd $HADOOP_PREFIX 


# Question 1
nano Map1.py
nano Red1.py
docker cp Map1.py hadoop:/tmp/Map1.py
docker cp Red1.py hadoop:/tmp/Red1.py
docker cp ../../covid.csv hadoop:/tmp/covid.csv
./bin/hdfs dfs -mkdir COVID
./bin/hdfs dfs -put /tmp/covid.csv COVID

# HADOOP
time bash -c './bin/hadoop jar share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
  -mapper "python Map1.py" \
  -reducer "python Red1.py" \
  -input COVID/covid.csv \
  -output COVID/MR1 \
  -file /tmp/Map1.py \
  -file /tmp/Red1.py
'

./bin/hdfs dfs -cat COVID/MR1/part-* | head -n 5
./bin/hdfs dfs -cat COVID/MR1/part-* | tail -n 5



# MONGODB
docker start mongo-benchmark
docker cp covid.csv mongo-benchmark:/tmp/covid.csv
docker exec mongo-benchmark mongoimport   --db covid_db   --collection covid_weekly   --type csv   --headerline   --file /tmp/covid.csv

# PySpark
docker start pyspark-benchmark
docker exec -it pyspark-benchmark bash



# Question 2
# Hadoop
nano Map2.py
nano Red2.py
docker cp Map2.py hadoop:/tmp/Map2.py
docker cp Red2.py hadoop:/tmp/Red2.py

time bash -c './bin/hadoop jar share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
  -mapper "python Map2.py" \
  -reducer "python Red2.py" \
  -input COVID/covid.csv \
  -output COVID/MR2 \
  -file /tmp/Map2.py \
  -file /tmp/Red2.py
'

./bin/hdfs dfs -cat COVID/MR2/part-* | head -n 5
./bin/hdfs dfs -cat COVID/MR2/part-* | tail -n 5


# Question 3
# Hadoop
nano Map3.py
nano Red3.py
docker cp Map3.py hadoop:/tmp/Map3.py
docker cp Red3.py hadoop:/tmp/Red3.py

time bash -c './bin/hadoop jar share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
  -mapper "python Map3.py" \
  -reducer "python Red3.py" \
  -input COVID/covid.csv \
  -output COVID/MR3 \
  -file /tmp/Map3.py \
  -file /tmp/Red3.py
'

./bin/hdfs dfs -cat COVID/MR3/part-* | head -n 5
./bin/hdfs dfs -cat COVID/MR3/part-* | tail -n 5


# Question 4
# Hadoop
nano Map4.py
nano Red4.py
docker cp Map4.py hadoop:/tmp/Map4.py
docker cp Red4.py hadoop:/tmp/Red4.py

time bash -c './bin/hadoop jar share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
  -mapper "python Map4.py" \
  -reducer "python Red4.py" \
  -input COVID/covid.csv \
  -output COVID/MR4 \
  -file /tmp/Map4.py \
  -file /tmp/Red4.py
'

./bin/hdfs dfs -cat COVID/MR4/part-* | head -n 5
./bin/hdfs dfs -cat COVID/MR4/part-* | tail -n 5

# Question 5
# Hadoop
nano Map5.py
nano Red5.py
docker cp Map5.py hadoop:/tmp/Map5.py
docker cp Red5.py hadoop:/tmp/Red5.py

time bash -c './bin/hadoop jar share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar \
  -mapper "python Map5.py" \
  -reducer "python Red5.py" \
  -input COVID/covid.csv \
  -output COVID/MR5 \
  -file /tmp/Map5.py \
  -file /tmp/Red5.py
'

./bin/hdfs dfs -cat COVID/MR5/part-* | head -n 5
./bin/hdfs dfs -cat COVID/MR5/part-* | tail -n 5

# For other benchmarking purposes
docker stats
