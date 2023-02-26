#!/bin/bash

maxla=$(sed -n 's/^[[:space:]]*maxla:[[:space:]]*//p' $HOME/JopasMonitorScript/config/config.yaml)
maxmem=$(sed -n 's/^[[:space:]]*maxmem:[[:space:]]*//p' $HOME/JopasMonitorScript/config/config.yaml)

loadavg=$(cat /proc/loadavg | awk '{print $1}')
used_mem=$(free -m | awk '/^Mem:/ {print $3}')

la=$(echo "$loadavg > $maxla" | bc)
mem=$(echo "$used_mem > $maxmem" | bc)


if [ "$la" -eq 1 ] && [ "$mem" -eq 1  ]; then
    slackurl=$(sed -n 's/^[[:space:]]*slackurl:[[:space:]]*//p' $HOME/JopasMonitorScript/config/config.yaml)
    channel=$(sed -n 's/^[[:space:]]*channel:[[:space:]]*//p' $HOME/JopasMonitorScript/config/config.yaml)
    botname=$(sed -n 's/^[[:space:]]*botname:[[:space:]]*//p' $HOME/JopasMonitorScript/config/config.yaml)
    message="Load Avg and Memory usage are High! Info: la: $loadavg mem: $used_mem MB"
    json_payload="payload={
        \"channel\": \"$channel\",
        \"username\": \"$botname\",
        \"text\": \"$message\"
    }"

    #sending message
    curl --silent -X POST --data-urlencode "$json_payload" "$slackurl" > /dev/null
fi
