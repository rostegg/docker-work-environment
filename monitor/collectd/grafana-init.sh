#!/bin/bash

clear

ENDPOINT="localhost:3000"

function getJsonVal () { 
    python -c "import json,sys;sys.stdout.write(json.dumps(json.load(sys.stdin)$1))"; 
}

read -e -p $'\e[32mEnter grafana user ("admin" by default):\e[0m ' GRAFANA_USER
read -e -p $'\e[32mEnter grafana password ("admin" by default):\e[0m ' GRAFANA_PASSWORD
read -p "$(echo -e "\033[32m"Enter grafana organization "(${HOSTNAME}_sysm by default): ""\033[0m" )" ORG_NAME

if [ -z "$GRAFANA_USER" ]
then
    GRAFANA_USER="admin"
fi

if [ -z "$GRAFANA_PASSWORD" ]
then
    GRAFANA_PASSWORD="admin"
fi

if [ -z "$ORG_NAME" ]
then
    ORG_NAME="${HOSTNAME}_sysm"
fi

RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" -d '{"name":"'${ORG_NAME}'"}' http://${GRAFANA_USER}:${GRAFANA_PASSWORD}@${ENDPOINT}/api/orgs)
RESPONSE_MESSAGE=$(echo ${RESPONSE} | getJsonVal "['message']" | sed -e 's/"//g;')

if [ "$RESPONSE_MESSAGE" == "Organization created" ]
then
    ORG_ID=$(echo ${RESPONSE} | getJsonVal "['orgId']"|sed -e 's/"//g;')
    echo -e "Organization successfully created with \033[32mID:${ORG_ID}\033[0m"
else
    echo -e "\033[31mError occurred, while creating organization, message:\033[0m ${RESPONSE_MESSAGE}"
    exit 1
fi

curl -s -X POST http://${GRAFANA_USER}:${GRAFANA_PASSWORD}@${ENDPOINT}/api/user/using/${ORG_ID} > /dev/null
GET_KEY_RESPONE=$(curl -s -X POST -H "Content-Type: application/json" -d '{"name":"apiKey", "role": "Admin"}' http://${GRAFANA_USER}:${GRAFANA_PASSWORD}@${ENDPOINT}/api/auth/keys)

if [[ $GET_KEY_RESPONE == *"key"* ]]; then
    API_KEY=$(echo ${GET_KEY_RESPONE} | getJsonVal "['key']" | sed -e 's/"//g;')
    echo -e "API_KEY generated successfully: \033[32m${API_KEY}\033[0m"
else
    echo -e "\033[31mError occurred, while generating api key, message:\033[0m ${GET_KEY_RESPONE}"
    exit 1
fi

# create connection to influxdb data

INFLUXDB_ENDPOINT="http://influxdb:8086"


CREATE_DATASOURCE_RESPONSE=$(curl -s -X POST --insecure -H "Authorization: Bearer ${API_KEY}" -H "Content-Type: application/json" -d '{
  "name":"collectd-influx-datasource",
  "type":"influxdb",
  "url":"'${INFLUXDB_ENDPOINT}'",
  "access":"proxy",
  "database":"collectd",
  "user":"admin",
  "password":"admin",
  "basicAuth":false
}' http://${ENDPOINT}/api/datasources)

CREATE_DATASOURCE_RESPONSE_MESSAGE=$(echo ${CREATE_DATASOURCE_RESPONSE} | getJsonVal "['message']" | sed -e 's/"//g;')

if [ "$CREATE_DATASOURCE_RESPONSE_MESSAGE" != "Datasource added" ]
then
    echo -e "\033[31mError occurred, while connecting to datasource ${INFLUXDB_ENDPOINT}, message:\033[0m ${CREATE_DATASOURCE_RESPONSE}"
    exit 1
fi
echo -e "Successfully connected to InfluxDB datasource on \033[32m${INFLUXDB_ENDPOINT}\033[0m"

# create dashboards

CREATE_MEMORY_DASHBOARD_RESPONSE=$(curl -s -X POST --insecure -H "Authorization: Bearer ${API_KEY}" -H "Content-Type: application/json" -d '{
  "dashboard": {
    "annotations": {
      "list": [
        {
          "builtIn": 1,
          "datasource": "collectd-influx-datasource",
          "enable": true,
          "hide": true,
          "iconColor": "rgba(0, 211, 255, 1)",
          "name": "Memory Usage",
          "type": "dashboard"
        }
      ]
    },
    "editable": true,
    "gnetId": null,
    "graphTooltip": 0,
    "id": null,
    "links": [],
    "panels": [],
    "schemaVersion": 16,
    "style": "dark",
    "tags": [],
    "templating": { "list": [] },
    "time": { "from": "now-6h", "to": "now" },
    "timepicker": {
      "refresh_intervals": ["5s", "10s", "30s", "1m", "5m", "15m", "30m", "1h", "2h", "1d"],
      "time_options": ["5m", "15m", "1h", "6h", "12h", "24h", "2d", "7d", "30d"]
    },
    "timezone": "",
    "title": "Memory Usage",
    "uid": "",
    "version": 0,
    "hideControls": false
  },
  "overwrite": false,
  "message": ""
}' http://${ENDPOINT}/api/dashboards/db)

CREATE_MEMORY_DASHBOARD_RESPONSE_STATUS=$(echo ${CREATE_MEMORY_DASHBOARD_RESPONSE} | getJsonVal "['status']" | sed -e 's/"//g;')

if [ "$CREATE_MEMORY_DASHBOARD_RESPONSE_STATUS" != "success" ]
then
    echo -e "\033[31mError occurred, while creating dashboard \"Memory Usage\", message:\033[0m ${CREATE_MEMORY_DASHBOARD_RESPONSE}"
    exit 1
fi
echo -e "Successfully created \033[32mMemory Usage\033[0m dashboard"

# ----------------------------------------------------------------------------------------------------------------

CREATE_CPU_DASHBOARD_RESPONSE=$(curl -s -X POST --insecure -H "Authorization: Bearer ${API_KEY}" -H "Content-Type: application/json" -d '{
  "dashboard": {
    "annotations": {
      "list": [
        {
          "builtIn": 1,
          "datasource": "collectd-influx-datasource",
          "enable": true,
          "hide": true,
          "iconColor": "rgba(0, 211, 255, 1)",
          "name": "CPU Usage",
          "type": "dashboard"
        }
      ]
    },
    "editable": true,
    "gnetId": null,
    "graphTooltip": 0,
    "id": null,
    "links": [],
    "panels": [],
    "schemaVersion": 16,
    "style": "dark",
    "tags": [],
    "templating": { "list": [] },
    "time": { "from": "now-6h", "to": "now" },
    "timepicker": {
      "refresh_intervals": ["5s", "10s", "30s", "1m", "5m", "15m", "30m", "1h", "2h", "1d"],
      "time_options": ["5m", "15m", "1h", "6h", "12h", "24h", "2d", "7d", "30d"]
    },
    "timezone": "",
    "title": "CPU Usage",
    "uid": "",
    "version": 0,
    "hideControls": false
  },
  "overwrite": false,
  "message": ""
}' http://${ENDPOINT}/api/dashboards/db)

CREATE_CPU_DASHBOARD_RESPONSE_STATUS=$(echo ${CREATE_CPU_DASHBOARD_RESPONSE} | getJsonVal "['status']" | sed -e 's/"//g;')

if [ "$CREATE_CPU_DASHBOARD_RESPONSE_STATUS" != "success" ]
then
    echo -e "\033[31mError occurred, while creating dashboard \"CPU Usage\", message:\033[0m ${CREATE_CPU_DASHBOARD_RESPONSE}"
    exit 1
fi
echo -e "Successfully created \033[32mCPU Usage\033[0m dashboard"


