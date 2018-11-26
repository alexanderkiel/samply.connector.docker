FROM debian:latest AS build

ENV CONNECTOR_VERSION 3.0.7

RUN apt-get update && apt-get install -yq wget unzip

RUN mkdir -p /target && \
    cd /target && \
    wget -q https://maven.samply.de/nexus/service/local/repositories/oss-releases/content/de/samply/share-client/$CONNECTOR_VERSION/share-client-$CONNECTOR_VERSION.war && \
    unzip share-client-$CONNECTOR_VERSION.war && \
    rm share-client-$CONNECTOR_VERSION.war

FROM tomcat:8.5.32-jre8-alpine

COPY --from=build /target /usr/local/tomcat/webapps/gba-connector

ADD context.xml /usr/local/tomcat/conf/Catalina/localhost/gba-connector.xml
ADD server.xml /usr/local/tomcat/conf

ADD samply_common_urls.xml /root/.config/samply/
ADD samply_common_operator.xml /root/.config/samply/
ADD samply_common_config.xml /root/.config/samply/
ADD samply_bridgehead_info.xml /root/.config/samply/

# JMX Exporter
ENV JMX_EXPORTER_VERSION 0.3.1
COPY jmx-exporter.yml /samply/jmx-exporter.yml
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/$JMX_EXPORTER_VERSION/jmx_prometheus_javaagent-$JMX_EXPORTER_VERSION.jar /samply/

ADD start.sh /samply/
RUN chmod +x /samply/start.sh

CMD ["/samply/start.sh"]
