FROM confluentinc/cp-kafka:7.6.0
#FROM debian:bullseye


ENV KAFKA_CONFLUENT_SUPPORT_METRICS_ENABLE "false"
ENV KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR "1"
ENV KAFKA_HEAP_OPTS "-Xmx512m -Xms512m"

ADD create_default_topic.sh .

#RUN apt-get update && apt-get install -y dos2unix && dos2unix create_default_topic.sh

#RUN  apt-get update \
#  && apt-get install --force-yes -y net-tools \
#  && chmod +x /create_default_topic.sh
#RUN apk update \
#  && apk add --no-cache net-tools \
#  && chmod +x ./create_default_topic.sh

COPY create_default_topic.sh /create_default_topic.sh

USER root

RUN yum update -y && \
    yum install -y net-tools

RUN chmod +x /create_default_topic.sh

#USER nobody

CMD ["/create_default_topic.sh"]

#CMD [ "./create_default_topic.sh" ]
