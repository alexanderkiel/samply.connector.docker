#!/usr/bin/env bash

set -e

sed -i "s/{postgres-host}/${POSTGRES_HOST}/" /usr/local/tomcat/conf/Catalina/localhost/gba-connector.xml
sed -i "s/{postgres-port}/${POSTGRES_PORT:-5432}/" /usr/local/tomcat/conf/Catalina/localhost/gba-connector.xml
sed -i "s/{postgres-db}/${POSTGRES_DB:-samplyconnector}/" /usr/local/tomcat/conf/Catalina/localhost/gba-connector.xml
sed -i "s/{postgres-user}/${POSTGRES_USER:-samplyconnector}/" /usr/local/tomcat/conf/Catalina/localhost/gba-connector.xml
sed -i "s/{postgres-pass}/${POSTGRES_PASS}/" /usr/local/tomcat/conf/Catalina/localhost/gba-connector.xml

if [ -n "${PROXY_URL}" ]; then
    echo "Setting up proxy ${PROXY_URL} ..."
    sed -i "s/<useProxy>false<\/useProxy>/<useProxy>true<\/useProxy>/" /usr/local/share/biobank.connector/mdrconfig.xml
    sed -i "s/<pathToProxy><\/pathToProxy>/<pathToProxy>\/samply<\/pathToProxy>/" /usr/local/share/biobank.connector/mdrconfig.xml
    sed -i "s~{proxy-url}~${PROXY_URL}~" /samply/conf/proxy.xml
    sed -i "s/{proxy-user}/${PROXY_USER:-}/" /samply/conf/proxy.xml
    sed -i "s/{proxy-pass}/${PROXY_PASS:-}/" /samply/conf/proxy.xml
fi

if [ "${ENABLE_METRICS}" = "true" ]; then
  export CATALINA_OPTS="${CATALINA_OPTS} -javaagent:/samply/jmx_prometheus_javaagent-0.3.1.jar=9100:/samply/jmx-exporter.yml"
fi

# Replace start.sh with catalina.sh
exec /usr/local/tomcat/bin/catalina.sh run
