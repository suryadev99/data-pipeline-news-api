#!/bin/sh

/etc/confluent/docker/run &
echo "Waiting for Kafka to be ready..."

# Wait for Kafka to be ready
START_TIMEOUT=600
start_timeout_exceeded=false
count=0
step=10

#while ! kafka-topics --list --bootstrap-server localhost:9092 &> /dev/null; do
#  echo "Waiting for Kafka to be ready..."
#  sleep $step
#  count=$((count + step))
#  if [ $count -ge $START_TIMEOUT ]; then
#      start_timeout_exceeded=true
#      break
#  fi
#done

#if [ "$start_timeout_exceeded" = true ]; then
#    echo "Kafka did not start within $START_TIMEOUT seconds."
#    exit 1
#fi

echo "Kafka is ready. Creating topic..."
## Create the topic
#kafka-topics --create --if-not-exists \
#    --zookeeper $KAFKA_ZOOKEEPER_CONNECT \
#    --partitions 1 \
#    --replication-factor 1 \
#    --topic $DEFAULT_TOPIC

# Create the topic

echo "Waiting for Kafka brokers to be ready..."

# Define the timeout and the number of expected brokers
EXPECTED_BROKERS=1
TIMEOUT=20

# Wait for Kafka brokers to be ready using cub
#cub kafka-ready -b kafka:9092 $EXPECTED_BROKERS $TIMEOUT
#
#if [ $? -ne 0 ]; then
#    echo "Kafka broker did not start within $TIMEOUT seconds."
#    exit 1
#fi

while ! echo "exit" | nc localhost 9092; do
  echo "Waiting for Kafka broker on port 9092..."
  sleep $step
  count=$((count + step))
  if [ $count -ge $START_TIMEOUT ]; then
      start_timeout_exceeded=true
      break
  fi
done

echo "Kafka brokers are ready. Creating topic..."
kafka-topics --create --if-not-exists \
    --bootstrap-server kafka:9092 \
    --partitions 1 \
    --replication-factor 1 \
    --topic $DEFAULT_TOPIC

echo "Topic $DEFAULT_TOPIC created."


# Keep the container running
sleep infinity
