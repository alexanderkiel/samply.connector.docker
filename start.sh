#!/usr/bin/env bash

set -e

sed -i "s/{postgres-host}/${POSTGRES_HOST}/" /usr/local/tomcat/conf/Catalina/localhost/gba-connector.xml
sed -i "s/{postgres-port}/${POSTGRES_PORT:-5432}/" /usr/local/tomcat/conf/Catalina/localhost/gba-connector.xml
sed -i "s/{postgres-db}/${POSTGRES_DB:-samplyconnector}/" /usr/local/tomcat/conf/Catalina/localhost/gba-connector.xml
sed -i "s/{postgres-user}/${POSTGRES_USER:-samplyconnector}/" /usr/local/tomcat/conf/Catalina/localhost/gba-connector.xml
sed -i "s/{postgres-pass}/${POSTGRES_PASS}/" /usr/local/tomcat/conf/Catalina/localhost/gba-connector.xml
sed -i "s~{proxy-url}~${HTTP_PROXY:-}~" /root/.config/samply/samply_common_config.xml
sed -i "s/{proxy-user}/${PROXY_USER:-}/" /root/.config/samply/samply_common_config.xml
sed -i "s/{proxy-pass}/${PROXY_PASS:-}/" /root/.config/samply/samply_common_config.xml
sed -i "s#{store-url}#${STORE_URL}#" /root/.config/samply/samply_common_urls.xml
sed -i "s/{operator-first-name}/${OPERATOR_FIRST_NAME:-UNKNOWN}/" /root/.config/samply/samply_common_operator.xml
sed -i "s/{operator-last-name}/${OPERATOR_LAST_NAME:-UNKNOWN}/" /root/.config/samply/samply_common_operator.xml
sed -i "s/{operator-email}/${OPERATOR_EMAIL:-UNKNOWN}/" /root/.config/samply/samply_common_operator.xml
sed -i "s#{operator-phone}#${OPERATOR_PHONE:-UNKNOWN}#" /root/.config/samply/samply_common_operator.xml

if [ "${ENABLE_METRICS}" = "true" ]; then
  export CATALINA_OPTS="${CATALINA_OPTS} -javaagent:/samply/jmx_prometheus_javaagent-0.3.1.jar=9100:/samply/jmx-exporter.yml"
fi

# Replace start.sh with catalina.sh
exec /usr/local/tomcat/bin/catalina.sh run
