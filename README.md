# Docker Samply.Store Tomcat

A Samply.Store Docker image based on [tomcat:8.5.32-jre8-alpine][1]. The Samply.Store is configured alike that one from the windows installer. The Postgres database has to be supplied in another Docker container. The connection settings are given by environment variables which are documented below.

## Environment

* POSTGRES_HOST - the host name of the Postgres DB
* POSTGRES_PORT - the port of the Postgres DB, defaults to `5432`
* POSTGRES_DB - the database name, defaults to `samplyconnector`
* POSTGRES_USER - the database username, defaults to `samplyconnector`
* POSTGRES_PASS - the database password
* CATALINA_OPTS - JVM options for Tomcat like `-Xmx8g`
* ENABLE_METRICS - `true` to enable metrics (see below), defaults to `false`

## Usage

```sh
docker run -p 8080:8080 -e POSTGRES_HOST=<host> -e POSTGRES_PASS=<password> akiel/samply.connector:latest
```

Open the following URL in a Browser:

```
http://localhost:8080/gba-connector
```

You should see a welcome page.

## Metrics

The Docker image contains an [agent][3] which exports various metrics of the JVM like memory statistics in a text format on port `9100`. After enabling metrics by setting `ENABLE_METRICS` to `true` and exporting port `9100`, the following command shows the metrics:

```sh
curl http://localhost:9100/metrics
```

The metrics should be polled by a [Prometheus][2] instance.

[1]: <https://hub.docker.com/_/tomcat/>
[2]: <https://prometheus.io>
[3]: <https://github.com/prometheus/jmx_exporter>
