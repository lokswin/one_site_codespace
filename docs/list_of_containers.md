guacamole/guacd:1.5.5
guacamole/guacamole:1.5.5
postgres:17
vnc_firefox_remote_custom_image

services:
  devcontainer:
    image: mcr.microsoft.com/devcontainers/base:alpine-3.20

  guacamole-proxy:
    image: nginx:1.27.3-alpine

  firefox_vnc:
    image: work1t/firefox_vnc:1.0.5


  guacd:
    image: guacamole/guacd:1.5.5

  guacd-web:
    image: guacamole/guacamole:1.5.5

  guacamole_db:
    image: postgres:17

# SRE
# host machine metrics
  node_exporter:
    image: bitnami/node-exporter:1.8.2

# container-level metrics
  telegraf_collect:
    image: telegraf:1.32.3

# scrapes data from exporters
  prometheus:
    image: bitnami/prometheus:3.0.0

# monitoring visual
  grafana:
    image: grafana/grafana:11.3.1

