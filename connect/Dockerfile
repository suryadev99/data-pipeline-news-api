FROM  cnfldemos/cp-server-connect-datagen:0.6.4-7.6.0

RUN confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.11.2 \
&& confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:14.0.3 \
&& confluent-hub install --no-prompt debezium/debezium-connector-mongodb:2.3.0.Final \
&& confluent-hub install --no-prompt confluentinc/kafka-connect-s3:10.5.7

ENV CONNECT_KAFKA_HEAP_OPTS "-Xms512m -Xmx512m"
ENV CONNECT_CONFIG_STORAGE_TOPIC "connect-configs"
ENV CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR "1"
ENV CONNECT_OFFSET_STORAGE_TOPIC "connect-offsets"
ENV CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR "1"
ENV CONNECT_STATUS_STORAGE_TOPIC "connect-status"
ENV CONNECT_STATUS_STORAGE_REPLICATION_FACTOR "1"
ENV CONNECT_GROUP_ID "100"
ENV CONNECT_KEY_CONVERTER "io.confluent.connect.avro.AvroConverter"
ENV CONNECT_VALUE_CONVERTER "io.confluent.connect.avro.AvroConverter"
ENV CONNECT_INTERNAL_KEY_CONVERTER "org.apache.kafka.connect.json.JsonConverter"
ENV CONNECT_INTERNAL_VALUE_CONVERTER "org.apache.kafka.connect.json.JsonConverter"
ENV CONNECT_PLUGIN_PATH "/usr/share/java,/usr/share/confluent-hub-components"

ADD connectors /etc/kafka-connect/connectors

WORKDIR /etc/kafka-connect/connectors

USER root

RUN chmod +x ./register_connectors.sh

RUN ls -l /etc/kafka-connect/connectors

CMD ["./register_connectors.sh"]